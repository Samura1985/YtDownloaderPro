using System.Diagnostics;
using System.Net.Http.Headers;
using System.Reflection;
using System.Security.Cryptography;
using System.Text.Json;

const string resourceName = "YtDownloaderPro.YtDownloaderPro.bat";
string tempDirectory = Path.Combine(Path.GetTempPath(), $"YtDownloaderPro-{Guid.NewGuid():N}");

try
{
    Version currentVersion = ReadCurrentVersion();
    ReleaseInfo? update = await CheckForUpdateAsync(currentVersion);

    if (update is not null)
    {
        Console.WriteLine($"Hi ha una versió nova de YtDownloaderPro ({update.Version}).");
        Console.Write("Vols actualitzar ara? (S/N): ");

        if (string.Equals(Console.ReadLine()?.Trim(), "S", StringComparison.OrdinalIgnoreCase))
        {
            string executablePath = Environment.ProcessPath
                ?? throw new InvalidOperationException("No s'ha pogut localitzar l'executable actual.");

            if (Path.GetFileNameWithoutExtension(executablePath).Equals("dotnet", StringComparison.OrdinalIgnoreCase))
                throw new InvalidOperationException("Executa l'EXE publicat per utilitzar l'actualització automàtica.");

            await InstallUpdateAsync(update, executablePath);
            return;
        }
    }

    await RunDownloaderAsync(tempDirectory, resourceName);
}
catch (Exception error)
{
    Console.Error.WriteLine($"No s'ha pogut iniciar YtDownloaderPro: {error.Message}");
    Console.WriteLine("Prem una tecla per tancar.");
    Console.ReadKey(intercept: true);
    Environment.ExitCode = 1;
}
finally
{
    try
    {
        if (Directory.Exists(tempDirectory))
            Directory.Delete(tempDirectory, recursive: true);
    }
    catch
    {
        // La carpeta temporal es podrà eliminar quan Windows alliberi els fitxers.
    }
}

static Version ReadCurrentVersion()
{
    string versionText = Assembly.GetExecutingAssembly()
        .GetCustomAttribute<AssemblyInformationalVersionAttribute>()?.InformationalVersion
        ?? "0.0.0";
    versionText = versionText.Split('+', 2)[0].TrimStart('v');
    return Version.TryParse(versionText, out Version? version) ? version : new Version(0, 0, 0);
}

static async Task<ReleaseInfo?> CheckForUpdateAsync(Version currentVersion)
{
    try
    {
        using var client = new HttpClient { Timeout = TimeSpan.FromSeconds(5) };
        client.DefaultRequestHeaders.UserAgent.Add(new ProductInfoHeaderValue("YtDownloaderPro", currentVersion.ToString()));
        client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/vnd.github+json"));

        using HttpResponseMessage response = await client.GetAsync("https://api.github.com/repos/Samura1985/YtDownloaderPro/releases/latest");
        response.EnsureSuccessStatusCode();

        await using Stream jsonStream = await response.Content.ReadAsStreamAsync();
        using JsonDocument document = await JsonDocument.ParseAsync(jsonStream);
        JsonElement root = document.RootElement;
        string tag = root.GetProperty("tag_name").GetString()?.TrimStart('v') ?? "";
        tag = tag.Split('+', 2)[0];

        if (!Version.TryParse(tag, out Version? latestVersion) || latestVersion <= currentVersion)
            return null;

        JsonElement assets = root.GetProperty("assets");
        foreach (JsonElement asset in assets.EnumerateArray())
        {
            if (asset.GetProperty("name").GetString() == "YtDownloaderPro.exe")
            {
                return new ReleaseInfo(
                    latestVersion,
                    asset.GetProperty("browser_download_url").GetString()!,
                    asset.TryGetProperty("digest", out JsonElement digestElement) ? digestElement.GetString() : null);
            }
        }
    }
    catch
    {
        // Si no hi ha connexió amb GitHub, l'aplicació continua obrint el descarregador.
    }

    return null;
}

static async Task InstallUpdateAsync(ReleaseInfo update, string executablePath)
{
    Directory.CreateDirectory(Path.GetTempPath());
    string updatePath = Path.Combine(Path.GetTempPath(), $"YtDownloaderPro-update-{Guid.NewGuid():N}.exe");

    using (var client = new HttpClient { Timeout = TimeSpan.FromMinutes(5) })
    {
        client.DefaultRequestHeaders.UserAgent.Add(new ProductInfoHeaderValue("YtDownloaderPro", update.Version.ToString()));
        await using Stream download = await client.GetStreamAsync(update.DownloadUrl);
        await using FileStream output = File.Create(updatePath);
        await download.CopyToAsync(output);
    }

    if (!string.IsNullOrWhiteSpace(update.Sha256))
    {
        string expectedHash = update.Sha256.StartsWith("sha256:", StringComparison.OrdinalIgnoreCase)
            ? update.Sha256[7..]
            : update.Sha256;
        await using FileStream file = File.OpenRead(updatePath);
        string actualHash = Convert.ToHexString(await SHA256.HashDataAsync(file)).ToLowerInvariant();
        if (!CryptographicOperations.FixedTimeEquals(
                Convert.FromHexString(expectedHash), Convert.FromHexString(actualHash)))
        {
            File.Delete(updatePath);
            throw new InvalidDataException("La verificació de l'executable descarregat ha fallat.");
        }
    }

    string scriptPath = Path.Combine(Path.GetTempPath(), $"YtDownloaderPro-update-{Guid.NewGuid():N}.ps1");
    string script = $$"""
        $ErrorActionPreference = 'Stop'
        $processId = {{Environment.ProcessId}}
        $target = '{{ToPowerShellLiteral(executablePath)}}'
        $download = '{{ToPowerShellLiteral(updatePath)}}'
        for ($i = 0; $i -lt 120; $i++) {
            if (-not (Get-Process -Id $processId -ErrorAction SilentlyContinue)) { break }
            Start-Sleep -Milliseconds 500
        }
        try {
            Copy-Item -LiteralPath $download -Destination $target -Force
            Start-Process -FilePath $target
        } catch {
            $fallback = Join-Path ([Environment]::GetFolderPath('UserProfile')) 'Downloads'
            [IO.Directory]::CreateDirectory($fallback) | Out-Null
            $fallbackExe = Join-Path $fallback 'YtDownloaderPro.exe'
            Copy-Item -LiteralPath $download -Destination $fallbackExe -Force
            Start-Process explorer.exe -ArgumentList $fallback
        }
        Remove-Item -LiteralPath $download -Force -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath $PSCommandPath -Force -ErrorAction SilentlyContinue
        """;

    await File.WriteAllTextAsync(scriptPath, script);
    Process.Start(new ProcessStartInfo
    {
        FileName = "powershell.exe",
        Arguments = $"-NoProfile -NonInteractive -ExecutionPolicy Bypass -File \"{scriptPath}\"",
        UseShellExecute = false,
        CreateNoWindow = true
    }) ?? throw new InvalidOperationException("No s'ha pogut iniciar l'actualitzador.");
}

static async Task RunDownloaderAsync(string tempDirectory, string resourceName)
{
    Directory.CreateDirectory(tempDirectory);
    string batchPath = Path.Combine(tempDirectory, "YtDownloaderPro.bat");

    await using (Stream? source = Assembly.GetExecutingAssembly().GetManifestResourceStream(resourceName))
    {
        if (source is null)
            throw new FileNotFoundException("No s'ha trobat el codi BAT dins de l'executable.");

        await using FileStream destination = File.Create(batchPath);
        await source.CopyToAsync(destination);
    }

    string commandProcessor = Environment.GetEnvironmentVariable("ComSpec") ?? "cmd.exe";
    using Process process = Process.Start(new ProcessStartInfo
    {
        FileName = commandProcessor,
        Arguments = $"/d /c call \"{batchPath}\"",
        UseShellExecute = false,
        CreateNoWindow = false,
        WorkingDirectory = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile)
    }) ?? throw new InvalidOperationException("No s'ha pogut iniciar el programa.");

    await process.WaitForExitAsync();
    Environment.ExitCode = process.ExitCode;
}

static string ToPowerShellLiteral(string value) => value.Replace("'", "''");

sealed record ReleaseInfo(Version Version, string DownloadUrl, string? Sha256);


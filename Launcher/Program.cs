using System.Diagnostics;
using System.Reflection;

const string resourceName = "YtDownloaderPro.YtDownloaderPro.bat";
string tempDirectory = Path.Combine(Path.GetTempPath(), $"YtDownloaderPro-{Guid.NewGuid():N}");

try
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
    return process.ExitCode;
}
catch (Exception error)
{
    Console.Error.WriteLine($"No s'ha pogut iniciar YtDownloaderPro: {error.Message}");
    Console.WriteLine("Prem una tecla per tancar.");
    Console.ReadKey(intercept: true);
    return 1;
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


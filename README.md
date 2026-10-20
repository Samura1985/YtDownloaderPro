# YtDownloaderPro

Eina de consola en català per descarregar vídeos o àudio amb yt-dlp a Windows.

## Versió 0.21

- Codi font: `YtDownloaderPro.bat`
- Baixa vídeo MP4, àudio MP3, llistes de reproducció i fragments.
- Comprova si yt-dlp, Deno i FFmpeg estan disponibles.
- Pot instal·lar yt-dlp i Deno amb WinGet.
- Per convertir a MP3 o combinar pistes de vídeo i àudio cal FFmpeg.

Les descàrregues s'ordenen a `Videos\YouTubeMP4` i `Music\YouTubeMP3` dins del perfil de Windows.

## Execució

Descarrega el fitxer `YtDownloaderPro.bat` des del repositori i obre'l. Per a les instal·lacions amb WinGet, cal tenir WinGet disponible. La primera vegada que s'instal·la una eina, pot caldre tancar i tornar a obrir el programa.

## Executable

Les versions publicades inclouen `YtDownloaderPro.exe`, un executable de Windows que inicia el mateix BAT. No cal instal·lar .NET per executar-lo. El fitxer font continua disponible per inspeccionar-lo o executar-lo directament.

## Actualitzacions

Cada versió es publica com una GitHub Release. Per preparar-ne una, actualitza el codi i el número de versió i crea una etiqueta `v*`; GitHub Actions genera l'executable i l'adjunta a la publicació. Els usuaris poden descarregar sempre la versió més recent des de la pàgina Releases.

## Avís

Utilitza l'eina només per a contingut que tens dret a descarregar i respecta les condicions del servei aplicable. yt-dlp, Deno, FFmpeg i WinGet són projectes o eines de tercers.


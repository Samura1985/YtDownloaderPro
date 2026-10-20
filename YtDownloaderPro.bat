::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFB5STR2NL1eeCbYJ5e31+/m7m1k5W/UxSJ3U5riBJ+9d40brFQ==
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJgZkk0
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFB5STR2NL1eMD7EZ5/vHzeuOukwpW/YPaoDn46CqL/cd5kTgcIQdxHUayIVeQh5Ae3I=
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
chcp 65001 >nul
title 🎬🎵 YouTube Downloader PRO 0.21
setlocal EnableExtensions EnableDelayedExpansion

:: ==========================================================
:: CONFIGURACIO
:: ==========================================================

set "DEST_VIDEO=%USERPROFILE%\Videos\YouTubeMP4"
set "DEST_MP3=%USERPROFILE%\Music\YouTubeMP3"

if not exist "%DEST_VIDEO%" mkdir "%DEST_VIDEO%"
if not exist "%DEST_MP3%" mkdir "%DEST_MP3%"

:: ==========================================================
:: COMPROVACIO AUTOMATICA A L'INICI
:: ==========================================================

call :auto_check
if errorlevel 1 exit

:: ==========================================================
:: MENU PRINCIPAL
:: ==========================================================

:menu
cls
echo ==========================================================
echo      🎬🎵 YOUTUBE DOWNLOADER PRO 0.21 By Música De Colors
echo ==========================================================
echo.
echo 🎬 VIDEO
echo ----------------------------------------------------------
echo  1. Video MP4 - Millor qualitat
echo  2. Video MP4 - 720p
echo  3. Playlist completa MP4
echo  4. Fragment de video
echo.
echo 🎵 AUDIO
echo ----------------------------------------------------------
echo  5. Video - MP3
echo  6. Playlist - MP3
echo  7. Fragment - MP3
echo.
echo 📦 GESTIO
echo ----------------------------------------------------------
echo  8. Gestio del sistema
echo.
echo  0. Sortir
echo ----------------------------------------------------------
echo.
set /p "OPT=Escull opcio: "

if "%OPT%"=="1" goto :best
if "%OPT%"=="2" goto :hd
if "%OPT%"=="3" goto :playlist
if "%OPT%"=="4" goto :fragment
if "%OPT%"=="5" goto :mp3
if "%OPT%"=="6" goto :plist_mp3
if "%OPT%"=="7" goto :fragment_mp3
if "%OPT%"=="8" goto :gestio
if "%OPT%"=="0" goto :exit
goto :menu

:: ==========================================================
:: COMPROVACIO INICIAL
:: ==========================================================

:auto_check
cls
echo 🔍 Comprovant yt-dlp...
echo.

where yt-dlp >nul 2>nul
if errorlevel 1 (
    echo ❌ yt-dlp NO instal.lat.
    echo.
    set /p "ANS=Vols instal.lar-lo ara? (S/N): "

    if /I "!ANS!"=="S" (
        call :install_ytdlp_auto
        exit /b 1
    ) else (
        echo.
        echo 👋 Fins aviat!
        timeout /t 2 >nul
        exit /b 1
    )
)

echo ✅ yt-dlp instal.lat.
where deno >nul 2>nul
if errorlevel 1 (
    echo ⚠ Deno NO instal·lat. Es necessita per a la resolucio JavaScript de YouTube.
    set /p "ANS=Vols instal·lar Deno ara? (S/N): "
    if /I "!ANS!"=="S" (
        call :install_deno
        exit /b 1
    )
) else (
    echo ✅ Deno detectat.
)
echo 🔄 Comprovant actualitzacions...
yt-dlp -U
echo.
timeout /t 2 >nul
exit /b 0
:: ==========================================================
:: INSTAL.LACIO AUTOMATICA INICIAL
:: ==========================================================

:install_ytdlp_auto
cls
echo ⬇ Instal.lant yt-dlp...
echo.

winget install -e --id yt-dlp.yt-dlp

echo.
echo ==========================================================
echo ✅ Instal.lacio finalitzada.
echo ⚠ Cal reiniciar l'aplicacio per continuar.
echo.
echo Prem una tecla per tancar...
pause >nul
exit /b
:: ==========================================================
:: GESTIO SUBMENU
:: ==========================================================

:gestio
cls
echo ==========================================================
echo                    📦 GESTIO
echo ==========================================================
echo.
echo  1. Comprovar instal.lacio
echo  2. Instal.lar yt-dlp
echo  3. Instal.lar ffmpeg
echo  4. Actualitzar yt-dlp
echo  5. Instal·lar Deno (motor JavaScript)
echo  0. Tornar
echo.
set /p "GOPT=Escull opcio: "

if "%GOPT%"=="1" goto :check
if "%GOPT%"=="2" goto :install_ytdlp
if "%GOPT%"=="3" goto :install_ffmpeg
if "%GOPT%"=="4" goto :update
if "%GOPT%"=="5" goto :install_deno_menu
if "%GOPT%"=="0" goto :menu
goto :gestio

:: ==========================================================
:: GESTIO FUNCIONS
:: ==========================================================

:check
cls
echo 🔍 Comprovant instal.lacio...
where yt-dlp >nul 2>nul && echo ✅ yt-dlp instal.lat || echo ❌ yt-dlp NO instal.lat
where ffmpeg >nul 2>nul && echo ✅ ffmpeg instal.lat || echo ⚠ ffmpeg NO instal.lat
where deno >nul 2>nul && echo ✅ Deno instal·lat || echo ⚠ Deno NO instal·lat
pause
goto :gestio

:install_ytdlp
cls
echo ⬇ Instal.lant yt-dlp...
winget install -e --id yt-dlp.yt-dlp
pause
goto :gestio

:install_ffmpeg
cls
echo ⬇ Instal.lant ffmpeg...
winget install -e --id Gyan.FFmpeg
pause
goto :gestio

:update
cls
echo 🔄 Actualitzant yt-dlp...
yt-dlp -U
pause
goto :gestio

:install_deno_menu
call :install_deno
if errorlevel 1 goto :gestio
goto :exit

:install_deno
cls
echo Instal·lant Deno (motor JavaScript)...
winget install -e --id DenoLand.Deno
if errorlevel 1 (
    echo.
    echo ❌ No s'ha pogut instal·lar Deno.
    pause
    exit /b 1
)
echo.
echo ✅ Ordre d'instal·lacio completada.
echo Tanca el programa i el terminal. Obre un terminal nou per actualitzar el PATH.
pause
exit /b 0

:require_deno
where deno >nul 2>nul
if errorlevel 1 (
    echo.
    echo ❌ Falta Deno. Instal·la'l des del menu Gestio i reinicia el programa.
    pause
    exit /b 1
)
exit /b 0

:: ==========================================================
:: VIDEO
:: ==========================================================

:best
cls
echo 🎬 Millor qualitat disponible
set /p "URL=Enganxa l'enllac: "
if not defined URL goto :menu

call :require_deno
if errorlevel 1 goto :menu

yt-dlp -f "bv*+ba/b" ^
--merge-output-format mp4 ^
-o "%DEST_VIDEO%\%%(title)s.%%(ext)s" ^
--js-runtimes deno ^
--remote-components ejs:npm ^
--progress -- "%URL%"
goto :done

:hd
cls
echo 🎬 Video 720p
set /p "URL=Enganxa l'enllac: "
if not defined URL goto :menu

call :require_deno
if errorlevel 1 goto :menu

yt-dlp -f "bv*[height<=720]+ba/b[height<=720]" ^
--merge-output-format mp4 ^
-o "%DEST_VIDEO%\%%(title)s.%%(ext)s" ^
--js-runtimes deno ^
--remote-components ejs:npm ^
--progress -- "%URL%"
goto :done

:playlist
cls
echo 📜 Playlist MP4
set /p "URL=Enganxa l'enllac: "
if not defined URL goto :menu

call :require_deno
if errorlevel 1 goto :menu

yt-dlp -f "bv*+ba/b" ^
--yes-playlist ^
--merge-output-format mp4 ^
--js-runtimes deno ^
--remote-components ejs:npm ^
-o "%DEST_VIDEO%\%%(playlist_title)s\%%(playlist_index)02d - %%(title)s.%%(ext)s" ^
--progress -- "%URL%"
goto :done

:fragment
cls
echo ✂ Fragment de video
set /p "URL=Enganxa l'enllac: "
if not defined URL goto :menu

set /p "SECCIO=Interval (ex 00:30-02:00): "
if not defined SECCIO goto :menu

call :require_deno
if errorlevel 1 goto :menu

yt-dlp -f "bv*+ba/b" ^
--download-sections "*%SECCIO%" ^
--force-keyframes-at-cuts ^
--merge-output-format mp4 ^
--js-runtimes deno ^
--remote-components ejs:npm ^
-o "%DEST_VIDEO%\%%(title)s - fragment.%%(ext)s" ^
--progress -- "%URL%"
goto :done

:: ==========================================================
:: AUDIO
:: ==========================================================

:mp3
cls
echo 🎵 Convertir video a MP3
set /p "URL=Enganxa l'enllac: "
if not defined URL goto :menu

call :require_deno
if errorlevel 1 goto :menu

yt-dlp -x --audio-format mp3 --audio-quality 0 ^
--js-runtimes deno ^
--remote-components ejs:npm ^
-o "%DEST_MP3%\%%(title)s.%%(ext)s" ^
--progress -- "%URL%"
goto :done

:plist_mp3
cls
echo 🎵 Playlist a MP3
set /p "URL=Enganxa l'enllac: "
if not defined URL goto :menu

call :require_deno
if errorlevel 1 goto :menu

yt-dlp -x --audio-format mp3 --audio-quality 0 ^
--yes-playlist ^
--js-runtimes deno ^
--remote-components ejs:npm ^
-o "%DEST_MP3%\%%(playlist_title)s\%%(playlist_index)02d - %%(title)s.%%(ext)s" ^
--progress -- "%URL%"
goto :done

:fragment_mp3
cls
echo 🎵 Fragment de audio (MP3)
set /p "URL=Enganxa l'enllac: "
if not defined URL goto :menu

set /p "SECCIO=Interval (ex 00:30-02:00): "
if not defined SECCIO goto :menu

set "SECN=%SECCIO::=.%"
set "SECN=%SECN: =_%"

call :require_deno
if errorlevel 1 goto :menu

yt-dlp ^
--download-sections "*%SECCIO%" ^
--force-keyframes-at-cuts ^
-x --audio-format mp3 --audio-quality 0 ^
--js-runtimes deno ^
--remote-components ejs:npm ^
-o "%DEST_MP3%\%%(title)s - clip-%SECN%.%%(ext)s" ^
--progress -- "%URL%"
goto :done

:: ==========================================================

:done
echo.
echo ✅ Fet!
echo.
pause
goto :menu

:exit
echo 👋 Fins aviat!
timeout /t 2 >nul
exit /b

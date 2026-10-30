@echo off
rem Runs Khylo in this window without installing anything. Close the window to stop it.
rem Your library and settings are kept in %LOCALAPPDATA%\Khylo.
set "HERE=%~dp0Khylo"
set "DATA=%LOCALAPPDATA%\Khylo"
if not exist "%DATA%" mkdir "%DATA%"
echo Starting Khylo. When it says it is listening, open http://localhost:8096
"%HERE%\khylo.exe" --webdir "%HERE%\web" --ffmpeg "%HERE%\ffmpeg\ffmpeg.exe" --datadir "%DATA%\data" --configdir "%DATA%\config" --cachedir "%DATA%\cache" --logdir "%DATA%\log"
pause

@echo off
rem Runs one of Kodi's x64 Windows build steps (download-dependencies, download-msys2,
rem make-mingwlibs, BuildSetup ...) with its arguments, e.g.  kodi-step.bat make-mingwlibs
rem Kodi's scripts call each other by bare name, so cmd must search the current folder.
set NoDefaultCurrentDirectoryInExePath=
cd /d C:\Kodi-AC4\kodi\tools\buildsteps\windows\x64
call %* < nul

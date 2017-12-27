@echo off

if exist C:\cygwin set CYGDIR=C:\cygwin
if exist C:\cygwin64 set CYGDIR=C:\cygwin64
if "%CYGDIR%"=="" goto fail

cd /D %HOME%
%CYGDIR%\bin\run.exe -p /usr/bin -p /bin xterm -display :0 -e zsh -l

goto end

:fail
echo "Can't find Cygwin"
pause

:end

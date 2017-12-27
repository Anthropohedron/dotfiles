@echo off

if exist C:\cygwin set CYGDIR=C:\cygwin
if exist C:\cygwin64 set CYGDIR=C:\cygwin64
if "%CYGDIR%"=="" goto fail

%CYGDIR%\bin\run.exe -p /usr/bin -p /bin Xwin -multiwindow -clipboard -emulate3buttons -nounixkill -nowinkill

goto end

:fail
echo "Can't find Cygwin"
pause

:end

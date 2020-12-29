@echo off

if exist C:\cygwin set CYGDIR=C:\cygwin
if exist C:\cygwin64 set CYGDIR=C:\cygwin64
if "%CYGDIR%"=="" goto fail

%CYGDIR%\bin\sh.exe "PATH=/bin:/usr/bin /bin/startxwin -multiwindow -clipboard -emulate3buttons -nounixkill -nowinkill"

goto end

:fail
echo "Can't find Cygwin"
pause

:end

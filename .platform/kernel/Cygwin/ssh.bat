@echo off

if exist C:\cygwin set CYGDIR=C:\cygwin
if exist C:\cygwin64 set CYGDIR=C:\cygwin64
if "%CYGDIR%"=="" goto fail

cd /d %USERPROFILE%
%CYGDIR%\bin\env.exe "PATH=/bin:/usr/bin" "DISPLAY=:0" /bin/sh -c "export HOME=`pwd`; eval `bin/agent -s`; ssh %1"

goto end

:fail
echo "Can't find Cygwin"
pause

:end

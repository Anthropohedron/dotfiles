echo off
start /min /wait C:\Windows\System32\rundll32.exe user32.dll, LockWorkStation
start /min C:\Windows\System32\scrnsave.scr -s

# To automatically load, run the following in PowerShell once:
# Set-Content $PROFILE ". $HOME\.platform\kernel\Cygwin\pwshrc.ps1"

function Set-Title([string]$title) { $host.ui.RawUI.WindowTitle = $title }
Set-Alias -Name:"title" -Value:"Set-Title" -Description:"" -Option:"None"

if ($host.Name -eq 'ConsoleHost')
{
				Import-Module -ErrorAction SilentlyContinue PSReadLine
}

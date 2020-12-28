# vim: ts=4 sw=4 noexpandtab
# To automatically load, run the following in PowerShell once:
# Set-Content $PROFILE ". $HOME\.platform\kernel\Cygwin\pwshrc.ps1"

function Set-Title([string]$title) { $host.ui.RawUI.WindowTitle = $title }
Set-Alias -Name:"title" -Value:"Set-Title" -Description:"" -Option:"None"

if ($host.Name -eq 'ConsoleHost')
{
	if (-not (Get-Module -ListAvailable -Name PSReadLine))
	{
		Install-Module PSReadLine -Scope CurrentUser -Force
	}
	Import-Module PSReadLine
	Set-PSReadLineOption -EditMode Emacs
	Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
	Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

# vim: ts=4 sw=4 noexpandtab
# This file should live in $PROFILE, which is typically
# $HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

function Set-Title([string]$title) { $host.ui.RawUI.WindowTitle = $title }
Set-Alias -Name:"title" -Value:"Set-Title" -Description:"" -Option:"None"
Set-Alias -Name:"which" -Value:"Get-Command" -Description:"" -Option:"None"

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

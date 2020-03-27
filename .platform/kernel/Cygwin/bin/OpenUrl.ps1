#!/usr/bin/env pwsh

$clip = Get-Clipboard -Format Text -Raw
$url = [uri]$clip

if ($url.AbsoluteUri -ne $null) {
	Start-Process "$clip"
} else {
	Write-Warning "Bad Url '$clip'"
	pause
	exit 1
}

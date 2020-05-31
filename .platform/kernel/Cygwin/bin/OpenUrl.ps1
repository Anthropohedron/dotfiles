#!/usr/bin/env pwsh

$clip = Get-Clipboard -Format Text -Raw
$url = [uri]$clip

if (($url.AbsoluteUri -eq $null) -and -not $clip.Contains("://")) {
	$url = [uri]"https://$clip"
}

if ($url.AbsoluteUri -ne $null) {
	Start-Process $url
} else {
	Write-Warning "Bad Url '$clip'"
	pause
	exit 1
}

#!/usr/bin/env pwsh

$clip = Get-Clipboard
$url = [uri]$clip

if ($url.AbsolutePath -ne $null) {
	Start-Process "$clip"
} else {
	exit 1
}

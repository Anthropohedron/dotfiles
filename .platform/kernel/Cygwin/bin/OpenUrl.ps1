#!/usr/bin/env pwsh

function UrlFromString($maybeUrlString) {
	$maybeUrl = [uri]$maybeUrlString

	if (($maybeUrl.AbsoluteUri -eq $null) -and `
	     -not $maybeUrlString.Contains("://")) {
		$maybeUrl = [uri]"https://$maybeUrlString"
	}
	if ($maybeUrl.AbsoluteUri -ne $null) {
		return $maybeUrl
	} else {
		Write-Warning "Bad Url '$maybeUrlString"
		return $null
	}
}

function Die() {
	pause
	exit 1
}

$clip = Get-Clipboard -Format Text -Raw
$url = UrlFromString($clip)

if ($url -eq $null) {
	Write-Warning "Bad Url '$clip'"
	$cygbin = "/cygwin/bin"
	if (-not (Test-Path $cygbin -PathType Container)) {
		$cygbin = "/cygwin64/bin"
		if (-not (Test-Path $cygbin -PathType Container)) {
			Die
		}
	}
	$xsel = "$cygbin/xsel.exe"
	$sh = "$cygbin/sh.exe"
	if ((Test-Path $xsel -Type Leaf) -and (Test-Path $sh -Type Leaf)) {
		$clip = & $sh "-c" "PATH=/bin DISPLAY=:0 xsel 2>/dev/null"
		$url = UrlFromString($clip)
	}
}


if ($url -eq $null) {
	Die
}

Start-Process $url

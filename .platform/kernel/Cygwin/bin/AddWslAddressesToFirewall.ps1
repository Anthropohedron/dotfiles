#!/usr/bin/env pwsh


param (
    [ValidateScript({
		$FORMAT_ERROR = "IPv4 range must be of the form <address>/<mask> with a valid and non-zero mask, e.g. 192.168.1.1/255.255.255.0"
        if ($_ -eq $null) {
            throw $FORMAT_ERROR
        }
		if ($_.Length -eq 0) {
            throw $FORMAT_ERROR
		}
		$OCTET_REGEX = "((?:[12][0-9][0-9])|(?:[1-9][0-9]?)|0)"
		[regex]$FORMAT_REGEX = "^$OCTET_REGEX\.$OCTET_REGEX\.$OCTET_REGEX\.$OCTET_REGEX/$OCTET_REGEX\.$OCTET_REGEX\.$OCTET_REGEX\.$OCTET_REGEX$"
		$_ | foreach {
			$match = $FORMAT_REGEX.Match($_)
			if (-not $match.Success) {
				throw $FORMAT_ERROR + "`nIncorrect format $_"
			}
			$binoctets = $match.Groups[5..8] | foreach {
				[System.Convert]::ToString($_.Value, 2).PadLeft(8, '0')
			}
			$binary = $binoctets -join ""
			$firstOne = $binary.IndexOf('1')
			if ($firstOne -lt 0) {
				throw $FORMAT_ERROR + "`nBad mask $binary in $_"
			}
			$lastOne = $binary.LastIndexOf('1')
			$firstZero = $binary.IndexOf('0')
			if ($firstZero -lt $lastOne) {
				throw $FORMAT_ERROR + "`nBad mask $binary in $_"
			}
		}
        return $true
    })]
    [Parameter(Position=0,Mandatory)]
    [string[]]$IPv4Range
)

if (-not (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
	throw "Must run as administrator"
}

$rules = Get-NetFirewallRule -DisplayGroup WSL -Direction Inbound
$rules | foreach {
	$filter = $_ | Get-NetFirewallAddressFilter
	$addresses = $filter | select -ExpandProperty RemoteIp
	$addresses += $IPv4Range
	Set-NetFirewallAddressFilter -InputObject $filter -RemoteAddress $addresses -Confirm
}

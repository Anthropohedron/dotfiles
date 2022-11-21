#!/usr/bin/env pwsh

param (
	[Parameter(Mandatory,Position=0)]
	[string]
	$SelectedProfile,
	[System.IO.FileInfo]
	[ValidateScript({ $_.Exists })]
	$Profiles = (Join-Path (Join-Path $HOME ".local") "audioprofiles.ini")
)

function Ensure-Module {
	param (
		[Parameter(Position=0)]
		[string]$moduleName
	)
	if ((Get-Module $moduleName) -eq $null)
	{
		if ((Get-Module -ListAvailable -Name $moduleName) -eq $null)
		{
			Install-Module $moduleName -Scope CurrentUser -Force
		}
		Import-Module $moduleName
	}
}

Ensure-Module AudioDeviceCmdlets
Ensure-Module PsIni

$profileConfig = (Get-IniContent $Profiles)[$SelectedProfile]

if ($profileConfig -eq $null)
{
	throw "Cannot find profile: '$SelectedProfile'"
}

function Get-NamedAudioDevices {
	param (
		[string]$Search,
		[switch]$Like
	)
	if ($Like)
	{
		return (Get-AudioDevice -List | where Name -CLike $Search)
	}
	else
	{
		return (Get-AudioDevice -List | where Name -CEQ $Search)
	}
}

if (-not [string]::IsNullOrWhitespace($profileConfig.Both))
{
	if ($profileConfig.Search -eq "Like")
	{
		$devices = Get-NamedAudioDevices $profileConfig.Both -Like
	}
	else
	{
		$devices = Get-NamedAudioDevices $profileConfig.Both
	}
}
elseif (-not ([string]::IsNullOrWhitespace($profileConfig.Input) -or `
	[string]::IsNullOrWhitespace($profileConfig.Output)))
{
	if ($profileConfig.Search -eq "Like")
	{
		$inputDevice = Get-NamedAudioDevices $profileConfig.Input -Like |`
			where Type -CEQ "Recording"
		$outputDevice = Get-NamedAudioDevices $profileConfig.Output -Like |`
			where Type -CEQ "Playback"
	}
	else
	{
		$inputDevice = Get-NamedAudioDevices $profileConfig.Input |`
			where Type -CEQ "Recording"
		$outputDevice = Get-NamedAudioDevices $profileConfig.Output |`
			where Type -CEQ "Playback"
	}
	$devices = $inputDevice,$outputDevice
}
else
{
	throw "Invalid profile: '$SelectedProfile'"
}

$inputId = $devices | where Type -CEQ "Recording" | select -ExpandProperty ID
$outputId = $devices | where Type -CEQ "Playback" | select -ExpandProperty ID

if ($inputId -isnot [string])
{
	throw "Cannot find singular microphone in '$devices'"
}
if ($outputId -isnot [string])
{
	throw "Cannot find singular speaker in '$devices'"
}

Set-AudioDevice -ID $inputId | Out-Null
Set-AudioDevice -ID $outputId -DefaultOnly | Out-Null


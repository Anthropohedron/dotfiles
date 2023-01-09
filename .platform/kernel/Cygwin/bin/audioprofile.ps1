#!/usr/bin/env pwsh

param (
	[Parameter(Position=0, ParameterSetName = "UseProfile")]
	[string]
	$SelectedProfile = "",
	[Parameter(Mandatory, ParameterSetName = "CreateProfile")]
	[string]
	$NewProfile,
	[Parameter(ParameterSetName = "CreateProfile")]
	[switch]
	$OverwriteProfile,
	[Parameter(ParameterSetName = "UseProfile")]
	[Parameter(ParameterSetName = "CreateProfile")]
	[System.IO.FileInfo]
	[ValidateScript({ $PSCmdlet.ParameterSetName -eq "CreateProfile" -or $_.Exists })]
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

function Get-AvailableAudioDevices
{
	$recording = [System.Collections.Generic.List[System.String]]::new()
	$playback = [System.Collections.Generic.List[System.String]]::new()
	Get-AudioDevice -List | foreach {
		if ($_.Type -eq "Playback")
		{
			$playback.Add($_.Name)
		}
		elseif ($_.Type -eq "Recording")
		{
			$recording.Add($_.Name)
		}
	}
	return $recording,$playback
}

function Select-Option {
	param (
		[Parameter(Mandatory,Position=0)]
		[string[]]$options,
		[Parameter(Mandatory,Position=1)]
		[string]$choicePrompt
	)
	[System.Management.Automation.Host.ChoiceDescription[]]$choices = `
		$options | % {$index=0}{
			$index++
			"&$index $_"
		}
	$choice = $Host.UI.PromptForChoice("$choicePrompt", $null, $choices, -1)
	$options[$choice]
}

function Get-NamedAudioDevices
{
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

function Use-AudioProfile
{
	$allProfiles = Get-IniContent $Profiles
	if (-not $allProfiles.Contains($SelectedProfile))
	{
		Write-Output "Available profiles:"
		$allProfiles.Keys | select { "`t$_" } |`
			Format-Table -HideTableHeaders
		return
	}

	$profileConfig = $allProfiles[$SelectedProfile]

	if ($profileConfig -eq $null)
	{
		throw "Cannot find profile: '$SelectedProfile'"
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
}

function Create-AudioProfile
{
	if ($Profiles.Exists)
	{
		$allProfiles = Get-IniContent $Profiles
	}
	else
	{
		$allProfiles = [System.Collections.Specialized.OrderedDictionary]::new()
	}
	if (-not $OverwriteProfile -and $allProfiles.Contains($NewProfile))
	{
		throw "Profile '$NewProfile' already exists`nUse the '-OverwriteProfile' flag to overwrite it"
	}
	$inputNames,$outputNames = Get-AvailableAudioDevices
	$profile = [System.Collections.Specialized.OrderedDictionary]::new()
	$profile["Input"] = Select-Option $inputNames "Select audio input device:"
	$profile["Output"] = Select-Option $outputNames "Select audio output device:"
	$allProfiles[$NewProfile] = $profile
	Out-IniFile $Profiles -Force -InputObject $allProfiles
	Write-Output "Created profile '$NewProfile':"
	Format-Table -HideTableHeaders -InputObject $profile
}

switch ($PSCmdlet.ParameterSetName)
{
	"UseProfile" { Use-AudioProfile }
	"CreateProfile" { Create-AudioProfile }
}


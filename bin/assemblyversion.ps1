#!/usr/bin/env powershell
param (
	[string]$file
)
$assembly = [System.Reflection.Assembly]::ReflectionOnlyLoadFrom($file)
$version = $assembly.GetName().Version.ToString()

echo "$file version is $version"

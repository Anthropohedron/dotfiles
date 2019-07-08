#!/usr/bin/env powershell
param (
	[string]$file,
	[switch]$WithDependencies
)
$assembly = [System.Reflection.Assembly]::ReflectionOnlyLoadFrom($file)
$version = $assembly.GetName().Version.ToString()

echo "$file version is $version"

if ($WithDependencies) {
	$assembly.GetReferencedAssemblies() | Format-Table -AutoSize
}

#!/usr/bin/env powershell
param (
	[string]$file,
	[switch]$WithDependencies
)
try {
	$assembly = [System.Reflection.Assembly]::ReflectionOnlyLoadFrom($file)
}
catch [System.Management.Automation.MethodInvocationException] {
	$assembly = [System.Reflection.Assembly]::LoadFrom($file)
}
$version = $assembly.GetName().Version.ToString()

echo "$file version is $version"

if ($WithDependencies) {
	$assembly.GetReferencedAssemblies() | Format-Table -AutoSize
}

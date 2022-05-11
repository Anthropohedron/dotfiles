#!/usr/bin/env pwsh

# Copied from:
#
#   https://social.msdn.microsoft.com/Forums/sqlserver/en-US/57811d43-a2b9-4179-a97b-a9936ddb188e/how-to-retrieve-a-password-saved-by-sql-server?forum=sqltools#94c30f24-e95a-445d-8bc1-ea95e0d3502a
#
# Instructions:
#
#   Go to Microsoft SQL Server Management Studio, right click on any of the
#   server that you have already connected, click "Register" and select the
#   server, password should be populated already if you have this server
#   saved password. Then click "Save" Now go to Main Menu -> View ->
#   Registered Servers, you will see the server you just registered, now
#   right click on it and Click Tasks -> Export, specify a file name and
#   uncheck "Do not include user name and passwords in export file", the
#   exported server will have an extension like: ".regsrvr" now by using
#   the script you will see the connection string decrypted.

param(
    [Parameter(Mandatory=$true)]
    [string] $FileName
)

Add-Type -AssemblyName System.Security
$ErrorActionPreference = 'Stop'

function Unprotect-String([string] $base64String)
{
    return [System.Text.Encoding]::Unicode.GetString([System.Security.Cryptography.ProtectedData]::Unprotect([System.Convert]::FromBase64String($base64String), $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser))
}

$document = [xml] (Get-Content $FileName)
$nsm = New-Object 'System.Xml.XmlNamespaceManager' ($document.NameTable)
$nsm.AddNamespace('rs', 'http://schemas.microsoft.com/sqlserver/RegisteredServers/2007/08')

$attr = $document.DocumentElement.GetAttribute('plainText')
if ($attr -ne '' -and $Operation -ieq 'Decrypt')
{    
    throw "The file does not contain encrypted passwords."	
}

$servers = $document.SelectNodes("//rs:RegisteredServer", $nsm)

foreach ($server in $servers)
{
    $connString = $server.ConnectionStringWithEncryptedPassword.InnerText
	echo ""
	echo "Encrypted Connection String:"
	echo $connString
	echo ""
    if ($connString -inotmatch 'password="?([^";]+)"?') {continue}
    $password = $Matches[1]
	
	$password = Unprotect-String $password  
	echo ""
	echo "Decrypted Connection String:"
    $connString = $connString -ireplace 'password="?([^";]+)"?', "password=`"$password`""
	echo $connString
	echo ""
}

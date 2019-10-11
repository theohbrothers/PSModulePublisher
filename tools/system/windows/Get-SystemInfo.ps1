[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

hostname
whoami
systeminfo
Get-PSDrive
$PSVersionTable
Get-Location

[CmdletBinding()]
param()

# Issue with PowerShell 5.0 not having NuGet.exe despite installing the package provider. The binary is necessary for Publish-Module to work
"PowerShell version: $($PSVersionTable.PSVersion.ToString())" | Write-Host
"Installing NuGet binary if needed" | Write-Host
if ($PSVersionTable.PSVersion -lt [version]'5.1') {
    "Checking for NuGet binary"
    $nugetBinPath = "$env:LOCALAPPDATA\Microsoft\Windows\PowerShell\PowerShellGet\NuGet.exe"
    Get-ChildItem -Path "$env:LOCALAPPDATA\Microsoft\Windows\PowerShell" -Recurse
    if (!(Test-Path -Path $nugetBinPath -PathType Leaf)) {
        "Downloading NuGet binary" | Write-Host
        New-Item -Path (Split-Path -Path $nugetBinPath -Parent) -ItemType Directory -Force
        Invoke-WebRequest -Uri https://dist.nuget.org/win-x86-commandline/latest/nuget.exe -OutFile $nugetBinPath
    }
    Get-ChildItem -Path (Split-Path -Path $nugetBinPath -Parent)
    & $nugetBinPath
}else {
    "Installation is not needed." | Write-Host
}
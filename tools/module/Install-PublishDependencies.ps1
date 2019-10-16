[CmdletBinding()]
param()

"PowerShell version: $($PSVersionTable.PSVersion.ToString())" | Write-Host

# Install the NuGet binary for PowerShell versions below 5.1 for Publish-Module to work correctly
"Verifying if NuGet should be installed" | Write-Host
if ($PSVersionTable.PSVersion -lt [version]'5.1') {
    $nugetBinPath = "$env:LOCALAPPDATA\Microsoft\Windows\PowerShell\PowerShellGet\nuget.exe"
    "Checking for nuget.exe" | Write-Host
    if (!(Test-Path -Path $nugetBinPath -PathType Leaf)) {
        New-Item -Path (Split-Path -Path $nugetBinPath -Parent) -ItemType Directory -Force > $null
        "Downloading nuget.exe" | Write-Host
        Invoke-WebRequest -Uri 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe' -OutFile $nugetBinPath
    }
    Get-ChildItem -Path (Split-Path -Path $nugetBinPath -Parent)
    & $nugetBinPath
}else {
    "Installation is not required." | Write-Host
}

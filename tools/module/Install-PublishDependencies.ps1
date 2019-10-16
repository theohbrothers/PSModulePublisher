[CmdletBinding()]
param()

"PowerShell version: $($PSVersionTable.PSVersion.ToString())" | Write-Host

# Install the NuGet binary For PowerShell versions below 5.1 for Publish-Module to work correctly
"Installing NuGet.exe" | Write-Host
if ($PSVersionTable.PSVersion -lt [version]'5.1') {
    $nugetBinPath = "$env:LOCALAPPDATA\Microsoft\Windows\PowerShell\PowerShellGet\NuGet.exe"
    "Checking for NuGet.exe" | Write-Host
    if (!(Test-Path -Path $nugetBinPath -PathType Leaf)) {
        New-Item -Path (Split-Path -Path $nugetBinPath -Parent) -ItemType Directory -Force > $null
        "Downloading NuGet.exe" | Write-Host
        Invoke-WebRequest -Uri 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe' -OutFile $nugetBinPath
    }
    Get-ChildItem -Path (Split-Path -Path $nugetBinPath -Parent)
    & $nugetBinPath
}else {
    "Installation is not needed." | Write-Host
}

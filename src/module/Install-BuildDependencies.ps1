[CmdletBinding()]
param()

try {
    # Get info on PSGallery repository
    "Retrieving info on PSGallery repository" | Write-Host
    Get-PSRepository -Name 'PSGallery' | Format-List -Property * | Out-String | Write-Verbose

    # Install NuGet package provider
    "Checking NuGet version" | Write-Host
    $nugetRequiredVersion = [version]'2.8.5.201'
    $nuget = Get-PackageProvider 'NuGet' -ListAvailable
    if (!$nuget -or !($nuget.Version -gt $nugetRequiredVersion)) {
        "Installing NuGet" | Write-Host
        Install-PackageProvider -Name NuGet -MinimumVersion $nugetRequiredVersion -Force
    }

    # Install PowerShellGet module of the specified version
    "Installing PowerShellGet" | Write-Host
    $powershellGetRequiredVersion = '2.1.2'
    $powershellGetInstalledVersions = (Get-Module 'PowerShellGet' -ListAvailable).Version | % { $_.ToString() }
    if ($powershellGetRequiredVersion -notin $powershellGetInstalledVersions) {
        Install-Module -Name 'PowershellGet' -Repository 'PSGallery' -RequiredVersion $powershellGetRequiredVersion -Scope CurrentUser -Force
    }

    # Import and get info on PowerShellGet
    "Importing PowerShellGet" | Write-Host
    Import-Module -Name 'PowerShellGet' -RequiredVersion $powershellGetRequiredVersion -Force
    Get-Module -Name 'PowerShellGet' -ListAvailable | Out-String | Write-Verbose

}catch {
    throw
}
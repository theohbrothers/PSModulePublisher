[CmdletBinding()]
param()

try {
    # Get info on PSGallery repository
    "Retrieving info on PSGallery repository" | Write-Host
    Get-PSRepository -Name 'PSGallery' | Format-List -Property * | Out-String | Write-Verbose

    # Install NuGet package provider
    "Checking NuGet version" | Write-Host
    $nugetMinimumVersion = [version]'2.8.5.201'
    $nuget = Get-PackageProvider 'NuGet' -ListAvailable -ErrorAction SilentlyContinue
    if (!$nuget -or !($nuget.Version -gt $nugetMinimumVersion)) {
        "Installing NuGet" | Write-Host
        Install-PackageProvider -Name NuGet -MinimumVersion $nugetMinimumVersion -Force > $null    # Suppress the output as older versions of the module 'PackageManagement' to which this cmdlet belongs returns a package provider object on successful installations
    }

    # Install PowerShellGet module of the specified version
    "Checking PowerShellGet version" | Write-Host
    $powershellgetRequiredVersion = [version]'2.1.2'
    $powershellget = Get-Module 'PowerShellGet' -ListAvailable
    if (!($powershellget.Version -eq $powershellgetRequiredVersion)) {
        "Installing PowerShellGet" | Write-Host
        Install-Module -Name 'PowershellGet' -Repository 'PSGallery' -RequiredVersion $powershellgetRequiredVersion -Scope CurrentUser -Force
    }

    # Import and get info on PowerShellGet
    "Importing PowerShellGet" | Write-Host
    Import-Module -Name 'PowerShellGet' -RequiredVersion $powershellgetRequiredVersion -Force
    Get-Module -Name 'PowerShellGet' -ListAvailable | Out-String | Write-Verbose

}catch {
    throw
}

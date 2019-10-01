[CmdletBinding()]
param()

try {
    # Get info on PSGallery repository
    "Retrieving info on PSGallery repository" | Write-Host
    Get-PSRepository -Name 'PSGallery' | Format-List -Property * | Out-String | Write-Verbose

    # Install PowershellGet module of the specified version
    "Installing PowerShellGet" | Write-Host
    $powershellGetRequiredVersion = '2.1.2'
    $powershellGetInstalledVersions = (Get-Module PowerShellGet -ListAvailable).Version | % { $_.ToString() }
    if ($powershellGetRequiredVersion -notin $powershellGetInstalledVersions) {
        Install-Module -Name PowershellGet -Repository 'PSGallery' -RequiredVersion $powershellGetRequiredVersion -Scope CurrentUser -Force
    }

    # Import and get info on PowershellGet
    "Importing PowerShellGet" | Write-Host
    Import-Module -Name PowerShellGet -RequiredVersion $powershellGetRequiredVersion -Force
    Get-Module -Name PowerShellGet -ListAvailable | Out-String | Write-Verbose

}catch {
    throw
}
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$DefinitionPath
    ,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Path
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

try {
    if ($env:MODULE_VERSION) {
        "Version: '$env:MODULE_VERSION'" | Write-Host
    }else {
        "Version is null." | Write-Host
    }

    # Get the module manifest's definition object
    $moduleManifestArgs = . $DefinitionPath

    # Determine the module name
    $moduleName = [System.IO.Path]::GetFileNameWithoutExtension($moduleManifestArgs['RootModule'])

    # Verify the superproject's name matches the value of the RootModule property specified in the specified module manifest definition file
    if ($moduleName -ne $global:PROJECT['NAME']) {
        throw "The superproject of name '$($global:PROJECT['NAME'])' does not match value of the RootModule property of value '$($moduleManifestArgs['RootModule'])' in the specified module manifest definition file. Ensure they match and try again."
    }

    # Set the module manifest path
    $moduleManifestArgs['Path'] = $Path

    # Set the module version based on the git tag if present, else default to 0.0.0 for mock / continuous builds
    $moduleManifestArgs['ModuleVersion'] = if ($env:MODULE_VERSION) { $env:MODULE_VERSION } else { '0.0.0' }

    # Create the new manifest (overrides existing)
    New-ModuleManifest @moduleManifestArgs

    # Run Update-ModuleManifest for standardizing the manifest and correctly populate the manifest's PrivateData properties
    $updateModuleManifestArgs = @{
        Path = $moduleManifestArgs['Path']
        PrivateData = $moduleManifestArgs['PrivateData']
    }
    Update-ModuleManifest @updateModuleManifestArgs

    # Display the generated manifest's content
    Get-Content -Path $moduleManifestArgs['Path'] | Write-Verbose

    # Return the manifest object
    Get-Item -Path $moduleManifestArgs['Path']

}catch {
    throw
}
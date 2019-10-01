[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$DefinitionFile
    ,
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$Path
)

try {
    if ($env:MODULE_VERSION) {
        "Version: '$env:MODULE_VERSION'" | Write-Host
    }else {
        "Version is null." | Write-Host
    }

    # Get the module manifest's definition object
    $moduleManifestArgs = . $DefinitionFile

    # Determine the module name
    $moduleName = [System.IO.Path]::GetFileNameWithoutExtension($moduleManifestArgs['RootModule'])

    # Set the module manifest path
    $moduleManifestArgs['Path'] = $Path

    # Set the module version based on the git tag if present, else default to 0.0.0 for mock / continuous builds
    $moduleManifestArgs['ModuleVersion'] = if ($env:MODULE_VERSION) { $env:MODULE_VERSION } else { '0.0.0' }

    # Create the new manifest (overrides existing)
    "Generating the module manifest" | Write-Host
    New-ModuleManifest @moduleManifestArgs

    # Run Update-ModuleManifest for standardizing the manifest and correctly populate the manifest's PrivateData properties
    "Updating the module manifest" | Write-Host
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
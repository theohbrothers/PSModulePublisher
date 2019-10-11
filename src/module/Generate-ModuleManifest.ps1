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
    # Get the module manifest's definition object
    $moduleManifestArgs = . $DefinitionFile

    # Set the module manifest path
    $moduleManifestArgs['Path'] = $Path

    # Set the module version based on the value of the following environment variable which will be set in a CI release environment. Else assume the run to be occurring within a development environment or as a regular CI build, assigning it the dummy value of '0.0.0'
    $moduleManifestArgs['ModuleVersion'] = if ($env:MODULE_VERSION) {
                                               $env:MODULE_VERSION
                                           }else {
                                               '0.0.0'
                                           }

    # Create the new manifest (overrides existing)
    "Generating the module manifest" | Write-Host
    $newModuleManifestArgs = $moduleManifestArgs.Clone()
    $newModuleManifestArgs.Remove('PrivateData')
    New-ModuleManifest @newModuleManifestArgs

    # Run Update-ModuleManifest for standardizing the manifest and correctly populate the manifest's PrivateData properties
    "Updating the module manifest" | Write-Host
    $updateModuleManifestArgs = @{
        Path = $moduleManifestArgs['Path']
        PrivateData = $moduleManifestArgs['PrivateData']
    }
    Update-ModuleManifest @updateModuleManifestArgs

    # Display the generated manifest's content
    "Displaying the generated manifest's content" | Write-Host
    Get-Content -Path $moduleManifestArgs['Path'] | Write-Verbose

    # Return the manifest item object
    Get-Item -Path $moduleManifestArgs['Path']

}catch {
    throw
}
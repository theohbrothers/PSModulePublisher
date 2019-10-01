[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($env:MODULE_VERSION) {
    "Version: '$env:MODULE_VERSION'" | Write-Host
}else {
    "Version is null." | Write-Host
}

# Script constants
$superProjectDirRaw = git rev-parse --show-superproject-working-tree
if ($superProjectDirRaw) {
    $projectDir = Convert-Path -Path $superProjectDirRaw
}else {
    $projectDir = Convert-Path -Path (git rev-parse --show-toplevel)
}
$modulesDir = Join-Path $projectDir 'Modules'
$buildDir = Join-Path $projectDir 'build'
$definitionsDir = Join-Path $buildDir 'definitions'
$definitions = @{
    modulemanifest = @{
        path = "$definitionsDir\modulemanifest\definition.ps1"
    }
}

# Get the module manifest's definition object
$moduleManifestArgs = . $definitions['modulemanifest']['path']
# Determine the module name
$moduleName = [System.IO.Path]::GetFileNameWithoutExtension($moduleManifestArgs['RootModule'])
# Set the module manifest path
$moduleManifestArgs['Path'] = "$modulesDir\$moduleName\$moduleName.psd1"
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

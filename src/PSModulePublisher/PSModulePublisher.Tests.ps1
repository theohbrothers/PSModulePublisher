Describe "Invoke-PSModulePublisher" -Tag 'Integration' {
    BeforeAll {
        $moduleDir = $PSScriptRoot
        Import-Module $moduleDir/PSModulePublisher.psm1 -Force
        $mockModuleRepoDir = (Resolve-Path "$PSScriptRoot/../../test/Mock-Module").Path
        $mockModuleManifest = (Resolve-Path "$mockModuleRepoDir/src/Mock-Module/Mock-Module.psd1").Path
        $env:PROJECT_BASE_DIR = $mockModuleRepoDir  # Override the project base
    }
    BeforeEach {
        Push-Location $mockModuleRepoDir
    }
    AfterEach {
        Pop-Location
    }
    It "Runs Invoke-Build" {
        $moduleManifest = Invoke-Build
        $moduleManifest | Should -Be $mockModuleManifest
    }
    It "Runs Invoke-Publish" {
        $env:MODULE_VERSION = '0.0.0'
        $env:NUGET_API_KEY = 'xxx'
        Invoke-Publish -ModuleManifestPath $mockModuleManifest -Repository PSGallery -DryRun
    }
    It "Runs Invoke-Test" {
        Invoke-Test -ModuleManifestPath $mockModuleManifest
    }
}

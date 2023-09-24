Describe "Invoke-PSModulePublisher" -Tag 'Integration' {
    BeforeEach {
        $moduleDir = $PSScriptRoot
        $mockModuleRepoDir = (Resolve-Path "$PSScriptRoot/../../test/Mock-Module").Path
        $mockModuleManifest = (Resolve-Path "$mockModuleRepoDir/src/Mock-Module/Mock-Module.psd1").Path
        Push-Location $mockModuleRepoDir
        $env:PROJECT_BASE_DIR = $mockModuleRepoDir  # Override the project base
    }
    AfterEach {
        Pop-Location
    }
    It "Runs Invoke-Build.ps1" {
        $moduleManifest = & "$moduleDir/Public/Invoke-Build.ps1"
        $moduleManifest | Should -Be $mockModuleManifest
    }
    It "Runs Invoke-Publish.ps1" {
        $env:MODULE_VERSION = '0.0.0'
        $env:NUGET_API_KEY = 'xxx'
        & "$moduleDir/Public/Invoke-Publish.ps1" -ModuleManifestPath $mockModuleManifest -Repository PSGallery -DryRun
    }
    It "Runs Invoke-Test.ps1" {
        & "$moduleDir/Public/Invoke-Test.ps1" -ModuleManifestPath $mockModuleManifest
    }
}

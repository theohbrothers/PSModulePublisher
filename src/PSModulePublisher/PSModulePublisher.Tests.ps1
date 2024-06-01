Describe "PSModulePublisher" -Tag 'Integration' {
    BeforeAll {
        $ErrorView = 'NormalView'
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
        $env:MODULE_VERSION = $null
        $moduleManifest = Invoke-Build
        $moduleManifest | Should -Be $mockModuleManifest
    }
    It "Runs Invoke-Test" {
        Invoke-Test -ModuleManifestPath $mockModuleManifest
    }
    It "Runs Invoke-Publish -DryRun `$env:NUGET_API_KEY" {
        $env:NUGET_API_KEY = 'xxx'
        Invoke-Publish -ModuleManifestPath $mockModuleManifest -Repository PSGallery -DryRun
    }
    It "Runs Invoke-Build `$env:MODULE_VERSION='0.1.0'" {
        $env:MODULE_VERSION = '0.1.0'
        $moduleManifest = Invoke-Build
        $moduleManifest | Should -Be $mockModuleManifest
    }
    It "Runs Invoke-Publish -Repository `$env:MODULE_VERSION='0.1.0'" {
        $env:MODULE_VERSION = '0.1.0'
        $env:NUGET_API_KEY = $null
        { Invoke-Publish -ModuleManifestPath $mockModuleManifest -Repository PSGallery } | Should -Throw
    }
    It "Runs Invoke-PSModulePublisher -Repository -DryRun `$env:NUGET_API_KEY" {
        $env:MODULE_VERSION = $null
        $env:NUGET_API_KEY = 'xxx'
        Invoke-PSModulePublisher -Repository PSGallery -DryRun
    }
    It "Runs Invoke-PSModulePublisher -Repository `$env:NUGET_API_KEY" {
        $env:MODULE_VERSION = $null
        $env:NUGET_API_KEY = 'xxx'
        { Invoke-PSModulePublisher -Repository PSGallery } | Should -Throw
    }
    It "Runs Invoke-PSModulePublisher -Repository `$env:MODULE_VERSION='0.1.0'" {
        $env:MODULE_VERSION = '0.1.0'
        $env:NUGET_API_KEY = $null
        { Invoke-PSModulePublisher -Repository PSGallery } | Should -Throw
    }
}

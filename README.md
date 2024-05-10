# PSModulePublisher

[![github-actions](https://github.com/theohbrothers/PSModulePublisher/workflows/ci-master-pr/badge.svg)](https://github.com/theohbrothers/PSModulePublisher/actions)
[![github-release](https://img.shields.io/github/v/release/theohbrothers/PSModulePublisher?style=flat-square)](https://github.com/theohbrothers/PSModulePublisher/releases/)

A project containing the necessary tools to ease publishing of PowerShell modules.

## Introduction

This project provides CI templates and cmdlets that other projects can utilize for building, testing, and publishing PowerShell modules.

### Main project structure

`PSModulePublisher` requires main projects to adopt the following directory structure:

```shell
/build/                                             # Directory containing build files
/build/PSModulePublisher/                           # The root directory of PSModulePublisher as a submodule
/build/definitions/modulemanifest.ps1               # The module manifest definition file

/src/MyPowershellModule/                            # The module's root directory
/src/MyPowershellModule/MyPowershellModule.psm1     # The module .psm1 file
/src/MyPowershellModule/MyPowershellModule.psd1     # The module .psd1 file (optional)

/test/                                              # Directory containing test files (optional)
/test/test.ps1                                      # The test entrypoint script (optional)
```

## Configuration

### Main project

Configure the following components on your main project.

#### Submodule

Add `PSModulePublisher` as a submodule under the directory `build` in your main project:

```shell
# Add the submodule
git submodule add https://github.com/theohbrothers/PSModulePublisher.git build/PSModulePublisher

# Checkout ref to use
git --git-dir build/PSModulePublisher/.git checkout vx.x.x

# Commit the submodule
git commit -am 'Add submodule PSModulePublisher vx.x.x'
```

#### Module file

Ensure the main project contains the module file at the location `src/MyPowershellModule/MyPowershellModule.psm1`.

#### Module manifest definition file

The project sources from a definition file to generate a manifest used for publishing the module. Ensure that the file exists in your main project at the location `build/definitions/modulemanifest.ps1` and that it contains the right properties and values relevant to your PowerShell module. Remember to update the definition prior to publishing your module.

The definition template can be found [here](docs/samples/build/definitions/modulemanifest.ps1).

#### CI files

Decide on which CI provider to use in your main project based on those supported by this project. Setup the CI file(s) for your main project. Then simply reference the relevant CI files of this project from your main project's CI file(s).

Sample CI files can be found [here](docs/samples/ci).

#### Test files (Optional)

The project optionally runs an entrypoint script for tests at the location `test/test.ps1`. You can add the module's main tests steps in this file for tests to be run.

Sample test files can be found [here](docs/samples/test).

### CI settings

Configure the following CI settings for your project.

#### Secrets

##### PSGallery API Key

Add a secret variable `NUGET_API_KEY` containing your [PSGallery API key](https://docs.microsoft.com/en-us/powershell/scripting/gallery/how-to/publishing-packages/publishing-a-package?view=powershell-6#powershell-gallery-account-and-api-key) to your main project's CI settings for publishing your module on [PowerShell Gallery](https://www.powershellgallery.com/).

#### Environment variables

##### Project base directory

By default, `PSModulePublisher` uses the main project's root directory as the path for execution. To override the default location, set the *environment* variable `PROJECT_BASE_DIR` to contain a custom directory value in your CI environment before executing `PSModulePublisher`.

## Usage

### Development

The project provides a all-in-one cmdlet [`Invoke-PSModulePublisher`](src/PSModulePublisher/Public/Invoke-PSModulePublisher.ps1) which can be used for executing the same build, test, and publish steps that will run in CI environments.

### Continuous Integration

#### Steps

The CI process is composed of the following steps:

##### Build

1. Display system info
2. Get PowerShell version
3. Process build variables
4. Generate module manifest

##### Test

1. Test module via module's manifest

##### Publish

1. Install publish dependencies *(if applicable)*
1. Publish module

**Build** and **Test** steps can be executed for every commit pushed. Simply [configure](docs/samples/ci/azure-pipelines/azure-pipelines.linux.sample.yml#L8-L11) your main project's CI file(s) and/or settings to allow so.

#### Publishing the module

**Publish** steps will run only for [*tag* refs](templates/azure-pipelines/steps/pwsh/run-publish.yml#L10). Ensure your main project's CI file(s) and/or settings are [configured](docs/samples/ci/azure-pipelines/azure-pipelines.linux.sample.yml#L5-L7) to run CI jobs for *tag* refs.

Tags must follow [Semantic Versioning](https://semver.org/) and be prepended with a lowercase `v`:

```shell
# Tag the commit to publish
git tag v1.0.12

# Push the tag
git push remotename v1.0.12
```

#### Use cases

For a basic use case, the CI process could simply comprise a single stage containing all the steps from **Build**, **Test**, and **Publish**.

In cases where the module needs to be tested across multiple operating systems and/or versions of PowerShell, two stages can be configured: The 1st stage containing *multiple jobs* executing [**Build** and **Test** steps](docs/samples/ci/azure-pipelines/azure-pipelines.linux.windows.sample.yml#L24-L40) for building and testing the module; the 2nd stage containing a *single* job executing [**Build** and **Publish** steps](docs/samples/ci/azure-pipelines/azure-pipelines.linux.windows.sample.yml#L52) for publishing the module.

Refer to the [sample CI files](docs/samples/ci) for some working examples.

### Managing the submodule

#### Retrieving updates

To update the submodule:

```shell
git submodule update --remote build/PSModulePublisher
```

#### Using a specific tag

To use a specific tag of the submodule:

```shell
# Checkout ref to use
git --git-dir build/PSModulePublisher/.git checkout vx.x.x

# Bump PSModulePublisher to the same ref in CI file
vi azure-pipelines.yml

# Commit the submodule and CI file
git commit -am 'Bump PSModulePublisher to vx.x.x'
```

## Best practices

- Use only tag refs of `PSModulePublisher` in your main project.
- Ensure your main project's CI file(s) is configured to use the CI templates of `PSModulePublisher` and that the ref used matches that of the `PSModulePublisher` submodule used in your main project.

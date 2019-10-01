# PSModulePublisher

A project containing the necessary tools to ease publishing of powershell modules.

## Setup

### Initial steps

First, add this project as a submodule under the directory `build` in your main project.

```shell
# Add the submodule
git submodule add 'https://github.com/theohbrothers/PSModulePublisher.git' build/PSModulePublisher
# Commit the submodule
git commit -m 'Add submodule PSModulePublisher'
```

Next, ensure the following files are present on your main project for the submodule to work.

### Module definition

Add a module definition file `build/definitions/modulemanifest/definition.ps1` to your main project containing relevant properties of your powershell module. The definition will be used for generating the manifest used with publishing of the module. Ensure to update the file before publishing your module.

The definition template can be found [here](https://github.com/theohbrothers/PSModulePublisher/blob/master/docs/samples/definitions/modulemanifest/definition.ps1.sample).

### CI files

Decide on which CI provider to use in your main project based on those supported by this project. Setup the CI file(s) for your main project. Then simply reference the relevant CI files of this project from your main project's CI file(s).

Sample CI files can be found [here](https://github.com/theohbrothers/PSModulePublisher/tree/master/docs/samples/ci).

### Test files (Optional)

The project runs an entrypoint test script at the location `tests/test.ps1` if it exists. Create the script in your main project for your module's tests to be run.

## Usage

### Continuous Integration

The project contains the necessary steps in its CI files for generating and testing module manifests, as well as testing of the modules based on the generated manifest. You can configure your main project's CI file(s) to run the steps on every push. Refer to the [sample CI files](https://github.com/theohbrothers/PSModulePublisher/tree/master/docs/samples/ci) for some working examples.

### Publishing modules

Publishing a module requires a tagged commit. The tag must follow [Semantic Versioning](https://semver.org) with a prepended `v` in order for the publish step to run.

```shell
# Tag the commit to release
git tag v1.0.12
# Push the tag
git push remotename v1.0.12
```

### Managing PSModulePublisher

#### Updating

To update the submodule:

```shell
git submodule update --remote
```

#### Using specific version

To use a specific commit or tag of the submodule:

```shell
# Change to the submodule's root directory
cd build/PSModulePublisher

# To use a specific commit
git checkout 0123456789abcdef0123456789abcdef01234567
# Or, to use a specific tag
git checkout v1.0.1

# Return to the main project's root directory
cd "$(git rev-parse --show-superproject-working-tree)"
# Commit the submodule
git commit -m 'Update submodule PSModulePublisher'
```

#### Tracking specific branch

To track a specific branch with `git submodule update`, add the `branch` key-value pair under the submodule's entry in `.gitmodules` like so:

```shell
[submodule "build/PSModulePublisher"]
	path = build/PSModulePublisher
	url = https://github.com/theohbrothers/PSModulePublisher.git
	branch = trackedbranch
```

## Best practices

- Use a tagged commit of `PSModulePublisher` in your main project.
- Ensure your main project's CI file(s) is configured to use the CI templates of [`PSModulePublisher`](https://github.com/theohbrothers/PSModulePublisher) and that the commit used matches that of `PSModulePublisher` used in your main project.

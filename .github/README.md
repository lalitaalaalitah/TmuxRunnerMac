# GitHub Actions Workflow

This repository uses GitHub Actions to automate the build and release process for the `TmuxRunner.app` macOS application.

## How it Works

The workflow is defined in `.github/workflows/build-and-release.yml`. It is configured to run automatically whenever a new **version tag** is pushed to the repository.

When triggered, the action will:
1. Check out the repository.
2. Extract the version number from the Git tag.
3. Run the `./build.sh` script, passing the version number via the `VERSION` environment variable. The build script automatically injects this version information and publisher metadata into the `Info.plist` of the macOS Application Bundle.
4. Zip the built `TmuxRunner.app` into `TmuxRunner.zip`.
5. Create a new GitHub Release under the "Releases" section of the repository, attaching the zipped application bundle as a downloadable asset.

## Triggering a New Release

To build and release a new version of `TmuxRunner.app`, you simply need to create a Git tag starting with `v` (e.g., `v1.0.1`, `v2.0.0`) and push it to GitHub.

You can do this using the `git` command line:

```bash
# 1. Commit any outstanding changes
git commit -m "Your release changes"

# 2. Create an annotated tag for the new version
git tag -a v1.0.1 -m "Release version 1.0.1"

# 3. Push the tag to GitHub (this triggers the workflow)
git push origin v1.0.1
```

Once pushed, navigate to the **Actions** tab on your GitHub repository to monitor the build progress. Upon completion, a new release will be available on the **Releases** page!

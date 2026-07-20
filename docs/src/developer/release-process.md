# [Release process](@id release-process)

EpiAwareADTools.jl follows the Julia ecosystem's standard release practices, driven by the shared EpiAwarePackageTools workflows.
This page describes what those workflows actually do in this repository.

The package is registered in the Julia General Registry; see [Installation](@ref installation).

## Release philosophy

- **Release frequently**: ideally after every merged pull request to `main`
- **Semantic versioning**: follow [SemVer](https://semver.org/) strictly
- **Automated tooling**: registration, tagging, and version increments are workflow-driven
- **SciML ecosystem alignment**: follow established patterns from the broader scientific computing ecosystem

**When not to release**:
- Work-in-progress features
- Failing tests
- Incomplete documentation for new features

## Semantic versioning

Following [SemVer](https://semver.org/):

- **Patch** (`1.0.0` → `1.0.1`): Bug fixes, performance improvements
- **Minor** (`1.0.1` → `1.1.0`): New features, additions to the API (backwards compatible)
- **Major** (`1.1.0` → `2.0.0`): Breaking changes to the public API

Examples:
- Adding a new AD-safe hook or workaround: **Minor**
- Fixing a derivative rule bug: **Patch**
- Changing a public hook signature: **Major**
- Removing an entry once its upstream fix lands: **Major** (downstream packages depend on the surface)

## Version management

Version increments in `Project.toml` are handled by two workflows rather than by hand.

### Automatic patch increment

`.github/workflows/auto-version-increment.yaml` runs on every push to `main`.
It compares the version in `Project.toml` against the previous commit.
If the version is unchanged, it opens a pull request that bumps the **patch** version.
If the version already changed in the push, it does nothing.
This keeps `main` on an unreleased version after every merge.

### On-demand increment

`.github/workflows/version-on-demand.yaml` responds to a `/version major|minor|patch` comment on a pull request.
The comment is gated on the author having `write`, `maintain`, or `admin` permission.
On success it commits the chosen increment directly to the pull request branch and reports the old and new versions.
Use it when a change needs a minor or major bump rather than the default patch.

## Registration and tagging

Once a version bump is merged to `main`, registration is triggered from within the repository.

### Triggering registration

`.github/workflows/Register.yml` posts the `@JuliaRegistrator register` comment on `main`'s HEAD commit for you.
There is no need to type that comment by hand.
Fire it either way, both gated on the actor having write access:

- Comment `/register` on any issue or pull request
- Run the workflow manually from **Actions → Register → Run workflow**

If the actor lacks write access, the workflow reacts to the comment with a thumbs-down and does nothing else.

### Automated flow

1. `Register.yml` posts the registration comment on the `main` commit
2. JuliaRegistrator (the org-installed GitHub App) reacts to the comment and opens a pull request against the Julia General Registry
3. Once the registry pull request merges (usually within about 15 minutes; the initial registration of a new package has a mandatory waiting period instead), TagBot creates the GitHub release
4. Documentation is deployed for the new tagged version

### TagBot

`.github/workflows/TagBot.yaml` calls the shared EpiAware TagBot workflow.
It runs when JuliaTagBot triggers it after registration, or manually via workflow dispatch.
It creates the GitHub release with generated changelog and uses the repository's `DOCUMENTER_KEY` for authenticated operations.

## Dependency updates

Dependency and pinned-reference updates reach this repository through the shared infrastructure rather than a per-repository CompatHelper.
Dependabot (`.github/dependabot.yml`) keeps the pinned reusable-workflow and action references current, and the scheduled template-sync workflow propagates kit-level `[compat]` and configuration changes.
See [EpiAwarePackageTools](https://github.com/EpiAware/EpiAwarePackageTools.jl) for details.

## Release notes

- **GitHub Releases**: created by TagBot for every release, with a generated changelog linking commits and pull requests
- **NEWS.md**: reserved for major releases and significant milestones, giving context for breaking changes and migration guidance

## Pre-release checklist

Before triggering registration:

- [ ] All CI tests pass (including pre-commit hooks)
- [ ] The version number in `Project.toml` follows semantic versioning
- [ ] New features have tests and documentation
- [ ] Examples in docstrings work correctly

For a major release, additionally:

- [ ] NEWS.md entry describing the breaking changes and migration path
- [ ] Deprecation warnings added in a previous release where applicable
- [ ] Downstream package compatibility assessed (ConvolvedDistributions.jl and CensoredDistributions.jl consume the AD-safe surface)

## Troubleshooting releases

- **Registry pull request fails**: check `Project.toml` syntax and version conflicts
- **TagBot doesn't trigger**: verify the `DOCUMENTER_KEY` secret is configured
- **Registration comment does nothing**: confirm the actor has write access to the repository

---

This process gives reliable, frequent releases while keeping version management and tagging automated.

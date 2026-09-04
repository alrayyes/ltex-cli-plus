## ADDED Requirements

### Requirement: Shared LTeX image

The system SHALL build a Debian-based container image bundling
`ltex-cli-plus`, pinned to a specific upstream version, and publish it to
`ghcr.io/alrayyes/ltex-cli-plus`.

#### Scenario: Pull request

- **WHEN** a pull request changes the Dockerfile or its build context
- **THEN** the image builds without being pushed, so a broken Dockerfile
  fails the check before merge

#### Scenario: Merge to main

- **WHEN** a commit lands on `main`
- **THEN** the image builds and pushes to `ghcr.io`, tagged with the pinned
  LTeX version and `latest`, with a build-provenance attestation

### Requirement: Upstream version tracking

The system SHALL detect when the pinned LTeX version falls behind
`ltex-plus/ltex-ls-plus`'s own releases and open a pull request bumping it,
since Dependabot's `docker` ecosystem only watches the base image tag and
has no way to see an unrelated project's releases.

#### Scenario: A new upstream release exists

- **WHEN** the weekly check runs and the pinned version doesn't match the
  latest upstream release
- **THEN** a pull request opens bumping the pin, and auto-merges once its
  checks pass

### Requirement: Self-releasing repo

The system SHALL release itself from Conventional Commits on `main`,
maintaining a changelog and versioned releases independent of the image's
own LTeX-version tags.

#### Scenario: A releasable commit lands

- **WHEN** a `fix:` or `feat:` commit lands on `main`
- **THEN** a release pull request opens (or updates) carrying the next
  version and changelog entry, and auto-merges once its checks pass

# Bootstrap the image build pipeline

Documented retroactively — implemented in #1 and #2 before this change was
written up.

## Why

`ltex-ls-plus` ships no official Docker image, so every repo running a
grammar check in CI (server-dotfiles, claude-dotfiles, and this account's
dotfiles repo) was downloading and unpacking the same 319 MB tarball on
every single run.

## What changes

- A Dockerfile builds a Debian-based image bundling `ltex-cli-plus`, pinned
  by an `ARG LTEX_VERSION` build argument.
- A `build` workflow builds the image on every pull request and pushes it
  to `ghcr.io/alrayyes/ltex-cli-plus` (tagged by version and `latest`) on
  every push to `main`, with a signed build-provenance attestation.
- A `check-upstream` workflow runs weekly, compares the pinned version
  against `ltex-plus/ltex-ls-plus`'s own releases, and opens a
  self-merging pull request when it's fallen behind.
- The repo releases itself: `release-please` reads Conventional Commits on
  `main` and keeps a release pull request open, which auto-merges once its
  checks pass, the same as Dependabot's own pull requests.

## Impact

Consuming repos pull a pre-built image instead of fetching the tarball
themselves - a `docker pull` instead of a 319 MB download and unpack, every
run.

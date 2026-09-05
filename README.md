# ltex-cli-plus

[![build](https://github.com/alrayyes/ltex-cli-plus/actions/workflows/build.yml/badge.svg)](https://github.com/alrayyes/ltex-cli-plus/actions/workflows/build.yml)
[![release](https://img.shields.io/github/v/release/alrayyes/ltex-cli-plus)](https://github.com/alrayyes/ltex-cli-plus/releases)
[![ghcr.io](https://img.shields.io/badge/ghcr.io-ltex--cli--plus-blue)](https://github.com/alrayyes/ltex-cli-plus/pkgs/container/ltex-cli-plus)
[![licence](https://img.shields.io/github/license/alrayyes/ltex-cli-plus)](LICENSE)

A Debian-based container image bundling [ltex-cli-plus](https://github.com/ltex-plus/ltex-ls-plus),
built once and reused by CI grammar checks instead of every consuming repo
downloading and unpacking the same 319 MB tarball on every run.

## Why this exists

`ltex-ls-plus` ships no official Docker image - its GitHub releases carry only
platform tarballs, and `ghcr.io/ltex-plus/ltex-ls-plus` 401s on every tag
lookup (either unpublished or still mid-flight upstream). Each repo running
a grammar check in CI was fetching and extracting the same tarball fresh on
every single run.

Consumed by more than one of this account's own CI pipelines, each running
the same grammar check.

## Image

```text
ghcr.io/alrayyes/ltex-cli-plus:<ltex-ls-plus version>
ghcr.io/alrayyes/ltex-cli-plus:latest
```

The entrypoint is `ltex-cli-plus` itself - run it the same way you would the
unpacked binary:

```sh
docker run --rm -v "$PWD:/work" -w /work ghcr.io/alrayyes/ltex-cli-plus:18.7.0 \
  --client-configuration=.ltex.json README.md
```

### Why the image also ships `git` and `node`

A CI job that runs `container: <image>` (GitHub Actions and Forgejo Actions
alike) executes every step inside that container's own filesystem, not the
runner's. `actions/checkout` is a JavaScript action, so it needs a `node`
runtime to execute at all, and it shells out to `git` to actually fetch the
repository - neither is optional for checkout to run. Baking both into the
image means a consumer can go straight from `container: ghcr.io/alrayyes/
ltex-cli-plus:<version>` to `actions/checkout` with no package-install step
in between; without them, every consumer would otherwise install the same
two packages themselves, on every single run.

Override the entrypoint (`options: --entrypoint ""` on GitHub Actions and
Forgejo alike) to run anything other than `ltex-cli-plus` itself in that
container.

## Keeping it current

The pinned version lives in `Dockerfile`'s `ARG LTEX_VERSION`.
`.github/workflows/check-upstream.yml` runs weekly, compares that pin
against `ltex-plus/ltex-ls-plus`'s latest release, and opens a pull request
when it's fallen behind. `.github/workflows/build.yml` builds and pushes the
image on every push to `main`, tagged with the version and `latest`.

A consuming repo's own Renovate (or Dependabot) picks up the new image tag
from there the same way it tracks any other pinned Docker image - there's
nothing repo-specific to configure on this end.

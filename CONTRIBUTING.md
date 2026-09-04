# Contributing

This repo builds one thing: a container image wrapping `ltex-cli-plus`.
Changes are almost always one of:

- Bumping `ARG LTEX_VERSION` in `Dockerfile` - usually done automatically by
  `.github/workflows/check-upstream.yml`, but a manual pull request works the
  same way.
- Editing the `Dockerfile` itself.

## Testing a change locally

```sh
docker build -t ltex-cli-plus:local .
docker run --rm -v "$PWD:/work" -w /work ltex-cli-plus:local --help
```

## Opening a pull request

Every change lands through a pull request - see the repo's branch protection
for the mechanics. `.github/workflows/build.yml` builds the image on every
pull request without pushing it, so a broken `Dockerfile` fails the check
before merge.

Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/):
a `fix:` for anything that changes what ships in the image (the `Dockerfile`,
the pinned `LTEX_VERSION`), `ci:` for pipeline-only changes, `chore:`/`docs:`
for everything else.

## Releases

[release-please](https://github.com/googleapis/release-please) reads the
Conventional Commits on `main` and keeps a release pull request open with the
next version and changelog entry. Merging it tags the release and writes
`CHANGELOG.md`. Nobody picks a version by hand, and both that pull request
and a routine `check-upstream.yml` version bump auto-merge themselves once
their checks pass - the same standing exception any Dependabot pull request
gets.

The release job needs a `RELEASE_TOKEN` Actions secret (a real PAT, not the
default `GITHUB_TOKEN` - a bot-authored push doesn't trigger other
workflows, which would otherwise leave the release pull request's own checks
never running). Without it the release job fails outright rather than
silently skipping.

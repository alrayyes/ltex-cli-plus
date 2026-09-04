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

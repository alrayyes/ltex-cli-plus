# Bake checkout dependencies into the image

## Why

Every consuming repo runs this image as a `container:` job so
`actions/checkout` (GitHub's and Forgejo's own fork) can pull the repo down
before the grammar check runs. A container job's steps run inside that
container's filesystem, not the runner's, and `actions/checkout` is a JS
action that shells out to git — so it needs both `git` and `nodejs` on
`PATH` to run at all. The image ships neither today, so dotfiles,
server-dotfiles and claude-dotfiles each run their own `apt-get update &&
apt-get install -y --no-install-recommends git nodejs` step first, on every
single run, identically.

## What changes

- `Dockerfile` installs `git` and `nodejs` alongside the existing packages
  and doesn't purge either afterward.

## Impact

Consuming repos drop their own `apt-get install` step for the `ltex`/
`grammar` job entirely once they bump to the image built from this change.

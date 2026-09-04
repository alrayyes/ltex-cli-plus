## 1. Image

- [x] 1.1 Dockerfile: Debian base, `ltex-cli-plus` unpacked at build time
      from `ARG LTEX_VERSION`.
- [x] 1.2 `build` workflow: build on every pull request, push to `ghcr.io`
      on push to `main`, tagged by version and `latest`.
- [x] 1.3 Build provenance attestation on the pushed image.

## 2. Keeping the pin current

- [x] 2.1 `check-upstream` workflow: weekly check against
      `ltex-plus/ltex-ls-plus`'s releases, opens a pull request when behind.
- [x] 2.2 That pull request auto-merges once checks pass.

## 3. Repo hygiene

- [x] 3.1 Dependabot for the base image and workflow pins.
- [x] 3.2 Dependabot pull requests auto-merge (patch/minor) once checks pass.
- [x] 3.3 `release-please` releases the repo itself from Conventional
      Commits; its pull request auto-merges the same way.

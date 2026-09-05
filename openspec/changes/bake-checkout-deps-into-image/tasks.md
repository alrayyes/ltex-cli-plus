## 1. Image

- [x] 1.1 `Dockerfile`: install `git` and `nodejs`, keep both past the
      cleanup step.
- [x] 1.2 Verify locally: `docker build`, then `git --version`,
      `node --version` and the existing `ltex-cli-plus` entrypoint all work
      in the built image.

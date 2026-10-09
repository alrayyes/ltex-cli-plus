# Debian, not Alpine: ltex-ls-plus ships its own JRE, and that JRE is
# glibc-linked - it dies on musl before it reads a word.
FROM debian:bookworm-slim@sha256:7c7b2c966bc9ee8cedfeef67e0e279108992c77681fa595db4a9d65c06ccc587

ARG LTEX_VERSION=18.7.0

# git and nodejs stay installed (not purged below): every consuming repo's CI
# runs this image as a `container:` job, and actions/checkout needs both to
# check the repo out at all - each one was apt-get installing them itself on
# top of this image on every single run before this.
RUN apt-get update -qq \
    && apt-get install -y -qq --no-install-recommends ca-certificates curl git nodejs \
    && curl -sSLo /tmp/ltex.tar.gz "https://github.com/ltex-plus/ltex-ls-plus/releases/download/${LTEX_VERSION}/ltex-ls-plus-${LTEX_VERSION}-linux-x64.tar.gz" \
    && tar xzf /tmp/ltex.tar.gz -C /opt \
    && ln -s "/opt/ltex-ls-plus-${LTEX_VERSION}/bin/ltex-cli-plus" /usr/local/bin/ltex-cli-plus \
    && rm /tmp/ltex.tar.gz \
    && apt-get purge -y -qq curl \
    && apt-get autoremove -y -qq \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/ltex-cli-plus"]

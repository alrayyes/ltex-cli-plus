# Debian, not Alpine: ltex-ls-plus ships its own JRE, and that JRE is
# glibc-linked - it dies on musl before it reads a word.
FROM debian:bookworm-slim@sha256:88200866dfff7ea7f5cbcb6ec7c8a701889efe6fe859fe64d6990e4b07ea4171

ARG LTEX_VERSION=18.7.0

RUN apt-get update -qq \
    && apt-get install -y -qq --no-install-recommends ca-certificates curl \
    && curl -sSLo /tmp/ltex.tar.gz "https://github.com/ltex-plus/ltex-ls-plus/releases/download/${LTEX_VERSION}/ltex-ls-plus-${LTEX_VERSION}-linux-x64.tar.gz" \
    && tar xzf /tmp/ltex.tar.gz -C /opt \
    && ln -s "/opt/ltex-ls-plus-${LTEX_VERSION}/bin/ltex-cli-plus" /usr/local/bin/ltex-cli-plus \
    && rm /tmp/ltex.tar.gz \
    && apt-get purge -y -qq curl \
    && apt-get autoremove -y -qq \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/local/bin/ltex-cli-plus"]

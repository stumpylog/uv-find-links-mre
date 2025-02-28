# syntax=docker/dockerfile:1
# https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/reference.md

FROM ghcr.io/astral-sh/uv:0.6.3-python3.12-bookworm AS app

WORKDIR /app

# Python dependencies
# Change pretty frequently
COPY --chown=1000:1000 ["pyproject.toml", "uv.lock", "/app/"]

ARG PSYCOPG_VERSION=3.2.4

RUN echo "Installing Python requirements" \
    && curl --fail --silent --no-progress-meter --show-error --location --remote-name-all --parallel --parallel-max 4 \
      https://github.com/paperless-ngx/builder/releases/download/psycopg-${PSYCOPG_VERSION}/psycopg_c-${PSYCOPG_VERSION}-cp312-cp312-linux_x86_64.whl \
      https://github.com/paperless-ngx/builder/releases/download/psycopg-${PSYCOPG_VERSION}/psycopg_c-${PSYCOPG_VERSION}-cp312-cp312-linux_aarch64.whl \
    && ls -ahl . \
    && uv sync --verbose --frozen --no-dev --no-python-downloads --python-preference system --find-links ./  --no-build-package psycopg-c

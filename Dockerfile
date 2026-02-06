FROM node:22-bookworm
# [ 1/14] FROM docker.io/library/node:22-bookworm@sha256:379c51ac7bbf9bffe16769cfda3eb027d59d9c66ac314383da3fcf71b46d026c

# Install Bun (required for build scripts)
RUN curl -fsSL https://bun.sh/install | bash
# [ 2/14] RUN curl -fsSL https://bun.sh/install | bash

ENV PATH="/root/.bun/bin:${PATH}"

RUN corepack enable
# [ 3/14] RUN corepack enable

WORKDIR /app
# [ 4/14] WORKDIR /app

ARG OPENCLAW_DOCKER_APT_PACKAGES=""
RUN if [ -n "$OPENCLAW_DOCKER_APT_PACKAGES" ]; then \
      apt-get update && \
      DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $OPENCLAW_DOCKER_APT_PACKAGES && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*; \
    fi
# [ 5/14] RUN
# if [ -n "" ]; then
#     apt-get update &&
#     DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends  &&
#     apt-get clean &&
#     rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*; \
# fi

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml .npmrc ./
# [ 6/14] COPY package.json pnpm-lock.yaml pnpm-workspace.yaml .npmrc ./

COPY ui/package.json ./ui/package.json
# [ 7/14] COPY ui/package.json ./ui/package.json

COPY patches ./patches
# [ 8/14] COPY patches ./patches

COPY scripts ./scripts
# [ 9/14] COPY scripts ./scripts

RUN pnpm install --frozen-lockfile
# [10/14] RUN pnpm install --frozen-lockfile

COPY . .
# [11/14] COPY . .

RUN OPENCLAW_A2UI_SKIP_MISSING=1 pnpm build
# [12/14] RUN OPENCLAW_A2UI_SKIP_MISSING=1 pnpm build

# Force pnpm for UI build (Bun may fail on ARM/Synology architectures)
ENV OPENCLAW_PREFER_PNPM=1
RUN pnpm ui:build
# [13/14] RUN pnpm ui:build

ENV NODE_ENV=production

# Allow non-root user to write temp files during runtime/tests.
RUN chown -R node:node /app
# [14/14] RUN chown -R node:node /app

# Security hardening: Run as non-root user
# The node:22-bookworm image includes a 'node' user (uid 1000)
# This reduces the attack surface by preventing container escape via root privileges
USER node

# Start gateway server with default config.
# Binds to loopback (127.0.0.1) by default for security.
#
# For container platforms requiring external health checks:
#   1. Set OPENCLAW_GATEWAY_TOKEN or OPENCLAW_GATEWAY_PASSWORD env var
#   2. Override CMD: ["node","dist/index.js","gateway","--allow-unconfigured","--bind","lan"]
CMD ["node", "dist/index.js", "gateway", "--allow-unconfigured"]

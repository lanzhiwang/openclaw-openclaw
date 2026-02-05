

```bash

$ bash install.sh --help

  🦞 OpenClaw Installer
  I'll do the boring stuff while you dramatically stare at the logs like it's cinema.

✓ Detected: linux
OpenClaw installer (macOS + Linux)

Usage:
  curl -fsSL --proto '=https' --tlsv1.2 https://openclaw.ai/install.sh | bash -s -- [options]

Options:
  --install-method, --method npm|git   Install via npm (default) or from a git checkout
  --npm                               Shortcut for --install-method npm
  --git, --github                     Shortcut for --install-method git
  --version <version|dist-tag>         npm install: version (default: latest)
  --beta                               Use beta if available, else latest
  --git-dir, --dir <path>             Checkout directory (default: ~/openclaw)
  --no-git-update                      Skip git pull for existing checkout
  --no-onboard                          Skip onboarding (non-interactive)
  --no-prompt                           Disable prompts (required in CI/automation)
  --dry-run                             Print what would happen (no changes)
  --verbose                             Print debug output (set -x, npm verbose)
  --help, -h                            Show this help

Environment variables:
  OPENCLAW_INSTALL_METHOD=git|npm
  OPENCLAW_VERSION=latest|next|<semver>
  OPENCLAW_BETA=0|1
  OPENCLAW_GIT_DIR=...
  OPENCLAW_GIT_UPDATE=0|1
  OPENCLAW_NO_PROMPT=1
  OPENCLAW_DRY_RUN=1
  OPENCLAW_NO_ONBOARD=1
  OPENCLAW_VERBOSE=1
  OPENCLAW_NPM_LOGLEVEL=error|warn|notice  Default: error (hide npm deprecation noise)
  SHARP_IGNORE_GLOBAL_LIBVIPS=0|1    Default: 1 (avoid sharp building against global libvips)

Examples:
  curl -fsSL --proto '=https' --tlsv1.2 https://openclaw.ai/install.sh | bash
  curl -fsSL --proto '=https' --tlsv1.2 https://openclaw.ai/install.sh | bash -s -- --no-onboard
  curl -fsSL --proto '=https' --tlsv1.2 https://openclaw.ai/install.sh | bash -s -- --install-method git --no-onboard
$

$ bash install.sh --no-onboard
$
```

# 🦞 OpenClaw

```bash

################################################################################################

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

################################################################################################

$ bash install.sh --no-onboard
$

################################################################################################

$ openclaw --version
2026.2.3-1

################################################################################################

$ openclaw --help

🦞 OpenClaw 2026.2.3-1 (d84eb46) — WhatsApp automation without the "please accept our new privacy policy".

Usage: openclaw [options] [command]

Options:
  -V, --version     output the version number
  --dev             Dev profile: isolate state under ~/.openclaw-dev, default gateway port 19001, and shift derived ports (browser/canvas)
  --profile <name>  Use a named profile (isolates OPENCLAW_STATE_DIR/OPENCLAW_CONFIG_PATH under ~/.openclaw-<name>)
  --no-color        Disable ANSI colors
  -h, --help        display help for command

Commands:
  setup             Initialize ~/.openclaw/openclaw.json and the agent workspace
                    初始化 ~/.openclaw/openclaw.json 和代理工作区

  onboard           Interactive wizard to set up the gateway, workspace, and skills
                    交互式向导, 用于设置网关、工作区和技能

  configure         Interactive prompt to set up credentials, devices, and agent defaults
                    交互式提示, 用于设置凭据、设备和代理默认设置

  config            Config helpers (get/set/unset). Run without subcommand for the wizard.
                    配置助手(获取/设置/取消设置). 运行向导时无需子命令.

  doctor            Health checks + quick fixes for the gateway and channels
                    健康检查 + 网关和通道的快速修复

  dashboard         Open the Control UI with your current token
                    使用当前令牌打开控制界面

  reset             Reset local config/state (keeps the CLI installed)
                    重置本地配置/状态(保留 CLI)

  uninstall         Uninstall the gateway service + local data (CLI remains)
                    卸载网关服务和本地数据(保留 CLI)

  message           Send messages and channel actions
                    发送消息和通道操作

  memory            Memory search tools
                    内存搜索工具

  agent             Run an agent turn via the Gateway (use --local for embedded)
                    通过网关运行代理轮询(使用 --local 参数以嵌入)

  agents            Manage isolated agents (workspaces + auth + routing)
                    管理隔离代理(工作区 + 身份验证 + 路由)

  acp               Agent Control Protocol tools
                    代理控制协议工具

  gateway           Gateway control
  daemon            Gateway service (legacy alias)
  logs              Gateway logs
  system            System events, heartbeat, and presence
                    系统事件、心跳和在线状态

  models            Model configuration
  approvals         Exec approvals
                    执行审批

  nodes             Node commands
  devices           Device pairing + token management
                    设备配对 + 令牌管理

  node              Node control
  sandbox           Sandbox tools
  tui               Terminal UI
  cron              Cron scheduler
  dns               DNS helpers
  docs              Docs helpers
  hooks             Hooks tooling
  webhooks          Webhook helpers
  pairing           Pairing helpers
  plugins           Plugin management
  channels          Channel management
  directory         Directory commands
  security          Security helpers
  skills            Skills management
  update            CLI update helpers
  completion        Generate shell completion script
  status            Show channel health and recent session recipients
  health            Fetch health from the running gateway
  sessions          List stored conversation sessions
  browser           Manage OpenClaw's dedicated browser (Chrome/Chromium)
  help              display help for command

Examples:
  openclaw channels login --verbose
    Link personal WhatsApp Web and show QR + connection logs.
  openclaw message send --target +15555550123 --message "Hi" --json
    Send via your web session and print JSON result.
  openclaw gateway --port 18789
    Run the WebSocket Gateway locally.
  openclaw --dev gateway
    Run a dev Gateway (isolated state/config) on ws://127.0.0.1:19001.
  openclaw gateway --force
    Kill anything bound to the default gateway port, then start it.
  openclaw gateway ...
    Gateway control via WebSocket.
  openclaw agent --to +15555550123 --message "Run summary" --deliver
    Talk directly to the agent using the Gateway; optionally send the WhatsApp reply.
  openclaw message send --channel telegram --target @mychat --message "Hi"
    Send via your Telegram bot.

Docs: docs.openclaw.ai/cli

$

################################################################################################

$ openclaw setup

🦞 OpenClaw 2026.2.3-1 (d84eb46) — I'll refactor your busywork like it owes me money.

Wrote ~/.openclaw/openclaw.json
Workspace OK: ~/.openclaw/workspace
Sessions OK: ~/.openclaw/agents/main/sessions

################################################################################################

$ tree -a ~/.openclaw/
/root/.openclaw/
├── agents
│   └── main
│       └── sessions
├── openclaw.json
└── workspace
    ├── .git
    │   ├── HEAD
    │   ├── branches
    │   ├── config
    │   ├── description
    │   ├── hooks
    │   │   ├── applypatch-msg.sample
    │   │   ├── commit-msg.sample
    │   │   ├── fsmonitor-watchman.sample
    │   │   ├── post-update.sample
    │   │   ├── pre-applypatch.sample
    │   │   ├── pre-commit.sample
    │   │   ├── pre-merge-commit.sample
    │   │   ├── pre-push.sample
    │   │   ├── pre-rebase.sample
    │   │   ├── pre-receive.sample
    │   │   ├── prepare-commit-msg.sample
    │   │   ├── push-to-checkout.sample
    │   │   └── update.sample
    │   ├── info
    │   │   └── exclude
    │   ├── objects
    │   │   ├── info
    │   │   └── pack
    │   └── refs
    │       ├── heads
    │       └── tags
    ├── AGENTS.md
    ├── BOOTSTRAP.md
    ├── HEARTBEAT.md
    ├── IDENTITY.md
    ├── SOUL.md
    ├── TOOLS.md
    └── USER.md

14 directories, 25 files

################################################################################################

$ cat ~/.openclaw/openclaw.json
{
  "agents": {
    "defaults": {
      "workspace": "/root/.openclaw/workspace"
    }
  },
  "meta": {
    "lastTouchedVersion": "2026.2.3-1",
    "lastTouchedAt": "2026-02-06T08:07:25.214Z"
  }
}
$

################################################################################################

$ openclaw gateway --help

🦞 OpenClaw 2026.2.3-1 (d84eb46) — Automation with claws: minimal fuss, maximal pinch.

Usage: openclaw gateway [options] [command]

Run the WebSocket Gateway

Options:
  --port <port>              Port for the gateway WebSocket
  --bind <mode>              Bind mode ("loopback"|"lan"|"tailnet"|"auto"|"custom"). Defaults to config gateway.bind (or loopback).
  --token <token>            Shared token required in connect.params.auth.token (default: OPENCLAW_GATEWAY_TOKEN env if set)
  --auth <mode>              Gateway auth mode ("token"|"password")
  --password <password>      Password for auth mode=password
  --tailscale <mode>         Tailscale exposure mode ("off"|"serve"|"funnel")
  --tailscale-reset-on-exit  Reset Tailscale serve/funnel configuration on shutdown (default: false)
  --allow-unconfigured       Allow gateway start without gateway.mode=local in config (default: false)
  --dev                      Create a dev config + workspace if missing (no BOOTSTRAP.md) (default: false)
  --reset                    Reset dev config + credentials + sessions + workspace (requires --dev) (default: false)
  --force                    Kill any existing listener on the target port before starting (default: false)
  --verbose                  Verbose logging to stdout/stderr (default: false)
  --claude-cli-logs          Only show claude-cli logs in the console (includes stdout/stderr) (default: false)
  --ws-log <style>           WebSocket log style ("auto"|"full"|"compact") (default: "auto")
  --compact                  Alias for "--ws-log compact" (default: false)
  --raw-stream               Log raw model stream events to jsonl (default: false)
  --raw-stream-path <path>   Raw stream jsonl path
  -h, --help                 display help for command

Commands:
  run                        Run the WebSocket Gateway (foreground)
  status                     Show gateway service status + probe the Gateway
  install                    Install the Gateway service (launchd/systemd/schtasks)
  uninstall                  Uninstall the Gateway service (launchd/systemd/schtasks)
  start                      Start the Gateway service (launchd/systemd/schtasks)
  stop                       Stop the Gateway service (launchd/systemd/schtasks)
  restart                    Restart the Gateway service (launchd/systemd/schtasks)
  call                       Call a Gateway method
  usage-cost                 Fetch usage cost summary from session logs
  health                     Fetch Gateway health
  probe                      Show gateway reachability + discovery + health + status summary (local + remote)
  discover                   Discover gateways via Bonjour (local + wide-area if configured)

Docs: docs.openclaw.ai/cli/gateway

$
################################################################################################

$ openclaw onboard --help

🦞 OpenClaw 2026.2.3-1 (d84eb46) — I speak fluent bash, mild sarcasm, and aggressive tab-completion energy.

Usage: openclaw onboard [options]

Interactive wizard to set up the gateway, workspace, and skills

Options:
  --workspace <dir>                        Agent workspace directory (default: ~/.openclaw/workspace)
  --reset                                  Reset config + credentials + sessions + workspace before running wizard
  --non-interactive                        Run without prompts (default: false)
  --accept-risk                            Acknowledge that agents are powerful and full system access is risky (required for --non-interactive) (default: false)
  --flow <flow>                            Wizard flow: quickstart|advanced|manual
  --mode <mode>                            Wizard mode: local|remote
  --auth-choice <choice>                   Auth:
                                           setup-token|token|chutes|openai-codex|openai-api-key|openrouter-api-key|ai-gateway-api-key|cloudflare-ai-gateway-api-key|moonshot-api-key|moonshot-api-key-cn|kimi-code-api-key|synthetic-api-key|venice-api-key|gemini-api-key|zai-api-key|xiaomi-api-key|apiKey|minimax-api|minimax-api-lightning|opencode-zen|skip
  --token-provider <id>                    Token provider id (non-interactive; used with --auth-choice token)
  --token <token>                          Token value (non-interactive; used with --auth-choice token)
  --token-profile-id <id>                  Auth profile id (non-interactive; default: <provider>:manual)
  --token-expires-in <duration>            Optional token expiry duration (e.g. 365d, 12h)
  --anthropic-api-key <key>                Anthropic API key
  --openai-api-key <key>                   OpenAI API key
  --openrouter-api-key <key>               OpenRouter API key
  --ai-gateway-api-key <key>               Vercel AI Gateway API key
  --cloudflare-ai-gateway-account-id <id>  Cloudflare Account ID
  --cloudflare-ai-gateway-gateway-id <id>  Cloudflare AI Gateway ID
  --cloudflare-ai-gateway-api-key <key>    Cloudflare AI Gateway API key
  --moonshot-api-key <key>                 Moonshot API key
  --kimi-code-api-key <key>                Kimi Coding API key
  --gemini-api-key <key>                   Gemini API key
  --zai-api-key <key>                      Z.AI API key
  --xiaomi-api-key <key>                   Xiaomi API key
  --minimax-api-key <key>                  MiniMax API key
  --synthetic-api-key <key>                Synthetic API key
  --venice-api-key <key>                   Venice API key
  --opencode-zen-api-key <key>             OpenCode Zen API key
  --gateway-port <port>                    Gateway port
  --gateway-bind <mode>                    Gateway bind: loopback|tailnet|lan|auto|custom
  --gateway-auth <mode>                    Gateway auth: token|password
  --gateway-token <token>                  Gateway token (token auth)
  --gateway-password <password>            Gateway password (password auth)
  --remote-url <url>                       Remote Gateway WebSocket URL
  --remote-token <token>                   Remote Gateway token (optional)
  --tailscale <mode>                       Tailscale: off|serve|funnel
  --tailscale-reset-on-exit                Reset tailscale serve/funnel on exit
  --install-daemon                         Install gateway service
  --no-install-daemon                      Skip gateway service install
  --skip-daemon                            Skip gateway service install
  --daemon-runtime <runtime>               Daemon runtime: node|bun
  --skip-channels                          Skip channel setup
  --skip-skills                            Skip skills setup
  --skip-health                            Skip health check
  --skip-ui                                Skip Control UI/TUI prompts
  --node-manager <name>                    Node manager for skills: npm|pnpm|bun
  --json                                   Output JSON summary (default: false)
  -h, --help                               display help for command

Docs: docs.openclaw.ai/cli/onboard

$

################################################################################################

OPENCLAW_GATEWAY_TOKEN="$(openssl rand -hex 32)"
openclaw onboard

################################################################################################


################################################################################################


################################################################################################


################################################################################################


################################################################################################

```

---
model: sonnet
description: |
  Generates an optimized devcontainer.json for a given project type.
  Invoke when creating a new project that needs a devcontainer from the start.
tools:
  - Read
  - Write
  - Bash
---

## Information to collect

If not provided, ask:
1. Project type (TypeScript/Node, Python, Rust, Go, C++, polyglot...)
2. Required auxiliary services (PostgreSQL, Redis, MongoDB...)
3. Ports to expose
4. GPU needed? (ML with CUDA)

## Recommended base images

| Type | Image | Notes |
|---|---|---|
| Node.js / TypeScript | `mcr.microsoft.com/devcontainers/node:1-22` | Node 22 LTS |
| Python | `mcr.microsoft.com/devcontainers/python:1-3.12` | Python 3.12 |
| Rust | `mcr.microsoft.com/devcontainers/rust:1` | Cargo included |
| Go | `mcr.microsoft.com/devcontainers/go:1-1.22` | Go 1.22 |
| Generic / Debian | `mcr.microsoft.com/devcontainers/base:trixie` | Debian 13 |
| C/C++ | `mcr.microsoft.com/devcontainers/cpp:1` | gcc, cmake, gdb |

## Base template (always include)

```json
{
  "name": "<project-name>",
  "image": "<chosen-image>",

  "features": {},

  "customizations": {
    "vscode": {
      "extensions": [],
      "settings": {}
    }
  },

  "postCreateCommand": "",
  "remoteUser": "vscode",

  "remoteEnv": {
    "ANTHROPIC_API_KEY": "${localEnv:ANTHROPIC_API_KEY}",
    "TAVILY_API_KEY": "${localEnv:TAVILY_API_KEY}",
    "GITHUB_TOKEN": "${localEnv:GITHUB_TOKEN}"
  }
}
```

## VSCode extensions by project type

### TypeScript/Node.js
```json
"extensions": [
  "dbaeumer.vscode-eslint",
  "esbenp.prettier-vscode",
  "prisma.prisma",
  "bradlc.vscode-tailwindcss",
  "ms-vscode.vscode-typescript-next"
]
```

### Python
```json
"extensions": [
  "ms-python.python",
  "ms-python.vscode-pylance",
  "ms-python.black-formatter",
  "charliermarsh.ruff",
  "ms-toolsai.jupyter"
]
```

### Rust
```json
"extensions": [
  "rust-lang.rust-analyzer",
  "tamasfe.even-better-toml",
  "serayuzgur.crates",
  "vadimcn.vscode-lldb"
]
```

## Auxiliary services (docker-compose)

When services are needed, also generate a `docker-compose.yml`:

```yaml
# .devcontainer/docker-compose.yml
services:
  app:
    build:
      context: ..
      dockerfile: .devcontainer/Dockerfile
    volumes:
      - ..:/workspace:cached
    command: sleep infinity
    environment:
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}

  postgres:
    image: ankane/pgvector:v0.5.0
    environment:
      POSTGRES_USER: dev
      POSTGRES_PASSWORD: dev
      POSTGRES_DB: app_db
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine

volumes:
  pgdata:
```

And adapt the `devcontainer.json`:
```json
{
  "dockerComposeFile": "docker-compose.yml",
  "service": "app",
  "workspaceFolder": "/workspace"
}
```

## Generation rules

1. Always pass `ANTHROPIC_API_KEY`, `TAVILY_API_KEY`, and `GITHUB_TOKEN` via `remoteEnv`
2. **Always include the Node.js 22 feature** -- even for Python, Rust, C++, Go. Claude Code and MCP servers (npx) require Node.js:
   ```json
   "ghcr.io/devcontainers/features/node:1": { "version": "22" }
   ```
3. Never hardcode credentials in the file
4. **Do NOT add `install.sh` in postCreateCommand** -- the VSCode dotfiles feature handles this automatically via `dev.containers.dotfilesRepository`
5. Use Microsoft `devcontainers/` images -- they already include base tools
6. For ML projects with GPU: add the NVIDIA device in docker-compose
7. Create the `.devcontainer/` directory if absent
8. Always suggest relevant VSCode extensions

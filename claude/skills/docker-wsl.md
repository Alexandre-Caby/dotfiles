---
name: docker-wsl
description: Common Docker/WSL2 patterns and commands. Reference for recurring container management tasks in this environment.
---

# Docker + WSL2 — Patterns and Commands

## WSL2/Docker Ground Rules

- Always use **Linux paths** in WSL configs (`/home/user/...`)
- Windows files are accessible in WSL via `/mnt/c/Users/...` but **avoid** mounting from there (poor performance)
- Store projects in the WSL filesystem (`~/projects/`) for better I/O performance
- `host.docker.internal` -> access the Windows/WSL host from a container

## Essential Commands

### Container Management
```bash
docker compose up -d                  # Start in background
docker compose up -d --build          # Rebuild + start
docker compose down                   # Stop and remove containers
docker compose down -v                # Same + remove volumes
docker compose restart <service>      # Restart a service
docker compose exec <service> sh      # Shell into a service
docker compose logs -f <service>      # Real-time logs
docker compose ps                     # Service status
```

### Cleanup
```bash
docker system prune                   # Remove unused resources
docker system prune -a                # Remove everything (unused images too)
docker volume prune                   # Remove orphaned volumes
docker image prune                    # Remove dangling images
```

### Debug
```bash
docker inspect <container>            # Full JSON config
docker stats                          # Real-time CPU/RAM usage
docker exec -it <container> sh        # Interactive shell
docker cp <container>:/path ./local   # Copy a file from a container
```

## Docker Networking — Project-Nero Architecture

```bash
# Create the shared network (one-time)
docker network create ai_network

# Check connected containers
docker network inspect ai_network

# Connect an existing container to the network
docker network connect ai_network <container>
```

**Project-Nero startup order:**
1. `AI_lab/` -> Ollama + environments (network created here)
2. `AI_tools/` -> MCP servers Unreal + Blender + Everness + Bridge

## Volumes — Best Practices

```yaml
# Named volume (persistent, managed by Docker)
volumes:
  - pgdata:/var/lib/postgresql/data

# Bind mount from WSL (development)
volumes:
  - ./src:/app/src

# Bind mount from Windows (slow)
volumes:
  - /mnt/c/Users/Alexandre/...:/app  # Avoid
```

## Multi-stage Builds (recommended pattern)

```dockerfile
# TypeScript — multi-stage
FROM node:22-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM node:22-slim AS runtime
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
CMD ["node", "dist/index.js"]

# Rust — multi-stage
FROM rust:1-slim AS builder
WORKDIR /app
COPY . .
RUN cargo build --release

FROM debian:trixie-slim AS runtime
COPY --from=builder /app/target/release/mybinary /usr/local/bin/
CMD ["mybinary"]
```

## Environment Variables — Security

```bash
# .env (never committed, in .gitignore)
POSTGRES_PASSWORD=secret
JWT_SECRET=secret
ANTHROPIC_API_KEY=sk-...

# docker-compose.yml — reference without default value
environment:
  - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}  # Required
  - LOG_LEVEL=${LOG_LEVEL:-info}            # With default
```

## Healthchecks — Always on Critical Services

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
  interval: 10s
  timeout: 5s
  retries: 3
  start_period: 30s
```

## GPU (for Project-Nero — TinyML/Unsloth)

```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: 1
          capabilities: [gpu]
```

Verify NVIDIA Container Toolkit is installed:
```bash
docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi
```

---
name: docker-wsl
description: Patterns et commandes Docker/WSL2 fréquents. Référence pour les tâches récurrentes de gestion de conteneurs dans cet environnement.
---

# Docker + WSL2 — Patterns et commandes

## Règles de base WSL2/Docker

- Toujours utiliser des **chemins Linux** dans les configs WSL (`/home/user/...`)
- Les fichiers Windows sont accessibles dans WSL via `/mnt/c/Users/...` mais **éviter** de monter depuis là (perf médiocre)
- Stocker les projets dans le filesystem WSL (`~/projects/`) pour de meilleures perfs I/O
- `host.docker.internal` → accès à l'hôte Windows/WSL depuis un conteneur

## Commandes essentielles

### Gestion des conteneurs
```bash
docker compose up -d                  # Démarrer en background
docker compose up -d --build          # Rebuild + démarrer
docker compose down                   # Arrêter et supprimer les conteneurs
docker compose down -v                # Idem + supprimer les volumes
docker compose restart <service>      # Redémarrer un service
docker compose exec <service> sh      # Shell dans un service
docker compose logs -f <service>      # Logs en temps réel
docker compose ps                     # État des services
```

### Nettoyage
```bash
docker system prune                   # Supprimer les ressources inutilisées
docker system prune -a                # Tout supprimer (images non utilisées aussi)
docker volume prune                   # Supprimer les volumes orphelins
docker image prune                    # Supprimer les images dangling
```

### Debug
```bash
docker inspect <container>            # Config complète JSON
docker stats                          # Utilisation CPU/RAM en temps réel
docker exec -it <container> sh        # Shell interactif
docker cp <container>:/chemin ./local # Copier un fichier depuis un conteneur
```

## Réseau Docker — Architecture Project-Nero

```bash
# Créer le réseau partagé (une seule fois)
docker network create ai_network

# Vérifier les conteneurs connectés
docker network inspect ai_network

# Connecter un conteneur existant au réseau
docker network connect ai_network <container>
```

**Ordre de démarrage Project-Nero :**
1. `AI_lab/` → Ollama + environnements (réseau créé ici)
2. `AI_tools/` → MCP servers Unreal + Blender + Everness + Bridge

## Volumes — Bonnes pratiques

```yaml
# ✅ Volume nommé (persistent, géré par Docker)
volumes:
  - pgdata:/var/lib/postgresql/data

# ✅ Bind mount depuis WSL (développement)
volumes:
  - ./src:/app/src

# ❌ Bind mount depuis Windows (lent)
volumes:
  - /mnt/c/Users/Alexandre/...:/app  # Éviter
```

## Multi-stage builds (pattern recommandé)

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

## Variables d'environnement — Sécurité

```bash
# .env (jamais commité, dans .gitignore)
POSTGRES_PASSWORD=secret
JWT_SECRET=secret
ANTHROPIC_API_KEY=sk-...

# docker-compose.yml — référencer sans valeur par défaut
environment:
  - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}  # Obligatoire
  - LOG_LEVEL=${LOG_LEVEL:-info}            # Avec défaut
```

## Healthchecks — Toujours sur les services critiques

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
  interval: 10s
  timeout: 5s
  retries: 3
  start_period: 30s
```

## GPU (pour Project-Nero — TinyML/Unsloth)

```yaml
deploy:
  resources:
    reservations:
      devices:
        - driver: nvidia
          count: 1
          capabilities: [gpu]
```

Vérifier NVIDIA Container Toolkit installé :
```bash
docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi
```

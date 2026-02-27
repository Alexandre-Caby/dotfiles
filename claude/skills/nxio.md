# Skill: NXIO — Contexte projet

> ⚠️ Ce fichier est un document vivant. Le mettre à jour à chaque évolution majeure du projet.
> Dernière mise à jour connue : décembre 2024 (MCP UE5 + plugin).
> Nom précédent : Project-Nero / Project-Nero-Everness

## Vue d'ensemble

NXIO est un projet entrepreneurial multi-couches combinant :
- Simulation de monde IA dans Unreal Engine 5
- Agents IA autonomes (Ollama + TinyML)
- Interface hardware (microcontrôleurs, capteurs)
- Tooling MCP pour contrôle UE5/Blender depuis Claude

C'est à la fois un **projet produit** et une **plateforme de recherche**.

---

## Architecture courante

```
┌─────────────────────────────────────────────────────┐
│                    NXIO Platform                     │
├──────────────┬──────────────┬───────────────────────┤
│  Hardware    │  AI Engine   │   3D World             │
│  Layer       │  Layer       │   Layer                │
├──────────────┼──────────────┼───────────────────────┤
│ MCU          │ Ollama       │ Unreal Engine 5        │
│ MicroPython  │ TinyML       │ Blender                │
│ Sensors      │ Unsloth      │ Everness (plugin)      │
│ GPIO         │ TensorFlow   │ Blueprint/C++          │
└──────────────┴──────────────┴───────────────────────┘
              │              │
              ▼              ▼
┌─────────────────────────────────────────────────────┐
│                  MCP Layer (Node.js)                 │
│  unreal-mcp  │  blender-mcp  │  everness-mcp        │
└─────────────────────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────────────────┐
│            Agent Manager (Python + uv)               │
│  Orchestre les agents IA, gère les workflows         │
└─────────────────────────────────────────────────────┘
```

## Repos (organisation GitHub: Project-Nero-Everness)

> Mettre à jour cette liste quand de nouveaux repos sont ajoutés

| Repo | Langage | Rôle |
|---|---|---|
| `unreal-mcp` | Node.js | MCP server — Remote Control API UE5 (port 30010/30020) |
| `blender-mcp` | Python | MCP server — Python addon Blender (port 9876) |
| `everness` | Node.js | MCP server — génération monde procédural |
| `unreal-bridge` | Node.js/Python | Pont Everness ↔ UE5 via Redis |
| `agent-manager` | Python + uv | Orchestration des agents IA |
| *(à compléter)* | | |

## Stack par couche

### MCP Servers (Node.js)

```typescript
// Framework: @modelcontextprotocol/sdk
// Convention tools: snake_case, verb_noun
// Ex: get_actor_list, spawn_blueprint, set_transform

// Port assignments:
// UE5 Remote Control API: 30010 (HTTP), 30020 (WebSocket)
// Blender addon: 9876
// Redis bridge: 6379

// Lancer les MCP:
// docker compose -f docker-compose.mcp.yml up -d
```

### Agent Manager (Python)

```bash
# Package manager: uv
uv run agent_manager.py

# Dépendances clés:
# - ollama (local LLM inference)
# - unsloth (fine-tuning)
# - tensorflow (TinyML)
```

### Unreal Engine 5

```cpp
// Plugins utilisés: Everness (procédural world gen)
// Communication: Remote Control API (HTTP/WebSocket)
// Conventions C++ UE5:
//   - Classes: U (UObject), A (AActor), F (struct), E (enum), I (interface)
//   - Nommage: PascalCase strict
//   - UPROPERTY et UFUNCTION pour l'exposition Blueprint

// Entry points MCP:
// GET  /remote/object/property  → lire une propriété d'acteur
// PUT  /remote/object/property  → modifier une propriété
// POST /remote/object/call      → appeler une fonction Blueprint/C++
```

### Hardware / Microcontrôleur

```python
# MicroPython sur MCU (ESP32/RP2040 selon le composant)
# Pattern: lecture capteur → traitement minimal → envoi UART/I2C

# TinyML embarqué:
# Modèles optimisés avec TensorFlow Lite for Microcontrollers
# Quantification int8 pour contraintes mémoire
```

## Réseau Docker — ai_network

```bash
# Réseau dédié pour tous les services AI/MCP du projet
docker network create ai_network

# Services sur ce réseau:
# - ollama (GPU inference)
# - redis (message broker)
# - agent-manager
# - MCP servers (si dockerisés)

# host.docker.internal → accès à UE5/Blender sur l'hôte Windows
```

## Variables d'environnement

```bash
ANTHROPIC_API_KEY=        # Claude API (agent manager)
OLLAMA_HOST=http://ollama:11434   # Ollama dans Docker
REDIS_URL=redis://redis:6379
UE5_REMOTE_CONTROL_HOST=host.docker.internal
UE5_REMOTE_CONTROL_PORT=30010
BLENDER_PORT=9876
```

## Conventions de développement NXIO

### MCP tools

- Noms en `snake_case`, format `verb_noun` : `spawn_actor`, `get_world_state`
- Descriptions en anglais, précises — elles sont lues par le LLM
- Toujours valider avec Zod avant de transmettre à UE5/Blender
- Gérer les timeouts : UE5 peut être lent au démarrage

### Agent Manager

- Chaque agent = une classe Python avec interface standardisée
- Logging structuré (JSON) pour pouvoir analyser les runs
- Les agents ne doivent pas avoir d'état global — passer le contexte explicitement

### Règle générale

- **Jamais** de logique métier dans les MCP servers — ils sont de purs adaptateurs
- La logique de simulation vit dans l'Agent Manager et les Blueprints UE5
- Les MCP sont remplaçables — l'Agent Manager est le cerveau

---

## ⚠️ Sections à mettre à jour

Quand tu travailles sur NXIO, maintenir ces sections :

1. **Liste des repos** — ajouter les nouveaux repos
2. **Architecture** — modifier le diagramme si de nouvelles couches sont ajoutées
3. **Stack** — mettre à jour les versions et dépendances clés
4. **Variables d'env** — ajouter les nouvelles vars

Commande pour mettre à jour via Claude Code :
```
Update the NXIO skill at ~/.claude/skills/nxio.md with the following changes: [...]
```

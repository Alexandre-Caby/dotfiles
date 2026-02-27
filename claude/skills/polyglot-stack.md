---
name: polyglot-stack
description: Guide de sélection de stack et conventions multi-langages. Référence rapide pour choisir les bons outils selon le contexte sans se répéter.
---

# Polyglot Stack Guide

## Gestionnaires de paquets préférés

| Langage | Gestionnaire | Commande init |
|---|---|---|
| TypeScript/Node | **pnpm** (pas npm, pas yarn) | `pnpm init` |
| Python | **uv** (pas pip direct, pas poetry) | `uv init` |
| Rust | **cargo** (natif) | `cargo new` |
| Go | **go mod** (natif) | `go mod init` |

## Conventions par langage

### TypeScript / Node.js
- **Linter :** ESLint + config stricte
- **Format :** Prettier (`.prettierrc` à la racine)
- **Types :** strict mode dans `tsconfig.json`
- **Build :** tsup pour les libs, vite pour les apps, tsc pour les serveurs simples
- **Tests :** Vitest (pas Jest — plus rapide, même API)
- **Validation runtime :** Zod
- **ORM :** Prisma pour SQL, Mongoose si MongoDB obligatoire

```json
// tsconfig.json minimal strict
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true
  }
}
```

### Python
- **Linter/Format :** Ruff (remplace Black + Flake8 + isort)
- **Types :** mypy en mode strict, ou pyright
- **Tests :** pytest + pytest-cov
- **Validation :** Pydantic v2
- **Gestion env :** uv + `pyproject.toml` (pas de `requirements.txt` brut)
- **ML stack :** PyTorch (pas TensorFlow sauf contrainte existante)

```toml
# pyproject.toml minimal
[tool.ruff]
line-length = 88
[tool.ruff.lint]
select = ["E", "F", "I", "N", "UP"]
[tool.mypy]
strict = true
```

### Rust
- **Format :** `rustfmt` (automatique)
- **Lint :** `clippy` (traiter les warnings comme des erreurs)
- **Tests :** intégrés (`#[test]`), critiques avec `criterion`
- **Erreurs :** `thiserror` pour les libs, `anyhow` pour les binaires
- **Async :** Tokio
- **Serialisation :** Serde

```rust
// Clippy strict dans Cargo.toml
[lints.clippy]
all = "warn"
pedantic = "warn"
```

### Go
- **Format :** `gofmt` / `goimports` (automatique)
- **Lint :** `golangci-lint`
- **Tests :** stdlib `testing` + `testify`
- **HTTP :** stdlib + `chi` pour le routing, ou `fiber` si perf critique
- **Erreurs :** toujours wrapper avec contexte (`fmt.Errorf("doing X: %w", err)`)

## Combos de stacks validés

### Web fullstack moderne (style Syplay/EDA)
```
Frontend: Vite + React + TypeScript + Tailwind
Backend:  Node.js + TypeScript + Prisma/Drizzle + Zod
DB:       PostgreSQL (+ pgvector si embeddings) + Redis (cache/sessions)
Proxy:    Nginx
Test:     Vitest + Playwright
```

### Service ML/AI (style Project-Nero AI)
```
API:      FastAPI (Python) — si API HTTP nécessaire
ML:       PyTorch + Transformers/Diffusers
Data:     Pandas + Polars (Polars pour gros volumes)
Infra:    Ollama (LLM local) + Redis (queue)
Test:     pytest + hypothesis
```

### CLI performant
```
Simple:   Go (binaire unique, cross-platform facile)
Complexe: Rust (performance max, sécurité mémoire)
Scripting: Bash (si < 100 lignes et pas de logique)
```

### Monorepo polyglot (style EDA étendu)
```
Orchestration: pnpm workspaces / Turborepo
TS packages:  tsup pour build
Rust crate:   via napi-rs si FFI avec Node, sinon standalone
Shared types: package dédié (shared-schema pattern)
```

## Ce qu'il ne faut jamais faire

- Mixer pnpm et npm dans le même projet (lockfile conflict)
- Utiliser `pip install` directement dans un projet avec uv
- Créer un backend Python/Flask pour une API simple si TypeScript suffit
- Ignorer les type hints en Python dès qu'on est "pressé"
- Committer `node_modules/`, `.venv/`, `target/` dans git

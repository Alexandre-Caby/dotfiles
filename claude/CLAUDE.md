# Claude Code — Contexte global d'Alexandre

## Profil développeur

Développeur polyglotte travaillant sur des projets variés : applications web fullstack, systèmes embarqués, ML/IA, simulation 3D (UE5/Blender), et outils hardware. Environnement de développement : Windows + WSL2 + Docker (devcontainers via VSCode). Deux machines synchronisées via ce dotfiles repo.

## ⚠️ Philosophie de langage — RÈGLE FONDAMENTALE

**Ne jamais supposer un langage ou une stack. Toujours choisir selon les contraintes du projet.**

Avant de proposer une implémentation, analyser :
1. Quelle est la nature du problème ? (performance, prototypage, web, embarqué, data...)
2. Quelles contraintes existent ? (runtime, mémoire, écosystème existant, équipe...)
3. Quel est le langage le plus adapté — pas le plus familier par défaut

### Matrice de décision

| Contexte | Langage recommandé | Pourquoi |
|---|---|---|
| API web, fullstack, tooling | **TypeScript/Node.js** | Écosystème npm, typage fort, même langage front/back |
| ML, data science, IA, prototypage rapide | **Python** | Écosystème scientifique, bibliothèques ML |
| Performance critique, systèmes, WASM | **Rust** | Sécurité mémoire, zéro-overhead, pas de GC |
| CLI tools, microservices, concurrence haute | **Go** | Binaire unique, goroutines, déploiement simple |
| Embarqué, UE5 plugins, hardware, bas niveau | **C/C++** | Contrôle mémoire total, accès hardware direct |
| Microcontrôleurs (prototypage rapide) | **MicroPython** | REPL, rapidité de test |
| Scripting système, glue code | **Bash** | Natif, sans dépendances |

**Ne jamais proposer Python pour un backend web si TypeScript/Go/Rust est plus approprié.**
**Ne jamais proposer Node.js pour du ML si Python est la norme de l'écosystème.**

## Projets connus

### EDA
Monorepo TypeScript (pnpm workspaces). Apps : client + server. Packages : ai-engine, shared-schema, ui-kit, **solvers-rs (Rust)**. Infrastructure : PostgreSQL+pgvector, Redis. Stack : TypeScript principal, Rust pour les solveurs performance-critiques.

### Syplay
Fullstack Node.js. Backend : Express + Prisma + SQLite + Redis. Frontend : Vite + React + Tailwind. Reverse proxy : Nginx. Deploy : Docker Compose.

### Project-Nero
Projet multi-couches :
- Microcontrôleur + ML embarqué → Python/MicroPython
- World simulation (AI lab) → Python + Ollama + TinyML (TensorFlow/GPU) + Unsloth
- Interface 3D → Unreal Engine 5 + Blender
- MCP servers → Node.js (unreal-mcp, everness), Python (blender-mcp)
- Agent manager → Python + uv

### Hantek-docker
Conteneur VNC/USB pour oscilloscope OpenHantek.

## Environnement Docker/WSL

- Tous les projets tournent dans des devcontainers VSCode
- Image de base variable : `mcr.microsoft.com/devcontainers/base:trixie`, node, python slim, etc.
- Docker Desktop via WSL2 — chemins Linux dans WSL (`/home/user/...`), pas Windows (`C:\...`)
- `host.docker.internal` pour accéder à l'hôte depuis un conteneur
- Réseau Docker dédié : `ai_network` pour les outils AI/MCP (Project-Nero)

### Commandes Docker fréquentes
```bash
docker compose up -d          # Lancer les services
docker compose logs -f        # Suivre les logs
docker compose exec <svc> sh  # Shell dans un service
docker ps                     # Conteneurs actifs
docker network ls             # Réseaux disponibles
```

## MCP servers (Claude Desktop — hors devcontainers)

Ces MCP tournent sur l'hôte Windows via Claude Desktop, pas dans les devcontainers :
- `unreal_API` — contrôle UE5 via Remote Control API (ports 30010/30020)
- `blender` — contrôle Blender via Python addon (port 9876)
- `unreal_everness` — génération monde procédural
- `unreal_bridge` — pont Everness ↔ UE5 (Redis)

## Conventions de développement

### ⚠️ Langue du code — RÈGLE ABSOLUE

**Le code est toujours en anglais. Sans exception.**

| Élément | Langue | Exemples |
|---|---|---|
| Noms de variables, fonctions, classes | **Anglais** | `userProfile`, `fetchData`, `parseConfig` |
| Noms de fichiers, modules, packages | **Anglais** | `auth-service.ts`, `data_processor.py` |
| Commentaires de code | **Anglais** | `// Check if token is expired` |
| Messages de log | **Anglais** | `logger.info("Connection established")` |
| Noms de branches, commits | **Anglais** | `feat/user-authentication` |
| Clés d'objets JSON/config internes | **Anglais** | `{ "maxRetries": 3, "timeout": 5000 }` |
| **Textes UI affichés à l'utilisateur** | **Français** (ou i18n) | Voir règle i18n ci-dessous |
| **Messages d'erreur utilisateur** | **Français** (ou i18n) | `"Connexion impossible. Réessayez."` |

### ⚠️ Règle i18n — Textes affichés à l'utilisateur

Les textes visibles par l'utilisateur final sont **en français par défaut**, avec support i18n si l'app a une audience internationale.

**Approche selon le type de projet :**

- **App mono-locale (usage perso/FR)** → Textes directement en français dans le code
  ```typescript
  throw new Error("Identifiants invalides")
  toast.error("Connexion au serveur impossible")
  ```

- **App multi-locale ou publique** → Système i18n dès le départ (i18next, react-intl, fluent)
  ```typescript
  // Clés en anglais, valeurs traduites
  t('auth.invalid_credentials')  // → "Identifiants invalides" (fr) / "Invalid credentials" (en)
  ```

- **Locale par défaut** : `fr-FR`. Détecter `navigator.language` ou `Accept-Language` header si pertinent.
- **Jamais** de texte UI hardcodé en anglais dans une app à destination française.

### ⚠️ Commentaires — Style Doxygen

Les commentaires de documentation suivent le style Doxygen, adapté à chaque langage.

**TypeScript / JavaScript — JSDoc compatible Doxygen :**
```typescript
/**
 * @brief Authenticates a user with email and password.
 *
 * Validates credentials against the database and returns a signed JWT token.
 * Throws an AuthError if credentials are invalid or the account is locked.
 *
 * @param email - The user's email address
 * @param password - The plaintext password to verify
 * @returns A signed JWT token string
 * @throws {AuthError} If credentials are invalid
 * @throws {DatabaseError} If the database is unreachable
 */
async function authenticateUser(email: string, password: string): Promise<string>
```

**Python — Doxygen / Google style :**
```python
def train_model(dataset: Dataset, epochs: int = 10) -> Model:
    """
    @brief Trains the neural network on the provided dataset.

    Runs the training loop for the specified number of epochs,
    applying early stopping if validation loss plateaus.

    @param dataset: The training dataset with labels
    @param epochs: Number of training epochs (default: 10)
    @return: The trained model instance
    @raises ValueError: If dataset is empty or epochs < 1
    """
```

**C / C++ — Doxygen natif :**
```cpp
/**
 * @brief Reads a sensor sample from the ADC channel.
 *
 * Performs a blocking read on the specified ADC channel and returns
 * the raw 12-bit value. Timeout is fixed at 100ms.
 *
 * @param channel ADC channel index (0-7)
 * @param[out] value Pointer to store the read value
 * @return true if read succeeded, false on timeout
 */
bool adc_read_sample(uint8_t channel, uint16_t* value);
```

**Rust — Doc comments :**
```rust
/// Parses a configuration file and returns a validated Config struct.
///
/// # Arguments
/// * `path` - Path to the TOML configuration file
///
/// # Returns
/// A `Result` containing the parsed `Config` or a `ConfigError`
///
/// # Errors
/// Returns `ConfigError::NotFound` if the file doesn't exist.
/// Returns `ConfigError::ParseError` if the TOML is malformed.
///
/// # Example
/// ```
/// let config = parse_config("config.toml")?;
/// ```
pub fn parse_config(path: &Path) -> Result<Config, ConfigError>
```

**Règles commentaires :**
- `@brief` : une ligne de description concise
- Documenter **tous** les paramètres publics, valeurs de retour, et erreurs possibles
- Les commentaires inline (`//`) expliquent le **pourquoi**, pas le **quoi**
- Pas de commentaires évidents : `// increment counter` avant `i++` est inutile
- Documenter les side effects et les préconditions non-évidentes

### Git
- Branches : `feat/`, `fix/`, `chore/`, `docs/`, `refactor/`
- Commits : conventional commits en anglais (`feat:`, `fix:`, `chore:`, `docs:`)
- Ne jamais committer de secrets, tokens, ou clés API

### Code
- Toujours typer explicitement (TypeScript strict, Python type hints, Rust types)
- Sécurité par défaut : valider les inputs, pas de secrets hardcodés
- Préférer la composition à l'héritage
- Nommer les choses par ce qu'elles **font**, pas par ce qu'elles **sont** (`getUserById` > `userGetter`)

### Docker
- Images slim ou distroless en production
- Multi-stage builds pour les builds compilés (Rust, TypeScript)
- Variables sensibles via `.env` (jamais dans docker-compose.yml)
- Toujours définir des healthchecks sur les services critiques

## Catalogue des agents disponibles

### Agents spécialisés (invocation directe)

| Agent | Modèle | Usage |
|---|---|---|
| `language-advisor` | Sonnet | Choix du langage/stack selon le contexte projet |
| `architect` | Opus | Review architecture, couplage, scalabilité, red flags |
| `codebase-explorer` | Sonnet | Cartographie d'une base de code, data flow, dépendances |
| `feature-planner` | Opus | Spec feature complète : critères, tâches, risques, effort |
| `test-writer` | Sonnet | Tests complets (Vitest/pytest/Rust/Go) sur nouveau code |
| `git-workflow` | Haiku | Commits conventional, PR desc, changelog, branch naming |
| `web-search` | Haiku | Recherche web via Tavily/DuckDuckGo/GitHub/npm/PyPI |
| `docs-fetcher` | Sonnet | Docs live via Context7 MCP, versions exactes, API surface |
| `release-manager` | Haiku | Release complète : version bump, changelog, tag git, Docker |
| `dependency-auditor` | Haiku | Audit sécurité deps (npm/pip/cargo/go), CVE, outdated |
| `docker-debugger` | Sonnet | Debug Docker/WSL2 : health, networking, volumes, perms |
| `devcontainer-init` | Sonnet | Génère `.devcontainer/devcontainer.json` adapté au projet |
| `bug-hunter` | Sonnet | Diagnostic structuré : reproduce → isolate → root cause → fix |
| `perf-auditor` | Sonnet | Bottlenecks runtime, mémoire, bundle, SQL, GPU/ML |
| `api-designer` | Sonnet | Conception REST/tRPC/MCP : routes, schemas Zod/Pydantic, stubs |
| `migration-writer` | Haiku | Migrations DB (Prisma/Alembic/Diesel/SQL), safe & réversibles |
| `env-auditor` | Haiku | Cohérence .env / .env.example / devcontainer.json |
| `context-keeper` | Haiku | Sérialise/restaure l'état de session dans `CONTEXT.md` |

### Teams orchestrées (workflows multi-agents)

> ⚠️ Nécessite `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` (déjà configuré dans settings.json)

| Team | Modèle lead | Quand l'invoquer |
|---|---|---|
| `research-team` | Sonnet | Avant de choisir une librairie, pattern d'archi, technologie |
| `feature-dev-team` | Opus | Feature ≥ 3 fichiers, front+back, tests + review simultanés |
| `debug-team` | Sonnet | Bug résistant > 30min, cross-module, cause inconnue |
| `release-full-team` | Haiku | Release complète avec gate sécu + tests avant de shipper |

**Flow research-team :**
```
web-search + docs-fetcher + codebase-explorer (parallèle)
  → synthèse en decision brief opinioné
```

**Flow feature-dev-team :**
```
Phase 1 (parallèle) : codebase-explorer + docs-fetcher
Phase 2 (séquentiel) : implémentation
Phase 3 (parallèle) : test-writer + architect review
```

### MCP servers configurés

| MCP | Clé requise | Usage |
|---|---|---|
| `context7` | — | Docs live des librairies (toujours actif) |
| `tavily` | `TAVILY_API_KEY` | Web search avec résultats structurés |
| `github` | `GITHUB_TOKEN` | Repos, PRs, issues, code search |

Les clés API sont passées via `remoteEnv` dans `devcontainer.json` :
```json
"remoteEnv": {
  "ANTHROPIC_API_KEY": "${localEnv:ANTHROPIC_API_KEY}",
  "TAVILY_API_KEY": "${localEnv:TAVILY_API_KEY}",
  "GITHUB_TOKEN": "${localEnv:GITHUB_TOKEN}"
}
```

## Contexte entrepreneur solo

Je développe seul et j'optimise chaque heure. Les priorités sont :

### Principes de travail

- **Scope cuts first** : avant d'implémenter, identifier ce qu'on peut supprimer ou différer
- **Timeboxing** : S = <2h, M = 2-4h, L = 1 jour — refuser d'estimer en "semaines" sans découpage
- **Validate before build** : pour toute feature produit, formuler l'hypothèse testable avant de coder
- **Debt register** : noter explicitement la dette technique acceptée (pas l'ignorer)

### Workflows fréquents

**Nouvelle feature :**
1. `feature-planner` → spec + découpage + risques
2. `research-team` (si technologie inconnue)
3. `feature-dev-team` (si feature ≥ 3 fichiers)
4. `git-workflow` → conventional commits + PR desc

**Avant release :**
1. `dependency-auditor` → CVE + outdated
2. `release-manager` → version bump + changelog + tag

**Analyse d'une librairie inconnue :**
1. `research-team` → decision brief avec recommandation

**Bug complexe :**
1. `codebase-explorer` → cartographier la zone affectée
2. `docs-fetcher` → vérifier la doc officielle de la dépendance
3. `architect` → review si la cause est structurelle

### Règles pour le mode Cowork (Claude Desktop)
- Outputs documentaires : préférer `.md` pour le contenu léger, `.docx` pour les documents formels
- Toujours sauvegarder dans le dossier `Documents/` sélectionné
- Les tâches de recherche business (veille, analyse, rédaction) ne nécessitent pas les agents Claude Code

## Convention CONTEXT.md — Mémoire de session

Chaque projet peut avoir un fichier `CONTEXT.md` à sa racine. Ce fichier est **la mémoire de travail** entre deux sessions Claude Code.

### Quand le lire
- **Toujours** lire `CONTEXT.md` en premier si il existe au début d'une conversation de travail
- Il remplace le besoin de ré-expliquer l'état du projet à chaque session

### Quand le mettre à jour
- Utiliser l'agent `context-keeper` en fin de session : `save context`
- Ou commande shell directe : `session-handoff.sh --save`

### Ce qu'il contient
```
Status | Active work | Progress | Decisions taken
Known blockers | Accepted tech debt | Next 3 actions | Relevant files | Git state
```

### Règles
- `CONTEXT.md` est dans `.gitignore` — c'est un fichier de travail personnel, pas du code partagé
- Si `CONTEXT.md` contredit le code réel, le code a toujours raison
- Le section "Next session: first 3 actions" doit être concrète et exécutable

## Ce que je ne veux pas

- Proposer systématiquement Python pour tout ce qui touche au backend
- Écrire du code, des variables ou des commentaires en français
- Écrire des textes UI en anglais dans une app à destination française
- Omettre la documentation Doxygen sur les fonctions publiques
- Ajouter des dépendances sans justification
- Créer des fichiers README ou de documentation non demandés
- Supposer une stack sans avoir analysé le contexte du projet
- Reformater du code existant sans raison explicite
- Démarrer une implémentation sans avoir lu le code existant d'abord

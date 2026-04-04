# Init — Bootstrap d'un nouveau projet avec devcontainer

Initialise un projet complet avec devcontainer, structure de base, et configuration Claude Code.

## Paramètre

$ARGUMENTS = stack du projet (ex: "node", "python", "rust", "full", "c-embedded", "base", "go")

## Agents auto-activés

- **`language-advisor`** — si le stack n'est pas spécifié, analyser le contexte pour recommander
- **`devcontainer-init`** — génération du devcontainer.json adapté

## Étapes

### 1. Détecter ou demander le stack

Si `$ARGUMENTS` est vide, détecter via les fichiers existants :
- `package.json` → node
- `pyproject.toml` / `requirements.txt` → python
- `Cargo.toml` → rust
- `CMakeLists.txt` / `Makefile` avec arm-none-eabi → c-embedded
- Plusieurs langages → full

### 2. Créer la structure de base

```bash
mkdir -p .devcontainer src tests docs
```

### 3. Générer le devcontainer.json

Utiliser l'agent `devcontainer-init` pour générer le fichier. Se baser sur les templates existants :

| Stack | Template source |
|---|---|
| `node` | `~/dotfiles/templates/devcontainer-node.json` |
| `python` | `~/dotfiles/templates/devcontainer-python.json` |
| `rust` | `~/dotfiles/templates/devcontainer-rust.json` |
| `c-embedded` | `~/dotfiles/templates/devcontainer-c-embedded.json` |
| `full` / polyglot | `~/dotfiles/templates/devcontainer-full.json` |
| `base` / `go` / autre | `~/dotfiles/templates/devcontainer-base.json` (+ features à décommenter) |

Règles critiques (toujours appliquer) :
- **ANTHROPIC_API_KEY**, **TAVILY_API_KEY**, **GITHUB_TOKEN** dans remoteEnv
- Feature **Node.js 22** obligatoire dans TOUS les templates (requis pour Claude Code + MCP)
- Extensions VSCode adaptées au stack
- `remoteUser: "vscode"`
- NE PAS mettre `install.sh` dans postCreateCommand (VSCode dotfiles feature s'en charge)

### 4. Générer le .mcp.json projet (si pertinent)

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/sequential-thinking"]
    }
  }
}
```

### 5. Générer les fichiers de config de base

Selon le stack :

**Node/TypeScript** :
- `.prettierrc` (semi: false, singleQuote: true)
- `tsconfig.json` (strict: true)
- `.eslintrc.json`
- `vitest.config.ts`

**Python** :
- `pyproject.toml` (ruff, pytest, uv)
- `ruff.toml`

**Rust** :
- `clippy.toml`
- `rustfmt.toml`

**C/Embedded** :
- `.clang-format`
- `CMakeLists.txt` (base)

### 6. Créer le CLAUDE.md projet

Créer un `CLAUDE.md` à la racine du projet :

```markdown
# [Nom du projet]

## Description
[À compléter]

## Stack
- Langage : [détecté]
- Framework : [détecté ou à compléter]
- Tests : [runner détecté]

## Structure
[arborescence générée]

## Conventions spécifiques au projet
[À compléter — les conventions globales s'appliquent via ~/.claude/CLAUDE.md]
```

### 7. Git init + premier commit

```bash
git init
git add -A
git commit -m "feat: initial project setup with devcontainer

- devcontainer.json configured for [stack]
- Claude Code config (CLAUDE.md, .mcp.json)
- Linting and formatting config
- Test runner configured

Co-Authored-By: Claude <noreply@anthropic.com>"
```

## Format de sortie

```
✅ Projet initialisé — [stack]

Fichiers créés :
  .devcontainer/devcontainer.json
  CLAUDE.md
  .mcp.json
  [autres fichiers selon stack]

Prochaine étape : ouvrir dans VSCode → "Reopen in Container"
```

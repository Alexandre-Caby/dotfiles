# Skill: Dotfiles Authoring

Guide for adding new agents, teams, skills, and MCP servers to `~/.claude/`.
Read this before creating any new component for the Claude Code environment.

## Où mettre quoi

```
~/.claude/
├── agents/
│   ├── my-agent.md          ← agent spécialisé
│   └── teams/
│       └── my-team.md       ← orchestration multi-agents
├── skills/
│   └── my-skill.md          ← savoir métier ou conventions
└── settings.json            ← permissions, hooks, env vars
```

---

## Créer un Agent

### Template minimal

```markdown
---
name: agent-name                    # kebab-case, unique
description: |
  One paragraph explaining WHEN to invoke this agent.
  Be specific — this description is used by Claude to decide whether to spawn it.
  Include: invocation patterns, what it does, what it does NOT do.
  Examples:
  - "analyze X"
  - "when Y happens"
  - "generate Z"
tools:
  - Read
  - Bash
  - Write
  - Edit
  - Glob
  - Grep
model: claude-haiku-4-5            # voir choix de modèle ci-dessous
---

[Instructions de comportement de l'agent — en prose ou sections]
```

### Choix du modèle

| Modèle | Quand l'utiliser | Coût relatif |
|---|---|---|
| `claude-haiku-4-5` | Tâches répétitives, formatage, commits, audit simple | $ |
| `claude-sonnet-4-5` | Analyse, exploration, génération de code, debug | $$ |
| `claude-opus-4-5` | Architecture, décisions complexes, spec produit | $$$$ |

> Règle : toujours choisir le modèle le moins cher qui fait le job.
> Un agent git-commit n'a pas besoin d'Opus.

### Outils disponibles

```yaml
# Lecture seule
tools: [Read, Bash, Glob, Grep]

# Création/modification de fichiers
tools: [Read, Write, Edit, Bash, Glob, Grep]

# Orchestration (pour les teams seulement)
tools: [Task, Read, Bash]

# Accès MCP (contexte7, tavily, github)
tools: [mcp__context7__resolve-library-id, mcp__context7__get-library-docs]
```

### Pièges à éviter

- **Description trop vague** → "Helps with code" ne sera jamais invoqué correctement
- **Trop d'outils déclarés** → déclarer uniquement ce dont l'agent a besoin
- **Pas de règles de comportement** → l'agent sans règles dérive sur des cas limites
- **Modèle trop puissant** → Haiku pour les tâches mécaniques, Opus pour la réflexion profonde

### Structure d'un bon agent

```markdown
## Étapes (ou phases)
[Numérotées, séquentielles — l'agent suit dans l'ordre]

## Output format
[Format exact de ce que l'agent produit — pas de surprise]

## Rules
[Liste courte de règles absolues — ce que l'agent ne doit jamais faire]
```

---

## Créer une Team

Une team est un agent dont le rôle est de **spawner d'autres agents en parallèle** et de synthétiser leurs résultats. Elle vit dans `agents/teams/`.

### Contraintes importantes

- Les subagents **ne peuvent pas spawner d'autres subagents** — la team est le seul niveau d'orchestration
- La team a besoin de l'outil `Task` dans ses outils
- Requiert `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` dans settings.json (déjà configuré)

### Template

```markdown
---
name: my-team
description: |
  Orchestrates [A], [B], [C] agents in parallel for [use case].
  Use when: [condition plus complexe qu'un seul agent].
tools:
  - Task
  - Read
  - Bash
model: claude-sonnet-4-5
---

## Phase 1 — Parallèle

Spawn simultaneously:

**Agent 1 — [agent-name]**
[Prompt exact pour cet agent]

**Agent 2 — [agent-name]**
[Prompt exact pour cet agent]

## Phase 2 — Séquentiel (après retour de la Phase 1)

[Ce qui se passe une fois les résultats des agents parallèles reçus]

## Output

[Format de la synthèse finale]
```

### Pattern de spawn

```markdown
Spawn these agents at the same time:

**Agent: codebase-explorer**
Prompt: "Map the authentication module, focus on JWT handling and session management."

**Agent: docs-fetcher**
Prompt: "Fetch docs for @auth/core v1.2.3, specifically token rotation and refresh."
```

---

## Créer un Skill

Un skill est du markdown libre — pas de frontmatter. C'est du savoir opinioné.

### Structure recommandée

```markdown
# Skill: [Nom]

[1-2 phrases : quand lire ce skill, quel problème il résout]

## Principe fondamental
[La règle la plus importante — avant tout le reste]

## Patterns positifs ✅
[Ce qu'on fait — avec exemples de code]

## Anti-patterns ❌
[Ce qu'on ne fait pas — avec exemples de ce qu'on évite]

## Référence rapide
[Tableau ou liste pour décision rapide]

## ⚠️ Règles absolues
[Courte liste — les invariants qui ne changent jamais]
```

### Taille idéale

- **Trop court** (< 50 lignes) : pas assez de contexte, ne change pas le comportement
- **Idéal** (100-300 lignes) : couvre les cas courants, lisible en < 2 minutes
- **Trop long** (> 500 lignes) : dilue l'attention, sera partiellement ignoré

### Skills à créer vs ne pas créer

✅ **Créer un skill pour :**
- Des conventions qui s'appliquent à plusieurs projets (API, tests, sécurité)
- Un projet spécifique avec une architecture complexe (NXIO)
- Une stack technique peu connue (MicroPython, UE5 C++)

❌ **Ne pas créer un skill pour :**
- Des choses dans CLAUDE.md (règles globales → CLAUDE.md, pas un skill)
- Des procédures one-shot → mettre dans un agent
- Des références que tu n'utiliseras jamais (duplication de doc)

---

## Ajouter un MCP Server

Les MCP servers sont configurés dans `~/.claude/mcp.json` (géré par `claude mcp add`).

### Via install.sh (recommandé pour les MCP globaux)

```bash
# Dans install.sh, section MCP servers :
claude mcp add --scope user my-server \
  -e API_KEY="$MY_API_KEY" \
  -- npx -y @vendor/mcp-server-name
```

### Via projet (.mcp.json dans le repo)

```json
{
  "mcpServers": {
    "my-server": {
      "command": "npx",
      "args": ["-y", "@vendor/mcp-server-name"],
      "env": {
        "API_KEY": "${MY_API_KEY}"
      }
    }
  }
}
```

### Conventions tools MCP

```typescript
// Nommage: snake_case, verb_noun
{
  name: "get_actor_transform",    ✅
  name: "list_blueprint_classes", ✅
  name: "getTransform",           ❌ (camelCase)
  name: "actor",                  ❌ (pas de verbe)
}

// Description: anglais, précise, décrit ce que l'outil fait ET ses paramètres clés
{
  description: "Returns the world transform (location, rotation, scale) of an actor by its label.",
  // Pas: "Gets actor info" (trop vague)
}
```

Pour créer un MCP server de A à Z, lire le skill `mcp-builder` (disponible dans les skills Cowork).

---

## Checklist avant de commiter un nouveau composant

- [ ] Le nom est en kebab-case et unique
- [ ] La description dit clairement **quand** l'invoquer (pas juste ce qu'il fait)
- [ ] Le modèle est le moins cher suffisant pour la tâche
- [ ] Les outils sont limités au strict nécessaire
- [ ] L'output format est documenté
- [ ] Les règles (`## Rules`) listent les invariants
- [ ] Le CLAUDE.md est mis à jour avec le nouveau composant dans le catalogue

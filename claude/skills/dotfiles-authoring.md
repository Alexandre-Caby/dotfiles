# Skill: Dotfiles Authoring

Guide for adding new agents, teams, skills, and MCP servers to `~/.claude/`.
Read this before creating any new component for the Claude Code environment.

## Where to Put What

```
~/.claude/
├── agents/
│   ├── my-agent.md          <- specialized agent
│   └── teams/
│       └── my-team.md       <- multi-agent orchestration
├── skills/
│   └── my-skill.md          <- domain knowledge or conventions
└── settings.json            <- permissions, hooks, env vars
```

---

## Creating an Agent

### Minimal Template

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
model: claude-haiku-4-5            # see model selection below
---

[Agent behavior instructions — in prose or sections]
```

### Model Selection

| Model | When to Use | Relative Cost |
|---|---|---|
| `claude-haiku-4-5` | Repetitive tasks, formatting, commits, simple audits | $ |
| `claude-sonnet-4-5` | Analysis, exploration, code generation, debugging | $$ |
| `claude-opus-4-5` | Architecture, complex decisions, product specs | $$$$ |

> Rule: always pick the cheapest model that gets the job done.
> A git-commit agent does not need Opus.

### Available Tools

```yaml
# Read-only
tools: [Read, Bash, Glob, Grep]

# File creation/modification
tools: [Read, Write, Edit, Bash, Glob, Grep]

# Orchestration (teams only)
tools: [Task, Read, Bash]

# MCP access (context7, tavily, github)
tools: [mcp__context7__resolve-library-id, mcp__context7__get-library-docs]
```

### Pitfalls to Avoid

- **Vague description** -> "Helps with code" will never be invoked correctly
- **Too many tools declared** -> only declare what the agent actually needs
- **No behavior rules** -> an agent without rules drifts on edge cases
- **Overpowered model** -> Haiku for mechanical tasks, Opus for deep reasoning

### Structure of a Good Agent

```markdown
## Steps (or phases)
[Numbered, sequential — the agent follows them in order]

## Output format
[Exact format of what the agent produces — no surprises]

## Rules
[Short list of absolute rules — what the agent must never do]
```

---

## Creating a Team

A team is an agent whose role is to **spawn other agents in parallel** and synthesize their results. It lives in `agents/teams/`.

### Important Constraints

- Subagents **cannot spawn other subagents** — the team is the only orchestration level
- The team needs the `Task` tool in its tool list
- Requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in settings.json (already configured)

### Template

```markdown
---
name: my-team
description: |
  Orchestrates [A], [B], [C] agents in parallel for [use case].
  Use when: [condition more complex than a single agent].
tools:
  - Task
  - Read
  - Bash
model: claude-sonnet-4-5
---

## Phase 1 — Parallel

Spawn simultaneously:

**Agent 1 — [agent-name]**
[Exact prompt for this agent]

**Agent 2 — [agent-name]**
[Exact prompt for this agent]

## Phase 2 — Sequential (after Phase 1 returns)

[What happens once the parallel agents' results are received]

## Output

[Format of the final synthesis]
```

### Spawn Pattern

```markdown
Spawn these agents at the same time:

**Agent: codebase-explorer**
Prompt: "Map the authentication module, focus on JWT handling and session management."

**Agent: docs-fetcher**
Prompt: "Fetch docs for @auth/core v1.2.3, specifically token rotation and refresh."
```

---

## Creating a Skill

A skill is free-form markdown — no frontmatter. It is opinionated knowledge.

### Recommended Structure

```markdown
# Skill: [Name]

[1-2 sentences: when to read this skill, what problem it solves]

## Core Principle
[The most important rule — before everything else]

## Positive Patterns
[What we do — with code examples]

## Anti-patterns
[What we avoid — with examples of what not to do]

## Quick Reference
[Table or list for fast decision-making]

## Absolute Rules
[Short list — invariants that never change]
```

### Ideal Size

- **Too short** (< 50 lines): not enough context, won't change behavior
- **Ideal** (100-300 lines): covers common cases, readable in < 2 minutes
- **Too long** (> 500 lines): dilutes attention, will be partially ignored

### Skills to Create vs Not Create

**Create a skill for:**
- Conventions that apply across multiple projects (API, tests, security)
- A specific project with complex architecture (NXIO)
- A less common tech stack (MicroPython, UE5 C++)

**Do not create a skill for:**
- Things that belong in CLAUDE.md (global rules -> CLAUDE.md, not a skill)
- One-shot procedures -> put those in an agent
- References you will never use (documentation duplication)

---

## Adding an MCP Server

MCP servers are configured in `~/.claude/mcp.json` (managed by `claude mcp add`).

### Via install.sh (recommended for global MCPs)

```bash
# In install.sh, MCP servers section:
claude mcp add --scope user my-server \
  -e API_KEY="$MY_API_KEY" \
  -- npx -y @vendor/mcp-server-name
```

### Via project (.mcp.json in the repo)

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

### MCP Tool Conventions

```typescript
// Naming: snake_case, verb_noun
{
  name: "get_actor_transform",    // correct
  name: "list_blueprint_classes", // correct
  name: "getTransform",           // wrong (camelCase)
  name: "actor",                  // wrong (no verb)
}

// Description: English, precise, describes what the tool does AND its key parameters
{
  description: "Returns the world transform (location, rotation, scale) of an actor by its label.",
  // Not: "Gets actor info" (too vague)
}
```

To create an MCP server from scratch, read the `mcp-builder` skill (available in Cowork skills).

---

## Checklist Before Committing a New Component

- [ ] Name is kebab-case and unique
- [ ] Description clearly states **when** to invoke (not just what it does)
- [ ] Model is the cheapest one sufficient for the task
- [ ] Tools are limited to the strict minimum
- [ ] Output format is documented
- [ ] Rules (`## Rules`) list the invariants
- [ ] CLAUDE.md is updated with the new component in the catalog

---
model: haiku
description: |
  Audits environment variable consistency: .env vs .env.example,
  devcontainer.json remoteEnv, and code usage.
tools:
  - Read
  - Bash
  - Glob
  - Grep
---

## Step 1: Collect all env var references

```bash
# Node.js / TypeScript
grep -r "process\.env\." --include="*.ts" --include="*.js" -h . \
  | grep -oP 'process\.env\.\K[A-Z_]+' | sort -u

# Python
grep -r "os\.environ\|os\.getenv\|settings\." --include="*.py" -h . \
  | grep -oP '(?:os\.environ\.get|os\.getenv|os\.environ)\(["\x27]\K[A-Z_]+' | sort -u

# Rust (.env via dotenvy/dotenv)
grep -r 'env::var\|env!\(' --include="*.rs" -h . \
  | grep -oP '(?:env::var|env!)\(["\x27]\K[A-Z_]+' | sort -u
```

## Step 2: Compare with .env.example

Read `.env.example` (or `.env.template`) and list all declared keys.

Produce a diff:
```
IN CODE but NOT in .env.example (undocumented -- risk of being forgotten):
  + NEW_SECRET_KEY
  + STRIPE_WEBHOOK_SECRET

IN .env.example but NOT in code (stale -- probably removable):
  - OLD_FEATURE_FLAG
  - DEPRECATED_API_URL
```

## Step 3: Check devcontainer.json alignment

```bash
find . -name "devcontainer.json" | xargs grep -l "remoteEnv" 2>/dev/null
```

For each devcontainer.json found, check if `remoteEnv` includes all secrets needed at runtime.

Standard required vars to check for:
- `ANTHROPIC_API_KEY` -- Claude Code
- `TAVILY_API_KEY` -- web search MCP
- `GITHUB_TOKEN` -- GitHub MCP
- `DATABASE_URL` -- if DB is used
- `REDIS_URL` -- if Redis is used
- Any project-specific API keys

## Step 4: Check for hardcoded secrets

```bash
grep -r \
  -e "api[_-]key\s*=\s*['\"][a-zA-Z0-9_\-]\{20,\}" \
  -e "secret\s*=\s*['\"][a-zA-Z0-9_\-]\{20,\}" \
  -e "password\s*=\s*['\"][^'\"]\{8,\}" \
  --include="*.ts" --include="*.js" --include="*.py" --include="*.rs" \
  --exclude-dir=node_modules --exclude-dir=.git \
  -l . 2>/dev/null || echo "No hardcoded secrets found"
```

## Step 5: Output report

```markdown
## Env Audit -- [date] -- [project]

### Summary
- Total vars in code: N
- Documented in .env.example: N
- Declared in devcontainer.json: N

### Critical
- `SECRET_X` -- used in code, missing from .env.example AND devcontainer.json

### Warning
- `OLD_VAR` -- in .env.example but not used in code (stale)
- `API_KEY` -- in code and .env.example but missing from devcontainer.json

### OK
- All other vars are consistent

### Recommended .env.example additions
[generated entries with placeholder values and inline comments]

### Recommended devcontainer.json additions
[generated remoteEnv block]
```

## Rules

- Never print actual secret values -- only key names
- `.env` files should never be committed (check `.gitignore` includes `.env*`)
- `.env.example` should have placeholder values + a comment explaining what each var is for
- `${localEnv:VAR}` syntax in devcontainer.json pulls from the host machine -- document this

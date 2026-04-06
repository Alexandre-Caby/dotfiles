# Doc — Automatic project documentation generation

Analyzes the codebase and generates/updates documentation.

## Parameter

$ARGUMENTS = doc type (e.g., "readme", "api", "architecture", "all")

If empty, detect what is missing and generate everything.

## Steps

### 1. Project analysis

```bash
# Structure
find . -type f -name "*.ts" -o -name "*.py" -o -name "*.rs" -o -name "*.c" -o -name "*.go" \
  | grep -v node_modules | grep -v .git | grep -v __pycache__ | head -50

# Package info
cat package.json 2>/dev/null | head -20
cat pyproject.toml 2>/dev/null | head -20
cat Cargo.toml 2>/dev/null | head -20

# Existing docs
ls -la README.md docs/ CHANGELOG.md ARCHITECTURE.md 2>/dev/null
```

### 2. README.md

If absent or unpersonalized template, generate:

```markdown
# [Project name]

[Description in 1-2 sentences]

## Quick Start

### Prerequisites
- [language] [version]
- [required tools]

### Installation
\`\`\`bash
[installation commands]
\`\`\`

### Running
\`\`\`bash
[launch commands]
\`\`\`

## Project structure

\`\`\`
[relevant tree — not everything, just important directories]
\`\`\`

## Tests

\`\`\`bash
[command to run tests]
\`\`\`

## License
[detected license or to be defined]
```

### 3. ARCHITECTURE.md

If the project has > 10 source files, generate:

```markdown
# Architecture

## Overview
[ASCII diagram or architecture description]

## Modules
### [module-1]
- Responsibility: [what]
- Dependencies: [what it depends on]
- Exports: [public API]

## Data flow
[Description of the main flow]

## Technical decisions
- [Why this framework]
- [Why this structure]
```

### 4. API Documentation

If it's an API (routes/endpoints detected):

```bash
# Detect routes
grep -rn "app\.\(get\|post\|put\|delete\|patch\)\|@app\.route\|@router\.\|#\[.*route\]" \
  --include="*.ts" --include="*.py" --include="*.rs" . \
  | grep -v node_modules | grep -v test
```

Generate docs per endpoint: method, path, params, body, response, errors.

### 5. Missing Doxygen

Scan public functions without documentation:

```bash
# TS/JS — exported functions/methods without JSDoc
grep -rn "^export\s\+\(function\|const\|class\)" --include="*.ts" . | grep -v node_modules

# Python — functions/classes without docstring
grep -rn "^\s*def \|^\s*class " --include="*.py" . | grep -v __pycache__ | grep -v test

# Rust — pub fn/struct without /// doc
grep -rn "pub\s\+fn\|pub\s\+struct\|pub\s\+enum" --include="*.rs" .
```

For each public function without docs, add Doxygen documentation in the appropriate language style.

## Output format

```
## 📚 Documentation — [date]

### Files generated/updated
- README.md [created/updated]
- ARCHITECTURE.md [created/updated]
- docs/api.md [created/updated]

### Doxygen added
- [X] functions documented out of [Y] public functions

### Missing (action required)
- [What I cannot guess — business description, license choice, etc.]
```

# Doc — Génération automatique de documentation projet

Analyse le codebase et génère/met à jour la documentation.

## Paramètre

$ARGUMENTS = type de doc (ex: "readme", "api", "architecture", "tout")

Si vide, détecter ce qui manque et tout générer.

## Étapes

### 1. Analyse du projet

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

Si absent ou template non personnalisé, générer :

```markdown
# [Nom du projet]

[Description en 1-2 phrases]

## Quick Start

### Prérequis
- [langage] [version]
- [outils nécessaires]

### Installation
\`\`\`bash
[commandes d'installation]
\`\`\`

### Lancement
\`\`\`bash
[commandes de lancement]
\`\`\`

## Structure du projet

\`\`\`
[arborescence pertinente — pas tout, juste les dossiers importants]
\`\`\`

## Tests

\`\`\`bash
[commande pour lancer les tests]
\`\`\`

## Licence
[licence détectée ou à définir]
```

### 3. ARCHITECTURE.md

Si le projet a > 10 fichiers source, générer :

```markdown
# Architecture

## Vue d'ensemble
[Diagramme ASCII ou description de l'architecture]

## Modules
### [module-1]
- Responsabilité : [quoi]
- Dépendances : [de quoi il dépend]
- Expositions : [API publique]

## Flux de données
[Description du flux principal]

## Décisions techniques
- [Pourquoi ce framework]
- [Pourquoi cette structure]
```

### 4. API Documentation

Si c'est une API (routes/endpoints détectés) :

```bash
# Détecter les routes
grep -rn "app\.\(get\|post\|put\|delete\|patch\)\|@app\.route\|@router\.\|#\[.*route\]" \
  --include="*.ts" --include="*.py" --include="*.rs" . \
  | grep -v node_modules | grep -v test
```

Générer la doc par endpoint : méthode, path, params, body, response, erreurs.

### 5. Doxygen manquant

Scanner les fonctions publiques sans documentation :

```bash
# TS/JS — fonctions/méthodes exportées sans JSDoc
grep -rn "^export\s\+\(function\|const\|class\)" --include="*.ts" . | grep -v node_modules

# Python — fonctions/classes sans docstring
grep -rn "^\s*def \|^\s*class " --include="*.py" . | grep -v __pycache__ | grep -v test

# Rust — pub fn/struct sans /// doc
grep -rn "pub\s\+fn\|pub\s\+struct\|pub\s\+enum" --include="*.rs" .
```

Pour chaque fonction publique sans doc, ajouter la documentation Doxygen dans le style approprié au langage.

## Format de sortie

```
## 📚 Documentation — [date]

### Fichiers générés/mis à jour
- README.md [créé/mis à jour]
- ARCHITECTURE.md [créé/mis à jour]
- docs/api.md [créé/mis à jour]

### Doxygen ajouté
- [X] fonctions documentées sur [Y] fonctions publiques

### Manquant (action requise)
- [Ce que je ne peux pas deviner — description métier, choix de licence, etc.]
```

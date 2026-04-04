# Cleanup — Nettoyage dead code + AI slop + simplification

Analyse le codebase et supprime le code mort, l'AI slop, et simplifie le code de manière sûre.

## Paramètre

$ARGUMENTS = scope optionnel (ex: "src/", "fichier.ts", "tout")

Si vide, analyser tout le projet.

## Étapes

### 1. Inventaire du code mort

```bash
# Node/TypeScript — exports non utilisés, fichiers orphelins
npx knip --no-progress 2>/dev/null

# Python — code non atteint
python3 -m vulture . --min-confidence 80 2>/dev/null

# Rust — dead code
cargo clippy -- -W dead_code 2>/dev/null

# Imports non utilisés (multi-langage)
grep -rn "^import\|^from.*import\|^use " --include="*.ts" --include="*.py" --include="*.rs" . \
  | grep -v node_modules | grep -v .git
```

### 2. Détection AI slop

Scanner chaque fichier pour :

**Commentaires inutiles** (supprimer directement) :
- `// increment i` au-dessus de `i++`
- `// return the result` au-dessus de `return result`
- `// constructor` au-dessus de `constructor()`
- `// import X` au-dessus d'un import
- Tout commentaire qui répète le code verbatim

**Filler code** (simplifier) :
- Wrapper functions qui ne font que passer les args
- Classes avec une seule méthode → fonction
- Interfaces avec une seule implémentation → supprimer l'interface
- `if (condition) { return true } else { return false }` → `return condition`
- Variables intermédiaires inutiles (`const result = x; return result;` → `return x`)

**Console/debug oubliés** (supprimer) :
- `console.log` hors fichiers de config/CLI
- `print()` de debug en Python
- `dbg!()` en Rust
- `printf` de debug en C

### 3. Workflow de suppression sûre

Pour chaque élément détecté :

1. **Analyser** — vérifier que c'est réellement mort (pas de reflection, dynamic import, etc.)
2. **Vérifier** — s'assurer que les tests passent avant la suppression
3. **Supprimer** — retirer le code
4. **Tester** — relancer les tests après suppression
5. **Si tests cassés** → revert et marquer comme "faux positif"

### 4. Simplification

Après le nettoyage, chercher des simplifications :

- Boucles `for` → `map/filter/reduce` quand applicable
- Chaînes de `if/else if` → `switch/match` ou lookup table
- Fonctions > 50 lignes → extraire des sous-fonctions
- Fichiers > 300 lignes → découper en modules
- Dépendances utilisées pour une seule fonction → implémenter à la main si < 10 lignes

### 5. Dépendances inutiles

```bash
# Node
npx depcheck 2>/dev/null

# Python — check unused imports dans requirements
pip list --not-required 2>/dev/null
```

## Format de sortie

```
## 🧹 Cleanup — [date]

### Dead code supprimé
- [fichier] Fonction `foo()` — jamais appelée
- [fichier] Import `bar` — non utilisé
- [fichier] Variable `temp` — déclarée, jamais lue

### AI slop nettoyé
- [X] commentaires paraphrase supprimés
- [X] console.log/print supprimés
- [X] variables intermédiaires simplifiées

### Simplifications appliquées
- [fichier] for loop → array.map()
- [fichier] if/else chain → switch

### Dépendances retirées
- [package] — utilisé nulle part

### Résultat
- Lignes supprimées : X
- Fichiers modifiés : X
- Tests : ✅ tous passent après cleanup
```

# Audit — Audit complet qualité + sécurité + propreté

Lance un audit exhaustif du projet en 4 phases. Combine review, security, et cleanup en un seul pass.

## Paramètre

$ARGUMENTS = scope optionnel (ex: "src/", "depuis le dernier commit", "tout")

Si vide, auditer les changements depuis le dernier commit. Si "tout", auditer tout le projet.

## Phase 1 — Scan automatisé

Exécuter en parallèle :

```bash
# Secrets exposés
grep -rn "password\|secret\|api_key\|token\|private_key\|BEGIN RSA\|BEGIN OPENSSH" \
  --include="*.ts" --include="*.py" --include="*.rs" --include="*.go" \
  --include="*.c" --include="*.cpp" --include="*.h" . \
  | grep -v node_modules | grep -v .git | grep -v test | grep -v "\.example"

# Dépendances vulnérables
npm audit --audit-level=moderate 2>/dev/null; \
pip audit 2>/dev/null; \
cargo audit 2>/dev/null; \
true

# Dead code
npx knip --no-progress 2>/dev/null || \
python3 -m vulture . 2>/dev/null || \
true

# TODO/FIXME/HACK oubliés
grep -rn "TODO\|FIXME\|HACK\|XXX\|TEMP\|WORKAROUND" \
  --include="*.ts" --include="*.py" --include="*.rs" --include="*.go" \
  --include="*.c" --include="*.cpp" . \
  | grep -v node_modules | grep -v .git
```

## Phase 2 — Code quality review

Pour chaque fichier dans le scope :

### Correctness
- Logique métier correcte ?
- Edge cases gérés (null, empty, overflow, concurrence) ?
- Erreurs propagées correctement (pas de catch vide) ?
- Types corrects (pas de `any` en TS, pas de `# type: ignore` en Python) ?

### Performance
- Requêtes N+1 ?
- Calculs inutilement répétés dans des boucles ?
- Mémoire : leaks, objets volumineux non libérés ?
- Complexité algorithmique excessive ?

### Maintainability
- Nommage clair (pas de `data`, `temp`, `stuff`, `x`) ?
- Fonctions < 50 lignes, une seule responsabilité ?
- Documentation Doxygen sur les fonctions publiques ?
- DRY respecté (pas de copier-coller) ?

### Tests
- Couverture : chaque fonction publique a un test ?
- Tests pertinents (pas juste "ça ne plante pas") ?
- Edge cases testés ?
- Mocks minimaux (pas de mock qui renvoie toujours true) ?

## Phase 3 — Security (OWASP WSTG + ANSSI)

Appliquer le même référentiel que `/user:security-check` :
- CONFIG, AUTHN, AUTHZ, SESS, INPVAL, CRYPT, BUSLOGIC
- Pattern review (17 patterns critiques)
- Scoring CVSS v3.1 par vulnérabilité

## Phase 4 — AI slop & clean code

Détecter les signes de code généré sans relecture :

### AI Slop checklist
- [ ] Commentaires qui paraphrasent le code (`// increment i by 1`)
- [ ] Over-abstraction (3 fichiers pour un helper de 5 lignes)
- [ ] Filler words dans les docstrings ("This function basically...")
- [ ] Console.log / print de debug oubliés
- [ ] Code mort (fonctions jamais appelées, imports inutilisés)
- [ ] Variables déclarées mais jamais utilisées
- [ ] Try-catch avec catch vide ou `// TODO: handle error`
- [ ] Types `any` / `object` / `dict` sans raison documentée
- [ ] Dépendances importées mais non utilisées dans package.json/Cargo.toml
- [ ] README.md avec du contenu template non personnalisé

### Simplification
- Code qui peut être réduit (map/filter vs boucle manuelle) ?
- Abstractions inutiles (interface avec une seule implémentation) ?
- Fichiers de config dupliqués ?

## Format de sortie

```
# 🔍 Audit complet — [date]

## Scope : [description]
## Durée : [temps]

## Résumé exécutif
- Score qualité : [X/10]
- Score sécurité : [X/10]
- Score propreté : [X/10]
- **Score global : [X/10]**

## 🔴 Bloquants (à corriger avant merge)
1. [SEC] [fichier:ligne] Description — CVSS X.X
2. [BUG] [fichier:ligne] Description
3. [TEST] Pas de tests pour [module]

## 🟠 Importants (à corriger rapidement)
1. [PERF] [fichier:ligne] Description
2. [SLOP] [fichier:ligne] Description

## 🟡 Améliorations (prochaine itération)
1. [CLEAN] Description
2. [DOC] Description

## 🟢 Points positifs
- [ce qui est bien fait]

## Métriques
- Fichiers analysés : X
- Vulnérabilités : X critique / X haute / X moyenne
- Dead code détecté : X fonctions / X imports
- AI slop détecté : X occurrences
- Couverture tests estimée : X%
```

# Code Review — Depuis le dernier commit

Analyse les changements depuis le dernier commit et fournis un code review structuré.

## Étapes

1. Exécuter `git diff HEAD~1` pour voir les changements
2. Si pas de commit précédent, utiliser `git diff --staged` puis `git diff`

## Checklist de review

Pour chaque fichier modifié, évaluer :

### Correctness
- Logique métier correcte ?
- Edge cases gérés ?
- Erreurs propagées correctement ?

### Security
- Inputs validés ?
- Pas de secrets hardcodés ?
- Pas d'injection SQL/XSS/command possible ?

### Performance
- Requêtes N+1 ?
- Calculs inutilement répétés ?
- Mémoire : objets volumineux non libérés ?

### Maintainability
- Nommage clair et cohérent ?
- Documentation Doxygen sur les nouvelles fonctions publiques ?
- Code dupliqué ?
- Tests couvrant les changements ?

## Format de sortie

```
## Review — [date]

### Résumé
[1-2 phrases sur la nature des changements]

### 🔴 Critique (bloque le merge)
- [fichier:ligne] Description du problème

### 🟡 Important (à corriger)
- [fichier:ligne] Description

### 🟢 Suggestions (nice to have)
- [fichier:ligne] Description

### ✅ Points positifs
- Ce qui est bien fait
```

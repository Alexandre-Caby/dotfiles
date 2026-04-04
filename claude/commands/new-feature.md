# New Feature — Cycle complet orchestré avec agents et teams

Orchestre le cycle complet de développement d'une feature en utilisant automatiquement les bons agents et teams selon le contexte.

## Paramètre

$ARGUMENTS = description de la feature (ex: "auth JWT pour l'API", "parser BCI signal en Rust")

## Phase 1 — Analyse et plan

### 1a. Recherche préalable (si techno inconnue)

Si la feature implique une technologie, lib ou pattern pas encore utilisé dans le projet :
- **Agent `docs-fetcher`** → documentation live via Context7
- **Agent `web-search`** → état de l'art, comparaisons, best practices
- **Team `research-team`** → si plusieurs technos à évaluer

### 1b. Choix du stack (si ambigu)

Si le langage ou le framework n'est pas évident :
- **Agent `language-advisor`** → analyser les contraintes et recommander
- Ne JAMAIS assumer — toujours justifier le choix

### 1c. Plan structuré

Utiliser **agent `feature-planner`** pour produire :

| # | Tâche | Taille | Fichiers | Tests prévus |
|---|-------|--------|----------|--------------|
| 1 | ... | S/M/L | ... | ... |

Plus :
- Risques identifiés et mitigations
- Scope cuts possibles (si deadline serrée)
- Dépendances nouvelles à justifier

### 1d. Validation architecture (si > 3 fichiers ou changement structurel)

- **Agent `architect`** → review coupling, SOLID, scalability, red flags
- **Agent `api-designer`** → si endpoints/routes sont impliqués

**→ STOP : Présenter le plan et attendre la validation avant de continuer.**

## Phase 2 — Implémentation TDD

### Dispatch automatique

- **Si feature ≥ 3 fichiers ou front + back** → déléguer à **team `feature-dev-team`**
- **Si feature simple (1-2 fichiers)** → exécution directe avec **agent `tdd-guide`**

### Cycle pour chaque tâche

1. **Agent `tdd-guide`** supervise le cycle Red-Green-Refactor :
   - Écrire le test qui échoue (RED)
   - Écrire le code minimal qui passe (GREEN)
   - Refactorer sans casser les tests
   - Vérifier : `vitest run` / `pytest` / `cargo test` / `ctest`

2. **Agent `test-writer`** complète les tests si couverture < 80% :
   - Edge cases : null, empty, overflow, erreurs réseau
   - Tests d'intégration si API/DB impliqué

3. Si nouvelle dépendance ajoutée → **agent `dependency-auditor`** vérifie CVE

Règles strictes :
- **Jamais de code sans test**
- Une tâche à la fois, dans l'ordre du plan
- Si migration DB nécessaire → **agent `migration-writer`**
- Conventional commits : `feat(scope): description`

## Phase 3 — Review et audit

### Review automatique

- **Agent `security-reviewer`** → OWASP WSTG sur le code changé
- **Agent `refactor-cleaner`** → AI slop, dead code, simplifications
- **Agent `perf-auditor`** → si endpoints, requêtes DB, ou traitement lourd

### Checklist

- [ ] Tous les tests passent
- [ ] Couverture ≥ 80% sur le nouveau code
- [ ] Pas de régression
- [ ] Pas de secrets hardcodés
- [ ] Pas d'AI slop (commentaires paraphrase, over-abstraction)
- [ ] Documentation Doxygen sur les nouvelles fonctions publiques
- [ ] Pas de `any` / `# type: ignore` / `unsafe` non justifié

## Phase 4 — Commit

- **Agent `git-workflow`** → message conventional commit, scope adapté
- **Agent `env-auditor`** → vérifier cohérence .env / .env.example si modifié

## Format de sortie

```
## ✅ Feature terminée — [nom]

### Agents utilisés
- [agent-1] — [ce qu'il a fait]
- [agent-2] — [ce qu'il a fait]
- Team [team-name] (si utilisée)

### Résumé
[1-2 phrases]

### Fichiers créés/modifiés
- [fichier] — [description]

### Tests
- X tests écrits / X assertions
- Couverture : X%

### Review
- Qualité : X/10 | Sécurité : X/10
- Issues corrigées : X

### Commits
- feat(scope): ...
- test(scope): ...
```

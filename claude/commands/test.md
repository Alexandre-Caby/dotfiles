# Test — Lancer et analyser les tests

Exécute la suite de tests du projet et analyse les résultats.

## Détection automatique du runner

1. Vérifier la présence des fichiers de config et exécuter :
   - `package.json` avec script test → `npm test` ou `pnpm test`
   - `vitest.config.*` → `npx vitest run`
   - `jest.config.*` → `npx jest`
   - `pytest.ini` / `pyproject.toml` [tool.pytest] → `pytest -v`
   - `Cargo.toml` → `cargo test`
   - `go.mod` → `go test ./...`

2. Si plusieurs runners possibles, demander à l'utilisateur

## Analyse des résultats

Pour chaque test qui échoue :

```
### ❌ [nom du test]
**Fichier** : [path:line]
**Erreur** : [message d'erreur concis]
**Cause probable** : [diagnostic]
**Fix suggéré** : [correction proposée]
```

## Résumé final

```
✅ [X] passed | ❌ [Y] failed | ⏭ [Z] skipped
Coverage : [X]% (si disponible)
```

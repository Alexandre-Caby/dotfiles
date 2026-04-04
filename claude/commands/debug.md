# Debug — Diagnostic structuré

Applique une méthode de diagnostic systématique pour identifier et résoudre un bug.

## Protocole

### Phase 1 : Reproduire
- Identifier les étapes exactes pour reproduire le bug
- Confirmer que le bug est reproductible de manière fiable
- Isoler l'input minimal qui déclenche le problème

### Phase 2 : Isoler
- Identifier le fichier et la zone de code responsable
- Utiliser des logs/breakpoints pour tracer le flux d'exécution
- Réduire le périmètre : est-ce le code, une dépendance, la config, ou l'environnement ?

### Phase 3 : Diagnostiquer
- Formuler une hypothèse sur la cause racine
- Vérifier l'hypothèse avec un test ou une modification ciblée
- Si l'hypothèse est fausse, revenir à Phase 2

### Phase 4 : Corriger
- Appliquer le fix minimal qui résout le problème
- Vérifier que le fix ne casse rien d'autre (lancer les tests)
- Écrire un test qui aurait attrapé ce bug

## Format de sortie

```
## Diagnostic — [description courte du bug]

**Symptôme** : [ce qui se passe]
**Attendu** : [ce qui devrait se passer]
**Cause racine** : [pourquoi ça arrive]
**Fix appliqué** : [ce qui a été changé]
**Test ajouté** : [oui/non — description]
**Régression check** : [tests passent ✅ / échouent ❌]
```

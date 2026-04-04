# Plan — Feature ou tâche

Crée un plan d'implémentation détaillé pour la feature ou tâche décrite par l'utilisateur.

## Étapes

1. **Comprendre** — Lire le code existant pertinent avant de proposer quoi que ce soit
2. **Analyser** — Identifier les fichiers impactés, les dépendances, et les risques
3. **Découper** — Créer des tâches concrètes et ordonnées

## Format de sortie

```
## Plan : [titre de la feature]

### Contexte
[Ce qui existe, ce qui doit changer, pourquoi]

### Approche technique
[Choix d'architecture, patterns à utiliser, justification]

### Tâches
1. [ ] Tâche 1 — [S/M/L] — [fichier(s) impacté(s)]
2. [ ] Tâche 2 — [S/M/L] — [fichier(s)]
...

### Risques identifiés
- [Risque] → [Mitigation]

### Ce qu'on ne fait PAS (scope cut)
- [Feature/détail volontairement exclu et pourquoi]
```

## Règles

- Estimation : S = <2h, M = 2-4h, L = 1 jour
- Toujours inclure une section "scope cut"
- Identifier les tâches parallélisables vs séquentielles
- Si la tâche est un L, proposer un découpage en sous-tâches S/M

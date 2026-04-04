# Context Save — Sauvegarder l'état de session

Génère ou met à jour le fichier `CONTEXT.md` à la racine du projet avec l'état actuel de la session.

## Étapes

1. Lire le `CONTEXT.md` existant s'il y en a un
2. Exécuter `git status` et `git log --oneline -10` pour connaître l'état git
3. Synthétiser la session courante

## Format du CONTEXT.md

```markdown
# Context — [nom du projet]
> Dernière mise à jour : [date ISO]

## Status
[En cours / Bloqué / Prêt pour review / ...]

## Travail actif
[Ce sur quoi on travaille actuellement — 1-3 phrases max]

## Progression
- [x] Ce qui est fait
- [ ] Ce qui reste

## Décisions prises
- [Décision] — [Justification courte]

## Blockers connus
- [Blocker] — [Impact]

## Dette technique acceptée
- [Shortcut pris] — [Quand le corriger]

## Fichiers clés modifiés
- `path/to/file` — [ce qui a changé]

## État git
- Branche : [nom]
- Dernier commit : [hash court] [message]
- Fichiers non commités : [liste ou "aucun"]

## Prochaine session : 3 premières actions
1. [Action concrète et exécutable]
2. [Action concrète]
3. [Action concrète]
```

## Règles

- Être concis — chaque section doit tenir en quelques lignes
- "Prochaine session" doit être exécutable immédiatement, pas vague
- Si CONTEXT.md contredit le code, le code a raison
- Ne pas inclure de code dans CONTEXT.md, seulement des références aux fichiers

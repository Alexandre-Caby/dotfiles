# Dotfiles — Alexandre Caby

Configuration globale Claude Code synchronisée entre PC fixe et laptop.

## Structure

```
dotfiles/
├── install.sh              ← Exécuté automatiquement par VSCode Dotfiles
├── claude/
│   ├── CLAUDE.md           ← Contexte global (polyglot, Docker/WSL, conventions)
│   ├── settings.json       ← Hooks (auto-format, notifications)
│   ├── agents/
│   │   ├── language-advisor.md    ← Choisir le bon langage/stack
│   │   ├── docker-debugger.md     ← Debug Docker/WSL2
│   │   ├── devcontainer-init.md   ← Générer un devcontainer.json
│   │   └── architect.md           ← Review d'architecture
│   └── skills/
│       ├── secure-craft/          ← Sécurité (code review, threat modeling)
│       ├── aesthetic-craft/       ← Design (+ sub-skills web/email/visual/dataviz)
│       ├── polyglot-stack.md      ← Conventions multi-langages
│       └── docker-wsl.md          ← Patterns Docker/WSL fréquents
└── templates/
    ├── devcontainer-node.json     ← Template Node.js/TypeScript
    ├── devcontainer-python.json   ← Template Python
    └── devcontainer-rust.json     ← Template Rust
```

## Conventions clés (résumé)

- **Code** → toujours en anglais (variables, fonctions, commentaires, logs)
- **UI / textes utilisateur** → français par défaut, i18n si app publique
- **Commentaires** → style Doxygen (`@brief`, `@param`, `@return`, `@throws`)
- **Langage** → choisi selon les contraintes du projet, jamais par défaut

## Installation — Nouvelle machine WSL

```bash
# 1. Cloner le repo dans WSL
git clone git@github.com:Alexandre-Caby/dotfiles.git ~/dotfiles

# 2. Rendre le script exécutable et lancer
chmod +x ~/dotfiles/install.sh
~/dotfiles/install.sh

# 3. VSCode settings (déjà configuré — vérifier)
# "dev.containers.dotfilesRepository": "https://github.com/Alexandre-Caby/dotfiles"
# "dev.containers.dotfilesTargetPath": "~/dotfiles"
# "dev.containers.dotfilesInstallCommand": "~/dotfiles/install.sh"

# 4. Variables d'environnement dans WSL (~/.bashrc)
# export ANTHROPIC_API_KEY="sk-ant-..."
# export GITHUB_TOKEN="ghp_..."
```

## Sync entre machines

```bash
# Après modification
git add .
git commit -m "chore: update claude config"
git push

# Sur l'autre machine
git pull
# → Le prochain devcontainer utilisera automatiquement la version à jour
```

## Utiliser les agents dans Claude Code

```
# Dans n'importe quel devcontainer
/language-advisor    → Recommande un langage pour un nouveau projet
/docker-debugger     → Diagnostique un problème Docker
/devcontainer-init   → Génère un devcontainer.json adapté
/architect           → Review d'architecture (tourne sur Opus)
```

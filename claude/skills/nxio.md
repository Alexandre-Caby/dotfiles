# Skill: NXIO — Contexte projet

> ⚠️ Ce fichier est un document vivant. Le mettre à jour à chaque évolution majeure.
> Dernière mise à jour : mars 2025
> Nom précédent : Project-Nero / Project-Nero-Everness

---

## Vue d'ensemble

NXIO est un projet entrepreneurial de **dispositif BCI (Brain-Computer Interface)** combinant :
- Un hardware médical/research-grade pour acquisition EEG + stimulation neurale
- Du ML embarqué (TinyML, inférence temps réel sur MCU)
- Une plateforme logicielle de traitement et visualisation
- Un écosystème d'agents IA et de simulation monde (World_lab)

Il existe deux produits hardware :
- **NXIO-Lab** — version laboratoire/recherche (PCB existant, V1.1 en cours)
- **NXIO-Home** — version grand public/home (à concevoir)

---

## État actuel du projet (mars 2025)

| Composant | État | Notes |
|---|---|---|
| NXIO-Lab V1.1 (PCB) | ✅ En cours | STM32H735, schémas/routage faits |
| Firmware NERO | 🔄 En développement | STM32CubeIDE, EEG + stim + ML inference |
| Modèle TinyML | 🔄 En développement | `unified_bci_model.h5`, scaler, notebook |
| Data Analyzer | 🔄 En développement | Outil desktop d'analyse des données EEG |
| NXIO-Home (hardware) | ⬜ Non démarré | Specs à rédiger |
| Site web NXIO | ⬜ Non démarré | |
| World_lab / agent-manager | 🔄 Actif | MCP servers, simulation monde |
| Entreprise | 🔄 Actif | Structure Cowork, Créasup en cours |

**Deadline prioritaire : Créasup fin juin 2025** — POC NXIO-Lab (hardware + software fonctionnel)

---

## Architecture produit

```
┌─────────────────────────────────────────────────────────────┐
│                        NXIO Platform                         │
├───────────────────────┬─────────────────────────────────────┤
│    Hardware           │    Software & AI                     │
├───────────────────────┼─────────────────────────────────────┤
│  NXIO-Lab (V1.1)      │  Firmware (STM32CubeIDE)            │
│  STM32H735            │  ├─ EEG acquisition pipeline        │
│  EEG + stimulation    │  ├─ Neural stimulation control       │
│  + ML inference       │  └─ TinyML inference (on-device)    │
│                       │                                      │
│  NXIO-Home            │  Data Analyzer (desktop app)        │
│  (à concevoir)        │  ML Pipeline (Python, TensorFlow)   │
└───────────────────────┴─────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                        World_lab                             │
│  MCP servers · AI agents · Simulation UE5/Blender            │
│  agent-manager (Python + uv) · Ollama · Redis               │
└─────────────────────────────────────────────────────────────┘
```

---

## Hardware — NXIO-Lab

### MCU principal
- **STM32H735** (série H7, Cortex-M7 @ 550MHz)
- Acquisition EEG multi-canaux
- Stimulation neurale
- Inférence ML embarquée (TinyML)

### Documents de référence
- `BOM_V1.gsheet` — couvre V1.0 et V1.1
- `Project NXIO - Hardware design report.gdoc` — HDR courant (V1.1)
- `STM32H735 Pin allocation map.gsheet`
- `Version/V1/` et `Version/V1.1/` — archives PCB/SCH/EPRJ

### Conventions versioning hardware
- `BOM` et `HDR` = documents vivants à la racine Hardware/
- `Version/Vx.x/` = archives des livrables figés (PCB, SCH, EPRJ)
- Nouvelle version = nouveau sous-dossier dans Version/

---

## Software — Firmware NERO

```c
// Projet : Project-NERO-Core-Software (STM32CubeIDE)
// MCU : STM32H735
// Fonctions principales :
//   - Acquisition EEG (pipeline ADC → filtrage → buffer)
//   - Contrôle stimulation neurale
//   - Inférence TinyML on-device (TensorFlow Lite for MCU)
//   - Communication (UART/USB/BLE selon version)
```

### Modèle ML embarqué
```python
# Fichiers clés :
# - unified_bci_model.h5     → modèle Keras complet (14Go)
# - tinyml-nero-model.ipynb  → pipeline entraînement + quantification
# - scaler                   → normalisation des features
#
# Pipeline : acquisition EEG → features → inférence → output
# Quantification int8 pour déploiement sur STM32H735
```

---

## Structure dossiers NXIO

```
Documents/NXIO/
├── 01 - Entreprise/
│   ├── Admin & Legal/
│   ├── Business Development/   # Concours, Financement, Incubateurs, Marketing, Pitchs
│   ├── Finance/                # Comptabilité, Factures (par fournisseur), Commandes
│   └── Operations/             # Abonnements, Fournisseurs
│
├── 02 - R&D/
│   ├── NXIO-Lab/               # Produit Lab (V1.1 existant)
│   │   ├── Documentation/
│   │   ├── Hardware/           # BOM, HDR, PCB, Version/V1, Version/V1.1
│   │   ├── Software/           # Firmware/, Machine Learning/, specs
│   │   └── Validation/
│   ├── NXIO-Home/              # Produit Home (à concevoir)
│   │   ├── Documentation/
│   │   ├── Hardware/
│   │   ├── Software/
│   │   └── Validation/
│   └── _References/            # Datasheets, Papers, State of the Art
│
├── 03 - Developpement/         # Code hors Drive sync (géré par git)
│   ├── World_lab/              # MCP servers, plugins, AI_lab — NE PAS DÉPLACER
│   ├── agent-manager/          # Orchestration agents IA
│   └── Data_analyzer/          # Outil analyse données EEG
│
└── 04 - Ressources/
    ├── Backup/                 # R&D/, Config/
    ├── Diagrammes architecture/
    ├── Templates/
    └── Videos/
```

---

## Repos GitHub

> Organisation : `Alexandre-Caby` (à migrer vers org NXIO si création structure)

| Repo | Langage | Rôle |
|---|---|---|
| `Project-NERO-Core-Software` | C (STM32CubeIDE) | Firmware STM32H735 |
| `world-lab` | Node.js / Python | MCP servers + outils AI |
| `agent-manager` | Python + uv | Orchestration agents IA |
| `eda` | TypeScript (pnpm) | Projet EDA (side project) |
| `syplay` | TypeScript + Docker | Projet Syplay (side project) |
| `dotfiles` | Bash | Config Claude Code + install |

---

## World_lab — Écosystème agents IA

> ⚠️ Le dossier `World_lab/` ne doit PAS être déplacé — contient des configs et dépendances critiques.

```bash
# Stack : MCP servers (Node.js) + agent-manager (Python + uv)
# Réseau Docker : ai_network
# Services : ollama, redis, agent-manager, MCP servers

# Variables d'environnement clés :
ANTHROPIC_API_KEY=
OLLAMA_HOST=http://ollama:11434
REDIS_URL=redis://redis:6379
UE5_REMOTE_CONTROL_HOST=host.docker.internal
UE5_REMOTE_CONTROL_PORT=30010
BLENDER_PORT=9876
```

### Conventions MCP tools
- Noms en `snake_case`, format `verb_noun` : `spawn_actor`, `get_world_state`
- Descriptions en anglais, précises — lues par le LLM
- Valider avec Zod avant transmission à UE5/Blender
- Jamais de logique métier dans les MCP servers — purs adaptateurs
- La logique vit dans l'Agent Manager et les Blueprints UE5

---

## Contexte entrepreneurial

- **Statut** : projet en création (pas encore de structure légale formalisée)
- **Compétition prioritaire** : Créasup — deadline fin juin 2025
- **Objectif Créasup** : POC NXIO-Lab fonctionnel (hardware + firmware + démo ML)
- **Pistes** : incubation, financement public (BPI, subventions), concours

---

## Commande de mise à jour

```
Update the NXIO skill at ~/.claude/skills/nxio.md with: [changements]
```

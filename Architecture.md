# Architecture de l'Assistant Vocal Odin

## Structure du Projet

```
odin_assistant/
│
├── src/
│   ├── core/
│   │   ├── __init__.py
│   │   ├── engine.py           # Gestion du moteur vocal (init, synthesis)
│   │   ├── recognizer.py       # Reconnaissance vocale et traitement audio
│   │   └── command_router.py   # Routage des commandes vers les handlers
│   │
│   ├── commands/
│   │   ├── __init__.py
│   │   ├── base.py            # Classe de base pour les commandes
│   │   ├── system_commands.py  # Commandes système (volume, shutdown...)
│   │   ├── window_commands.py  # Gestion des fenêtres
│   │   ├── mouse_commands.py   # Contrôle de la souris
│   │   ├── ui_commands.py      # Interaction UI
│   │   ├── app_commands.py     # Gestion des applications
│   │   └── media_commands.py   # Commandes multimédia
│   │
│   ├── patterns/
│   │   ├── __init__.py
│   │   ├── command_patterns.py # Patterns de reconnaissance
│   │   └── validators.py       # Validation des commandes
│   │
│   ├── powershell/
│   │   ├── __init__.py
│   │   ├── executor.py        # Exécution des commandes PowerShell
│   │   └── scripts/           # Scripts PowerShell organisés par fonction
│   │       ├── system.ps1
│   │       ├── ui.ps1
│   │       ├── mouse.ps1
│   │       └── apps.ps1
│   │
│   ├── utils/
│   │   ├── __init__.py
│   │   ├── logger.py          # Logging unifié
│   │   ├── config.py          # Gestion de la configuration
│   │   └── exceptions.py      # Exceptions personnalisées
│   │
│   └── feedback/
│       ├── __init__.py
│       ├── voice.py           # Retour vocal
│       └── visual.py          # Retour visuel (notifications)
│
├── config/
│   ├── settings.yaml          # Configuration générale
│   ├── commands.yaml          # Définition des commandes
│   └── patterns.yaml          # Patterns de reconnaissance
│
├── tests/                     # Tests unitaires et d'intégration
│   ├── test_core/
│   ├── test_commands/
│   └── test_patterns/
│
├── docs/                      # Documentation
│   ├── setup.md
│   ├── commands.md
│   └── architecture.md
│
├── requirements.txt           # Dépendances Python
├── setup.py                  # Installation du package
└── main.py                   # Point d'entrée
```

## Principes Architecturaux

### 1. Séparation des Responsabilités

#### Core
- **engine.py** : Gestion du moteur de synthèse vocale
- **recognizer.py** : Capture et reconnaissance vocale
- **command_router.py** : Routage intelligent des commandes

#### Commands
- Handlers spécialisés par domaine fonctionnel
- Pattern Command pour l'exécution des actions
- Interface unifiée via classe de base

#### Patterns
- Séparation de la logique de reconnaissance
- Patterns extensibles et maintenables
- Validation centralisée

#### PowerShell
- Isolation de l'interaction système
- Scripts modulaires et spécialisés
- Interface unifiée via executor.py

### 2. Patterns de Conception

#### Command Pattern
```python
# src/commands/base.py
class CommandHandler:
    def handle(self, command: str) -> bool:
        raise NotImplementedError
```

#### Factory Pattern
```python
# src/core/command_router.py
class CommandRouter:
    def __init__(self):
        self.handlers = {}
    
    def register_handler(self, command_type: str, handler: CommandHandler):
        self.handlers[command_type] = handler
```

#### Observer Pattern
```python
# src/feedback/voice.py
class VoiceFeedback:
    def notify(self, message: str):
        self.synthesize_speech(message)
```

### 3. Avantages de l'Architecture

1. **Maintenance Facilitée**
   - Modules indépendants et cohésifs
   - Responsabilités clairement définies
   - Code organisé et documenté

2. **Extensibilité**
   - Ajout facile de nouvelles commandes
   - Patterns extensibles
   - Configuration externalisée

3. **Testabilité**
   - Tests unitaires par module
   - Mocking simplifié
   - Couverture de code optimale

4. **Configuration Flexible**
   - Configuration YAML pour les paramètres
   - Patterns de commandes externalisés
   - Facilité de modification

### 4. Exemple d'Implémentation

```python
# src/commands/mouse_commands.py
from .base import CommandHandler
from ..patterns import command_patterns
from ..powershell import execute_ps

class MouseCommandHandler(CommandHandler):
    def handle(self, command: str) -> bool:
        if match := command_patterns.MOUSE_MOVE.match(command):
            x, y = match.groups()
            return execute_ps.control_mouse("Move", x, y)
        return False

# src/patterns/command_patterns.py
class CommandPatterns:
    MOUSE_MOVE = re.compile(
        r"(?:déplace|bouge|souris\s+déplacée?)(?:r)?\s+"
        r"(?:la\s+)?(?:souris\s+)?(?:vers|à|en|aux?)?\s+"
        r"(\d+)\s*[,\s]\s*(\d+)"
    )
```

### 5. Gestion de la Configuration

```yaml
# config/patterns.yaml
mouse:
  move:
    - "déplacer? (la\s+)?souris vers {x},{y}"
    - "souris déplacée? (vers\s+)?{x},{y}"
  click:
    - "cliquer? (avec\s+)?(le\s+)?bouton {button}"
    - "double[- ]cliquer? {button}"
```

### 6. Flux de Traitement

1. Capture audio (recognizer.py)
2. Reconnaissance vocale (recognizer.py)
3. Routage de la commande (command_router.py)
4. Validation du pattern (validators.py)
5. Exécution de la commande (handlers spécifiques)
6. Retour utilisateur (feedback/voice.py, feedback/visual.py)

Cette architecture modulaire permet une évolution contrôlée du système tout en maintenant une base de code propre et maintenable.
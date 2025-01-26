# Architecture de l'Assistant Vocal Odin

## Structure du Projet

```
odin_assistant_vocale/
│
├── python_modules/                    # Modules Python
│   ├── __init__.py
│   ├── speech_engine.py              # Gestion de la synthèse vocale
│   ├── voice_recognizer.py           # Reconnaissance vocale
│   ├── powershell_executor.py        # Exécution des commandes PowerShell
│   ├── command_patterns.py           # Patterns de reconnaissance
│   ├── command_handler.py            # Gestionnaire de commandes
│   └── console_interface.py          # Interface console
│
├── modules/                          # Modules PowerShell
│   ├── VolumeManager.ps1            # Gestion du volume
│   ├── ApplicationManager.ps1        # Gestion des applications
│   ├── SystemManager.ps1            # Gestion système
│   ├── WindowManager.ps1            # Gestion des fenêtres
│   ├── UIManager.ps1                # Interface utilisateur
│   └── MouseManager.ps1             # Contrôle de la souris
│
├── mes_commande_ext/                 # Modules externes
│   └── mes_actions.ps1              # Actions personnalisées
│
├── voice_commands.py                 # Point d'entrée Python
├── audio_commands.ps1               # Point d'entrée PowerShell
├── COMMANDS.md                      # Documentation des commandes
└── PATTERNS.md                      # Guide des patterns de reconnaissance
```

## Architecture Modulaire

### 1. Modules Python

#### Speech Engine (speech_engine.py)
- Classe `SpeechEngine`
- Initialisation et gestion du moteur de synthèse vocale
- Méthodes sécurisées pour la parole

#### Voice Recognizer (voice_recognizer.py)
- Classe `VoiceRecognizer`
- Capture et reconnaissance vocale
- Gestion des erreurs de reconnaissance

#### PowerShell Executor (powershell_executor.py)
- Classe `PowerShellExecutor`
- Interface avec les scripts PowerShell
- Gestion des erreurs d'exécution

#### Command Patterns (command_patterns.py)
- Classe `CommandPatterns`
- Définition des patterns de reconnaissance
- Organisation par catégories (souris, fenêtres, etc.)
- Documentation détaillée dans PATTERNS.md
- Extensible pour de nouveaux types de commandes

#### Command Handler (command_handler.py)
- Classe `CommandHandler`
- Traitement des commandes vocales
- Routage vers les fonctions PowerShell appropriées

#### Console Interface (console_interface.py)
- Classe `ConsoleInterface`
- Affichage des commandes et de l'aide
- Messages de statut

### 2. Modules PowerShell

#### VolumeManager.ps1
- `Set-SystemVolume` : Contrôle du volume système
- Validation des niveaux de volume
- Gestion des touches multimédia

#### ApplicationManager.ps1
- `Start-Application` : Lancement des applications
- Gestion des chemins d'applications
- Support des paramètres de lancement

#### SystemManager.ps1
- `Restart-Shutdown` : Gestion de l'arrêt/redémarrage
- `Lock-Session` : Verrouillage de la session
- Actions système critiques

#### WindowManager.ps1
- `Set-WindowState` : Gestion de l'état des fenêtres
- `Invoke-UIAction` : Actions sur l'interface utilisateur
- Contrôle des fenêtres Windows

#### UIManager.ps1
- `Show-Notification` : Affichage des notifications
- `New-Screenshot` : Création de captures d'écran
- Interactions avec l'interface utilisateur

#### MouseManager.ps1
- `Invoke-MouseAction` : Actions de la souris
- Contrôle du curseur
- Gestion des clics

## Verbes PowerShell Approuvés

Tous les modules PowerShell utilisent des verbes approuvés :
- `Set-*` : Pour définir un état ou une valeur
- `Start-*` : Pour démarrer un processus ou une application
- `New-*` : Pour créer un nouvel objet
- `Show-*` : Pour afficher une information
- `Invoke-*` : Pour exécuter une action
- `Lock-*` : Pour verrouiller une ressource
- `Restart-*` : Pour redémarrer un service ou système

## Documentation

1. **COMMANDS.md**
   - Liste complète des commandes disponibles
   - Exemples d'utilisation
   - Guide de référence rapide

2. **PATTERNS.md**
   - Guide d'ajout de nouveaux patterns
   - Organisation des patterns par catégorie
   - Exemples et bonnes pratiques
   - Maintenance des expressions régulières

## Principes de Conception

1. **Modularité**
   - Modules hautement spécialisés
   - Responsabilités uniques
   - Interfaces claires

2. **Maintenabilité**
   - Code organisé et documenté
   - Standards de nommage respectés
   - Gestion des erreurs robuste

3. **Extensibilité**
   - Architecture modulaire
   - Patterns réutilisables
   - Facilité d'ajout de nouvelles commandes

4. **Performance**
   - Exécution efficace des commandes
   - Gestion optimisée des ressources
   - Réactivité aux commandes vocales

## Flux d'Exécution

1. Capture de la commande vocale (VoiceRecognizer)
2. Reconnaissance et traduction en texte
3. Analyse des patterns de commande (CommandPatterns)
4. Traitement par le gestionnaire approprié (CommandHandler)
5. Exécution de la commande PowerShell
6. Retour vocal à l'utilisateur

Cette architecture assure une séparation claire des responsabilités tout en maintenant une cohérence dans l'exécution des commandes vocales.
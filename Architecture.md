# Couche de Reconnaissance Vocale

voice/
  ├── recognition/
  │   ├── speech_engine.py      # Moteur de reconnaissance
  │   ├── text_to_speech.py     # Synthèse vocale
  │   └── audio_capture.py      # Capture audio
  ├── patterns/
  │   ├── navigation_patterns.py   # Patterns navigation
  │   ├── control_patterns.py      # Patterns contrôles
  │   └── system_patterns.py       # Patterns système
  └── feedback/
      ├── voice_feedback.py     # Retour vocal
      └── error_feedback.py     # Gestion erreurs

# Couche de Mapping et RoutageCouche

command_mapping/
  ├── core/
  │   ├── command_router.ps1    # Routage des commandes
  │   └── pattern_matcher.ps1   # Matching des patterns
  ├── mappings/
  │   ├── navigation_maps.ps1   # Mapping navigation
  │   ├── control_maps.ps1      # Mapping contrôles
  │   └── system_maps.ps1       # Mapping système
  └── validators/
      ├── param_validator.ps1   # Validation params
      └── context_validator.ps1 # Validation contexte

# Couche d'Actions

actions/
  ├── web/
  │   ├── browser_control.ps1   # Contrôle navigateur
  │   ├── link_actions.ps1      # Actions liens
  │   └── search_actions.ps1    # Actions recherche
  ├── ui/
  │   ├── control_basic.ps1     # Actions UI basiques
  │   ├── control_advanced.ps1  # Actions UI avancées
  │   └── window_manage.ps1     # Gestion fenêtres
  └── system/
      ├── mouse_actions.ps1     # Actions souris
      ├── keyboard_actions.ps1  # Actions clavier
      └── media_actions.ps1     # Actions média

# Couche Utilitaire

utils/
  ├── logging/
  │   ├── action_logger.ps1     # Journalisation
  │   └── error_logger.ps1      # Log erreurs
  ├── config/
  │   ├── settings.ps1          # Configuration
  │   └── constants.ps1         # Constantes
  └── helpers/
      ├── string_utils.ps1      # Utilitaires texte
      └── path_utils.ps1        # Utilitaires chemins

# Avantages de cette structure :

Responsabilité unique par module
Couplage faible entre composants
Cohésion forte dans chaque module
Facilité de maintenance et d'extension
Meilleure testabilité
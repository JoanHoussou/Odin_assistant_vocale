# Guide d'Ajout de Patterns de Commandes

Les patterns de reconnaissance vocale sont définis dans `python_modules/command_patterns.py`. Voici comment ajouter ou modifier les patterns pour chaque type de commande.

## Structure des Patterns

Les patterns sont organisés en classes statiques dans `CommandPatterns` :

```python
class CommandPatterns:
    @staticmethod
    def youtube_search_patterns():
        return [...]

    @staticmethod
    def mouse_patterns():
        return {...}

    @staticmethod
    def ui_patterns():
        return {...}
```

## Catégories de Patterns

### 1. Patterns YouTube
```python
@staticmethod
def youtube_search_patterns():
    return [
        r"cherche(?:r)?\s+sur\s+youtube\s+(.+)",
        r"recherche(?:r)?\s+sur\s+youtube\s+(.+)",
        r"trouve(?:r)?\s+sur\s+youtube\s+(.+)",
        r"youtube\s+cherche(?:r)?\s+(.+)",
        r"youtube\s+recherche(?:r)?\s+(.+)"
    ]
```

### 2. Patterns Souris
```python
@staticmethod
def mouse_patterns():
    return {
        'move': r"(?:déplace|bouge|souris\s+déplacée?)(?:r)?\s+(?:la\s+)?(?:souris\s+)?(?:vers|à|en|aux?|coordinates?)?\s+(\d+)\s*[,\s]\s*(\d+)",
        'click': r"(?:cliquer?|clics?|cliquez)\s+(?:avec\s+)?(?:le\s+)?(?:bouton\s+)?(gauche|droit|milieu)"
    }
```

### 3. Patterns Interface Utilisateur
```python
@staticmethod
def ui_patterns():
    return {
        'click': r"(?:clique[rz]?|cliquez)\s+sur\s+[\"']?(.+?)[\"']?\s+(?:dans|de)\s+[\"']?(.+?)[\"']?",
        'focus': r"(?:focus|sélectionne[rz]?)\s+[\"']?(.+?)[\"']?\s+(?:dans|de)\s+[\"']?(.+?)[\"']?",
        'write': r"(?:écris|saisis?|entre[rz]?)\s+[\"']?(.+?)[\"']?\s+(?:dans|de)\s+[\"']?(.+?)[\"']?\s+(?:de|dans)\s+[\"']?(.+?)[\"']?"
    }
```

### 4. Patterns Fenêtres
```python
@staticmethod
def window_patterns():
    return {
        'minimize': r"minimise[rz]?|cache[rz]?|réduis",
        'restore': r"restaure[rz]?|affiche[rz]?|montre[rz]?",
        'lock': r"verrouille|bloque|sécurise"
    }
```

### 5. Patterns Applications
```python
@staticmethod
def application_patterns():
    return {
        'youtube_open': r'^(ouvrir?|lance[rz]?|démarre[rz]?)\s+youtube$',
        'app_open': [
            r"ouvrir\s+(.+)",
            r"ouvre\s+(.+)",
            r"lance\s+(.+)",
            r"démarre\s+(.+)"
        ]
    }
```

### 6. Patterns Système
```python
@staticmethod
def system_patterns():
    return {
        'shutdown': ["éteindre", "arrêter", "shutdown"],
        'restart': ["redémarrer", "reboot", "restart"],
        'screenshot': r"capture|screenshot|photo|écran"
    }
```

### 7. Patterns Volume
```python
@staticmethod
def volume_patterns():
    return {
        'volume': r'volume|son'
    }
```

## Comment Ajouter un Nouveau Pattern

1. Identifiez la catégorie appropriée (ou créez-en une nouvelle)
2. Ajoutez la méthode statique dans la classe `CommandPatterns`
3. Définissez les patterns avec des expressions régulières
4. Ajoutez la logique de traitement dans `command_handler.py`

### Exemple d'Ajout d'un Nouveau Pattern

```python
# Dans command_patterns.py
@staticmethod
def new_feature_patterns():
    return {
        'action': r"ma nouvelle commande (\w+)"
    }

# Dans command_handler.py
def handle_new_feature(self, command):
    match = re.search(self.patterns.new_feature_patterns()['action'], command)
    if match:
        action = match.group(1)
        # Traitement de la commande
        return True
    return False
```

## Bonnes Pratiques

1. **Nommage Clair**
   - Utilisez des noms descriptifs pour les patterns
   - Groupez les patterns logiquement

2. **Expressions Régulières**
   - Utilisez des groupes nommés pour plus de clarté
   - Testez vos patterns avec plusieurs variations

3. **Documentation**
   - Commentez les patterns complexes
   - Expliquez les groupes de capture

4. **Maintenance**
   - Gardez les patterns organisés par catégorie
   - Évitez la duplication de patterns
class CommandPatterns:
    @staticmethod
    def youtube_search_patterns():
        return [
            r"cherche(?:r)?\s+sur\s+youtube\s+(.+)",
            r"recherche(?:r)?\s+sur\s+youtube\s+(.+)",
            r"trouve(?:r)?\s+sur\s+youtube\s+(.+)",
            r"youtube\s+cherche(?:r)?\s+(.+)",
            r"youtube\s+recherche(?:r)?\s+(.+)"
        ]

    @staticmethod
    def mouse_patterns():
        return {
            'move': r"(?:déplace|bouge|souris\s+déplacée?)(?:r)?\s+(?:la\s+)?(?:souris\s+)?(?:vers|à|en|aux?|coordinates?)?\s+(\d+)\s*[,\s]\s*(\d+)",
            'click': r"(?:cliquer?|clics?|cliquez)\s+(?:avec\s+)?(?:le\s+)?(?:bouton\s+)?(gauche|droit|milieu)"
        }

    @staticmethod
    def ui_patterns():
        return {
            'click': r"(?:clique[rz]?|cliquez)\s+sur\s+[\"']?(.+?)[\"']?\s+(?:dans|de)\s+[\"']?(.+?)[\"']?",
            'focus': r"(?:focus|sélectionne[rz]?)\s+[\"']?(.+?)[\"']?\s+(?:dans|de)\s+[\"']?(.+?)[\"']?",
            'write': r"(?:écris|saisis?|entre[rz]?)\s+[\"']?(.+?)[\"']?\s+(?:dans|de)\s+[\"']?(.+?)[\"']?\s+(?:de|dans)\s+[\"']?(.+?)[\"']?"
        }

    @staticmethod
    def window_patterns():
        return {
            'minimize': r"minimise[rz]?|cache[rz]?|réduis",
            'restore': r"restaure[rz]?|affiche[rz]?|montre[rz]?",
            'lock': r"verrouille|bloque|sécurise"
        }

    @staticmethod
    def application_patterns():
        return {
            'youtube_open': r'^(ouvrir?|lance[rz]?|démarre[rz]?)\s+youtube$',
            'app_open': [r"ouvrir\s+(.+)", r"ouvre\s+(.+)", r"lance\s+(.+)", r"démarre\s+(.+)"]
        }

    @staticmethod
    def system_patterns():
        return {
            'shutdown': ["éteindre", "arrêter", "shutdown"],
            'restart': ["redémarrer", "reboot", "restart"],
            'screenshot': r"capture|screenshot|photo|écran"
        }

    @staticmethod
    def volume_patterns():
        return {
            'volume': r'volume|son'
        }
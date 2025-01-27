class WindowPatterns:
    @staticmethod
    def patterns():
        return {
            'minimize': r"minimise[rz]?|cache[rz]?|réduis",
            'restore': r"restaure[rz]?|affiche[rz]?|montre[rz]?",
            'lock': r"verrouille|bloque|sécurise"
        }
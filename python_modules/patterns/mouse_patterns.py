class MousePatterns:
    @staticmethod
    def patterns():
        return {
            'absolute_move': (
                r"(?i)\b(?:"
                r"déplace(?:r)?|positionne(?:r)?|bouge(?:r)?|décalage|déplacer|positionner"
                r")\b\s+(?:"
                r"(?:la\s+souris\s+)?(?:vers|à|sur|en|aux?)\s+"
                r"(?:coordonnées?\s*)?(?:x\s*)?(\d+)(?:\s*[,;\.\s]\s*|y\s*)(\d+)|"
                r"(?:les?\s+)?(?:coords?\s+)?(\d+)\s+(\d+)"
                r")"
            ),
            'relative_move': (
                r"(?i)\b(?:"
                r"déplace(?:r)?|bouge(?:r)?|décale(?:r)?|glisse(?:r)?|décalage"
                r")\b\s+(?:"
                r"(?:la\s+souris\s+)?(?:de\s+)?(-?\d+)\s*(?:pixels?|pts?)\s+(à\s+gauche|à\s+droite|vers\s+le\s+haut|vers\s+le\s+bas)|"
                r"(?:horizontalement|verticalement)\s+de\s+(-?\d+)|"
                r"(gauche|droite|haut|bas)\s+de\s+(\d+)\s*(?:pixels?|pts?)"
                r")"
            ),
            'click': (
                r"(?i)\b(?:"
                r"clique(?:r|z)?|clic|appui|press(?:er)?|click"
                r")\b(?:\s+"
                r"(?:"
                r"(?:sur\s+)?(?:le\s+)?(?:bouton\s+)?(gauche|droit|milieu|central)|"
                r"(gauche|droite|milieu)(?:\s+bouton)?|"
                r"(?:avec\s+)?(?:le\s+)?(?:bouton\s+)?(principal|secondaire|molette)"
                r"))?"
            ),
            'drag': (
                r"(?i)\b(?:"
                r"glisse(?:r)?|déplace(?:r)?\s+en\s+maintenant|drag(?:ger)?|"
                r"maintenir\s+et\s+déplacer|faire\s+glisser"
                r")\b\s+(?:"
                r"(?:depuis\s+)?(?:les?\s+)?coords?\s+(\d+)\s*[,;]\s*(\d+)\s+vers\s+(\d+)\s*[,;]\s*(\d+)|"
                r"(?:sur\s+)?(?:une\s+)?distance\s+de\s+(\d+)\s+pixels\s+dans\s+la\s+direction\s+(nord|sud|est|ouest)"
                r")"
            ),
            'scroll': (
                r"(?i)\b(?:"
                r"défile(?:r)?|scroll(?:er)?|faire\s+défiler|molette"
                r")\b\s+(?:"
                r"(vers\s+(le\s+)?(haut|bas)|en\s+(haut|bas)|de\s+(\d+)\s+tours?)"
                r")"
            )
        }
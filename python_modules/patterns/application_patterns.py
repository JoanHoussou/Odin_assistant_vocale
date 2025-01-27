class ApplicationPatterns:
    @staticmethod
    def patterns():
        return {
            'youtube_open': r'^(ouvrir?|lance[rz]?|démarre[rz]?)\s+youtube$',
            'app_open': [
                r"ouvrir\s+(.+)",
                r"ouvre\s+(.+)",
                r"lance\s+(.+)",
                r"démarre\s+(.+)"
            ]
        }
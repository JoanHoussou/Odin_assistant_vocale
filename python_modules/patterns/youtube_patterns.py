class YouTubePatterns:
    @staticmethod
    def search_patterns():
        return [
            r"cherche(?:r)?\s+sur\s+youtube\s+(.+)",
            r"recherche(?:r)?\s+sur\s+youtube\s+(.+)",
            r"trouve(?:r)?\s+sur\s+youtube\s+(.+)",
            r"youtube\s+cherche(?:r)?\s+(.+)",
            r"youtube\s+recherche(?:r)?\s+(.+)"
        ]
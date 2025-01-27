class UIPatterns:
    @staticmethod
    def patterns():
        return {
            'click': r"(?:clique[rz]?|cliquez)\s+sur\s+[\"']?(.+?)[\"']?\s+(?:dans|de)\s+[\"']?(.+?)[\"']?",
            'focus': r"(?:focus|sélectionne[rz]?)\s+[\"']?(.+?)[\"']?\s+(?:dans|de)\s+[\"']?(.+?)[\"']?",
            'write': r"(?:écris|saisis?|entre[rz]?)\s+[\"']?(.+?)[\"']?\s+(?:dans|de)\s+[\"']?(.+?)[\"']?\s+(?:de|dans)\s+[\"']?(.+?)[\"']?"
        }
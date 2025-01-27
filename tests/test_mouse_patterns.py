import pytest
from python_modules.patterns.mouse_patterns import MousePatterns
import re

class TestMousePatterns:
    @pytest.fixture
    def patterns(self):
        return MousePatterns.patterns()

    def test_absolute_move_patterns(self, patterns):
        valid_commands = [
            "déplace la souris vers 100 200",
            "positionne en 150 300",
            "bouge à coordonnées 200 400",
            "déplacer vers x100y200",
            "positionner aux coords 300 600"
        ]
        
        for command in valid_commands:
            match = re.search(patterns['absolute_move'], command)
            assert match is not None
            groups = match.groups()
            assert any(groups[:2]) or any(groups[2:])  # Vérifie qu'au moins une paire de coordonnées est capturée

    def test_click_patterns(self, patterns):
        valid_commands = [
            "clic",
            "clique",
            "clic gauche",
            "clique droit",
            "click bouton gauche",
            "cliquer bouton droit",
            "appuie bouton central",
            "press milieu"
        ]
        
        for command in valid_commands:
            match = re.search(patterns['click'], command)
            assert match is not None

    def test_scroll_patterns(self, patterns):
        valid_commands = [
            "défile vers le haut",
            "scroll vers le bas",
            "faire défiler en haut",
            "molette en bas",
            "défiler de 3 tours"
        ]
        
        for command in valid_commands:
            match = re.search(patterns['scroll'], command)
            assert match is not None

    def test_drag_patterns(self, patterns):
        valid_commands = [
            "glisse depuis coords 100,100 vers 200,200",
            "déplacer en maintenant depuis les coords 150,150 vers 300,300",
            "faire glisser sur une distance de 100 pixels dans la direction nord"
        ]
        
        for command in valid_commands:
            match = re.search(patterns['drag'], command)
            assert match is not None

    def test_relative_move_patterns(self, patterns):
        valid_commands = [
            "déplace de 100 pixels à droite",
            "bouge de 50 pixels vers le haut",
            "décale horizontalement de 200",
            "glisse verticalement de 150",
            "décalage gauche de 75 pixels"
        ]
        
        for command in valid_commands:
            match = re.search(patterns['relative_move'], command)
            assert match is not None

    def test_invalid_commands(self, patterns):
        invalid_commands = [
            "déplace",  # Commande incomplète
            "clic sur",  # Commande incomplète
            "déplace souris",  # Pas de coordonnées
            "glisse 100",  # Coordonnées incomplètes
            "scroll autre"  # Direction invalide
        ]
        
        for command in invalid_commands:
            for pattern in patterns.values():
                match = re.search(pattern, command)
                assert match is None, f"La commande invalide '{command}' a été reconnue par le pattern"
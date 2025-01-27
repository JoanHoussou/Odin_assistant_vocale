import pytest
from python_modules.patterns.ui_patterns import UIPatterns
import re

class TestUIPatterns:
    @pytest.fixture
    def patterns(self):
        return UIPatterns.patterns()

    def test_click_patterns(self, patterns):
        valid_commands = [
            "clique sur 'bouton ok' dans 'fenêtre principale'",
            'cliquez sur "valider" dans "dialogue"',
            "clique sur menu dans application",
            'cliquez sur "Fermer" de "Explorateur"',
            "clique sur bouton dans fenêtre"
        ]
        
        for command in valid_commands:
            match = re.search(patterns['click'], command)
            assert match is not None
            assert len(match.groups()) == 2  # Vérifie qu'on capture l'élément et la fenêtre
            element, window = match.groups()
            assert element and window

    def test_focus_patterns(self, patterns):
        valid_commands = [
            "focus 'champ texte' dans 'formulaire'",
            'sélectionne "input" dans "dialogue"',
            "focus zone_texte dans editeur",
            'sélectionner "recherche" de "barre outils"',
            "focus champ dans fenêtre"
        ]
        
        for command in valid_commands:
            match = re.search(patterns['focus'], command)
            assert match is not None
            assert len(match.groups()) == 2
            element, window = match.groups()
            assert element and window

    def test_write_patterns(self, patterns):
        valid_commands = [
            "écris 'Hello World' dans 'champ texte' de 'formulaire'",
            'saisis "test" dans "input" de "dialogue"',
            "entre bonjour dans zone_texte de editeur",
            'écrire "123" dans "nombre" de "formulaire"',
            "saisir texte dans champ de fenêtre"
        ]
        
        for command in valid_commands:
            match = re.search(patterns['write'], command)
            assert match is not None
            assert len(match.groups()) == 3  # Vérifie qu'on capture le texte, l'élément et la fenêtre
            text, element, window = match.groups()
            assert text and element and window

    def test_invalid_commands(self, patterns):
        invalid_commands = [
            "clique sur",  # Commande incomplète
            "focus",  # Commande incomplète
            "écris texte",  # Manque la cible
            "saisir dans",  # Manque le texte et la fenêtre
            "cliquez fenêtre"  # Format incorrect
        ]
        
        for command in invalid_commands:
            for pattern in patterns.values():
                match = re.search(pattern, command)
                assert match is None, f"La commande invalide '{command}' a été reconnue par le pattern"

    def test_quotation_handling(self, patterns):
        mixed_quotes_commands = [
            "clique sur 'bouton' dans \"fenêtre\"",
            'écris "texte" dans \'champ\' de "formulaire"',
            "focus 'élément\" dans 'dialogue'",  # Quotes non correspondantes
            'sélectionne "item\' dans "liste"'   # Quotes non correspondantes
        ]
        
        # Les deux premiers devraient matcher, les deux derniers non
        assert re.search(patterns['click'], mixed_quotes_commands[0]) is not None
        assert re.search(patterns['write'], mixed_quotes_commands[1]) is not None
        assert re.search(patterns['focus'], mixed_quotes_commands[2]) is None
        assert re.search(patterns['focus'], mixed_quotes_commands[3]) is None
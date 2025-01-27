import pytest
from python_modules.command_handler import CommandHandler
from unittest.mock import call

class TestCommandHandler:
    def test_mouse_command_execution(self, command_handler, mock_speech_engine, mock_powershell_executor):
        # Test déplacement absolu de la souris
        command = "déplace la souris vers 100 200"
        command_handler.execute_command(command)
        
        mock_powershell_executor.execute_command.assert_called_with(
            "Invoke-MouseAction -Action Move -X 100 -Y 200"
        )
        mock_speech_engine.say_text.assert_called_with("Souris déplacée vers 100, 200")

    def test_click_command_execution(self, command_handler, mock_speech_engine, mock_powershell_executor):
        # Test clic simple
        command = "clique gauche"
        command_handler.execute_command(command)
        
        mock_powershell_executor.execute_command.assert_called_with(
            "Invoke-MouseAction -Action Click -Button Gauche"
        )
        mock_speech_engine.say_text.assert_called_with("Clic gauche effectué")

    def test_scroll_command_execution(self, command_handler, mock_speech_engine, mock_powershell_executor):
        # Test défilement
        command = "défile vers le haut"
        command_handler.execute_command(command)
        
        mock_powershell_executor.execute_command.assert_called_with(
            "Invoke-MouseAction -Action Scroll -Direction Haut -Scroll 1"
        )
        mock_speech_engine.say_text.assert_called_with("Défilement haut de 1 tour")

    def test_window_commands(self, command_handler, mock_speech_engine, mock_powershell_executor):
        # Test minimisation
        command = "minimise"
        command_handler.execute_command(command)
        
        mock_powershell_executor.execute_command.assert_called_with(
            "Set-WindowState -Action 'MinimizeAll'"
        )
        mock_speech_engine.say_text.assert_called_with("Fenêtres minimisées")

        # Test restauration
        command = "restaure"
        command_handler.execute_command(command)
        
        mock_powershell_executor.execute_command.assert_called_with(
            "Set-WindowState -Action 'RestoreAll'"
        )
        mock_speech_engine.say_text.assert_called_with("Fenêtres restaurées")

    def test_volume_command(self, command_handler, mock_speech_engine, mock_powershell_executor):
        # Test réglage du volume
        command = "volume 50"
        command_handler.execute_command(command)
        
        mock_powershell_executor.execute_command.assert_called_with(
            "Set-SystemVolume -Level 50"
        )
        mock_speech_engine.say_text.assert_called_with("Volume réglé à 50 pour cent")

    def test_youtube_search(self, command_handler, mock_speech_engine, mock_powershell_executor):
        # Test recherche YouTube
        command = "cherche sur youtube musique classique"
        command_handler.execute_command(command)
        
        mock_powershell_executor.execute_command.assert_called_with(
            "Start-Application -AppName 'youtube' -Arguments 'musique classique'"
        )
        mock_speech_engine.say_text.assert_called_with("Recherche de musique classique sur YouTube")

    def test_application_launch(self, command_handler, mock_speech_engine, mock_powershell_executor):
        # Test lancement d'application
        command = "lance notepad"
        command_handler.execute_command(command)
        
        mock_powershell_executor.execute_command.assert_called_with(
            "Start-Application -AppName 'notepad'"
        )
        mock_speech_engine.say_text.assert_called_with("Lancement de notepad")

    def test_system_commands(self, command_handler, mock_speech_engine, mock_powershell_executor):
        # Test commande d'arrêt
        command = "éteindre"
        command_handler.execute_command(command)
        
        mock_powershell_executor.execute_command.assert_called_with(
            "Restart-Shutdown -Action 'Shutdown'"
        )
        mock_speech_engine.say_text.assert_called_with("Arrêt de l'ordinateur")

    def test_error_handling(self, command_handler, mock_speech_engine, mock_powershell_executor):
        # Test avec une commande invalide
        command = "commande invalide"
        command_handler.execute_command(command)
        
        mock_speech_engine.say_text.assert_called_with("Commande non reconnue")
        
        # Test avec une erreur d'exécution PowerShell
        mock_powershell_executor.execute_command.return_value = False
        command = "volume 50"
        command_handler.execute_command(command)
        
        mock_speech_engine.say_text.assert_called_with("Erreur lors du réglage du volume")

    def test_multiple_commands_sequence(self, command_handler, mock_speech_engine, mock_powershell_executor):
        # Test séquence de commandes
        commands = [
            "clique gauche",
            "déplace la souris vers 100 200",
            "volume 75"
        ]
        
        expected_responses = [
            "Clic gauche effectué",
            "Souris déplacée vers 100, 200",
            "Volume réglé à 75 pour cent"
        ]
        
        for command, response in zip(commands, expected_responses):
            command_handler.execute_command(command)
            mock_speech_engine.say_text.assert_called_with(response)
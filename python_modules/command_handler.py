import re
from datetime import datetime
from .command_patterns import CommandPatterns

class CommandHandler:
    def __init__(self, speech_engine, powershell_executor):
        self.speech_engine = speech_engine
        self.ps_executor = powershell_executor
        self.patterns = CommandPatterns()

    def handle_screenshot(self, command):
        if re.search(self.patterns.system_patterns()['screenshot'], command):
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filepath = f"capture_{timestamp}.png"
            if self.ps_executor.execute_command(f"New-Screenshot -Path '{filepath}'"):
                self.speech_engine.say_text("Capture d'écran effectuée")
            else:
                self.speech_engine.say_text("Erreur lors de la capture d'écran")
            return True
        return False

    def handle_mouse_commands(self, command):
        # Gestion du déplacement absolu
        mouse_patterns = self.patterns.mouse_patterns()
        absolute_move_match = re.search(mouse_patterns['absolute_move'], command, re.IGNORECASE)
        if absolute_move_match:
            groups = absolute_move_match.groups()
            x = int(groups[0] or groups[2])
            y = int(groups[1] or groups[3])
            if self.ps_executor.execute_command(f"Invoke-MouseAction -Action Move -X {x} -Y {y}"):
                self.speech_engine.say_text(f"Souris déplacée vers {x}, {y}")
            else:
                self.speech_engine.say_text("Erreur lors du déplacement de la souris")
            return True

        # Gestion du défilement
        scroll_match = re.search(mouse_patterns['scroll'], command)
        if scroll_match:
            direction = None
            amount = 1  # Par défaut, un tour

            # Vérifier la direction
            if "haut" in command.lower() or "nord" in command.lower():
                direction = "Haut"
            elif "bas" in command.lower() or "sud" in command.lower():
                direction = "Bas"

            # Chercher le nombre de tours
            tours_match = re.search(r'(\d+)\s+tours?', command)
            if tours_match:
                try:
                    amount = int(tours_match.group(1))
                except ValueError:
                    amount = 1

            if direction:
                if self.ps_executor.execute_command(
                    f"Invoke-MouseAction -Action Scroll -Direction {direction} -Scroll {amount}"
                ):
                    self.speech_engine.say_text(f"Défilement {direction.lower()} de {amount} tour{'s' if amount > 1 else ''}")
                else:
                    self.speech_engine.say_text("Erreur lors du défilement")
            return True

        # Gestion des clics
        click_match = re.search(mouse_patterns['click'], command)
        if click_match:
            groups = click_match.groups()
            button = next((g for g in groups if g), "gauche")  # Premier groupe non None ou "gauche" par défaut
            # Mapper les boutons alternatifs
            button_map = {
                "principal": "gauche",
                "secondaire": "droit",
                "central": "milieu"
            }
            button = button_map.get(button.lower(), button.lower())
            
            if "double" in command.lower():
                if self.ps_executor.execute_command(f"Invoke-MouseAction -Action Click -Button {button.capitalize()} -Double"):
                    self.speech_engine.say_text(f"Double-clic {button} effectué")
                else:
                    self.speech_engine.say_text("Erreur lors du double-clic")
            else:
                if self.ps_executor.execute_command(f"Invoke-MouseAction -Action Click -Button {button.capitalize()}"):
                    self.speech_engine.say_text(f"Clic {button} effectué")
                else:
                    self.speech_engine.say_text("Erreur lors du clic")
            return True
        return False

    def handle_ui_commands(self, command):
        ui_patterns = self.patterns.ui_patterns()
        
        # Gestion des clics UI
        match = re.search(ui_patterns['click'], command)
        if match:
            control, window = match.groups()
            if self.ps_executor.execute_command(f"Invoke-UIAction -Action Click -WindowTitle '{window}' -ControlName '{control}'"):
                self.speech_engine.say_text(f"Clic effectué sur {control}")
            else:
                self.speech_engine.say_text("Erreur lors du clic sur l'élément")
            return True

        # Gestion du focus
        match = re.search(ui_patterns['focus'], command)
        if match:
            control, window = match.groups()
            if self.ps_executor.execute_command(f"Invoke-UIAction -Action Focus -WindowTitle '{window}' -ControlName '{control}'"):
                self.speech_engine.say_text(f"Focus défini sur {control}")
            else:
                self.speech_engine.say_text("Erreur lors de la définition du focus")
            return True

        # Gestion de la saisie
        match = re.search(ui_patterns['write'], command)
        if match:
            value, control, window = match.groups()
            if self.ps_executor.execute_command(f"Invoke-UIAction -Action SetValue -WindowTitle '{window}' -ControlName '{control}' -Value '{value}'"):
                self.speech_engine.say_text(f"Texte saisi dans {control}")
            else:
                self.speech_engine.say_text("Erreur lors de la saisie du texte")
            return True
        return False

    def handle_window_commands(self, command):
        window_patterns = self.patterns.window_patterns()
        
        if re.search(window_patterns['minimize'], command):
            if self.ps_executor.execute_command("Set-WindowState -Action 'MinimizeAll'"):
                self.speech_engine.say_text("Fenêtres minimisées")
            return True
        
        if re.search(window_patterns['restore'], command):
            if self.ps_executor.execute_command("Set-WindowState -Action 'RestoreAll'"):
                self.speech_engine.say_text("Fenêtres restaurées")
            return True

        if re.search(window_patterns['lock'], command):
            self.speech_engine.say_text("Verrouillage de la session")
            self.ps_executor.execute_command("Lock-Session")
            return True
        return False

    def handle_youtube_commands(self, command):
        # Ouverture simple de YouTube
        if re.match(self.patterns.application_patterns()['youtube_open'], command):
            if self.ps_executor.execute_command("Start-Application -AppName 'youtube'"):
                self.speech_engine.say_text("Ouverture de YouTube")
            else:
                self.speech_engine.say_text("Erreur lors de l'ouverture de YouTube")
            return True

        # Recherche sur YouTube
        for pattern in self.patterns.youtube_search_patterns():
            match = re.search(pattern, command)
            if match:
                search_query = match.group(1).strip()
                if self.ps_executor.execute_command(f"Start-Application -AppName 'youtube' -Arguments '{search_query}'"):
                    self.speech_engine.say_text(f"Recherche de {search_query} sur YouTube")
                else:
                    self.speech_engine.say_text("Erreur lors de la recherche sur YouTube")
                return True
        return False

    def handle_volume_commands(self, command):
        if re.search(self.patterns.volume_patterns()['volume'], command):
            level_match = re.search(r'\d+', command)
            if level_match:
                level_value = int(level_match.group(0))
                if 0 <= level_value <= 100:
                    if self.ps_executor.execute_command(f"Set-SystemVolume -Level {level_value}"):
                        self.speech_engine.say_text(f"Volume réglé à {level_value} pour cent")
                    else:
                        self.speech_engine.say_text("Erreur lors du réglage du volume")
                else:
                    self.speech_engine.say_text("Le volume doit être entre 0 et 100 pour cent")
            else:
                self.speech_engine.say_text("Niveau de volume non spécifié")
            return True
        return False

    def handle_application_commands(self, command):
        if any(x in command.replace("-", "") for x in ["ouvrir", "ouvre", "lance", "démarre"]):
            for pattern in self.patterns.application_patterns()['app_open']:
                match = re.search(pattern, command)
                if match:
                    app = match.group(1).strip()
                    if self.ps_executor.execute_command(f"Start-Application -AppName '{app}'"):
                        self.speech_engine.say_text(f"Lancement de {app}")
                    else:
                        self.speech_engine.say_text(f"Impossible de lancer {app}")
                    return True
            self.speech_engine.say_text("Application non spécifiée")
            return True
        return False

    def handle_system_commands(self, command):
        system_patterns = self.patterns.system_patterns()
        
        if any(x in command for x in system_patterns['shutdown']):
            self.speech_engine.say_text("Arrêt de l'ordinateur")
            self.ps_executor.execute_command("Restart-Shutdown -Action 'Shutdown'")
            return True
            
        if any(x in command for x in system_patterns['restart']):
            self.speech_engine.say_text("Redémarrage de l'ordinateur")
            self.ps_executor.execute_command("Restart-Shutdown -Action 'Restart'")
            return True
        return False

    def execute_command(self, command):
        try:
            handlers = [
                self.handle_screenshot,
                self.handle_mouse_commands,
                self.handle_ui_commands,
                self.handle_window_commands,
                self.handle_youtube_commands,
                self.handle_volume_commands,
                self.handle_application_commands,
                self.handle_system_commands
            ]

            for handler in handlers:
                if handler(command):
                    return

            self.speech_engine.say_text("Commande non reconnue")

        except Exception as e:
            print(f"Erreur lors de l'exécution de la commande: {str(e)}")
            self.speech_engine.say_text("Une erreur s'est produite lors de l'exécution de la commande")
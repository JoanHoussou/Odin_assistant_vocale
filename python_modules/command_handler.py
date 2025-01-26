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
            if self.ps_executor.execute_command(f"Capture-Screenshot -Path '{filepath}'"):
                self.speech_engine.say_text("Capture d'écran effectuée")
            else:
                self.speech_engine.say_text("Erreur lors de la capture d'écran")
            return True
        return False

    def handle_mouse_commands(self, command):
        # Gestion du déplacement de la souris
        mouse_move_match = re.search(self.patterns.mouse_patterns()['move'], command)
        if mouse_move_match:
            x, y = map(int, mouse_move_match.groups())
            if self.ps_executor.execute_command(f"Control-Mouse -Action Move -X {x} -Y {y}"):
                self.speech_engine.say_text(f"Souris déplacée vers {x}, {y}")
            else:
                self.speech_engine.say_text("Erreur lors du déplacement de la souris")
            return True

        # Gestion des clics
        click_match = re.search(self.patterns.mouse_patterns()['click'], command)
        if click_match:
            button = click_match.group(1).capitalize()
            if "double" in command:
                if self.ps_executor.execute_command(f"Control-Mouse -Action DoubleClick -Button {button}"):
                    self.speech_engine.say_text(f"Double-clic {button.lower()} effectué")
                else:
                    self.speech_engine.say_text("Erreur lors du double-clic")
            else:
                if self.ps_executor.execute_command(f"Control-Mouse -Action Click -Button {button}"):
                    self.speech_engine.say_text(f"Clic {button.lower()} effectué")
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
            if self.ps_executor.execute_command(f"Control-UI -Action Click -WindowTitle '{window}' -ControlName '{control}'"):
                self.speech_engine.say_text(f"Clic effectué sur {control}")
            else:
                self.speech_engine.say_text("Erreur lors du clic sur l'élément")
            return True

        # Gestion du focus
        match = re.search(ui_patterns['focus'], command)
        if match:
            control, window = match.groups()
            if self.ps_executor.execute_command(f"Control-UI -Action Focus -WindowTitle '{window}' -ControlName '{control}'"):
                self.speech_engine.say_text(f"Focus défini sur {control}")
            else:
                self.speech_engine.say_text("Erreur lors de la définition du focus")
            return True

        # Gestion de la saisie
        match = re.search(ui_patterns['write'], command)
        if match:
            value, control, window = match.groups()
            if self.ps_executor.execute_command(f"Control-UI -Action SetValue -WindowTitle '{window}' -ControlName '{control}' -Value '{value}'"):
                self.speech_engine.say_text(f"Texte saisi dans {control}")
            else:
                self.speech_engine.say_text("Erreur lors de la saisie du texte")
            return True
        return False

    def handle_window_commands(self, command):
        window_patterns = self.patterns.window_patterns()
        
        if re.search(window_patterns['minimize'], command):
            if self.ps_executor.execute_command("Manage-Windows -Action 'MinimizeAll'"):
                self.speech_engine.say_text("Fenêtres minimisées")
            return True
        
        if re.search(window_patterns['restore'], command):
            if self.ps_executor.execute_command("Manage-Windows -Action 'RestoreAll'"):
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
import tkinter as tk
from tkinter import ttk
from python_modules.command_patterns import CommandPatterns
from python_modules.speech_engine import SpeechEngine
from python_modules.powershell_executor import PowerShellExecutor
from python_modules.command_handler import CommandHandler
from python_modules.voice_recognizer import VoiceRecognizer

class AssistantGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Assistant Vocal")
        self.root.geometry("600x400")

        self.speech_engine = SpeechEngine()
        self.ps_executor = PowerShellExecutor()
        self.command_handler = CommandHandler(self.speech_engine, self.ps_executor)
        self.command_patterns = CommandPatterns()
        self.voice_recognizer = VoiceRecognizer(self.speech_engine)

        self.create_widgets()

    def create_widgets(self):
        # Liste des commandes
        self.command_list = tk.Listbox(self.root, width=60, height=15)
        self.command_list.pack(pady=10)
        self.populate_command_list()

        # Champ de saisie
        self.command_entry = ttk.Entry(self.root, width=50)
        self.command_entry.pack(pady=5)

        # Bouton d'écoute
        self.listen_button = ttk.Button(self.root, text="Écouter", command=self.listen_command)
        self.listen_button.pack(pady=5)

        # Bouton d'exécution
        self.execute_button = ttk.Button(self.root, text="Exécuter", command=self.execute_command)
        self.execute_button.pack(pady=5)

    def populate_command_list(self):
        # Récupérer toutes les commandes possibles
        all_patterns = [
            self.command_patterns.mouse_patterns(),
            self.command_patterns.ui_patterns(),
            self.command_patterns.window_patterns(),
            self.command_patterns.application_patterns(),
            self.command_patterns.system_patterns(),
            self.command_patterns.volume_patterns(),
            self.command_patterns.youtube_search_patterns()
        ]
        
        for patterns in all_patterns:
            if isinstance(patterns, dict):
                for key, pattern in patterns.items():
                    if isinstance(pattern, str):
                        self.command_list.insert(tk.END, f"{key}: {pattern}")
                    elif isinstance(pattern, list):
                        for p in pattern:
                            self.command_list.insert(tk.END, f"{key}: {p}")
            elif isinstance(patterns, list):
                for pattern in patterns:
                    self.command_list.insert(tk.END, f"YouTube: {pattern}")

    def listen_command(self):
        command = self.voice_recognizer.listen_command()
        if command:
            self.command_entry.delete(0, tk.END)
            self.command_entry.insert(0, command)

    def execute_command(self):
        command = self.command_entry.get()
        if command:
            self.command_handler.execute_command(command)
            self.command_entry.delete(0, tk.END)

if __name__ == "__main__":
    root = tk.Tk()
    gui = AssistantGUI(root)
    root.mainloop()
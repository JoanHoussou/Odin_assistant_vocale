import speech_recognition as sr
import pyttsx3
import subprocess
import re
import os
from datetime import datetime

# Variables globales
engine = None

def init_engine():
    """Initialise ou réinitialise le moteur de synthèse vocale"""
    global engine
    engine = pyttsx3.init()

def execute_powershell_command(command):
    """Exécute une commande PowerShell avec le script"""
    script_path = os.path.abspath('audio_commands.ps1')
    ps_command = f'. "{script_path}"; {command}'
    result = subprocess.run(
        ['powershell', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', ps_command],
        capture_output=True,
        text=True
    )
    if result.stderr and "Write-Error" in result.stderr:
        print(f"Erreur PowerShell: {result.stderr}")
        return False
    return True

def say_text(text):
    """Fonction sécurisée pour la synthèse vocale"""
    global engine
    try:
        if engine is None:
            init_engine()
        engine.say(text)
        engine.runAndWait()
    except RuntimeError:
        init_engine()
        engine.say(text)
        engine.runAndWait()

def listen_command():
    recognizer = sr.Recognizer()
    with sr.Microphone() as source:
        print("Dites une commande...")
        audio = recognizer.listen(source)
    
    try:
        command = recognizer.recognize_google(audio, language="fr-FR")
        print(f"Commande détectée : {command}")
        return command.lower()
    except sr.UnknownValueError:
        say_text("Je n'ai pas compris.")
        return None
    except sr.RequestError:
        say_text("Erreur de connexion.")
        return None

def execute_command(command):
    try:
        # Commande de capture d'écran
        if re.search(r"capture|screenshot|photo|écran", command):
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filepath = f"capture_{timestamp}.png"
            if execute_powershell_command(f"Capture-Screenshot -Path '{filepath}'"):
                say_text("Capture d'écran effectuée")
            else:
                say_text("Erreur lors de la capture d'écran")
            return

        # Commandes de gestion des fenêtres
        if re.search(r"minimise|cache|réduis", command):
            if execute_powershell_command("Manage-Windows -Action 'MinimizeAll'"):
                say_text("Fenêtres minimisées")
            return
        
        if re.search(r"restaure|affiche|montre", command):
            if execute_powershell_command("Manage-Windows -Action 'RestoreAll'"):
                say_text("Fenêtres restaurées")
            return

        # Commande de verrouillage
        if re.search(r"verrouille|bloque|sécurise", command):
            say_text("Verrouillage de la session")
            execute_powershell_command("Lock-Session")
            return

        # Vérifier d'abord si c'est une commande d'ouverture simple de YouTube
        if re.match(r'^(ouvrir?|lance[rz]?|démarre[rz]?)\s+youtube$', command):
            if execute_powershell_command("Start-Application -AppName 'youtube'"):
                say_text("Ouverture de YouTube")
            else:
                say_text("Erreur lors de l'ouverture de YouTube")
            return

        # Commandes de recherche YouTube
        youtube_search_patterns = [
            r"cherche(?:r)?\s+sur\s+youtube\s+(.+)",
            r"recherche(?:r)?\s+sur\s+youtube\s+(.+)",
            r"trouve(?:r)?\s+sur\s+youtube\s+(.+)",
            r"youtube\s+cherche(?:r)?\s+(.+)",
            r"youtube\s+recherche(?:r)?\s+(.+)"
        ]
        
        # Vérifier si c'est une recherche YouTube
        for pattern in youtube_search_patterns:
            match = re.search(pattern, command)
            if match:
                search_query = match.group(1).strip()
                if execute_powershell_command(f"Start-Application -AppName 'youtube' -Arguments '{search_query}'"):
                    say_text(f"Recherche de {search_query} sur YouTube")
                else:
                    say_text("Erreur lors de la recherche sur YouTube")
                return

        # Commandes de volume
        if re.search(r'volume|son', command):
            level_match = re.search(r'\d+', command)
            if level_match:
                level_value = int(level_match.group(0))
                if 0 <= level_value <= 100:
                    if execute_powershell_command(f"Set-SystemVolume -Level {level_value}"):
                        say_text(f"Volume réglé à {level_value} pour cent")
                    else:
                        say_text("Erreur lors du réglage du volume")
                else:
                    say_text("Le volume doit être entre 0 et 100 pour cent")
            else:
                say_text("Niveau de volume non spécifié")

        # Commandes d'applications
        elif any(x in command for x in ["ouvrir", "ouvre", "lance", "démarre"]):
            for pattern in [r"ouvrir\s+(.+)", r"ouvre\s+(.+)", r"lance\s+(.+)", r"démarre\s+(.+)"]:
                match = re.search(pattern, command)
                if match:
                    app = match.group(1).strip()
                    if execute_powershell_command(f"Start-Application -AppName '{app}'"):
                        say_text(f"Lancement de {app}")
                    else:
                        say_text(f"Impossible de lancer {app}")
                    break
            else:
                say_text("Application non spécifiée")

        # Commande d'arrêt
        elif any(x in command for x in ["éteindre", "arrêter", "shutdown"]):
            say_text("Arrêt de l'ordinateur")
            execute_powershell_command("Restart-Shutdown -Action 'Shutdown'")

        # Commande de redémarrage
        elif any(x in command for x in ["redémarrer", "reboot", "restart"]):
            say_text("Redémarrage de l'ordinateur")
            execute_powershell_command("Restart-Shutdown -Action 'Restart'")

        else:
            say_text("Commande non reconnue")

    except Exception as e:
        print(f"Erreur lors de l'exécution de la commande: {str(e)}")
        say_text("Une erreur s'est produite lors de l'exécution de la commande")

if __name__ == "__main__":
    print("=== Assistant Vocal ===")
    print("Commandes supportées :")
    print("- 'volume [0-100]' pour régler le volume")
    print("- 'ouvrir/ouvre/lance [application]' pour lancer une application")
    print("  Applications : chrome, google, firefox, bloc-notes, calculatrice, explorateur")
    print("- YouTube :")
    print("  * 'ouvrir youtube' pour aller sur YouTube")
    print("  * 'chercher sur youtube [terme]' pour faire une recherche")
    print("  * 'youtube cherche [terme]' pour faire une recherche")
    print("- Système :")
    print("  * 'capture écran' pour faire une capture d'écran")
    print("  * 'minimise/cache' pour réduire toutes les fenêtres")
    print("  * 'restaure/affiche' pour restaurer les fenêtres")
    print("  * 'verrouille/bloque' pour verrouiller la session")
    print("  * 'éteindre/arrêter' pour arrêter l'ordinateur")
    print("  * 'redémarrer' pour redémarrer l'ordinateur")
    print("Appuyez sur Ctrl+C pour quitter")
    print("====================")
    
    # Initialiser le moteur de synthèse vocale
    init_engine()
    say_text("Assistant vocal prêt")
    
    try:
        while True:
            command = listen_command()
            if command:
                execute_command(command)
    except KeyboardInterrupt:
        print("\nArrêt de l'assistant vocal...")
        say_text("Au revoir")
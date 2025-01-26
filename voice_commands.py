from python_modules import (
    SpeechEngine,
    VoiceRecognizer,
    PowerShellExecutor,
    CommandHandler,
    ConsoleInterface
)

def main():
    # Initialisation de l'interface console
    console = ConsoleInterface()
    console.show_startup_message()
    
    # Initialisation des composants
    speech_engine = SpeechEngine()
    ps_executor = PowerShellExecutor()
    command_handler = CommandHandler(speech_engine, ps_executor)
    voice_recognizer = VoiceRecognizer(speech_engine)
    
    # Affichage de l'aide
    console.show_help()
    
    # Message de démarrage
    speech_engine.say_text("Assistant vocal prêt")
    
    try:
        while True:
            command = voice_recognizer.listen_command()
            if command:
                command_handler.execute_command(command)
    except KeyboardInterrupt:
        console.show_shutdown_message()
        speech_engine.say_text("Au revoir")

if __name__ == "__main__":
    main()
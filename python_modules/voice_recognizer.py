import speech_recognition as sr

class VoiceRecognizer:
    def __init__(self, speech_engine):
        self.recognizer = sr.Recognizer()
        self.speech_engine = speech_engine
    
    def listen_command(self):
        """Écoute et reconnaît une commande vocale"""
        with sr.Microphone() as source:
            print("Dites une commande...")
            audio = self.recognizer.listen(source)
        
        try:
            command = self.recognizer.recognize_google(audio, language="fr-FR")
            print(f"Commande détectée : {command}")
            return command.lower()
        except sr.UnknownValueError:
            self.speech_engine.say_text("Je n'ai pas compris.")
            return None
        except sr.RequestError:
            self.speech_engine.say_text("Erreur de connexion.")
            return None
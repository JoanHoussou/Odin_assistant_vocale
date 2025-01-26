import pyttsx3

class SpeechEngine:
    def __init__(self):
        self.engine = None
        self.init_engine()
    
    def init_engine(self):
        """Initialise ou réinitialise le moteur de synthèse vocale"""
        self.engine = pyttsx3.init()
    
    def say_text(self, text):
        """Fonction sécurisée pour la synthèse vocale"""
        try:
            if self.engine is None:
                self.init_engine()
            self.engine.say(text)
            self.engine.runAndWait()
        except RuntimeError:
            self.init_engine()
            self.engine.say(text)
            self.engine.runAndWait()
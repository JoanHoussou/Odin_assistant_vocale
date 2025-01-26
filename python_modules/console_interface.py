class ConsoleInterface:
    @staticmethod
    def show_help():
        """Affiche l'aide et les commandes supportées"""
        print("=== Assistant Vocal ===")
        print("Commandes supportées :")
        print("- 'volume [0-100]' pour régler le volume")
        print("- 'ouvrir/ouvre/lance [application]' pour lancer une application")
        print("  Applications : chrome, google, firefox, bloc-notes (ou bloc-note), calculatrice, explorateur")
        print("- YouTube :")
        print("  * 'ouvrir youtube' pour aller sur YouTube")
        print("  * 'chercher sur youtube [terme]' pour faire une recherche")
        print("  * 'youtube cherche [terme]' pour faire une recherche")
        print("- Système :")
        print("  * 'capture écran' pour faire une capture d'écran")
        print("  * 'minimise/minimisez/cache' pour réduire toutes les fenêtres")
        print("  * 'restaure/restaurez/affiche' pour restaurer les fenêtres")
        print("  * 'verrouille/bloque' pour verrouiller la session")
        print("  * 'éteindre/arrêter' pour arrêter l'ordinateur")
        print("  * 'redémarrer' pour redémarrer l'ordinateur")
        print("- Souris :")
        print("  * 'déplacer souris vers X,Y' ou 'souris déplacée vers X,Y'")
        print("  * 'cliquer/cliquez [bouton] gauche/droit/milieu'")
        print("  * 'double-cliquer/double clic [bouton]'")
        print("- Interface :")
        print("  * 'cliquer/cliquez sur bouton dans fenêtre'")
        print("  * 'focus sur champ dans fenêtre'")
        print("  * 'écrire/saisir texte dans champ de fenêtre'")
        print("Note : Les guillemets sont optionnels pour les noms de boutons,")
        print("       champs et fenêtres dans les commandes d'interface")
        print("Appuyez sur Ctrl+C pour quitter")
        print("====================")

    @staticmethod
    def show_startup_message():
        """Affiche le message de démarrage"""
        print("=== Assistant Vocal ===")
        print("Initialisation...")

    @staticmethod
    def show_shutdown_message():
        """Affiche le message d'arrêt"""
        print("\nArrêt de l'assistant vocal...")
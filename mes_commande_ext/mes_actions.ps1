# Module principal regroupant toutes les fonctions d'actions système
# À intégrer avec les commandes vocales
# Version: 1.0

# Importation des modules spécialisés
$modulePath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Modules de base
. "$modulePath\action_configuration.ps1"
. "$modulePath\action_application.ps1"
. "$modulePath\action_controles.ps1"
. "$modulePath\action_souris.ps1"
. "$modulePath\action_texte.ps1"
. "$modulePath\action_multimedia.ps1"
. "$modulePath\action_saisie.ps1"

# Modules avancés
. "$modulePath\action_controles_avances.ps1"
. "$modulePath\action_navigateur.ps1"
. "$modulePath\action_navigateur_avance.ps1"

# Initialisation par défaut
Initialize-Configuration

# Exportation de toutes les fonctions
$publicFunctions = @(
    # Configuration
    'Initialize-Configuration',
    'Write-ActionLog',
    
    # Application
    'Start-AppVocale',
    'Stop-AppVocale',
    'Switch-ApplicationWindow',
    
    # Contrôles (base et avancé)
    'Invoke-ControlClick',
    'Set-ControlFocus',
    'Set-ControlValue',
    'Ignorer-Action',
    'Verifie-Controle',
    'Decoche-Controle',
    'Developpe-Controle',
    'Defile-Controle',
    'Recherche-Controle',
    
    # Navigation Web
    'Ouvrir-NavigateurURL',
    'Rechercher-Google',
    'Naviguer-Onglets',
    'Interagir-Page',
    'Cliquer-LienWeb',
    
    # Souris
    'Move-SourisVocale',
    'Invoke-ClicVocal',
    
    # Texte
    'Select-TexteVocal',
    'Format-TexteVocal',
    
    # Multimédia
    'Control-MediaVocal',
    'Capture-EcranVocale',
    
    # Saisie
    'Start-DicteeVocale',
    'Set-VolumeVocal',
    'Set-EtatSystemeVocal',
    'Set-EcranVocal',
    'Set-ZoomVocal',
    'Start-NarrateurVocal',
    'New-Rappel',
    'Start-MinuteurVocal'
)

Export-ModuleMember -Function $publicFunctions

Write-Host "Module mes_actions chargé avec succès. Toutes les fonctions sont prêtes pour l'intégration avec les commandes vocales."

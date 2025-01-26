# Module de configuration pour les actions système
# Version: 1.0

# Variables globales de configuration
$script:ConfigurationGlobale = @{
    DelaiEntreLesActions = 100
    ModeDebug = $false
}

# Fonction d'initialisation de la configuration
function Initialize-Configuration {
    param (
        [int]$DelaiEntreLesActions = 100,
        [bool]$ModeDebug = $false
    )
    try {
        $script:ConfigurationGlobale.DelaiEntreLesActions = $DelaiEntreLesActions
        $script:ConfigurationGlobale.ModeDebug = $ModeDebug
        Write-ActionLog "Configuration initialisée avec succès"
    }
    catch {
        Write-Error "Erreur lors de l'initialisation de la configuration: $_"
    }
}

# Fonction de journalisation
function Write-ActionLog {
    param (
        [string]$Message,
        [ValidateSet('Info', 'Warning', 'Error')]
        [string]$Type = 'Info'
    )
    if ($script:ConfigurationGlobale.ModeDebug) {
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logMessage = "[$timestamp] [$Type] $Message"
        
        switch ($Type) {
            'Info' { Write-Host $logMessage -ForegroundColor Gray }
            'Warning' { Write-Host $logMessage -ForegroundColor Yellow }
            'Error' { Write-Host $logMessage -ForegroundColor Red }
        }
    }
}

# Fonction utilitaire pour la validation des paramètres
function Test-ParameterValid {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$Parameters,
        [Parameter(Mandatory=$true)]
        [string[]]$RequiredParams
    )
    try {
        foreach ($param in $RequiredParams) {
            if (-not $Parameters.ContainsKey($param)) {
                throw "Paramètre requis manquant: $param"
            }
        }
        return $true
    }
    catch {
        Write-ActionLog "Erreur de validation des paramètres: $_" -Type Error
        return $false
    }
}

# Fonction pour obtenir les délais configurés
function Get-ActionDelay {
    param (
        [ValidateSet('Court', 'Moyen', 'Long')]
        [string]$Type = 'Moyen'
    )
    switch ($Type) {
        'Court' { return [int]($script:ConfigurationGlobale.DelaiEntreLesActions * 0.5) }
        'Long' { return [int]($script:ConfigurationGlobale.DelaiEntreLesActions * 2) }
        default { return $script:ConfigurationGlobale.DelaiEntreLesActions }
    }
}

# Exportation des fonctions
Export-ModuleMember -Function @(
    'Initialize-Configuration',
    'Write-ActionLog',
    'Test-ParameterValid',
    'Get-ActionDelay'
)
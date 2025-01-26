# Importer les assemblies nécessaires
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Web
Add-Type -AssemblyName PresentationFramework

# Définir les chemins
$scriptRoot = $PSScriptRoot
$mesCommandesPath = Join-Path $scriptRoot "mes_commande_ext"
$modulesPath = Join-Path $scriptRoot "modules"

# Importer les fichiers de mes_commande_ext dans l'ordre
$mesCommandesFiles = @(
    "action_configuration.ps1",
    "action_application.ps1",
    "action_controles.ps1",
    "action_souris.ps1",
    "action_texte.ps1",
    "action_multimedia.ps1",
    "action_saisie.ps1",
    "action_controles_avances.ps1",
    "action_navigateur.ps1",
    "action_navigateur_avance.ps1"
)

# Charger chaque fichier de mes_commande_ext
foreach ($file in $mesCommandesFiles) {
    $filePath = Join-Path $mesCommandesPath $file
    if (Test-Path $filePath) {
        . $filePath
    } else {
        Write-Error "Fichier non trouvé: $filePath"
    }
}

# Importer mes_actions.ps1 après avoir chargé ses dépendances
$mesActionsPath = Join-Path $mesCommandesPath "mes_actions.ps1"
if (Test-Path $mesActionsPath) {
    . $mesActionsPath
} else {
    Write-Error "Module mes_actions non trouvé: $mesActionsPath"
}

# Importer les modules PowerShell en tant que scripts
$moduleFiles = @(
    "VolumeManager.ps1",
    "ApplicationManager.ps1",
    "SystemManager.ps1",
    "WindowManager.ps1",
    "UIManager.ps1",
    "MouseManager.ps1"
)

# Charger chaque module
foreach ($moduleFile in $moduleFiles) {
    $modulePath = Join-Path $modulesPath $moduleFile
    if (Test-Path $modulePath) {
        . $modulePath
    } else {
        Write-Error "Module non trouvé: $modulePath"
    }
}

# Vérifier que toutes les fonctions requises sont disponibles
$requiredFunctions = @(
    'Set-SystemVolume',
    'Start-Application',
    'Restart-Shutdown',
    'Lock-Session',
    'Set-WindowState',
    'Invoke-UIAction',
    'Show-Notification',
    'New-Screenshot',
    'Invoke-MouseAction'
)

$missingFunctions = $requiredFunctions | Where-Object { -not (Get-Command $_ -ErrorAction SilentlyContinue) }
if ($missingFunctions) {
    Write-Error "Fonctions manquantes: $($missingFunctions -join ', ')"
}

# Initialiser la configuration de mes_actions
if (Get-Command "Initialize-Configuration" -ErrorAction SilentlyContinue) {
    Initialize-Configuration
}

Write-Host "Tous les modules ont été chargés avec succès"
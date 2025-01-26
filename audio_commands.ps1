# Importer les modules
$modulesPath = Join-Path $PSScriptRoot "modules"
$moduleFiles = @(
    "VolumeManager.ps1",
    "ApplicationManager.ps1",
    "SystemManager.ps1",
    "WindowManager.ps1",
    "UIManager.ps1",
    "MouseManager.ps1"
)

foreach ($module in $moduleFiles) {
    $modulePath = Join-Path $modulesPath $module
    if (Test-Path $modulePath) {
        . $modulePath
    } else {
        Write-Error "Module non trouvé: $modulePath"
    }
}

# Importer le module mes_actions pour les fonctions externes
$mesActionsPath = Join-Path $PSScriptRoot "mes_commande_ext\mes_actions.ps1"
if (Test-Path $mesActionsPath) {
    . $mesActionsPath
} else {
    Write-Error "Module mes_actions non trouvé: $mesActionsPath"
}

# Exporter toutes les fonctions pour qu'elles soient accessibles
Export-ModuleMember -Function @(
    'Set-SystemVolume',
    'Start-Application',
    'Restart-Shutdown',
    'Lock-Session',
    'Manage-Windows',
    'Control-UI',
    'Show-Notification',
    'Capture-Screenshot',
    'Control-Mouse'
)
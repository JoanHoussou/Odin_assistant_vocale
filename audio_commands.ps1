# Importer les assemblies nécessaires
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Web
Add-Type -AssemblyName PresentationFramework

# Importer tous les modules PowerShell
$modulesPath = Join-Path $PSScriptRoot "modules"
$moduleFiles = @(
    "VolumeManager.ps1",
    "ApplicationManager.ps1",
    "SystemManager.ps1",
    "WindowManager.ps1",
    "UIManager.ps1",
    "MouseManager.ps1"
)

# Charger chaque module
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
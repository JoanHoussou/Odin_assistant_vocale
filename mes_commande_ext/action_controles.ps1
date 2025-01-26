# Module d'actions pour les contrôles d'interface
# Version: 2.0
# Utilise UIAutomation pour une meilleure fiabilité

# Chargement du module UIAutomation
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes

function Get-UIAWindow {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [int]$TimeoutSec = 10
    )
    try {
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $automation = [Windows.Automation.AutomationElement]::RootElement
        
        while ($stopwatch.Elapsed.TotalSeconds -lt $TimeoutSec) {
            $condition = New-Object Windows.Automation.PropertyCondition(
                [Windows.Automation.AutomationElement]::NameProperty, 
                $Title
            )
            $window = $automation.FindFirst(
                [Windows.Automation.TreeScope]::Children, 
                $condition
            )
            
            if ($window) {
                return $window
            }
            Start-Sleep -Milliseconds 500
        }
        throw "Fenêtre '$Title' non trouvée après $TimeoutSec secondes"
    }
    catch {
        Write-ActionLog "Erreur lors de la recherche de la fenêtre: $_" -Type Error
        return $null
    }
}

function Get-UIAControl {
    param (
        [Parameter(Mandatory=$true)]
        [Windows.Automation.AutomationElement]$Window,
        [string]$Name = "",
        [string]$AutomationId = "",
        [string]$ClassName = "",
        [int]$TimeoutSec = 10
    )
    try {
        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        
        while ($stopwatch.Elapsed.TotalSeconds -lt $TimeoutSec) {
            $condition = $null
            
            if ($AutomationId) {
                $condition = New-Object Windows.Automation.PropertyCondition(
                    [Windows.Automation.AutomationElement]::AutomationIdProperty, 
                    $AutomationId
                )
            }
            elseif ($Name) {
                $condition = New-Object Windows.Automation.PropertyCondition(
                    [Windows.Automation.AutomationElement]::NameProperty, 
                    $Name
                )
            }
            elseif ($ClassName) {
                $condition = New-Object Windows.Automation.PropertyCondition(
                    [Windows.Automation.AutomationElement]::ClassNameProperty, 
                    $ClassName
                )
            }
            
            if ($condition) {
                $control = $Window.FindFirst(
                    [Windows.Automation.TreeScope]::Descendants, 
                    $condition
                )
                if ($control) {
                    return $control
                }
            }
            Start-Sleep -Milliseconds 500
        }
        throw "Contrôle non trouvé après $TimeoutSec secondes"
    }
    catch {
        Write-ActionLog "Erreur lors de la recherche du contrôle: $_" -Type Error
        return $null
    }
}

function Invoke-ControlClick {
    param(
        [string]$WindowTitle,
        [string]$ControlName,
        [string]$AutomationId = "",
        [string]$ClassName = "",
        [int]$TimeoutSec = 10,
        [switch]$Double
    )
    try {
        Write-ActionLog "Recherche de la fenêtre '$WindowTitle'"
        $window = Get-UIAWindow -Title $WindowTitle -TimeoutSec $TimeoutSec
        
        if ($window) {
            Write-ActionLog "Recherche du contrôle dans la fenêtre"
            $control = Get-UIAControl -Window $window `
                -Name $ControlName `
                -AutomationId $AutomationId `
                -ClassName $ClassName `
                -TimeoutSec $TimeoutSec
            
            if ($control) {
                $pattern = $control.GetCurrentPattern(
                    [Windows.Automation.InvokePattern]::Pattern
                )
                
                if ($Double) {
                    $pattern.Invoke()
                    Start-Sleep -Milliseconds (Get-ActionDelay -Type 'Court')
                    $pattern.Invoke()
                    Write-ActionLog "Double-clic effectué sur le contrôle"
                }
                else {
                    $pattern.Invoke()
                    Write-ActionLog "Clic effectué sur le contrôle"
                }
                return $true
            }
        }
        return $false
    }
    catch {
        Write-ActionLog "Erreur lors du clic sur le contrôle: $_" -Type Error
        return $false
    }
}

function Set-ControlFocus {
    param(
        [string]$WindowTitle,
        [string]$ControlName,
        [string]$AutomationId = "",
        [string]$ClassName = "",
        [int]$TimeoutSec = 10
    )
    try {
        Write-ActionLog "Recherche de la fenêtre '$WindowTitle'"
        $window = Get-UIAWindow -Title $WindowTitle -TimeoutSec $TimeoutSec
        
        if ($window) {
            Write-ActionLog "Recherche du contrôle pour focus"
            $control = Get-UIAControl -Window $window `
                -Name $ControlName `
                -AutomationId $AutomationId `
                -ClassName $ClassName `
                -TimeoutSec $TimeoutSec
            
            if ($control) {
                $control.SetFocus()
                Write-ActionLog "Focus défini sur le contrôle"
                return $true
            }
        }
        return $false
    }
    catch {
        Write-ActionLog "Erreur lors de la définition du focus: $_" -Type Error
        return $false
    }
}

function Set-ControlValue {
    param(
        [string]$WindowTitle,
        [string]$ControlName,
        [string]$AutomationId = "",
        [string]$ClassName = "",
        [string]$Value,
        [int]$TimeoutSec = 10
    )
    try {
        Write-ActionLog "Recherche de la fenêtre '$WindowTitle'"
        $window = Get-UIAWindow -Title $WindowTitle -TimeoutSec $TimeoutSec
        
        if ($window) {
            Write-ActionLog "Recherche du contrôle pour définir la valeur"
            $control = Get-UIAControl -Window $window `
                -Name $ControlName `
                -AutomationId $AutomationId `
                -ClassName $ClassName `
                -TimeoutSec $TimeoutSec
            
            if ($control) {
                $pattern = $control.GetCurrentPattern(
                    [Windows.Automation.ValuePattern]::Pattern
                )
                $pattern.SetValue($Value)
                Write-ActionLog "Valeur définie sur le contrôle"
                return $true
            }
        }
        return $false
    }
    catch {
        Write-ActionLog "Erreur lors de la définition de la valeur: $_" -Type Error
        return $false
    }
}

# Exportation des fonctions
Export-ModuleMember -Function @(
    'Invoke-ControlClick',
    'Set-ControlFocus',
    'Set-ControlValue'
)
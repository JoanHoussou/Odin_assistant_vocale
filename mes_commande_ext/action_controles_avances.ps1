# Module d'actions avancées pour les contrôles d'interface
# Version: 1.0
# Utilise UIAutomation pour des interactions complexes

# Chargement du module UIAutomation si nécessaire
if (-not ('Windows.Automation.AutomationElement' -as [type])) {
    Add-Type -AssemblyName UIAutomationClient
    Add-Type -AssemblyName UIAutomationTypes
}

#region Fonctions d'interaction avancées
function Ignorer-Action {
    param(
        [string]$WindowTitle,
        [string]$ButtonToClickName = "Annuler",
        [string]$AutomationId = "",
        [int]$TimeoutSec = 10
    )

    try {
        Write-ActionLog "Tentative d'ignorer action dans la fenêtre '$WindowTitle'"
        $Window = Get-UIAWindow -Title $WindowTitle
        if ($AutomationId) {
            $Button = Get-UIAControl -Window $Window -AutomationId $AutomationId
        } else {
            $Button = Get-UIAControl -Window $Window -Name $ButtonToClickName
        }

        if ($Button) {
            Invoke-UIAControlAction -Control $Button -Action "Click"
            Write-ActionLog "Action ignorée avec succès (clic sur '$ButtonToClickName')"
            return $true
        } else {
            Write-ActionLog "Bouton non trouvé pour ignorer l'action" -Type Warning
            return $false
        }
    }
    catch {
        Write-ActionLog "Erreur lors de l'action d'ignorer: $_" -Type Error
        return $false
    }
}

function Verifie-Controle {
    param(
        [string]$WindowTitle,
        [string]$ControlName,
        [string]$AutomationId = "",
        [int]$TimeoutSec = 10
    )

    try {
        Write-ActionLog "Vérification du contrôle '$ControlName'"
        $Window = Get-UIAWindow -Title $WindowTitle
        $Control = if ($AutomationId) {
            Get-UIAControl -Window $Window -AutomationId $AutomationId
        } else {
            Get-UIAControl -Window $Window -Name $ControlName
        }

        if ($Control) {
            $togglePattern = $Control.GetCurrentPattern([Windows.Automation.TogglePattern]::Pattern)
            if ($togglePattern -and $togglePattern.Current.ToggleState -ne 'On') {
                $togglePattern.Toggle()
                Write-ActionLog "Contrôle vérifié avec succès"
                return $true
            }
            elseif ($togglePattern.Current.ToggleState -eq 'On') {
                Write-ActionLog "Le contrôle était déjà vérifié"
                return $true
            }
        }
        Write-ActionLog "Contrôle non trouvé ou non vérifiable" -Type Warning
        return $false
    }
    catch {
        Write-ActionLog "Erreur lors de la vérification: $_" -Type Error
        return $false
    }
}

function Decoche-Controle {
    param(
        [string]$WindowTitle,
        [string]$ControlName,
        [string]$AutomationId = "",
        [int]$TimeoutSec = 10
    )

    try {
        Write-ActionLog "Décochage du contrôle '$ControlName'"
        $Window = Get-UIAWindow -Title $WindowTitle
        $Control = if ($AutomationId) {
            Get-UIAControl -Window $Window -AutomationId $AutomationId
        } else {
            Get-UIAControl -Window $Window -Name $ControlName
        }

        if ($Control) {
            $togglePattern = $Control.GetCurrentPattern([Windows.Automation.TogglePattern]::Pattern)
            if ($togglePattern -and $togglePattern.Current.ToggleState -ne 'Off') {
                $togglePattern.Toggle()
                Write-ActionLog "Contrôle décoché avec succès"
                return $true
            }
            elseif ($togglePattern.Current.ToggleState -eq 'Off') {
                Write-ActionLog "Le contrôle était déjà décoché"
                return $true
            }
        }
        Write-ActionLog "Contrôle non trouvé ou non décochable" -Type Warning
        return $false
    }
    catch {
        Write-ActionLog "Erreur lors du décochage: $_" -Type Error
        return $false
    }
}

function Developpe-Controle {
    param(
        [string]$WindowTitle,
        [string]$ControlName,
        [string]$AutomationId = "",
        [int]$TimeoutSec = 10
    )

    try {
        Write-ActionLog "Développement du contrôle '$ControlName'"
        $Window = Get-UIAWindow -Title $WindowTitle
        $Control = if ($AutomationId) {
            Get-UIAControl -Window $Window -AutomationId $AutomationId
        } else {
            Get-UIAControl -Window $Window -Name $ControlName
        }

        if ($Control) {
            $expandPattern = $Control.GetCurrentPattern([Windows.Automation.ExpandCollapsePattern]::Pattern)
            if ($expandPattern -and $expandPattern.Current.ExpandCollapseState -ne 'Expanded') {
                $expandPattern.Expand()
                Write-ActionLog "Contrôle développé avec succès"
                return $true
            }
            elseif ($expandPattern.Current.ExpandCollapseState -eq 'Expanded') {
                Write-ActionLog "Le contrôle était déjà développé"
                return $true
            }
        }
        Write-ActionLog "Contrôle non trouvé ou non développable" -Type Warning
        return $false
    }
    catch {
        Write-ActionLog "Erreur lors du développement: $_" -Type Error
        return $false
    }
}

function Defile-Controle {
    param(
        [string]$WindowTitle,
        [string]$ControlName,
        [ValidateSet('Haut', 'Bas', 'Gauche', 'Droite')]
        [string]$Direction,
        [int]$Distance = 1,
        [string]$AutomationId = "",
        [int]$TimeoutSec = 10
    )

    try {
        Write-ActionLog "Défilement du contrôle '$ControlName' direction '$Direction'"
        $Window = Get-UIAWindow -Title $WindowTitle
        $Control = if ($AutomationId) {
            Get-UIAControl -Window $Window -AutomationId $AutomationId
        } else {
            Get-UIAControl -Window $Window -Name $ControlName
        }

        if ($Control) {
            $scrollPattern = $Control.GetCurrentPattern([Windows.Automation.ScrollPattern]::Pattern)
            if ($scrollPattern) {
                1..$Distance | ForEach-Object {
                    switch ($Direction) {
                        'Haut' { $scrollPattern.ScrollVertical([Windows.Automation.ScrollAmount]::SmallDecrement) }
                        'Bas' { $scrollPattern.ScrollVertical([Windows.Automation.ScrollAmount]::SmallIncrement) }
                        'Gauche' { $scrollPattern.ScrollHorizontal([Windows.Automation.ScrollAmount]::SmallDecrement) }
                        'Droite' { $scrollPattern.ScrollHorizontal([Windows.Automation.ScrollAmount]::SmallIncrement) }
                    }
                    Start-Sleep -Milliseconds (Get-ActionDelay -Type 'Court')
                }
                Write-ActionLog "Défilement effectué avec succès"
                return $true
            }
        }
        Write-ActionLog "Contrôle non trouvé ou non défilable" -Type Warning
        return $false
    }
    catch {
        Write-ActionLog "Erreur lors du défilement: $_" -Type Error
        return $false
    }
}

function Recherche-Controle {
    param(
        [string]$WindowTitle,
        [string]$MotRecherche,
        [int]$TimeoutSec = 10,
        [switch]$SetFocus
    )

    try {
        Write-ActionLog "Recherche du mot '$MotRecherche' dans la fenêtre '$WindowTitle'"
        $Window = Get-UIAWindow -Title $WindowTitle
        
        $condition = New-Object Windows.Automation.PropertyCondition(
            [Windows.Automation.AutomationElement]::NameProperty,
            "*$MotRecherche*",
            [Windows.Automation.PropertyConditionFlags]::IgnoreCase
        )

        $controles = $Window.FindAll(
            [Windows.Automation.TreeScope]::Descendants,
            $condition
        )

        if ($controles -and $controles.Count -gt 0) {
            $controle = $controles[0]
            if ($SetFocus) {
                $controle.SetFocus()
            }
            Write-ActionLog "Contrôle trouvé: '$($controle.Current.Name)'"
            return $controle
        }
        
        Write-ActionLog "Aucun contrôle trouvé contenant '$MotRecherche'" -Type Warning
        return $null
    }
    catch {
        Write-ActionLog "Erreur lors de la recherche: $_" -Type Error
        return $null
    }
}

# Exportation des fonctions
Export-ModuleMember -Function @(
    'Ignorer-Action',
    'Verifie-Controle',
    'Decoche-Controle',
    'Developpe-Controle',
    'Defile-Controle',
    'Recherche-Controle'
)
# Module d'actions avancées pour la navigation web
# Version: 1.0
# Utilise UIAutomation pour des interactions complexes avec les navigateurs

function Cliquer-LienWeb {
    param(
        [Parameter(Mandatory=$true)]
        [string]$WindowTitleNavigateur,
        [Parameter(Mandatory=$true)]
        [string]$TexteLien,
        [switch]$AttendreChargement,
        [int]$DelaiAttente = 2
    )
    try {
        Write-ActionLog "Recherche du lien: '$TexteLien' dans la fenêtre '$WindowTitleNavigateur'"
        
        # Recherche de la fenêtre avec gestion des variations de titre
        $fenetre = $null
        $titresPossibles = @(
            $WindowTitleNavigateur,
            "*$WindowTitleNavigateur*",
            "$WindowTitleNavigateur*",
            "*$WindowTitleNavigateur - *"
        )
        
        foreach ($titre in $titresPossibles) {
            try {
                $fenetre = Get-UIAWindow -Title $titre -ErrorAction SilentlyContinue
                if ($fenetre) {
                    Write-ActionLog "Fenêtre trouvée avec le titre '$titre'"
                    break
                }
            }
            catch { continue }
        }
        
        if (-not $fenetre) {
            throw "Fenêtre du navigateur non trouvée"
        }

        # Recherche du lien avec différentes stratégies
        $lien = $null
        $strategies = @(
            # Stratégie 1: Texte exact
            { Get-UIAControl -Window $fenetre -ControlType Hyperlink -Name $TexteLien },
            # Stratégie 2: Texte partiel
            { Get-UIAControl -Window $fenetre -ControlType Hyperlink -Name "*$TexteLien*" },
            # Stratégie 3: Recherche dans tous les éléments cliquables
            { Get-UIAControl -Window $fenetre -ControlType Button,Hyperlink,Link -Name "*$TexteLien*" }
        )

        foreach ($strategy in $strategies) {
            try {
                $lien = & $strategy
                if ($lien) {
                    Write-ActionLog "Lien trouvé avec la stratégie de recherche"
                    break
                }
            }
            catch { continue }
        }

        if ($lien) {
            $lien.SetFocus()
            Start-Sleep -Milliseconds (Get-ActionDelay -Type 'Court')
            
            if ($lien.Current.IsInvokePatternAvailable) {
                $pattern = $lien.GetCurrentPattern([Windows.Automation.InvokePattern]::Pattern)
                $pattern.Invoke()
            }
            else {
                Send-Keys "{ENTER}"
            }
            
            Write-ActionLog "Lien cliqué avec succès"
            
            if ($AttendreChargement) {
                Write-ActionLog "Attente du chargement de la page..."
                Start-Sleep -Seconds $DelaiAttente
            }
            
            return $true
        }
        else {
            Write-ActionLog "Lien '$TexteLien' non trouvé" -Type Warning
            return $false
        }
    }
    catch {
        Write-ActionLog "Erreur lors du clic sur le lien: $_" -Type Error
        return $false
    }
}

# Exportation des fonctions
Export-ModuleMember -Function @(
    'Cliquer-LienWeb'
)
# Module d'actions pour la navigation web
# Version: 1.0
# Utilise UIAutomation pour interagir avec les navigateurs

function Ouvrir-NavigateurURL {
    param(
        [Parameter(Mandatory=$true)]
        [string]$URL,
        [ValidateSet('Chrome', 'Firefox', 'Edge', 'Default')]
        [string]$Navigateur = 'Default'
    )
    try {
        Write-ActionLog "Ouverture de l'URL: $URL"
        
        $processInfo = switch ($Navigateur) {
            'Chrome' { @{ Path = 'chrome.exe'; Args = $URL } }
            'Firefox' { @{ Path = 'firefox.exe'; Args = $URL } }
            'Edge' { @{ Path = 'msedge.exe'; Args = $URL } }
            'Default' { @{ Path = 'explorer.exe'; Args = "shell:AppsFolder\Microsoft.MicrosoftEdge_8wekyb3d8bbwe!MicrosoftEdge $URL" } }
        }
        
        Start-Process $processInfo.Path $processInfo.Args
        Start-Sleep -Seconds 2  # Attente pour le chargement
        Write-ActionLog "Navigateur ouvert avec l'URL"
        return $true
    }
    catch {
        Write-ActionLog "Erreur lors de l'ouverture du navigateur: $_" -Type Error
        return $false
    }
}

function Rechercher-Google {
    param(
        [Parameter(Mandatory=$true)]
        [string]$TermeRecherche,
        [int]$AttenteChargement = 3,
        [switch]$NouvelOnglet
    )
    try {
        Write-ActionLog "Démarrage de la recherche Google: $TermeRecherche"
        
        if ($NouvelOnglet) {
            Send-Keys "^t"  # Nouveau tab
            Start-Sleep -Milliseconds (Get-ActionDelay)
        }
        
        Ouvrir-NavigateurURL -URL "https://www.google.com"
        Start-Sleep -Seconds $AttenteChargement

        # Recherche de la fenêtre avec plusieurs variantes de titre
        $titresPossibles = @("*Google*", "*google.com*", "*Recherche Google*")
        $fenetre = $null
        
        foreach ($titre in $titresPossibles) {
            try {
                $fenetre = Get-UIAWindow -Title $titre -ErrorAction SilentlyContinue
                if ($fenetre) { break }
            }
            catch { continue }
        }

        if (-not $fenetre) {
            throw "Fenêtre Google non trouvée"
        }

        # Recherche du champ avec différents identifiants possibles
        $champs = @(
            @{ Type = "Name"; Value = "q" },           # ID standard
            @{ Type = "Name"; Value = "Rechercher" },  # Français
            @{ Type = "Name"; Value = "Search" }       # Anglais
        )

        $champRecherche = $null
        foreach ($champ in $champs) {
            try {
                $champRecherche = Get-UIAControl -Window $fenetre -ControlType Edit -$($champ.Type) $($champ.Value) -ErrorAction SilentlyContinue
                if ($champRecherche) { break }
            }
            catch { continue }
        }

        if ($champRecherche) {
            Set-ControlValue -WindowTitle $fenetre.Current.Name -ControlId $champRecherche.Current.AutomationId -Value $TermeRecherche
            Start-Sleep -Milliseconds (Get-ActionDelay -Type 'Court')
            Send-Keys "{ENTER}"
            Write-ActionLog "Recherche effectuée avec succès"
            return $true
        }
        else {
            Write-ActionLog "Champ de recherche non trouvé" -Type Warning
            return $false
        }
    }
    catch {
        Write-ActionLog "Erreur lors de la recherche Google: $_" -Type Error
        return $false
    }
}

function Naviguer-Onglets {
    param(
        [ValidateSet('Suivant', 'Precedent', 'Nouveau', 'Fermer')]
        [string]$Action
    )
    try {
        Write-ActionLog "Navigation des onglets: $Action"
        
        switch ($Action) {
            'Suivant' { Send-Keys "^{TAB}" }
            'Precedent' { Send-Keys "^+{TAB}" }
            'Nouveau' { Send-Keys "^t" }
            'Fermer' { Send-Keys "^w" }
        }
        
        Start-Sleep -Milliseconds (Get-ActionDelay -Type 'Court')
        Write-ActionLog "Navigation effectuée"
        return $true
    }
    catch {
        Write-ActionLog "Erreur lors de la navigation des onglets: $_" -Type Error
        return $false
    }
}

function Interagir-Page {
    param(
        [ValidateSet('Retour', 'Suivant', 'Actualiser', 'Accueil')]
        [string]$Action
    )
    try {
        Write-ActionLog "Action sur la page: $Action"
        
        switch ($Action) {
            'Retour' { Send-Keys "!{LEFT}" }
            'Suivant' { Send-Keys "!{RIGHT}" }
            'Actualiser' { Send-Keys "{F5}" }
            'Accueil' { Send-Keys "!{HOME}" }
        }
        
        Start-Sleep -Milliseconds (Get-ActionDelay)
        Write-ActionLog "Action effectuée"
        return $true
    }
    catch {
        Write-ActionLog "Erreur lors de l'action sur la page: $_" -Type Error
        return $false
    }
}

# Exportation des fonctions
Export-ModuleMember -Function @(
    'Ouvrir-NavigateurURL',
    'Rechercher-Google',
    'Naviguer-Onglets',
    'Interagir-Page'
)
# Module d'actions pour la manipulation de texte
# Version: 1.0

function Select-TexteVocal {
    param (
        [ValidateSet('Mot', 'Ligne', 'Paragraphe', 'Tout', 'DuCurseur')]
        [string]$TypeSelection,
        [int]$Position = 0,
        [int]$Longueur = 0,
        [switch]$Debut,
        [switch]$Fin
    )
    try {
        Write-ActionLog "Sélection de texte: $TypeSelection"
        Add-Type -AssemblyName System.Windows.Forms
        
        switch ($TypeSelection) {
            'Mot' { 
                if ($Position -gt 0) {
                    Send-Keys "^{HOME}"
                    1..$Position | ForEach-Object { Send-Keys "^{RIGHT}" }
                }
                Send-Keys "^+{RIGHT}"
            }
            'Ligne' {
                if ($Position -gt 1) {
                    Send-Keys "^{HOME}"
                    1..($Position-1) | ForEach-Object { Send-Keys "{DOWN}" }
                }
                Send-Keys "{HOME}+{END}"
            }
            'Paragraphe' {
                if ($Position -gt 0) {
                    Send-Keys "^{HOME}"
                    1..$Position | ForEach-Object { Send-Keys "^{DOWN}" }
                }
                Send-Keys "^+{DOWN}"
            }
            'Tout' {
                Send-Keys "^a"
            }
            'DuCurseur' {
                if ($Debut) {
                    Send-Keys "+{HOME}"
                }
                elseif ($Fin) {
                    Send-Keys "+{END}"
                }
                elseif ($Longueur -gt 0) {
                    1..$Longueur | ForEach-Object { Send-Keys "+{RIGHT}" }
                }
            }
        }
        Write-ActionLog "Sélection effectuée"
    }
    catch {
        Write-ActionLog "Erreur lors de la sélection: $_" -Type Error
    }
}

function Format-TexteVocal {
    param (
        [ValidateSet('Gras', 'Italique', 'Souligné', 'Normal')]
        [string[]]$Format,
        [ValidateSet('Gauche', 'Centre', 'Droite', 'Justifié')]
        [string]$Alignement,
        [switch]$Annuler
    )
    try {
        Write-ActionLog "Application du format: $($Format -join ', ')"
        Add-Type -AssemblyName System.Windows.Forms
        
        foreach ($style in $Format) {
            switch ($style) {
                'Gras' { Send-Keys "^b" }
                'Italique' { Send-Keys "^i" }
                'Souligné' { Send-Keys "^u" }
                'Normal' { 
                    Send-Keys "^b"
                    Send-Keys "^i"
                    Send-Keys "^u"
                }
            }
        }
        
        if ($Alignement) {
            switch ($Alignement) {
                'Gauche' { Send-Keys "^l" }
                'Centre' { Send-Keys "^e" }
                'Droite' { Send-Keys "^r" }
                'Justifié' { Send-Keys "^j" }
            }
        }
        
        if ($Annuler) {
            Send-Keys "^z"
        }
        
        Write-ActionLog "Format appliqué"
    }
    catch {
        Write-ActionLog "Erreur lors du formatage: $_" -Type Error
    }
}

function Send-Keys {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Keys
    )
    [System.Windows.Forms.SendKeys]::SendWait($Keys)
    Start-Sleep -Milliseconds (Get-ActionDelay -Type 'Court')
}

# Exportation des fonctions
Export-ModuleMember -Function @(
    'Select-TexteVocal',
    'Format-TexteVocal'
)
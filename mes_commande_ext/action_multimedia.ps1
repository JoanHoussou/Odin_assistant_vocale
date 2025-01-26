# Module d'actions pour le contrôle multimédia
# Version: 1.0

function Control-MediaVocal {
    param (
        [ValidateSet('Lecture', 'Pause', 'Suivant', 'Précédent', 'Stop', 'Muet')]
        [string]$Action,
        [ValidateRange(0,100)]
        [int]$Volume = -1
    )
    try {
        Write-ActionLog "Contrôle média: $Action"
        Add-Type -AssemblyName System.Windows.Forms
        
        switch ($Action) {
            'Lecture' { Send-Keys "{PLAYPAUSE}" }
            'Pause' { Send-Keys "{PLAYPAUSE}" }
            'Suivant' { Send-Keys "{MEDIA_NEXT}" }
            'Précédent' { Send-Keys "{MEDIA_PREV}" }
            'Stop' { Send-Keys "{MEDIA_STOP}" }
            'Muet' { Send-Keys "{VOLUME_MUTE}" }
        }
        
        if ($Volume -ge 0) {
            Set-VolumeVocal -Niveau $Volume
        }
        
        Write-ActionLog "Commande média exécutée"
    }
    catch {
        Write-ActionLog "Erreur lors du contrôle média: $_" -Type Error
    }
}

function Capture-EcranVocale {
    param (
        [ValidateSet('EcranComplet', 'FenêtreActive', 'ZoneSelectionnee')]
        [string]$Type = 'EcranComplet',
        [string]$CheminSauvegarde = "$env:USERPROFILE\Pictures\Captures"
    )
    try {
        Write-ActionLog "Capture d'écran: $Type"
        Add-Type -AssemblyName System.Windows.Forms
        Add-Type -AssemblyName System.Drawing
        
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        $fichier = Join-Path $CheminSauvegarde "Capture_${timestamp}.png"
        
        switch ($Type) {
            'EcranComplet' {
                $bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
                $bitmap = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
                $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
                $graphics.CopyFromScreen($bounds.X, $bounds.Y, 0, 0, $bounds.Size)
            }
            'FenêtreActive' {
                Send-Keys "%{PRTSC}"
                Start-Sleep -Milliseconds (Get-ActionDelay)
                $image = [System.Windows.Forms.Clipboard]::GetImage()
                $bitmap = New-Object System.Drawing.Bitmap $image
            }
            'ZoneSelectionnee' {
                Send-Keys "^+s"
                return # Windows 10+ utilise l'outil de capture natif
            }
        }
        
        if (-not (Test-Path $CheminSauvegarde)) {
            New-Item -ItemType Directory -Path $CheminSauvegarde -Force
        }
        
        $bitmap.Save($fichier, [System.Drawing.Imaging.ImageFormat]::Png)
        Write-ActionLog "Capture sauvegardée: $fichier"
    }
    catch {
        Write-ActionLog "Erreur lors de la capture d'écran: $_" -Type Error
    }
}

function Set-VolumeVocal {
    param (
        [ValidateRange(0,100)]
        [int]$Niveau,
        [ValidateSet('Augmenter', 'Diminuer', 'Muet')]
        [string]$Action,
        [int]$Pas = 2
    )
    try {
        Write-ActionLog "Modification du volume: $Action"
        Add-Type -TypeDefinition @"
        using System.Runtime.InteropServices;
        
        public class Audio {
            [DllImport("user32.dll")]
            public static extern void keybd_event(byte virtualKey, byte scanCode, uint flags, int extraInfo);
            
            public const int VK_VOLUME_MUTE = 0xAD;
            public const int VK_VOLUME_DOWN = 0xAE;
            public const int VK_VOLUME_UP = 0xAF;
        }
"@
        
        switch ($Action) {
            'Augmenter' {
                1..$Pas | ForEach-Object {
                    [Audio]::keybd_event([Audio]::VK_VOLUME_UP, 0, 0, 0)
                    Start-Sleep -Milliseconds (Get-ActionDelay -Type 'Court')
                }
            }
            'Diminuer' {
                1..$Pas | ForEach-Object {
                    [Audio]::keybd_event([Audio]::VK_VOLUME_DOWN, 0, 0, 0)
                    Start-Sleep -Milliseconds (Get-ActionDelay -Type 'Court')
                }
            }
            'Muet' {
                [Audio]::keybd_event([Audio]::VK_VOLUME_MUTE, 0, 0, 0)
            }
        }
        
        Write-ActionLog "Volume modifié"
    }
    catch {
        Write-ActionLog "Erreur lors de la modification du volume: $_" -Type Error
    }
}

# Fonction utilitaire
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
    'Control-MediaVocal',
    'Capture-EcranVocale',
    'Set-VolumeVocal'
)
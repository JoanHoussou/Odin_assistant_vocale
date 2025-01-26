# Module d'actions pour la saisie vocale
# Version: 1.0

function Start-DicteeVocale {
    param (
        [switch]$ModeContinuel,
        [int]$TimeoutSeconds = 30,
        [string]$Langue = "fr-FR",
        [switch]$AjoutEspace,
        [switch]$NouveauParagraphe
    )
    try {
        Write-ActionLog "Démarrage de la dictée vocale"
        Add-Type -AssemblyName System.Speech
        
        $recognizer = New-Object System.Speech.Recognition.SpeechRecognitionEngine
        $culture = New-Object System.Globalization.CultureInfo $Langue
        $recognizer.Culture = $culture
        
        $recognizer.LoadGrammar((New-Object System.Speech.Recognition.DictationGrammar))
        
        $recognizer.SetInputToDefaultAudioDevice()
        
        if ($ModeContinuel) {
            $recognizer.RecognizeAsync([System.Speech.Recognition.RecognizeMode]::Multiple)
            $recognizer.SpeechRecognized += {
                param($sender, $e)
                $texte = $e.Result.Text
                if ($NouveauParagraphe) {
                    Send-Keys "{ENTER}{ENTER}"
                }
                Send-Keys $texte
                if ($AjoutEspace) {
                    Send-Keys " "
                }
            }
            Start-Sleep -Seconds $TimeoutSeconds
            $recognizer.RecognizeAsyncStop()
        }
        else {
            $result = $recognizer.Recognize()
            if ($result) {
                if ($NouveauParagraphe) {
                    Send-Keys "{ENTER}{ENTER}"
                }
                Send-Keys $result.Text
                if ($AjoutEspace) {
                    Send-Keys " "
                }
            }
        }
        
        Write-ActionLog "Dictée terminée"
    }
    catch {
        Write-ActionLog "Erreur lors de la dictée vocale: $_" -Type Error
    }
}

function Set-EtatSystemeVocal {
    param (
        [ValidateSet('Veille', 'Hibernation', 'Redémarrage', 'Arrêt')]
        [string]$Action,
        [switch]$Force
    )
    try {
        Write-ActionLog "Action système demandée: $Action"
        
        switch ($Action) {
            'Veille' { 
                Write-ActionLog "Mise en veille du système"
                [System.Windows.Forms.Application]::SetSuspendState('Suspend', $Force, $false)
            }
            'Hibernation' {
                Write-ActionLog "Mise en hibernation du système"
                [System.Windows.Forms.Application]::SetSuspendState('Hibernate', $Force, $false)
            }
            'Redémarrage' {
                Write-ActionLog "Redémarrage du système"
                Restart-Computer -Force:$Force
            }
            'Arrêt' {
                Write-ActionLog "Arrêt du système"
                Stop-Computer -Force:$Force
            }
        }
    }
    catch {
        Write-ActionLog "Erreur lors de l'action système: $_" -Type Error
    }
}

function Set-EcranVocal {
    param (
        [ValidateSet('Allumer', 'Eteindre', 'Veille')]
        [string]$Action
    )
    try {
        Write-ActionLog "Contrôle de l'écran: $Action"
        Add-Type -TypeDefinition @"
        using System;
        using System.Runtime.InteropServices;

        public class MonitorControl {
            [DllImport("user32.dll")]
            public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam);
            
            public static void SetMonitorState(int state) {
                SendMessage(0xFFFF, 0x112, 0xF170, state);
            }
        }
"@
        
        switch ($Action) {
            'Allumer' { [MonitorControl]::SetMonitorState(-1) }
            'Eteindre' { [MonitorControl]::SetMonitorState(2) }
            'Veille' { [MonitorControl]::SetMonitorState(1) }
        }
        
        Write-ActionLog "État de l'écran modifié"
    }
    catch {
        Write-ActionLog "Erreur lors du contrôle de l'écran: $_" -Type Error
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
    'Start-DicteeVocale',
    'Set-EtatSystemeVocal',
    'Set-EcranVocal'
)
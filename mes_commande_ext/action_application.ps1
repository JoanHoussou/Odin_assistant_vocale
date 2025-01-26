# Module d'actions pour les applications
# Version: 1.0

function Start-AppVocale {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ApplicationPath,
        [switch]$AsAdmin,
        [ValidateSet('Normal', 'Maximized', 'Minimized')]
        [string]$WindowStyle = 'Normal'
    )
    try {
        Write-ActionLog "Démarrage de l'application: $ApplicationPath"
        $startInfo = @{
            FilePath = $ApplicationPath
            WindowStyle = $WindowStyle
        }
        if ($AsAdmin) {
            $startInfo.Verb = 'RunAs'
        }
        Start-Process @startInfo
        Start-Sleep -Milliseconds (Get-ActionDelay)
        Write-ActionLog "Application démarrée avec succès"
    }
    catch {
        Write-ActionLog "Erreur lors du démarrage de l'application: $_" -Type Error
    }
}

function Stop-AppVocale {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProcessName,
        [switch]$Force,
        [switch]$Confirm
    )
    try {
        Write-ActionLog "Tentative de fermeture de: $ProcessName"
        if ($Confirm) {
            $choix = Read-Host "Voulez-vous vraiment fermer $ProcessName ? (O/N)"
            if ($choix -ne 'O') {
                Write-ActionLog "Fermeture annulée par l'utilisateur"
                return
            }
        }
        Stop-Process -Name $ProcessName -Force:$Force
        Write-ActionLog "Application fermée avec succès"
    }
    catch {
        Write-ActionLog "Erreur lors de la fermeture de l'application: $_" -Type Error
    }
}

function Switch-ApplicationWindow {
    param (
        [Parameter(Mandatory=$true)]
        [string]$WindowTitle
    )
    try {
        Write-ActionLog "Changement vers la fenêtre: $WindowTitle"
        Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        public class Win32 {
            [DllImport("user32.dll")]
            public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
            [DllImport("user32.dll")]
            public static extern bool SetForegroundWindow(IntPtr hWnd);
        }
"@
        
        $processes = Get-Process | Where-Object {$_.MainWindowTitle -like "*$WindowTitle*"}
        foreach($process in $processes) {
            [Win32]::ShowWindow($process.MainWindowHandle, 9)
            [Win32]::SetForegroundWindow($process.MainWindowHandle)
        }
        Write-ActionLog "Fenêtre activée avec succès"
    }
    catch {
        Write-ActionLog "Erreur lors du changement de fenêtre: $_" -Type Error
    }
}

# Exportation des fonctions
Export-ModuleMember -Function @(
    'Start-AppVocale',
    'Stop-AppVocale',
    'Switch-ApplicationWindow'
)
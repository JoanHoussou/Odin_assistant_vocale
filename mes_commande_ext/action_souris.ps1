# Module d'actions pour le contrôle de la souris
# Version: 1.0

function Move-SourisVocale {
    param (
        [Parameter(Mandatory=$true)]
        [int]$X,
        [Parameter(Mandatory=$true)]
        [int]$Y,
        [ValidateSet('Direct', 'Smooth')]
        [string]$MovementStyle = 'Direct',
        [int]$Speed = 1
    )
    try {
        Write-ActionLog "Déplacement de la souris vers ($X, $Y)"
        Add-Type -AssemblyName System.Windows.Forms
        
        switch ($MovementStyle) {
            'Direct' {
                [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($X, $Y)
            }
            'Smooth' {
                $currentPos = [System.Windows.Forms.Cursor]::Position
                $steps = 10
                for ($i = 1; $i -le $steps; $i++) {
                    $newX = $currentPos.X + (($X - $currentPos.X) * ($i / $steps))
                    $newY = $currentPos.Y + (($Y - $currentPos.Y) * ($i / $steps))
                    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($newX, $newY)
                    Start-Sleep -Milliseconds (Get-ActionDelay -Type 'Court')
                }
            }
        }
        Write-ActionLog "Déplacement terminé"
    }
    catch {
        Write-ActionLog "Erreur lors du déplacement: $_" -Type Error
    }
}

function Invoke-ClicVocal {
    param (
        [ValidateSet('Gauche', 'Droit', 'Milieu')]
        [string]$TypeClic = 'Gauche',
        [switch]$Double,
        [switch]$Maintenu,
        [int]$DureeMaintien = 0
    )
    try {
        Write-ActionLog "Exécution d'un clic $TypeClic"
        Add-Type @"
        using System;
        using System.Runtime.InteropServices;
        public class MouseOperations {
            [DllImport("user32.dll")]
            public static extern void mouse_event(uint dwFlags, int dx, int dy, uint dwData, IntPtr dwExtraInfo);
            
            public const uint MOUSEEVENTF_LEFTDOWN = 0x0002;
            public const uint MOUSEEVENTF_LEFTUP = 0x0004;
            public const uint MOUSEEVENTF_RIGHTDOWN = 0x0008;
            public const uint MOUSEEVENTF_RIGHTUP = 0x0010;
            public const uint MOUSEEVENTF_MIDDLEDOWN = 0x0020;
            public const uint MOUSEEVENTF_MIDDLEUP = 0x0040;
        }
"@
        
        $downFlag = switch ($TypeClic) {
            'Gauche' { [MouseOperations]::MOUSEEVENTF_LEFTDOWN }
            'Droit' { [MouseOperations]::MOUSEEVENTF_RIGHTDOWN }
            'Milieu' { [MouseOperations]::MOUSEEVENTF_MIDDLEDOWN }
        }
        
        $upFlag = switch ($TypeClic) {
            'Gauche' { [MouseOperations]::MOUSEEVENTF_LEFTUP }
            'Droit' { [MouseOperations]::MOUSEEVENTF_RIGHTUP }
            'Milieu' { [MouseOperations]::MOUSEEVENTF_MIDDLEUP }
        }
        
        if ($Maintenu) {
            [MouseOperations]::mouse_event($downFlag, 0, 0, 0, [IntPtr]::Zero)
            if ($DureeMaintien -gt 0) {
                Start-Sleep -Milliseconds $DureeMaintien
            }
            [MouseOperations]::mouse_event($upFlag, 0, 0, 0, [IntPtr]::Zero)
        }
        else {
            [MouseOperations]::mouse_event($downFlag, 0, 0, 0, [IntPtr]::Zero)
            [MouseOperations]::mouse_event($upFlag, 0, 0, 0, [IntPtr]::Zero)
            
            if ($Double) {
                Start-Sleep -Milliseconds (Get-ActionDelay -Type 'Court')
                [MouseOperations]::mouse_event($downFlag, 0, 0, 0, [IntPtr]::Zero)
                [MouseOperations]::mouse_event($upFlag, 0, 0, 0, [IntPtr]::Zero)
            }
        }
        
        Write-ActionLog "Clic exécuté"
    }
    catch {
        Write-ActionLog "Erreur lors du clic: $_" -Type Error
    }
}

# Exportation des fonctions
Export-ModuleMember -Function @(
    'Move-SourisVocale',
    'Invoke-ClicVocal'
)
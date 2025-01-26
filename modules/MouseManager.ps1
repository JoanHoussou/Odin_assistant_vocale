# Importer mes_actions.ps1 pour Move-SourisVocale et Invoke-ClicVocal
$modulePath = Join-Path $PSScriptRoot "..\mes_commande_ext\mes_actions.ps1"
. $modulePath

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class MouseWheel {
    [DllImport("user32.dll")]
    public static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, IntPtr dwExtraInfo);
    
    public const int MOUSEEVENTF_WHEEL = 0x0800;
}
"@

function Invoke-MouseAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Move", "RelativeMove", "Click", "Drag", "Scroll")]
        [string]$Action,
        
        [Parameter()]
        [int]$X,
        
        [Parameter()]
        [int]$Y,
        
        [Parameter()]
        [ValidateSet("Gauche", "Droit", "Milieu", "Principal", "Secondaire", "Molette")]
        [string]$Button = "Gauche",

        [Parameter()]
        [int]$DestX,

        [Parameter()]
        [int]$DestY,

        [Parameter()]
        [int]$Distance,

        [Parameter()]
        [ValidateSet("Nord", "Sud", "Est", "Ouest", "Haut", "Bas")]
        [string]$Direction,

        [Parameter()]
        [int]$Scroll = 1
    )
    
    try {
        switch ($Action) {
            "Move" { 
                if ($X -ge 0 -and $Y -ge 0) {
                    Move-SourisVocale -X $X -Y $Y -MovementStyle "Smooth"
                    return $true
                }
                return $false
            }
            "RelativeMove" {
                $currentX = [System.Windows.Forms.Cursor]::Position.X
                $currentY = [System.Windows.Forms.Cursor]::Position.Y
                
                switch ($Direction) {
                    "Gauche" { $X = $currentX - $Distance; $Y = $currentY }
                    "Droite" { $X = $currentX + $Distance; $Y = $currentY }
                    "Haut"   { $X = $currentX; $Y = $currentY - $Distance }
                    "Bas"    { $X = $currentX; $Y = $currentY + $Distance }
                }
                
                Move-SourisVocale -X $X -Y $Y -MovementStyle "Smooth"
                return $true
            }
            "Click" { 
                $mappedButton = switch ($Button) {
                    "Principal" { "Gauche" }
                    "Secondaire" { "Droit" }
                    "Molette" { "Milieu" }
                    default { $Button }
                }
                Invoke-ClicVocal -TypeClic $mappedButton
                return $true
            }
            "Drag" {
                # Déplacement au point de départ
                Move-SourisVocale -X $X -Y $Y -MovementStyle "Smooth"
                # Maintien du clic
                Invoke-ClicVocal -TypeClic "Gauche" -Maintenu
                Start-Sleep -Milliseconds 100
                # Déplacement vers la destination
                Move-SourisVocale -X $DestX -Y $DestY -MovementStyle "Smooth"
                # Relâchement du clic
                Invoke-ClicVocal -TypeClic "Gauche"
                return $true
            }
            "Scroll" {
                # Le WHEEL_DELTA standard de Windows est 120
                $WHEEL_DELTA = 120
                
                # Calculer la valeur de défilement
                # Multiplier par le nombre de "tours" demandés
                $scrollValue = $WHEEL_DELTA * $Scroll
                
                # Inverser la direction si nécessaire
                if ($Direction -eq "Bas" -or $Direction -eq "Sud") {
                    $scrollValue = -$scrollValue
                }

                # Effectuer le défilement
                # En utilisant int au lieu de uint pour gérer les valeurs négatives
                [MouseWheel]::mouse_event(
                    [MouseWheel]::MOUSEEVENTF_WHEEL,
                    0,
                    0,
                    $scrollValue,
                    [IntPtr]::Zero
                )
                return $true
            }
        }
    }
    catch {
        Write-Error "Erreur lors du contrôle de la souris: $_"
        return $false
    }
}
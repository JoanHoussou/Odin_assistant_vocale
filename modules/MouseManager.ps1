function Control-Mouse {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Move", "Click", "DoubleClick")]
        [string]$Action,
        [int]$X,
        [int]$Y,
        [ValidateSet("Gauche", "Droit", "Milieu")]
        [string]$Button = "Gauche"
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
            "Click" { 
                Invoke-ClicVocal -TypeClic $Button
                return $true
            }
            "DoubleClick" {
                Invoke-ClicVocal -TypeClic $Button -Double
                return $true
            }
        }
    }
    catch {
        Write-Error "Erreur lors du contrôle de la souris: $_"
        return $false
    }
}

Export-ModuleMember -Function Control-Mouse
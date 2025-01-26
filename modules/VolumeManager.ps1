# Constantes pour les touches de volume
$script:VOLUME_MUTE = [char]173
$script:VOLUME_DOWN = [char]174
$script:VOLUME_UP = [char]175

function Set-SystemVolume {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateRange(0,100)]
        [int]$Level
    )
    
    try {
        $wshell = New-Object -ComObject wscript.shell
        
        # Mute si volume = 0
        if ($Level -eq 0) {
            $wshell.SendKeys($script:VOLUME_MUTE)
            return $true
        }
        
        # Réinitialiser d'abord le volume à 0
        1..50 | ForEach-Object { $wshell.SendKeys($script:VOLUME_DOWN) }
        
        # Puis ajuster au niveau souhaité
        $steps = [math]::Round($Level / 2)
        1..$steps | ForEach-Object { $wshell.SendKeys($script:VOLUME_UP) }
        return $true
    }
    catch {
        Write-Error "Erreur lors du réglage du volume: $_"
        return $false
    }
}
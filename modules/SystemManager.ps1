function Restart-Shutdown {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Shutdown", "Restart")]
        [string]$Action
    )
    
    try {
        switch ($Action) {
            "Shutdown" { 
                Start-Process "shutdown.exe" -ArgumentList "/s /t 0" -NoNewWindow
                return $true
            }
            "Restart" { 
                Start-Process "shutdown.exe" -ArgumentList "/r /t 0" -NoNewWindow
                return $true
            }
        }
    }
    catch {
        Write-Error "Erreur lors de l'action $Action : $_"
        return $false
    }
}

function Lock-Session {
    try {
        rundll32.exe user32.dll,LockWorkStation
        return $true
    }
    catch {
        Write-Error "Erreur lors du verrouillage de la session: $_"
        return $false
    }
}
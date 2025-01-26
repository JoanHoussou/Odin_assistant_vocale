function Manage-Windows {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("MinimizeAll", "RestoreAll")]
        [string]$Action
    )
    
    try {
        $shell = New-Object -ComObject "Shell.Application"
        switch ($Action) {
            "MinimizeAll" { 
                $shell.MinimizeAll()
                return $true
            }
            "RestoreAll" { 
                $shell.UndoMinimizeAll()
                return $true
            }
        }
    }
    catch {
        Write-Error "Erreur lors de la gestion des fenêtres: $_"
        return $false
    }
}

function Control-UI {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$WindowTitle,
        [Parameter(Mandatory=$true)]
        [string]$ControlName,
        [ValidateSet("Click", "Focus", "SetValue")]
        [string]$Action = "Click",
        [string]$Value = ""
    )
    
    try {
        switch ($Action) {
            "Click" { 
                return Invoke-ControlClick -WindowTitle $WindowTitle -ControlName $ControlName
            }
            "Focus" {
                return Set-ControlFocus -WindowTitle $WindowTitle -ControlName $ControlName
            }
            "SetValue" {
                return Set-ControlValue -WindowTitle $WindowTitle -ControlName $ControlName -Value $Value
            }
        }
    } catch {
        Write-Error "Erreur lors du contrôle de l'interface: $_"
        return $false
    }
}

Export-ModuleMember -Function Manage-Windows, Control-UI
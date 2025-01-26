# Charger les assemblies nécessaires
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Web
Add-Type -AssemblyName PresentationFramework

# Importer le module mes_actions
$modulePath = Join-Path $PSScriptRoot "mes_commande_ext\mes_actions.ps1"
. $modulePath

# Constantes pour les touches de volume
$VOLUME_MUTE = [char]173
$VOLUME_DOWN = [char]174
$VOLUME_UP = [char]175

function Set-SystemVolume {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateRange(0,100)]
        [int]$Level = 50
    )
    
    try {
        $wshell = New-Object -ComObject wscript.shell
        
        # Mute si volume = 0
        if ($Level -eq 0) {
            $wshell.SendKeys($VOLUME_MUTE)
            return $true
        }
        
        # Réinitialiser d'abord le volume à 0
        1..50 | ForEach-Object { $wshell.SendKeys($VOLUME_DOWN) }
        
        # Puis ajuster au niveau souhaité
        $steps = [math]::Round($Level / 2)
        1..$steps | ForEach-Object { $wshell.SendKeys($VOLUME_UP) }
        return $true
    }
    catch {
        Write-Error "Erreur lors du réglage du volume: $_"
        return $false
    }
}

function Start-Application {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$AppName,
        [Parameter(Mandatory=$false)]
        [string]$Arguments
    )
    
    $appPaths = @{
        'chrome' = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
        'firefox' = 'C:\Program Files\Mozilla Firefox\firefox.exe'
        'notepad' = "$env:SystemRoot\system32\notepad.exe"
        'explorer' = "$env:SystemRoot\explorer.exe"
        'google' = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
        'bloc-notes' = "$env:SystemRoot\system32\notepad.exe"
        'calculatrice' = "$env:SystemRoot\system32\calc.exe"
        'youtube' = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
    }
    
    $appName = $AppName.ToLower()
    if ($appPaths.ContainsKey($appName)) {
        $path = $appPaths[$appName]
        if (Test-Path $path) {
            if ($appName -eq 'youtube') {
                if ($Arguments) {
                    # Encoder les caractères spéciaux pour l'URL
                    $encodedQuery = [System.Web.HttpUtility]::UrlEncode($Arguments)
                    Start-Process -FilePath $path -ArgumentList "https://www.youtube.com/results?search_query=$encodedQuery"
                } else {
                    Start-Process -FilePath $path -ArgumentList "https://www.youtube.com"
                }
            } else {
                if ($Arguments) {
                    Start-Process -FilePath $path -ArgumentList $Arguments
                } else {
                    Start-Process -FilePath $path
                }
            }
            return $true
        } else {
            Write-Error "Chemin non trouvé : $path"
            return $false
        }
    } else {
        $apps = $appPaths.Keys -join ', '
        Write-Error "Application non reconnue : $AppName. Applications supportées : $apps"
        return $false
    }
}

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

function Show-Notification {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    
    try {
        [System.Windows.MessageBox]::Show($Message, $Title, [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Information)
        return $true
    }
    catch {
        Write-Error "Erreur lors de l'affichage de la notification: $_"
        return $false
    }
}

function Capture-Screenshot {
    [CmdletBinding()]
    param(
        [string]$Path = "$env:USERPROFILE\Desktop\Screenshot_$(Get-Date -Format 'yyyyMMdd_HHmmss').png"
    )
    
    try {
        $bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
        $bitmap = New-Object System.Drawing.Bitmap($bounds.Width, $bounds.Height)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.CopyFromScreen($bounds.X, $bounds.Y, 0, 0, $bounds.Size)
        $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
        $graphics.Dispose()
        $bitmap.Dispose()
        return $true
    }
    catch {
        Write-Error "Erreur lors de la capture d'écran: $_"
        return $false
    }
}

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
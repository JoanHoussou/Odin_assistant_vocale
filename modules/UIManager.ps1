# Importer les assemblies nécessaires
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationFramework

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

function New-Screenshot {
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
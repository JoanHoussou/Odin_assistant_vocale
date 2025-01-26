# Importer les assemblies nécessaires
Add-Type -AssemblyName System.Web

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
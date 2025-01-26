import os
import subprocess

class PowerShellExecutor:
    def __init__(self):
        self.script_path = os.path.abspath('audio_commands.ps1')
    
    def execute_command(self, command):
        """Exécute une commande PowerShell avec le script"""
        ps_command = f'. "{self.script_path}"; {command}'
        result = subprocess.run(
            ['powershell', '-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command', ps_command],
            capture_output=True,
            text=True
        )
        
        if result.stderr and "Write-Error" in result.stderr:
            print(f"Erreur PowerShell: {result.stderr}")
            return False
        return True
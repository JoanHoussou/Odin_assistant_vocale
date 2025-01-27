import pytest
from python_modules.command_patterns import CommandPatterns
from python_modules.speech_engine import SpeechEngine
from python_modules.powershell_executor import PowerShellExecutor
from python_modules.command_handler import CommandHandler
from unittest.mock import MagicMock

@pytest.fixture
def command_patterns():
    return CommandPatterns()

@pytest.fixture
def mock_speech_engine():
    speech_engine = MagicMock(spec=SpeechEngine)
    speech_engine.say_text = MagicMock(return_value=None)
    return speech_engine

@pytest.fixture
def mock_powershell_executor():
    ps_executor = MagicMock(spec=PowerShellExecutor)
    ps_executor.execute_command = MagicMock(return_value=True)
    return ps_executor

@pytest.fixture
def command_handler(mock_speech_engine, mock_powershell_executor):
    return CommandHandler(mock_speech_engine, mock_powershell_executor)
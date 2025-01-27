from .patterns import (
    MousePatterns,
    UIPatterns,
    WindowPatterns,
    ApplicationPatterns,
    SystemPatterns,
    VolumePatterns,
    YouTubePatterns
)

class CommandPatterns:
    def __init__(self):
        self._mouse_patterns = MousePatterns()
        self._ui_patterns = UIPatterns()
        self._window_patterns = WindowPatterns()
        self._application_patterns = ApplicationPatterns()
        self._system_patterns = SystemPatterns()
        self._volume_patterns = VolumePatterns()
        self._youtube_patterns = YouTubePatterns()

    def mouse_patterns(self):
        return self._mouse_patterns.patterns()

    def ui_patterns(self):
        return self._ui_patterns.patterns()

    def window_patterns(self):
        return self._window_patterns.patterns()

    def application_patterns(self):
        return self._application_patterns.patterns()

    def system_patterns(self):
        return self._system_patterns.patterns()

    def volume_patterns(self):
        return self._volume_patterns.patterns()

    def youtube_search_patterns(self):
        return self._youtube_patterns.search_patterns()
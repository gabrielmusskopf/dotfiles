import dbus
import subprocess
from functools import partial
from libqtile.widget import base

class Spotify(base.ThreadPoolText):
    """A simple Spotify widget, made using dbus-python.
    Show the song and artist of now listening song and allow basic mouse
    control from the bar using spotify-control(
    Github: https://github.com/J00LZ/spotify-control
    AUR:    https://aur.archlinux.org/packages/spotify-control
    ):
    - toggle pause (or play if stopped) on left click;
    - skip forward in playlist on scroll up;
    - skip backward in playlist on scroll down.
    """

    defaults = [
        ("color", "00ff00", "Text"),
        ("update_interval", 0.5, "Update Time in seconds."),
    ]

    def __init__(self, **config):
        base.ThreadPoolText.__init__(self, "", **config)
        self.add_defaults(Spotify.defaults)
        self.local = None
        self.add_callbacks(
            {
                "Button1": partial(subprocess.Popen, ["spotify-control", "play-pause"]),
                "Button4": partial(subprocess.Popen, ["spotify-control", "next"]),
                "Button5": partial(subprocess.Popen, ["spotify-control", "previous"]),
            }
        )

    def now_playing(self):
        """Return current song"""
        session_bus = dbus.SessionBus()
        bus_data = ("org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2")
        spotify_bus = session_bus.get_object(*bus_data)
        interface = dbus.Interface(spotify_bus, "org.freedesktop.DBus.Properties")
        metadata = interface.Get("org.mpris.MediaPlayer2.Player", "Metadata")
        data = {
            "artist" : next(iter(metadata.get("xesam:albumArtist"))),
            "song" : metadata.get("xesam:title")
        }
        song = data["song"] + " ♫ " + data["artist"]
        self.layout.colour = self.color
        return song

    def poll(self):
        """Poll content for the text box."""
        try:
            return self.now_playing()
        except :
            return "Spotify is not responding"

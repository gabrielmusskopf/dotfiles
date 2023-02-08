import os
from libqtile import hook, qtile
from libqtile.log_utils import logger

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal, send_notification
from libqtile.core.manager import Qtile
from libqtile.widget.backlight import ChangeDirection

# Customizados
from typing import TYPE_CHECKING
from custom.battery import CustomBattery
#from custom.spotify import Spotify
#from custom.spotify_widget import Spotify

# Utils
from colors import colors
import psutil

import subprocess
import random


mod = "mod4"
terminal = guess_terminal()
myBrowser = "brave-browser"

HAS_BATTERY: bool = os.path.isdir("/sys/class/power_supply/BAT0")
MUSIC_CTRL = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player."

@hook.subscribe.startup
def dbus_register(): 
    id = os.environ.get('DESKTOP_AUTOSTART_ID')
    if not id:
        return
    subprocess.Popen(['dbus-send',
                      '--session',
                      '--print-reply',
                      '--dest=org.gnome.SessionManager',
                      '/org/gnome/SessionManager',
                      'org.gnome.SessionManager.RegisterClient',
                      'string:qtile',
                      'string:' + id])
@lazy.function
def notification(qtile: Qtile, request: str) -> None:
    """Used for mouse callbacks and keybinds to send notifications"""
    title: str = ""
    message: str = ""
    try:
        if request == "battery":
            if HAS_BATTERY:
                battery = psutil.sensors_battery()
                assert battery is not None, "Battery must be found by psutil"
                title = "Battery"
                message = f"{round(battery.percent)}%"
            else:
                return

        send_notification(title, message, timeout=2500, urgent=False)

    except Exception as err:
        logger.warning(f"Failed to send notification: {err}")


@lazy.function
def spawn_or_focus(qtile: Qtile, app: str) -> None:
    """Check if the app being launched is already running, if so focus it"""
    window = None
    for win in qtile.windows_map.values():
        if isinstance(win, Window):
            wm_class: list | None = win.get_wm_class()
            if wm_class is None or win.group is None:
                return
            if any(item.lower() in app for item in wm_class):
                window = win
                group = win.group
                group.toscreen(toggle=False)
                break

    if window is None:
        qtile.spawn(app)

    elif window == qtile.current_window:
        try:
            assert (
                qtile.current_layout.swap_main is not None
            ), "The current layout should have swap_main"
            qtile.current_layout.swap_main()
        except AttributeError:
            return
    else:
        qtile.current_group.focus(window)

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod, "shift"], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "Space", lazy.spawn("rofi -show drun"), desc="Spawn a command using a prompt widget"),

    # Abrir navegador
    Key([mod], "b", lazy.spawn(myBrowser), desc='Abrir navegador'),
    # https://www.howtoforge.com/tutorial/taking-screenshots-in-linux-using-gnome-screenshot
    Key([mod, "shift"], "s", lazy.spawn("gnome-screenshot -i"), desc='Tirar screenshot de e copiar para a área de transferência'),

    # Habilitando controle de volume pelas teclas de media
    # https://github.com/qtile/qtile/blob/master/libqtile/backend/x11/xkeysyms.python
    # https://askubuntu.com/questions/454955/using-amixer-to-control-volume
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -D pulse sset Master 5%+"), desc='Volume Up'),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -D pulse sset Master 5%-"), desc='Volume Down'),
    Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse sset Master toggle"), desc='Volume Down'),

    # Não identifica o teclado do notebook
    Key([mod, "shift"], "d", lazy.spawn("sudo brightnessctl -d amdgpu_bl0 set 10-"), desc='Aumentar brilho da tela'),
    Key([], "F5", lazy.spawn("sudo brightnessctl -d amdgpu_bl0 set 10-"), desc='Diminuir brilho da tela'),
    Key([], 'XF86MonBrightnessUp', lazy.widget['backlight'].change_backlight(ChangeDirection.UP, 5),   "Increase backlight"),
    Key([], 'XF86MonBrightnessDown', lazy.widget['backlight'].change_backlight(ChangeDirection.DOWN, 5), "Decrease backlight"),
    #Key([], 'F6', lazy.widget['backlight'].change_backlight(ChangeDirection.UP, 5),   "Increase backlight"),
    #Key([], 'F5', lazy.widget['backlight'].change_backlight(ChangeDirection.DOWN, 5), "Decrease backlight"),

    Key([mod, "shift"], "b", notification("battery")),
]

groups = [Group(i) for i in "12345qwer"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

widget_defaults = dict(
    font="Ubuntu Bold",
    fontsize=12,
    padding=3,
    background=colors[2]
)

extension_defaults = widget_defaults.copy()


def get_widgets():
    widget_separator = widget.TextBox(
            text = '|',
            font = "Ubuntu Mono",
            background = colors[0],
            foreground = '474747',
            padding = 2,
            fontsize = 14
        )

    return [
                widget.Sep(
                       linewidth = 0,
                       padding = 6,
                       foreground = colors[2],
                       background = colors[0]
                       ),
                widget.Image(
                       filename = "~/.config/qtile/icons/python.png",
                       scale = "False",
                       mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal)}
                       ),
                widget.Sep(
                       linewidth = 0,
                       padding = 6,
                       foreground = colors[2],
                       background = colors[0]
                       ),
                widget.GroupBox(
                       font = "Ubuntu Bold",
                       fontsize = 9,
                       margin_y = 3,
                       margin_x = 0,
                       padding_y = 5,
                       padding_x = 3,
                       borderwidth = 3,
                       active = colors[2],
                       inactive = colors[7],
                       rounded = False,
                       highlight_color = colors[1],
                       highlight_method = "line",
                       this_current_screen_border = colors[6],
                       this_screen_border = colors [4],
                       other_current_screen_border = colors[6],
                       other_screen_border = colors[4],
                       foreground = colors[2],
                       background = colors[0]
                       ),
                widget_separator,
                widget.CurrentLayoutIcon(
                       custom_icon_paths = [os.path.expanduser("~/.config/qtile/icons")],
                       foreground = colors[2],
                       background = colors[0],
                       padding = 0,
                       scale = 0.7
                       ),
                widget.CurrentLayout(
                       foreground = colors[2],
                       background = colors[0],
                       padding = 5
                       ),
                widget_separator,
                widget.WindowName(
                       foreground = colors[6],
                       background = colors[0],
                       padding = 0,
                       format=""
                       ),
                widget.Sep(
                       linewidth = 0,
                       padding = 6,
                       foreground = colors[0],
                       background = colors[0]
                       ),   
                widget_separator,
                widget.Net(
                        background = colors[0],
                        foreground = colors[7],
                        format = "    {down} ↓↑ {up}",
                        # 'nmcli device' para ver o valor
                        interface = "wlp3s0",
                        mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn("gnome-control-center wifi")}
                        ),
                widget_separator,
                widget.ThermalSensor(
                       foreground = colors[3],
                       background = colors[0],
                       fmt = "    {}"
                        ),
                widget.Memory(
                       foreground = colors[3],
                       background = colors[0],
                       mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e htop')},
                       fmt = '{}',
                       padding = 5,
                       measure_mem='G'
                       ),
                widget_separator,
                widget.Backlight(
                        #backlight_name=os.listdir('/sys/class/backlight')[0],
                        backlight_name=os.path.basename('/sys/class/backlight/amdgpu_bl0'),
                        foreground = colors[7],
                        background = colors[0],
                        fmt ="   {}",
                        change_command = "sudo brightnessctl -d amdgpu_bl0 set {0}"
                        ),
                widget_separator,
                widget.TextBox(
                       text = '',
                       font = "Ubuntu Mono",
                       background = colors[0],
                       foreground = colors[8],
                       padding = 5,
                       fontsize = 13,
                        mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn("blueman-manager")}
                       ),
                widget_separator,
                # TODO: validar se está em notebook
                CustomBattery(
                        padding = 5,
                        foreground = colors[4],
                        background = colors[0],
                        mouse_callbacks = {"Button1": notification("battery")}
                        ),
                widget.Battery(
                        foreground = colors[4],
                        background = colors[0],
                        format="{percent:2.0%}"
                        ),  
                widget_separator,
                widget.PulseVolume(
                        fmt= "墳   {}",
                        foreground=colors[6],
                        background=colors[0],
                        padding=5
                ),
                widget_separator,
                widget.Clock(
                       foreground = colors[8],
                       background = colors[0],
                       format = "%d/%m/%y   %H:%M"
                       ),
                widget.Sep(
                       linewidth = 0,
                       padding = 6,
                       foreground = colors[0],
                       background = colors[0]
                       ),   
            ]

def get_random_wallpaper():
    wallpapers = os.listdir("/home/gabrielgrahlmusskopf/wallpapers/")
    wp = random.choice(wallpapers)
    return wp


def init_screen(wallpaper = ''):
    return Screen(
        wallpaper=wallpaper,
        wallpaper_mode="fill",
        top=bar.Bar( get_widgets(), 24),
    )

wallpaper="~/wallpapers/" + get_random_wallpaper();

screens = [init_screen(wallpaper), init_screen(wallpaper)]

layouts = [
    layout.MonadTall(
        border_focus=colors[9],
        border_width=1,
        margin=8
        ),
    layout.Max(),
    #layout.Floating(
    #    border_focus = colors[9],
    #    border_normal = colors[9]
    #    ),
    #layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    #layout.Spiral(),
  #  layout.Stack(num_stacks=2),
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

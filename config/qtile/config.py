# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401

from libqtile import bar, layout, widget, hook, extension
from libqtile.config import Click, Drag, Group, Key, Match, Screen, KeyChord
from libqtile.lazy import lazy
from colour import Color
import PyColors
import os
import subprocess

def make_inactive_color(active_color):
    InactiveColor = Color(active_color)
    if (InactiveColor.get_saturation() >= 0.3):
        InactiveColor.set_saturation(InactiveColor.get_saturation() - 0.3)
    if (InactiveColor.get_red() >= 0.2):
        InactiveColor.set_red(InactiveColor.get_red() - 0.2)
    if (InactiveColor.get_green() >= 0.2):
        InactiveColor.set_green(InactiveColor.get_green() - 0.2)
    if (InactiveColor.get_blue() >= 0.2):
        InactiveColor.set_blue(InactiveColor.get_blue() - 0.2)

    return InactiveColor.get_hex_l()

def color_contrast_difference(color1, color2):
    Color1 = Color(color1)
    Color2 = Color(color2)
    redVal = (Color1.get_red() * 255) - (Color2.get_red() * 255)
    greenVal = (Color1.get_green() * 255) - (Color2.get_green() * 255)
    blueVal = (Color1.get_blue() * 255) - (Color2.get_blue() * 255)

    return abs(redVal) + abs(greenVal) + abs(blueVal)

def color_brightness(color):
    GivenColor = Color(color)
    red = GivenColor.get_red()*255
    green = GivenColor.get_green()*255
    blue = GivenColor.get_blue()*255

    return ((red*299) + (green*587) + (blue*114))/1000

def make_foreground_color(background_color):
    if (color_contrast_difference(background_color, PyColors.foreground) > 280):
        return PyColors.foreground

    return PyColors.background

def get_complementary_color(color):
    GivenColor = Color(color)
    GivenColor.set_hue(((GivenColor.get_hue()*360) + 180)/360)
    return GivenColor.get_hex_l()

def colors_equal(color1, color2):
    Color1 = Color(color1)
    Color2 = Color(color2)

    return Color1.get_hex_l() == Color2.get_hex_l()

def get_standout_color():
    colors = [
            PyColors.color1,
            PyColors.color2,
            PyColors.color3,
            PyColors.color4,
            PyColors.color5,
            PyColors.color6,
            PyColors.color7,
            PyColors.color8,
            PyColors.color9
            ]
    results = [0] * len(colors)
    for index, color1 in enumerate(colors):
        for color2 in colors:
            if not colors_equal(color1, color2):
                results[index] += color_contrast_difference(color1, color2)
    max_contrast = max(results)
    max_index = results.index(max_contrast)

    return colors[max_index]

def make_widget(name, color, **kwargs):
    foregroundColor = make_foreground_color(color)
    shadow = None if colors_equal(foregroundColor, PyColors.background) else PyColors.background
    return getattr(widget, name)(
            foreground=foregroundColor,
            fontshadow=shadow,
            background=color,
            **kwargs
            )


@hook.subscribe.startup_once
def autostart():
    script = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([script])


class myGroup:
    # create a class to contain group name and keycode independently
    def __init__(self, name, key, layout=None):
        self.name = name
        self.key = key
        self.default_layout = layout


# modifier key (mod4 = super)
mod = "mod4"
# what terminal to try and use
#  terminal = "alacritty"
terminal = "kitty -1"

# task bar configuration
#  bar_font = "GohuFont Nerd Font Mono Medium"
#bar_font = "OpenDyslexicMono Nerd Font"
#bar_font = "C059"
#  bar_font = "ProggyCleanTT Nerd Font Mono"
bar_font = "Cascadia Code PL"
bar_fontsize = 14
bar_padding = 2
bar_size = 22
bar_default_fontshadow = PyColors.background


# app launchers
laucher = "rofi -m -1 -combi-modi drun,run -show combi -modi combi -show-icons"
alt_launcher = "dmenu_run"

# layout settings
preferred_ratio = 80 / 100
max_ratio = 90 / 100
min_ratio = 20 / 100
resize_step_ratio = 2 / 100
gap = 0
border = 2

active_color = get_standout_color() #PyColors.color6
active_color_alt = PyColors.color5
inactive_color = PyColors.background #make_inactive_color(PyColors.color6)
inactive_color_alt = make_inactive_color(PyColors.color5)

# configure groups (workspaces)
# list of myGroup, first argument is group name second is keycode
# Azerty: 
# 1-"ampersand", 2-"eacute", 3-"quotedbl", 4-"apostrophe", 
# 5-"parenleft", 6-"minus", 7-"egrave", 8-"underscore", 9-"ccedilla", 0-"agrave"
myGroups = [
    myGroup(" Work ", "ampersand", "monadwide"),
    myGroup(" Dev ", "eacute", "monadwide"),
    myGroup(" www ", "quotedbl", "max"),
    myGroup(" www-2", "apostrophe", "max"),
    myGroup(" Data ", "parenleft", "max"),
    myGroup(" Audio ", "egrave", "monadwide"),
    myGroup(" Other ", "underscore", "max")
]

# modifiers that combined with previously configured keycodes per group
# will allow you to focus that group or move currently focused windo to that group
focusGroup = [mod, "shift"]
moveWindowToGroup = [mod]

# if true, shift + group keycode will move currently active window to corresponding group
shiftToMoveWindow = False

# icons
icons = dict(
    separator= '',#'┌┺┽╀┮┩',#'╵╹▚▞▜▕', #'', #'',#'',#'░▒▓',
    mem='RAM: ',#'',
    cpu='CPU: ',#'',
    disk='HD: ',
    net='NET: ',#'鷺',
    netArrows='↓↑',#'⬇⬆',
    vol='VOL:',#'',
    date='',#'',
    time='',#'',
    color='',
    battery='BAT: '
)

# shortcuts for doing everything
keys = [
    # change focused window
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.layout.next(),
        desc="Move window focus to other window"),

    # move focused window
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod], "space", lazy.layout.swap_main(),
        desc="Swap current window with Main"),

    # resize window
    Key([mod], "h", lazy.layout.grow(), desc="Grow window"),
    Key([mod], "l", lazy.layout.shrink(), desc="Shrink window"),
    #  Key([mod], "m", lazy.layout.maximize(),
        #  desc="maximize current window"),
    Key([mod], "n", lazy.layout.normalize(),
        desc="Reset all non-master window sizes"),

    # launchers
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "x", lazy.spawn(laucher), desc="Show rofi launcher"),
#    Key([mod], "p", lazy.spawn(alt_launcher), desc="Show dmenu launcher"),

    Key([mod], "p", lazy.run_extension(extension.DmenuRun(
        font = "Cascadia Code PL",
        fontsize="14",
        background=PyColors.background,
        foreground=PyColors.foreground,
        selected_background=PyColors.color3,
        selected_foreground=PyColors.color7
    )), desc="Show dmenu launcher"),

    # kill focused window
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),

    # toggle floating
    Key([mod], "z", lazy.window.toggle_floating(), desc="Toggle floating for currently selected window"),

    # switch layouts
    Key([mod, "shift"], "s", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),

    # switch focused screen
    Key([mod], "e", lazy.to_screen(0), desc="Focus main screen"),
    Key([mod], "t", lazy.to_screen(1), desc="Focus secondary screen"),

    # qtile functions
    Key([mod, "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # multimedia
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +1%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -1%")),
    # toggle default microphone/input mute 
    Key([mod], "m", lazy.spawn("/home/alexis/Learning/tuya-api/muteUnmuteMic.sh")),

    # stuffj4-dmenu-desktop
    Key([mod], "F12", lazy.spawn("lock")),
    # apps
    KeyChord([mod], "o", [
       Key([], "t", lazy.spawn(terminal)),
       Key([], "w", lazy.spawn("google-chrome-stable")),
       Key([], "p", lazy.spawn("pcmanfm"))
    ])
]

# define groups
# groups = [Group(i.name) for i in myGroups]
groups = []

# define keyboard shortcuts for group switching and moving focused window
for i in myGroups:
    if i.default_layout:
        groups.append(Group(name=i.name, layout=i.default_layout))
    else:
        groups.append(Group(i.name))

    keys.extend([
        # switch to group
        Key(focusGroup, i.key, lazy.group[i.name].toscreen(toggle=False),
            desc="Switch to group {}".format(i.name)),
        # move focused window to group
        Key(moveWindowToGroup, i.key, lazy.window.togroup(i.name, switch_group=False),
            desc="move focused window to group {}".format(i.name)),
    ])


# layouts config
layoutConfig = dict(
    border_focus=active_color,
    border_normal=inactive_color,
    align=layout.MonadTall._left,
    ratio=preferred_ratio,
    border_width=border,
    margin=gap,
    max_ratio=max_ratio,
    min_ratio=min_ratio,
    new_client_position='top',
)

# define layouts
layouts = [
    layout.MonadTall(**layoutConfig),
    layout.MonadWide(**layoutConfig),
    #  layout.VerticalTile(**layoutConfig),
    #  layout.Zoomy(**layoutConfig),
    layout.Max()
]

widget_defaults = dict(
    font=bar_font,
    fontsize=bar_fontsize,
    padding=bar_padding,
    background=PyColors.background,
    foreground=PyColors.foreground,
    fontshadow=bar_default_fontshadow,
)
extension_defaults = widget_defaults.copy()

separator = dict(
    text=icons['separator'],
    fontsize=bar_size,
    padding=0
)

powerlineBar = []

powerlineWidgets = {
    'net': PyColors.color1,
    'memory': PyColors.color2,
    'cpu': PyColors.color3,
    'disk': PyColors.color4,
    'volume': PyColors.color5,
    'battery': PyColors.color6,
    'calendar': PyColors.color8
}

previousColor = None


for name, color in powerlineWidgets.items():
    if previousColor:
        powerlineBar.append(
            widget.TextBox(
                foreground=color,
                background=previousColor,
                **separator
            ),
        )
    else:
        powerlineBar.append(
            widget.TextBox(
                foreground=color,
                **separator
            ),
        )

    if name == 'memory':
        powerlineBar.append(
            make_widget('Memory', color, format=icons['mem'] + " {MemUsed: .0f}{mm}")
        )
    elif name == 'cpu':
        powerlineBar.append(
            make_widget('CPU', color, format=icons['cpu'] + " {load_percent}%")
        )
    elif name == 'disk':
        powerlineBar.append(
            make_widget(
                'DF',
                color,
                format=icons['disk'] + "{uf}{m}",
                measure='G',
                visible_on_warn=False,
                warn_color=PyColors.foreground
            )
        )
    elif name == 'net':
        powerlineBar.append(
            make_widget(
                'Net',
                color,
                interface='wlp2s0',
                format=icons['net'] + " {down} " + icons['netArrows'] + " {up}"
            )
        )
    elif name == 'volume':
        powerlineBar.append(
            make_widget(
                'TextBox',
                color,
                text=icons['vol']
            )
        )
        powerlineBar.append(
            make_widget(
                'Volume',
                color
            )
        )
    elif name == 'battery':
        powerlineBar.append(
            make_widget(
                'Battery',
                color,
                format=icons['battery'] + "{percent:2.0%}"
            )
        )
    elif name == 'calendar':
        powerlineBar.append(
            make_widget(
                'Clock',
                PyColors.color8,
                format=icons['date'] + ' %a %d/%m ' + icons['time'] + ' %H:%M'
            )
        )

    previousColor = color


powerlineBar.append(
    widget.TextBox(
        foreground=PyColors.background,
        background=previousColor,
        **separator
    ),
)
powerlineBar.append(
    widget.Systray()
)

mainBar = [
    widget.GroupBox(
        active=active_color_alt,
        inactive=inactive_color_alt,
        this_current_screen_border=active_color,
        this_screen_border=inactive_color,
        highlight_method='line',
        #  font="Analecta",
        font="Cascadia Code PL",
        #fontsize=18,
        fontshadow=None,
        borderwidth=3
    ),
    widget.Spacer(),
] + powerlineBar

screens = [
    Screen(
        top=bar.Bar(
            mainBar,
            bar_size,
        ),
    ),
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(
                    active=active_color_alt,
                    inactive=inactive_color_alt,
                    this_current_screen_border=active_color,
                    this_screen_border=inactive_color,
                    highlight_method='line',
                    font="Cascadia Code PL",
                    #  fontsize=18,
                    fontshadow=None,
                    borderwidth=3
                ),
                #  widget.Mpris2(objname="org.mpris.MediaPlayer2.spotify",
                              #  name="spotify",
                              #  max_chars=60,
                              #  display_metadata=['xesam:album', 'xesam:title'],
                              #  stop_pause_text="Spotify not playing",
                              #  scroll_interval=0
                              #  ),
                widget.Spacer(),
                widget.TextBox(text=icons['color'], foreground=PyColors.color1),
                widget.TextBox(text=icons['color'], foreground=PyColors.color2),
                widget.TextBox(text=icons['color'], foreground=PyColors.color3),
                widget.TextBox(text=icons['color'], foreground=PyColors.color4),
                widget.TextBox(text=icons['color'], foreground=PyColors.color5),
                widget.TextBox(text=icons['color'], foreground=PyColors.color6),
                widget.TextBox(text=icons['color'], foreground=PyColors.color7),
                widget.TextBox(text=icons['color'], foreground=PyColors.color8),
                widget.TextBox(text=icons['color'], foreground=PyColors.color9),
                make_widget('Memory', PyColors.background, format=":"+icons['time']+" {MemUsed: .0f}{mm}"),
                #  widget.Spacer(),
                make_widget(
                    'Clock',
                    PyColors.background,
                    format=icons['date'] + ' %a %d/%m ' + icons['time'] + ' %H:%M'
                    ),
                # make_widget('Volume', PyColors.background, fmt="  {}"),
            ],
            bar_size,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    # Match(wm_class='gokedex')
    # Match(wm_class='rofi'),  # rofi launcher
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

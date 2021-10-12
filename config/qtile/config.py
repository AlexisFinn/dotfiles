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

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
import PyColors
import os
import subprocess


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])


class myGroup:
    # create a class to contain group name and keycode independently
    def __init__(self, name, key):
        self.name = name
        self.key = key


# modifier key (mod4 = super)
mod = "mod4"
# what terminal to try and use
terminal = "alacritty"

# task bar configuration
bar_font = "FiraCode Nerd Font Mono"
bar_fontsize = 16
bar_padding = 4
bar_size = 26

# app launchers
laucher = "rofi -combi-modi drun,run -show combi -modi combi -show-icons"
alt_launcher = "dmenu_run"

# layout settings
preferred_ratio = 80 / 100
max_ratio = 90 / 100
min_ratio = 20 / 100
resize_step_ratio = 2 / 100
gap = 17
border = 3
active_color = PyColors.color6
active_color_alt = PyColors.color5
inactive_color = PyColors.color1
inactive_color_alt = PyColors.color8

# configure groups (workspaces)
# list of myGroup, first argument is group name second is keycode
myGroups = [
    myGroup("chat", "ampersand"),
    myGroup("dev", "eacute"),
    myGroup("www", "quotedbl"),
    myGroup("db", "apostrophe"),
    myGroup("other", "parenleft")
]

# modifiers that combined with previously configured keycodes per group
# will allow you to focus that group or move currently focused windo to that group
focusGroup = [mod, "shift"]
moveWindowToGroup = [mod]

# if true, shift + group keycode will move currently active window to corresponding group
shiftToMoveWindow = False

# icons
icons = dict(
    separator='',
    mem='',
    cpu='',
    net='鷺',
    netArrows='⬇⬆',
    vol='',
    date='',
    time='',
    color='●'
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
    Key([mod], "n", lazy.layout.normalize(),
        desc="Reset all non-master window sizes"),

    # launchers
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "x", lazy.spawn(laucher), desc="Show rofi launcher"),
    Key([mod], "p", lazy.spawn(alt_launcher), desc="Show dmenu launcher"),

    # kill focused window
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),

    # switch layouts
    Key([mod, "shift"], "s", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),

    # switch focused screen
    Key([mod], "t", lazy.to_screen(0), desc="Focus main screen"),
    Key([mod], "e", lazy.to_screen(1), desc="Focus secondary screen"),

    # qtile functions
    Key([mod, "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # multimedia
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ +2%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn(
        "pactl set-sink-volume @DEFAULT_SINK@ -2%"))
]

# define groups
groups = [Group(i.name) for i in myGroups]

# define keyboard shortcuts for group switching and moving focused window
for i in myGroups:
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
    new_client_position='top'
)

# define layouts
layouts = [
    layout.MonadTall(**layoutConfig),
    layout.MonadWide(**layoutConfig),
    layout.Max()
]

widget_defaults = dict(
    font=bar_font,
    fontsize=bar_fontsize,
    padding=bar_padding,
    background=PyColors.background,
    foreground=PyColors.foreground
)
extension_defaults = widget_defaults.copy()

separator = dict(
    text=icons['separator'],
    fontsize=bar_size,
    padding=0
)

powerlineBar = []

powerlineWidgets = {
    'memory': PyColors.color1,
    'cpu': PyColors.color2,
    'net': PyColors.color3,
    'volume': PyColors.color4,
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
            widget.Memory(
                background=color,
                format=icons['mem'] + " {MemUsed: .0f}{mm}"
            ),
        )
    elif name == 'cpu':
        powerlineBar.append(
            widget.CPU(
                background=color,
                format=icons['cpu'] + " {load_percent}%"
            ),
        )
    elif name == 'net':
        powerlineBar.append(
            widget.Net(
                background=color,
                interface='wlp2s0',
                format=icons['net'] + " {down} " + icons['netArrows'] + " {up}"
            ),
        )
    elif name == 'volume':
        powerlineBar.append(
            widget.TextBox(
                background=color,
                text=icons['vol'],
            ),
        )
        powerlineBar.append(
            widget.PulseVolume(
                background=color
            ),
        )
    elif name == 'calendar':
        powerlineBar.append(
            widget.Clock(
                format=icons['date'] + ' %a %d/%m ' + icons['time'] + ' %H:%M',
                background=PyColors.color8
            ),
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
                ),
                widget.Mpris2(objname="org.mpris.MediaPlayer2.spotify",
                              name="spotify",
                              max_chars=60,
                              display_metadata=['xesam:album', 'xesam:title'],
                              stop_pause_text="Spotify not playing",
                              scroll_interval=0
                              ),
                widget.Spacer(),
                widget.TextBox(text=icons['color'], foreground=PyColors.color1),
                widget.TextBox(text=icons['color'], foreground=PyColors.color2),
                widget.TextBox(text=icons['color'], foreground=PyColors.color3),
                widget.TextBox(text=icons['color'], foreground=PyColors.color4),
                widget.TextBox(text=icons['color'], foreground=PyColors.color5),
                widget.TextBox(text=icons['color'], foreground=PyColors.color6),
                widget.TextBox(text=icons['color'], foreground=PyColors.color7),
                widget.TextBox(text=icons['color'], foreground=PyColors.color8),
                widget.TextBox(text=icons['color'], foreground=PyColors.color9)
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

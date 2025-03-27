#   ______ _       _    _     ______       _
#   | ___ (_)     | |  (_)    | ___ \     (_)
#   | |_/ /_ _ __ | | ___  ___| |_/ / ___  _
#   |  __/| | '_ \| |/ / |/ _ \ ___ \/ _ \| |
#   | |   | | | | |   <| |  __/ |_/ / (_) | |
#   \_|   |_|_| |_|_|\_\_|\___\____/ \___/|_|
#   -----------------------------------------
#     And Python  -  A Match Made on Grindr
#  -------------------------------------------
import os
import re
import socket
import subprocess
import arcobattery
from libqtile import qtile, layout, bar, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, Rule
from libqtile.command import lazy
from libqtile.widget import Spacer
try:
    from typing import List  # noqa: F401
except ImportError:
    pass

#mod4 or mod = super key
mod = "mod4"
mod1 = "alt"
mod2 = "control"
home = os.path.expanduser('~')

# Personal Variables
terminal    = "alacritty"
browser1    = "brave"
browser2    = "librewolf"
browser3    = "firefox"
filemanager = "thunar"
editor      = "nvim"
guieditor   = "code"
mailclient  = "evolution"
scrlocker   = "betterlockscreen -l"


# @lazy.function
# def window_to_prev_group(qtile):
#     if qtile.currentWindow is not None:
#         i = qtile.groups.index(qtile.currentGroup)
#         qtile.currentWindow.togroup(qtile.groups[i - 1].name)


# @lazy.function
# def window_to_next_group(qtile):
#     if qtile.currentWindow is not None:
#         i = qtile.groups.index(qtile.currentGroup)
#         qtile.currentWindow.togroup(qtile.groups[i + 1].name)


keys = [

    # LAUNCHER
    Key([mod], "Escape", lazy.spawn('xkill')),
    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "b", lazy.spawn(browser1)),
    Key([mod], "e", lazy.spawn(filemanager)),
    Key([mod], "m", lazy.spawn(mailclient)),
    Key([mod], "p", lazy.spawn('rofi -theme-str "window {width: 30%;height: 40%;}" -show drun')),
    Key([mod], "v", lazy.spawn('pavucontrol')),
    Key([mod], "w", lazy.spawn(guieditor)),
    Key([mod], "F12", lazy.spawn('rofi-theme-selector')),
    Key([mod, "shift"], "b", lazy.spawn(browser2)),
    Key([mod, "shift"], "Return", lazy.spawn("dmenu_run -p 'Run: ' -h 26")),
    Key([mod, "control"], "b", lazy.spawn(browser3)),
    Key(["mod1", "control"], "l", lazy.spawn(scrlocker)),
    Key(["mod1", "control"], "o", lazy.spawn( home + '/.config/qtile/scripts/picom-toggle.sh' )),

    # SCREENSHOTS
    Key([], "Print", lazy.spawn("scrot 'ArchPinkie%a-%d-%b-%Y-%H:%M_screenshot_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir PICTURES)'")),

    # QTILE
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod2], "F5", lazy.restart()),
    Key([mod], "F1", lazy.spawncmd()),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "shift"], "q", lazy.spawn("archlinux-logout")),
    # Key([mod, "shift"], "q", lazy.shutdown()),

    # MULTIMEDIA KEYS
    # INCREASE/DECREASE BRIGHTNESS
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -inc 5")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 5")),
    # INCREASE/DECREASE/MUTE VOLUME
    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -q set Master 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -q set Master 5%+")),

    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),

    # CHANGE FOCUS
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),

    # RESIZE UP, DOWN, LEFT, RIGHT
    Key([mod, "control"], "l",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "h",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "k",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "j",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),

    # FLIP LAYOUT
    Key([mod, "shift"], "f", lazy.layout.flip()),
    # FLIP LAYOUT FOR BSP
    Key([mod, "mod1"], "k", lazy.layout.flip_up()),
    Key([mod, "mod1"], "j", lazy.layout.flip_down()),
    Key([mod, "mod1"], "l", lazy.layout.flip_right()),
    Key([mod, "mod1"], "h", lazy.layout.flip_left()),

    # MOVE WINDOWS
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Left", lazy.layout.swap_left()),
    Key([mod, "shift"], "Right", lazy.layout.swap_right()),

    # TOGGLE FLOATING LAYOUT
    Key([mod, "shift"], "space", lazy.window.toggle_floating()),

    ]


def window_to_previous_screen(qtile, switch_group=False, switch_screen=False):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group, switch_group=switch_group)
        if switch_screen == True:
            qtile.cmd_to_screen(i - 1)


def window_to_next_screen(qtile, switch_group=False, switch_screen=False):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group, switch_group=switch_group)
        if switch_screen == True:
            qtile.cmd_to_screen(i + 1)


keys.extend([
    # MOVE WINDOW TO NEXT SCREEN
    Key([mod,"shift"], "Right", lazy.function(window_to_next_screen, switch_screen=True)),
    Key([mod,"shift"], "Left", lazy.function(window_to_previous_screen, switch_screen=True)),
])

groups = []

# FOR QWERTY KEYBOARDS
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9",]

# FOR AZERTY KEYBOARDS
#group_names = ["ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", "section", "egrave", "exclam", "ccedilla", "agrave",]

group_labels = ["1 ", "2 ", "3 ", "4 ", "5 ", "6 ", "7 ", "8 ", "9 ",]
# group_labels = ["", "", "", "", "", "", "", "", "", "",]
#group_labels = ["Web", "Edit/chat", "Image", "Gimp", "Meld", "Video", "Vb", "Files", "Mail", "Music",]

group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall",]
#group_layouts = ["monadtall", "matrix", "monadtall", "bsp", "monadtall", "matrix", "monadtall", "bsp", "monadtall", "monadtall",]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

for i in groups:
    keys.extend([

#CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
        # MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND FOLLOW MOVED WINDOW TO WORKSPACE
        Key([mod, "control"], i.name, lazy.window.togroup(i.name) , lazy.group[i.name].toscreen()),
    ])


def init_layout_theme():
    return {"margin": 8,
            "border_width": 2,
            "border_focus": "#FF79C6",
            "border_normal": "#4D4D4D"
            }

layout_theme = init_layout_theme()


layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Matrix(**layout_theme),
    layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme)
]

#Theme name : ArcoLinux Dracula
def init_colors():
    return [["#000000", "#000000"], # color 0
            ["#282A36", "#282A36"], # color 1
            ["#F8F8F2", "#F8F8F2"], # color 2
            ["#F1FA8C", "#F1FA8C"], # color 3
            ["#BD93F9", "#BD93F9"], # color 4
            ["#FF79C6", "#FF79C6"], # color 5
            ["#8BE9FD", "#8BE9FD"], # color 6
            ["#BFBFBF", "#BFBFBF"], # color 7
            ["#4D4D4D", "#4D4D4D"], # color 8
            ["#FF5555", "#FF5555"]] # color 9

colors = init_colors()


# WIDGETS FOR THE BAR

def init_widgets_defaults():
    return dict(font="Ubuntu Regular",
                fontsize = 13,
                padding = 2,
                background=colors[1])

widget_defaults = init_widgets_defaults()

def init_widgets_list():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
    widgets_list = [
        widget.Sep(
            linewidth = 3,
            foreground = colors[1],
            background = colors[1]
            ),
        widget.Image(
            filename = "~/.config/qtile/icons/qtile-ish.svg",
            background = colors[1],
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn("dmenu_run -p 'Run: ' -h 26")}
            ),
        widget.Sep(
            linewidth = 2,
            foreground = colors[1],
            background = colors[1]
            ),

        widget.GroupBox(
            font="JetBrainsMono Nerd Font Mono Bold",
            fontsize = 16,
            padding_y = 6,
            padding_x = 1,
            borderwidth = 0,
            disable_drag = True,
            active = colors[5],
            inactive = colors[7],
            rounded = False,
            highlight_method = "text",
            this_current_screen_border = colors[9],
            foreground = colors[2],
            background = colors[1]
            ),
        widget.Sep(
            linewidth = 2,
            foreground = colors[1],
            background = colors[1]
            ),
        widget.WindowTabs(
            foreground = colors[5],
            ),
        widget.TextBox(
            text = '',
            font = "Hack Nerd Font Mono Bold",
            padding = 5,
            foreground = colors[9],
            fontsize = 22
            ),
        widget.Net(
            format = '{down} ↓↑ {up}',
            foreground = colors[2],
            ),
        widget.Sep(
            linewidth = 3,
            foreground = colors[1],
            background = colors[1]
            ),
        widget.TextBox(
            text = '',
            font = "Hack Nerd Font Mono Bold",
            padding = 5,
            foreground = colors[9],
            fontsize = 22
            ),
        widget.TextBox(
            text = " 🖬",
            foreground = colors[2],
            fontsize = 14
            ),
        widget.Memory(
            mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' -e htop')},
            foreground = colors[2],
            padding = 8
            ),
        widget.Sep(
            linewidth = 3,
            foreground = colors[1],
            background = colors[1]
            ),
        widget.TextBox(
            text = '',
            font = "Hack Nerd Font Mono Bold",
            padding = 5,
            foreground = colors[9],
            fontsize = 22
            ),
        widget.Systray(
            padding = 8,
            margin_x = 2,
            foreground = colors[6],
            # icon_size = 12,
            ),
        widget.Sep(
            linewidth = 3,
            foreground = colors[1],
            background = colors[1]
            ),
        # arcobattery.BatteryIcon(
        #     theme_path = home + "/.config/qtile/icons/battery_icons_horiz",
        #     padding = 0,
        #     scale = 0.7,
        #     y_poss = 2,
        #     update_interval = 5,
        #     foreground = colors[2],
        #     background = colors[1]
        #     ),
        # widget.Sep(
        #     linewidth = 3,
        #     foreground = colors[1],
        #     background = colors[1]
        #     ),
        widget.TextBox(
            text = '',
            font = "Hack Nerd Font Mono Bold",
            padding = 5,
            foreground = colors[9],
            fontsize = 22
            ),
        widget.CurrentLayoutIcon(
            foreground = colors[6],
            background = colors[1],
            padding = 2,
            scale = 0.7
            ),
        widget.CurrentLayout(
            foreground = colors[2],
            background = colors[1],
            padding = 6
            ),
        widget.TextBox(
            text = '',
            font = "Hack Nerd Font Mono Bold",
            padding = 5,
            foreground = colors[9],
            fontsize = 22
            ),
        widget.Clock(
            format = " %a %d %b  [ %H:%M ]",
            foreground = colors[2],
            padding = 5,
            ),
        widget.Sep(
            linewidth = 0,
            padding = 5,
            foreground = colors[0],
            ),
        ]

    return widgets_list

widgets_list = init_widgets_list()


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2

widgets_screen1 = init_widgets_screen1()
widgets_screen2 = init_widgets_screen2()


def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=26, opacity=1)),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), size=26, opacity=1))]
screens = init_screens()


# MOUSE CONFIGURATION
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size())
]

dgroups_key_binder = None
dgroups_app_rules = []

# ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME
# BEGIN

#########################################################
################ assgin apps to groups ##################
#########################################################
# @hook.subscribe.client_new
# def assign_app_group(client):
#     d = {}
#     #####################################################################################
#     ### Use xprop fo find  the value of WM_CLASS(STRING) -> First field is sufficient ###
#     #####################################################################################
#     d[group_names[0]] = ["Navigator", "Firefox", "Vivaldi-stable", "Vivaldi-snapshot", "Chromium", "Google-chrome", "Brave", "Brave-browser",
#               "navigator", "firefox", "vivaldi-stable", "vivaldi-snapshot", "chromium", "google-chrome", "brave", "brave-browser", ]
#     d[group_names[1]] = [ "Atom", "Subl", "Geany", "Brackets", "Code-oss", "Code", "TelegramDesktop", "Discord",
#                "atom", "subl", "geany", "brackets", "code-oss", "code", "telegramDesktop", "discord", ]
#     d[group_names[2]] = ["Inkscape", "Nomacs", "Ristretto", "Nitrogen", "Feh",
#               "inkscape", "nomacs", "ristretto", "nitrogen", "feh", ]
#     d[group_names[3]] = ["Gimp", "gimp" ]
#     d[group_names[4]] = ["Meld", "meld", "org.gnome.meld" "org.gnome.Meld" ]
#     d[group_names[5]] = ["Vlc","vlc", "Mpv", "mpv" ]
#     d[group_names[6]] = ["VirtualBox Manager", "VirtualBox Machine", "Vmplayer",
#               "virtualbox manager", "virtualbox machine", "vmplayer", ]
#     d[group_names[7]] = ["Thunar", "Nemo", "Caja", "Nautilus", "org.gnome.Nautilus", "Pcmanfm", "Pcmanfm-qt",
#               "thunar", "nemo", "caja", "nautilus", "org.gnome.nautilus", "pcmanfm", "pcmanfm-qt", ]
#     d[group_names[8]] = ["Evolution", "Geary", "Mail", "Thunderbird",
#               "evolution", "geary", "mail", "thunderbird" ]
#     d[group_names[9]] = ["Spotify", "Pragha", "Clementine", "Deadbeef", "Audacious",
#               "spotify", "pragha", "clementine", "deadbeef", "audacious" ]
#     ######################################################################################
#
# wm_class = client.window.get_wm_class()[0]
#
#     for i in range(len(d)):
#         if wm_class in list(d.values())[i]:
#             group = list(d.keys())[i]
#             client.togroup(group)
#             client.group.cmd_toscreen(toggle=False)

# END
# ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME


main = None


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])


@hook.subscribe.startup
def start_always():
    # Set the cursor to something sane in X
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])


@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True
        window.cmd_bring_to_front()


floating_types = ["notification", "toolbar", "splash", "dialog"]


follow_mouse_focus = False
bring_front_click = True
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
    Match(wm_class='Arcolinux-welcome-app.py'),
    Match(wm_class='Arcolinux-calamares-tool.py'),
    Match(wm_class='confirm'),
    Match(wm_class='dialog'),
    Match(wm_class='download'),
    Match(wm_class='error'),
    Match(wm_class='file_progress'),
    Match(wm_class='notification'),
    Match(wm_class='splash'),
    Match(wm_class='toolbar'),
    Match(wm_class='Arandr'),
    Match(wm_class='feh'),
    Match(wm_class='Galculator'),
    Match(wm_class='archlinux-logout'),
    Match(wm_class='xfce4-terminal'),

],  fullscreen_border_width = 0, border_width = 0)
auto_fullscreen = True

focus_on_window_activation = "focus" # or smart

wmname = "LG3D"

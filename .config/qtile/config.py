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
from libqtile.config import Drag, Key, Screen, Group, Click, Rule
from libqtile.command import lazy
from libqtile.widget import Spacer

# Modkeys
mod  = "mod4"
alt  = "mod1"
mod2 = "control"
home = os.path.expanduser('~')

# Personal Variables
terminal    = "kitty"
browser1    = "brave"
browser2    = "qutebrowser"
mailclient  = "evolution"
filemanager = "thunar"
guieditor   = "kate"
scrlocker   = "betterlockscreen -l"


@lazy.function
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)


@lazy.function
def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)


keys = [

    # Launcher
    Key([mod], "Escape", lazy.spawn('xkill')),
    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "b", lazy.spawn(browser1)),
    Key([mod], "d", lazy.spawn("dmenu_run -p 'Run: ' -h 22")),
    Key([mod], "e", lazy.spawn(filemanager)),
    Key([mod], "m", lazy.spawn(mailclient)),
    Key([mod], "p", lazy.spawn('rofi -show drun -show-icons')),
    Key([mod], "v", lazy.spawn('pavucontrol')),
    Key([mod], "w", lazy.spawn(guieditor)),
    Key([mod], "F12", lazy.spawn('rofi-theme-selector')),
    Key([mod, "shift"], "b", lazy.spawn(browser2)),
    Key(["mod1", "control"], "o", lazy.spawn(home + '/.config/qtile/scripts/picom-toggle.sh')),
    # Screenshots
    Key([], "Print", lazy.spawn("scrot '%a-%d-%b-%Y-%H:%M_screenshot_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir PICTURES)'")),

    # Qtile
    Key([mod], "f", lazy.window.toggle_fullscreen()),
    Key([mod], "n", lazy.layout.normalize()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "F1", lazy.spawncmd()),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "shift"], "q", lazy.shutdown()),

    # Miltimedia
        # Brightness
    # Key([], "XF86MonBrightnessUp", lazy.spawn("backlight -inc 10")),
    # Key([], "XF86MonBrightnessDown", lazy.spawn("backlight-down 10")),
        # Volume
    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -q set Master 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -q set Master 5%+")),

    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),

    # Window Control
        # Window Focus
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
        # Move Windows
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Left", lazy.layout.swap_left()),
    Key([mod, "shift"], "Right", lazy.layout.swap_right()),
        # Resize Up / Down / Left / Right
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
        # Flip Layout
    Key([mod, "shift"], "f", lazy.layout.flip()),
        # Flip Layout ( BSP )
    Key([mod, "mod1"], "k", lazy.layout.flip_up()),
    Key([mod, "mod1"], "j", lazy.layout.flip_down()),
    Key([mod, "mod1"], "l", lazy.layout.flip_right()),
    Key([mod, "mod1"], "h", lazy.layout.flip_left()),
        # Toggle Floating
    Key([mod, "shift"], "space", lazy.window.toggle_floating()),]

groups = []

# FOR QWERTY KEYBOARDS
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
group_labels = ["1 ", "2 ", "3 ", "4 ", "5 ", "6 ", "7 ", "8 ", "9"]
#group_labels = ["", "", "", "", "", "", "", "", ""]
group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall"]

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
    return {"margin":10,
            "border_width":2,
            "border_focus": "#9400DE",
            "border_normal": "#4C566A"
            }


layout_theme = init_layout_theme()

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.RatioTile(**layout_theme),
    layout.Matrix(**layout_theme),
    layout.Bsp(**layout_theme),
    layout.Max(**layout_theme),
    layout.Floating(**layout_theme),
]

# COLORS FOR THE BAR
colors = [["#282c34", "#282c34"], # 0
          ["#434758", "#434758"], # 1
          ["#ffffff", "#ffffff"], # 2
          ["#ff5555", "#ff5555"], # 3
          ["#72238f", "#72238f"], # 4
          ["#6790EB", "#6790EB"], # 5
          ["#e1acff", "#e1acff"], # 6
          ["#cd1f3f", "#cd1f3f"], # 7
          ["#a9a9a9", "#a9a9a9"]] # 8


##### DEFAULT WIDGET SETTINGS #####
widget_defaults = dict(
    font="Hack Nerd Font",
    fontsize = 12,
    padding = 0,
    margin_x = 5,
    background=colors[0]
)
extension_defaults = widget_defaults.copy()

def init_widgets_list():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
    widgets_list = [
              widget.Sep(
                  linewidth = 3,
                  foreground = colors[0],
                  background = colors[0]
                  ),
              widget.Image(
                  filename = "~/.config/qtile/icons/python.png",
                  background = colors[0],
                  mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn("dmenu_run -p 'Run: ' -h 24")}
                  ),
              widget.Sep(
                  linewidth = 2,
                  foreground = colors[0],
                  background = colors[0]
                  ),
              widget.GroupBox(
                  font = "Hack Nerd Font Mono Bold",
                  fontsize = 12,
                  margin_y = 3,
                  margin_x = 5,
                  padding_y = 5,
                  padding_x = 3,
                  borderwidth = 3,
                  active = colors[6],
                  inactive = colors[8],
                  rounded = False,
                  highlight_color =  colors[1],
                  highlight_method = "line",
                  this_current_screen_border = colors[6],
                  this_screen_border = colors [4],
                  other_current_screen_border = colors[0],
                  other_screen_border = colors[0],
                  background = colors[0]
                  ),
              widget.Sep(
                  linewidth = 2,
                  foreground = colors[0],
                  background = colors[0]
                  ),
              widget.Prompt(
                  prompt = f"{socket.gethostname().title()}: ",
                  font = "Hack Nerd Font Mono",
                  fontsize = 14,
                  padding = 10,
                  foreground = colors[6],
                  background = colors[0],
                  ),
              widget.Sep(
                  linewidth = 0,
                  padding = 45,
                  foreground = colors[2],
                  background = colors[0]
                  ),
              widget.WindowTabs(
                  foreground = colors[6],
                  ),
              widget.TextBox(
                  text = '',
                  font = "Hack Nerd Font Mono Bold",
                  padding = 5,
                  foreground = colors[6],
                  fontsize = 18
                  ),
              widget.Net(
                  format = '{down} ↓↑ {up}',
                  foreground = colors[2],
                  ),
              widget.Sep(
                  linewidth = 3,
                  foreground = colors[0],
                  background = colors[0]
                  ),
              widget.TextBox(
                  text = '',
                  font = "Hack Nerd Font Mono Bold",
                  padding = 5,
                  foreground = colors[6],
                  fontsize = 18
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
                  foreground = colors[0],
                  background = colors[0]
                  ),
              widget.TextBox(
                  text = '',
                  font = "Hack Nerd Font Mono Bold",
                  padding = 5,
                  foreground = colors[6],
                  fontsize = 18
                  ),
              widget.Systray(
                  padding = 8,
                  margin_x = 2,
                  foreground = colors[6],
                  ),
              # widget.Sep(
              #     linewidth = 3,
              #     foreground = colors[0],
              #     background = colors[0]
              #     ),
              # arcobattery.BatteryIcon(
              #     theme_path=home + "/.config/qtile/icons/battery_icons_horiz",
              #     padding=0,
              #     scale=0.7,
              #     y_poss=2,
              #     update_interval = 5,
              #     foreground = colors[2],
              #     background = colors[0]
              #     ),
              widget.Sep(
                  linewidth = 3,
                  foreground = colors[0],
                  background = colors[0]
                  ),
              widget.TextBox(
                  text = '',
                  font = "Hack Nerd Font Mono Bold",
                  padding = 5,
                  foreground = colors[6],
                  fontsize = 18
                  ),
              widget.TextBox(
                  text = " Vol:",
                  foreground = colors[2],
                  padding = 3
                  ),
              widget.Volume(
                  foreground = colors[2],
                  padding = 8
                  ),
              widget.TextBox(
                  text = '',
                  font = "Hack Nerd Font Mono Bold",
                  padding = 5,
                  foreground = colors[6],
                  fontsize = 18
                  ),
              widget.CurrentLayoutIcon(
                  foreground = colors[6],
                  background = colors[0],
                  padding = 3,
                  scale = 0.7
                  ),
              widget.CurrentLayout(
                  foreground = colors[2],
                  background = colors[0],
                  padding = 8
                  ),
              widget.TextBox(
                  text = '',
                  font = "Hack Nerd Font Mono Bold",
                  padding = 5,
                  foreground = colors[6],
                  fontsize = 18
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


widgets_screen1 = init_widgets_screen1()


def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), size=22))]
screens = init_screens()


# Mouse Keys
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []

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


floating_types = ["notification", "toolbar", "splash", "dialog"]

follow_mouse_focus = False
bring_front_click = True
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    {'wmclass': 'lxpolkit'},
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},
    {'wmclass': 'makebranch'},
    {'wmclass': 'maketag'},
    {'wmclass': 'Arandr'},
    {'wmclass': 'feh'},
    {'wmclass': 'Galculator'},
    {'wname': 'branchdialog'},
    {'wname': 'Open File'},
    {'wname': 'pinentry'},
    {'wmclass': 'ssh-askpass'},

],  fullscreen_border_width = 0, border_width = 0)
auto_fullscreen = True
focus_on_window_activation = "smart" # or focus
wmname = "LG3D"


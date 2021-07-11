local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

-- Standard awesome library
local gears         = require("gears") --Utilities such as color parsing and objects
local awful         = require("awful") --Everything related to window managment
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
naughty.config.defaults['icon_size'] = 100
local menubar       = require("menubar")
local lain          = require("lain")
local freedesktop   = require("freedesktop")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({ "unclutter -root" }) -- entries must be comma-separated

local themes = {
    "powerarrow-blue", -- 1
    "powerarrow",      -- 2
    "multicolor",      -- 3
}

-- choose your theme here
local chosen_theme = themes[1]
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
beautiful.init(theme_path)

local modkey       = "Mod4"
local altkey       = "Mod1"
local modkey1      = "Control"

-- personal variables
local terminal          = "kitty"
local browser1          = "brave"
local browser2          = "qutebrowser"
local editor            = os.getenv("EDITOR") or "nvim"
local editorgui         = "kate"
local filemanager       = "nemo"
local mailclient        = "evolution"
local mediaplayer       = "vlc"
local scrlocker         = "slimlock"
local virtualmachine    = "virtualbox"

-- awesome variables
awful.util.terminal = terminal
awful.util.tagnames = {  "1", "2", "3", "4", "5", "6", "7", "8", "9" }
--awful.util.tagnames = {  " ", " ", " ", " ", " ", " ", " ", " ", " ", " "  }
--awful.util.tagnames = { " DEV ", " WWW ", " SYS ", " DOC ", " VBOX ", " CHAT ", " MUS ", " VID ", " GFX " }
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.spiral,
    awful.layout.suit.max,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.sw,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.se,
    awful.layout.suit.floating,
}

awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = 250}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

beautiful.init(string.format(gears.filesystem.get_configuration_dir() .. "/themes/%s/theme.lua", chosen_theme))

local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e 'man awesome'" },
    { "edit config", terminal.." vim ~/.config/awesome/rc.lua" },
    { "arandr", "arandr" },
    { "restart", awesome.restart },
}

awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 16,
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        --{ "Atom", "atom" },
        -- other triads can be put here
    },
    after = {
        { "Terminal", terminal },
        { "Log out", function() awesome.quit() end },
        { "Sleep", "systemctl suspend" },
        { "Restart", "systemctl reboot" },
        { "Exit", "systemctl poweroff" },
        -- other triads can be put here
    }
})
--menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s)
    s.systray = wibox.widget.systray()
    s.systray.visible = true
 end)

root.buttons(my_table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

globalkeys = my_table.join(

    -- dmenu
    awful.key({ modkey, "Shift" }, "Return", function () awful.spawn("dmenu_run -p 'Run: ' -h 22") end,
        {description = "show dmenu", group = "hotkeys"}),

    -- dmenu scripts
    awful.key({ altkey, "Control" }, "e", function () awful.util.spawn( "./.dmenu/dmenu-edit-configs.sh" ) end,
        {description = "edit config files" , group = "dmenu scripts" }),
    awful.key({ altkey, "Control" }, "m", function () awful.util.spawn( "./.dmenu/dmenu-sysmon.sh" ) end,
        {description = "system monitoring apps" , group = "dmenu scripts" }),
    awful.key({ altkey, "Control" }, "p", function () awful.util.spawn( "passmenu" ) end,
        {description = "passmenu" , group = "dmenu scripts" }),
    awful.key({ altkey, "Control"  }, "s", function () awful.util.spawn( "./.dmenu/dmenu-surfraw.sh" ) end,
        {description = "surfraw web search" , group = "dmenu scripts" }),
    awful.key({ altkey, "Control"  }, "t", function () awful.util.spawn( "./.dmenu/dmenu-trading.sh" ) end,
        {description = "trading programs" , group = "dmenu scripts" }),

    -- My applications
    awful.key({ modkey }, "Return", function () awful.util.spawn( terminal )                 end,
              {description = "terminal", group = "super"}),
    awful.key({ modkey }, "Escape", function () awful.util.spawn( "xkill" )                  end,
              {description = "Kill proces", group = "hotkeys"}),
    awful.key({ modkey }, "e", function () awful.util.spawn( filemanager )                   end,
              {description = "run gui editor", group = "super"}),
    awful.key({ modkey }, "m", function () awful.util.spawn( mailclient )                    end,
              {description = mailclient , group = "function keys" }),
    awful.key({ modkey }, "p", function () awful.util.spawn( "rofi -show drun -show-icons" ) end,
              {description = "rofi theme selector", group = "super"}),
    awful.key({ modkey }, "v", function () awful.util.spawn( "pavucontrol" )                 end,
              {description = "pulseaudio control", group = "super"}),
    awful.key({ modkey }, "w", function () awful.util.spawn( editorgui )                     end,
              {description = "gui editor", group = "super"}),
    awful.key({ modkey }, "F5", function () awful.util.spawn( "meld" )                       end,
              {description = "meld" , group = "function keys" }),
    awful.key({ modkey }, "F12", function () awful.util.spawn( "rofi-theme-selector" )       end,
              {description = "rofi" , group = "Theming" }),

    awful.key({ modkey, "Shift" }, "b", function () awful.spawn( browser2 )                  end,
              {description = "surf web browser" , group = "gui apps" }),

    -- ctrl+alt
    awful.key({ modkey1, altkey }, "o", function() awful.spawn.with_shell("$HOME/.config/wm-scripts/picom-toggle.sh") end,
              {description = "Picom toggle", group = "System"}),
    awful.key({ modkey1, altkey }, "p", function() awful.util.spawn( "pamac-manager" )       end,
              {description = "Pamac Manager", group = "alt+ctrl"}),

    -- screenshots
    awful.key({ }, "Print", function () awful.util.spawn("scrot 'ArcoLinuxD-%Y-%m-%d-%s_screenshot_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir PICTURES)'") end,
              {description = "Scrot", group = "screenshots"}),
    awful.key({ modkey1 }, "Print", function () awful.util.spawn( "xfce4-screenshooter" )    end,
              {description = "Xfce screenshot", group = "screenshots"}),
    awful.key({ modkey1, "Shift"  }, "Print", function() awful.util.spawn("gnome-screenshot -i") end,
              {description = "Gnome screenshot", group = "screenshots"}),

    -- Hotkeys Awesome
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
        {description = "show help", group="awesome"}),

    -- Default client focus
    awful.key({ altkey }, "j", function () awful.client.focus.byidx( 1) end,
        {description = "focus next by index", group = "client"}),
    awful.key({ altkey }, "k", function () awful.client.focus.byidx(-1) end,
        {description = "focus previous by index", group = "client"}),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

        -- By direction client focus with arrows
    awful.key({ modkey1, modkey }, "Down",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey1, modkey }, "Up",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey1, modkey }, "Left",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey1, modkey }, "Right",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

    awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey }, ".", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey }, ",", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey1,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
              {description = "go back", group = "client"}),


    -- Show/Hide Systray
    awful.key({ modkey }, "-", function ()
    awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
    end, {description = "Toggle systray visibility", group = "awesome"}),

    -- Standard program
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ altkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ altkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "Tab", function () awful.layout.inc( 1)                  end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "Tab", function () awful.layout.inc(-1)                  end,
              {description = "select previous", group = "layout"}),

    -- Widgets popups
    awful.key({ altkey, }, "c", function () lain.widget.calendar.show(7) end,
              {description = "show calendar", group = "widgets"}),
    awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
              {description = "show filesystem", group = "widgets"}),
    awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
              {description = "show weather", group = "widgets"}),

    -- ALSA volume control
    awful.key({ modkey1 }, "Up",
    --awful.key({ }, "XF86AudioRaiseVolume",
        function ()
            os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ modkey1 }, "Down",
    -- awful.key({ }, "XF86AudioLowerVolume",
        function ()
            os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ }, "XF86AudioMute",
        function ()
            os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ modkey1, "Shift" }, "m",
        function ()
            os.execute(string.format("amixer -q set %s 100%%", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ modkey1, "Shift" }, "0",
        function ()
            os.execute(string.format("amixer -q set %s 0%%", beautiful.volume.channel))
            beautiful.volume.update()
        end),

    -- Copy primary to clipboard (terminals to gtk)
    awful.key({ modkey }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
              {description = "copy terminal to gtk", group = "hotkeys"}),
    -- Copy clipboard to primary (gtk to terminals)
    awful.key({ modkey }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
              {description = "copy gtk to terminal", group = "hotkeys"}),

    -- Menubar
    awful.key({ modkey, "Shift" }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "super"})
)

clientkeys = my_table.join(
    awful.key({ altkey, "Shift" }, "m",      lain.util.magnify_client,
              {description = "magnify client", group = "client"}),
    awful.key({ modkey,         }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "hotkeys"}),
    awful.key({ modkey, "Shift"   }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = false } },

    -- Set applications to map to tags
    { rule = { class = "Firefox" },
      properties = { screen = 1, tag = "2" } },

    { rule = { instance = "qutebrowser" },
      properties = { screen = 1, tag = "3" } },

    { rule = { class = "Meld" },
      properties = { screen = 1, tag = "5" } },

    { rule = { class = "Evolution" },
      properties = { screen = 1, tag = "9" } },

    -- Set applications to be maximized at startup.
    -- { rule = { class = editorgui },
    --       properties = { maximized = true } },

    -- { rule = { class = "inkscape" },
    --       properties = { maximized = true } },

    -- { rule = { class = "Vlc" },
    --   properties = { maximized = true } },



    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Blueberry",
          "Galculator",
          "Gnome-font-viewer",
          "Gpick",
          "Imagewriter",
          "Font-manager",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Oblogout",
          "Peek",
          "Skype",
          "System-config-printer.py",
          "Sxiv",
          "Unetbootin.elf",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
          "Preferences",
          "setup",
        }
      }, properties = { floating = true }},

}

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awful.spawn.with_shell("$HOME/.config/wm-scripts/autostart.sh")
awful.spawn.with_shell("picom --config  $HOME/.config/wm-scripts/picom.conf")

-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

--https://awesomewm.org/doc/api/documentation/05-awesomerc.md.html
-- Standard awesome library
local gears = require("gears") --Utilities such as color parsing and objects
local awful = require("awful") --Everything related to window management
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
naughty.config.defaults["icon_size"] = 100
local menubar = require("menubar")
local lain = require("lain")
local freedesktop = require("freedesktop")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi = require("beautiful.xresources").apply_dpi
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Autostart windowless processes
local function run_once(cmd_arr)
	for _, cmd in ipairs(cmd_arr) do
		awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
	end
end

run_once({ "unclutter -root" }) -- entries must be comma-separated
-- }}}

-- }}}

-- {{{ Variable definitions

-- keep themes in alfabetical order for ATT
local themes = {
	"blackburn", -- 1
	"copland", -- 2
	"multicolor", -- 3
	"powerarrow", -- 4
	"powerarrow-blue", -- 5
	"powerarrow-dark", -- 6
}

-- choose your theme here
local chosen_theme = themes[4]

local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
beautiful.init(theme_path)

-- modkey or mod4 = super key
local modkey = "Mod4"
local altkey = "Mod1"
local modkey1 = "Control"

-- personal variables
local terminal = "kitty"
local browser1 = "brave"
local browser2 = "zen-browser"
local editorgui = "code"
local filemanager = "dolphin"
local mailclient = "evolution"

-- awesome variables
awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }
--awful.util.tagnames = { "⠐", "⠡", "⠲", "⠵", "⠻", "⠿" }
--awful.util.tagnames = { "⌘", "♐", "⌥", "ℵ" }
--awful.util.tagnames = { "www", "edit", "gimp", "inkscape", "music" }
-- Use this : https://fontawesome.com/cheatsheet
--awful.util.tagnames = { "", "", "", "", "" }
awful.layout.suit.tile.left.mirror = true
awful.layout.layouts = {
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.magnifier,
	awful.layout.suit.corner.nw,
	awful.layout.suit.corner.sw,
	awful.layout.suit.floating,
	--awful.layout.suit.spiral,
	--awful.layout.suit.max.fullscreen,
	--awful.layout.suit.corner.ne,
	--awful.layout.suit.corner.se,
}

awful.util.taglist_buttons = my_table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

awful.util.tasklist_buttons = my_table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			--c:emit_signal("request::activate", "tasklist", {raise = true})<Paste>

			-- Without this, the following
			-- :isvisible() makes no sense
			c.minimized = false
			if not c:isvisible() and c.first_tag then
				c.first_tag:view_only()
			end
			-- This will also un-minimize
			-- the client, if needed
			client.focus = c
			c:raise()
		end
	end),
	awful.button({}, 3, function()
		local instance = nil

		return function()
			if instance and instance.wibox.visible then
				instance:hide()
				instance = nil
			else
				instance = awful.menu.clients({ theme = { width = dpi(250) } })
			end
		end
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
-- }}}

-- {{{ Menu
local myawesomemenu = {
	{
		"hotkeys",
		function()
			return false, hotkeys_popup.show_help
		end,
	},
	{ "arandr", "arandr" },
}

awful.util.mymainmenu = freedesktop.menu.build({
	before = {
		{ "Awesome", myawesomemenu },
		--{ "Atom", "atom" },
		-- other triads can be put here
	},
	after = {
		{ "Terminal", terminal },
		{
			"Log out",
			function()
				awesome.quit()
			end,
		},
		{ "Sleep", "systemctl suspend" },
		{ "Restart", "systemctl reboot" },
		{ "Shutdown", "systemctl poweroff" },
		-- other triads can be put here
	},
})
-- hide menu when mouse leaves it
--awful.util.mymainmenu.wibox:connect_signal("mouse::leave", function() awful.util.mymainmenu:hide() end)

menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it
-- }}}

-- {{{ Screen
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
awful.screen.connect_for_each_screen(function(s)
	beautiful.at_screen_connect(s)
	s.systray = wibox.widget.systray()
	s.systray.visible = true
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(my_table.join(
	awful.button({}, 3, function()
		awful.util.mymainmenu:toggle()
	end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = my_table.join(

	awful.key({ modkey }, "Return", function()
		awful.spawn(terminal)
	end, { description = "Terminal", group = "Launcher" }),
	awful.key({ modkey }, "b", function()
		awful.spawn(browser1)
	end, { description = "Brave", group = "Launcher" }),
	awful.key({ modkey, "Shift" }, "b", function()
		awful.spawn(browser2)
	end, { description = "Librewolf", group = "Launcher" }),
	awful.key({ modkey }, "c", function()
		awful.spawn(editorgui)
	end, { description = "Code Editor", group = "Launcher" }),
	awful.key({ modkey, modkey1 }, "c", function()
		awful.spawn("killall conky")
	end, { description = "conky killall", group = "Conky" }),
	awful.key({ modkey }, "e", function()
		awful.spawn(filemanager)
	end, { description = "File Manager", group = "Launcher" }),
	awful.key({ modkey }, "m", function()
		awful.spawn(mailclient)
	end, { description = "Email Client", group = "Launcher" }),
	awful.key({ modkey }, "p", function()
		awful.spawn("rofi -theme-str 'window {width: 30%;height: 40%;}' -show drun")
	end, { description = "rofi theme selector", group = "Launcher" }),
	awful.key({ modkey }, "t", function()
		awful.spawn(terminal)
	end, { description = "terminal", group = "super" }),
	awful.key({ modkey }, "v", function()
		awful.spawn("pavucontrol")
	end, { description = "pulseaudio control", group = "Sound" }),
	awful.key({ modkey }, "Escape", function()
		awful.spawn("xkill")
	end, { description = "Kill process", group = "hotkeys" }),
	awful.key({ modkey }, "F5", function()
		awful.spawn("meld")
	end, { description = "meld", group = "Launcher" }),
	awful.key({ modkey }, "F12", function()
		awful.spawn("rofi-theme-selector")
	end, { description = "rofi", group = "Theming" }),
	awful.key({ modkey, "Shift" }, "Return", function()
		awful.util.spawn("dmenu_run -p 'Run: ' -h 22")
	end, { description = "dmenu", group = "Launcher" }),

	-- ctrl+alt +  ...
	awful.key({ modkey1, altkey }, "a", function()
		awful.util.spawn("xfce4-appfinder")
	end, { description = "Xfce appfinder", group = "alt+ctrl" }),
	awful.key({ modkey1, altkey }, "c", function()
		awful.util.spawn("catfish")
	end, { description = "catfish", group = "alt+ctrl" }),
	awful.key({ modkey1, altkey }, "o", function()
		awful.spawn.with_shell("$HOME/.config/awesome/scripts/picom-toggle.sh")
	end, { description = "Picom toggle", group = "alt+ctrl" }),
	awful.key({ modkey1, altkey }, "p", function()
		awful.util.spawn("pamac-manager")
	end, { description = "Pamac Manager", group = "alt+ctrl" }),
	awful.key({ modkey1, altkey }, "Escape", function()
		awful.util.spawn("xfce4-taskmanager")
	end, { description = "Task Manager", group = "Awesome" }),

	-- screenshots
	awful.key({}, "Print", function()
		awful.util.spawn("scrot 'ArcoLinux-%Y-%m-%d-%s_screenshot_$wx$h.jpg' -e 'mv $f $$(xdg-user-dir PICTURES)'")
	end, { description = "Scrot", group = "screenshots" }),
	awful.key({ modkey1 }, "Print", function()
		awful.util.spawn("xfce4-screenshooter")
	end, { description = "Xfce screenshot", group = "screenshots" }),

	-- Hotkeys Awesome
	awful.key({ modkey }, "u", function()
		awful.screen.focused().mypromptbox:run()
	end, { description = "run prompt", group = "Awesome" }),
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	-- Tag browsing with modkey
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),

	-- Tag browsing alt + tab
	awful.key({ altkey }, "space", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ altkey, "Shift" }, "space", awful.tag.viewprev, { description = "view previous", group = "tag" }),

	-- Default client focus
	awful.key({ altkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),
	awful.key({ altkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),

	-- By direction client focus
	awful.key({ modkey }, "j", function()
		awful.client.focus.global_bydirection("down")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus down", group = "client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.global_bydirection("up")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus up", group = "client" }),
	awful.key({ modkey }, "h", function()
		awful.client.focus.global_bydirection("left")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus left", group = "client" }),
	awful.key({ modkey }, "l", function()
		awful.client.focus.global_bydirection("right")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus right", group = "client" }),

	-- By direction client focus with arrows
	awful.key({ modkey1, modkey }, "Down", function()
		awful.client.focus.global_bydirection("down")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus down", group = "client" }),
	awful.key({ modkey1, modkey }, "Up", function()
		awful.client.focus.global_bydirection("up")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus up", group = "client" }),
	awful.key({ modkey1, modkey }, "Left", function()
		awful.client.focus.global_bydirection("left")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus left", group = "client" }),
	awful.key({ modkey1, modkey }, "Right", function()
		awful.client.focus.global_bydirection("right")
		if client.focus then
			client.focus:raise()
		end
	end, { description = "focus right", group = "client" }),

	-- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),
	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
	awful.key({ modkey1 }, "Tab", function()
		awful.client.focus.history.previous()
		if client.focus then
			client.focus:raise()
		end
	end, { description = "go back", group = "client" }),

	-- Show/Hide Systray
	awful.key({ modkey }, "-", function()
		awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
	end, { description = "Toggle systray visibility", group = "awesome" }),

	-- Standard program
	awful.key({ modkey, "Shift" }, "r", awesome.restart, { description = "reload awesome", group = "Awesome" }),
	-- awful.key({ modkey, "Shift" }, "q", function () awful.spawn( "archlinux-logout" )         end,
	--          {description = "Logout Menu", group = "Awesome"}),
	awful.key({ modkey, "Shift" }, "q", awesome.quit, { description = "quit awesome", group = "awesome" }),

	awful.key({ altkey, "Shift" }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ altkey, "Shift" }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),
	awful.key({ modkey }, "Tab", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "Tab", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),
	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			client.focus = c
			c:raise()
		end
	end, { description = "restore minimized", group = "client" }),

	-- Widgets popups
	--awful.key({ altkey, }, "c", function () lain.widget.calendar.show(7) end,
	--{description = "show calendar", group = "widgets"}),
	--awful.key({ altkey, }, "h", function () if beautiful.fs then beautiful.fs.show(7) end end,
	--{description = "show filesystem", group = "widgets"}),
	--awful.key({ altkey, }, "w", function () if beautiful.weather then beautiful.weather.show(7) end end,
	--{description = "show weather", group = "widgets"}),

	-- Brightness
	awful.key({}, "XF86MonBrightnessUp", function()
		os.execute("xbacklight -inc 10")
	end, { description = "+10%", group = "hotkeys" }),
	awful.key({}, "XF86MonBrightnessDown", function()
		os.execute("xbacklight -dec 10")
	end, { description = "-10%", group = "hotkeys" }),

	-- ALSA volume control
	--awful.key({ modkey1 }, "Up",
	awful.key({}, "XF86AudioRaiseVolume", function()
		os.execute(string.format("amixer -q set %s 5%%+", beautiful.volume.channel))
		beautiful.volume.update()
	end),
	--awful.key({ modkey1 }, "Down",
	awful.key({}, "XF86AudioLowerVolume", function()
		os.execute(string.format("amixer -q set %s 5%%-", beautiful.volume.channel))
		beautiful.volume.update()
	end),
	awful.key({}, "XF86AudioMute", function()
		os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
		beautiful.volume.update()
	end),

	--Media keys supported by vlc, spotify, audacious, xmm2, ...
	awful.key({}, "XF86AudioPlay", function()
		awful.util.spawn("playerctl play-pause", false)
	end),
	awful.key({}, "XF86AudioNext", function()
		awful.util.spawn("playerctl next", false)
	end),
	awful.key({}, "XF86AudioPrev", function()
		awful.util.spawn("playerctl previous", false)
	end),
	awful.key({}, "XF86AudioStop", function()
		awful.util.spawn("playerctl stop", false)
	end),

	-- MPD control
	awful.key({ modkey1, "Shift" }, "Up", function()
		os.execute("mpc toggle")
		beautiful.mpd.update()
	end, { description = "mpc toggle", group = "widgets" }),
	awful.key({ modkey1, "Shift" }, "Down", function()
		os.execute("mpc stop")
		beautiful.mpd.update()
	end, { description = "mpc stop", group = "widgets" }),
	awful.key({ modkey1, "Shift" }, "Left", function()
		os.execute("mpc prev")
		beautiful.mpd.update()
	end, { description = "mpc prev", group = "widgets" }),
	awful.key({ modkey1, "Shift" }, "Right", function()
		os.execute("mpc next")
		beautiful.mpd.update()
	end, { description = "mpc next", group = "widgets" }),
	awful.key({ modkey1, "Shift" }, "s", function()
		local common = { text = "MPD widget ", position = "top_middle", timeout = 2 }
		if beautiful.mpd.timer.started then
			beautiful.mpd.timer:stop()
			common.text = common.text .. lain.util.markup.bold("OFF")
		else
			beautiful.mpd.timer:start()
			common.text = common.text .. lain.util.markup.bold("ON")
		end
		naughty.notify(common)
	end, { description = "mpc on/off", group = "widgets" }),

	-- Copy primary to clipboard (terminals to gtk)
	--awful.key({ modkey }, "c", function () awful.spawn.with_shell("xsel | xsel -i -b") end,
	-- {description = "copy terminal to gtk", group = "hotkeys"}),
	--Copy clipboard to primary (gtk to terminals)
	--awful.key({ modkey }, "v", function () awful.spawn.with_shell("xsel -b | xsel") end,
	--{description = "copy gtk to terminal", group = "hotkeys"}),

	-- Default
	-- Menubar

	awful.key({ modkey, "Shift" }, "p", function()
		menubar.show()
	end, { description = "show the menubar", group = "super" })
)

clientkeys = my_table.join(
	awful.key({ modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ modkey }, "q", function(c)
		c:kill()
	end, { description = "close", group = "hotkeys" }),
	awful.key(
		{ modkey, "Shift" },
		"space",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),
	awful.key({ modkey, "Shift" }, "Left", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),
	awful.key({ modkey, "Shift" }, "Right", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),
	awful.key({ modkey, "Shift" }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "maximize", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	-- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
	local descr_view, descr_toggle, descr_move, descr_toggle_focus
	if i == 1 or i == 9 then
		descr_view = { description = "view tag #", group = "tag" }
		descr_toggle = { description = "toggle tag #", group = "tag" }
		descr_move = { description = "move focused client to tag #", group = "tag" }
		descr_toggle_focus = { description = "toggle focused client on tag #", group = "tag" }
	end
	globalkeys = my_table.join(
		globalkeys,
		-- View tag only.
		awful.key({ modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, descr_view),
		-- Toggle tag display.
		awful.key({ modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, descr_toggle),
		-- Move client to tag.
		awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, descr_move),
		-- Toggle tag on focused client.
		awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, descr_toggle_focus)
	)
end

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			size_hints_honor = false,
		},
	},

	-- Titlebars
	{ rule_any = { type = { "dialog", "normal" } }, properties = { titlebars_enabled = false } },
	-- Set applications to always map on the tag 2 on screen 1.
	--{ rule = { class = "Subl" },
	--properties = { screen = 1, tag = awful.util.tagnames[2], switchtotag = true  } },

	{
		rule = { class = "Brave-browser" },
		properties = { screen = 1, tag = awful.util.tagnames[2], switchtotag = false },
	},

	{
		rule = { class = "LibreWolf" },
		properties = { screen = 1, tag = awful.util.tagnames[3], switchtotag = false },
	},

	{
		rule = { class = "qBittorrent" },
		properties = { screen = 1, tag = awful.util.tagnames[8], switchtotag = true },
	},

	{
		rule = { class = "Evolution" },
		properties = { screen = 1, tag = awful.util.tagnames[9], switchtotag = false },
	},

	{ rule = { class = "Xfce4-settings-manager" }, properties = { floating = true } },

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
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
				"MessageWin", -- kalarm.
				"archlinux-logout",
				"Peek",
				"Skype",
				"System-config-printer.py",
				"Sxiv",
				"Unetbootin.elf",
				"Wpa_gui",
				"pinentry",
				"veromix",
				"xtightvncviewer",
				"Xfce4-terminal",
			},

			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
				"Preferences",
				"setup",
			},
		},
		properties = { floating = true },
	},

	-- Floating clients but centered in screen
	{
		rule_any = {
			class = {
				"Polkit-gnome-authentication-agent-1",
			},
		},
		properties = { floating = true },
		callback = function(c)
			awful.placement.centered(c, nil)
		end,
	},
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
	-- Custom
	if beautiful.titlebar_fun then
		beautiful.titlebar_fun(c)
		return
	end

	-- Default
	-- buttons for the titlebar
	local buttons = my_table.join(
		awful.button({}, 1, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.move(c)
		end),
		awful.button({}, 3, function()
			c:emit_signal("request::activate", "titlebar", { raise = true })
			awful.mouse.client.resize(c)
		end)
	)

	awful.titlebar(c, { size = dpi(21) }):setup({
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{ -- Middle
			{ -- Title
				align = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- Right
			awful.titlebar.widget.floatingbutton(c),
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.stickybutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	})
end)

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

-- }}}

-- Autostart applications
awful.spawn.with_shell("~/.config/awesome/autostart.sh")

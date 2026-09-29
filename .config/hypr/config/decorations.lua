-- Look and feel configuration

hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 12,
		border_size = 2,
		extend_border_grab_area = 10,
		resize_on_border = true,
		col = {
			active_border = {
				colors = { CATMPINK, CATMMAUVE },
				angle = 45,
			},
			inactive_border = CATMSURFACE0,
		},
	},
	group = {
		col = {
			border_active = CATMTEAL,
			border_inactive = CATMSURFACE1,
			border_locked_active = CATMBLUE,
			border_locked_inactive = CATMSURFACE0,
		},
		groupbar = {
			col = {
				active = CATMGREEN,
				inactive = CATMSURFACE0,
				locked_active = CATMBLUE,
				locked_inactive = CATMSURFACE0,
			},
		},
	},
	decoration = {
		dim_special = 0.3,
		rounding = 10,
		active_opacity = 0.95,
		inactive_opacity = 0.85,
		fullscreen_opacity = 1,
		blur = {
			size = 5,
			passes = 4,
			special = true,
		},
	},
})

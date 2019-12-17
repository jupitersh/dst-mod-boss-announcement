-- This information tells other players more about the mod
name = "Boss Announcement"
description = ""
author = "辣椒小皇纸"
version = "1.3.0"

all_clients_require_mod = false
client_only_mod = false
dst_compatible = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

----------------------
-- General settings --
----------------------

configuration_options =
{
	{
		name = "is_fish_announce",
		label = "Fish Announce",
		hover = "",
		options =	{
						{description = "Yes", data = true, hover = ""},
						{description = "No", data = false, hover = ""},
					},
		default = true,
	},
}
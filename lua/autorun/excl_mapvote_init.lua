-- Send this file to the client
AddCSLuaFile()

-- Create a table
EXCL_MAPVOTE = {};

-- Utility include
local function i (path)
	local side=string.Explode("/",path,false); side=string.Left(side[#side],3);
	if side == "cl_" then
		if CLIENT then
			include(path);
		elseif SERVER then
			AddCSLuaFile(path);
		end
	elseif side == "sv_" then
		if SERVER then
			include(path);
		end
	else
		if CLIENT then
			include(path);
		elseif SERVER then
			include(path);
			AddCSLuaFile(path);
		end
	end
end

-- Load configuration values first.
i "excl_mapvote/sh_config_values.lua";

-- Load client files and core last
i "excl_mapvote/cl_vgui_tile.lua";
i "excl_mapvote/cl_vgui_avatar.lua";
i "excl_mapvote/cl_net.lua";
i "excl_mapvote/cl_force.lua";
i "excl_mapvote/cl_core.lua";

-- Load server files and core last
i "excl_mapvote/sv_resources.lua";
i "excl_mapvote/sv_net.lua";
i "excl_mapvote/sv_load.lua";
i "excl_mapvote/sv_force.lua";
i "excl_mapvote/sv_core.lua";

-- Load shared files and core last
i "excl_mapvote/sh_core.lua";

-- Load compatability file at the very last.
timer.Simple(0,function()
	i "excl_mapvote/sv_compatability.lua"
end);

-- Add a message notifying the player of this system being insstalled
MsgC(Color(102,255,51),"\nThis server use the MAPVOTE system by Excl.\n");
MsgC(Color(102,255,51),"This script can be purchased from: https://scriptfodder.com/scripts/view/402\n\n");

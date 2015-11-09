-- sv_force.lua

util.AddNetworkString("MV.FORCEVOTE");
util.AddNetworkString("MV.FORCEVOTE.NOPE");
util.AddNetworkString("MV.FORCEVOTE.ALREADY");

local voters = {}
local canVote = EXCL_MAPVOTE.ForceVoteWaitTime;
local function doRTV(p)
	if not IsValid(p) then
		return
	elseif CurTime() < canVote then 
		net.Start("MV.FORCEVOTE.NOPE");
		net.WriteInt(math.ceil(canVote-CurTime()),8)
		net.Send(p);
		return
	end

	local needed = math.Round(#player.GetAll()*EXCL_MAPVOTE.PlayerPercentage);

	if not voters[p:UniqueID()] then
		voters[p:UniqueID()] = true;
		net.Start("MV.FORCEVOTE");
		net.WriteEntity(p);
		net.WriteInt(math.Clamp(needed-table.Count(voters),0,1000),8);
		net.Broadcast();
	else
		net.Start("MV.FORCEVOTE.ALREADY");
		net.WriteInt(math.Clamp(needed-table.Count(voters),0,1000),8)
		net.Send(p);
	end

	if table.Count(voters) >= needed then
		EXCL_MAPVOTE:Start()
	end
end

-- Apparently some systems use 'rtv' and 'forcemap', so we'll add those phrases as well.
hook.Add("PlayerSay","MAPVOTE.HandleForceVote",function(p,tx)
	local t = string.lower(tx);
	if t == "mapvote" or t == "!mapvote" or t == "rtv" or t == "!rtv" or t == "!forcemap" or t == "forcemap" then
		doRTV(p)
		return false;
	end
end)

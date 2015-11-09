net.Receive("EXCL_MAPVOTE.PlayerVoted",function()
	local p = net.ReadEntity();

	if not IsValid(p) then return end
	
	local map = net.ReadString();
	local x = net.ReadInt(8);

	if (x < 0 or x > 6) then
		x = nil;
	else
		x = math.Round(x);
	end

	local tile;
	for k,v in pairs(EXCL_MAPVOTE._votePanel.Tiles)do
		if string.lower(v:GetMap()) == string.lower(map) then
			tile=v;
			break;
		end
	end

	if not IsValid(tile) then return end

	tile:PlaceAvatar(p,x);
end);

net.Receive("EXCL_MAPVOTE.OpenMapvote",function()
	local tab=net.ReadTable();

	if not tab or #tab < 1 then return end
	
	EXCL_MAPVOTE:Open(tab);
	EXCL_MAPVOTE._stop = false;
end);

net.Receive("EXCL_MAPVOTE.WinnerSelected",function()
	local winner=net.ReadString();

	if not winner then 
		Error("Did not receive 'winner' string in net message.");
		return
	end

	MsgC(Color(255,255,255,255),string.format("Received count; %s won the mapvote!",winner));
	
	EXCL_MAPVOTE._stop=true;

	if not IsValid(EXCL_MAPVOTE._votePanel) then 
		if EXCL_MAPVOTE.DeveloperMode then
			print("Somehow no vote panel is open.");
		end
		return
	end
	
	for k,v in pairs(EXCL_MAPVOTE._votePanel.Tiles)do
		if IsValid(v) and v:GetMap() != winner then
		else
			v.nameTagColor = Color(0,50,0);
		end
	end

	timer.Simple(4.5,function()
			EXCL_MAPVOTE:Close();
	end);
end)
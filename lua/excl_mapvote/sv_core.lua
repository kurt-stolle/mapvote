EXCL_MAPVOTE.Votes = {}

function EXCL_MAPVOTE:Start()
	if not EXCL_MAPVOTE.MapSelection or #EXCL_MAPVOTE.MapSelection < 1 then
		Error("Not enough maps selected to load mapvote; is mapvote file setup correctly?\n");
		return;
	end

	EXCL_MAPVOTE.Votes = {}

	net.Start("EXCL_MAPVOTE.OpenMapVote");
	net.WriteTable(EXCL_MAPVOTE.MapSelection);
	net.Broadcast();

	timer.Simple(EXCL_MAPVOTE.VoteTime,function()
		EXCL_MAPVOTE:Stop();
	end);

	EXCL_MAPVOTE._busy=true;
end

function EXCL_MAPVOTE:Stop()
	if not EXCL_MAPVOTE._busy then return end
	
	EXCL_MAPVOTE._busy=false;

	local count = {};
	for k,v in pairs(EXCL_MAPVOTE.Votes)do
		count[v] = (count[v] or 0) + 1;
	end

	local most = {};
	for k,v in pairs(count)do
		local hasMore = 2;
		if most[1] then
			if most[1].count == v then
				hasMore = 1; -- equal
			elseif most[1].count > v then
				hasMore = 0; -- has more.
			end
		end

		if hasMore == 2 then
			most={{map=k,count=v}};
		elseif hasMore == 1 then
			table.insert(most,{map=k});
		end
	end

	local winner;
	if #most < 1 then
		Msg("Could not select winning map!\nPicking random map.\n");
		winner=table.Random(EXCL_MAPVOTE.MapSelection);
	else
		winner = ( table.Random(most) )["map"];
	end

	MsgC(Color(255,255,255,255),winner.." won the mapvote!\n");

	net.Start("EXCL_MAPVOTE.WinnerSelected");
	net.WriteString(winner);
	net.Broadcast();

	hook.Call("EXCL_MAPVOTE.DoFinish",GAMEMODE,winner);

	if winner==game.GetMap() then
		for k,v in pairs(EXCL_MAPVOTE.MapSelection)do
			if v == winner then
				table.remove(EXCL_MAPVOTE.MapSelection,k);
			end
		end
		EXCL_MAPVOTE.SupressChange=true;
	end

	timer.Simple(4,function()
			hook.Call("EXCL_MAPVOTE.Finish",GAMEMODE,winner);

			if not EXCL_MAPVOTE.SupressChange then
				EXCL_MAPVOTE.SupressChange = false;

				game.ConsoleCommand("changelevel "..winner.."\n");
			else
				EXCL_MAPVOTE.SupressChange = false;
			end
	end);
end
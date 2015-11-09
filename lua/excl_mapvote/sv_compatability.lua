-- Here we detect which gamemode the server is running, and then adapt to this gamemode.
-- If you are using a remake of a gamemode or an unofficial version, you should make sure your gamemode is compatable, and if not add compatabily stuff in this file.

if JB then 
	-- Gamemode is the official Jail Break, version 4+
	print("EXCL MAPVOTE: Loading JB-compat.")
	
	hook.Add("JailBreakStartMapvote","EXCL_MAPVOTE.Compat.StartVote",function(rounds,extentions)
		EXCL_MAPVOTE:Start();
		return true;
	end);

	hook.Add("EXCL_MAPVOTE.Finish","EXC_MAPVOTE.Compat.Finish",function(winner)
		if winner == game.GetMap() then
			JB:Mapvote_ExtendCurrentMap()
		end
	end);

elseif string.find(string.lower(GAMEMODE.Name),"terrorist town",1,false) then 
	-- Gamemode is the official TTT, version 2+
	print("EXCL MAPVOTE: Loading TTT-compat.")

	GAMEMODE.StartFrettaVote = function() end

	-- Easiest way is a little good old hack.
	game.LoadNextMap=function() 
		EXCL_MAPVOTE:Start()
	end

	local oldSimple = timer.Simple;
	function timer.Simple(time,func,...)
		if func == game.LoadNextMap then
			EXCL_MAPVOTE:Start();
			return;
		end
		oldSimple(time,func,...);
	end



end
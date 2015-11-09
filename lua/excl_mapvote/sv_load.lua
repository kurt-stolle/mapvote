
if EXCL_MAPVOTE.MapLoader == "fs" then
	-- Use the filesystem. We will read the maps list from a file called "excl_mapvote.txt" in the "data" folder.

	if not file.Exists("excl_mapvote.txt","DATA") then
		file.Write("excl_mapvote.txt","gm_construct\ngm_flatgrass");
	end

	local maps = file.Read("excl_mapvote.txt","DATA");
	if not maps then
		Error("File I/O error; Coudldn't open vote list.");
		return
	end

	maps=string.lower(maps);
	maps=string.gsub(maps," ","_");
	maps=string.gsub(maps,".bsp","");
	maps=string.gsub(maps,".bz2","");
	maps=string.Explode("\n",maps);

	if not maps or not maps[1] then return end

	for k,v in ipairs(maps)do
		if string.lower(v) == string.gsub(string.lower(game.GetMap())," ","_") then
			table.remove(maps,k);
			break;
		end
	end

	if ( #maps > 8 and not EXCL_MAPVOTE.AllowExtend ) or #maps > 7 then
		EXCL_MAPVOTE.MapSelection = {};
		while(#EXCL_MAPVOTE.MapSelection < 8)do
			local rnd=math.random(1,#maps);
			table.insert(EXCL_MAPVOTE.MapSelection,maps[rnd]);
			table.remove(maps,rnd);
		end
	else
		EXCL_MAPVOTE.MapSelection = maps;
	end

	if EXCL_MAPVOTE.AllowExtend then
		EXCL_MAPVOTE.MapSelection[#EXCL_MAPVOTE.MapSelection+1]=string.lower(game.GetMap());
	end

	MsgC(Color(255,255,255,0),"\nThe following maps will be voted on later this game:\n");
	for k,v in pairs(EXCL_MAPVOTE.MapSelection)do
		MsgC(Color(255,255,255,0),"\t"..k..".\t"..v);

		if file.Exists("materials/excl_mapvote/maps/"..v..".png","GAME") and not EXCL_MAPVOTE.IconsURL then
			resource.AddSingleFile ("materials/excl_mapvote/maps/"..v..".png");
		end
	end
--elseif EXCL_MAPVOTE.MapLoader == "somethingElse" then

-- Your own loader here


end

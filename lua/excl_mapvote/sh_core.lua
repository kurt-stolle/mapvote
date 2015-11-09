local typePrefixes={
	"gm_",
	"ba_",
	"jail_",
	"jb_",
	"ttt_",
	"cs_",
	"de_"
}

local parseCache={};

function EXCL_MAPVOTE.ParseMapName(str)
	if parseCache[str] then return parseCache[str] end

	for i,v in ipairs(typePrefixes)do
		str=string.gsub(str,v,"");
	end
	str=string.Trim(str);

	str=string.Explode("_",str,false);
	for k,v in pairs(str)do
		str[k]=string.upper(string.Left(v,1))..string.lower(string.Right(v,math.Clamp(string.len(v)-1,0,10000)));
	end
	str=table.concat(str," ",1);
	//str=string.upper(str);

	parseCache[str]=str;

	return str;
end
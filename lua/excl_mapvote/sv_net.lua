util.AddNetworkString "EXCL_MAPVOTE.PlayerVoted";
util.AddNetworkString "EXCL_MAPVOTE.PlayerSubmitVote";
util.AddNetworkString "EXCL_MAPVOTE.OpenMapvote";
util.AddNetworkString "EXCL_MAPVOTE.WinnerSelected";

net.Receive("EXCL_MAPVOTE.PlayerSubmitVote",function(len,p)
	if not IsValid(p) then return end
	
	local map=net.ReadString();
	map=string.lower(map);
	local x= net.ReadInt(8);
	x=math.Round(x or -1);
	if x < 0 or x > 6 then
		x=-1;
	end

	net.Start("EXCL_MAPVOTE.PlayerVoted");
	net.WriteEntity(p);
	net.WriteString(map);
	net.WriteInt(x,8);
	net.SendOmit(p);

	MsgC(Color(255,255,255,255),string.format("Received mapvote-vote from '%s' for '%s'\n",p:Nick(),map));

	EXCL_MAPVOTE.Votes[p:UniqueID()] = map;
end);
local rockers = {}
local color_white = Color(255,255,255);
local color_green = Color(102,255,51)

net.Receive("MV.FORCEVOTE",function()
	local p = net.ReadEntity();
	if not IsValid(p) then return end

	chat.AddText(color_green,p:Nick(),color_white," wants to start the mapvote, ",color_green,tostring(net.ReadInt(8)),color_white," more vote(s) needed. Type ",color_green,"\"mapvote\"",color_white," to vote.");
end)

net.Receive("MV.FORCEVOTE.NOPE",function()
	chat.AddText(color_white,"Mapvote will be enabled in ",color_green,tostring(net.ReadInt(8)),color_white," seconds. Try again later.");
end)

net.Receive("MV.FORCEVOTE.ALREADY",function()
	chat.AddText(color_white,"You have already voted. The mapvote will start after ",color_green,tostring(net.ReadInt(8))," more people vote.");
end)
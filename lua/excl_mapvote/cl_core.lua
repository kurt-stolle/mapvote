local margin=50;
surface.CreateFont("excl_mapvote.TitleFont.Shadow",{
	font="Roboto",
	size=56,
	weight=400,
	blursize=2
})
surface.CreateFont("excl_mapvote.TitleFont",{
	font="Roboto",
	size=56,
	weight=400
})

surface.CreateFont("excl_mapvote.InfoSub.Shadow",{
	font="Roboto",
	size=32,
	weight=400,
	blursize=2
})
surface.CreateFont("excl_mapvote.InfoSub",{
	font="Roboto",
	size=32,
	weight=400
})

surface.CreateFont("excl_mapvote.Info.Shadow",{
	font="Roboto",
	size=18,
	weight=400,
	blursize=2
})
surface.CreateFont("excl_mapvote.Info",{
	font="Roboto",
	size=18,
	weight=400
})

local tab =
{
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1.1,
	["$pp_colour_colour"] = .2,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

hook.Add("RenderScreenspaceEffects", "EXCL_MAPVOTE.RenderScreenspaceEffects", function()
	if IsValid(EXCL_MAPVOTE._votePanel) then DrawColorModify( tab ) end
end)

local color_white = Color(255,255,255);
local color_black = Color(0,0,0);
local color_background =Color(0,0,0,200);
local color_text = Color(200,200,200);

local function convertTimeToString(iTime)
	if iTime < 0 then
		return "0:00";
	end

	local minutes = math.floor(iTime/60);
	local seconds = tostring(math.ceil(iTime - minutes*60));

	if string.len(seconds) < 2 then
		seconds = "0"..seconds;
	end

	return tostring(minutes)..":"..seconds;
end

function EXCL_MAPVOTE:Open(maps)
	timer.Simple(0,function()

		if IsValid(EXCL_MAPVOTE._votePanel) then
			EXCL_MAPVOTE._votePanel:Remove();
		end

		local fact = table.Random(EXCL_MAPVOTE.RandomFacts);

		baseAddLower = 300;

		while(#maps > 8)do
			table.remove(maps,1);
		end 

		EXCL_MAPVOTE._votePanel = vgui.Create("EditablePanel");
		EXCL_MAPVOTE._votePanel:SetSize(ScrW(),ScrH());
		EXCL_MAPVOTE._votePanel.openTime = SysTime();

		local tiles={};
		local addTime=.6;

		local x_base, y_base = ScrW()/2-((4 * (224 + margin)) - margin)/2,ScrH()/2-((2 * (224 + margin)) - margin)/2;

		for i=0,#maps-1 do
			tiles[i]=vgui.Create("excl_mapvote.Tile",EXCL_MAPVOTE._votePanel);

			if not IsValid(tiles[i]) then ErrorNoHalt("Failed to create MapVote tile!\n") return end

			tiles[i]:SetMap(maps[i+1]);
			tiles[i]:SetPos( x_base + (i%4) * (224 + margin), y_base + (i < 4 and 0 or 224 + margin) );
			tiles[i]:Expand(addTime+CurTime());

			addTime=addTime+.05;
		end

		EXCL_MAPVOTE._votePanel.Tiles=tiles;
		EXCL_MAPVOTE._votePanel.hintAdd=0;
		EXCL_MAPVOTE._votePanel.Paint=function(self,w,h)
			Derma_DrawBackgroundBlur(self,self.openTime)

			surface.SetDrawColor(color_background);
			surface.DrawRect(0,0,w,h);

			-- Draw the title
			draw.SimpleText(EXCL_MAPVOTE.Title..(EXCL_MAPVOTE.DeveloperMode and (" ("..math.floor(1/FrameTime()).." FPS)") or ""),"excl_mapvote.TitleFont.Shadow",x_base,y_base/2 + 2,color_black,0,1);
			draw.SimpleText(EXCL_MAPVOTE.Title..(EXCL_MAPVOTE.DeveloperMode and (" ("..math.floor(1/FrameTime()).." FPS)") or ""),"excl_mapvote.TitleFont",x_base,y_base/2,color_white,0,1);

			-- Draw the time left
			local timeleft=convertTimeToString(EXCL_MAPVOTE.VoteTime - (SysTime() - self.openTime));
			draw.SimpleText(timeleft,"excl_mapvote.TitleFont.Shadow",ScrW()-x_base,y_base/2 + 2,color_black,2,1);
			draw.SimpleText(timeleft,"excl_mapvote.TitleFont",ScrW()-x_base,y_base/2 + 1,color_white,2,1);
			
			surface.SetFont("excl_mapvote.InfoSub");
			local w1,h1 = surface.GetTextSize("Did you know?");
			surface.SetFont("excl_mapvote.Info");
			local w2,h2 = surface.GetTextSize(fact);
			local hTotal = h1+h2+4;

			if fact and type(fact) == "string" then
				self.hintAdd = Lerp(FrameTime() * EXCL_MAPVOTE.EffectSpeed*.8,self.hintAdd,h/4);

				local y_base_2 = (h-y_base/2-hTotal/2) + h/4 - self.hintAdd;

					surface.SetDrawColor(Color(25,25,25));
					surface.DrawRect(x_base,y_base_2 - 16,w-x_base*2,hTotal+32);

					surface.SetDrawColor(Color(0,0,0));
					surface.DrawRect(x_base,y_base_2 - 16,1,hTotal + 32);
					surface.DrawRect(w-x_base-1,y_base_2 - 16,1,hTotal + 32);
					surface.DrawRect(x_base+1,y_base_2 - 16,w-x_base*2,1);
					surface.DrawRect(x_base+1,y_base_2 + hTotal + 16 - 1,w-x_base*2,1);

					surface.SetDrawColor(Color(255,255,255,2));
					surface.DrawRect(x_base+1,y_base_2 - 15,1,hTotal + 30);
					surface.DrawRect(w-x_base-2,y_base_2 - 15,1,hTotal + 30);
					surface.DrawRect(x_base+2,y_base_2 - 15,w-x_base*2-4,1);
					surface.DrawRect(x_base+2,y_base_2 + hTotal + 16 - 2,w-x_base*2-4,1);

					draw.SimpleText("Did you know?","excl_mapvote.InfoSub.Shadow",x_base+16,y_base_2 + 1,color_black,0,0);
					draw.SimpleText("Did you know?","excl_mapvote.InfoSub",x_base+16,y_base_2,color_white,0,0);

					draw.SimpleText(fact,"excl_mapvote.Info.Shadow",x_base+16,y_base_2 + h1 + 4 + 1,color_black,0,0);
					draw.SimpleText(fact,"excl_mapvote.Info",x_base+16,y_base_2 + h1 + 4,color_text,0,0);
			end
		end


		EXCL_MAPVOTE._votePanel:MakePopup();
	end);
end

function EXCL_MAPVOTE:Close()
	if IsValid(EXCL_MAPVOTE._votePanel) then
		EXCL_MAPVOTE._votePanel:Remove();
	end
end
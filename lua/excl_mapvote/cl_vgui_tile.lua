local matRipple = Material("excl_mapvote/ripple.png","smooth");
local randomIcons = {
	"excl_mapvote/random_1.png",
	"excl_mapvote/random_2.png",
	"excl_mapvote/random_3.png",
	"excl_mapvote/random_4.png"
} 

-- Shape generation
local shape = {}
if EXCL_MAPVOTE.IsCircular then
	math.tau = math.pi*2
	local function generatePoly(x,y,radius,quality)
	    local circle = {};
	    local tmp = 0;
		local s,c;
	    for i=1,quality do
	        tmp = (i*math.tau)/quality;
			s = math.sin(tmp);
			c = math.cos(tmp);
	        circle[i] = {x = x + c*radius,y = y + s*radius,u = (c+1)/2,v = (s+1)/2};
	    end
	    return circle;
	end
	shape=generatePoly(224/2,224/2,224/2,52);
end

-- Font
surface.CreateFont("excl_mapvote.TileNameFont.Shadow",{
	font="Roboto",
	weight=700,
	size=14,
	blursize=2
})
surface.CreateFont("excl_mapvote.TileNameFont",{
	font="Roboto",
	weight=700,
	size=14,
})
-- Panel
local PNL={};
AccessorFunc(PNL,"_map","Map",FORCE_STRING);
AccessorFunc(PNL,"_mapParsed","ParsedMapName",FORCE_STRING);
function PNL:Init()
	self.scale=0;
	self.scale2=0;

	self.rippleColor = Color(255,255,255,0);
	self.rippleScale = 1;
	self.cursorPos_x = 0;
	self.cursorPos_y = 0;

	self._icon = Material(randomIcons[math.random(1,#randomIcons)],"smooth"); -- each needs its own material
	self._expand=-1;

	self.Avatars = {};
	for x=0,6 do
		self.Avatars[x]={};
	end
	
	self.nameTagColor = Color(25,25,25,255);

	self:SetSize(224,224);
	self:NoClipping(true);

	if EXCL_MAPVOTE.IconsURL then
		self._HTML=self:Add("DHTML");
		self._HTML:SetMouseInputEnabled(false);
		self._HTML:SetSize(222,222);
		self._HTML:SetPos(1,1);
		self._HTML:SetScrollbars(false);
	end
end
function PNL:PlaceAvatar(p,xDesired)
	if not IsValid(p) then return end
	
	if IsValid(p.EXCL_MAPVOTE_AvatarTile) then
		p.EXCL_MAPVOTE_AvatarTile:FadeOut(true);
	end

	-- find a spot first
	local coords={x=-1,y=-1};

	if not xDesired or xDesired < 0 or xDesired > 6 or table.Count(self.Avatars[xDesired]) > 5 then
		local y=-1;
		while (coords.x < 0 and coords.y < 0) do
			y=y+1;
			for x=0,6 do
				if not IsValid(self.Avatars[x][y]) then
					coords.x=x;
					coords.y=y;
					break;
				end
			end
		end
	else
		coords.x = xDesired
		coords.y = table.Count(self.Avatars[xDesired]) + 1;
	end
	-- create the avatar panel
	local av=vgui.Create("excl_mapvote.Avatar",self);
	av:Setup(p);
	av.coords=coords;
	if self._hover then
		av._fadeOut = true;
	end

	-- add it to the table
	self.Avatars[coords.x][coords.y] = av;
	p.EXCL_MAPVOTE_AvatarTile = av;
end
function PNL:OnMouseReleased()
	if self._hover and not EXCL_MAPVOTE._stop then
		sound.Play("ambient/levels/canals/drip4.wav",LocalPlayer():EyePos(),75,math.random(75,120),1)

		self.queueUnfade = true;
		self._hover=false;
		for x=0,6 do
			for y=0,6 do
				if IsValid(self.Avatars[x][y]) then
					self.Avatars[x][y]:FadeIn();
				else
					break;
				end
			end
		end

		local xCursor,yCursor =self:CursorPos();

		if EXCL_MAPVOTE.UseRippleEffect then
			self.rippleScale = 0;
			self.cursorPos_x, self.cursorPos_y = xCursor,yCursor;
		end

		self:PlaceAvatar(LocalPlayer(),math.floor(xCursor/32));

		net.Start('EXCL_MAPVOTE.PlayerSubmitVote');
		net.WriteString(self:GetMap());
		net.WriteInt(math.floor(xCursor/32),8)
		net.SendToServer();
	end
end
function PNL:SetMap(str)
	self._map=str;
	self._mapParsed=EXCL_MAPVOTE.ParseMapName(str);

	if not IsValid(self._HTML) and file.Exists("materials/excl_mapvote/maps/"..str..".png","GAME") then
		self._icon=Material("excl_mapvote/maps/"..str..".png","smooth");
	elseif IsValid(self._HTML) then
		self._HTML:SetHTML([[
			<img src="]]..string.format(EXCL_MAPVOTE.IconsURL,str)..[[" style="width:100%;height:100%;position:absolute;top:0px;left:0px;"></img>
		]]);
	end


end
function PNL:Expand(time)
	self._expand=time;
end
function PNL:Think()
	-- Handle expansion
		self.scale=Lerp(FrameTime()*EXCL_MAPVOTE.EffectSpeed,self.scale, (self._expand > 0 and self._expand <= CurTime() and (self._hover and not EXCL_MAPVOTE.IsCircular and EXCL_MAPVOTE.HoverAmplification or 1)) or 0);

		if EXCL_MAPVOTE.UseInnerZoomEffect then
			self.scale2=Lerp(FrameTime()*EXCL_MAPVOTE.EffectSpeed,self.scale2, (self._expand > 0 and self._expand <= CurTime() and (self._hover and EXCL_MAPVOTE.HoverAmplification or 1)) or 0);
		end

		if self.queueUnfade and math.floor(self.scale - 0.005) == 0 then
			self.queueUnfade = false;
			for x=0,6 do
				for y=0,6 do
					if IsValid(self.Avatars[x][y]) then
						self.Avatars[x][y]:FadeIn();
					else
						break;
					end
				end
			end
		end

	-- Handle avatar positioning
	local algorythmBusy = true;
	while algorythmBusy do
		local didNothing = true;
		for x=0,6 do
			for y,avatar in pairs(self.Avatars[x]) do
				if y > 0 and IsValid(avatar) and not IsValid(self.Avatars[x][y-1]) then
					avatar.coords.y = y-1;
					self.Avatars[x][y-1] = avatar;
					self.Avatars[x][y]=nil;
					didNothing=false;
					break;
				end
			end
		end

		if didNothing then
			algorythmBusy = false;
		end
	end
end
function PNL:OnCursorEntered() 
		if EXCL_MAPVOTE._stop then return end

	self.queueUnfade = false;

	sound.Play("ambient/levels/canals/drip1.wav",LocalPlayer():EyePos(),75,255,1)

	self._hover=true; 
	for x=0,6 do
		for y=0,6 do
			if IsValid(self.Avatars[x][y]) then
				self.Avatars[x][y]:FadeOut();
			else
				break;
			end
		end
	end
end
function PNL:OnCursorExited() 
	self.queueUnfade = true;
	self._hover=false; 
end

local color_guide = Color(0,0,0,1);
local color_white = Color(213,213,213);
local color_black = Color(0,0,0);

local matrix,x,y;
local matrixTranslation=Vector(0,0,0);
local matrixScale=Vector(0,0,0);
local matrixAngles=Angle(0,0,0);
function PNL:Paint(w,h)
	if self.scale <=0 /*or self.scale2 <=0*/ then return end

	x,y=self:LocalToScreen(w/2,h/2);
	x,y=(self.scale-1)*-x,(self.scale-1)*-y;

	matrixTranslation.x,matrixTranslation.y = x,y;
	matrixScale.x,matrixScale.y = self.scale, self.scale;	
	
	matrix=Matrix();
	matrix:SetAngles(matrixAngles)
	matrix:SetTranslation( matrixTranslation )
	matrix:Scale( matrixScale )

	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )
	
	render.ClearStencil()
	render.SetStencilEnable( true )

		cam.PushModelMatrix( matrix )
			render.SetStencilFailOperation( STENCILOPERATION_KEEP )
			render.SetStencilZFailOperation( STENCILOPERATION_REPLACE )
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
			render.SetStencilReferenceValue( 1 )

				if EXCL_MAPVOTE.IsCircular then
					surface.SetDrawColor( color_guide )
					draw.NoTexture()
					surface.DrawPoly( shape )
				else
					surface.SetDrawColor( color_guide )
					surface.DrawRect(0,0,w,h);
				end
		cam.PopModelMatrix();

		if EXCL_MAPVOTE.UseInnerZoomEffect then
			x,y=self:LocalToScreen(w/2,h/2);
			x,y=(self.scale2-1)*-x,(self.scale2-1)*-y;

			matrixTranslation.x,matrixTranslation.y = x,y;
			matrixScale.x,matrixScale.y = self.scale2, self.scale2;	
			
			matrix=Matrix();
			matrix:SetAngles(matrixAngles)
			matrix:SetTranslation( matrixTranslation )
			matrix:Scale( matrixScale )

			cam.PushModelMatrix( matrix )
		end
		
		render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
		render.SetStencilPassOperation( STENCILOPERATION_REPLACE )

		surface.SetDrawColor( color_white ); 
		surface.SetMaterial(self._icon);
		surface.DrawTexturedRect(0,EXCL_MAPVOTE.IsCircular and 0 or -15,w,h);	

end
function PNL:PaintOver(w,h)
	if self.scale <=0 /*or self.scale2 <=0*/ then return end

		if not EXCL_MAPVOTE.IsCircular then
			
			surface.SetDrawColor(self.nameTagColor);
			surface.DrawRect(0,h-30,w,30);

			surface.SetDrawColor(Color(0,0,0,255));
			surface.DrawRect(1,0,w-2,1);
			--surface.DrawRect(1,h-31,w-2,1);
			surface.DrawRect(0,0,1,h-30);
			surface.DrawRect(w-1,0,1,h-30);

			surface.SetDrawColor(Color(0,0,0,255));
			surface.DrawRect(1,h-30,w-2,1);
			surface.DrawRect(1,h-1,w-2,1);
			surface.DrawRect(0,h-30,1,30);
			surface.DrawRect(w-1,h-30,1,30);

			surface.SetDrawColor(Color(255,255,255,2));
			surface.DrawRect(1,h-29,w-2,1);
			surface.DrawRect(1,h-2,w-2,1);
			surface.DrawRect(1,h-29,1,28);
			surface.DrawRect(w-2,h-29,1,28);

			draw.SimpleText(self:GetParsedMapName(),"excl_mapvote.TileNameFont.Shadow",w/2,h-(30/2)+1,color_black,1,1);
			draw.SimpleText(self:GetParsedMapName(),"excl_mapvote.TileNameFont",w/2,h-(30/2),color_white,1,1);
		end
		
		self.rippleScale = Lerp(FrameTime()*EXCL_MAPVOTE.EffectSpeed,self.rippleScale,1);

		if self.rippleScale > 0 and self.rippleScale < 1 then

			self.cursorPos_x = Lerp(FrameTime(),self.cursorPos_x,w/2);
			self.cursorPos_y = Lerp(FrameTime(),self.cursorPos_y,h/2);
			self.rippleColor.a = 150 - 150*self.rippleScale;

			surface.SetDrawColor(self.rippleColor);
			surface.SetMaterial(matRipple);
			surface.DrawTexturedRectRotated(self.cursorPos_x,self.cursorPos_y,128*self.rippleScale,128*self.rippleScale,0);

		end


		if EXCL_MAPVOTE.UseInnerZoomEffect then
			cam.PopModelMatrix();
		end

		if EXCL_MAPVOTE.IsCircular then
			draw.DrawText(self:GetParsedMapName(),"excl_mapvote.TileNameFont.Shadow",w/2,h*.6 + 1,color_black,1,1);
			draw.DrawText(self:GetParsedMapName(),"excl_mapvote.TileNameFont",w/2,h*.6,color_white,1,1);
		end

	render.SetStencilEnable( false )

	render.PopFilterMin();
	render.PopFilterMag();
end
vgui.Register("excl_mapvote.Tile",PNL,"EditablePanel");
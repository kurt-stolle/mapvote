local PNL = {}
local color_outline = Color(20,20,20,250);
function PNL:Init()
	self.coords={x=-1,y=-1};
	self.yFall = -32;
	self.alpha = 0;

	if not EXCL_MAPVOTE.DeveloperMode then
		self:SetMouseInputEnabled(false);
	end
	self:SetSize(32,32);
end
function PNL:OnMouseReleased()
	self:FadeOut(true);
end
function PNL:FadeOut(die)
	self._fadeOut=true;
	self._die = die;
end
function PNL:FadeIn()
	if self._die then return end
	
	self._fadeOut=false;
end
function PNL:Think()
	if not IsValid(self._player) or self._player.EXCL_MAPVOTE_AvatarTile != self then self:FadeOut(true) end

	-- Calculate 'gravity'
	if self.x >= 0 then
		self.yFall = Lerp(FrameTime() * EXCL_MAPVOTE.EffectSpeed*(EXCL_MAPVOTE.EffectSpeed/2),self.yFall,self:GetParent():GetTall() - (self.coords.y * self:GetTall()) - 32- 30, FrameTime() * EXCL_MAPVOTE.EffectSpeed * 100)

		self.y = math.Round(self.yFall);
	end
	-- Calculate fading

	if self._fadeOut then
		self.alpha = Lerp(FrameTime() * EXCL_MAPVOTE.EffectSpeed*EXCL_MAPVOTE.EffectSpeed,self.alpha,0);
		if self.alpha <= 1 then
			if self._die then
				self:Remove();
			else
				self.x = -100;		
			end
		end
	else
		self.alpha = Lerp(FrameTime() * EXCL_MAPVOTE.EffectSpeed*.8,self.alpha,255);

		if self.alpha > 0 then
			self.x = self.coords.x * self:GetWide();
		end
	end

	self:SetAlpha(self.alpha);
end
function PNL:Setup(p)
	self._player=p;
	self:SetPlayer( p, 32 )
end
function PNL:PaintOver(w,h)
	surface.SetDrawColor(color_outline);
	surface.DrawLine(0,0,0,h-1);
	surface.DrawLine(0,h-1,h-1,w-1);
	surface.DrawLine(w-1,h-1,w-1,0);
	surface.DrawLine(0,0,w-1,0);
end
vgui.Register("excl_mapvote.Avatar",PNL,"AvatarImage");
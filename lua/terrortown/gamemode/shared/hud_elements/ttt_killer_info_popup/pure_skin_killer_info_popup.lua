local base = "pure_skin_element"

DEFINE_BASECLASS(base)

HUDELEMENT.Base = base

if CLIENT then -- CLIENT
    local const_defaults = {
		basepos = {x = 0, y = 0},
		size = {w = 364, h = 213},
		minsize = {w = 364, h = 213}
    }
    
    function HUDELEMENT:Initialize()
		self.scale = 1.0
		self.basecolor = self:GetHUDBasecolor()

		BaseClass.Initialize(self)
    end
    
    function HUDELEMENT:GetDefaults()
		const_defaults["basepos"] = {x = math.Round(ScrW() * 0.5 - self.size.w * 0.5), y = ScrH() - (10 * self.scale + self.size.h)}

		return const_defaults
	end

	-- parameter overwrites
	function HUDELEMENT:IsResizable()
		return true, true
    end

    function HUDELEMENT:ShouldDraw()
		return GAMEMODE.round_state == ROUND_ACTIVE or GAMEMODE.round_state == ROUND_POST
	end
    -- parameter overwrites end

	function HUDELEMENT:Draw()
		local client = LocalPlayer()
		local pos = self:GetPos()
		local size = self:GetSize()
		local x, y = pos.x, pos.y
        local w, h = size.w, size.h
        
        -- draw bg
        self:DrawBg(x, y, w, h, self.basecolor)
        
        -- draw border and shadow
        self:DrawLines(x, y, w, h, self.basecolor.a)
	end
end
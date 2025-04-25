local boom = class("boom")
boom.texture = res.spritesheet
boom.size = 1
boom.lifeMax = 0.5
function boom:init(x,y)
	self.x = x
	self.y = y
	self.rot = rot
	self.anim = anim8.newAnimation(res.gBoom('1-7',1), 0.1)
	self.life = self.lifeMax
end

function boom:update(dt)
	self.anim:update(dt)
	self.life = self.life - dt
	if self.life <0 then 
		self.destroyed =true
	end
end


function boom:draw()
	self.anim:draw(self.texture,self.x,self.y,0,self.size,self.size,32,32)
end

return boom
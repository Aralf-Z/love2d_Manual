Bullet = class("bullet")
Bullet.fireCD = 0.1
Bullet.radius = 5
Bullet.speed = 20
Bullet.damage = 30

function Bullet:init(parent,rot)
	self.parent = parent 
	self.rot = self.parent.rot
	self.x = self.parent.x + math.sin(self.rot)*self.parent.w
	self.y = self.parent.y - math.cos(self.rot)*self.parent.w
	self.vx = self.speed * math.sin(self.rot)
	self.vy = -self.speed * math.cos(self.rot)
	self.tag = "bullet"
	self:initBump()
end

function Bullet:initBump()
	game.world:add(self,self.x -self.radius ,self.y-self.radius,self.radius*2,self.radius*2)
end

function Bullet:update(dt)
	self.x = self.x + self.vx
	self.y = self.y + self.vy
	
	local x,y,cols = game.world:move(
		self,self.x-self.radius,self.y-self.radius,
		function() return bump.Response_Cross end)

	for i,col in ipairs(cols) do
		local other = col.other
		local tag = other.tag
		if tag ~= "bullet" then --我们不管子弹碰撞
			if self.parent.tag ~= tag then -- 如果射出子弹的标签与目标标签不同，则击中
				other:damage(self.damage)
				self.destroyed = true
			end
		end
	end

	if self.x > 800 or self.x<0 or self.y<0 or self.y > 600 then --边界判断
		self.destroyed = true
	end
end

function Bullet:draw()
	love.graphics.setColor(255,255,0,255)
	love.graphics.circle("fill",self.x,self.y,self.radius)
end

return Bullet
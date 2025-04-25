local Enemy = class("Enemy")
Enemy.speed =3
Enemy.size = 1
Enemy.texture = res.spritesheet
Enemy.hpMax = 30
local Bullet = require (path.."object/bullet")
local Boom = require (path.."object/boom")
function Enemy:init()
	local rot = love.math.random()*2*math.pi
	self.x = math.sin(rot)*400 + 400
	self.y = -math.cos(rot)*300 + 300
	self.rot = rot+math.pi
	self.fireCD = 1
	self.fireTimer = self.fireCD
	self.anim = anim8.newAnimation(res.g64('2-4',3), 0.1)
	self.w = self.size * 32
	self.tag = "enemy"
	self.hp = self.hpMax
	self:initBump()
end

function Enemy:initBump()
	game.world:add(self,self.x - self.w/2 ,self.y -self.w/2,
		self.w,self.w)
end

function Enemy:damage(damage)
	self.hp = self.hp - damage
	if self.hp<0 then
		self.destroyed = true
		game.count = game.count + 1
		table.insert(game.others,Boom(self.x,self.y))
	end
end

function Enemy:update(dt)
	self.x = self.x + self.speed*math.sin(self.rot)
	self.y = self.y - self.speed*math.cos(self.rot)

	local x,y,col = game.world:move(
		self,self.x- self.w/2,self.y- self.w/2,
		function() return bump.Response_Cross end)


	self.fireTimer = self.fireTimer - dt --这里的开火计时器是十分常用的一种方法，需要学会

	if self.fireTimer < 0 then
		self.fireTimer = self.fireCD
		local b = Bullet(self)
		b.vx = b.vx/3
		b.vy = b.vy/3
		table.insert(game.bullets,b)
	end

	if self.x > 800 or self.x<0 or self.y<0 or self.y > 600 then --边界判断
		self.destroyed = true
	end
end

function Enemy:draw()
	love.graphics.setColor(255, 255, 255, 255)
	self.anim:draw(self.texture,self.x,self.y,self.rot,self.size,self.size,32,32)
end

return Enemy
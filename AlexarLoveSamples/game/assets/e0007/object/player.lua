local Player = class("Player")
Player.speed =3
Player.size = 1
Player.texture = res.spritesheet
Player.dr = 0.1
Player.hpMax = 100
local Bullet = require (path.."object/bullet")
local Boom = require (path.."object/boom")
function Player:init(x,y,rot)
	self.x = x
	self.y = y
	self.rot = rot
	self.fireCD = Bullet.fireCD
	self.fireTimer = self.fireCD
	self.anim = anim8.newAnimation(res.g64(1,'1-3'), 0.1)
	self.w = self.size * 32
	self.tag = "player"
	self.hp = self.hpMax
	self:initBump()
end

function Player:initBump()
	game.world:add(self,self.x - self.w/2 ,self.y -self.w/2,
		self.w,self.w)
end

function Player:damage(damage)
	self.hp = self.hp - damage
	if self.hp<0 then
		self.destroyed = true
		table.insert(game.others,Boom(self.x,self.y))
		delay:new(2,function() gamestate.switch(gameState.gameover,math.ceil(game.timer),game.count) end)
	end
end

function Player:update(dt)
	self.anim:update(dt)
	local tx,ty = love.mouse.getPosition()
	local rot = math.unitAngle(math.getRot(self.x,self.y,tx,ty)) --这里是计算方位角的一种方法。
	self.rot = math.unitAngle(self.rot)
	if rot>self.rot and math.abs(rot - self.rot)< math.pi or
		 rot<self.rot and  math.abs(rot - self.rot)> math.pi then
		self.rot = self.rot + self.dr
	else
		self.rot = self.rot - self.dr
	end
	self.fireTimer = self.fireTimer - dt --这里的开火计时器是十分常用的一种方法，需要学会

	if love.mouse.isDown(1) and self.fireTimer < 0 then
		self.fireTimer = self.fireCD
		table.insert(game.bullets,Bullet(self))
	end
	self.x = self.x + self.speed*math.sin(self.rot)
	self.y = self.y - self.speed*math.cos(self.rot)

	local x,y,col = game.world:move(
		self,self.x- self.w/2,self.y- self.w/2,
		function() return bump.Response_Cross end)
end

function Player:draw()
	love.graphics.setColor(255, 255, 255, 255)
	self.anim:draw(self.texture,self.x,self.y,self.rot,self.size,self.size,32,32)
	love.graphics.setColor(100, 255, 100, 50)
	love.graphics.rectangle("fill", self.x - 30, self. y -40 , 60, 5)
	love.graphics.setColor(100, 255, 100, 250)
	love.graphics.rectangle("fill", self.x - 30, self. y -40 , 60*self.hp/self.hpMax, 5)
	love.graphics.setColor(200, 255, 200, 250)
	love.graphics.rectangle("line", self.x - 30, self. y -40 , 60, 5)
end

return Player
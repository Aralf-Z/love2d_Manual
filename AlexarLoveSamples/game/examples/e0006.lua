-- 第六章 动画与声音

--------------------import -------------------
class = require "assets/middleclass"
anim8 = require "assets/anim8"

---------------------objects-------------------
Bullet = class("bullet")
Bullet.fireCD = 0.1
Bullet.radius = 5
Bullet.speed = 20

function Bullet:init(parent,rot)
	self.parent = parent 
	self.rot = self.parent.rot
	self.x = self.parent.x + math.sin(self.rot)*self.parent.w
	self.y = self.parent.y - math.cos(self.rot)*self.parent.w
	self.vx = self.speed * math.sin(self.rot)
	self.vy = -self.speed * math.cos(self.rot)
	self.tag = "bullet"
end

function Bullet:update(dt)
	self.x = self.x + self.vx
	self.y = self.y + self.vy
	if self.x > 800 or self.x<0 or self.y<0 or self.y > 600 then --边界判断
		self.destroyed = true
	end
end

function Bullet:draw()
	love.graphics.setColor(255,255,0,255)
	love.graphics.circle("fill",self.x,self.y,self.radius)
end

local Plane = class("plane")
Plane.speed =3
Plane.size = 1
Plane.texture = love.graphics.newImage("assets/res/1945.png")
Plane.g64 = anim8.newGrid(64,64, 1024,768,  299,101,   2)
Plane.dr = 0.1
function Plane:init(x,y,rot)
	self.x = x
	self.y = y
	self.rot = rot
	self.fireCD = Bullet.fireCD
	self.fireTimer = self.fireCD
	self.anim = anim8.newAnimation(self.g64(1,'1-3'), 0.1)
	self.w = self.size * 32
end


local function getRot(x1,y1,x2,y2)
	if x1==x2 and y1==y2 then return 0 end 
	local angle=math.atan((x2-x1)/(y2-y1))
	if y1-y2<0 then angle=angle-math.pi end
	if angle>0 then angle=angle-2*math.pi end
	return -angle
end

local function unitAngle(angle)  --convert angle to 0,2*Pi
 	angle = angle%(2*math.pi)
 	if angle > math.pi then angle = angle - 2* math.pi end
 	return angle
end

local function getLoopDist(p1,p2,loop)
	loop=loop or 2*math.pi
  	local dist=math.abs(p1-p2)
	local dist2=loop-math.abs(p1-p2)
  	if dist>dist2 then dist=dist2 end
	return dist
end


function Plane:update(dt)
	self.anim:update(dt)
	local tx,ty = love.mouse.getPosition()
	local rot = unitAngle(getRot(self.x,self.y,tx,ty)) --这里是计算方位角的一种方法。
	self.rot = unitAngle(self.rot)
	if rot>self.rot and math.abs(rot - self.rot)< math.pi or
		 rot<self.rot and  math.abs(rot - self.rot)> math.pi then
		self.rot = self.rot + self.dr
	else
		self.rot = self.rot - self.dr
	end
	self.fireTimer = self.fireTimer - dt --这里的开火计时器是十分常用的一种方法，需要学会

	if love.mouse.isDown(1) and self.fireTimer < 0 then
		self.fireTimer = self.fireCD
		table.insert(game.objects,Bullet(self))
	end
	self.x = self.x + self.speed*math.sin(self.rot)
	self.y = self.y - self.speed*math.cos(self.rot)
end

function Plane:draw()
	love.graphics.setColor(255, 255, 255, 255)
	self.anim:draw(self.texture,self.x,self.y,self.rot,self.size,self.size,32,32)
end

local Enemy = class("Enemy")
Enemy.speed =3
Enemy.size = 1
Enemy.texture = Plane.texture
Enemy.g64 = Plane.g64
function Enemy:init()
	local rot = love.math.random()*2*math.pi
	self.x = math.sin(rot)*400 + 400
	self.y = -math.cos(rot)*300 + 300
	self.rot = rot+math.pi
	self.fireCD = 0.5
	self.fireTimer = self.fireCD
	self.anim = anim8.newAnimation(self.g64('2-4',3), 0.1)
	self.w = self.size * 32
	self.tag = "enemy"
end

function Enemy:update(dt)
	self.x = self.x + self.speed*math.sin(self.rot)
	self.y = self.y - self.speed*math.cos(self.rot)

	self.fireTimer = self.fireTimer - dt --这里的开火计时器是十分常用的一种方法，需要学会

	if self.fireTimer < 0 then
		self.fireTimer = self.fireCD
		local b = Bullet(self)
		b.vx = b.vx/3
		b.vy = b.vy/3
		table.insert(game.objects,b)
	end

	if self.x > 800 or self.x<0 or self.y<0 or self.y > 600 then --边界判断
		self.destroyed = true
	end
end

function Enemy:draw()
	love.graphics.setColor(255, 255, 255, 255)
	self.anim:draw(self.texture,self.x,self.y,self.rot,self.size,self.size,32,32)
end


game = {}
function love.load()
	love.graphics.setBackgroundColor(100, 100, 200, 255)
	game.objects = {}
	game.enemies = {}
	game.plane = Plane(400,300,0)
	for i = 1, 5 do
		table.insert(game.enemies,Enemy())
	end
end

function love.update(dt)
	game.plane:update(dt)
	for i = #game.objects,1 ,-1 do
		local go = game.objects[i]
		go:update(dt)
		if go.destroyed then table.remove(game.objects,i) end
	end
	for i = #game.enemies,1 ,-1 do
		local go = game.enemies[i]
		go:update(dt)
		if go.destroyed then table.remove(game.enemies,i) end
	end
	if #game.enemies<5 then
		table.insert(game.enemies,Enemy())
	end
end

function love.draw()
	game.plane:draw()
	for i,v in ipairs(game.objects) do
		v:draw()
	end
	for i,v in ipairs(game.enemies) do
		v:draw()
	end
end
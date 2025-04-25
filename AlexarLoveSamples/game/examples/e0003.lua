-- 第三章 角度，方向以及旋转

function love.load()
	tank = {
		x = 400, --放到屏幕中心
		y = 300,
		w = 60, 
		h = 100,
		speed = 1,
		rot = 0,
		cannon = {
			w = 10,
			h = 50,
			radius = 20
		}
	}

	target = {
		x = 0,
		y = 0
	}
end

function keyControl()
	local down = love.keyboard.isDown --方便书写，而且会加快一些速度
	if down("a") then
		tank.rot = tank.rot - 0.1
	elseif down("d") then
		tank.rot = tank.rot + 0.1
	elseif down("w") then
		tank.x = tank.x + tank.speed*math.sin(tank.rot) --速度直接叠加，就不加入vx变量了
		tank.y = tank.y - tank.speed*math.cos(tank.rot)
	elseif down("s") then
		tank.x = tank.x - tank.speed*math.sin(tank.rot) --倒车
		tank.y = tank.y + tank.speed*math.cos(tank.rot)
	end
end

function getRot(x1,y1,x2,y2)
	if x1==x2 and y1==y2 then return 0 end 
	local angle= - math.atan((x2-x1)/(y2-y1))
	if y1-y2<0 then angle=angle+math.pi end
	if angle<0 then angle=angle+2*math.pi end
	return angle
end

function mouseControl()
	target.x,target.y = love.mouse.getPosition()
	local rot =  getRot(target.x,target.y,tank.x,tank.y)
	tank.cannon.rot = rot --大炮的角度为坦克与鼠标连线的角度
end

function love.update(dt)
	keyControl()
	mouseControl()
end

function love.draw()
	--车身
	love.graphics.push()
	love.graphics.translate(tank.x,tank.y)
	love.graphics.rotate(tank.rot)
	love.graphics.setColor(128,128,128)
	love.graphics.rectangle("fill",-tank.w/2,-tank.h/2,tank.w,tank.h) --以0，0为中心
	love.graphics.pop()

	--炮塔
	love.graphics.push()
	love.graphics.translate(tank.x,tank.y)
	love.graphics.rotate(tank.cannon.rot)
	love.graphics.setColor(0,255,0)
	love.graphics.circle("fill",0,0,tank.cannon.radius)
	love.graphics.setColor(0,255,255)
	love.graphics.rectangle("fill",-tank.cannon.w/2,0,tank.cannon.w,tank.cannon.h)
	love.graphics.pop()

	--激光
	love.graphics.setColor(255,0,0)
	love.graphics.line(tank.x,tank.y,target.x,target.y)
end
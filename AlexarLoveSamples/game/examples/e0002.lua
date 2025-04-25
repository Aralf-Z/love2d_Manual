-- 第二章 让画面动起来


Tween = require "assets/tween"

function love.load()
	ball = {
		x = 400, --屏幕中心
		y = 300,
		vx = 0,
		vy = 0,
		ax = 0,
		ay = 0,
		mode = "匀速",
		tween = nil, --预留给tween的，实际有没有都可以，但是这里是方便查阅的
		tx = 0, --用来存储目标位置的
		ty = 0
	}
end

function love.mousepressed(x,y,key) --关于参数，自己wiki
	ball.tx,ball.ty = x,y
	if key == 1 then
		ball.mode = "匀速"
		ball.vx = (ball.tx - ball.x)/3 --速度为3秒到达，小学数学
		ball.vy = (ball.ty - ball.y)/3
	elseif key == 2 then
		ball.mode = "加速"
		ball.vx = 0 --速度归零
		ball.vy = 0
		ball.ax = (ball.tx - ball.x)/10 --这个量。。。好吧 我没算过，自己用你的物理公式来算抵达时间吧
		ball.ay = (ball.ty - ball.y)/10
	else --key==3
		ball.mode = "变速"
		ball.tween = Tween.new(3,ball,{x = ball.tx,y = ball.ty},"outElastic")
	end
end

function love.update(dt)
	if ball.mode == "匀速" then
		ball.x = ball.x + ball.vx * dt 
		ball.y = ball.y + ball.vy * dt
	elseif ball.mode == "加速" then
		ball.vx = ball.vx + ball.ax * dt
		ball.vy = ball.vy + ball.ay * dt
		ball.x = ball.x + ball.vx * dt 
		ball.y = ball.y + ball.vy * dt
	else
		ball.tween:update(dt)
	end
end

function love.draw()
	love.graphics.setColor(255,55,55,155)
	love.graphics.circle("fill",ball.x,ball.y,30)
	love.graphics.setColor(255,155,155,255)
	love.graphics.circle("line",ball.x,ball.y,30)
end
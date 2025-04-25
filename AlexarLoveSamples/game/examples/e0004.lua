-- 第四章 碰撞

function love.load()
	board = {
		x = 0, --为了方便，我们把球桌就定为窗体了。
		y = 0,
		w = 800,
		h = 600
	}

	ball = {
		x = 400,
		y = 300,
		r = 20, --画面为20的圆，但是物理世界是40*40的矩形
		
		l = -20,
		t = -20,
		r = 20,
		b = 20,
	
		vx = -2,
		vy = 0
	}

	leftPad = {
		x = 100,
		y = 300,
		w = 30,
		h = 150,
		
		l = -15,
		t = -75,
		r = 15,
		b = 75,
		
	}

	rightPad = {
		x = 700,
		y = 300,
		w = 30,
		h = 150,
		
		l = -15,
		t = -75,
		r = 15,
		b = 75,
		
	}
end

function keyTest()
	local down = love.keyboard.isDown
	if down("w") then
		leftPad.y = leftPad.y - 1
		leftPad.vy = -1
		if leftPad.y - leftPad.h/2 < board.y then --边界
			leftPad.y = leftPad.h
		end
	elseif down("s") then
		leftPad.y = leftPad.y + 1
		leftPad.vy = 1
		if leftPad.y + leftPad.h/2 > board.y + board.h then
			leftPad.y = board.h + board.y - leftPad.h/2
		end
	else
		leftPad.vy = 0
	end


	if down("up") then
		rightPad.y = rightPad.y - 1
		rightPad.vy = -1
		if rightPad.y - rightPad.h/2 < board.y then --边界
			rightPad.y = rightPad.h
		end
	elseif down("down") then
		rightPad.y = rightPad.y + 1
		rightPad.vy = 1
		if rightPad.y + rightPad.h/2 > board.y + board.h then
			rightPad.y = board.h + board.y - rightPad.h/2
		end
	else
		rightPad.vy = 0
	end
end

function ballMove()
	ball.x = ball.x + ball.vx
	ball.y = ball.y + ball.vy
	if ball.x-ball.r < board.x then
		ball.x = ball.r + board.x
		ball.vx = - ball.vx
	elseif ball.x + ball.r > board.w + board.x then
		ball.x = board.x + board.w - ball.r
		ball.vx = - ball.vx
	end

	if ball.y-ball.r < board.y then
		ball.y = ball.r + board.y
		ball.vy = - ball.vy
	elseif ball.y + ball.r > board.h + board.y then
		ball.y = board.y + board.h - ball.r
		ball.vy = - ball.vy
	end
end


function pointTest(x,y,l,t,r,b)
	if x< l or x> r or y< t or y>b then return end
	return true
end

function bodyTest(Al,At,Ar,Ab,Bl,Bt,Br,Bb)
	if pointTest(Al,At,Bl,Bt,Br,Bb) 
		or pointTest(Ar,At,Bl,Bt,Br,Bb) 
		or pointTest(Al,Ab,Bl,Bt,Br,Bb) 
		or pointTest(Ar,Ab,Bl,Bt,Br,Bb)  then
		return true
	end
end


function leftCollTest()
	local al, at, ar, ab = 
		ball.x + ball.l, ball.y + ball.t, ball.x + ball.r, ball.y + ball.b
	local bl, bt, br, bb = 
		leftPad.x - leftPad.w/2,
		leftPad.y - leftPad.h/2,
		leftPad.x + leftPad.w/2,
		leftPad.y + leftPad.h/2
	local coll = bodyTest(al, at, ar, ab,bl, bt, br, bb)
	if coll then
		ball.vx = -ball.vx
		ball.vy = ball.vy + leftPad.vy/2
	end
end


function rightCollTest()
	local al, at, ar, ab = 
		ball.x + ball.l, ball.y + ball.t, ball.x + ball.r, ball.y + ball.b
	local bl, bt, br, bb = 
		rightPad.x - rightPad.w/2,
		rightPad.y - rightPad.h/2,
		rightPad.x + rightPad.w/2,
		rightPad.y + rightPad.h/2
	local coll = bodyTest(al, at, ar, ab,bl, bt, br, bb)
	if coll then
		ball.vx = -ball.vx
		ball.vy = ball.vy + rightPad.vy/2
	end
end

function love.update()
	leftCollTest()
	rightCollTest()
	keyTest()
	ballMove()
end

function love.draw()
	love.graphics.setColor(55, 50, 50, 250)
	love.graphics.rectangle("fill", board.x, board.y , board.w, board.h)
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.circle("fill", ball.x, ball.y, ball.r)
	love.graphics.setColor(0, 255, 0, 255)
	love.graphics.rectangle("fill", leftPad.x - leftPad.w/2, leftPad.y - leftPad.h/2, leftPad.w, leftPad.h)
	love.graphics.rectangle("fill", rightPad.x - rightPad.w/2, rightPad.y - rightPad.h/2, rightPad.w, rightPad.h)
end


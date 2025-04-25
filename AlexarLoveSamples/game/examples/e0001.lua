-- 第一章 游戏的基本元素
function love.load()
	test = {
		x = 400,
		y = 300,
	    image = love.graphics.newImage("images/love-ball.png"),
	    text = "hello lovers!"
	}
end

function love.update(dt)
	if love.keyboard.isDown("w") then
		test.y = test.y - 1
	elseif love.keyboard.isDown("s") then
		test.y = test.y + 1
	end
end

function love.draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(test.image,test.x,test.y,0,1,1,32,32)
	--love.graphics.draw(test.image,test.x - 32,test.y - 32)
	love.graphics.setColor(255, 0, 0, 255)
	love.graphics.circle("line", test.x, test.y, 100)
	love.graphics.setColor(0, 255, 255, 50)
	love.graphics.rectangle("fill", test.x - 100, test.y - 100, 200, 200)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(test.text, test.x-100, test.y+100)
end

function love.keyreleased(key)
	if key == "a" then
		test.x = test.x - 100
	elseif key == "d" then
		test.x = test.x + 100
	end
end

function love.mousereleased(key)
	test.x = love.math.random(1,800)
	test.y = love.math.random(1,600)
end
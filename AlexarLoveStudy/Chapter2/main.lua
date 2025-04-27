Tween = require("tween")--和教程的tween似乎不一样

local screenWidth = 800
local screenHeight = 600
local ball

function love.load()
	ball = {
        radius = 25,
        posX = screenWidth/2,
        posY = screenHeight/2,
        mode = "None",
        v = 200,
        a = 50,
    }
end

function love.update(dt)
    if "None" == ball.mode then
        ball.posX = screenWidth/2
        ball.posY = screenHeight/2
    elseif "constant" == ball.mode then
        ball.posX = ball.posX - dt * ball.v
    elseif "acceleration" == ball.mode then
        ball.v = ball.v + ball.a * dt
        ball.posX = ball.posX + dt * ball.v
    elseif "tween" == ball.mode then
    end

    if ball.posX < 0 then
        ball.posX = screenWidth
    elseif ball.posX > screenWidth then
        ball.posX = 0
    end

    if "acceleration" ~= ball.mode then
        ball.v = 200
    end
end

function love.keypressed(key)
    if "space" == key then
        ball.mode = "None"
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if 1 == button then --left
        ball.mode = "constant"
    elseif 2 == button then --right
        ball.mode = "acceleration"
    elseif 3 == button then --middle
        ball.mode = "tween"
    end
end

function love.draw()
   love.graphics.circle("fill", ball.posX, ball.posY, ball.radius)
end
local screenWidth = 800
local screenHeight = 600
local circle

function love.load()
    circle = {
        img = love.graphics.newImage("assets/love-ball.png"),
        posX = screenWidth/2,
        posY = screenHeight/2,
    }
end

function love.update(dt)
    if love.keyboard.isDown("w") then
        circle.posY = circle.posY - 1
    elseif love.keyboard.isDown("s") then
        circle.posY = circle.posY + 1
    end

    if love.keyboard.isDown("w") then
        circle.posY = circle.posY - 1
    elseif love.keyboard.isDown("s") then
        circle.posY = circle.posY + 1
    end

    if circle.posY > screenHeight then
        circle.posY = 0
    elseif circle.posY < 0 then
        circle.posY = screenHeight
    end
end

function love.keypressed(key)
    if "a" == key then
        circle.posX = circle.posX - 100
    elseif "d" == key then
        circle.posX = circle.posX + 100
    end

    if circle.posX > screenWidth then
        circle.posX = 0
    elseif circle.posX < 0 then
        circle.posX = screenWidth
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    circle.posX = x
    circle.posY = y
end

function love.draw()
    love.graphics.draw(circle.img, circle.posX, circle.posY, 0, 1, 1, 32, 32)
end
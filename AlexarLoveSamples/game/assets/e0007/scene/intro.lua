local scene = gamestate.new()
local font = love.graphics.setNewFont(32)
love.graphics.setFont(font)
local text = "last survivor 1945"
local text2 = "press any key to start"
local quad = love.graphics.newQuad(104, 577, 270, 136, 1024, 768)

function scene:enter()

end


function scene:draw()
	love.graphics.draw(res.spritesheet,quad, 400, 300, 0, 3, 3, 135, 68)
	love.graphics.printf(text, 0, 200, 800, "center")
	love.graphics.printf(text2, 0, 400, 800, "center")
end


function scene:keypressed()
	gamestate.switch(gameState.game)
end
return scene
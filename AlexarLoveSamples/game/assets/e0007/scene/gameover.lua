local scene = gamestate.new()
local font = love.graphics.setNewFont(32)
love.graphics.setFont(font)


local quad = love.graphics.newQuad(104, 577, 270, 136, 1024, 768)
local text 
local text2
local text3 = "press esc to quit \n press enter to restart"
function scene:enter(from,s,count)
	text = "You survived "..s.." scondes"
	text2 = "You killed "..count.." enimies"
end

function scene:keypressed(key)
	if key == "return" then
		gamestate.switch(gameState.game)
	end
end

function scene:draw()
	love.graphics.setColor(255, 100, 100, 255)
	love.graphics.draw(res.spritesheet,quad, 400, 300, 0, 3, 3, 135, 68)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf(text, 0, 200, 800, "center")
	love.graphics.printf(text2, 0, 300, 800, "center")
	love.graphics.printf(text3, 0, 400, 800, "center")
end


return scene
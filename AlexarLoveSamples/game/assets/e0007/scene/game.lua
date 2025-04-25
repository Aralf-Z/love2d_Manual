local scene = gamestate.new()
local Player = require (path .. "object/player")
local Enemy = require (path .. "object/enemy")

function scene:enter()
	game = {}
	love.graphics.setBackgroundColor(100, 100, 200, 255)
	game.world = bump.newWorld(64)
	game.bullets = {}
	game.planes = {}
	game.others = {}
	game.timer = 0
	game.count = 0
	game.planes[1] = Player(400,300,0)
	for i = 1, 5 do
		table.insert(game.planes,Enemy())
	end
end

function scene:leave()

end

function scene:update(dt)
	game.timer = game.timer + dt
	for i = #game.bullets,1 ,-1 do
		local go = game.bullets[i]
		go:update(dt)
		if go.destroyed then 
			game.world:remove(go)
			table.remove(game.bullets,i) 
		end
	end
	for i = #game.planes,1 ,-1 do
		local go = game.planes[i]
		go:update(dt)
		if go.destroyed then
			game.world:remove(go)
			table.remove(game.planes,i) 
		end
	end
	for i = #game.others,1 ,-1 do
		local go = game.others[i]
		go:update(dt)
		if go.destroyed then
			table.remove(game.others,i) 
		end
	end
	if #game.planes<6 then
		table.insert(game.planes,Enemy())
	end
end

function scene:draw()
	for i,v in ipairs(game.bullets) do
		v:draw()
	end
	for i,v in ipairs(game.planes) do
		v:draw()
	end
	for i,v in ipairs(game.others) do
		v:draw()
	end
end


return scene
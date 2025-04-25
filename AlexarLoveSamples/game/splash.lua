-- love splash screen
flux = require'assets/flux'
local timer = 0
function love.load()
	local delay = 1.5
	font = {love = love.graphics.newFont('assets/res/fonts/handy-andy.otf', math.floor(9*3.5*(love.graphics.getWidth()/800)))}
	shader = {black2white = love.graphics.newShader([[
	  vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords) {
	    if(Texel(texture,texture_coords).a > 0.){
	      //return vec4(vec3(1.),Texel(texture,texture_coords).a);
	      return vec4(1);
	    }
	    return vec4(0.);
	  }
	]])}
	local pinkRectangle = love.graphics.newCanvas(math.sqrt(love.graphics.getWidth()^2+(love.graphics.getHeight())^2),math.sqrt((love.graphics.getWidth()/2)^2+(love.graphics.getHeight()/2)^2))
	love.graphics.setCanvas(pinkRectangle)
		love.graphics.rectangle('fill', 0, 0, pinkRectangle:getWidth(), pinkRectangle:getHeight())
	love.graphics.setCanvas()
	splash = {
		blue = {
			pos = {0,0},
			dim = {0,love.graphics.getHeight()},
			--rotation = 0,
			--offset = {0,0},
			color = {39,170,225}
	 	},
		pink = {
			pos = {0,love.graphics.getHeight()/2},
			--dim = {math.sqrt(love.graphics.getWidth()^2+(love.graphics.getHeight()/2)^2),love.graphics.getHeight()},
			rotation = math.pi/2,
			offset = {pinkRectangle:getWidth()/2,0},
			color = {231,74,153}
		},
		heart = {
			scale = 0
		},
		timer = {
			tigger = 0
		}
	}
	splash.pinkRectangle = pinkRectangle
	local angle = math.atan2(-love.graphics.getHeight(),love.graphics.getWidth())
	flux.to(splash.blue.dim,1,{love.graphics.getWidth()}):ease('expoout'):delay(delay)
	flux.to(splash.pink.pos,0.5,{love.graphics.getWidth()/2}):delay(delay+0.4):ease('backinout'):oncomplete(function() flux.to(splash.heart,1,{scale = 1}):ease('elasticout'):delay(1.2) end):after(splash.pink,6.2,{rotation=-(math.pi+2*math.pi-angle)}):ease('quintout')
	local dpis = love.window.getPixelScale()
	if dpis <= 1.0 then
	 	--mdpi
	 	splash.heart.image = love.graphics.newImage('assets/res/drawable-mdpi/heart.png')
	 	splash.logo = love.graphics.newImage('assets/res/drawable-mdpi/love_logo.png')
	 	local canvas = love.graphics.newCanvas(splash.logo:getWidth(),splash.logo:getHeight())
	 	love.graphics.setCanvas(canvas)	 	  love.graphics.setShader(shader.black2white)	 	  love.graphics.draw(splash.logo)	 	  love.graphics.setShader()
	 	love.graphics.setCanvas()
	 	splash.logo = canvas	
	 	print('is mdpi display')
	elseif dpis <= 1.5 then
	 	--hdpi
	 	splash.heart.image = love.graphics.newImage('assets/res/drawable-hdpi/heart.png')
	 	splash.logo = love.graphics.newImage('assets/res/drawable-hdpi/love_logo.png')
	 	local canvas = love.graphics.newCanvas(splash.logo:getWidth(),splash.logo:getHeight())
	 	love.graphics.setCanvas(canvas)
	 	 love.graphics.setShader(shader.black2white)
	 	 love.graphics.draw(splash.logo)
	 	 love.graphics.setShader()
	 	love.graphics.setCanvas()
	 	splash.logo = canvas	
	 	print('is hdpi display')
	elseif dpis <= 2.0 then
	 	--xhdpi
	 	splash.heart.image = love.graphics.newImage('assets/res/drawable-xhdpi/heart.png')
	 	splash.logo = love.graphics.newImage('assets/res/drawable-xhdpi/love_logo.png')
	 	local canvas = love.graphics.newCanvas(splash.logo:getWidth(),splash.logo:getHeight())
	 	love.graphics.setCanvas(canvas)
	 		love.graphics.setShader(shader.black2white)
	 		love.graphics.draw(splash.logo)
	 		love.graphics.setShader()
	 	love.graphics.setCanvas()
	 	splash.logo = canvas	
	 	print('is xhdpi display')
	elseif dpis <= 3.0 then
	 	--xxhdpi
	 	splash.heart.image = love.graphics.newImage('assets/res/drawable-xxhdpi/heart.png')
	 	splash.logo = love.graphics.newImage('assets/res/drawable-xxhdpi/love_logo.png')
	 	local canvas = love.graphics.newCanvas(splash.logo:getWidth(),splash.logo:getHeight())
	 	love.graphics.setCanvas(canvas)
	 		love.graphics.setShader(shader.black2white)
	 		love.graphics.draw(splash.logo)
	 		love.graphics.setShader()
	 	love.graphics.setCanvas()
	 	splash.logo = canvas	
	 	print('is xxhdpi display')
	elseif dpis <= 4.0 then
		--xxxhdpi
		splash.heart.image = love.graphics.newImage('assets/res/drawable-xxxhdpi/heart.png')
		splash.logo = love.graphics.newImage('assets/res/drawable-xxxhdpi/love_logo.png')
		local canvas = love.graphics.newCanvas(splash.logo:getWidth(),splash.logo:getHeight())
		love.graphics.setCanvas(canvas)
			love.graphics.setShader(shader.black2white)
			love.graphics.draw(splash.logo)
			love.graphics.setShader()
		love.graphics.setCanvas()
		splash.logo = canvas

		--print('is xxxhdpi display')
	end
end

function love.update(dt)
	flux.update(dt)
	timer = timer - dt
	if timer<0 then 
		require "system"
		love.load()
	end
end

function love.draw()
	--love.window.setTitle(love.timer.getFPS())
	love.graphics.setColor(splash.blue.color)
	love.graphics.rectangle('fill', splash.blue.pos[1], splash.blue.pos[2], splash.blue.dim[1], splash.blue.dim[2])
	love.graphics.setColor(splash.pink.color)
	love.graphics.draw(splash.pinkRectangle, splash.pink.pos[1], splash.pink.pos[2], splash.pink.rotation, 1, 1, splash.pink.offset[1], splash.pink.offset[2])
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(splash.heart.image,love.graphics.getWidth()/2,love.graphics.getHeight()/2,0,splash.heart.scale,splash.heart.scale,splash.heart.image:getWidth()/2,splash.heart.image:getHeight()/2)

	love.graphics.setFont(font.love)
	love.graphics.setScissor(splash.blue.pos[1], splash.blue.pos[2], splash.blue.dim[1], splash.blue.dim[2])
	love.graphics.print('Made with', love.graphics.getWidth()/2, (love.graphics.getHeight()+splash.heart.image:getWidth()*splash.heart.scale)/2-20*(love.graphics.getWidth()/800), 0, 1, 1, font.love:getWidth('Made with'), 0)
	love.graphics.draw(splash.logo,love.graphics.getWidth()/2, (love.graphics.getHeight()+splash.heart.image:getWidth()*splash.heart.scale)/2+font.love:getHeight()-20*(love.graphics.getWidth()/800),0,0.4,0.4,(splash.logo:getWidth()*0.4)/2)
	love.graphics.setScissor()
	if timer<3 then
		love.graphics.setColor(0, 0, 0, 255-timer*85)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	end
end

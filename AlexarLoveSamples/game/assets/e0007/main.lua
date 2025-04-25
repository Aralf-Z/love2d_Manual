path = string.sub(...,1,-5)
__TESTING = true
bump=require (path.."lib/bump")
class=require (path.."lib/middleclass")
gamestate= require (path.."lib/gamestate")
delay= require (path.."lib/delay")
anim8 = require (path.."lib/anim8")
game = {} --sandbox
require (path.."lib/util")
require (path.."misc/resloader")
function love.load()
    gameState={}
    for _,name in ipairs(love.filesystem.getDirectoryItems(path.."scene")) do
        gameState[name:sub(1,-5)]=require(path.."scene."..name:sub(1,-5))
    end
    gamestate.registerEvents()
    gamestate.switch(gameState.intro)
end

function love.update(dt) delay:update(dt) end
-- 案例： 贪吃蛇

--[[
贪吃蛇是一个很好的游戏教学项目，其原因在于：
•	基本的实物抽象思想
•	基本的键盘按下回调
•	基本的图形显示
•	基本的网格概念
•	基本的表数据更新
•	几乎无限的可拓展
 
思路：
我们先整理下贪吃蛇游戏的组成和游戏规则，然后我们初步抽象成逻辑关系，然后进一步抽象为伪代码，最后按照lua的语法形成执行代码。至于后续的美工，优化不作为本节重点。
 
贪吃蛇是一个方块阵列游戏。游戏内容包括地图，边界，蛇，食物。规则包括蛇每次蛇按某方向移动一次，如果吃到食物则蛇长增长一格，如果碰壁或自己则游戏结束。 
我们来分别分析一下。
 
地图 是由固定数量的方块构成的矩阵组成，每个方块有两种状态，黑和白。因此，考虑建立一个二维数组来存储每个方块的状态，同时，方块的阵列位置和显示位置也构成简单的函数关系。可以让周围一圈为黑作为墙。
 
蛇是一组连续的方块，从蛇的特性，类似火车，每次往前走，蛇头向控制方向移动一格，蛇头的后一节成为蛇头的位置，以此类推。那么，我们想到了，蛇的本质是一个存储着矩阵位置的数组，蛇头是第一个元素，而其他蛇节构成后面的，每个元素存储着（x，y），蛇头是有一个方向来控制，可能是上下左右中的一个，上的概念在矩阵里实际上是（0,-1），其他方向类推。在每次移动时，蛇头按方向变更其位置，而蛇节则继承其前一节的位置。而在地图上所有蛇的位置为黑。
 
食物，实际上就是矩阵中的一个方块。当蛇吃到食物，也就是蛇头的位置与食物相同时，蛇节的所代表的数组总长度加1，里面存储蛇尾的位置。食物在地图上为黑。
 
碰撞判断，如何判断蛇碰壁或碰自己呢？很简单，只要判断地图是否为黑就行了！哦，别忘了食物也是黑的，所以如果蛇头下一个位置如果为黑，那么不是碰壁就是吃到食物了，食物数量很少，分别判断就行了。
 
游戏速度，显示帧率为60hz，我们的蛇每秒仅需走几次，根据游戏速度不同，那么我们需要差速更新逻辑。
 
输入输出，输入我们仅仅需要上下左右就行了，我们通过输入来改变蛇的方向，但是蛇不能够向回转哦！输出我们暂时只用最基本的画矩阵的两个状态，白色就是线框方形，黑色就是填充方形。
 
核心循环，上面是所有我们已经有的信息，现在让我们把它们串起来来完成我们的核心。首先，我们要读取按键信息来改变蛇的方向，然后我们的蛇按照方向移动，移动后就肯定有我们的碰撞判断。碰撞判断告诉我们蛇是普通，吃食物还是挂了，然后继续我们的循环。如果吃了食物就要在空位置再生成一个，挂了就要弹出gameover！了。
 
好像我们已经把贪吃蛇的轮廓刻画出来了，我们来用流程图和伪代码来实战演习一下！
 
初始化
定义地图为二维数组，每个位置初始为假
定义蛇为一个数组，初始为长度为5的蛇，放在矩阵中间。
 
循环
读取输入改变方向
蛇按方向移动
碰撞判断～否，正常移动:是，如果是食物则增长；否则游戏结束。
 
绘图
画矩阵
 
好啦，程序架构已经完成啦，接下来我们用lua代码把上面的流程翻译一下，就是我们的贪吃蛇啦。
注意，我们这里的代码并不是最简单和优化最好的，但是相比来讲更加适合理解。
 
首先，我们把地图矩阵做出来，同时为了有可视化效果，我们再把绘图做出来。
local function setupMap()
for x=1,15 do
map[x]={} --定义二维数组的时候必须在遍历第一维的时候把第二维定义出来
for y=1,15 do
if x==1 or x==15 or y==1 or y==15 then 这样我们的四周就被圈起来了，而中间是空的
map[x][y]=true 
else
map[x][y]=false
end
end
End
 
end
 
local function drawMap()
love.graphics.setColor(255,255,255)
    for x=1,15 do
for y=1,15 do
local how=map[x][y] and "fill" or "line" --一个常用的三联表达式
love.graphics.rectangle(how, x*32+200, y*32, 30, 30, 5, 5)
end
end
End
 
local function check(x,y) --增加一个方法，这个就是检验某点位置是否被占的
return map[x][y]
end
 
 
然后，我们定义一条蛇，放在屏幕中间。暂时它还是条死蛇^_^。
local snake
local function setupSnake()
snake={}
for i=1,5 do
snake[i]={x=i+5,y=7} --蛇的本质就是一个数组，每一节存储位置x=?,y=?
end
end
 
local function drawSnake(toggle) --这里toggle=true则绘制，toggle=false则擦除
for i,v in ipairs(snake) do
map[v.x][v.y]=toggle
end
end
 
 
然后我们让蛇动起来，我们暂时还无法控制蛇的方向。
local dir={x=0,y=1} --定义蛇的方向
local function updateSnake()
drawSnake(false) --更新之前，先把上一帧的蛇擦除，实际上只擦除蛇尾就行
for i=#snake,2,-1 do --先更新后面的蛇节，再更新蛇头，不然第二节以及后面所有的跟第一节位置相同了
snake[i].x=snake[i-1].x
snake[i].y=snake[i-1].y
end
snake[1].x=snake[1].x+dir.x
snake[1].y=snake[1].y+dir.y
drawSnake(true)
End
 
 
这里 我们要插入一个差速更新的方法，使每隔固定时间长度，蛇更新一次。
local updateCD=0.5
local timer=0.5
function love.update(dt) --一旦cd小于0就更新，然后计时器重新回到cd的位置
timer=timer-dt 
if timer<0 then
timer=updateCD
updateSnake()
end
end
 
想要控制方向我们需要读取按键或者按下回调。注意，蛇不能后退哦！
我们之所以用一个dir来控制方向是因为，蛇的方向更新的响应并不是立即的，也就是并不是按下左蛇就要直接向左移动一格，而是在蛇差速更新时，才会按方向移动，因此需要用一个变量来保存这个方向。
 
local function input()
if love.keyboard.isDown("up") then
if lastDir.y==0 then --之所以加入这个判断是因为 只有在蛇左右移动的时候 改变到上下才有意义 同时也避免了让蛇后退。用上一帧的方向是因为避免在一帧内多次输入导致的错误。如果用当前方向dir,那么如果蛇的方向为right在一帧内快速按下up 和left就可以 ,就可以让蛇倒退了。
dir.x,dir.y=0,-1
end
elseif love.keyboard.isDown("down") then
if lastDir.y==0 then
dir.x,dir.y=0,1
end
elseif love.keyboard.isDown("left") then
if lastDir.x==0 then
dir.x,dir.y=-1,0
end
elseif love.keyboard.isDown("right") then
if lastDir.x==0 then
dir.x,dir.y=1,0
end
end
end
 
 
现在我们的蛇可以移动了，动的多了蛇就饿了，得吃东西，随机生成一个食物，注意不能在已占的位置生成。
 
local function newFood()
repeat 
food.x= love.math.random(2,14) --不能在框上画食物哦
food.y= love.math.random(2,14)
until not check(food.x,food.y) --直到食物位置是个空位，实际上这是个不严谨的写法。更加好的做法是把可以用的位置做一个表，然后随机选取一个来作为食物的位置。
map[food.x][food.y]=true
end
 
 
吃到食物那么长度加1。游戏速度增加一些。
Local function eat()
table.insert(snake, {x=snake[1].x,y=snake[1].y}) --实际上 增加一节的位置可以是蛇上的任意点，因为下一帧会跳到上一次倒数第二的位置。
updateCD=updateCD*0.9 --cd速度打九折
newFood() --生成一个新的食物
end
 
 
接下来是碰撞判断，我们看地图蛇头位置是否被占。
 
local targetX,targetY=snake[1].x+dir.x,snake[1].y+dir.y --实际上检验的位置是移动后的蛇头
if check(targetX,targetY) then
if targetX==food.x and targetY==food.y then --如果位置是食物就吃了它，并生成新的食物
eat()
else --如果位置是墙就gameover了，这里注意有个return 因为游戏结束了，后面不需要再更新了。
gameover()
return
end
end
 
 
最后，我们gameover画面啦。
 
local function gameover()
local title = "Game Over"
local message = "Your Score is "..tostring(#snake-5)
local buttons = {"Restart!", "Quit!", escapebutton = 2}
 
local pressedbutton = love.window.showMessageBox(title, message, buttons) --这个是个出对话框的命令，这个命令有自己的循环，当对话框存在时，游戏窗体的update是暂停的。
if pressedbutton == 1 then
           setupMap()
setupSnake()
drawSnake(true)
newFood()
timer=0.5
elseif pressedbutton == 2 then
    love.event.quit()
end
end
 
 
我们把所有代码整合起来，如下
这里要注意的是，由于lua的代码机制，在lua代码运行时之前，是有一个预编译过程的，所有的内部定义函数或者变量在运行前是固定的。因此，在存在函数嵌套引用的时候，千万要把被嵌套的写在前面，如果写在后面，在调用前面的时候会显示未定义。
 
-- Example: Snake
 
-------------------------------------------init--------------------------------
local updateCD=0.5
local timer=0.5
local dir={x=0,y=1}
local lastDir={x=0,y=0}
local map={}
local food={x=0,y=0}
 
------------------------for map---------------------------
local function setupMap()
map={}
for x=1,15 do
map[x]={}
for y=1,15 do
if x==1 or x==15 or y==1 or y==15 then
map[x][y]=true 
else
map[x][y]=false
end
end
end 
end
 
local function drawMap()
love.graphics.setColor(255,255,255)
    for x=1,15 do
for y=1,15 do
local how=map[x][y] and "fill" or "line"
love.graphics.rectangle(how, x*32+200, y*32, 30, 30, 5, 5)
end
end
end
 
local function check(x,y)
return map[x][y]
end
-----------------------for food-----------------------
 
 
local function newFood()
repeat 
food.x= love.math.random(2,14)
food.y= love.math.random(2,14)
until not check(food.x,food.y)
map[food.x][food.y]=true
end
 
-----------------------for snake------------------------------
local snake={}
local function setupSnake()
snake={}
for i=1,5 do
snake[i]={x=i+5,y=7} 
end
end
 
 
local function drawSnake(toggle)
for i,v in ipairs(snake) do
map[v.x][v.y]=toggle
end
end
 
--------------------game over--------------------------------
 
local function gameover()
local title = "Game Over"
local message = "Your Score is "..tostring(#snake-5)
local buttons = {"Restart!", "Quit!", escapebutton = 2}
 
local pressedbutton = love.window.showMessageBox(title, message, buttons)
if pressedbutton == 1 then
           setupMap()
setupSnake()
drawSnake(true)
newFood()
timer=0.5
elseif pressedbutton == 2 then
    love.event.quit()
end
end
 
local function eat()
table.insert(snake, {x=targetX,y=targetY})
updateCD=updateCD*0.9
newFood()
end
 
---------------------for update -------------------------
local function updateSnake()
lastDir.x=dir.x
lastDir.y=dir.y
local targetX,targetY=snake[1].x+dir.x,snake[1].y+dir.y
if check(targetX,targetY) then
if targetX==food.x and targetY==food.y then --eat
eat()
else --hit
gameover()
return
end
end
drawSnake(false)
for i=#snake,2,-1 do
snake[i].x=snake[i-1].x
snake[i].y=snake[i-1].y
end
snake[1].x=targetX
snake[1].y=targetY
 
drawSnake(true)
 
end
 
-----------------------for input-------------------
 
local function input()
if love.keyboard.isDown("up") then
if lastDir.y==0 then
dir.x,dir.y=0,-1
end
elseif love.keyboard.isDown("down") then
if lastDir.y==0 then
dir.x,dir.y=0,1
end
elseif love.keyboard.isDown("left") then
if lastDir.x==0 then
dir.x,dir.y=-1,0
end
elseif love.keyboard.isDown("right") then
if lastDir.x==0 then
dir.x,dir.y=1,0
end
end
end
 
-------------------------------------the main frame------------------------------------
 
function love.load()
setupMap()
setupSnake()
drawSnake(true)
newFood()
end
 
function love.update(dt)
input()
timer=timer-dt
if timer<0 then
timer=updateCD
updateSnake()
end
end
 
function love.draw()
    drawMap()
end
 
 
 
贪吃蛇就做完啦！怎么样？是不是很简单？
我们来回顾下学习的重点，
•	实物抽象思想：通过把地图，蛇，食物进行抽象，建立数学模型。
•	键盘按下回调，通过两种方法按下按键来改变方向。
•	基本的图形显示，用矢量图绘制矩阵单元格，每个单元格跟矩阵位置的函数关系。
•	基本的网格概念：使用网格法进行碰撞判断。
•	基本的表数据更新，通过表的遍历来控制一组数据
 
拓展作业
•	根据个人能力与时间完成下列拓展中的一个或几个，也可以合并到一个项目中。
•	除了贪吃蛇的基本规则，通过拓展来实现新的游戏规则
•	让屏幕上蛇、边框、食物有不同的颜色！
•	我们的小蛇会饿了，如果一定时间吃不到食物就要缩短！
•	有种东西叫虫洞，我们的小蛇要进行穿越之旅了！
•	让地图和小蛇有个皮肤吧，你不再是裸蛇了！
•	小蛇不再限制于上下左右四个方向了，是的，代号，自由行动！
•	你的世界不再孤单！争夺食物，弱肉强食，想挑战比你大的？记得咬尾巴！
•	贪吃蛇拼图？没错，吃进去的图片按顺序从尾部拉出来……听起来有点恶心，不过先进先出是关键！
]]



-------------------------------------------init--------------------------------
local updateCD=0.5
local timer=0.5
local dir={x=0,y=1}
local lastDir={x=0,y=0}
local map={}
local food={x=0,y=0}

------------------------for map---------------------------
local function setupMap()
	map={}
	for x=1,15 do
		map[x]={}
		for y=1,15 do
			if x==1 or x==15 or y==1 or y==15 then
				map[x][y]=true 
			else
				map[x][y]=false
			end
		end
	end 
end

local function drawMap()
	love.graphics.setColor(255,255,255)
    for x=1,15 do
	for y=1,15 do
		local how=map[x][y] and "fill" or "line"
		love.graphics.rectangle(how, x*32+100, y*32, 30, 30, 5, 5)
	end
	end
end

local function check(x,y)
	return map[x][y]
end
-----------------------for food-----------------------


local function newFood()
	repeat 
		food.x= love.math.random(2,14)
		food.y= love.math.random(2,14)
	until check(food.x,food.y)==false
	map[food.x][food.y]=true
end

-----------------------for snake------------------------------
local snake={}
local function setupSnake()
	snake={}
	for i=1,5 do
		snake[i]={x=i+5,y=7} 
	end
end


local function drawSnake(toggle)
	for i,v in ipairs(snake) do
		map[v.x][v.y]=toggle
	end
end

--------------------game over--------------------------------

local function gameover()
	local title = "Game Over"
	local message = "Your Score is "..tostring(#snake-5)
	local buttons = {"Restart!", "Quit!", escapebutton = 2}
	 
	local pressedbutton = love.window.showMessageBox(title, message, buttons)
	if pressedbutton == 1 then
	   	setupMap()
		setupSnake()
		drawSnake(true)
		newFood()
		timer=0.5
		dir={x=0,y=1}
		lastDir={x=0,y=0}
	elseif pressedbutton == 2 then
	    --love.event.quit()
	    exf.resume()
	end
end

local function eat()
	table.insert(snake, {x=snake[1].x,y=snake[1].y})
	updateCD=updateCD*0.9
	newFood()
end

---------------------for update -------------------------
local function updateSnake()
	lastDir.x=dir.x
	lastDir.y=dir.y
	local targetX,targetY=snake[1].x+dir.x,snake[1].y+dir.y
	if check(targetX,targetY) then
		if targetX==food.x and targetY==food.y then --eat
			eat()
		else --hit
			gameover()
			return
		end
	end
	drawSnake(false)
	for i=#snake,2,-1 do
		snake[i].x=snake[i-1].x
		snake[i].y=snake[i-1].y
	end
	snake[1].x=targetX
	snake[1].y=targetY
	
	drawSnake(true)

end

-----------------------for input-------------------

local function input()
	if love.keyboard.isDown("up") then
		if lastDir.y==0 then
			dir.x,dir.y=0,-1
		end
	elseif love.keyboard.isDown("down") then
		if lastDir.y==0 then
			dir.x,dir.y=0,1
		end
	elseif love.keyboard.isDown("left") then
		if lastDir.x==0 then
			dir.x,dir.y=-1,0
		end
	elseif love.keyboard.isDown("right") then
		if lastDir.x==0 then
			dir.x,dir.y=1,0
		end
	end
end

-------------------------------------the main frame------------------------------------

function love.load()
	setupMap()
	setupSnake()
	drawSnake(true)
	newFood()
end

function love.update(dt)
	--print(dir.x,dir.y)
	input()
	timer=timer-dt
	if timer<0 then
		timer=updateCD
		updateSnake()
	end
	
end

function love.draw()
    drawMap()
end
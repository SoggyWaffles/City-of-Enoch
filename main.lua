--[[OMG THANKYOU!
TechnoCat
]]

require("libs/camera")
require("libs/vector")
require("libs/player")
require("libs/zombie")
require("libs/map")

function love.load()
	math.randomseed( os.time() )
	for i=1,5 do
		math.random()
	end
	t = 0
	love.graphics.setBackgroundColor(153,177,190)
	quadImage = love.graphics.newImage('images/cityspritesheet20lj.png')
	setH = quadImage:getHeight()
	setW = quadImage:getWidth()
	mapName = 'main'
	mapName_ = 'main'
	newLevel( mapName )
	camera = Camera()
	
end
function love.keyreleased( key )
	if key == " " and entry == true and mapName ~= mapName_ then 
		mapName_= mapName
		newLevel(mapName)
	end
	
end

function love.update(dt)
	t = t+dt
  	player:update(dt)
  	zombie:update(dt)
  	checkCamera()
  	World:update(dt)
 end
  

function checkCamera() --sets the camera so it follows the boundries of the world
	local body_x, body_y = player.body:getPosition()
	if body_x+(player.w/2) < sw_/2 then
		c_x = sw_/2
	elseif body_x+(player.w/2) > map.worldW-(sw_/2) then
		c_x = map.worldW-(sw_/2)
	else
		c_x = body_x+(player.w/2)
	end
	if body_y+(player.h/2) < sh_/2 then
		c_y = sh_/2
	elseif body_y+(player.h/2) > map.worldH-(sh_/2) then
		c_y = map.worldH-(sh_/2)
	else
		c_y = body_y+(player.h/2)
	end
	camera.pos = vector(c_x,c_y)
end

function love.draw()
	if t > 1 then
		love.graphics.setCaption(love.timer.getFPS(), 0, 0)
		t=0
	end
	camera:predraw()
		map:draw()
		for n,array in ipairs(map.shapes) do
			if array:isSensor() == true then
				local x1,y1, x2,y2, x3,y3, x4,y4 = array:getBoundingBox()
    			local w = x3-x2
    			local h = y2-y1
    			love.graphics.setColor( 255, 0, 0, 255 )
    			love.graphics.rectangle("line",x1,y1,w,h)
    			love.graphics.setColor( 255, 255, 255, 255 )
    		end
		end
		player:draw()
		zombie:draw()
	camera:postdraw()
end

 function isinarray(array, var) 
 	for i,v in ipairs(array) do 
 		if v == var then 
 			return true 
 		end 
 	end 
 end
 
function newLevel( mapName )
	map = Map:new( mapName )
	World = love.physics.newWorld(0,0,map.worldW,map.worldH)
	World:setCallbacks(add, persist, rem, result)
	map:set()
	player = Player:new(50,50)
	zombie = Zombie:new(200,50)
	c_x, c_y =0,0
	sh_ = love.graphics.getHeight()
	sw_ = love.graphics.getWidth()
	entry = false
end

function add(a, b, coll)
    text = a.." colliding with "..b.." at an angle of "..coll:getNormal().."\n"
    if b == 'zombie' then
    	zombie:collide()
    end
end

function persist(a, b, coll)
	--print(a)
	if string.sub(a,1,6) == 'sensor' then
    	entry = true
    	mapName = string.sub(a,7)
    	--print(mapName, 'mapName')
    end
end

function rem(a, b, coll)
    text = a.." uncolliding "..b.."\n"
    --print(text)
    entry = false
end

function result(a, b, coll)
    text = a.." hit "..b.."resulting with "..coll:getNormal().."\n"
end
--[[OMG THANKYOU!
TechnoCat
]]

require("libs/camera")
require("libs/vector")
require("libs/player")
require("libs/map")

function love.load()
	t = 0
	love.graphics.setBackgroundColor( 52, 52, 52 )
	map = Map:new()
	World = love.physics.newWorld(0,0,map.worldW,map.worldH)
	map:set()	
	player = Player:new(100,100)
	camera = Camera()
	c_x, c_y =0,0
	sh_ = love.graphics.getHeight()
	sw_ = love.graphics.getWidth()
end

function love.update(dt)
	t = t+dt
  	player:update(dt)
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
		player:draw()
	camera:postdraw()
	end

 function isinarray(array, var) 
 	for i,v in ipairs(array) do 
 		if v == var then 
 			return true 
 		end 
 	end 
 end
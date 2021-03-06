require "libs/middleclass"
require "libs/anim"

Player = class("Player")
function Player:initialize(posx,posy)
	self.quadInfo = {
		{'down_standing',480,387,15,19},
		{'down_1',496,387,15,19},
		{'down_2', 512,387,15,19},
		{'left_standing',528,387,15,19},
		{'left_1', 544,387,15,19},
		{'left_2', 560,387,15,19},
		{'up_standing',576,387,15,19},
		{'up_1', 592,387,15,19},
		{'up_2', 608,387,15,19},
		{'right_standing',624,387,15,19},
		{'right_1', 640,387,15,19},
		{'right_2', 656,387,15,19}
		}
	self.quads = {}
	for i,info in ipairs(self.quadInfo) do
		self.quads[info[1]] = love.graphics.newQuad(info[2], info[3], info[4], info[5], setW, setH)
	end
	self.anim = Anim:new()
	self.w = 15
	self.h = 19
  	self.angle = 0
  	self.body = love.physics.newBody( World, posx, posy, 50, 0 )
  	self.shape = love.physics.newRectangleShape( self.body, 0, 0, self.w, self.h, 0 )
  	self.body:setLinearDamping(10)
  	self.shape:setData("player")
  	self.direction = 'up'
  	self.x_, self.y_ = posx, posy
end

function Player:update(dt)
	if love.keyboard.isDown("right") or love.keyboard.isDown('d') then --use wasd or arrows to move player
    	self.body:applyForce(2000, 0)
    end
  	if love.keyboard.isDown("left") or love.keyboard.isDown('a') then 
    	self.body:applyForce(-2000, 0)
    end
  	if love.keyboard.isDown("up") or love.keyboard.isDown('w') then 
    	self.body:applyForce(0, -2000)
    end
  	if love.keyboard.isDown("down") or love.keyboard.isDown('s') then 
    	self.body:applyForce(0, 2000)
  	end
  	
  	local px,py = self.body:getPosition()
  	self.dist = math.sqrt((self.x_-px)^2+(self.y_-py)^2)
  	self:getAngle(px,py)
  	self.image = self.anim:getImge(self.direction, self.dist, dt)
  	self.x_, self.y_ = px,py
end

function Player:getAngle(px,py) --sets the angle, and sets the quad to draw to appropriate angle of the player
	local mx,my = camera:mousepos():unpack()
	local xd = mx-px
	local yd = my-py
	self.angle = math.atan2(yd,xd)+math.pi
	if self.angle < math.pi/4 or self.angle >=7* math.pi/4 then
		self.direction = 'left' --self.direction is a name of a quad
	elseif self.angle < 3*math.pi/4 and self.angle >= math.pi/4 then
		self.direction = 'up'
	elseif self.angle < 7*math.pi/6 and self.angle >= 3*math.pi/4 then
		self.direction = 'right'
	elseif self.angle < 7*math.pi/4 and self.angle >= 7*math.pi/6 then
		self.direction = 'down'
	end
end

function Player:draw()
	local _px_, _py_ = self.body:getPosition()
	love.graphics.drawq(quadImage, self.quads[self.image], _px_-self.w/2,_py_-self.h/2)
end

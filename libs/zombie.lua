require "libs/middleclass"
require "libs/vector"
require "libs/anim"

Zombie = class("Zombie")
function Zombie:initialize(posx,posy)
	--[[self.quadImage = love.graphics.newImage('images/cityspritesheet20lj.png')
	self.setH = self.quad_image:getHeight()
	self.setW = self.quad_image:getWidth()]]
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
  	self.angle = math.random()*(2*math.pi)
  	self:vectors()
  	self.body = love.physics.newBody( World, posx, posy, 50, 0 )
  	self.shape = love.physics.newRectangleShape( self.body, 0, 0, self.w, self.h, 0 )
  	self.body:setLinearDamping(10)
  	self.shape:setData("zombie")
  	self.direction = 'up'
  	self.x_, self.y_ = posx, posy
end

function Zombie:update(dt)
	local px,py = self.body:getPosition()
  	self.dist = math.sqrt((self.x_-px)^2+(self.y_-py)^2)
	self.body:applyForce(self.vx*1000, self.vy*1000)
	self:getAngle()
	self.image = self.anim:getImge(self.direction, self.dist, dt)
	self.x_, self.y_ = px,py
end

function Zombie:getAngle() --sets the angle, and sets the quad to draw to appropriate angle of the player
	if self.angle < math.pi/4 or self.angle >=7* math.pi/4 then
		self.direction = 'right' --self.direction is a name of a quad
	elseif self.angle < 3*math.pi/4 and self.angle >= math.pi/4 then
		self.direction = 'down'
	elseif self.angle < 7*math.pi/6 and self.angle >= 3*math.pi/4 then
		self.direction = 'left'
	elseif self.angle < 7*math.pi/4 and self.angle >= 7*math.pi/6 then
		self.direction = 'up'
	end
end


function Zombie:draw()
	local _px_, _py_ = self.body:getPosition()
	love.graphics.setColor( 70, 245, 0, 255 )
	love.graphics.drawq(quadImage, self.quads[self.image], _px_-self.w/2,_py_-self.h/2)
	love.graphics.setColor( 255, 255, 255, 255 )
end

function Zombie:vectors()
	self.vx =  math.cos(self.angle)/math.pi*2
	self.vy =  math.sin(self.angle)/math.pi*2
end

function Zombie:collide()
	self.angle = math.random()*(2*math.pi)
  	self:vectors()
end
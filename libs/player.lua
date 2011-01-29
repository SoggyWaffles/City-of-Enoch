require "libs/middleclass"

Player = class("Player")
function Player:initialize(posx,posy)
	self.image = love.graphics.newImage("images/player.png")
	self.w = self.image:getWidth()
	self.h = self.image:getHeight()
  	self.angle = 0
  	self.body = love.physics.newBody( World, posx, posy, 50, 0 )
  	self.shape = love.physics.newCircleShape(self.body, 0, 0, 16)
  	self.body:setLinearDamping(3)
  	self.shape:setData("player")
end

function Player:update(dt)
	if love.keyboard.isDown("right") or love.keyboard.isDown('d') then --use wasd or arrows to move player
    	self.body:applyForce(1000, 0)
    end
  	if love.keyboard.isDown("left") or love.keyboard.isDown('a') then 
    	self.body:applyForce(-1000, 0)
    end
  	if love.keyboard.isDown("up") or love.keyboard.isDown('w') then 
    	self.body:applyForce(0, -1000)
    end
  	if love.keyboard.isDown("down") or love.keyboard.isDown('s') then 
    	self.body:applyForce(0, 1000)
  	end

  	self:getAngle()
end

function Player:getAngle() --sets the angle 
	local px,py = self.body:getPosition()
	local mx,my = camera:mousepos():unpack()
	xd = mx-px
	yd = my-py
	self.angle = math.atan2(yd, xd)+(math.pi/2)
end

function Player:draw()
	_px_, _py_ = self.body:getPosition()
	love.graphics.draw(self.image, _px_, _py_,self.angle,1,1,self.w/2,self.h/2)
end

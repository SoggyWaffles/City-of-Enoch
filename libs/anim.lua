require "libs/middleclass"

Anim = class("Anim")
function Anim:initialize()
	self.step = 1
end

function Anim:getImge(direction, dist, dt)
	if dist < .2 then
		 self.name = direction..'_standing'
		 self.dt = 0
	else
		if self.dt >= .2 and  self.step == 1 then
			self.name = direction..'_1'
			self.step = 2
			self.dt = 0
		elseif self.dt >= .2 and  self.step == 2 then
			self.name = direction..'_standing'
			self.step = 3
			self.dt = 0
		elseif self.dt >= .2 and  self.step == 3 then
			self.name = direction..'_2'
			self.step = 4
			self.dt = 0
		elseif self.dt >= .2 and  self.step == 4 then
			self.name = direction..'_standing'
			self.step = 1
			self.dt = 0
		else 
			self.dt =self.dt + dt
		end
	end
	return self.name
end

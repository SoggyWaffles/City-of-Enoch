require("libs/middleclass")

Map = class('Map')

function Map:initialize()
	self.image = love.graphics.newImage('images/cyberpunk_main.png')
	self.setH = self.image:getHeight()
	self.setW = self.image:getWidth()
	self.tileH, self.tileW = 64,64 --size of the smallest quad, everything is scaled to this when drawing the background
	self.source = love.image.newImageData('images/map.png')
	self.worldW = self.source:getWidth()*self.tileW
	self.worldH = self.source:getHeight()*self.tileH
	self.fb = love.graphics.newFramebuffer(self.worldW, self.worldH)
	self.quadInfo = {{'road',640,896,64,64},{'building',64,192,128,128},{'wall',256,192,64,64}}
	self.quads = {}
	for i,info in ipairs(self.quadInfo) do
		self.quads[info[1]] = love.graphics.newQuad(info[2], info[3], info[4], info[5], self.setH, self.setW)
	end
	self.bodies = {}
	self.shapes = {}
end

function Map:set()
	local color = {}
	local collidable = {"wall","building"}
	self.width = self.worldW/self.tileW --sets the parameters for for loops
	self.height = self.worldH/self.tileH
	self.tileTable = {}
	for y=1,self.height do --looks at each pixal in map.png and gets the color, row then column, (y,x)
    	self.tileTable[y] = {} --adds a new array for each row
    	for x=1,self.width do --goes though each pixel in the row
    		color = {self.source:getPixel(x-1,y-1)} --gets the color for that pixel, (x,y)
      		k = self:checkColors(color) --send the color to the function, returns the name of the tile
      		c = isinarray(collidable, k) 
      		if c == true then
      			x_b = ((x-1)*self.tileW)
      			y_b = ((y-1)*self.tileH)
      			body_ = love.physics.newBody(World, x_b, y_b,0,0)
      			if k == 'wall' then
      				shape_ = love.physics.newRectangleShape(body_,(self.tileW/2),(self.tileH/2),self.tileW,self.tileH,0)
      			else
      				shape_ = love.physics.newRectangleShape(body_,(self.tileW),(self.tileH),self.tileW*2,self.tileH*2,0)
      			end
      			shape_:setData("block")
      			table.insert(self.bodies, body_)
      			table.insert(self.shapes, shape_)
      		end
      		self.tileTable[y][x] = k --set the name of the tile in the correct position in the array
      		color = {} --clears the color array to keep from messing up later on ;)
    	end
  	end
  	love.graphics.setRenderTarget(self.fb) --draws the map to a framebuffer
  		self:render()
  	love.graphics.setRenderTarget()
  	
 end
function Map:render()
	for rowIndex,row in ipairs(self.tileTable) do
  			for columnIndex,name in ipairs(row) do
  				local x,y = (columnIndex-1)*self.tileW, (rowIndex-1)*self.tileH
  				if name ~= 'skip' then
  					love.graphics.drawq(self.image, self.quads[name], x,y)
  				end
  			end
  	end
end

function Map:checkColors(color)
	local tiles_ = {{255,255,255,255,name='skip'},{0,255,0,255,name='road'},{255,0,0,255,name='wall'}
	,{0,0,255,255,name='building'}} --list of tiles with {r,g,b,a,name='tile name'} this can be added to at any time
	local x = 0 --counter to see if all 4 (r,g,b,a) values match
	for n,array in ipairs(tiles_) do
		for i,v in ipairs(array) do
			if v==color[i] then --check each value to the pixel value from the map.png
			x=x+1 end
			if x == 4 then return array.name end 
		end
		x=0
	end
end

function Map:draw()
	love.graphics.draw(self.fb, 0, 0)
end


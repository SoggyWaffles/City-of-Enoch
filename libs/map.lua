require("libs/middleclass")

Map = class('Map')

function Map:initialize( mapName )
	print('map:',mapName)
	self.tileH, self.tileW = 32,32 --size of the smallest quad, everything is scaled to this when drawing the background
	self.mapImages = {
		['building1'] = 'images/building1.png',
		['building2'] = 'images/building2.png',
		['building3'] = 'images/building3.png',
		['building4'] = 'images/map.png',
		['main'] = 'images/map.png'
		}
	self.source = love.image.newImageData(self.mapImages[mapName])
	self.worldW = self.source:getWidth()*self.tileW
	self.worldH = self.source:getHeight()*self.tileH
	self.fb = love.graphics.newFramebuffer(self.worldW, self.worldH)
	self.quadInfo = {
		{'road',845,1228,32,32},
		{'building1',458,5,64,64},
		{'building2',421,202,64,64},
		{'building3',1534,197,64,64},
		{'building4', 1042,722,64,64},
		{'wall',465,1750,32,32},
		{'corner',464,1786,32,32},
		}
	self.quads = {}
	self.quads_info = {}
	for i,info in ipairs(self.quadInfo) do
		self.quads[info[1]] = love.graphics.newQuad(info[2], info[3], info[4], info[5], setH, setW)
		self.quads_info[info[1]]={info[2], info[3], info[4], info[5]}
	end
	self.bodies = {}
	self.shapes = {}
end

function Map:set()
	local color = {}
	local collidable = {"building1","building2","building3","building4"}
	self.width = self.worldW/self.tileW --sets the parameters for for loops
	self.height = self.worldH/self.tileH
	self.tileTable = {}
	self:setWalls()
	for y=1,self.height do --looks at each pixal in map.png and gets the color, row then column, (y,x)
    	self.tileTable[y] = {} --adds a new array for each row
    	for x=1,self.width do --goes though each pixel in the row
    		color = {self.source:getPixel(x-1,y-1)} --gets the color for that pixel, (x,y)
      		k = self:checkColors(color) --send the color to the function, returns the name of the tile
      		c = isinarray(collidable, k) 
      		
      		if c == true then
      			local x_b = ((x-1)*self.tileW)
      			local y_b = ((y-1)*self.tileH)
      			local body_ = love.physics.newBody(World, x_b, y_b,0,0)
      			local shape_ = love.physics.newRectangleShape(body_,(self.tileW),(self.tileH),self.quads_info[k][3],self.quads_info[k][4],0)
      			--since i set the body at the (0,0) of each pixel in the minimap, the shape is offset by half total width and hight
      			shape_:setData(k)
      			table.insert(self.bodies, body_)
      			table.insert(self.shapes, shape_)
      			sensor_ = love.physics.newRectangleShape(body_,(self.tileW),(self.tileH*2+6),32,10,0)
      			sensor_:setSensor(true)
      			sensor_:setData('sensor'..k)
      			table.insert(self.shapes, sensor_)
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
  					love.graphics.drawq(quadImage, self.quads[name], x,y)
  				end
  			end
  	end
end

function Map:checkColors(color)
	local tiles_ = {
		{255,255,255,255,name='skip'},
		{0,255,0,255,name='road'},
		{255,0,0,255,name='wall'},
		{0,0,255,255,name='building1'},
		{255,0,255,255,name='building2'},
		{0,255,255,255,name='building3'},
		{255,255,0,255,name='building4'},
		{126,0,0,255,name='corner'}
	} --list of tiles with {r,g,b,a,name='tile name'} this can be added to at any time
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

function Map:setWalls()
	table.insert(self.bodies, love.physics.newBody(World, 0, 0,0,0))
    table.insert(self.shapes, love.physics.newRectangleShape(self.bodies[1],self.worldW/2,self.tileH/2,
    	self.worldW,self.tileH,0))
    self.shapes[1]:setData("wall")
    table.insert(self.bodies, love.physics.newBody(World, 0, self.tileH,0,0))
    table.insert(self.shapes, love.physics.newRectangleShape(self.bodies[2],self.tileW/2,(self.worldH/2)-(self.tileH),
    	self.tileW,self.worldH-self.tileH*2,0))
	self.shapes[2]:setData("wall")
	table.insert(self.bodies, love.physics.newBody(World, 0, self.worldH-self.tileH,0,0))
	table.insert(self.shapes, love.physics.newRectangleShape(self.bodies[3],self.worldW/2,self.tileH/2,
    	self.worldW,self.tileH,0))
    self.shapes[3]:setData("wall")
    table.insert(self.bodies, love.physics.newBody(World, self.worldW-self.tileW, self.tileH,0,0))
    table.insert(self.shapes, love.physics.newRectangleShape(self.bodies[4],self.tileW/2,(self.worldH/2)-(self.tileH),
    	self.tileW,self.worldH-self.tileH*2,0))
    self.shapes[4]:setData("wall")
end

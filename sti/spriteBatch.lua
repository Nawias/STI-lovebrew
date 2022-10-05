local lg       = _G.love.graphics
local lm       = _G.love.math
local SpriteBatch = {image, size, sprites = {}}


function SpriteBatch:new(o)
    o = o or {}
    setmetatable(o,self)
    self.__index = self
    return o
end

function SpriteBatch:draw(x,y)
    for i,v in ipairs (self.sprites) do
        if v.quad == nil then
            --print("Trans: ",v.transform)
            lg.draw(self.image, v.transform)
        else
            --print("Quad: ",v.quad)
            lg.draw(self.image, v.quad, v.transform)
        end
    end
end

function SpriteBatch:setNoQuad(spriteindex, x, y, r, sx, sy, ox, oy)
    self.sprites[spriteindex].transform = self.sprites[spriteindex].transform.setTransformation(x, y, r, sx, sy, ox, oy)
    return nil
end

function SpriteBatch:set(spriteindex, quad, x, y, r, sx, sy, ox, oy)
    if type(quad) == "number" then
        return SpriteBatch.setNoQuad(self,spriteindex, quad, x, y, r, sx, sy, ox)
    end
    self.sprites[spriteindex].transform = self.sprites[spriteindex].transform.setTransformation(x, y, r, sx, sy, ox, oy)
    self.sprites[spriteindex].quad = quad
    return self:set(spriteindex, quad, x,y,r,sx,sy,ox,oy)
end
 
function SpriteBatch:addNoQuad(x, y, r, sx, sy, ox, oy, kx, ky)
    table.insert(self.sprites,{x, y, r, sx, sy, ox, oy, kx, ky})
    return table.getn(self.sprites)
end

function SpriteBatch:add(quad, x, y, r, sx, sy, ox, oy, kx, ky)
    if type(quad) == "number" then
        return SpriteBatch.addNoQuad(self,quad, x, y, r, sx, sy, ox, oy, kx)
    end
    table.insert(self.sprites,{quad = quad, transform = lm.newTransform(x, y, r, sx, sy, ox, oy, kx, ky)})
    return table.getn(self.sprites)
end


function SpriteBatch.newSpriteBatch(image, size)
    return SpriteBatch:new({image = image, size = size})
end

return SpriteBatch
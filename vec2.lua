vec2 = {}
vec2.x = 0
vec2.y = 0
vec2.__index = vec2

function vec2:new(x,y)
    return setmetatable({x=x, y=y}, self)
end

function vec2:length()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function vec2:normalize()
    local len = self:length()
    if len > 0 then
        self.x = self.x / len
        self.y = self.y / len
    end
end

function vec2:__tostring()
	return "("..tonumber(self.x)..","..tonumber(self.y)..")"
end

local function isvector(v)
	return type(v) == 'table' and type(v.x) == 'number' and type(v.y) == 'number'
end

function vec2:__eq(v)
    assert(isvector(v), "Expected a vec2 type")
    return self.x == v.x and self.y == v.y
end

function vec2:__add(v)
    assert(isvector(v), "Expected a vec2 type")
    return vec2:new(self.x + v.x, self.y + v.y)
end

function vec2:add(v)
    assert(isvector(v), "Expected a vec2 type")
    self.x = self.x + v.x
    self.y = self.y + v.y
end

function vec2:__sub(v)
    assert(isvector(v), "Expected a vec2 type")
    return vec2:new(self.x - v.x, self.y - v.y)
end

function vec2:__mul(a)
    if type(a) == 'number' then
        return vec2:new(self.x * a, self.y * a)
    else
        assert(isvector(a), "Expected a number or vec2 type")
        return vec2:new(self.x * a.x, self.y * a.y)
    end
end

function vec2:__div(a)
    if type(a) == 'number' then
        return vec2:new(self.x / a, self.y / a)
    else
        assert(isvector(a), "Expected a number or vec2 type")
        return vec2:new(self.x / a.x, self.y / a.y)
    end
end

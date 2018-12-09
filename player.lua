require 'vec2'

Player = {}
Player.name = 'none'
Player.color = {255, 0, 0}
Player.width = 5
Player.height = 5
Player.acceleration = 100
Player.position = vec2:new(0, 0)
Player.vector = vec2:new(0, 0)
Player.path = {}
Player.path.vector = Player.position
Player.vectors = {
    up    = vec2:new(0, -1),
    down  = vec2:new(0, 1),
    left  = vec2:new(-1, 0),
    right = vec2:new(1, 0),
    }
Player.keys = {
    w = 'up',
    s = 'down',
    a = 'left',
    d = 'right',
    }

function Player:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.path.vector = o.position
    o:recordPosition()
    return o
end

function Player:__tostring()
    return self.name
end

function Player:drawPath()
    local points = {}
    local node = self.path
    while node do
        table.insert(points, node.vector.x)
        table.insert(points, node.vector.y)
        node = node.prev
    end
    if #points >= 4 then
        love.graphics.setLineWidth(2)
        love.graphics.setColor(self.color)
        love.graphics.line(points)
    end
end

function Player:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle(
        'fill',
        self.position.x-self.width/2,
        self.position.y-self.height/2,
        self.width,
        self.height
        )
    self:drawPath()
end

function Player:recordPosition()
    local v = vec2:new(self.position.x, self.position.y)
    self.position = v
    print('Recording position for '..tostring(self)..': '..tostring(self.position))
    local node = {}
    node.vector = v
    node.prev = self.path
    self.path.next = node
    self.path = node
end

function Player:multiple_keys_are_pressed()
    local count = 0
    for key,_ in pairs(self.keys) do
        if love.keyboard.isDown(key) then
            count = count + 1
        end
    end
    return count > 1
end

function Player:update(dt)
    if not self:multiple_keys_are_pressed() then
        for key, name in pairs(self.keys) do
            if love.keyboard.isDown(key)
            and self.vector ~= self.vectors[name]
            and (self.vector + self.vectors[name]):length() > 0
            then
                self.vector = self.vectors[name]
                self:recordPosition()
                break
            end
        end
    end
    self.position:add(self.vector * self.acceleration * dt)
end

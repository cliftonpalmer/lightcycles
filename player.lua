Player = {}
Player.name = 'player'
Player.color = {255, 0, 0}
Player.width = 5
Player.height = 5
Player.acceleration = 100
Player.position = {x=0, y=0}
Player.vector = {x=0, y=0}

function Player:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Player:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.position.x, self.position.y, self.width, self.height)
end

function Player:update(dt)
    if love.keyboard.isDown("w") then
        self.vector = {x=0, y=-self.acceleration}
    elseif love.keyboard.isDown("s") then
        self.vector = {x=0, y=self.acceleration}
    elseif love.keyboard.isDown("a") then
        self.vector = {x=-self.acceleration, y=0}
    elseif love.keyboard.isDown("d") then
        self.vector = {x=self.acceleration, y=0}
    end

    self.position.x = self.position.x + self.vector.x * dt
    self.position.y = self.position.y + self.vector.y * dt
end

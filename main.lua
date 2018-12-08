-- main

require 'vec2'
require 'player'

function love.load()
    player = Player:new({position=vec2:new(100,100), vector=Player.vectors.right})
end

function love.draw()
    -- set bg
    local bgcolor = {0.2, 0.2, 0.5}
    love.graphics.setBackgroundColor(bgcolor)

    -- draw basic grid
    love.graphics.setColor(0.3, 0.3, 0.6)
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    local delta = 50

    for x=0,width,delta do
        love.graphics.line(x, 0, x, height)
    end

    for y=0,height,delta do
        love.graphics.line(0, y, width, y)
    end

    -- misc
    player:draw()
end

function love.update(dt)
    if love.keyboard.isDown('escape') then
        love.event.quit()
    end
    player:update(dt)
end

function love.quit()
    print('Thanks for playing!')
    print('Recorded ' .. #player.path / 2 .. ' player path points')
end

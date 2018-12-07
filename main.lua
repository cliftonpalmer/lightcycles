-- main

function love.load()
end

function love.draw()
    -- set bg
    love.graphics.setBackgroundColor(0.2, 0.2, 0.5)

    -- draw basic grid
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    local delta = 50

    for x=0,width,delta do
        love.graphics.line(x, 0, x, height)
    end

    for y=0,height,delta do
        love.graphics.line(0, y, width, y)
    end
end

function love.update(dt)
    if love.keyboard.isDown('escape') then
        love.event.quit()
    end
end

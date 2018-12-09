-- main

require 'scene'

function love.load()
    scene:load()
end

function love.draw()
    scene:draw()
end

function love.update(dt)
    if love.keyboard.isDown('escape') then
        love.event.quit()
    end
    scene:update(dt)
end

function love.quit()
    print('Thanks for playing!')
    scene:quit()
end

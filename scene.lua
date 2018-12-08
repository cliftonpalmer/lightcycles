-- main

require 'vec2'
require 'player'


scene = {}
scene.paused = false
scene.width = love.graphics.getWidth()
scene.height = love.graphics.getHeight()
scene.players = {}
scene.grid = {}
scene.grid.bgcolor = {0.2, 0.2, 0.5}
scene.grid.linecolor = {0.3, 0.3, 0.6}
scene.grid.delta = 50

-- load
function scene:load()
    table.insert(scene.players, require('players/1'))
    --table.insert(scene.players, require('players/2'))
end

-- draw
function scene:drawGrid()
    love.graphics.setBackgroundColor(self.grid.bgcolor)
    love.graphics.setColor(self.grid.linecolor)

    for x=0,self.width,self.grid.delta do
        love.graphics.line(x, 0, x, self.height)
    end
    for y=0,self.height,self.grid.delta do
        love.graphics.line(0, y, self.width, y)
    end
end

function scene:drawPlayers()
    for _,player in pairs(self.players) do
        player:draw()
    end
end

function scene:draw()
    self:drawGrid()
    self:drawPlayers()

    -- draw intersection if it's there
    if self.intersection then
        love.graphics.setColor(0, 255, 0)
        love.graphics.line(self.intersection)
    end
end

-- update
function scene:updatePlayers(dt)
    for _,player in pairs(self.players) do
        player:update(dt)
    end
end

function doLinesIntersect(x1, y1, x2, y2, x3, y3, x4, y4)
    if x1 == x2 and x3 == x4
    or y1 == y2 and y3 == y4
    then
        -- if lines are parallel, no intersection!
        return false
    else
        -- if lines are not parallel, they must intersect
        -- do segments overlap?
        if
            x1 <= x3 and x3 <= x2
        and y1 <= y3 and y3 <= y2
        or
            x3 <= x1 and x1 <= x4
        and y3 <= y1 and y1 <= y4
        then
            scene.paused = true
            scene.intersection = {x1, y1, x2, y2, x3, y3, x4, y4}
            return true
        end
    end
end

function doesLineIntersectPlayerPaths(path, x1, y1, x2, y2)
    local stash = {}
    -- for every line in path,
    -- check intersection with player line
    for k,v in pairs(path) do
        if #stash == 4 then
            if doLinesIntersect(x1, y1, x2, y2, stash[4], stash[3], stash[2], stash[1]) then
                return true
            end
            stash = {}
        else
            table.insert(stash,v)
        end
    end
    return false
end

-- love collision handler
function collision(player)
    print('Player '..tostring(player)..' crashed!')
    --love.event.quit()
end
love.handlers.collision = collision

function scene:handleCollisions()
    -- calculate the last line for each player from current position
    -- check if line intersects any other path line
    -- if so, raise collision event for player
    for _,player in pairs(self.players) do
        local x1 = player.path[#player.path-1]
        local y1 = player.path[#player.path]
        local x2 = player.position.x
        local y2 = player.position.y

        -- check intersection against each existing path
        for _,player2 in pairs(self.players) do
            if doesLineIntersectPlayerPaths(player2.path, x1, y1, x2, y2) then
                love.event.push('collision', player)
            end
        end
    end
end

function scene:update(dt)
    self:updatePlayers(dt)
    self:handleCollisions()
end

-- quit
function scene:quit()
    for _,player in pairs(self.players) do
        print(tostring(player)..' generated '.. #player.path / 2 .. ' path points')
    end
end

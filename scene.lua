-- main

require 'vec2'
require 'player'


scene = {}
scene.debug = false
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
    table.insert(scene.players, require('players/2'))
end

-- draw
function scene:drawGrid()
    love.graphics.setBackgroundColor(self.grid.bgcolor)
    love.graphics.setColor(self.grid.linecolor)

    love.graphics.setLineWidth(2)
    for x=0,self.width,self.grid.delta do
        love.graphics.line(x, 0, x, self.height)
    end
    for y=0,self.height,self.grid.delta do
        love.graphics.line(0, y, self.width, y)
    end

    love.graphics.setLineWidth(0.5)
    for x=0,self.width,self.grid.delta/2 do
        love.graphics.line(x, 0, x, self.height)
    end
    for y=0,self.height,self.grid.delta/2 do
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
    if self.debug and self.intersection then
        love.graphics.setColor(0, 255, 0)
        love.graphics.line(self.intersection.a)
        love.graphics.setColor(0, 0, 255)
        love.graphics.line(self.intersection.b)
    end
end

-- update
function scene:updatePlayers(dt)
    for _,player in pairs(self.players) do
        player:update(dt)
    end
end

function doLinesIntersect(x1,y1, x2,y2, x3,y3, x4,y4)
    local intersect = false

    if x1 == x2 and x3 == x4
    or y1 == y2 and y3 == y4
    then
        -- if lines are parallel, no intersection!
    elseif x1 == x2 and y3 == y4 then
        intersect = (
                x3 < x1 and x1 < x4
                or
                x4 < x1 and x1 < x3
            ) and (
                y1 < y3 and y3 < y2
                or
                y2 < y3 and y3 < y1
            )
    elseif x3 == x4 and y1 == y2 then
        intersect = (
                x1 < x3 and x3 < x2
                or
                x2 < x3 and x3 < x1
            ) and (
                y3 < y1 and y1 < y4
                or
                y4 < y1 and y1 < y3
            )
    else
        print('You should never see this message')
    end

    if intersect then
        scene.intersection = {
            a = {x1,y1, x2,y2},
            b = {x3,y3, x4,y4},
            }
    end

    return intersect
end

function doesLineIntersectPlayerPaths(node, v1, v2)
    -- for every line in path,
    -- check intersection with player line
    while node and node.prev do
        local v3 = node.vector
        local v4 = node.prev.vector
        if doLinesIntersect(v1.x,v1.y, v2.x,v2.y, v3.x,v3.y, v4.x,v4.y) then
            return true
        end
        node = node.prev
    end
    return false
end

-- love collision handler
function collision(player)
    print(player..' crashed!')
    scene.paused = true
end
love.handlers.collision = collision

function scene:handleCollisions()
    -- calculate the last line for each player from current position
    -- check if line intersects any other path line
    -- if so, raise collision event for player
    -- only check last line for intersection, since all the rest should be ok
    for _,player in pairs(self.players) do
        local v1 = player.path.vector
        local v2 = player.path.prev.vector

        -- outside boundary
        if v1.x < 0 or v1.x > love.graphics.getWidth()
        or v1.y < 0 or v1.y > love.graphics.getHeight()
        then
            love.event.push('collision', tostring(player))
            break
        end

        -- inside boundary
        for _,player2 in pairs(self.players) do
            if doesLineIntersectPlayerPaths(player2.path, v1, v2) then
                love.event.push('collision', tostring(player))
                break
            end
        end
    end
end

function scene:update(dt)
    if not self.paused then
        self:updatePlayers(dt)
        self:handleCollisions()
    end
end

-- quit
function scene:quit()
    for _,player in pairs(self.players) do
        print(tostring(player)..' generated '.. #player.path / 2 .. ' path points')
    end
end

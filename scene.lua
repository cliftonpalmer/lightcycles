-- main

require 'vec2'
require 'player'


scene = {}
scene.width = love.graphics.getWidth()
scene.height = love.graphics.getHeight()
scene.players = {}
scene.grid = {}
scene.grid.bgcolor = {0.2, 0.2, 0.5}
scene.grid.linecolor = {0.3, 0.3, 0.6}
scene.grid.delta = 50

-- load
function scene:load()
    table.insert(scene.players, Player:new({
        position=vec2:new(100,100),
        vector=Player.vectors.right,
        path={},
        }))

    table.insert(scene.players, Player:new({
        position=vec2:new(self.width-100,self.height-100),
        vector=Player.vectors.left,
        path={},
        color={255, 255, 0},
        keys={
            up='up',
            down='down',
            left='left',
            right='right',
            }
        }))
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
end

-- update
function scene:updatePlayers(dt)
    for _,player in pairs(self.players) do
        player:update(dt)
    end
end

function scene:update(dt)
    self:updatePlayers(dt)
end

-- quit
function scene:quit()
    for i,player in pairs(self.players) do
        print('Player '..i..' generated '.. #player.path / 2 .. ' path points')
    end
end

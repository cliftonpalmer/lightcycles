-- player 2

require 'vec2'
require 'player'

local width = love.graphics.getWidth()
local height = love.graphics.getHeight()

return Player:new({
    name='Player 2',
    position=vec2:new(width-100,height-100),
    vector=Player.vectors.left,
    path={},
    color={255, 255, 0},
    keys={
        up='up',
        down='down',
        left='left',
        right='right',
        }
    })

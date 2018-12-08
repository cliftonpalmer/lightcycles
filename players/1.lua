-- player 1

require 'vec2'
require 'player'

return Player:new({
    position=vec2:new(100,100),
    vector=Player.vectors.right,
    path={},
    color={255, 0, 0},
    keys={
        w='up',
        s='down',
        a='left',
        d='right',
        }
    })

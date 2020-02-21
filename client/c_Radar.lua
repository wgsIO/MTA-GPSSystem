--setTimer(function() setPlayerHudComponentVisible("radar", false) end, 200, 1)
local map = MapFactory()
map:create(26, 205, 182, 164):prepare(8, 3072, 3072, 290, 175):setVisible(true)

local radar = RadarFactory()
radar:create(150, 700, 700, 600):prepare(12, 1800, 1800, 290, 175):setVisible(true)

--radar:create(150, 700, 700, 600)
--radar:prepare(12, 3072, 3072, 210, 162)
--radar:setRenderTarget(dxCreateRenderTarget(700, 600))
--dxCreateRenderTarget(rW or 210, rH or 162)
--radar:setVisible(true)


--[[local radar = MapFactory()
radar:create(100, 700, 780, 650)
radar:prepare(12, 3072, 3072, 780, 650)
radar:setVisible(true)]]

--MapFactory:create(x, y, w, h, type)

--[[

    local map = MapFactory()
    map:create(2, 193, 210, 161)
    map:prepare(12, 3072, 3072, 210, 161)
    map:setVisible(true)
]]



--[[local map = MapFactory()
map:create(-11, 162, 123, 138)
map:prepare(12, 3072, 3072, 123, 138)
map:setVisible(true)]]

--[[local map = MapFactory()
map:create(200, 700, 600, 300)
map:prepare(12, 3072, 3072, 600, 300)
map:setVisible(true)]]



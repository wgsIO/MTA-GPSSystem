local instances = {}
RadarFactory = class(function() end)

function RadarFactory:create(x, y, w, h, type)
    self.index = getLastIndex()
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.visible = false
    self.type = type or "map"
    instances[self.index] = self
    return self
end

function getLastIndex()
    local index = 1
    for id, map in pairs(instances) do
        if map.index >= index then index = map.index + 1 end
    end
    return index
end

function RadarFactory:prepare(bS, wW, wH, rW, rH)
    self.prepared = true
    self.wW = wW or 3072
    self.wH = wH or 3072
    self.target = dxCreateRenderTarget(rW or 210, rH or 162)
    local mW, mH = dxGetMaterialSize(self.target)
    self.mW = mW
    self.mH = mH
    self.bS = bS or 12
    instances[self.index] = self
    return self
end

function RadarFactory:destroy()
    instances[self.index] = nil
    self = nil
end

function setBlipSize(size) 
    self.bS = size or self.bS 
    instances[self.index] = self
    return self
end
function RadarFactory:getBlipSize() return self.bS end

function RadarFactory:setVisible(bool) 
    self.visible = bool
    instances[self.index] = self
    return self
end
function RadarFactory:isVisible() return self.visible end

function RadarFactory:setRenderTarget(target) 
    self.target = target
    local mW, mH = dxGetMaterialSize(self.target)
    self.mW = mW
    self.mH = mH
    instances[self.index] = self
    return self
end
function RadarFactory:getRenderTarget() return self.target end

function RadarFactory:setOwner(element)
    lp = element
    return self
end
function RadarFactory:getOwner() return lp end

function RadarFactory:setWorldSize(wW, wH) 
    self.wW = wW or self.wW
    self.wH = wH or self.wH
    instances[self.index] = self
    return self
end
function RadarFactory:getWorldSize() return self.wW, self.wH end

function RadarFactory:setMapPositions(x, y, w, h) 
    self.x = x or self.x
    self.y = y or self.y
    self.w = w or self.w
    self.h = h or self.h
    instances[self.index] = self
    return self
end
function RadarFactory:getWorldSize() return self.wW, self.wH end

function RadarFactory.draw()
    for id, map in pairs(instances) do
        if map.visible and map.prepared then
            local px, py = getElementPosition(lp)
            local _, _, rz = getElementRotation(lp)
            local _, _, cz = getElementRotation(getCamera())
            local mx, my = map.mW/2 - (px/(6000/map.wW)), map.mH/2 + (py/(6000/map.wH))
            dxSetRenderTarget(map.target, true)
                dxDrawRectangle(0, 0, map.mW, map.mH, tocolor(0, 132, 235))
                dxDrawImage(mx - map.wW/2, map.mH/5 + (my - map.wH/2), map.wW, map.wH, "images/map.png", cz, (px/(6000/map.wW)), -(py/(6000/map.wH)), tocolor(255, 255, 255, 255))
            dxSetRenderTarget()
            dxDrawImage(map.x*xF, sh-map.y*yF, map.w*xF, map.h*yF, map.target, 0, 0, 0, tocolor(255, 255, 255, 150))
            local lB = map.x*xF
            local rB = (map.x+map.w)*xF
            local tB = sh-(map.y)*yF
            local bB = tB + (map.h)*yF
            local cX, cY = (rB+lB)/2, (tB+bB)/2 +(35)*yF
            local tLt, tTp, tRt, tBm = cX-lB, cY-tB, rB-cX, bB-cY
            for id, blip in ipairs(getElementsByType("blip")) do
                local bx, by = getElementPosition(blip)
				local dbp = getDistanceBetweenPoints2D(px, py, bx, by)
                local mvd = getBlipVisibleDistance(blip)
                if dbp <= mvd and getElementInterior(blip) == getElementInterior(lp) then
                    local dist = dbp/(6000/((map.wW+map.wH)/2))
					local br = findRotation(bx, by, px, py)-cz
					local pdrx, pdry = getPointFromDistanceRotation(cX, cY, math.min(dist, math.sqrt(tTp^2 + tRt^2)), br)
					local bpx = math.max(lB, math.min(rB, pdrx))
                    local bpy = math.max(tB, math.min(bB, pdry))
                    local bS = getBlipSize(blip)
                    local bid = getBlipIcon(blip)
                    if bid > 0 then
                        dxDrawImage((bpx -(map.bS*bS)*xF/2), (bpy -(map.bS*bS)*yF/2), (map.bS*bS)*xF, (map.bS*bS)*yF, "images/blips/"..bid..".png")
                    end
                end
            end
            dxDrawImage(cX -(map.bS*2)*xF/2, cY -(map.bS*2)*yF/2, (map.bS*2)*xF-5, (map.bS*2)*yF-5, "images/player.png", cz-rz, 0, 0)
        end
    end
end
addEventHandler ( "onClientRender", getRootElement(), RadarFactory.draw)

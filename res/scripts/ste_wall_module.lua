local func = require "ste/func"
local coor = require "ste/coor"
local pipe = require "ste/pipe"
local general = require "ste/general"
local ste = require "ste"
local mType = "ste_wall"

local fitModels = {
    wall = ste.fitModel(0.5, 5, -15, true, true),
    fence = ste.fitModel(0.5, 5, 1, true, true)
}

local buildWall = ste.buildSurface(fitModels.wall, coor.scaleZ(15))
local buildFence = ste.buildSurface(fitModels.fence, coor.transZ(1))

local dump = require "luadump"
return function(wallWidth, desc, order)
    return function()
        return {
            availability = {
                yearFrom = 0,
                yearTo = 0,
            },
            buildMode = "SINGLE",
            cost = {
                price = 5000,
            },
            description = desc,
            category = {
                categories = {"track"},
            },
            type = mType,
            order = {
                value = order,
            },
            metadata = {
                isTrack = false,
                width = wallWidth,
                type = mType
            },
            
            updateFn = function(result, transform, tag, slotId, addModelFn, params)
                local withTag = general.withTag(tag)
                local info = ste.slotInfo(slotId)
                
                local nSeg = result.config.coords[info.pos.x].wall.nSeg
                if info.pos.y >= nSeg then return end
                
                local biLatCoords = result.config.coords[info.pos.x].wall.biLatCoords

                if (not result.config.coords[info.pos.x].wall.base) then
                    local lc, rc = biLatCoords(-wallWidth * 0.5, wallWidth * 0.5)
                    result.config.coords[info.pos.x].wall.base = { lc = ste.interlace(lc), rc = ste.interlace(rc) }
                end

                local lc = result.config.coords[info.pos.x].wall.base.lc[info.pos.y + 1]
                local rc = result.config.coords[info.pos.x].wall.base.rc[info.pos.y + 1]

                local wall = buildWall()(info.pos.y, "ste/concrete_wall", lc, rc) * withTag
                local fence = buildFence()(info.pos.y, "ste/concrete_wall", lc, rc) * withTag

                result.models = result.models + wall + fence
            end,
            
            getModelsFn = function(params)
                return {}
            end
        }
    
    end
end

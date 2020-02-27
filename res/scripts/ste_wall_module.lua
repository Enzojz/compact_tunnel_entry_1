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

local wallTypes = {
    "ste/concrete_wall",
    "ste/brick_wall",
    "ste/brick_2_wall"
}

local dump = require "luadump"
return function(modelWall, modelFence, wallWidth, desc, order)
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
                categories = {_("STRUCTURE")},
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
                local modelWall = modelWall or wallTypes[params.wallType + 1]
                local modelFence = modelFence or wallTypes[params.wallType + 1]
                local withTag = general.withTag(tag)
                local info = ste.slotInfo(slotId)
                
                if info.pos.y > 0 then return end
                local nSeg = result.config.coords[info.pos.x].wall.nSeg
                -- if info.pos.y >= nSeg then return end
                
                local posMark = result.config.posMark[info.pos.x].surface
                posMark = posMark and posMark.y or nSeg
                if posMark > nSeg then posMark = nSeg end

                local biLatCoords = result.config.coords[info.pos.x].wall.biLatCoords

                if (not result.config.coords[info.pos.x].wall.base) then
                    local lc, rc = biLatCoords(-wallWidth * 0.5, wallWidth * 0.5)
                    result.config.coords[info.pos.x].wall.base = { lc = ste.interlace(lc), rc = ste.interlace(rc) }
                end

                for i = 1, posMark do
                    local lc = result.config.coords[info.pos.x].wall.base.lc[i]
                    local rc = result.config.coords[info.pos.x].wall.base.rc[i]

                    local wall = buildWall()(nil, modelWall, lc, rc) * withTag
                    local fence = buildFence()(nil, modelFence, lc, rc) * withTag

                    result.models = result.models + wall + fence
                end
            end,
            
            getModelsFn = function(params)
                return {}
            end
        }
    
    end
end

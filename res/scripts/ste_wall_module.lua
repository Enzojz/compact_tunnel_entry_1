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
                local refArc = result.arcs[info.pos.x].surface
                
                local nSeg, baseL, baseR = ste.biLatCoords(5, refArc)(-wallWidth * 0.5, wallWidth * 0.5)
                local buildWall = ste.buildSurface(fitModels.wall, coor.scaleZ(15))
                local buildFence = ste.buildSurface(fitModels.fence, coor.transZ(1))
                
                local walls = pipe.new
                * pipe.mapn(
                    func.seq(1, nSeg),
                    pipe.rep(nSeg)("ste/concrete_wall"),
                    ste.interlace(baseL),
                    ste.interlace(baseR)
                )(buildWall())
                * pipe.flatten()
                
                local fence = pipe.new
                * pipe.mapn(
                    func.seq(1, nSeg),
                    pipe.rep(nSeg)("ste/concrete_wall"),
                    ste.interlace(baseL),
                    ste.interlace(baseR)
                )(buildFence())
                * pipe.flatten()

                result.models = result.models + walls + fence
                
            end,
            
            getModelsFn = function(params)
                return {}
            end
        }
    
    end
end

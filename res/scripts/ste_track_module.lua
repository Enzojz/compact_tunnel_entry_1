local func = require "ste/func"
local coor = require "ste/coor"
local pipe = require "ste/pipe"
local general = require "ste/general"
local ste = require "ste"
local dump = require "luadump"
local mType = "ste_track"


local fitModels = {
    surface = ste.fitModel(5, 5, -1, true, true),
    fence = ste.fitModel(5, 0.5, 1, true, true)
}


return function(trackWidth, trackType, catenary, desc, order)
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
                isTrack = true,
                width = trackWidth,
                type = mType
            },
            
            updateFn = function(result, transform, tag, slotId, addModelFn, params)
                local withTag = general.withTag(tag)
                local info = ste.slotInfo(slotId)
                local isUnderground = info.typeId == 2
                local isSurface = info.typeId == 1
                local refArc = isUnderground and result.arcs[info.pos.x].underground or result.arcs[info.pos.x].surface
                local edge = pipe.new
                    * refArc()
                    * ste.arc2Edges
                    * pipe.map(pipe.map(coor.vec2Tuple))
                
                if isSurface then
                    local nSeg, baseL, baseR = ste.biLatCoords(5, refArc)(-trackWidth * 0.5 - 0.35, trackWidth * 0.5 + 0.35)
                    local poly = ste.terrain(ste.interlace(baseL), ste.interlace(baseR))
                    for _, f in ipairs(poly) do
                        table.insert(result.groundFaces, {face = f, modes = {{type = "FILL", key = "hole.lua"}}})
                    end
                    
                    local buildSurface = ste.buildSurface(fitModels.surface, coor.I())
                    
                    local surfaces = pipe.new
                        * pipe.mapn(
                            func.seq(1, nSeg),
                            pipe.rep(nSeg)("ste/surface"),
                            ste.interlace(baseL),
                            ste.interlace(baseR)
                        )(buildSurface())
                        * pipe.flatten()

                    result.models = result.models + surfaces
                end
                
                
                if isUnderground then
                    local poly = func.map({
                        coor.xyz(-3, 0, 0) .. transform,
                        coor.xyz(-3, 15, 0) .. transform,
                        coor.xyz(3, 15, 0) .. transform,
                        coor.xyz(3, 0, 0) .. transform
                    }, coor.vec2Tuple)
                    
                    table.insert(result.groundFaces,
                        {
                            face = poly,
                            modes = {
                                { type = "FILL", key = "paving_sup.lua" }
                            }
                        })
                end
                
                if (info.pos.y == 0 and isUnderground and #result.edgeLists > 0) then
                    local lastEdge = result.edgeLists[#result.edgeLists]
                    if (lastEdge.slotId == slotId - 1) then
                        edge[1][1] = lastEdge.edges[1][1]
                    end
                end
                
                
                local edges = {
                    type = "TRACK",
                    alignTerrain = not isSurface,
                    params = {
                        type = trackType,
                        catenary = catenary,
                    },
                    edgeType = isUnderground and "TUNNEL" or nil,
                    edgeTypeName = isUnderground and "ste_void.lua" or nil,
                    edges = edge,
                    snapNodes = {3},
                    tag2nodes = {
                        [tag] = {0, 1, 2, 3}
                    },
                    slotId = slotId
                }
                
                table.insert(result.edgeLists, edges)
                
                if (isSurface) then
                    local buildFence = ste.buildSurface(fitModels.fence, coor.scaleZ(2) * coor.transZ(1))
                    local fences = buildFence()(
                        50,
                        "ste/concrete_fence",
                        {s = coor.xyz(-2.5, 0, 0) .. transform, i = coor.xyz(-2.5, -0.5, 0) .. transform},
                        {s = coor.xyz(2.5, 0, 0) .. transform, i = coor.xyz(2.5, -0.5, 0) .. transform}
                    )
                    result.models = result.models + fences
                end
            end,
            
            getModelsFn = function(params)
                return {}
            end
        }
    
    end
end

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
                
                local nSeg = isUnderground and result.config.coords[info.pos.x].underground.nSeg or isSurface and result.config.coords[info.pos.x].surface.nSeg
                if nSeg <= info.pos.y then return end
                
                if not (isUnderground and result.config.coords[info.pos.x].underground.edge or isSurface and result.config.coords[info.pos.x].surface.edge) then
                    local refArc = isUnderground and result.config.arcs[info.pos.x].underground or isSurface and result.config.arcs[info.pos.x].surface
                    local edgeArc = refArc()
                    local segLength = edgeArc:length() / nSeg
                    
                    local edge = pipe.new * func.seq(0, nSeg)
                        * pipe.map(function(n)
                            return {
                                edgeArc:pt(edgeArc.inf + (edgeArc.sup - edgeArc.inf) * n / nSeg),
                                edgeArc:tangent(edgeArc.inf + (edgeArc.sup - edgeArc.inf) * n / nSeg) * segLength
                            }
                        end)
                        * pipe.map(pipe.map(coor.vec2Tuple))
                        * pipe.interlace()
                    
                    if isUnderground then
                        result.config.coords[info.pos.x].underground.edge = edge
                        if result.config.coords[info.pos.x].surface.edge then
                            result.config.coords[info.pos.x].underground.edge[1][1][1] = result.config.coords[info.pos.x].surface.edge[1][1][1]
                        end
                    else
                        result.config.coords[info.pos.x].surface.edge = edge
                        if result.config.coords[info.pos.x].underground.edge then
                            result.config.coords[info.pos.x].surface.edge[1][1][1] = result.config.coords[info.pos.x].underground.edge[1][1][1]
                        end
                    end
                end
                
                local edges = {
                    type = "TRACK",
                    alignTerrain = false,
                    params = {
                        type = trackType,
                        catenary = catenary,
                    },
                    edgeType = isUnderground and "TUNNEL" or nil,
                    edgeTypeName = isUnderground and "ste_void.lua" or nil,
                    edges = (isUnderground and result.config.coords[info.pos.x].underground.edge or isSurface and result.config.coords[info.pos.x].surface.edge)[nSeg - info.pos.y],
                    snapNodes = {},
                    tag2nodes = {
                        [tag] = {0, 1}
                    },
                    slot = slotId
                }
                
                table.insert(result.edgeLists, edges)
                
                if isSurface then
                    local biLatCoords = result.config.coords[info.pos.x].surface.biLatCoords
                    
                    if (not result.config.coords[info.pos.x].surface.ground) then
                        local lc, rc = biLatCoords(-trackWidth * 0.5 - 0.35, trackWidth * 0.5 + 0.35)
                        result.config.coords[info.pos.x].surface.ground = {lc = ste.interlace(lc), rc = ste.interlace(rc)}
                    end
                    local polyL = result.config.coords[info.pos.x].surface.ground.lc[nSeg - info.pos.y]
                    local polyR = result.config.coords[info.pos.x].surface.ground.rc[nSeg - info.pos.y]
                    local size = ste.assembleSize(polyL, polyR)
                    table.insert(result.groundFaces, {
                        face = func.map({size.lt, size.lb, size.rb, size.rt}, coor.vec2Tuple),
                        modes = {{type = "FILL", key = "hole.lua"}}
                    })
                    
                    if (not result.config.coords[info.pos.x].surface.base) then
                        local lc, rc = biLatCoords(-trackWidth * 0.5, trackWidth * 0.5)
                        result.config.coords[info.pos.x].surface.base = {lc = ste.interlace(lc), rc = ste.interlace(rc)}
                    end
                    
                    local baseL = result.config.coords[info.pos.x].surface.base.lc[nSeg - info.pos.y]
                    local baseR = result.config.coords[info.pos.x].surface.base.rc[nSeg - info.pos.y]
                    local buildSurface = ste.buildSurface(fitModels.surface, coor.I())
                    
                    local surface = buildSurface()(info.pos.y, "ste/surface", baseL, baseR) * withTag
                    result.models = result.models + surface
                    
                    if info.pos.y == result.config.min[info.pos.x].surface then
                        local buildFence = ste.buildSurface(fitModels.fence, coor.scaleZ(2) * coor.transZ(1))
                        
                        local biLatCoords = result.config.coords[info.pos.x].wall.biLatCoords
                        local lc, rc = biLatCoords(-trackWidth * 0.5, trackWidth * 0.5)

                        local fences = buildFence()(
                            50,
                            "ste/concrete_fence",
                            {s = lc[1], i = lc[1] + (lc[2] - lc[1]):normalized() * 0.5},
                            {s = rc[1], i = rc[1] + (rc[2] - rc[1]):normalized() * 0.5}
                        )
                        result.models = result.models + fences
                    end
                    
                    if (not result.config.coords[info.pos.x].surface.top) then
                        local biLatCoords = result.config.coords[info.pos.x].wall.biLatCoords
                        local lc, rc = biLatCoords(-trackWidth * 0.5 - 1, trackWidth * 0.5 + 1)
                        result.config.coords[info.pos.x].surface.top = {lc = lc, rc = rc}
                    end
                end

                if isUnderground then
                    if (not result.config.coords[info.pos.x].underground.top) then
                        local biLatCoords = result.config.coords[info.pos.x].underground.biLatCoords
                        local lc, rc = biLatCoords(-trackWidth * 0.5 - 1, trackWidth * 0.5 + 1)
                        result.config.coords[info.pos.x].underground.top = {
                            lc = func.map(lc, function(c) return c + coor.xyz(0, 0, 8.5) end), 
                            rc = func.map(rc, function(c) return c + coor.xyz(0, 0, 8.5) end)
                        }
                    end
                end
                
            end,
            
            getModelsFn = function(params)
                return {}
            end
        }
    
    end
end

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

local wallTypes = {
    "ste/concrete_fence",
    "ste/brick_fence",
    "ste/brick_2_fence"
}

return function(trackWidth, trackType, catenary, desc, order, isStreet)
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
                categories = {isStreet and _("STREET") or _("TRACK")},
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
                local config = result.config
                local coords = config.coords[info.pos.x]
                local arcs = config.arcs[info.pos.x]
                
                if info.pos.y > 0 then return end

                local isSurface = info.typeId == 1
                local isUnderground = info.typeId == 2
                local isParallel = info.typeId == 3
                
                local nSeg = isUnderground and coords.underground.nSeg or isSurface and coords.surface.nSeg or isParallel and coords.surface.nSeg
                local segLength = isUnderground and coords.underground.segLength or isSurface and coords.surface.segLength or isParallel and coords.surface.segLength
                
                local posMark = config.posMark[info.pos.x] and (isUnderground and config.posMark[info.pos.x].underground or (isSurface or isParallel) and config.posMark[info.pos.x].surface)
                
                posMark = posMark and posMark.y or nSeg
                if posMark > nSeg then posMark = nSeg end

                if not (isUnderground and coords.underground.edge or isSurface and coords.surface.edge or isParallel and coords.surface.edge) then
                    local refArc = isUnderground and arcs.underground or isSurface and arcs.surface or isParallel and arcs.top
                    local edgeArc = refArc()
                    
                    local edge = pipe.new * func.seq(0, nSeg * 2)
                        * pipe.map(function(n)
                            local rad = edgeArc.inf + (edgeArc.sup - edgeArc.inf) * n * 0.5 / nSeg
                            local pt = edgeArc:pt(rad)
                            local nor = edgeArc:tangent(rad)
                            return function(length) return {pt, nor * length} end
                        end)
                        * pipe.interlace()
                    
                    if isUnderground then
                        coords.underground.edge = edge
                        if coords.surface.edge then
                            local ref = coords.underground.edge[1][1]
                            coords.underground.edge[1][1] = function(length) return { coords.surface.edge[1][1](length)[1], ref(length)[2] } end
                        end
                    elseif isSurface then
                        coords.surface.edge = edge
                        if coords.underground.edge then
                            local ref = coords.underground.edge[1][1]
                            coords.surface.edge[1][1] = function(length) return { coords.underground.edge[1][1](length)[1], ref(length)[2] } end
                        end
                    else
                        coords.surface.edge = edge
                    end
                end
                
                local edge = 
                    (isUnderground and coords.underground.edge or isSurface and coords.surface.edge or isParallel and coords.surface.edge)
                    * function(e) return {e[1][1], e[posMark][2], e[posMark][2], e[posMark * 2][2]} end
                    * pipe.map(function(f) return f(posMark * segLength * 0.5) end)
                    * pipe.map(pipe.map(coor.vec2Tuple))
                
                local edges = {
                    type = isStreet and "STREET" or "TRACK",
                    alignTerrain = isParallel,
                    params = {
                        type = trackType,
                        catenary = catenary,
                    },
                    edgeType = isUnderground and "TUNNEL" or nil,
                    edgeTypeName = isUnderground and "ste_void.lua" or nil,
                    edges = edge,
                    snapNodes = isParallel and {0, 3} or {3},
                    tag2nodes = {
                        [tag] = {0, 1, 2, 3}
                    },
                    slot = slotId
                }
                
                table.insert(result.edgeLists, edges)
                
                if isSurface then
                    local biLatCoords = coords.surface.biLatCoords
                    
                    if (not coords.surface.ground) then
                        local lc, rc = biLatCoords(-trackWidth * 0.5 - 0.35, trackWidth * 0.5 + 0.35)
                        coords.surface.ground = {lc = ste.interlace(lc), rc = ste.interlace(rc)}
                    end

                    for i = 1, posMark do
                        local polyL = coords.surface.ground.lc[i]
                        local polyR = coords.surface.ground.rc[i]
                        local size = ste.assembleSize(polyL, polyR)
                        table.insert(result.groundFaces, {
                            face = func.map({size.lt, size.lb, size.rb, size.rt}, coor.vec2Tuple),
                            modes = {{type = "FILL", key = "hole.lua"}}
                        })
                    end
                    
                    if (not coords.surface.base) then
                        local lc, rc = biLatCoords(-trackWidth * 0.5, trackWidth * 0.5)
                        coords.surface.base = {lc = ste.interlace(lc), rc = ste.interlace(rc)}
                    end
                    
                    if (not isStreet) then
                        for i = 1, posMark do
                            local baseL = coords.surface.base.lc[i]
                            local baseR = coords.surface.base.rc[i]
                            local buildSurface = ste.buildSurface(fitModels.surface, coor.I())
                            
                            local surface = buildSurface()(nil, "ste/surface", baseL, baseR) * withTag
                            result.models = result.models + surface
                        end
                    end

                    local buildFence = ste.buildSurface(fitModels.fence, coor.scaleZ(2) * coor.transZ(1))
                    
                    local biLatCoords = coords.top.biLatCoords
                    local lc, rc = biLatCoords(-trackWidth * 0.5, trackWidth * 0.5)

                    local fences = buildFence()(
                        nil,
                        wallTypes[params.wallType + 1],
                        {s = lc[1], i = lc[1] + (lc[2] - lc[1]):normalized() * 0.5},
                        {s = rc[1], i = rc[1] + (rc[2] - rc[1]):normalized() * 0.5}
                    )
                    result.models = result.models + withTag(fences)
                    
                    if (not coords.surface.top) then
                        local biLatCoords = coords.top.biLatCoords
                        local lc, rc = biLatCoords(-trackWidth * 0.5 - 1, trackWidth * 0.5 + 1)
                        coords.surface.top = {lc = lc, rc = rc}
                    end
                elseif isParallel then
                    if (not coords.surface.top) then
                        local biLatCoords = coords.top.biLatCoords
                        local lc, rc = biLatCoords(-trackWidth * 0.5 - 1, trackWidth * 0.5 + 1)
                        coords.surface.top = {lc = lc, rc = rc}
                    end
                elseif isUnderground then
                    if (not coords.underground.top) then
                        local biLatCoords = coords.underground.biLatCoords
                        local lc, rc = biLatCoords(-trackWidth * 0.5 - 1, trackWidth * 0.5 + 1)
                        coords.underground.top = {
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

local func = require "ste/func"
local coor = require "ste/coor"
local arc = require "ste/coorarc"
local general = require "ste/general"
local pipe = require "ste/pipe"
local dump = require "luadump"

local ste = {}

local math = math
local pi = math.pi
local abs = math.abs
local ceil = math.ceil
local floor = math.floor
local unpack = table.unpack

local segmentLength = 20

ste.slotInfo = function(slotId)
        -- Pos.x : track pos
        -- Pos.y : n module to the origin
        -- TypeId :
        --    1. Track
        --    2. Underground Track
        --    3. Wall
        --    4. Flat track
        local typeId = slotId % 10
        local d24 = (slotId - typeId) / 10
        local pos = d24
        local posY = pos % 100
        local posX = (pos - posY) / 100
        return {
            pos = coor.xy(posX, posY),
            typeId = typeId
        }
end

ste.arc2Edges = function(arc)
    local extLength = 2
    local extArc = arc:extendLimits(-extLength)
    local length = arc.r * abs(arc.sup - arc.inf)
    
    local sup = arc:pt(arc.sup)
    local inf = arc:pt(arc.inf)
    
    local supExt = arc:pt(extArc.sup)
    local vecSupExt = arc:tangent(extArc.sup)
    
    local vecSup = arc:tangent(arc.sup)
    local vecInf = arc:tangent(arc.inf)
    return {
        {inf, vecInf * (length - extLength)},
        {supExt, vecSupExt * (length - extLength)},
        {supExt, vecSupExt * extLength},
        {sup, vecSup * extLength}
    }
end

ste.arcPacker = function(length, radius, fz, fs)
    local o = coor.xyz(radius, 0, 0)
    local initRad = (radius > 0 and pi or 0)
    local finalRad = initRad + length / radius
    local fs = fs(initRad, finalRad)
    local fz = fz(initRad, finalRad)
    return function(dR)
        local radius = radius - dR
        return function(xDr)
            local dr = xDr or 0
            local ar = arc.byOR(o + coor.xyz(0, 0, 0), abs(radius - dr))
            return ar:withLimits({
                inf = initRad,
                sup = finalRad,
                fs = fs,
                fz = fz
            })
        end
    end
end

ste.biLatCoords = function(length, arc)
    local arcRef = arc()
    local nSeg = arcRef:length() / length
    nSeg = (nSeg < 1 or (nSeg % 1 > 0.5)) and ceil(nSeg) or floor(nSeg)
    local lRad = (arcRef.sup - arcRef.inf) / nSeg
    local listRad = func.seqMap({0, nSeg}, function(n) return arcRef.inf + n * lRad end)
    return function(...)
        return unpack(func.map({...}, function(o)
            local refArc = arc(o)
            return func.map(listRad, function(rad) return refArc:pt(rad) end)
        end))
    end, nSeg, arcRef:length() / nSeg
end

ste.assembleSize = function(lc, rc)
    return {
        lb = lc.i,
        lt = lc.s,
        rb = rc.i,
        rt = rc.s
    }
end

local function mul(m1, m2)
    local m = function(line, col)
        local l = (line - 1) * 3
        return m1[l + 1] * m2[col + 0] + m1[l + 2] * m2[col + 3] + m1[l + 3] * m2[col + 6]
    end
    return {
        m(1, 1), m(1, 2), m(1, 3),
        m(2, 1), m(2, 2), m(2, 3),
        m(3, 1), m(3, 2), m(3, 3),
    }
end

ste.fitModel2D = function(w, h, zOffset, fitTop, fitLeft)
    local s = {
        {
            coor.xy(0, 0),
            coor.xy(fitLeft and w or -w, 0),
            coor.xy(0, fitTop and -h or h),
        },
        {
            coor.xy(0, 0),
            coor.xy(fitLeft and -w or w, 0),
            coor.xy(0, fitTop and h or -h),
        }
    }
    
    local mX = func.map(s,
        function(s) return {
            {s[1].x, s[1].y, 1},
            {s[2].x, s[2].y, 1},
            {s[3].x, s[3].y, 1},
        }
        end)
    
    local mXI = func.map(mX, coor.inv3)
    
    local fitTop = {fitTop, not fitTop}
    local fitLeft = {fitLeft, not fitLeft}

    return function(size, mode)
        local mXI = mXI[mode and 1 or 2]
        local fitTop = fitTop[mode and 1 or 2]
        local fitLeft = fitLeft[mode and 1 or 2]
        local t = fitTop and
            {
                fitLeft and size.lt or size.rt,
                fitLeft and size.rt or size.lt,
                fitLeft and size.lb or size.rb,
            } or {
                fitLeft and size.lb or size.rb,
                fitLeft and size.rb or size.lb,
                fitLeft and size.lt or size.rt,
            }
        
        local mU = {
            t[1].x, t[1].y, 1,
            t[2].x, t[2].y, 1,
            t[3].x, t[3].y, 1,
        }
        
        local mXi = mul(mXI, mU)
        
        return coor.I() * {
            mXi[1], mXi[2], 0, mXi[3],
            mXi[4], mXi[5], 0, mXi[6],
            0, 0, 1, 0,
            mXi[7], mXi[8], 0, mXi[9]
        } * coor.transZ(zOffset)
    end
end

ste.fitModel = function(w, h, d, fitTop, fitLeft)
    local s = {
        {
            coor.xyz(0, 0, 0),
            coor.xyz(fitLeft and w or -w, 0, 0),
            coor.xyz(0, fitTop and -h or h, 0),
            coor.xyz(0, 0, d)
        },
        {
            coor.xyz(0, 0, 0),
            coor.xyz(fitLeft and -w or w, 0, 0),
            coor.xyz(0, fitTop and h or -h, 0),
            coor.xyz(0, 0, d)
        },
    }
    
    local mX = func.map(s, function(s)
        return {
            {s[1].x, s[1].y, s[1].z, 1},
            {s[2].x, s[2].y, s[2].z, 1},
            {s[3].x, s[3].y, s[3].z, 1},
            {s[4].x, s[4].y, s[4].z, 1}
        }
    end)
    
    local mXI = func.map(mX, coor.inv)
    
    local fitTop = {fitTop, not fitTop}
    local fitLeft = {fitLeft, not fitLeft}
    
    return function(size, mode)
        local mXI = mXI[mode and 1 or 2]
        local fitTop = fitTop[mode and 1 or 2]
        local fitLeft = fitLeft[mode and 1 or 2]
        local t = fitTop and
            {
                fitLeft and size.lt or size.rt,
                fitLeft and size.rt or size.lt,
                fitLeft and size.lb or size.rb,
            } or {
                fitLeft and size.lb or size.rb,
                fitLeft and size.rb or size.lb,
                fitLeft and size.lt or size.rt,
            }
        local mU = {
            t[1].x, t[1].y, t[1].z, 1,
            t[2].x, t[2].y, t[2].z, 1,
            t[3].x, t[3].y, t[3].z, 1,
            t[1].x, t[1].y, t[1].z + d, 1
        }
        
        return mXI * mU
    end
end

ste.interlace = pipe.interlace({"s", "i"})

ste.buildSurface = function(fitModel, tZ)
    return function(fnSize)
        local fnSize = fnSize or function(_, lc, rc) return ste.assembleSize(lc, rc) end
        return function(i, s, ...)
            local sizeS = fnSize(i, ...)
            return s
                and pipe.new
                / func.with(general.newModel(s .. "_tl.mdl", tZ, fitModel(sizeS, true)), {pos = i})
                / func.with(general.newModel(s .. "_br.mdl", tZ, fitModel(sizeS, false)), {pos = i})
                or pipe.new * {}
        end
    end
end

ste.terrain = function(lc, rc)
    return pipe.mapn(lc, rc)(function(lc, rc)
        local size = ste.assembleSize(lc, rc)
        return func.map({size.lt, size.lb, size.rb, size.rt}, coor.vec2Tuple)
    end)
end

ste.safeBuild = function(params, updateFn)
    local defaultParams = ste.defaultParams(params)
    local paramsOnFail = params() *
        pipe.mapPair(function(i) return i.key, i.defaultIndex or 0 end)
    
    return function(param)
        local r, result = xpcall(
            updateFn,
            function(e)
                print("========================")
                print("Ultimate Station failure")
                print("Algorithm failure:", debug.traceback())
                print("Params:")
                func.forEach(
                    params() * pipe.filter(function(i) return param[i.key] ~= (i.defaultIndex or 0) end),
                    function(i)print(i.key .. ": " .. param[i.key]) end)
                print("End of Ultimate Station failure")
                print("========================")
            end,
            defaultParams(param)
        )
        return r and result or updateFn(defaultParams(paramsOnFail))
    -- return updateFn(defaultParams(param))
    end
end

return ste

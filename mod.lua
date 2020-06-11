local dump = require "luadump"

local nameIndices = {
    ["standard.lua"] = "std",
    ["high_speed.lua"] = "hs",
}

function data()
    return {
        info = {
            minorVersion = 2,
            severityAdd = "NONE",
            severityRemove = "CRITICAL",
            name = _("MOD_NAME"),
            description = _("MOD_DESC"),
            authors = {
                {
                    name = "Enzojz",
                    role = "CREATOR",
                    text = "Idea, Scripting, Modeling, Texturing",
                    steamProfile = "enzojz",
                    tfnetId = 27218,
                }
            },
            tags = {"Street Construction", "Tunnel", "Station", "Train Station", "Track Asset"},
        }, 
        postRunFn = function(settings, params)
            local tracks = api.res.trackTypeRep.getAll()
            for __, trackName in pairs(tracks) do
                local track = api.res.trackTypeRep.get(api.res.trackTypeRep.find(trackName))
                for __, catenary in pairs({false, true}) do
                    local mod = api.type.ModuleDesc.new()
                    mod.fileName = "ste/tracks/" .. (nameIndices[trackName] or tostring(trackName)) .. (catenary and "_catenary" or "") .. ".module"
                    
                    mod.availability.yearFrom = track.yearFrom
                    mod.availability.yearTo = track.yearTo
                    mod.cost.price = math.round(track.cost / 75 * 18000)
                    
                    mod.description.name = track.name .. (catenary and _(" with catenary") or "")
                    mod.description.description = track.desc .. (catenary and _(" (with catenary)") or "")
                    mod.description.icon = track.icon
                    
                    mod.type = "ste_track"
                    mod.order.value = 0 + 10 * (catenary and 1 or 0)
                    mod.metadata = {
                        isTrack = true,
                        width = track.trackDistance,
                        type = "ste_track"
                    }

                    mod.category.categories = catenary and {_("TRACK_CAT")} or {_("TRACK")}

                    mod.updateScript.fileName = "construction/ste/trackmodule.updateFn"
                    mod.updateScript.params = {
                        trackType = trackName,
                        catenary = catenary,
                        width = track.trackDistance
                    }
                    mod.getModelsScript.fileName = "construction/ste/trackmodule.getModelsFn"
                    mod.getModelsScript.params = {}
                    
                    api.res.moduleRep.add(mod.fileName, mod, true)
                end
            end

            
            -- local streets = api.res.streetTypeRep.getAll()
            -- dump()(streets)
            -- for __, streetName in pairs(streets) do
            --     local street = api.res.streetTypeRep.get(api.res.streetTypeRep.find(streetName))
            --     if (#street.categories > 0) then
            --         local mod = api.type.ModuleDesc.new()
            --         for i = 1, #street.laneConfigs do
            --         end
            --     else
            --     end
            -- end
        end
    }
end

-- local dump = require "luadump"
local func = require "ste/func"

local trackIndices = {
    ["standard.lua"] = "std",
    ["high_speed.lua"] = "hs",
}

local streetIndices = {
    ["ste/streets/standard/country_large_new.module"] = "ste/streets/country_large_new.module",
    ["ste/streets/standard/country_large_old.module"] = "ste/streets/country_large_old.module",
    ["ste/streets/standard/country_large_one_way_new.module"] = "ste/streets/country_large_one_way_new.module",
    ["ste/streets/standard/country_large_one_way_new_rev.module"] = "ste/streets/country_large_one_way_new_rev.module",
    ["ste/streets/standard/country_medium_new.module"] = "ste/streets/country_medium_new.module",
    ["ste/streets/standard/country_medium_old.module"] = "ste/streets/country_medium_old.module",
    ["ste/streets/standard/country_medium_one_way_new.module"] = "ste/streets/country_medium_one_way_new.module",
    ["ste/streets/standard/country_medium_one_way_new_rev.module"] = "ste/streets/country_medium_one_way_new_rev.module",
    ["ste/streets/standard/country_small_new.module"] = "ste/streets/country_small_new.module",
    ["ste/streets/standard/country_small_old.module"] = "ste/streets/country_small_old.module",
    ["ste/streets/standard/country_small_one_way_new.module"] = "ste/streets/country_small_one_way_new.module",
    ["ste/streets/standard/country_small_one_way_new_rev.module"] = "ste/streets/country_small_one_way_new_rev.module",
    ["ste/streets/standard/country_x_large_new.module"] = "ste/streets/country_x_large_new.module",
    ["ste/streets/standard/town_large_new.module"] = "ste/streets/town_large_new.module",
    ["ste/streets/standard/town_large_old.module"] = "ste/streets/town_large_old.module",
    ["ste/streets/standard/town_large_one_way_new.module"] = "ste/streets/town_large_one_way_new.module",
    ["ste/streets/standard/town_large_one_way_new_rev.module"] = "ste/streets/town_large_one_way_new_rev.module",
    ["ste/streets/standard/town_medium_new.module"] = "ste/streets/town_medium_new.module",
    ["ste/streets/standard/town_medium_old.module"] = "ste/streets/town_medium_old.module",
    ["ste/streets/standard/town_medium_one_way_new.module"] = "ste/streets/town_medium_one_way_new.module",
    ["ste/streets/standard/town_medium_one_way_new_rev.module"] = "ste/streets/town_medium_one_way_new_rev.module",
    ["ste/streets/standard/town_small_new.module"] = "ste/streets/town_small_new.module",
    ["ste/streets/standard/town_small_old.module"] = "ste/streets/town_small_old.module",
    ["ste/streets/standard/town_small_one_way_new.module"] = "ste/streets/town_small_one_way_new.module",
    ["ste/streets/standard/town_small_one_way_new_rev.module"] = "ste/streets/town_small_one_way_rev.module",
    ["ste/streets/standard/town_x_large_new.module"] = "ste/streets/town_x_large_new.module"
}

function data()
    return {
        info = {
            minorVersion = 3,
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
                    mod.fileName = ("ste/tracks/%s%s.module"):format(trackIndices[trackName] or trackName, catenary and "_catenary" or "")
                    
                    mod.availability.yearFrom = track.yearFrom
                    mod.availability.yearTo = track.yearTo
                    mod.cost.price = 0
                    
                    mod.description.name = track.name .. (catenary and _(" with catenary") or "")
                    mod.description.description = track.desc .. (catenary and _(" (with catenary)") or "")
                    mod.description.icon = track.icon
                    
                    mod.type = "ste_track"
                    mod.order.value = trackIndices[trackName] and 0 or 100
                    mod.metadata = {
                        isTrack = true,
                        width = track.trackDistance,
                        type = "ste_track"
                    }
                    
                    mod.category.categories = catenary and {_("TRACK_CAT")} or {_("TRACK")}
                    
                    mod.updateScript.fileName = "construction/ste/ste_track_module.updateFn"
                    mod.updateScript.params = {
                        trackType = trackName,
                        catenary = catenary,
                        width = track.trackDistance
                    }
                    mod.getModelsScript.fileName = "construction/ste/ste_track_module.getModelsFn"
                    mod.getModelsScript.params = {}
                    
                    api.res.moduleRep.add(mod.fileName, mod, true)
                end
            end
            
            local streets = api.res.streetTypeRep.getAll()
            for __, streetName in pairs(streets) do
                local street = api.res.streetTypeRep.get(api.res.streetTypeRep.find(streetName))
                if (#street.categories > 0 and not streetName:match("street_depot/") and not streetName:match("street_station/")) then
                    local nBackward = #func.filter(street.laneConfigs, function(l) return (l.forward == false) end)
                    local isOneWay = nBackward == 0
                    for i = 1, (isOneWay and 2 or 1) do
                        local isRev = i == 2
                        local mod = api.type.ModuleDesc.new()
                        mod.fileName = ("ste/streets/%s%s.module"):format(streetName:match("(.+).lua"), isRev and "_rev" or "")
                        local hasIndice = streetIndices[mod.fileName]
                        if hasIndice then mod.fileName = streetIndices[mod.fileName] end
                        
                        mod.availability.yearFrom = street.yearFrom
                        mod.availability.yearTo = street.yearTo
                        mod.cost.price = 0
                        
                        mod.description.name = street.name
                        mod.description.description = street.desc
                        mod.description.icon = street.icon
                        
                        mod.type = "ste_track"
                        mod.order.value = (hasIndice and 0 or 100)
                        mod.metadata = {
                            isTrack = true,
                            width = street.streetWidth + street.sidewalkWidth * 2,
                            type = "ste_track"
                        }
                        
                        mod.category.categories = {isRev and _("ONE_WAY_REV") or isOneWay and _("ONE_WAY") or _("STREET")}
                        
                        mod.updateScript.fileName = "construction/ste/ste_track_module.updateFn"
                        mod.updateScript.params = {
                            isStreet = true,
                            isRev = isRev,
                            trackType = streetName,
                            catenary = false,
                            width = street.streetWidth + street.sidewalkWidth * 2
                        }
                        mod.getModelsScript.fileName = "construction/ste/ste_track_module.getModelsFn"
                        mod.getModelsScript.params = {}
                        
                        api.res.moduleRep.add(mod.fileName, mod, true)
                    end
                end
            end
        end
    }
end

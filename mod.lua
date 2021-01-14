-- local dump = require "luadump"
local func = require "ste/func"

local trackIndices = {
    ["standard"] = "std",
    ["high_speed"] = "hs",
}

local streetIndices = {
    ["ste/streets/standard/country_large_new"] = "ste/streets/country_large_new",
    ["ste/streets/standard/country_large_old"] = "ste/streets/country_large_old",
    ["ste/streets/standard/country_large_one_way_new"] = "ste/streets/country_large_one_way_new",
    ["ste/streets/standard/country_large_one_way_new_rev"] = "ste/streets/country_large_one_way_new_rev",
    ["ste/streets/standard/country_medium_new"] = "ste/streets/country_medium_new",
    ["ste/streets/standard/country_medium_old"] = "ste/streets/country_medium_old",
    ["ste/streets/standard/country_medium_one_way_new"] = "ste/streets/country_medium_one_way_new",
    ["ste/streets/standard/country_medium_one_way_new_rev"] = "ste/streets/country_medium_one_way_new_rev",
    ["ste/streets/standard/country_small_new"] = "ste/streets/country_small_new",
    ["ste/streets/standard/country_small_old"] = "ste/streets/country_small_old",
    ["ste/streets/standard/country_small_one_way_new"] = "ste/streets/country_small_one_way_new",
    ["ste/streets/standard/country_small_one_way_new_rev"] = "ste/streets/country_small_one_way_new_rev",
    ["ste/streets/standard/country_x_large_new"] = "ste/streets/country_x_large_new",
    ["ste/streets/standard/town_large_new"] = "ste/streets/town_large_new",
    ["ste/streets/standard/town_large_old"] = "ste/streets/town_large_old",
    ["ste/streets/standard/town_large_one_way_new"] = "ste/streets/town_large_one_way_new",
    ["ste/streets/standard/town_large_one_way_new_rev"] = "ste/streets/town_large_one_way_new_rev",
    ["ste/streets/standard/town_medium_new"] = "ste/streets/town_medium_new",
    ["ste/streets/standard/town_medium_old"] = "ste/streets/town_medium_old",
    ["ste/streets/standard/town_medium_one_way_new"] = "ste/streets/town_medium_one_way_new",
    ["ste/streets/standard/town_medium_one_way_new_rev"] = "ste/streets/town_medium_one_way_new_rev",
    ["ste/streets/standard/town_small_new"] = "ste/streets/town_small_new",
    ["ste/streets/standard/town_small_old"] = "ste/streets/town_small_old",
    ["ste/streets/standard/town_small_one_way_new"] = "ste/streets/town_small_one_way_new",
    ["ste/streets/standard/town_small_one_way_new_rev"] = "ste/streets/town_small_one_way_rev",
    ["ste/streets/standard/town_x_large_new"] = "ste/streets/town_x_large_new"
}

function data()
    return {
        info = {
            minorVersion = 5,
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
            local tracks = {}
            for __, trackName in pairs(api.res.trackTypeRep.getAll()) do
                if trackName == "standard.lua" then
                    table.insert(tracks, 1, trackName)
                elseif trackName == "high_speed.lua" then
                    table.insert(tracks, tracks[1] == "standard.lua" and 2 or 1, trackName)
                else
                    table.insert(tracks, trackName)
                end
            end
            local trackModuleList = {}
            local trackIconList = {}
            local trackNames = {}
            for __, trackName in ipairs(tracks) do
                local track = api.res.trackTypeRep.get(api.res.trackTypeRep.find(trackName))
                local trackName = trackName:match("(.+).lua")
                local baseFileName = ("ste/tracks/%s"):format(trackIndices[trackName] or trackName)
                for __, catenary in pairs({false, true}) do
                    local mod = api.type.ModuleDesc.new()
                    mod.fileName = ("%s%s.module"):format(baseFileName, catenary and "_catenary" or "")
                    
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
                table.insert(trackModuleList, baseFileName)
                table.insert(trackIconList, track.icon)
                table.insert(trackNames, track.name)
            end
            
            local streets = api.res.streetTypeRep.getAll()
            local streetModuleList = {}
            local streetIconList = {}
            local streetNames = {}
            for __, streetName in pairs(streets) do
                local street = api.res.streetTypeRep.get(api.res.streetTypeRep.find(streetName))
                if (#street.categories > 0 and not streetName:match("street_depot/") and not streetName:match("street_station/")) then
                    local nBackward = #func.filter(street.laneConfigs, function(l) return (l.forward == false) end)
                    local isOneWay = nBackward == 0
                    local baseFileName = ("ste/streets/%s"):format(streetName:match("(.+).lua"))
                    for i = 1, (isOneWay and 2 or 1) do
                        local isRev = i == 2
                        local mod = api.type.ModuleDesc.new()
                        mod.fileName = ("%s%s"):format(baseFileName, isRev and "_rev" or "")
                        local hasIndice = streetIndices[mod.fileName]
                        if hasIndice then mod.fileName = streetIndices[mod.fileName] end
                        mod.fileName = mod.fileName .. ".module"
                        
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
                    table.insert(streetModuleList, streetIndices[baseFileName] or baseFileName)
                    table.insert(streetIconList, street.icon)
                    table.insert(streetNames, street.name)
                end
            end
            
            
            local con = api.res.constructionRep.get(api.res.constructionRep.find("ste/tunnel_entry.con"))
            for c = 1, #con.constructionTemplates do
                local data = api.type.DynamicConstructionTemplate.new()
                for i = 1, #con.constructionTemplates[c].data.params do
                    local p = con.constructionTemplates[c].data.params[i]
                    local param = api.type.ScriptParam.new()
                    param.key = p.key
                    param.name = p.name
                    if (p.key == "trackType") then
                        param.values = trackNames
                    elseif (p.key == "streetType") then
                        param.values = streetNames
                    else
                        param.values = p.values
                    end
                    param.defaultIndex = p.defaultIndex or 0
                    param.uiType = p.uiType
                    data.params[i] = param
                end
                con.constructionTemplates[c].data = data
            end
            
            con.createTemplateScript.fileName = "construction/ste/create_template.fn"
            con.createTemplateScript.params = {trackModuleList = trackModuleList, streetModuleList = streetModuleList, trackIconList = trackIconList, streetIconList = streetIconList}
        end
    }
end

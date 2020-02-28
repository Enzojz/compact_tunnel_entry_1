function data()
    return {
        info = {
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
            tags = {"Street Construction", "Tunnel"},
        }
    --     ,runFn = function(settings)
    --         addModifier("loadStreet", 
    --             function(fileName, data)
    --                 local width = data.streetWidth + data.sidewalkWidth * 2
    --                 local fname = string.match(fileName, "standard/([a-zA-Z_]+).lua")
    --                 if (fname) then
    --                     print(fname)
    --                 local s = string.format([[
    -- local fn = require "ste_track_module"
    -- local desc = {
    --     name = _("%s"),
    --     description = _("%s"),
    --     icon = "ui/streets/standard/%s.tga"
    -- }

    -- local trackWidth = %d

    -- data = fn(trackWidth, "standard/%s.lua", false, desc, 1, true)]], data.name, data.name, fname, width, fname)
    --                 local file = io.open("ste/" .. fname .. ".module", "w")
    --                 file:write(s)
    --                 file:close()
    --             end
    --             return data
    --         end)
    --     end
    }
end

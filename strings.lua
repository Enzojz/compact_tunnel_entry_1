local descEN = [[

----------------------------------------------------------------------

I am Chinese, living in Europe. My motherland is suffering the pandemic caused by the "Novel Coronavirus" 2019-nCov, several tens of thousands of people are contaminated in weeks and hundreds of people died. We are fighting against the virus and we believe that we will win. I pay my highest respect to these who are working hard to save the people. I pay also my highest respect to all the people, healthy or ill, who is confining themselves at home to avoid the propagation of virus. 

However, we are NOT virus ourselves, and the virus is NOT called "Chinese virus", these attacks on Chinese just because of our face or because we have masks on the face -- are not justified.
We are on the same earth, we are on the same boat, if you want to protect yourself and protect others, you should put the mask on, wash your hand frequently, but never attack on innocent people, the virus doesn't hold a nationality, and the violence does not contribute to killing virus.

Keep fighting, Wuhan!
Keep fighting, Hubei!
Keep fighting, China!
Keep fighting, all suffered from Novel Coronavirus!
]]

local descCN = [[

武汉加油！
湖北加油！
中国加油！
人类一定可以战胜病魔！
]]

local descTC = [[

武漢加油！
湖北加油！
中國加油！
人類一定可以戰勝病魔！

致臺港澳同胞，所有華人：
不管您政治立場如何，都改變不了我們是炎黃子孫之事實。瘟疫無邊界，覆巢之下，焉有完卵？值此寒冬，願唯齊心協力，共同與病毒抗爭！

]]


function data()
    local profile = {
        en = {
            MOD_NAME = "Compact Tunnel Entry",
            MOD_DESC = descEN,
            MENU_CONCRETE_BEAM_NAME = "Concrete open trench beam",
            MENU_CONCRETE_BEAM_DESC = "Build some beam over the concrete open trench.",
            MENU_BRICK_WALL_NAME = "Brick retaining walls",
            MENU_BRICK_WALL_DESC = "Build brick retaining walls at sides or between tracks.",
            MENU_BRICK_WALL_2_NAME = "Brick retaining walls",
            MENU_BRICK_WALL_2_DESC = "Build brick retaining walls at sides or between tracks.",
            MENU_CONCRETE_WALL_NAME = "Concrete retaining walls",
            MENU_CONCRETE_WALL_DESC = "Build concrete retaining walls at sides or between tracks.",
            NAME_MARKER = "Length adjuster",
            DESC_MARKER = "Use adjuster to change the length of tracks, streets and walls.",
            MENU_WALL_NAME = "Retaining walls",
            MENU_WALL_DESC = "Build retaining walls at sides or between tracks.",

            MENU_TR_STD_NAME = "Standard track",
            MENU_TR_STD_DESC = "Standard track with speed limit of 120km/h",
            MENU_TR_STD_CAT_NAME = "Electrified track",
            MENU_TR_STD_CAT_DESC = "Electrified track with speed limit of 120km/h",
            MENU_TR_HS_NAME = "High-speed track",
            MENU_TR_HS_DESC = "Non-electrified high speed track with speed limit of 300km/h",
            MENU_TR_HS_CAT_NAME = "Electrified high-speed track",
            MENU_TR_HS_CAT_DESC = "High speed track with speed limit of 300km/h",
            STREET = "Streets",
            TRACK = "Tracks",
            STRUCTURE = "Structures"
        },
        zh_CN = {
            ["name"] = "地下车站",
            STREET = "道路"
        },
        zh_TW = {
            ["name"] = "地下車站"
        }
    }
    return profile
end

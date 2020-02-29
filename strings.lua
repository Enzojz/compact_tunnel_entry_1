local descEN = [[With this mod you get ability to build very compact tunnel entries, both for tracks and streets. You can use it to build kinds of junctions. The modular design enbales ability to build different layouts.

* This mod requires the shader enhancement mod.

Known bug:
- The street causes a lot of colission, sometimes not usable at all
- The hole dig on the ground get a zigzags, which needed to fix with support from UG (still unknow if it can be fixed or not)


----------------------------------------------------------------------

Keep fighting, Wuhan!
Keep fighting, all the world!

I wish a world without coronavirus.
]]

local descCN = [[本模组可以以紧凑的方式建造铁路或者街道隧道入口。这种隧道通常用在一些小型立交中，模块化的设计帮助您创建各种不同的布局。

* 本模组需要着色器增强的支持

已知Bug:
- 街道经常会引发冲突，有时候甚至完全没法使用
- 地面上开的洞的边缘会带有锯齿，这个问题需要UG去解决（并且不清楚是否可能解决）

武汉加油！
愿人类战胜病毒！
]]

local descTC = [[本模組可以以緊湊的方式建造鐵路或者街道隧道入口。這種隧道通常用在一些小型立交中，模組化的設計幫助您創建各種不同的佈局。

* 本模組需要著色器增強的支援

已知Bug:
- 街道經常會引發衝突，有時候甚至完全沒法使用
- 地面上開的洞的邊緣會帶有鋸齒，這個問題需要UG去解決（並且不清楚是否可能解決）

武漢加油！
願人類戰勝病毒！
]]

function data()
    local profile = {
        en = {
            MOD_NAME = "Compact Tunnel Entry",
            MOD_DESC = descEN,
            MENU_NAME = "Compact Tunnel Entry",
            MENU_DESC = "A compact tunnel entry for flying junctions, can be used as ordinary tunnel entry as well",
            TRACK_CONSTRUCTION = "Track Constructions",
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
            
            MENU_STREET_TYPE = "Road Type",
            MENU_LEFT_ROAD = "Road on the left",
            MENU_LEFT_ROAD = "Road on the right",
            MENU_TR_STD_NAME = "Standard track",
            MENU_TR_STD_DESC = "Standard track with speed limit of 120km/h",
            MENU_TR_STD_CAT_NAME = "Electrified track",
            MENU_TR_STD_CAT_DESC = "Electrified track with speed limit of 120km/h",
            MENU_TR_HS_NAME = "High-speed track",
            MENU_TR_HS_DESC = "Non-electrified high speed track with speed limit of 300km/h",
            MENU_TR_HS_CAT_NAME = "Electrified high-speed track",
            MENU_TR_HS_CAT_DESC = "High speed track with speed limit of 300km/h",
            
            MENU_ADJUST_LENGTH_SURFACE = "Surface pre-adjustment (%)",
            MENU_ADJUST_LENGTH_UNDERGROUND = "Underground pre-adjustment (%)",

            STRUCTURE = "Structures",
            TRACK = "Tracks",
            STREET = "Road",
            ONE_WAY = "One way",
            ONE_WAY_REV = "One way (Rev.)",

            MENU_DEG_SURFACE = "Surface turn (°)",
            MENU_DEG_UNDERGROUND = "Underground turn (°)",
            MENU_LENGTH = "Length (m)",
            MENU_PORTAIL_HEIGHT = "Portail Reference Height (m)",
            MENU_WALL_STYLE = "Structure Material",
            MENU_TRACK_NR = "Track numbers",
            MENU_TRACK_CAT = "Electrified tracks",
            MENU_TRACK_HS = "High-Speed tracks",
            MENU_LEFT_TRACK = "Ground track on the left",
            MENU_RIGHT_TRACK = "Ground track on the right"
        },
        zh_CN = {
            MOD_NAME = "紧凑隧道入口",
            MOD_DESC = descTC,
            MENU_NAME = "紧凑隧道入口",
            MENU_DESC = "一种可以用于制作小型立交的紧凑隧道入口，也可以用作普通的隧道入口。",
            TRACK_CONSTRUCTION = "轨道设施",
            MENU_CONCRETE_BEAM_NAME = "混凝土横梁",
            MENU_CONCRETE_BEAM_DESC = "在混凝土沟槽上方建造横梁。",
            MENU_BRICK_WALL_NAME = "砖式挡土墙",
            MENU_BRICK_WALL_DESC = "在轨道或者街道两侧建造砖式挡土墙。",
            MENU_BRICK_WALL_2_NAME = "砖式挡土墙",
            MENU_BRICK_WALL_2_DESC = "在轨道或者街道两侧建造砖式挡土墙。",
            MENU_CONCRETE_WALL_NAME = "混凝土挡土墙",
            MENU_CONCRETE_WALL_DESC = "在轨道或者街道两侧建造混凝土挡土墙。",
            NAME_MARKER = "长度调整工具",
            DESC_MARKER = "使用此工具调整轨道、街道或者挡土墙的长度。",
            MENU_WALL_NAME = "挡土墙",
            MENU_WALL_DESC = "在轨道或者街道两侧建造挡土墙。",
            
            MENU_STREET_TYPE = "道路类型",
            MENU_LEFT_ROAD = "左侧有道路",
            MENU_LEFT_ROAD = "右侧有道路",
            MENU_TR_STD_NAME = "普速股道",
            MENU_TR_STD_DESC = "限速120km/h的非电气化车站股道",
            MENU_TR_STD_CAT_NAME = "电气化普速股道",
            MENU_TR_STD_CAT_DESC = "限速120km/h的电气化车站股道",
            MENU_TR_HS_NAME = "高速股道",
            MENU_TR_HS_DESC = "限速300km/h的非电气化车站股道",
            MENU_TR_HS_CAT_NAME = "电气化高速股道",
            MENU_TR_HS_CAT_DESC = "限速300km/h的电气化车站股道",

            MENU_ADJUST_LENGTH_SURFACE = "地面长度预调 (%)",
            MENU_ADJUST_LENGTH_UNDERGROUND = "地下长度预调 (%)",
            
            STRUCTURE = "支撑结构",
            TRACK = "轨道",
            STREET = "街道",
            ONE_WAY = "单行道",
            ONE_WAY_REV = "反向单行道",
            
            MENU_DEG_SURFACE = "地面部分转角 (°)",
            MENU_DEG_UNDERGROUND = "地下部分转角 (°)",
            MENU_LENGTH = "长度 (米)",
            MENU_PORTAIL_HEIGHT = "入口参考高度 (米)",
            MENU_WALL_STYLE = "支撑结构材料",
            MENU_TRACK_NR = "轨道数",
            MENU_TRACK_CAT = "电气化轨道",
            MENU_TRACK_HS = "高速轨道",
            MENU_LEFT_TRACK = "左侧有地面轨道",
            MENU_RIGHT_TRACK = "右侧有地面轨道"
        },
        zh_TW = {
            MOD_NAME = "緊湊隧道入口",
            MOD_DESC = descTW,
            MENU_NAME = "緊湊隧道入口",
            TRACK_CONSTRUCTION = "軌道設施",
            MENU_DESC = "一種可以用於製作小型立交的緊湊隧道入口，也可以用作普通的隧道入口。",
            MENU_CONCRETE_BEAM_NAME = "混凝土橫樑",
            MENU_CONCRETE_BEAM_DESC = "在混凝土溝槽上方建造橫樑。",
            MENU_BRICK_WALL_NAME = "磚式擋土牆",
            MENU_BRICK_WALL_DESC = "在軌道或者街道兩側建造磚式擋土牆。",
            MENU_BRICK_WALL_2_NAME = "磚式擋土牆",
            MENU_BRICK_WALL_2_DESC = "在軌道或者街道兩側建造磚式擋土牆。",
            MENU_CONCRETE_WALL_NAME = "混凝土擋土牆",
            MENU_CONCRETE_WALL_DESC = "在軌道或者街道兩側建造混凝土擋土牆。",
            NAME_MARKER = "長度調整工具",
            DESC_MARKER = "使用此工具調整軌道、街道或者擋土牆的長度。",
            MENU_WALL_NAME = "擋土牆",
            MENU_WALL_DESC = "在軌道或者街道兩側建造擋土牆。",
            
            MENU_STREET_TYPE = "道路類型",
            MENU_LEFT_ROAD = "左側有道路",
            MENU_LEFT_ROAD = "右側有道路",
            MENU_TR_STD_NAME = "普速股道",
            MENU_TR_STD_DESC = "限速120km/h的非電氣化車站股道",
            MENU_TR_STD_CAT_NAME = "電氣化普速股道",
            MENU_TR_STD_CAT_DESC = "限速120km/h的電氣化車站股道",
            MENU_TR_HS_NAME = "高速股道",
            MENU_TR_HS_DESC = "限速300km/h的非電氣化車站股道",
            MENU_TR_HS_CAT_NAME = "電氣化高速股道",
            MENU_TR_HS_CAT_DESC = "限速300km/h的電氣化車站股道",

            MENU_ADJUST_LENGTH_SURFACE = "地面長度預調 (%)",
            MENU_ADJUST_LENGTH_UNDERGROUND = "地下長度預調 (%)",
            
            STRUCTURE = "支撐結構",
            TRACK = "軌道",
            STREET = "街道",
            ONE_WAY = "單行道",
            ONE_WAY_REV = "反向單行道",
            
            MENU_DEG_SURFACE = "地面部分轉角 (°)",
            MENU_DEG_UNDERGROUND = "地下部分轉角 (°)",
            MENU_LENGTH = "長度 (米)",
            MENU_PORTAIL_HEIGHT = "入口參考高度 (米)",
            MENU_WALL_STYLE = "支撐結構材料",
            MENU_TRACK_NR = "軌道數",
            MENU_TRACK_CAT = "電氣化軌道",
            MENU_TRACK_HS = "高速軌道",
            MENU_LEFT_TRACK = "左側有地面軌道",
            MENU_RIGHT_TRACK = "右側有地面軌道"
        }
    }
    return profile
end

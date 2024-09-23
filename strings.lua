local descEN = [[With this mod you get ability to build very compact tunnel entries, both for tracks and streets. You can use it to build kinds of junctions. The modular design enbales ability to build different layouts.

The entries can be found under:
1. Road -> Street -> Street Construction
2. Rail -> Building -> Track Construction

Known bug:
- The street causes a lot of colission, sometimes not usable at all
- The hole dig on the ground get a zigzags, which needed to fix with support from UG (still unknow if it can be fixed or not)

Changelog:
1.6
- Added tram tracks switch
1.5
- Added in-place track/street/wall replacement
- Intergration of mod street/track in the parameters menu
1.4
- Ability to convert between electrified and non-elecrified track
1.3
- Compatibility with modded tracks and streets
- Improvement of slot state machine
- Bugfix for disappeared slots with new version of the game 
1.2
- Improved colission issue when connect the tunnel to existing tracks and streets
- Improved colission issue when modifying the tunnel
- Fxied wrong street module order
1.1
- Added detacher to detach track/street from the construction for further editing.
- Fixed crash with track/street upgrading tools.
]]

local descCN = [[本模组可以以紧凑的方式建造铁路或者街道隧道入口。这种隧道通常用在一些小型立交中，模块化的设计帮助您创建各种不同的布局。

项目在以下位置:
1. 道路 -> 街道 -> 街道建设
2. 轨道 -> 建筑 -> Track Construction

已知Bug:
- 街道经常会引发冲突，有时候甚至完全没法使用
- 地面上开的洞的边缘会带有锯齿，这个问题需要UG去解决（并且不清楚是否可能解决）

更新记录:
1.6
- 增加了在道路上添加有轨电车的支持
1.5
- 增加了直接替换轨道、街道和挡土墙的功能
- 在初始菜单中增加了第三方模组道路和轨道
1.4
- 对所有轨道有效接触网转换功能
1.3
- 增加了对模组轨道和道路的支持
- 改进了模块槽使用的状态机
- 修正了新版下一些模块槽消失的问题
1.2
- 改善了与既有轨道或街道连接时的冲突问题
- 改善了修改隧道入口时的冲突问题
- 修正了错误的街道模块顺序
1.1
- 新增分离工具方便轨道和街道的后续编辑
- 修正了使用轨道和道路升级工具时的崩溃情况
]]

local descTC = [[本模組可以以緊湊的方式建造鐵路或者街道隧道入口。這種隧道通常用在一些小型立交中，模組化的設計幫助您創建各種不同的佈局。

項目在以下位置:
1. 道路 -> 街道 -> 街道建設
2. 軌道 -> 建築 -> Track Construction

已知Bug:
- 街道經常會引發衝突，有時候甚至完全沒法使用
- 地面上開的洞的邊緣會帶有鋸齒，這個問題需要UG去解決（並且不清楚是否可能解決）

更新記錄:
1.6
- 增加了在道路上添加有軌電車的支持
1.5
- 增加了直接替換軌道、街道和擋土牆的功能
- 在初始菜單中增加了協力廠商模組道路和軌道
1.4
- 對所有軌道有效接觸網轉換功能
1.3
- 增加了對模組軌道和道路的支持
- 改進了模組槽使用的狀態機
- 修正了新版下一些模組槽消失的問題
1.2
- 改善了與既有軌道或街道連接時的衝突問題
- 改善了修改隧道入口時的衝突問題
- 修正了錯誤的街道模組順序
1.1
- 新增分離工具方便軌道和街道的後續編輯
- 修正了使用軌道和道路升級工具時的崩潰情況
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
            MENU_TRACK_TYPE = "Track Type",
            MENU_STREET_TYPE = "Road Type",
            
            MENU_STREET_VARIANT = "Tram tracks switch",
            DESC_MENU_STREET_VARIANT = "To add or remove tram tracks from street",

            MENU_ADJUST_LENGTH_SURFACE = "Surface pre-adjustment (%)",
            MENU_ADJUST_LENGTH_UNDERGROUND = "Underground pre-adjustment (%)",

            FREENODE_MARKER = "Detacher",
            DESC_FREENODE_MARKER = "Use detacher to detach track/street from the tunnel entry so that can be edited freely.",

            STRUCTURE = "Structures",
            TRACK = "Tracks",
            TRACK_CAT = "Tracks (Elec.)",
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
            MOD_DESC = descCN,
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
            
            MENU_TRACK_TYPE = "轨道类型",
            MENU_STREET_TYPE = "道路类型",

            MENU_ADJUST_LENGTH_SURFACE = "地面长度预调 (%)",
            MENU_ADJUST_LENGTH_UNDERGROUND = "地下长度预调 (%)",

            MENU_STREET_VARIANT = "有轨轨道",
            DESC_MENU_STREET_VARIANT = "在道路上增加有轨轨道",
            
            STRUCTURE = "支撑结构",
            TRACK = "轨道",
            TRACK_CAT = "轨道 (电)",
            STREET = "街道",
            ONE_WAY = "单行道",
            ONE_WAY_REV = "单行道 (反)",

            FREENODE_MARKER = "分离工具",
            DESC_FREENODE_MARKER = "使用分离工具将轨道或道路从隧道入口的主体中分离出来，以便进行更深入的编辑",
            
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
            MOD_DESC = descTC,
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
            
            FREENODE_MARKER = "分離工具",
            DESC_FREENODE_MARKER = "使用分離工具將軌道或道路從隧道入口的主體中分離出來，以便進行更深入的編輯",

            MENU_STREET_VARIANT = "有軌軌道",
            DESC_MENU_STREET_VARIANT = "在道路上增加有軌軌道",

            MENU_TRACK_TYPE = "軌道類型",
            MENU_STREET_TYPE = "道路類型",

            MENU_ADJUST_LENGTH_SURFACE = "地面長度預調 (%)",
            MENU_ADJUST_LENGTH_UNDERGROUND = "地下長度預調 (%)",
            
            STRUCTURE = "支撐結構",
            TRACK = "軌道",
            TRACK_CAT = "軌道 (電)",
            STREET = "街道",
            ONE_WAY = "單行道",
            ONE_WAY_REV = "單行道 (反)",
            
            MENU_DEG_SURFACE = "地面部分轉角 (°)",
            MENU_DEG_UNDERGROUND = "地下部分轉角 (°)",
            MENU_LENGTH = "長度 (公尺)",
            MENU_PORTAIL_HEIGHT = "入口參考高度 (公尺)",
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

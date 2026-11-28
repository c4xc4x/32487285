-- made by samet september 14 2025
-- pchaxx (Pandora) con el estilo de juanitahaxx - solo libreria, sin UI de ejemplo

local LoadingTick = os.clock()

if getgenv().Library then
    getgenv().Library:Unload()
end

local Library do 
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    --local Lighting = game:GetService("Lighting")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    --local Camera = Workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new
    local NumSequence = NumberSequence.new
    local NumSequenceKeypoint = NumberSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local UDim2FromOffset = UDim2.fromOffset
    local Vector2New = Vector2.new
    --local Vector3New = Vector3.new

    local MathClamp = math.clamp
    local MathFloor = math.floor
    --local MathAbs = math.abs
    --local MathSin = math.sin

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLower = string.lower
    local StringLen = string.len

    local InstanceNew = Instance.new

    --local RectNew = Rect.new

    Library = {
        Theme =  { },

        MenuKeybind = tostring(Enum.KeyCode.RightControl), 

        Flags = { },

        Tween = {
            Time = 0.3,
            Style = Enum.EasingStyle.Quart,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.4,

        GlowTransparency = 0.8,

        RainbowSpeed = 0.2,

        Folders = {
            Directory = "Pandora",
            Configs = "Pandora/Configs",
            Assets = "Pandora/Images",
            Fonts = "Pandora/Fonts"
        },

        Images = {
            ["Sat"] = {"Sat.png", "https://github.com/sametexe001/images/blob/main/saturation.png?raw=true" },
            ["Val"] = { "Val.png", "https://github.com/sametexe001/images/blob/main/value.png?raw=true" },
            ["Hue"] = { "Hue.png", "https://github.com/sametexe001/images/blob/main/horizontalhue.png?raw=true" },
            ["Alpha"] = { "Alpha.png", "https://github.com/sametexe001/images/blob/main/checkers.png?raw=true" },
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,
        KeyList = nil,

        Font = nil,
        SubFont = nil,
        MenuFont = nil,
        TitleFont = nil,
        Fonts = nil,
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    local Themes = {
        ["Preset"] = {
            ["Border"] = FromRGB(10, 10, 10),
            ["Outline"] = FromRGB(60, 60, 60),
            ["Background"] = FromRGB(16, 16, 16),
            ["Inline"] = FromRGB(23, 23, 23),
            ["Accent"] = FromRGB(176, 176, 209),
            ["Dark Accent"] = FromRGB(123, 123, 146),
            ["Glow"] = FromRGB(176, 176, 209),
            ["Text"] = FromRGB(255, 255, 255),
            ["Inactive Text"] = FromRGB(155, 155, 155),
            ["Element"] = FromRGB(46, 46, 46),
            ["Element 2"] = FromRGB(64, 64, 64),
            ["Hovered Element"] = FromRGB(72, 72, 72)
        }
    }

    Library.Theme = TableClone(Themes["Preset"])

    -- Folders
    for Index, Value in Library.Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    -- Images
    for Index, Value in Library.Images do 
        local ImageData = Value

        local ImageName = ImageData[1]
        local ImageLink = ImageData[2]
        
        if not isfile(Library.Folders.Assets .. "/" .. ImageName) then
            writefile(Library.Folders.Assets .. "/" .. ImageName, game:HttpGet(ImageLink))
        end
    end

    -- Iconos embebidos (PNG blancos: se tintan con ImageColor3)
    Library.Icons = {
        ["Aim"] = "\137\080\078\071\013\010\026\010\000\000\000\013\073\072\068\082\000\000\000\064\000\000\000\064\008\006\000\000\000\170\105\113\222\000\000\007\048\073\068\065\084\120\218\237\155\105\136\092\085\022\199\255\183\170\186\059\210\065\077\092\198\133\024\090\141\187\147\113\065\141\024\193\184\116\148\001\141\131\232\056\226\054\243\081\220\081\028\198\229\155\126\048\110\159\004\113\003\023\068\080\034\014\131\074\024\197\005\035\067\020\065\028\117\112\197\117\018\053\046\073\183\245\094\253\252\144\115\157\051\151\247\186\171\042\085\175\058\118\046\060\234\213\187\247\190\123\207\255\044\247\220\115\238\147\102\121\009\131\024\020\168\075\218\062\121\252\093\008\033\255\085\163\013\212\236\119\017\240\077\114\045\242\109\170\042\141\001\097\081\151\180\099\193\179\202\203\160\000\192\174\244\217\172\001\096\096\246\039\045\053\205\242\178\013\128\001\172\004\161\068\252\107\086\247\235\178\001\070\084\045\018\029\066\200\128\201\130\166\155\066\008\000\053\160\097\070\177\021\066\096\171\004\192\008\175\135\016\050\073\185\123\062\042\105\172\160\203\034\096\125\008\225\251\228\061\013\003\162\181\213\088\098\160\030\189\058\115\108\142\149\116\162\164\165\146\014\148\180\139\164\161\164\091\038\105\157\164\247\036\189\036\105\181\164\151\067\008\019\206\123\236\187\068\244\196\211\179\251\093\129\203\129\215\233\190\188\003\092\015\044\076\220\232\025\073\124\035\078\016\184\020\248\220\017\210\002\038\129\009\224\039\251\159\150\150\213\077\088\219\220\213\109\000\110\002\230\250\177\102\034\241\139\129\053\110\226\077\035\042\043\033\184\232\062\150\220\250\054\221\179\183\129\019\102\148\036\056\226\207\007\126\116\132\103\009\023\063\004\238\183\118\127\072\234\114\224\012\224\108\224\110\224\221\004\156\204\001\145\003\087\059\105\011\051\129\248\043\221\132\179\132\227\207\002\103\070\241\181\246\011\010\056\190\151\171\031\006\198\129\039\146\247\230\014\184\149\003\005\161\128\248\166\077\046\018\255\111\096\069\210\103\008\104\000\007\090\123\127\029\096\117\195\073\159\019\156\090\101\078\053\060\008\141\170\137\175\219\239\121\142\248\150\035\254\033\096\135\184\050\068\046\185\120\192\065\005\018\112\144\107\031\172\079\221\001\119\155\083\137\150\003\225\186\074\065\112\068\028\002\108\114\092\137\196\255\045\149\146\196\057\018\176\155\217\003\127\237\230\219\120\176\093\191\191\184\177\114\103\023\078\170\196\048\058\206\052\128\181\078\044\155\158\120\171\015\061\030\119\200\238\047\072\084\174\005\124\010\236\016\165\167\010\189\191\036\177\246\000\143\056\113\013\109\016\212\072\174\208\198\248\195\246\123\075\001\248\183\245\085\010\108\210\001\152\015\172\115\034\216\002\254\003\204\237\055\007\028\112\001\120\037\145\132\073\096\063\111\107\250\197\253\203\010\184\255\251\170\012\145\051\140\191\115\196\071\041\184\163\047\243\112\220\111\000\111\057\215\022\224\159\085\123\102\142\025\015\218\028\162\123\253\021\176\099\145\049\237\021\234\075\156\055\022\185\127\122\004\167\202\101\216\198\060\220\057\071\113\062\103\119\034\005\237\234\074\068\243\020\011\084\100\218\028\198\254\084\210\051\182\069\205\187\144\170\122\055\158\092\220\106\135\016\214\074\090\107\116\228\054\183\241\174\002\034\211\025\014\155\228\241\006\070\220\147\175\150\052\105\214\057\003\212\206\126\029\168\089\128\035\047\120\214\078\160\069\146\026\064\046\233\239\146\142\116\140\058\054\006\081\140\038\074\064\164\083\177\171\185\045\110\244\194\206\233\050\082\020\223\119\012\176\020\152\211\173\222\002\199\187\037\049\206\109\207\142\036\192\116\124\239\018\149\168\073\106\073\090\032\105\231\068\114\154\192\254\174\205\134\016\194\023\064\040\066\056\114\025\216\079\210\195\142\115\239\000\023\134\016\094\157\078\018\128\237\036\205\113\146\184\078\210\164\164\017\155\195\144\164\223\002\027\077\077\203\084\243\127\185\072\096\158\229\231\202\246\230\101\037\079\036\226\254\050\003\020\215\103\219\233\189\225\150\210\184\132\125\105\062\070\040\146\004\103\249\175\001\190\054\139\255\181\093\121\050\175\239\093\157\191\214\187\251\125\123\017\020\173\117\016\091\172\133\016\114\224\008\073\139\205\144\254\034\073\146\118\149\116\114\008\225\049\035\054\043\121\207\168\164\121\211\140\053\183\093\233\031\068\104\105\104\010\208\134\219\232\031\163\204\030\192\212\007\041\019\123\220\184\173\094\000\208\234\096\041\109\153\104\255\075\210\071\146\022\026\231\035\040\063\074\090\109\109\166\090\082\071\140\224\169\028\175\118\156\178\250\047\092\104\211\008\046\148\244\015\251\031\145\092\033\233\237\046\140\224\049\146\030\147\020\163\064\235\037\093\028\066\120\170\204\008\198\119\002\099\073\094\097\039\073\015\153\244\068\134\092\033\233\077\055\175\162\242\106\008\097\099\039\203\205\144\025\030\111\244\086\108\193\050\056\015\056\011\056\023\216\099\011\150\193\197\137\065\206\098\108\161\151\142\080\205\116\238\093\075\106\068\084\199\129\085\246\158\076\018\211\057\024\049\253\021\066\248\070\210\227\093\056\066\049\205\214\048\085\057\205\217\134\097\073\031\075\250\214\164\058\076\225\008\229\255\007\192\052\107\111\205\038\254\162\101\121\034\167\078\050\112\154\157\120\087\166\006\193\233\106\219\169\175\216\142\205\058\209\002\150\059\003\135\164\053\033\132\009\203\078\101\189\222\012\045\115\226\022\069\110\089\244\235\171\204\064\217\152\251\187\157\096\244\039\046\234\249\150\216\109\135\231\000\239\039\065\201\085\003\220\014\223\149\108\135\055\000\191\233\249\118\056\025\244\250\036\018\147\003\199\085\005\130\227\254\062\192\198\036\076\126\095\223\230\225\006\222\019\248\033\137\196\172\181\096\073\223\147\020\142\017\079\023\004\071\015\235\171\058\058\091\112\099\065\088\236\246\184\092\182\075\200\022\004\069\047\047\008\138\062\208\119\041\116\027\154\081\179\005\233\036\254\220\110\100\184\139\177\099\088\124\121\146\027\200\129\111\129\221\251\022\016\045\145\130\165\005\041\177\028\184\208\071\124\074\222\049\007\184\214\036\233\006\251\029\043\073\140\212\220\152\167\154\250\181\018\221\255\099\165\134\216\233\225\085\137\021\142\091\233\155\093\006\169\225\238\163\023\056\191\096\107\061\158\000\092\243\075\025\112\133\123\191\095\133\238\172\042\034\093\006\194\202\004\132\104\019\094\000\142\074\179\059\102\040\231\155\091\221\180\003\017\077\243\039\234\192\136\151\002\075\164\062\233\008\247\156\127\212\231\010\170\006\032\056\110\173\076\028\164\204\253\191\023\056\058\233\059\106\065\009\031\202\090\154\180\057\020\184\195\157\057\072\243\129\143\250\213\073\131\040\009\008\127\077\078\134\164\167\066\214\216\049\151\101\150\029\246\000\180\108\099\180\196\222\243\124\114\050\036\075\254\223\233\012\242\096\143\220\038\032\044\007\062\040\056\034\147\150\077\005\097\172\137\130\118\063\185\244\027\192\127\129\063\013\156\243\211\216\132\249\192\173\070\164\007\098\210\174\108\154\024\099\108\215\076\234\238\005\022\248\196\136\102\090\241\203\016\112\048\112\059\240\217\020\193\212\233\158\173\007\238\073\140\105\079\151\186\208\015\149\136\001\208\024\248\176\108\205\184\164\163\045\242\052\082\210\189\105\225\178\215\036\061\103\089\167\207\029\225\051\251\160\100\153\003\227\185\007\044\180\003\080\223\037\156\191\020\024\003\070\010\250\108\189\167\218\211\243\062\209\167\055\241\246\203\224\018\015\092\085\107\123\223\189\039\159\056\117\156\220\190\064\253\070\173\190\214\179\072\078\007\137\141\202\004\034\077\138\250\176\185\213\085\170\227\219\190\024\217\006\192\128\109\164\138\063\161\155\021\000\196\111\135\106\026\224\039\116\179\094\005\006\249\241\244\152\054\039\070\098\158\241\147\142\114\117\219\074\111\202\207\136\177\192\179\060\085\253\225\000\000\000\000\073\069\078\068\174\066\096\130",
        ["Triggerbot"] = "\137\080\078\071\013\010\026\010\000\000\000\013\073\072\068\082\000\000\000\064\000\000\000\064\008\006\000\000\000\170\105\113\222\000\000\004\148\073\068\065\084\120\218\237\155\075\136\029\069\020\134\255\234\190\055\051\048\131\009\070\069\020\031\011\055\062\178\050\132\004\055\025\133\144\232\034\217\136\098\196\007\034\098\092\136\096\136\032\146\133\011\021\077\086\217\168\059\163\004\012\130\171\017\031\196\040\003\018\031\011\067\004\069\016\193\004\087\138\066\208\201\204\189\253\101\049\167\224\216\244\189\211\198\235\076\117\207\061\208\020\083\183\122\230\158\191\254\255\212\169\170\051\082\077\003\002\208\001\158\000\230\088\178\211\064\006\004\027\211\177\246\128\125\254\051\112\008\184\193\222\015\106\170\153\163\025\240\165\057\183\096\237\054\251\060\055\039\051\224\091\254\105\155\226\239\104\050\000\113\118\031\052\167\254\182\246\136\245\079\088\187\197\250\023\129\002\248\184\241\206\071\009\088\187\017\248\195\156\003\248\021\152\138\014\002\071\074\000\061\022\229\163\166\027\144\091\123\212\000\152\055\039\247\088\255\020\112\206\250\010\003\234\010\015\096\211\052\159\251\047\238\000\216\097\078\254\005\244\128\143\172\127\175\245\159\007\250\192\059\254\189\020\109\032\045\067\008\069\217\113\073\133\001\242\153\164\095\036\093\103\253\215\091\012\184\069\018\146\166\172\255\104\163\102\222\005\186\071\129\089\224\062\096\067\105\204\058\107\159\007\222\003\118\197\024\096\140\217\004\188\012\124\002\076\054\138\254\046\144\205\185\037\236\028\240\058\048\147\050\149\071\025\224\182\186\117\126\190\180\158\159\182\153\239\090\100\207\043\226\068\102\009\083\035\131\094\000\182\003\167\074\142\095\112\203\218\092\116\094\109\054\096\051\240\026\240\099\009\140\061\062\094\148\082\229\208\006\199\067\137\210\147\192\061\192\049\224\012\048\061\044\176\181\002\004\175\229\082\223\228\144\241\151\085\044\155\106\011\035\242\065\078\185\224\185\011\248\016\184\178\074\034\173\001\099\008\000\219\045\070\252\004\204\248\029\100\219\131\101\004\224\078\075\139\177\052\248\133\086\074\098\025\000\252\054\024\224\003\224\218\214\074\098\000\000\125\007\004\192\089\096\103\107\037\049\004\000\156\036\000\014\182\117\149\024\006\064\252\185\159\170\036\178\021\250\027\153\164\158\164\157\146\190\006\118\135\016\122\241\012\177\237\000\248\179\135\190\164\171\037\189\015\188\180\116\236\016\138\070\075\162\134\004\024\034\137\019\192\141\081\018\171\145\070\103\171\196\186\040\137\025\073\167\162\036\252\153\068\155\001\040\075\226\042\039\137\220\036\209\089\011\000\072\082\046\169\176\231\057\073\039\129\155\044\064\174\136\036\082\072\074\188\036\238\048\073\220\187\082\146\072\041\043\139\146\184\092\210\187\192\225\149\144\068\106\105\105\174\165\099\245\190\164\103\086\066\018\041\230\229\193\128\240\146\184\063\132\208\011\033\048\106\073\164\188\049\241\146\056\102\119\142\019\163\150\068\234\059\051\047\137\167\036\125\014\220\060\074\073\052\097\107\234\037\177\069\210\023\192\094\039\137\188\237\000\148\037\177\094\210\219\078\018\253\255\034\137\084\001\232\219\140\151\031\036\045\074\186\096\146\056\009\220\026\115\134\054\001\144\219\140\087\061\093\073\019\054\110\171\164\051\192\179\118\127\145\093\010\173\082\179\066\210\113\073\243\113\195\185\012\083\058\146\054\075\218\022\066\248\020\200\252\213\126\170\000\096\193\173\202\161\092\210\108\008\225\173\075\138\152\255\194\249\213\146\064\049\192\121\185\254\087\128\245\118\011\221\181\037\111\185\039\164\030\003\048\231\051\073\011\003\168\157\185\083\163\071\066\008\139\146\176\037\111\185\135\148\001\240\206\191\040\233\110\155\237\098\000\011\144\180\031\152\146\212\079\250\194\181\230\169\112\188\040\217\239\222\059\097\253\189\138\099\179\216\247\180\141\237\052\021\128\158\187\036\121\192\198\077\216\105\240\142\033\103\136\017\180\179\192\116\210\181\007\053\110\134\126\007\238\138\051\233\202\105\115\224\155\138\011\148\050\120\143\039\205\130\001\000\044\186\098\233\219\202\014\184\119\118\015\001\032\178\224\123\091\009\178\036\089\080\001\064\044\172\250\010\184\166\106\246\034\165\237\249\174\070\044\120\040\089\022\056\000\102\220\023\158\181\008\174\033\133\021\177\038\241\225\026\044\248\033\089\022\084\048\224\013\087\088\157\013\121\047\050\160\107\052\047\006\004\196\180\089\080\170\031\062\028\029\175\179\049\113\044\120\178\102\044\200\147\093\017\092\009\109\109\154\058\022\076\219\146\087\197\130\194\234\020\001\246\141\154\005\035\203\004\067\008\011\113\039\086\055\045\181\113\121\008\225\188\164\087\093\022\040\119\020\022\036\173\179\190\219\221\126\162\029\230\088\176\001\248\205\024\176\080\170\082\061\238\254\053\039\168\109\230\098\193\065\231\248\159\192\155\049\143\104\181\057\022\108\180\106\212\067\241\218\060\006\218\214\151\219\057\103\187\107\210\113\175\239\053\231\120\021\008\099\027\219\216\198\054\182\177\253\255\118\017\129\190\185\187\220\248\003\139\000\000\000\000\073\069\078\068\174\066\096\130",
        ["Visuals"] = "\137\080\078\071\013\010\026\010\000\000\000\013\073\072\068\082\000\000\000\064\000\000\000\064\008\006\000\000\000\170\105\113\222\000\000\006\017\073\068\065\084\120\218\237\154\093\136\085\085\020\199\255\251\222\145\004\053\112\040\141\236\067\009\145\100\010\161\050\005\051\021\164\039\013\163\065\065\136\160\151\158\066\250\120\009\161\135\064\005\041\196\162\002\019\146\008\065\009\012\042\098\130\032\123\152\044\035\043\050\012\163\200\082\075\018\027\103\212\209\123\231\215\067\107\195\114\119\238\189\231\206\220\143\049\206\130\203\156\185\231\220\189\215\250\239\181\254\107\173\189\143\084\072\033\133\020\082\072\033\133\020\082\072\033\029\023\032\000\161\155\058\132\014\026\091\178\249\130\036\066\008\213\228\126\057\222\179\251\099\255\151\085\046\155\241\077\003\102\160\092\155\030\016\141\142\043\009\220\038\233\030\073\203\037\221\033\233\038\073\215\219\227\035\146\254\144\116\076\210\065\073\095\133\016\126\205\026\231\090\088\241\171\086\014\088\006\188\003\156\039\191\156\183\223\044\075\060\041\076\122\119\119\215\075\128\129\196\176\043\192\037\251\092\001\070\237\147\126\239\101\000\088\146\053\199\100\099\243\178\093\207\005\222\050\195\000\198\128\203\025\171\252\075\141\235\040\151\237\183\216\088\187\045\140\162\151\133\073\193\001\022\163\132\016\000\158\148\180\069\210\076\187\029\227\118\072\210\105\073\055\074\058\036\233\115\073\131\146\110\177\251\191\073\090\042\105\137\164\251\037\157\073\056\034\146\232\089\073\155\067\008\175\027\000\161\171\220\224\086\189\007\216\154\172\030\192\105\251\123\004\088\010\204\202\049\230\044\123\246\072\050\134\247\162\151\129\158\174\134\132\083\096\054\112\208\197\120\021\024\002\254\006\142\003\079\000\051\018\146\236\049\082\235\073\174\075\238\185\025\246\219\227\054\214\144\141\029\057\226\032\048\219\235\210\013\227\251\076\193\184\066\094\193\237\192\252\196\240\144\147\079\060\016\243\109\172\040\085\160\098\215\063\002\119\118\020\004\103\252\114\224\140\091\249\168\084\197\184\064\046\060\194\056\137\181\199\253\255\052\112\214\129\016\129\254\019\088\222\017\016\156\241\253\142\229\043\166\016\192\009\224\097\183\226\165\090\025\035\186\188\011\137\076\160\252\056\192\074\155\035\245\132\081\160\191\173\032\000\083\236\239\122\151\222\042\078\137\067\192\156\122\074\228\033\172\090\207\056\240\231\000\095\056\240\043\046\093\174\247\186\182\195\248\181\134\124\053\089\249\247\128\233\121\140\007\166\000\143\000\175\000\031\001\031\003\111\000\027\035\089\214\001\033\142\049\221\230\036\209\165\010\172\109\041\008\014\249\021\192\176\161\237\171\181\221\209\117\107\053\061\078\241\213\192\183\117\074\224\159\129\013\013\064\040\185\080\218\157\084\153\099\166\227\138\150\132\067\098\252\136\067\252\156\145\207\142\070\012\239\140\127\202\041\091\113\196\025\175\061\168\219\026\128\016\028\016\059\076\151\115\206\035\071\038\012\066\194\246\222\248\088\144\236\108\196\242\206\248\149\025\196\149\037\158\221\031\203\001\066\212\113\103\146\138\035\008\227\203\014\078\241\062\067\054\085\110\175\197\114\185\142\241\193\062\215\001\199\220\202\055\146\024\203\103\129\027\234\237\026\185\140\050\197\116\242\197\024\166\123\095\083\032\056\215\090\000\156\076\216\022\096\111\158\237\044\007\226\186\038\140\247\241\012\176\169\145\242\094\015\007\130\215\247\036\176\176\030\071\253\039\182\128\155\129\159\050\242\252\190\188\085\157\115\207\215\050\136\179\145\196\212\246\126\158\244\153\112\194\190\140\112\059\105\021\101\168\011\130\083\122\187\139\169\056\200\001\095\188\052\225\073\003\227\240\128\008\248\247\222\200\028\027\049\177\168\058\224\230\140\156\181\063\011\204\090\134\076\139\227\186\150\185\103\156\237\115\105\002\137\104\060\191\013\166\107\045\155\026\162\024\128\121\073\252\087\019\020\155\009\129\055\039\016\002\003\121\098\055\009\129\253\009\153\098\132\122\159\223\184\201\227\186\011\129\083\117\072\176\212\128\004\035\000\027\039\064\130\155\115\146\096\169\014\009\158\114\153\160\212\108\026\092\232\058\176\074\146\006\067\131\002\040\166\193\025\192\239\182\162\213\028\198\199\030\227\002\112\107\131\010\051\056\175\221\155\209\153\158\115\025\160\103\188\133\208\178\026\133\208\158\070\187\181\014\200\071\051\114\116\045\227\099\151\249\076\142\066\040\142\191\167\070\033\244\096\171\170\193\180\020\142\158\176\171\137\106\112\091\226\226\149\164\177\242\028\241\118\061\112\147\042\112\087\006\184\035\237\234\007\134\157\043\071\055\107\166\031\120\220\241\074\150\012\001\207\213\027\047\163\015\240\068\221\218\102\040\163\029\094\229\144\174\184\253\191\087\157\082\141\186\184\089\192\038\107\103\191\003\142\002\031\002\207\003\115\235\229\124\007\100\201\230\028\074\116\185\002\172\106\247\158\064\127\082\105\093\048\212\223\005\166\229\233\231\039\184\033\050\205\230\026\182\185\125\154\238\111\139\241\025\074\108\072\170\182\081\219\185\253\018\088\090\143\023\098\252\038\167\072\165\116\087\184\070\188\247\001\135\109\174\209\132\080\055\116\122\095\112\141\059\239\243\037\231\041\224\161\086\028\101\037\032\109\000\190\113\174\094\113\231\136\107\186\181\051\188\216\145\090\084\234\047\251\127\043\208\219\130\109\241\094\096\139\091\233\139\073\145\179\184\219\103\003\243\140\200\124\005\023\093\243\184\109\162\102\186\187\165\185\114\086\008\216\247\235\221\185\067\037\073\193\071\129\121\093\049\062\131\149\123\237\056\059\221\159\139\064\012\002\119\001\051\115\140\057\211\158\029\116\096\166\189\196\190\232\093\019\061\026\107\201\225\168\123\009\226\069\073\207\074\154\042\169\106\221\100\201\014\053\127\144\180\064\210\097\073\159\072\250\204\238\151\237\016\245\001\073\171\036\221\171\127\095\148\184\083\082\175\221\011\246\220\037\073\047\073\122\033\132\080\245\115\079\166\227\241\069\174\035\139\043\056\082\099\007\056\235\026\087\205\121\150\223\015\044\202\179\027\213\245\211\098\183\021\054\088\231\005\137\152\057\070\237\186\214\011\018\131\192\186\086\100\149\078\129\080\074\200\108\053\240\129\021\046\121\101\216\126\179\186\214\184\173\146\118\190\036\085\246\175\194\037\047\073\221\045\233\118\073\023\221\078\205\009\073\095\075\250\084\238\037\169\172\177\174\009\000\018\151\029\011\033\144\124\063\213\136\077\118\255\098\202\043\146\074\237\050\188\099\000\036\205\080\124\081\114\044\101\111\051\184\172\014\191\040\025\186\200\021\087\205\157\122\072\033\133\020\082\072\033\133\020\082\072\033\133\180\087\254\001\104\007\110\121\009\240\180\251\000\000\000\000\073\069\078\068\174\066\096\130",
    }

    -- Icono automatico segun la posicion del tab (el 2 se queda como esta)
    Library.TabIcons = {
        [1] = "Aim",
        [3] = "Triggerbot",
        [4] = "Visuals"
    }

    for Name, Data in Library.Icons do
        writefile(Library.Folders.Assets .. "/Icon_" .. Name .. ".png", Data)
    end

    -- Tweening
    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item 

            if Item:IsA("Frame") then
                return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then 
                return { "Transparency" }
            end
        end

        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item 

            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency

            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
                [Property] = Visibility and OldTransparency or 1
            }, true)

            Library:Connect(NewTween.Tween.Completed, function()
                if not Visibility then 
                    task.wait()
                    Item[Property] = OldTransparency
                end
            end)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    -- Instances
    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                if Property == "Theme" then
                    continue
                end

                NewItem.Instance[Property] = Value
            end

            -- juanita style: Theme = {Property = "ThemeKey"} registers the item automatically
            if NewItem.Properties.Theme then
                Library:AddToTheme(NewItem, NewItem.Properties.Theme)
            end

            return NewItem
        end

        Instances.FadeItem = function(self, Visibility, Speed)
            local Item = self.Instance

            if Visibility == true then 
                Item.Visible = true
            end

            local Descendants = Item:GetDescendants()
            TableInsert(Descendants, Item)

            local NewTween

            for Index, Value in Descendants do 
                local TransparencyProperty = Tween:GetProperty(Value)

                if not TransparencyProperty then 
                    continue
                end

                if type(TransparencyProperty) == "table" then 
                    for _, Property in TransparencyProperty do 
                        NewTween = Tween:FadeItem(Value, Property, not Visibility, Speed)
                    end
                else
                    NewTween = Tween:FadeItem(Value, TransparencyProperty, not Visibility, Speed)
                end
            end
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
            return self
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        -- Bordes de redimensionado compartidos (ventana y paneles)
        local MakeEdges = function(Gui, Thickness, OnBegin, Sides)
            local Edges = { }

            local Definitions = {
                {"L", UDim2New(0, 0, 0, 0), UDim2New(0, Thickness, 1, 0)},
                {"R", UDim2New(1, -Thickness, 0, 0), UDim2New(0, Thickness, 1, 0)},
                {"T", UDim2New(0, 0, 0, 0), UDim2New(1, 0, 0, Thickness)},
                {"B", UDim2New(0, 0, 1, -Thickness), UDim2New(1, 0, 0, Thickness)}
            }

            for Index, Definition in Definitions do
                local Side = Definition[1]

                if Sides and not TableFind(Sides, Side) then
                    continue
                end

                local Button = Instances:Create("TextButton", {
                    Name = "\0",
                    Position = Definition[2],
                    Size = Definition[3],
                    BackgroundColor3 = FromRGB(166, 147, 243),
                    BackgroundTransparency = 1,
                    Text = "",
                    BorderSizePixel = 0,
                    AutoButtonColor = false,
                    Parent = Gui,
                    ZIndex = 99999,
                })  Button:AddToTheme({BackgroundColor3 = "Accent"})

                Button:Connect("InputBegan", function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        OnBegin(Side)
                    end
                end)

                TableInsert(Edges, {Button = Button, Side = Side})
            end

            return function(ActiveSide)
                for Index, Value in Edges do
                    Value.Button.Instance.BackgroundTransparency = (ActiveSide and Value.Side == ActiveSide) and 0 or 1
                end
            end
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then
                return
            end

            local Gui = self.Instance

            local Dragging = false
            local Pointer = Vector2New(0, 0)
            local PointerStart = Vector2New(0, 0)

            local BasePosition = Gui.Position
            local BaseAbsolute = Vector2New(0, 0)

            local Target = nil
            local Current = Vector2New(0, 0)

            local Smoothness = 24

            -- Calcula hasta donde debe ir la ventana (solo el delta del cursor, sin tocar Position/AnchorPoint al hacer click)
            local UpdateTarget = function()
                local Desired = BaseAbsolute + (Pointer - PointerStart)
                local Parent = Gui.Parent

                if Parent and Parent:IsA("GuiBase2d") then
                    local Min = Parent.AbsolutePosition
                    local Max = Min + Parent.AbsoluteSize - Gui.AbsoluteSize

                    Desired = Vector2New(
                        MathClamp(Desired.X, Min.X, math.max(Min.X, Max.X)),
                        MathClamp(Desired.Y, Min.Y, math.max(Min.Y, Max.Y))
                    )
                end

                Target = Desired - BaseAbsolute
            end

            local InputChanged

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true

                    PointerStart = Vector2New(Input.Position.X, Input.Position.Y)
                    Pointer = PointerStart

                    BasePosition = Gui.Position
                    BaseAbsolute = Gui.AbsolutePosition

                    Current = Vector2New(0, 0)
                    Target = Vector2New(0, 0)

                    if InputChanged then
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Pointer = Vector2New(Input.Position.X, Input.Position.Y)
                    end
                end
            end)

            -- Movimiento suavizado
            Library:Connect(RunService.RenderStepped, function(DeltaTime)
                if not Target then
                    return
                end

                if Dragging then
                    UpdateTarget()
                end

                local Alpha = 1 - math.exp(-DeltaTime * Smoothness)
                Current = Current:Lerp(Target, Alpha)

                local Finished = false

                if not Dragging and (Target - Current).Magnitude < 0.25 then
                    Current = Target
                    Finished = true
                end

                Gui.Position = UDim2New(
                    BasePosition.X.Scale, BasePosition.X.Offset + Current.X,
                    BasePosition.Y.Scale, BasePosition.Y.Offset + Current.Y
                )

                if Finished then
                    Target = nil
                end
            end)
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum, Options)
            if not self.Instance then
                return
            end

            local Gui = self.Instance
            Maximum = Maximum or Vector2New(9999, 9999)
            Options = Options or { }

            local Resizing = false
            local CurrentSide = nil

            local StartMouse = nil
            local StartPosition = nil
            local StartSize = nil

            local Highlight

            -- Funciona con cualquier AnchorPoint (no cambia la posicion al empezar)
            local BeginResizing = function(Side)
                Resizing = true
                CurrentSide = Side

                -- paneles con tamaño automatico: pasan a tamaño fijo en pixeles
                if not Options.AutoHeight and Gui.AutomaticSize ~= Enum.AutomaticSize.None then
                    local Absolute = Gui.AbsoluteSize
                    Gui.AutomaticSize = Enum.AutomaticSize.None
                    Gui.Size = UDim2FromOffset(Absolute.X, Absolute.Y)
                end

                StartMouse = UserInputService:GetMouseLocation()
                StartPosition = Gui.Position
                StartSize = Vector2New(Gui.Size.X.Offset, Gui.Size.Y.Offset)

                Highlight(Side)
            end

            Highlight = MakeEdges(Gui, Options.Thickness or 2, BeginResizing, Options.Sides)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Resizing then
                        Resizing = false
                        CurrentSide = nil
                        Highlight(nil)
                    end
                end
            end)

            Library:Connect(RunService.RenderStepped, function()
                if not Resizing or not CurrentSide then
                    return
                end

                local MouseLocation = UserInputService:GetMouseLocation()
                local dx = MouseLocation.X - StartMouse.X
                local dy = MouseLocation.Y - StartMouse.Y

                local w, h = StartSize.X, StartSize.Y

                if CurrentSide == "L" then
                    w = StartSize.X - dx
                elseif CurrentSide == "R" then
                    w = StartSize.X + dx
                elseif CurrentSide == "T" then
                    h = StartSize.Y - dy
                elseif CurrentSide == "B" then
                    h = StartSize.Y + dy
                end

                w = MathClamp(w, Minimum.X, Maximum.X)
                h = MathClamp(h, Minimum.Y, Maximum.Y)

                if Options.AutoHeight then
                    h = StartSize.Y
                end

                local dw = w - StartSize.X
                local dh = h - StartSize.Y

                local Anchor = Gui.AnchorPoint
                local px, py = 0, 0

                if CurrentSide == "L" then
                    px = -dw * (1 - Anchor.X)
                elseif CurrentSide == "R" then
                    px = dw * Anchor.X
                elseif CurrentSide == "T" then
                    py = -dh * (1 - Anchor.Y)
                elseif CurrentSide == "B" then
                    py = dh * Anchor.Y
                end

                Gui.Size = UDim2FromOffset(w, h)
                Gui.Position = UDim2New(
                    StartPosition.X.Scale, StartPosition.X.Offset + px,
                    StartPosition.Y.Scale, StartPosition.Y.Offset + py
                )
            end)
        end

        -- Redimensionado por escala (UIScale) para paneles con tamaño automatico
        Instances.MakeScalable = function(self, MinScale, MaxScale)
            if not self.Instance then
                return
            end

            local Gui = self.Instance

            MinScale = MinScale or 0.6
            MaxScale = MaxScale or 2.5

            local UIScaleItem = Instances:Create("UIScale", {
                Parent = Gui,
                Name = "\0",
                Scale = 1
            })

            local Scaling = false
            local CurrentSide = nil

            local StartMouse = nil
            local StartPosition = nil
            local StartSize = nil
            local StartScale = 1

            local Highlight

            local BeginScaling = function(Side)
                Scaling = true
                CurrentSide = Side

                StartMouse = UserInputService:GetMouseLocation()
                StartPosition = Gui.Position
                StartSize = Vector2New(math.max(Gui.AbsoluteSize.X, 1), math.max(Gui.AbsoluteSize.Y, 1))
                StartScale = UIScaleItem.Instance.Scale

                Highlight(Side)
            end

            Highlight = MakeEdges(Gui, 4, BeginScaling)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if Scaling then
                        Scaling = false
                        CurrentSide = nil
                        Highlight(nil)
                    end
                end
            end)

            Library:Connect(RunService.RenderStepped, function()
                if not Scaling or not CurrentSide then
                    return
                end

                local MouseLocation = UserInputService:GetMouseLocation()
                local dx = MouseLocation.X - StartMouse.X
                local dy = MouseLocation.Y - StartMouse.Y

                local Factor = 1

                if CurrentSide == "L" then
                    Factor = (StartSize.X - dx) / StartSize.X
                elseif CurrentSide == "R" then
                    Factor = (StartSize.X + dx) / StartSize.X
                elseif CurrentSide == "T" then
                    Factor = (StartSize.Y - dy) / StartSize.Y
                elseif CurrentSide == "B" then
                    Factor = (StartSize.Y + dy) / StartSize.Y
                end

                local NewScale = MathClamp(StartScale * Factor, MinScale, MaxScale)
                local Real = NewScale / StartScale

                local dw = StartSize.X * Real - StartSize.X
                local dh = StartSize.Y * Real - StartSize.Y

                local Anchor = Gui.AnchorPoint
                local px, py

                -- el lado opuesto al que arrastras se queda fijo
                if CurrentSide == "L" then
                    px = -dw * (1 - Anchor.X)
                    py = dh * Anchor.Y
                elseif CurrentSide == "T" then
                    px = dw * Anchor.X
                    py = -dh * (1 - Anchor.Y)
                else
                    px = dw * Anchor.X
                    py = dh * Anchor.Y
                end

                UIScaleItem.Instance.Scale = NewScale
                Gui.Position = UDim2New(
                    StartPosition.X.Scale, StartPosition.X.Offset + px,
                    StartPosition.Y.Scale, StartPosition.Y.Offset + py
                )
            end)
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    -- Custom font (SmallestPixel en toda la UI)
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            local TtfPath = `{Library.Folders.Fonts}/{Data.Id}.ttf`
            local FontPath = `{Library.Folders.Fonts}/{Data.Id}.font`

            -- solo descarga si el archivo no existe o esta vacio
            if not isfile(TtfPath) or #readfile(TtfPath) < 1000 then
                writefile(TtfPath, game:HttpGet(Data.Url))
            end

            local FontData = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(TtfPath)
                    }
                }
            }

            writefile(FontPath, HttpService:JSONEncode(FontData))
            return Font.new(getcustomasset(FontPath))
        end

        -- Fuentes: Tahoma (titulo + watermark) y ProggyClean (todo lo demas)
        local Tahoma = CustomFont:New("Tahoma", 200, "normal", {
            Id = "Tahoma",
            Url = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/tahoma_bold.ttf"
        })

        local ProggyClean = CustomFont:New("ProggyClean", 200, "normal", {
            Id = "ProggyClean",
            Url = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf"
        })

        Library.Fonts = {
            Tahoma = Tahoma,
            ProggyTiny = Tahoma,
            ProggyClean = ProggyClean
        }

        Library.SubFont = ProggyClean
        Library.Font = ProggyClean
        Library.MenuFont = ProggyClean
        Library.TitleFont = Tahoma
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 2,
        IgnoreGuiInset = true,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Enabled = false,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        Position = UDim2New(0, 0, 0, 65),
        Size = UDim2New(0, 0, 1, 0),
        BorderColor3 = FromRGB(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    
    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        Padding = UDimNew(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    Instances:Create("UIPadding", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        PaddingTop = UDimNew(0, 12),
        PaddingBottom = UDimNew(0, 12),
        PaddingRight = UDimNew(0, 12),
        PaddingLeft = UDimNew(0, 12)
    })

    Library.Unload = function(self)
        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        Library = nil 
        getgenv().Library = nil
    end

    Library.GetIcon = function(self, Name)
        if not self.Icons[Name] then
            return
        end

        return getcustomasset(self.Folders.Assets .. "/Icon_" .. Name .. ".png")
    end

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]

        if not ImageData then 
            return
        end

        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)
        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        Library:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value()
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

	Library.ToRich = function(self, Text, Color)
		return `<font color="rgb({MathFloor(Color.R * 255)}, {MathFloor(Color.G * 255)}, {MathFloor(Color.B * 255)})">{Text}</font>`
	end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha, Rainbow = Value.Rainbow}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha, Value.Rainbow)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then 
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local List = { }
        local ReturnList = { }

        List = listfiles(Library.Folders.Configs)

        for Index = 1, #List do 
            local File = List[Index]

            if File:sub(-5) == ".json" then
                local Position = File:find(".json", 1, true)
                local StartPosition = Position

                local Character = File:sub(Position, Position)
                while Character ~= "/" and Character ~= "\\" and Character ~= "" do
                    Position = Position - 1
                    Character = File:sub(Position, Position)
                end

                if Character == "/" or Character == "\\" then
                    TableInsert(ReturnList, File:sub(Position + 1, StartPosition - 1))
                end
            end
        end

        Element:Refresh(ReturnList)
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.RemoveFromTheme = function(self, Item)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = nil
        self.ThemeMap[Item] = nil
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance

        local MousePosition = Vector2New(Mouse.X, Mouse.Y)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.GetLighterColor = function(self, Color, Increment)
        local Hue, Saturation, Value = Color:ToHSV()
        return FromHSV(Hue, Saturation, Value * Increment)
    end

    Library.GetDarkerColor = function(self, Color, Increment)
        local Hue, Saturation, Value = Color:ToHSV()
        return FromHSV(Hue, Saturation, Value / Increment)
    end

    do 
        Library.CreateColorpicker = function(self, Data)
            local Colorpicker = {
                Flag = Data.Flag,

                Hue = 0,
                Saturation = 0,
                Value = 0,

                Alpha = 0,

                Color = FromRGB(255, 255, 255),
                HexValue = "#ffffff",

                Rainbow = false,

                IsOpen = false
            }

            local Items = { } do
                Items["ColorpickerButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 20, 0, 10),
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(163, 163, 163))}
                })                

                Items["ColorpickerWindow"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Background"},
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    Position = UDim2New(0, 1123, 0, 238),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 192, 0, 232),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"]
                })
                
                
                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    BorderOffset = UDimNew(0, 1)
                })
                
                Items["Alpha"] = Instances:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 8, 1, -29),
                    Size = UDim2New(1, -16, 0, 15),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 240, 123)
                })
                
                
                Items["Checkers"] = Instances:Create("ImageLabel", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    ScaleType = Enum.ScaleType.Tile,
                    BorderColor3 = FromRGB(0, 0, 0),
                    TileSize = UDim2New(0, 6, 0, 6),
                    Image = "http://www.roblox.com/asset/?id=18274452449",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Checkers"].Instance,
                    Name = "\0",
                    Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(0.37, 0.5), NumSequenceKeypoint(1, 0)}
                })
                
                
                Items["AlphaDragger"] = Instances:Create("Frame", {
                    Parent = Items["Alpha"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["AlphaDragger"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                
                Items["Palette"] = Instances:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Position = UDim2New(0, 8, 0, 8),
                    Size = UDim2New(1, -39, 1, -58),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 240, 123)
                })
                
                Items["Saturation"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Saturation"].Instance,
                    Name = "\0",
                    Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
                })
                
                
                Items["Value"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 1, 1, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(0, 0, 0)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Transparency = NumSequence{NumSequenceKeypoint(0, 1), NumSequenceKeypoint(1, 0)}
                })
                
                
                
                Items["PaletteDragger"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 5, 0, 5),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 3, 0, 3),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                
                Items["Hue"] = Instances:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, -8, 0, 8),
                    Size = UDim2New(0, 15, 1, -58),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                
                Items["HueInline"] = Instances:Create("TextButton", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                
                Instances:Create("UIGradient", {
                    Parent = Items["HueInline"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
                })
                
                Items["HueDragger"] = Instances:Create("Frame", {
                    Parent = Items["HueInline"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["HueDragger"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })                

                Items["RainbowButton"] = Instances:Create("TextButton", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 8, 1, -8),
                    Size = UDim2New(1, -16, 0, 13),
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["RainbowIndicator"] = Instances:Create("Frame", {
                    Parent = Items["RainbowButton"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 0, 0.5, 0),
                    Size = UDim2New(0, 9, 0, 9),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element 2"]
                })  Items["RainbowIndicator"]:AddToTheme({BackgroundColor3 = function()
                    return Library.Theme["Element 2"]
                end})


                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["RainbowIndicator"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Items["RainbowText"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Text"},
                    Parent = Items["RainbowButton"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    Text = "Rainbow",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 17, 0.5, -2),
                    Size = UDim2New(0, 0, 0, 13),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
            end

            function Colorpicker:Get()
                return Colorpicker.Color, Colorpicker.Alpha
            end

            function Colorpicker:Update(IsFromAlpha, Instant)
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = FromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()

                Library.Flags[Colorpicker.Flag] = {
                    Alpha = Colorpicker.Alpha,
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                    Rainbow = Colorpicker.Rainbow
                }

                if Instant then
                    Items["ColorpickerButton"].Instance.BackgroundColor3 = Colorpicker.Color
                    Items["Palette"].Instance.BackgroundColor3 = FromHSV(Hue, 1, 1)

                    if not IsFromAlpha then
                        Items["Alpha"].Instance.BackgroundColor3 = Colorpicker.Color
                    end
                else
                    Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
                    Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})

                    if not IsFromAlpha then 
                        Items["Alpha"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
                    end
                end

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local CompareVectors = function(PointA, PointB)
                return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
            end

            local IsClipped = function(Object, Column)
                local Parent = Column
                
                local BoundryTop = Parent.AbsolutePosition
                local BoundryBottom = BoundryTop + Parent.AbsoluteSize

                local Top = Object.AbsolutePosition
                local Bottom = Top + Object.AbsoluteSize 

                return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
            end

            Items["ColorpickerButton"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Colorpicker.IsOpen then
                    Colorpicker.IsOpen = not IsClipped(Items["ColorpickerButton"].Instance, Data.Section.Items["Outline"].Instance.Parent)
                    Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                end
            end)

            local SlidingPalette = false
            local PaletteChanged
            
            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end

                local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY

                local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.98)
                local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.98)

                Items["PaletteDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
                Colorpicker:Update()
            end
            
            local SlidingHue = false
            local HueChanged

            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end
                
                local ValueY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Hue = ValueY

                local SlideY = MathClamp((Input.Position.Y - Items["Hue"].Instance.AbsolutePosition.Y) / Items["Hue"].Instance.AbsoluteSize.Y, 0, 0.995)

                Items["HueDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, SlideY, 0)})
                Colorpicker:Update()
            end

            local SlidingAlpha = false 
            local AlphaChanged

            function Colorpicker:SlideAlpha(Input)
                if not Input or not SlidingAlpha then
                    return
                end

                local ValueX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 1)

                Colorpicker.Alpha = ValueX

                local SlideX = MathClamp((Input.Position.X - Items["Alpha"].Instance.AbsolutePosition.X) / Items["Alpha"].Instance.AbsoluteSize.X, 0, 0.995)

                Items["AlphaDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0, 0)})
                Colorpicker:Update(true)
            end

            local Debounce = false
            local RenderStepped  

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 

                if Colorpicker.IsOpen then 
                    Items["ColorpickerWindow"].Instance.Visible = true
                    Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["ColorpickerWindow"].Instance.Position = UDim2New(
                            0, 
                            Items["ColorpickerButton"].Instance.AbsolutePosition.X, 
                            0, 
                            Items["ColorpickerButton"].Instance.AbsolutePosition.Y + Items["ColorpickerButton"].Instance.AbsoluteSize.Y + 65
                        )
                    end)

                    for Index, Value in Library.OpenFrames do 
                        Value:SetOpen(false)
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker 
                else
                    if Library.OpenFrames[Colorpicker] then 
                        Library.OpenFrames[Colorpicker] = nil
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                    task.wait(0.2)
                    Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            local RainbowEntry

            function Colorpicker:SetRainbow(Bool)
                Colorpicker.Rainbow = Bool

                if Bool then
                    Items["RainbowIndicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                    Items["RainbowIndicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})

                    -- si el color es blanco/negro/gris no se veria nada, asi que lo saturo
                    if Colorpicker.Saturation < 0.2 or Colorpicker.Value < 0.2 then
                        Colorpicker.Saturation = 1
                        Colorpicker.Value = 1
                        Items["PaletteDragger"].Instance.Position = UDim2New(0, 0, 0, 0)
                    end

                    if not RainbowEntry then
                        RainbowEntry = {
                            Connection = RunService.RenderStepped:Connect(function()
                                Colorpicker.Hue = (os.clock() * Library.RainbowSpeed) % 1
                                Items["HueDragger"].Instance.Position = UDim2New(0, 0, MathClamp(Colorpicker.Hue, 0, 0.995), 0)
                                Colorpicker:Update(false, true)
                            end)
                        }

                        TableInsert(Library.Connections, RainbowEntry)
                    end
                else
                    Items["RainbowIndicator"]:ChangeItemTheme({BackgroundColor3 = function()
                        return Library.Theme["Element 2"]
                    end})
                    Items["RainbowIndicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element 2"]})

                    if RainbowEntry then
                        RainbowEntry.Connection:Disconnect()

                        local Index = TableFind(Library.Connections, RainbowEntry)
                        if Index then
                            TableRemove(Library.Connections, Index)
                        end

                        RainbowEntry = nil
                        Colorpicker:Update()
                    end
                end
            end

            function Colorpicker:Set(Color, Alpha, Rainbow)
                if type(Color) == "table" then
                    Alpha = Color[4]
                    Color = FromRGB(Color[1], Color[2], Color[3])
                elseif type(Color) == "string" then
                    Color = FromHex(Color)
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0  

                local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.98)
                local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.98)

                local AlphaPositionX = MathClamp(Colorpicker.Alpha, 0, 0.99)
                    
                local HuePositionY = MathClamp(Colorpicker.Hue, 0, 0.99)

                Items["PaletteDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
                Items["HueDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(0, 0, HuePositionY, 0)})
                Items["AlphaDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(AlphaPositionX, 0, 0, 0)})
                Colorpicker:Update()
                Colorpicker:SetRainbow(Rainbow == true)
            end

            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingPalette = true 

                    Colorpicker:SlidePalette(Input)

                    if PaletteChanged then
                        return
                    end

                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false

                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)

            Items["HueInline"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingHue = true 

                    Colorpicker:SlideHue(Input)

                    if HueChanged then
                        return
                    end

                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false

                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)

            Items["Alpha"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingAlpha = true 

                    Colorpicker:SlideAlpha(Input)

                    if AlphaChanged then
                        return
                    end

                    AlphaChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingAlpha = false

                            AlphaChanged:Disconnect()
                            AlphaChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement then
                    if SlidingPalette then 
                        Colorpicker:SlidePalette(Input)
                    end

                    if SlidingHue then
                        Colorpicker:SlideHue(Input)
                    end

                    if SlidingAlpha then
                        Colorpicker:SlideAlpha(Input)
                    end
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Colorpicker.IsOpen then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                        return
                    end

                    Colorpicker:SetOpen(false)
                end
            end)

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            Items["RainbowButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetRainbow(not Colorpicker.Rainbow)
            end)
            
            if Data.Default then
                Colorpicker:Set(Data.Default, Data.Alpha)
            end

            Library.SetFlags[Colorpicker.Flag] = function(Value, Alpha, Rainbow)
                Colorpicker:Set(Value, Alpha, Rainbow)
            end

            return Colorpicker, Items 
        end

        Library.CreateKeybind = function(self, Data)
            local Keybind = {
                Flag = Data.Flag,

                Key = "",
                Value = "",
                Mode = "",

                Toggled = false,
                IsOpen = false,

                Picking = false,
            }   

            local Items = { } do 
                Items["KeyButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Inactive Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "[NONE]",
                    AutoButtonColor = false,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextSize = 12,
                    BackgroundColor3 = Library.Theme["Element 2"],
                    Theme = {BackgroundColor3 = "Element 2"}
                })

                Instances:Create("UIGradient", {
                    Parent = Items["KeyButton"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(163, 163, 163))}
                })

                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["KeyButton"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })

                Instances:Create("UIPadding", {
                    Parent = Items["KeyButton"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 2),
                    PaddingRight = UDimNew(0, 5),
                    PaddingLeft = UDimNew(0, 6)
                })

                Items["KeyButton"]:OnHover(function()
                    Items["KeyButton"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                end)

                Items["KeyButton"]:OnHoverLeave(function()
                    Items["KeyButton"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element 2"]})
                end)                

                Items["KeybindWindow"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Background"},
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Position = UDim2New(0, 53, 0, 104),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Visible = false,
                    Size = UDim2New(0, 125, 0, 80),
                    BorderSizePixel = 2,
                    BackgroundColor3 = Library.Theme["Background"]
                })
                
                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    BorderOffset = UDimNew(0, 1)
                })                

                Instances:Create("UIListLayout", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
            end

            local KeyListItem 

            if Library.KeyList then 
                KeyListItem = Library.KeyList:Add("", "")
            end

            local Modes = { }

            local Update = function()
                KeyListItem:SetText(Data.Name, Keybind.Mode)
                KeyListItem:Set(Keybind.Toggled)
            end

            function Keybind:SetMode(Mode)
                Keybind.Mode = Mode

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            local AddMode = function(Name) -- yo no problem
                local ModeItems = { }

                ModeItems[Name] = Instances:Create("TextButton", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                local ModeButton = ModeItems[Name] -- i haev to do this idk why
                
                ModeItems["Accent1"] = Instances:Create("Frame", {
                    Parent = ModeItems[Name].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 1, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    BackgroundColor3 = FromRGB(166, 147, 243)
                })  ModeItems["Accent1"]:AddToTheme({BackgroundColor3 = "Accent"})
                
                ModeItems["Accent2"] = Instances:Create("Frame", {
                    Parent = ModeItems[Name].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 1, 1, 0),
                    Position = UDim2New(0, 1, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(110, 97, 161)
                })  ModeItems["Accent2"]:AddToTheme({BackgroundColor3 = "Dark Accent"})
                
                ModeItems["Text"] = Instances:Create("TextLabel", {
                    Parent = ModeItems[Name].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = FromRGB(166, 147, 243),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 10, 0.5, -2),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  ModeItems["Text"]:AddToTheme({TextColor3 = function()
                    return Library.Theme["Inactive Text"]
                end})
                
                ModeItems["Background"] = Instances:Create("Frame", {
                    Parent = ModeItems[Name].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIGradient", {
                    Parent = ModeItems["Background"].Instance,
                    Name = "\0",
                    Transparency = NumSequence{NumSequenceKeypoint(0, 0.956250011920929), NumSequenceKeypoint(0.06, 0.9750000238418579), NumSequenceKeypoint(0.739, 1), NumSequenceKeypoint(1, 1)}
                })

                function ModeItems:Toggle()
                    ModeItems.Accent1:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 1, 1, 0)})
                    ModeItems.Accent2:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 1, 1, 0)})
                    ModeItems.Text:ChangeItemTheme({TextColor3 = "Accent"})
                    ModeItems.Text:Tween(nil, {TextColor3 = Library.Theme.Accent})
                    ModeItems.Background:Tween(nil, {BackgroundTransparency = 0})

                    for Index, Value in Modes do
                        if Index ~= Name then
                            Value.Accent1:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 1, 0, 0)})
                            Value.Accent2:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 1, 0, 0)})
                            Value.Text:ChangeItemTheme({TextColor3 = function()
                                return Library.Theme["Inactive Text"]
                            end})
                            Value.Text:Tween(nil, {TextColor3 = Library.Theme["Inactive Text"]})
                            Value.Background:Tween(nil, {BackgroundTransparency = 1})
                        end
                    end
                end

                Library:Connect(ModeButton.Instance.MouseButton1Down, function()
                    ModeItems:Toggle()
                    Keybind:SetMode(Name)
                end)

                Modes[Name] = ModeItems
                return ModeItems
            end

            local CompareVectors = function(PointA, PointB)
                return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
            end

            local IsClipped = function(Object, Column)
                local Parent = Column
                
                local BoundryTop = Parent.AbsolutePosition
                local BoundryBottom = BoundryTop + Parent.AbsoluteSize

                local Top = Object.AbsolutePosition
                local Bottom = Top + Object.AbsoluteSize 

                return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
            end

            Items["KeyButton"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Keybind.IsOpen then
                    Keybind.IsOpen = not IsClipped(Items["KeybindWindow"].Instance, Data.Section.Items["Outline"].Instance.Parent)
                    Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                end
            end)

            AddMode("Toggle")
            AddMode("Hold")
            AddMode("Always On")

            function Keybind:Get()
                return Keybind.Key, Keybind.Mode, Keybind.Toggled
            end

            function Keybind:Set(Key)
                if StringFind(tostring(Key), "Enum") then 
                    Keybind.Key = tostring(Key)

                    Key = Key.Name == "Backspace" and "None" or Key.Name

                    local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                    local TextToDisplay = "["..StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "").."]" or "[None]"

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    Library.Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                    Keybind.Key = tostring(Key.Key)

                    if Key.Mode then
                        Modes[Key.Mode]:Toggle()
                        Keybind:SetMode(Key.Mode)
                    else
                        Modes["Toggle"]:Toggle()
                        Keybind:SetMode("Toggle")
                    end

                    local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "[None]"

                    TextToDisplay = "["..StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "").."]"

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                elseif TableFind({"Toggle", "Hold", "Always On"}, Key) then
                    Modes[Key]:Toggle()
                    Keybind:SetMode(Key)

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end

                    Update()
                end

                Keybind.Picking = false
            end

            local Debounce = false
            local RenderStepped  

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Keybind.IsOpen = Bool

                Debounce = true 

                if Keybind.IsOpen then 
                    Items["KeybindWindow"].Instance.Visible = true
                    Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["KeybindWindow"].Instance.Position = UDim2New(
                            0, 
                            Items["KeyButton"].Instance.AbsolutePosition.X, 
                            0, 
                            Items["KeyButton"].Instance.AbsolutePosition.Y + Items["KeyButton"].Instance.AbsoluteSize.Y + 65
                        )
                    end)

                    for Index, Value in Library.OpenFrames do 
                        Value:SetOpen(false)
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                else
                    if Library.OpenFrames[Keybind] then 
                        Library.OpenFrames[Keybind] = nil
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["KeybindWindow"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                    task.wait(0.2)
                    Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then 
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then 
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always On" then 
                    Keybind.Toggled = true
                end

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end

                Update()
            end

            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true 

                Items["KeyButton"].Instance.Text = "."
                Library:Thread(function()
                    local Count = 1

                    while true do 
                        if not Keybind.Picking then 
                            break
                        end

                        if Count == 4 then
                            Count = 1
                        end

                        Items["KeyButton"].Instance.Text = Count == 1 and "." or Count == 2 and ".." or Count == 3 and "..."
                        Count += 1
                        task.wait(0.35)
                    end
                end)

                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then 
                        Keybind:Set(Input.KeyCode)
                    else
                        Keybind:Set(Input.UserInputType)
                    end

                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end)

            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Toggle" then 
                        Keybind:Press()
                    elseif Keybind.Mode == "Hold" then 
                        Keybind:Press(true)
                    elseif Keybind.Mode == "Always On" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Toggle" then 
                        Keybind:Press()
                    elseif Keybind.Mode == "Hold" then 
                        Keybind:Press(true)
                    elseif Keybind.Mode == "Always On" then 
                        Keybind:Press(true)
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Keybind.IsOpen then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                        return
                    end

                    Keybind:SetOpen(false)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always On" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always On" then 
                        Keybind:Press(true)
                    end
                end
            end)

            if Data.Default then 
                Keybind:Set({
                    Mode = Data.Mode or "Toggle",
                    Key = Data.Default,
                })
            end

            Library.SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items
        end

        Library.Notification = function(self, Name, Duration, Color)
            Color = Color or Library.Theme.Accent
            local Items = { } do
                Items["Notification"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Inline"},
                    Parent = Library.NotifHolder.Instance,
                    Name = "\0",
                    ClipsDescendants = true,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    BackgroundColor3 = Library.Theme["Inline"]
                })
                
                
                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    BorderOffset = UDimNew(0, 1)
                })
                
                Items["Accent1"] = Instances:Create("Frame", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 1, 1, 10),
                    Position = UDim2New(0, -8, 0, -7),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color
                })  
                 
                Items["Accent2"] = Instances:Create("Frame", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 1, 1, 10),
                    Position = UDim2New(0, -7, 0, -7),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library:GetDarkerColor(Color, 1.35)
                })  
                
                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, -8, 0, -7),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 10),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Transparency = NumSequence{NumSequenceKeypoint(0, 0.90625), NumSequenceKeypoint(0.075, 0.9437500238418579), NumSequenceKeypoint(0.427, 0.981249988079071), NumSequenceKeypoint(0.739, 1), NumSequenceKeypoint(1, 1)}
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Text"},
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    Position = UDim2New(0, 0, 0, -4),
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Name,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 7),
                    PaddingBottom = UDimNew(0, -12),
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })                
            end

            local OldSize = Items["Notification"].Instance.AbsoluteSize
            Items["Notification"].Instance.BackgroundTransparency = 1
            Items["Notification"].Instance.Size = UDim2New(0, 0, 0, 25)

            for Index, Value in Items["Notification"].Instance:GetDescendants() do
                if Value:IsA("UIStroke") then 
                    Value.Transparency = 1
                elseif Value:IsA("TextLabel") then 
                    Value.TextTransparency = 1
                elseif Value:IsA("Frame") then 
                    Value.BackgroundTransparency = 1
                end
            end
            
            task.wait(0.2)

            Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.Y
            local TweenInfoq = TweenInfo.new(0.55, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

            Library:Thread(function()
                Items["Notification"]:Tween(TweenInfoq, {BackgroundTransparency = 0, Size = UDim2New(0,  OldSize.X, 0, OldSize.Y)})
                
                task.wait(0.06)

                for Index, Value in Items["Notification"].Instance:GetDescendants() do
                    if Value:IsA("UIStroke") then
                        Tween:Create(Value, TweenInfoq, {Transparency = 0}, true)
                    elseif Value:IsA("TextLabel") then
                        Tween:Create(Value, TweenInfoq, {TextTransparency = 0}, true)
                    elseif Value:IsA("Frame") then
                        Tween:Create(Value, TweenInfoq, {BackgroundTransparency = 0}, true)
                    end
                end

                task.delay(Duration, function()
                    for Index, Value in Items["Notification"].Instance:GetDescendants() do
                        if Value:IsA("UIStroke") then
                            Tween:Create(Value, TweenInfoq, {Transparency = 1}, true)
                        elseif Value:IsA("TextLabel") then
                            Tween:Create(Value, TweenInfoq, {TextTransparency = 1}, true)
                        elseif Value:IsA("Frame") then
                            Tween:Create(Value, TweenInfoq, {BackgroundTransparency = 1}, true)
                        end
                    end

                    task.wait(0.06)
                    Items["Notification"]:Tween(TweenInfoq, {BackgroundTransparency = 1, Size = UDim2New(0, 0, 0, 0)})

                    task.wait(0.5)
                    Items["Notification"]:Clean()
                end)
            end)
        end

        Library.KeybindList = function(self)
            local KeybindList = { }
            Library.KeyList = KeybindList

            local Items = { } do
                Items["KeybindsList"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Background"},
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    Size = UDim2New(0, 180, 0, 35),
                    Position = UDim2New(0.014184396713972092, 0, 0.3557213842868805, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                })
                
                
                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["KeybindsList"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["KeybindsList"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    BorderOffset = UDimNew(0, 1)
                })
                
                Items["Top"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Inline"},
                    Parent = Items["KeybindsList"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                })
                
                Items["Liner"] = Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})

                Instances:Create("ImageLabel", {
                    Parent = Items["Liner"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Glow"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = Library.GlowTransparency,
                    Size = UDim2New(1, 8, 1, 8),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
                    Theme = {ImageColor3 = "Glow"}
                })
                

                

                

                

                

                
                Instances:Create("UIGradient", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(180, 180, 180))}
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Text"},
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Keybinds",
                    AnchorPoint = Vector2New(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, -2),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["KeybindsList"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 25),
                    Size = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 8),
                    PaddingTop = UDimNew(0, 5),
                    PaddingLeft = UDimNew(0, 8)
                })                
            end

            Items["KeybindsList"]:MakeDraggable()
            Items["KeybindsList"]:MakeResizeable(Vector2New(130, 0), Vector2New(9999, 9999), {Thickness = 4, AutoHeight = true, Sides = {"L", "R"}})

            function KeybindList:SetVisibility(Bool)
                Items["KeybindsList"].Instance.Visible = Bool
            end

            function KeybindList:Add(Name, Mode)
                local NewKey = Instances:Create("TextLabel", {
                    Parent = Items["Content"].Instance,
                    Visible = false,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = FromRGB(122, 122, 122),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Name,
                    Size = UDim2New(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                local NewKeyMode = Instances:Create("TextLabel", {
                    Parent = NewKey.Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = FromRGB(112, 112, 112),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Mode,
                    AnchorPoint = Vector2New(1, 0),
                    Size = UDim2New(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 50, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIPadding", {
                    Parent = NewKey.Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 55)
                })                

                function NewKey:SetText(Name, Mode)
                    NewKey.Instance.Text = Name
                    NewKeyMode.Instance.Text = Mode
                end

                function NewKey:Set(Bool)
                    NewKey.Instance.Visible = Bool
                end

                return NewKey
            end

            return KeybindList
        end

        -- Panel base con el mismo estilo que el Keybind List (header + liner + contenido)
        Library.CreatePanel = function(self, Title, Width, Position, AnchorPoint, MinSize)
            local Items = { } do
                Items["Panel"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Background"},
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    Size = UDim2New(0, Width, 0, 0),
                    Position = Position,
                    AnchorPoint = AnchorPoint or Vector2New(0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                })


                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["Panel"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["Panel"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    BorderOffset = UDimNew(0, 1)
                })

                Items["Top"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Inline"},
                    Parent = Items["Panel"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"]
                })

                Items["Liner"] = Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                })  Items["Liner"]:AddToTheme({BackgroundColor3 = "Accent"})

                Instances:Create("ImageLabel", {
                    Parent = Items["Liner"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Glow"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = Library.GlowTransparency,
                    Size = UDim2New(1, 8, 1, 8),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
                    Theme = {ImageColor3 = "Glow"}
                })











                Instances:Create("UIGradient", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(180, 180, 180))}
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Text"},
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Title,
                    AnchorPoint = Vector2New(0, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, -2),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Panel"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 25),
                    Size = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 8),
                    PaddingTop = UDimNew(0, 6),
                    PaddingLeft = UDimNew(0, 8),
                    PaddingRight = UDimNew(0, 8)
                })
            end

            Items["Panel"]:MakeDraggable()
            Items["Panel"]:MakeResizeable(MinSize or Vector2New(110, 45), Vector2New(9999, 9999), {Thickness = 4})

            return Items
        end

        -- Player indicator: avatar (headshot), nombre y barra de vida del jugador
        Library.PlayerIndicator = function(self)
            local Indicator = {
                Player = nil,
                Health = -1
            }

            local Items = Library:CreatePanel("Player indicator", 170, UDim2New(0.014, 0, 0.55, 0), nil, Vector2New(150, 75)) do
                Items["Row"] = Instances:Create("Frame", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Avatar"] = Instances:Create("ImageLabel", {
                    Parent = Items["Row"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 40, 0, 40),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Image = "",
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Library.Theme["Element 2"]
                })

                Items["Name"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Text"},
                    Parent = Items["Row"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "no target",
                    Position = UDim2New(0, 48, 0, 4),
                    Size = UDim2New(1, -82, 0, 14),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["HealthText"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Inactive Text"},
                    Parent = Items["Row"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Inactive Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, 0, 0, 4),
                    Size = UDim2New(0, 30, 0, 14),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Bar"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Element 2"},
                    Parent = Items["Row"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 48, 0, 24),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -48, 0, 12),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    BackgroundColor3 = Library.Theme["Element 2"]
                })

                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["Bar"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["Bar"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    BorderOffset = UDimNew(0, 1)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["Bar"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(163, 163, 163))}
                })

                Items["Fill"] = Instances:Create("Frame", {
                    Parent = Items["Bar"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(120, 230, 120)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["Fill"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(163, 163, 163))}
                })
            end

            function Indicator:SetPlayer(Player)
                Indicator.Player = Player
                Indicator.Health = -1

                if Player then
                    Items["Name"].Instance.Text = Player.Name
                    Items["Avatar"].Instance.Image = StringFormat("rbxthumb://type=AvatarHeadShot&id=%d&w=100&h=100", Player.UserId)
                else
                    Items["Name"].Instance.Text = "no target"
                    Items["Avatar"].Instance.Image = ""
                end
            end

            function Indicator:SetVisibility(Bool)
                Items["Panel"].Instance.Visible = Bool
            end

            Library:Connect(RunService.RenderStepped, function()
                local Player = Indicator.Player
                local Character = Player and Player.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

                local Health = Humanoid and MathFloor(Humanoid.Health) or 0
                local MaxHealth = Humanoid and Humanoid.MaxHealth or 100

                if Health == Indicator.Health then
                    return
                end

                Indicator.Health = Health

                local Ratio = MathClamp(Health / math.max(MaxHealth, 1), 0, 1)

                Items["HealthText"].Instance.Text = tostring(Health)
                Items["Fill"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2New(Ratio, 0, 1, 0),
                    BackgroundColor3 = FromHSV(Ratio * 0.33, 0.75, 0.95)
                })
            end)

            Library.IndicatorObj = Indicator
            return Indicator
        end

        -- Hotbar: fila con el icono de cada item
        Library.Hotbar = function(self)
            local Hotbar = {
                Slots = { },
                Signature = nil
            }

            local Items = Library:CreatePanel("Hotbar", 150, UDim2New(0.5, 0, 1, -16), Vector2New(0.5, 1), Vector2New(100, 80)) do
                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    Wraps = true,
                    Padding = UDimNew(0, 4),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            end

            -- List = { {Name = "glock", Icon = "rbxassetid://..."}, ... }
            function Hotbar:SetItems(List)
                List = List or { }

                local Signature = { }
                for Index, Value in List do
                    Signature[Index] = Value.Name .. "|" .. tostring(Value.Icon or "")
                end
                Signature = TableConcat(Signature, ";")

                if Signature == Hotbar.Signature then
                    return
                end

                Hotbar.Signature = Signature

                for Index, Slot in Hotbar.Slots do
                    Slot:Clean()
                end
                Hotbar.Slots = { }

                if Items["Panel"].Instance.AutomaticSize ~= Enum.AutomaticSize.None then
                    local Columns = MathClamp(#List, 1, 10)
                    Items["Panel"].Instance.Size = UDim2New(0, math.max(150, Columns * 44 + 12), 0, 0)
                end

                if #List == 0 then
                    local Empty = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Inactive Text"},
                        Parent = Items["Content"].Instance,
                        Name = "\0",
                        FontFace = Library.MenuFont,
                        TextColor3 = Library.Theme["Inactive Text"],
                        Text = "no items",
                        Size = UDim2New(1, 0, 0, 40),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        TextSize = 12,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })

                    TableInsert(Hotbar.Slots, Empty)
                    return
                end

                for Index, Value in List do
                    local Slot = Instances:Create("Frame", {
                                            Parent = Items["Content"].Instance,
                        Name = "\0",
                        Size = UDim2New(0, 40, 0, 40),
                        BorderSizePixel = 0,
                        BackgroundTransparency = 1,
                        LayoutOrder = Index,
                        BackgroundColor3 = Library.Theme["Element 2"]
                    })

                    if Value.Icon and Value.Icon ~= "" then
                        Instances:Create("ImageLabel", {
                            Parent = Slot.Instance,
                            Name = "\0",
                            Position = UDim2New(0, 4, 0, 4),
                            Size = UDim2New(1, -8, 1, -8),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            ScaleType = Enum.ScaleType.Fit,
                            Image = Value.Icon,
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        })
                    else
                        Instances:Create("TextLabel", {
                            Theme = {TextColor3 = "Inactive Text"},
                            Parent = Slot.Instance,
                            Name = "\0",
                            FontFace = Library.MenuFont,
                            TextColor3 = Library.Theme["Inactive Text"],
                            Text = string.upper(string.sub(Value.Name, 1, 3)),
                            Size = UDim2New(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            TextSize = 12,
                            BackgroundColor3 = FromRGB(255, 255, 255)
                        })
                    end

                    TableInsert(Hotbar.Slots, Slot)
                end
            end

            function Hotbar:SetVisibility(Bool)
                Items["Panel"].Instance.Visible = Bool
            end

            Hotbar:SetItems({ })

            Library.HotbarObj = Hotbar
            return Hotbar
        end

        -- Ammo indicator: copia del Player indicator, muestra la municion (actual/maximo) del arma equipada
        Library.AmmoIndicator = function(self)
            local Ammo = {
                Tool = nil,
                Sources = { },
                TrackedMax = 0,
                LastScan = 0,
                Signature = nil
            }

            local Items = Library:CreatePanel("Ammo", 170, UDim2New(0.014, 0, 0.68, 0), nil, Vector2New(150, 75)) do
                Items["Row"] = Instances:Create("Frame", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Row"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 40, 0, 40),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    ScaleType = Enum.ScaleType.Fit,
                    Image = "",
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Library.Theme["Element 2"]
                })

                Items["IconText"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Inactive Text"},
                    Parent = Items["Icon"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Inactive Text"],
                    Text = "",
                    Size = UDim2New(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Name"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Text"},
                    Parent = Items["Row"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Ammo",
                    Position = UDim2New(0, 48, 0, 4),
                    Size = UDim2New(1, -98, 0, 14),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Count"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Inactive Text"},
                    Parent = Items["Row"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Inactive Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "-",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, 0, 0, 4),
                    Size = UDim2New(0, 48, 0, 14),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                -- Misma barra que la de vida / sliders (stroke + gradientes)
                Items["Bar"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Element 2"},
                    Parent = Items["Row"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 48, 0, 24),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -48, 0, 12),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    BackgroundColor3 = Library.Theme["Element 2"]
                })

                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["Bar"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["Bar"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    BorderOffset = UDimNew(0, 1)
                })

                Instances:Create("UIGradient", {
                    Parent = Items["Bar"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(163, 163, 163))}
                })

                Items["Fill"] = Instances:Create("Frame", {
                    Parent = Items["Bar"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"]
                })  Items["Fill"]:AddToTheme({BackgroundColor3 = "Accent"})

                Instances:Create("UIGradient", {
                    Parent = Items["Fill"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(163, 163, 163))}
                })
            end

            local AmmoPatterns = {"ammo", "clip", "mag", "bullet", "rounds"}
            local MaxPatterns = {"max", "size", "capacity"}
            local IgnorePatterns = {"magnitude", "reserve", "spare", "total", "stored", "damage", "speed", "pickup"}
            local PreferredNames = {"ammo", "currentammo", "ammocount", "clip", "currentclip", "mag", "magazine", "bullets"}

            local ContainsAny = function(Text, List)
                Text = StringLower(Text)

                for Index = 1, #List do
                    if StringFind(Text, List[Index], 1, true) then
                        return true
                    end
                end

                return false
            end

            local Scan = function(Tool)
                local Result = { Current = nil, Max = nil }

                if not Tool then
                    return Result
                end

                local CurrentList, MaxList = { }, { }

                local Consider = function(Name, Getter)
                    if not ContainsAny(Name, AmmoPatterns) or ContainsAny(Name, IgnorePatterns) then
                        return
                    end

                    local Source = {Name = StringLower(Name), Get = Getter}

                    if ContainsAny(Name, MaxPatterns) then
                        TableInsert(MaxList, Source)
                    else
                        TableInsert(CurrentList, Source)
                    end
                end

                local ScanObject = function(Object)
                    for Name, Value in Object:GetAttributes() do
                        if type(Value) == "number" or type(Value) == "string" then
                            Consider(Name, function()
                                return Object:GetAttribute(Name)
                            end)
                        end
                    end

                    if Object:IsA("IntValue") or Object:IsA("NumberValue") or Object:IsA("StringValue") then
                        Consider(Object.Name, function()
                            return Object.Value
                        end)
                    end
                end

                -- 1) el arma equipada y todo lo que tiene dentro
                ScanObject(Tool)

                for Index, Descendant in Tool:GetDescendants() do
                    ScanObject(Descendant)
                end

                -- 2) si el arma no tiene nada, buscar en el personaje y el jugador
                if #CurrentList == 0 then
                    local Others = { LocalPlayer, LocalPlayer.Character }

                    for Index, Other in Others do
                        if Other then
                            ScanObject(Other)

                            for _, Child in Other:GetChildren() do
                                if not Child:IsA("Tool") and not Child:IsA("Backpack") then
                                    ScanObject(Child)
                                end
                            end
                        end
                    end
                end

                for Index, Source in CurrentList do
                    if TableFind(PreferredNames, Source.Name) then
                        Result.Current = Source
                        break
                    end
                end

                Result.Current = Result.Current or CurrentList[1]
                Result.Max = MaxList[1]

                return Result
            end

            -- devuelve actual y (si el valor es tipo "3/3") el maximo
            local Read = function(Source)
                if not Source then
                    return nil
                end

                local Success, Value = pcall(Source.Get)

                if not Success then
                    return nil
                end

                if type(Value) == "number" then
                    return Value
                end

                if type(Value) == "string" then
                    local Current, Maximum = string.match(Value, "(%d+)%s*/%s*(%d+)")

                    if Current then
                        return tonumber(Current), tonumber(Maximum)
                    end

                    return tonumber(string.match(Value, "%d+"))
                end

                return nil
            end

            function Ammo:SetVisibility(Bool)
                Items["Panel"].Instance.Visible = Bool
            end

            Library:Connect(RunService.RenderStepped, function()
                local Character = LocalPlayer.Character
                local Tool = Character and Character:FindFirstChildOfClass("Tool")
                local Now = os.clock()

                if Tool ~= Ammo.Tool then
                    Ammo.Tool = Tool
                    Ammo.Sources = Scan(Tool)
                    Ammo.TrackedMax = 0
                    Ammo.LastScan = Now
                elseif Tool and not Ammo.Sources.Current and Now - Ammo.LastScan > 1 then
                    Ammo.Sources = Scan(Tool)
                    Ammo.LastScan = Now
                end

                local Name = Tool and Tool.Name or ""
                local Texture = Tool and Tool.TextureId or ""
                local Current, Max = nil, nil

                if Tool then
                    local StringMax
                    Current, StringMax = Read(Ammo.Sources.Current)
                    Max = Read(Ammo.Sources.Max) or StringMax
                end

                if Current and (not Max or Max <= 0) then
                    Ammo.TrackedMax = math.max(Ammo.TrackedMax, Current)
                    Max = Ammo.TrackedMax
                end

                local Signature = StringFormat("%s|%s|%s|%s", Name, Texture, tostring(Current), tostring(Max))

                if Signature == Ammo.Signature then
                    return
                end

                Ammo.Signature = Signature

                -- icono del arma (o sus 3 primeras letras si no tiene textura)
                Items["Icon"].Instance.Image = Texture
                Items["IconText"].Instance.Text = Texture == "" and string.upper(string.sub(Name, 1, 3)) or ""

                if Current then
                    local Ratio = Max and Max > 0 and MathClamp(Current / Max, 0, 1) or 0

                    Items["Count"].Instance.Text = StringFormat("%d/%d", MathFloor(Current), MathFloor(Max or 0))
                    Items["Count"].Instance.TextColor3 = Current <= 0 and FromRGB(255, 70, 70) or Library.Theme["Inactive Text"]
                    Items["Fill"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New(Ratio, 0, 1, 0)})
                else
                    Items["Count"].Instance.Text = Tool and "n/a" or "-"
                    Items["Count"].Instance.TextColor3 = Library.Theme["Inactive Text"]
                    Items["Fill"]:Tween(TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New(0, 0, 1, 0)})
                end
            end)

            Library.AmmoObj = Ammo
            return Ammo
        end

        -- Unicas notificaciones: targetted / untargetted / killed / error
        Library.Alert = function(self, Kind, Text, Duration)
            local Colors = {
                targetted = Library.Theme.Accent,
                untargetted = FromRGB(150, 150, 150),
                killed = FromRGB(120, 255, 120),
                error = FromRGB(255, 70, 70)
            }

            task.spawn(function()
                Library:Notification(StringFormat("%s (%s)", Kind, tostring(Text)), Duration or 4, Colors[Kind] or Library.Theme.Accent)
            end)
        end

        Library.TitleLabels = { }

        Library.TitlePhrases = {
            "pchaxx13",
            "PPPPCCCCHHHAAAXXX1113333 $$$$$$$$",
            "pchaxx13 ◣_◢",
            "pchaxx13 on top",
            "pchaxx13 best roblox script",
            "pchaxx13 always ud ◣_◢",
            "pchaxx13 private script",
            "pchaxx13: generating free robux $$$",
            "pchaxx13 big money $$"
        }

        -- Registra un TextLabel para que muestre el titulo con animacion typewriter
        Library.AddTitle = function(self, Label)
            TableInsert(self.TitleLabels, Label)

            if self.TitleThread then
                return
            end

            self.TitleThread = Library:Thread(function()
                local Phrases = Library.TitlePhrases
                local Phrase = Phrases[1]

                local Set = function(Text)
                    for Index = #Library.TitleLabels, 1, -1 do
                        local Item = Library.TitleLabels[Index]
                        local Object = Item.Instance or Item

                        if Object and Object.Parent then
                            Object.Text = Text
                        else
                            TableRemove(Library.TitleLabels, Index)
                        end
                    end
                end

                while true do
                    local Length = utf8.len(Phrase)

                    for Count = 1, Length do
                        Set(Phrase:sub(1, utf8.offset(Phrase, Count + 1) - 1))
                        task.wait(0.09)
                    end

                    task.wait(2.5)

                    for Count = Length - 1, 0, -1 do
                        Set(Count == 0 and "" or Phrase:sub(1, utf8.offset(Phrase, Count + 1) - 1))
                        task.wait(0.04)
                    end

                    task.wait(0.4)

                    local Next = Phrase
                    while Next == Phrase and #Phrases > 1 do
                        Next = Phrases[math.random(1, #Phrases)]
                    end
                    Phrase = Next
                end
            end)
        end

        Library.Watermark = function(self, Name, Icon)
            local Watermark = { }

            local Items = { } do 
                Items["Watermark"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Background"},
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, -8, 0, 8),
                    Size = UDim2New(0, 0, 0, 28),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = Library.Theme["Background"]
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 4)
                })
                
                
                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    BorderOffset = UDimNew(0, 1)
                })
                
                
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Inactive Text"},
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    FontFace = Library.TitleFont,
                    RichText = true,
                    TextColor3 = Library.Theme["Inactive Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Name,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, -2),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Watermark"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(158, 158, 158))}
                })                
            end

            Items["Watermark"]:MakeDraggable()

            local Title = "PCHAXX13"
            local Plain = ""

            local Visible = false
            local Fading = false
            local Pending = nil

            local WaveWidth = 3     -- letras iluminadas a la vez
            local WaveSpeed = 4     -- letras por segundo

            local Fps, Frames, LastTick = 60, 0, os.clock()
            local White = FromRGB(255, 255, 255)

            local BuildPlain = function()
                Plain = StringFormat("%s | %d fps | %s | %s", Title, Fps, os.date("%d/%m/%Y"), os.date("%H:%M"))
            end

            BuildPlain()

            Library:Connect(RunService.RenderStepped, function()
                local Now = os.clock()
                Frames += 1

                if Now - LastTick >= 0.5 then
                    Fps = MathFloor(Frames / (Now - LastTick) + 0.5)
                    Frames = 0
                    LastTick = Now
                    BuildPlain()
                end

                if not Visible and not Fading then
                    return
                end

                -- el accent va pasando letra por letra con fade
                local Count = #Plain
                local Accent = Library.Theme.Accent
                local Center = (Now * WaveSpeed) % (Count + WaveWidth * 2) - WaveWidth
                local Parts = { }

                for Index = 1, Count do
                    local Strength = MathClamp(1 - math.abs(Index - Center) / (WaveWidth / 2), 0, 1)
                    Strength = Strength * Strength * (3 - 2 * Strength)

                    Parts[Index] = Library:ToRich(Plain:sub(Index, Index), White:Lerp(Accent, Strength))
                end

                Items["Text"].Instance.Text = TableConcat(Parts)
            end)

            local ApplyFade

            ApplyFade = function(Bool)
                local Frame = Items["Watermark"].Instance

                Fading = true
                Visible = Bool

                if Bool then
                    Frame.Visible = true
                end

                local Descendants = Frame:GetDescendants()
                TableInsert(Descendants, Frame)

                local NewTween

                for Index, Value in Descendants do
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue
                    end

                    if type(TransparencyProperty) == "table" then
                        for _, Property in TransparencyProperty do
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end

                local Finish = function()
                    Fading = false

                    if not Visible then
                        Frame.Visible = false
                    end

                    local Next = Pending
                    Pending = nil

                    if Next ~= nil and Next ~= Visible then
                        ApplyFade(Next)
                    end
                end

                if NewTween then
                    NewTween.Tween.Completed:Connect(Finish)
                else
                    Finish()
                end
            end

            function Watermark:SetText(Text)
                Title = tostring(Text)
                BuildPlain()
            end

            function Watermark:SetVisibility(Bool)
                if Fading then
                    Pending = Bool
                    return
                end

                if Bool == Visible then
                    return
                end

                ApplyFade(Bool)
            end

            -- fade de entrada
            Items["Watermark"].Instance.Visible = false
            ApplyFade(true)

            return Watermark 
        end

        Library.Window = function(self, Data)
            Data = Data or { }

            local Window = {
                Logo = Data.Logo or Data.logo or "rbxassetid://90459883253339",
                Build = Data.Build or Data.build or "live",
                
                Pages = { },
                Items = { },
                IsOpen = false
            }

            local Items = { } do
                Items["MainFrame"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 590, 0, 480),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Background"],
                    Theme = {BackgroundColor3 = "Background"}
                })

                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2New(540, 400), Vector2New(9999, 9999))

                Instances:Create("UIStroke", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Theme = {Color = "Outline"}
                })

                Instances:Create("UIStroke", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    BorderOffset = UDimNew(0, 1),
                    Theme = {Color = "Border"}
                })

                Items["Bottom"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"],
                    Theme = {BackgroundColor3 = "Inline"}
                })

                Instances:Create("Frame", {
                    Parent = Items["Bottom"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"],
                    Theme = {BackgroundColor3 = "Outline"}
                })

                Items["BuildText"] = Instances:Create("TextLabel", {
                    Parent = Items["Bottom"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    RichText = true,
                    TextColor3 = Library.Theme["Inactive Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "build: "..Window.Build,
                    Size = UDim2New(0, 0, 0, 15),
                    AnchorPoint = Vector2New(0, 0.5),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 8, 0.5, -1),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    Theme = {TextColor3 = "Inactive Text"}
                })

                Items["Top"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 46),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"],
                    Theme = {BackgroundColor3 = "Inline"}
                })

                Items["Logo"] = Instances:Create("TextLabel", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    FontFace = Library.TitleFont,
                    TextColor3 = Library.Theme["Accent"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 14, 0.5, -1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Logo"]:AddToTheme({TextColor3 = "Accent"})

                Items["Logo"].Instance.Text = "pchaxx13"

                Items["Liner"] = Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 2),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Accent"],
                    Theme = {BackgroundColor3 = "Accent"}
                })

                Items["Glow"] = Instances:Create("ImageLabel", {
                    Parent = Items["Liner"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Glow"],
                    ScaleType = Enum.ScaleType.Slice,
                    ImageTransparency = Library.GlowTransparency,
                    Size = UDim2New(1, 8, 1, 8),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "http://www.roblox.com/asset/?id=18245826428",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
                    Theme = {ImageColor3 = "Glow"}
                })

                Items["SubPages"] = Instances:Create("Frame", {
                    Parent = Items["Top"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIPadding", {
                    Parent = Items["SubPages"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 12),
                    PaddingLeft = UDimNew(0, 12)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["SubPages"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDimNew(0, 20),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Items["Side"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 46),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 68, 1, -71),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["PageHolder"] = Instances:Create("Frame", {
                    Parent = Items["Side"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 13),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, -13),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("Frame", {
                    Parent = Items["Side"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0),
                    Position = UDim2New(1, 0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 1, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"],
                    Theme = {BackgroundColor3 = "Outline"}
                })

                Window.Items = Items
            end
            
            local Debounce = false

            function Window:SetCenter()
                -- La ventana ya esta centrada con AnchorPoint 0.5 / Position 0.5.
                -- Ya no se convierte a posicion absoluta (eso provocaba el salto hacia arriba).
                Items["MainFrame"].Instance.AnchorPoint = Vector2New(0.5, 0.5)
                Items["MainFrame"].Instance.Position = UDim2New(0.5, 0, 0.5, 0)
            end

            function Window:SetOpen(Bool)
                for Index, Value in Library.OpenFrames do 
                    Value:SetOpen(false)
                end

                if Debounce then 
                    return
                end

                Window.IsOpen = Bool

                Debounce = true 

                if Window.IsOpen then 
                    Items["MainFrame"].Instance.Visible = true 
                end

                local Descendants = Items["MainFrame"].Instance:GetDescendants()
                TableInsert(Descendants, Items["MainFrame"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["MainFrame"].Instance.Visible = Window.IsOpen
                end)
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:SetCenter()
            task.wait()
            Window:SetOpen(true)
            return setmetatable(Window, Library)
        end

        Library.Page = function(self, Data)
            Data = Data or { }

            local TabIcon = Data.Icon or Data.icon
            local AutoIcon = Library.TabIcons[#self.Pages + 1]

            if AutoIcon and not (Data.NoAutoIcon or Data.noautoicon) then
                TabIcon = Library:GetIcon(AutoIcon) or TabIcon
            elseif type(TabIcon) == "string" and Library.Icons[TabIcon] then
                TabIcon = Library:GetIcon(TabIcon)
            end

            local Page = {
                Window = self,

                Icon = TabIcon or "rbxassetid://86962395649126",

                Items = { },
                SubPages = { },
                Active = false
            }

            local Items = { } do
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Page.Window.Items["SubPages"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 20, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Inactive Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = Page.Icon,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({ImageColor3 = function()
                    return Library.Theme["Inactive Text"]
                end})

                Items["PageContent"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 69, 0, 45),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -69, 1, -70),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["SubPages"] = Instances:Create("Frame", {
                    Parent = Page.Window.Items["PageHolder"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Visible = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })                

                Instances:Create("UIListLayout", {
                    Parent = Items["SubPages"].Instance,
                    Name = "\0",
                    SortOrder = Enum.SortOrder.LayoutOrder
                })    

                Items["Inactive"]:OnHover(function()
                    if Page.Active then return end
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme["Text"]})
                end)

                Items["Inactive"]:OnHoverLeave(function()
                    if Page.Active then return end
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme["Inactive Text"]})
                end)

                Page.Items = Items
            end

            local Debounce = false

            function Page:Turn(Bool)
                Page.Active = Bool
                
                Items["PageContent"].Instance.Visible = Bool
                Items["PageContent"].Instance.Parent = Bool and Page.Window.Items["MainFrame"].Instance or Library.UnusedHolder.Instance
                Items["SubPages"].Instance.Visible = Bool

                if Page.Active then
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent})
                else
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = function()
                        return Library.Theme["Inactive Text"]
                    end})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme["Inactive Text"]})
                end
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do 
                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn(true)
            end

            TableInsert(Page.Window.Pages, Page)
            return setmetatable(Page, Library.Pages)
        end

        Library.Pages.SubPage = function(self, Data)
            Data = Data or { }

            local Page = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "SubPage",
                Icon = Data.Icon or Data.icon or "rbxassetid://86962395649126",
                Items = { },
                Active = false
            }

            local Items = { } do
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Page.Page.Items["SubPages"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 44),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Accent1"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 1, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 0, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(166, 147, 243)
                })  Items["Accent1"]:AddToTheme({BackgroundColor3 = "Accent"})
                
                Items["Accent2"] = Instances:Create("Frame", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 0.5, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 1, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(110, 97, 161)
                })  Items["Accent2"]:AddToTheme({BackgroundColor3 = "Dark Accent"})
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    ImageColor3 = Library.Theme["Inactive Text"],
                    ScaleType = Enum.ScaleType.Fit,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = Page.Icon,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Size = UDim2New(0, 22, 0, 22),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Icon"]:AddToTheme({ImageColor3 = function()
                    return Library.Theme["Inactive Text"]
                end})
                
                Items["Background"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Hovered Element"},
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Hovered Element"]
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Transparency = NumSequence{NumSequenceKeypoint(0, 0.956250011920929), NumSequenceKeypoint(0.06, 0.9750000238418579), NumSequenceKeypoint(0.739, 1), NumSequenceKeypoint(1, 1)}
                })                

                Items["PageContent"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["PageContent"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 15),
                    PaddingBottom = UDimNew(0, 15),
                    PaddingRight = UDimNew(0, 15),
                    PaddingLeft = UDimNew(0, 15)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["PageContent"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Padding = UDimNew(0, 15),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalFlex = Enum.UIFlexAlignment.Fill
                })

                Items["Inactive"]:OnHover(function()
                    if Page.Active then return end
                    Items["Background"]:Tween(nil, {BackgroundTransparency = 0})
                end)

                Items["Inactive"]:OnHoverLeave(function()
                    if Page.Active then return end
                    Items["Background"]:Tween(nil, {BackgroundTransparency = 1})
                end)

                Page.Items = Items
            end

            local Debounce = false

            function Page:Turn(Bool)
                Page.Active = Bool
                
                Items["PageContent"].Instance.Visible = Bool
                Items["PageContent"].Instance.Parent = Bool and Page.Page.Items["PageContent"].Instance or Library.UnusedHolder.Instance

                if Page.Active then
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = "Accent"})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme.Accent})
                    Items["Accent1"]:Tween(TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0, Size = UDim2New(0, 1, 1, 0)})
                    Items["Accent2"]:Tween(TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0, Size = UDim2New(0, 1, 1, 0)})
                    Items["Background"]:Tween(nil, {BackgroundTransparency = 0})
                else
                    Items["Icon"]:ChangeItemTheme({ImageColor3 = function()
                        return Library.Theme["Inactive Text"]
                    end})
                    Items["Icon"]:Tween(nil, {ImageColor3 = Library.Theme["Inactive Text"]})
                    Items["Accent1"]:Tween(TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 1, Size = UDim2New(0, 1, 0, 0)})
                    Items["Accent2"]:Tween(TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 1, Size = UDim2New(0, 1, 0, 0)})
                    Items["Background"]:Tween(nil, {BackgroundTransparency = 1})
                end
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Page.SubPages do 
                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Page.SubPages == 0 then 
                Page:Turn(true)
            end

            TableInsert(Page.Page.SubPages, Page)
            return setmetatable(Page, Library.Pages)
        end

        Library.Pages.Section = function(self, Data)
            Data = Data or { }

            local Section = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "Section",

                Items = { }
            }

            local Items = { } do
                Items["Outline"] = Instances:Create("Frame", {
                    Parent = Section.Page.Items["PageContent"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 100, 0, 125),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Inline"],
                    Theme = {BackgroundColor3 = "Inline"}
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Outline"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Theme = {Color = "Outline"}
                })

                Instances:Create("UIStroke", {
                    Parent = Items["Outline"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    BorderOffset = UDimNew(0, 1),
                    Theme = {Color = "Border"}
                })

                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Outline"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 1, -2),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Outline"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Section.Name,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2New(0, 9, 0, -2),
                    Size = UDim2New(0, 0, 0, 1),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = Library.Theme["Background"],
                    Theme = {TextColor3 = "Text", BackgroundColor3 = "Background"}
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Text"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 4),
                    PaddingLeft = UDimNew(0, 4)
                })

                Items["Elements"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ZIndex = 1,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0),
                    ScrollBarImageColor3 = Library.Theme["Accent"],
                    MidImage = "rbxassetid://81680855285439",
                    BorderColor3 = FromRGB(0, 0, 0),
                    ScrollBarThickness = 2,
                    Size = UDim2New(1, -2, 1, -8),
                    Position = UDim2New(0, 0, 0, 6),
                    TopImage = "rbxassetid://81680855285439",
                    BottomImage = "rbxassetid://81680855285439",
                    BackgroundTransparency = 1,
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    Theme = {ScrollBarImageColor3 = "Accent"}
                })

                Items["ElementsHolder"] = Instances:Create("Frame", {
                    Parent = Items["Elements"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    SelectionGroup = true,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 14, 0, 7),
                    Size = UDim2New(1, -26, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["ElementsHolder"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Elements"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 12)
                })

                Section.Items = Items
            end

            return setmetatable(Section, Library.Sections)
        end

        -- Ajusta el texto de un elemento al espacio libre; si no cabe se corta con "..."
        local FitText = function(TextItem, Parent, Left, Reserve)
            local Text = TextItem.Instance

            Text.AutomaticSize = Enum.AutomaticSize.None
            Text.TextTruncate = Enum.TextTruncate.AtEnd

            local Update = function()
                local Free = Parent.AbsoluteSize.X - Left - Reserve()
                Text.Size = UDim2New(0, math.max(Free, 0), 0, 13)
            end

            Library:Connect(Parent:GetPropertyChangedSignal("AbsoluteSize"), Update)
            Update()

            return Update
        end

        Library.Sections.Toggle = function(self, Data)
            Data = Data or { }

            local Toggle = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Toggle",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or false,
                Callback = Data.Callback or Data.callback or function() end,

                Value = false
            }

            local Items = { } do 
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Toggle.Section.Items["ElementsHolder"].Instance,
                    Name = "\0",
                    Active = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 13),
                    Selectable = false,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Indicator"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 0, 0.5, 0),
                    Size = UDim2New(0, 9, 0, 9),
                    BorderSizePixel = 2,
                    BackgroundColor3 = Library.Theme["Element 2"]
                })  Items["Indicator"]:AddToTheme({BackgroundColor3 = function()
                    return Library.Theme["Element 2"]
                end})
                
                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(163, 163, 163))}
                })
                

                Items["Text"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Text"},
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Toggle.Name,
                    Size = UDim2New(0, 0, 0, 13),
                    Position = UDim2New(0, 17, 0, -2),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })                

                Items["EXAMPLAR_"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    Position = UDim2New(1, -8, 0, -2),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["EXAMPLAR_"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Items["Toggle"]:OnHover(function()
                    if Toggle.Value then return end 
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                end)

                Items["Toggle"]:OnHoverLeave(function()
                    if Toggle.Value then return end 
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element 2"]})
                end)
            end

            do
                local Accessories = Items["EXAMPLAR_"].Instance:FindFirstChildOfClass("UIListLayout")
                local Update = FitText(Items["Text"], Items["Toggle"].Instance, 17, function()
                    return Accessories.AbsoluteContentSize.X + 14
                end)

                Library:Connect(Accessories:GetPropertyChangedSignal("AbsoluteContentSize"), Update)
            end

            function Toggle:Get()
                return Toggle.Value 
            end

            function Toggle:Set(Value)
                Toggle.Value = Value 
                Library.Flags[Toggle.Flag] = Value 

                if Toggle.Value then 
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent})
                else
                    Items["Indicator"]:ChangeItemTheme({BackgroundColor3 = function()
                        return Library.Theme["Element 2"]
                    end})
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element 2"]})
                end

                if Toggle.Callback then 
                    Library:SafeCall(Toggle.Callback, Toggle.Value)
                end
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Alpha = Data.Alpha or Data.alpha or 0,
                    Callback = Data.Callback or Data.callback or function() end
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["EXAMPLAR_"],
                    Page = Colorpicker.Page,
                    Flag = Colorpicker.Flag,
                    Section = Colorpicker.Section,
                    Default = Colorpicker.Default,
                    Alpha = Colorpicker.Alpha,
                    Callback = Colorpicker.Callback,
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Name = Data.Name or Data.name or Toggle.Name,
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",
                }

                local NewKeybind = Library:CreateKeybind({
                    Name = Keybind.Name,
                    Parent = Items["EXAMPLAR_"],
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Section = Keybind.Section,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return Toggle 
        end

        Library.Sections.Button = function(self, Data)
            Data = Data or { }

            local Button = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Button",
                Callback = Data.Callback or Data.callback or function() end
            }

            local Items = { } do
                Items["ButtonHolder"] = Instances:Create("Frame", {
                    Parent = Button.Section.Items["ElementsHolder"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 21),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Outline"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Border"},
                    Parent = Items["ButtonHolder"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 17, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -25, 0, 21),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Border"]
                })
                
                Items["Inline"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Outline"},
                    Parent = Items["Outline"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Outline"]
                })
                
                Items["Indicator"] = Instances:Create("TextButton", {
                    Theme = {BackgroundColor3 = "Element"},
                    Parent = Items["Inline"].Instance,
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(163, 163, 163))}
                })
                
                Items["Value"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Text"},
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Button.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 6, 0.4166666567325592, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                
                

                Items["ButtonHolder"]:OnHover(function()
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                end)

                Items["ButtonHolder"]:OnHoverLeave(function()
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                end)
            end

            function Button:Press()
                Items["Value"]:Tween(nil, {TextColor3 = Library.Theme.Accent})
                Library:SafeCall(Button.Callback)
                task.wait(0.1)
                Items["Value"]:Tween(nil, {TextColor3 = Library.Theme["Text"]})
            end

            function Button:SetVisibility(Bool)
                Items["ButtonHolder"].Instance.Visible = Bool
            end

            Items["Indicator"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return Button
        end

        Library.Sections.Slider = function(self, Data)
            Data = Data or { }

            local Slider = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Slider",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Min = Data.Min or Data.min or 0,
                Decimals = Data.Decimals or Data.decimals or 1,
                Suffix = Data.Suffix or Data.suffix or "",
                Max = Data.Max or Data.max or 100,
                Default = Data.Default or Data.Default or 0,
                Callback = Data.Callback or Data.callback or function() end,

                Value = 0,
                Sliding = false
            }

            local Items = { } do 
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Slider.Section.Items["ElementsHolder"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 27),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Indicator"] = Instances:Create("TextButton", {
                    Theme = {BackgroundColor3 = "Element 2"},
                    Parent = Items["Slider"].Instance,
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    Position = UDim2New(0, 17, 0, 17),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -25, 0, 9),
                    BorderSizePixel = 2,
                    BackgroundColor3 = Library.Theme["Element 2"]
                })
                
                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(163, 163, 163))}
                })
                
                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0.5, -2, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(166, 147, 243)
                })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})
                
                Instances:Create("UIGradient", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(163, 163, 163))}
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Text"},
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Slider.Name,
                    Size = UDim2New(0, 0, 0, 13),
                    Position = UDim2New(0, 17, 0, -2),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })                

                Items["Value"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Text"},
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AnchorPoint = Vector2New(1, 0),
                    Size = UDim2New(0, 0, 0, 13),
                    Position = UDim2New(1, -8, 0, -2),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })               

                Items["Indicator"]:OnHover(function()
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                end)

                Items["Indicator"]:OnHoverLeave(function()
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element 2"]})
                end)
            end

            do
                local ValueLabel = Items["Value"].Instance
                local Update = FitText(Items["Text"], Items["Slider"].Instance, 17, function()
                    return ValueLabel.AbsoluteSize.X + 14
                end)

                Library:Connect(ValueLabel:GetPropertyChangedSignal("AbsoluteSize"), Update)
            end

            function Slider:Get()
                return Slider.Value
            end

            function Slider:Set(Value)
                Slider.Value = Library:Round(MathClamp(Value, Slider.Min, Slider.Max), Slider.Decimals)
                Library.Flags[Slider.Flag] = Slider.Value

                Items["Accent"]:Tween(TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), 0, 1, 0)})
                Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)

                if Slider.Callback then 
                    Library:SafeCall(Slider.Callback, Slider.Value)
                end
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            Items["Indicator"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Slider.Sliding = true 

                    local SizeX = (Input.Position.X - Items["Indicator"].Instance.AbsolutePosition.X) / Items["Indicator"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                    Slider:Set(Value)
                end
            end)

            Items["Indicator"]:Connect("InputEnded", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Slider.Sliding = false
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement then 
                    if Slider.Sliding then
                        local SizeX = (Input.Position.X - Items["Indicator"].Instance.AbsolutePosition.X) / Items["Indicator"].Instance.AbsoluteSize.X
                        local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                        Slider:Set(Value)
                    end
                end
            end)

            if Slider.Default then
                Slider:Set(Slider.Default)
            end

            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return Slider 
        end

        Library.Sections.Dropdown = function(self, Data)
            Data = Data or { }

            local Dropdown = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Dropdown",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "",
                Multi = Data.Multi or Data.multi or false,
                Items = Data.Items or Data.items or { },
                Callback = Data.Callback or Data.callback or function() end,

                Options = { },
                Value = { },
                IsOpen = false
            }

            local Items = { } do 
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Dropdown.Section.Items["ElementsHolder"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 38),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Indicator"] = Instances:Create("TextButton", {
                    Theme = {BackgroundColor3 = "Element"},
                    Parent = Items["Dropdown"].Instance,
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    Position = UDim2New(0, 17, 0, 17),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -25, 0, 21),
                    BorderSizePixel = 2,
                    BackgroundColor3 = Library.Theme["Element"],
                    ClipsDescendants = true,
                })
                
                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    BorderOffset = UDimNew(0, 1)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    Rotation = 90,
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 255, 255)), RGBSequenceKeypoint(1, FromRGB(163, 163, 163))}
                })
                
                if not Dropdown.Multi then 
                    Items["Icon"] = Instances:Create("ImageLabel", {
                    Theme = {ImageColor3 = "Inactive Text"},
                        Parent = Items["Indicator"].Instance,
                        Name = "\0",
                        ImageColor3 = Library.Theme["Inactive Text"],
                        ScaleType = Enum.ScaleType.Fit,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(0, 7, 0, 7),
                        AnchorPoint = Vector2New(1, 0.5),
                        Image = "rbxassetid://108270041153906",
                        BackgroundTransparency = 1,
                        Position = UDim2New(1, -8, 0.5, 0),
                        ResampleMode = Enum.ResamplerMode.Pixelated,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                else
                    Items["Icon"] = Instances:Create("ImageLabel", {
                    Theme = {ImageColor3 = "Inactive Text", BackgroundColor3 = "Text"},
                        Parent = Items["Indicator"].Instance,
                        Name = "\0",
                        ImageColor3 = Library.Theme["Inactive Text"],
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(1, 0.5),
                        Image = "rbxassetid://132890703695297",
                        BackgroundTransparency = 1,
                        Position = UDim2New(1, -8, 0.5, -1),
                        Size = UDim2New(0, 8, 0, 8),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Library.Theme["Text"]
                    })                    
                end
                
                Items["Value"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Inactive Text"},
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Inactive Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "--",
                    Size = UDim2New(0.018518518656492233, 0, 0.8333333134651184, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 6, 0.4166666567325592, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.XY,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Text"},
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Dropdown.Name,
                    Size = UDim2New(0, 0, 0, 13),
                    Position = UDim2New(0, 17, 0, -2),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })                

                Items["DropdownHolder"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Background"},
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Size = UDim2New(0, 216, 0, 25),
                    Position = UDim2New(0, 253, 0, 84),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 2,
                    Visible = false,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = Library.Theme["Background"]
                })

                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["DropdownHolder"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["DropdownHolder"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    BorderOffset = UDimNew(0, 1)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["DropdownHolder"].Instance,
                    Name = "\0",
                    SortOrder = Enum.SortOrder.LayoutOrder
                })            
                
                Items["Indicator"]:OnHover(function()
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Hovered Element"]})
                end)

                Items["Indicator"]:OnHoverLeave(function()
                    Items["Indicator"]:Tween(nil, {BackgroundColor3 = Library.Theme["Element"]})
                end)
            end
            
            local Debounce = false
            local RenderStepped  

            do
                FitText(Items["Text"], Items["Dropdown"].Instance, 17, function()
                    return 8
                end)

                local ValueLabel = Items["Value"].Instance
                local Box = Items["Indicator"].Instance

                ValueLabel.AutomaticSize = Enum.AutomaticSize.None
                ValueLabel.TextTruncate = Enum.TextTruncate.AtEnd

                local UpdateValue = function()
                    ValueLabel.Size = UDim2New(0, math.max(Box.AbsoluteSize.X - 28, 0), 0.8333, 0)
                end

                Library:Connect(Box:GetPropertyChangedSignal("AbsoluteSize"), UpdateValue)
                UpdateValue()
            end

            function Dropdown:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Dropdown.IsOpen = Bool

                Debounce = true 

                if Dropdown.IsOpen then 
                    Items["DropdownHolder"].Instance.Visible = true
                    Items["DropdownHolder"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["DropdownHolder"].Instance.Position = UDim2New(
                            0, 
                            Items["Indicator"].Instance.AbsolutePosition.X, 
                            0, 
                            Items["Indicator"].Instance.AbsolutePosition.Y + Items["Indicator"].Instance.AbsoluteSize.Y * 3 + 19 -- its weird
                        )
                        Items["DropdownHolder"].Instance.Size = UDim2New(0, Items["Indicator"].Instance.AbsoluteSize.X, 0, 0)
                    end)

                    for Index, Value in Library.OpenFrames do 
                        Value:SetOpen(false)
                    end

                    Library.OpenFrames[Dropdown] = Dropdown 
                else
                    if Library.OpenFrames[Dropdown] then 
                        Library.OpenFrames[Dropdown] = nil
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["DropdownHolder"].Instance:GetDescendants()
                TableInsert(Descendants, Items["DropdownHolder"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["DropdownHolder"].Instance.Visible = Dropdown.IsOpen
                    task.wait(0.2)
                    Items["DropdownHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            function Dropdown:Add(Option)
                local OptionItems = { } do 
                    OptionItems["Disabled"] = Instances:Create("TextButton", {
                        Parent = Items["DropdownHolder"].Instance,
                        Name = "\0",
                        Text = "",
                        AutoButtonColor = false,
                        FontFace = Library.MenuFont,
                        TextColor3 = FromRGB(0, 0, 0),
                        TextTransparency = 1,
                        Size = UDim2New(1, 0, 0, 25),
                        Selectable = true,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Active = true,
                        TextSize = 12,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                    
                    OptionItems["Accent1"] = Instances:Create("Frame", {
                        Parent = OptionItems["Disabled"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        Size = UDim2New(0, 1, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(0, 0.5),
                        Position = UDim2New(0, 0, 0.5, 0),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(166, 147, 243)
                    })  OptionItems["Accent1"]:AddToTheme({BackgroundColor3 = "Accent"})
                    
                    OptionItems["Accent2"] = Instances:Create("Frame", {
                        Parent = OptionItems["Disabled"].Instance,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 1, 0.5, 0),
                        AnchorPoint = Vector2New(0, 0.5),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(110, 97, 161)
                    })  OptionItems["Accent2"]:AddToTheme({BackgroundColor3 = "Dark Accent"})
                    
                    OptionItems["Text"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Inactive Text"},
                        Parent = OptionItems["Disabled"].Instance,
                        Name = "\0",
                        FontFace = Library.MenuFont,
                        TextColor3 = Library.Theme["Inactive Text"],
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = Option,
                        AnchorPoint = Vector2New(0, 0.5),
                        Size = UDim2New(0, 0, 0, 15),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 10, 0.5, -2),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.X,
                        TextSize = 12,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  OptionItems["Text"]:AddToTheme({TextColor3 = function()
                        return Library.Theme["Inactive Text"]
                    end})
                    
                    OptionItems["Background"] = Instances:Create("Frame", {
                        Parent = OptionItems["Disabled"].Instance,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                    
                    Instances:Create("UIGradient", {
                        Parent = OptionItems["Background"].Instance,
                        Name = "\0",
                        Transparency = NumSequence{NumSequenceKeypoint(0, 0.956250011920929), NumSequenceKeypoint(0.06, 0.9750000238418579), NumSequenceKeypoint(0.739, 1), NumSequenceKeypoint(1, 1)}
                    })                    
                end
                
                local OptionData = {
                    Button = OptionItems["Disabled"],
                    Accent1 = OptionItems["Accent1"],
                    Accent2 = OptionItems["Accent2"],
                    Text = OptionItems["Text"],
                    Background = OptionItems["Background"],
                    Name = Option,
                    Selected = false
                }

                function OptionData:Toggle(Status)
                    if Status == "Active" then 
                        OptionData.Accent1:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 1, 1, 0)})
                        OptionData.Accent2:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 1, 1, 0)})
                        OptionData.Text:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Accent})
                        OptionData.Background:Tween(nil, {BackgroundTransparency = 0})
                    else
                        OptionData.Accent1:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 1, 0, 0)})
                        OptionData.Accent2:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 1, 0, 0)})
                        OptionData.Text:ChangeItemTheme({TextColor3 = function()
                            return Library.Theme["Inactive Text"]
                        end})
                        OptionData.Text:Tween(nil, {TextColor3 = Library.Theme["Inactive Text"]})
                        OptionData.Background:Tween(nil, {BackgroundTransparency = 1})
                    end
                end

                function OptionData:OnHover()
                    if OptionData.Selected then return end
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme["Inactive Text"]})
                end

                function OptionData:OnHoverLeave()
                    if OptionData.Selected then return end
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme["Inactive Text"]})
                end

                OptionData.Button:OnHover(OptionData.OnHover)
                OptionData.Button:OnHoverLeave(OptionData.OnHoverLeave)

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Dropdown.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "--"
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")

                            Items["Value"].Instance.Text = "--"
                        end
                    end

                    if Dropdown.Callback then
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Set(Option)
                if Dropdown.Multi then 
                    if type(Option) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]
                        
                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true 
                        OptionData:Toggle("Active")
                    end

                    Items["Value"].Instance.Text = TableConcat(Option, ", ")
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end

                    Items["Value"].Instance.Text = Option
                end

                if Dropdown.Callback then   
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Remove(Option)
                if not Dropdown.Options[Option] then
                    return
                end

                Dropdown.Options[Option].Button:Clean()
                Dropdown.Options[Option] = nil
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            local CompareVectors = function(PointA, PointB)
                return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
            end

            local IsClipped = function(Object, Column)
                local Parent = Column
                
                local BoundryTop = Parent.AbsolutePosition
                local BoundryBottom = BoundryTop + Parent.AbsoluteSize

                local Top = Object.AbsolutePosition
                local Bottom = Top + Object.AbsoluteSize 

                return CompareVectors(Top, BoundryTop) or CompareVectors(BoundryBottom, Bottom)
            end

            Items["Indicator"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Dropdown.IsOpen then
                    Dropdown.IsOpen = not IsClipped(Items["DropdownHolder"].Instance, Dropdown.Section.Items["Outline"].Instance.Parent)
                    Items["DropdownHolder"].Instance.Visible = Dropdown.IsOpen
                end
            end)

            Items["Indicator"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Dropdown.IsOpen then
                        return 
                    end

                    if Library:IsMouseOverFrame(Items["DropdownHolder"]) then 
                        return
                    end

                    Dropdown:SetOpen(false)
                end
            end)

            for Index, Value in Dropdown.Items do
                Dropdown:Add(Value)
            end

            if Dropdown.Default then 
                Dropdown:Set(Dropdown.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown
        end

        Library.Sections.Label = function(self, Text)
            local Label = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Text or "Label"
            }

            local Items = { } do
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Label.Section.Items["ElementsHolder"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Text"},
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Label.Name,
                    Size = UDim2New(0, 0, 0, 13),
                    Position = UDim2New(0, 17, 0, -2),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["EXAMPLAR_"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    Position = UDim2New(1, -8, 0, -2),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["EXAMPLAR_"].Instance,
                    Name = "\0",
                    VerticalAlignment = Enum.VerticalAlignment.Bottom,
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
            end

            do
                local Accessories = Items["EXAMPLAR_"].Instance:FindFirstChildOfClass("UIListLayout")
                local Update = FitText(Items["Text"], Items["Label"].Instance, 17, function()
                    return Accessories.AbsoluteContentSize.X + 14
                end)

                Library:Connect(Accessories:GetPropertyChangedSignal("AbsoluteContentSize"), Update)
            end

            function Label:SetText(Text)
                Text = tostring(Text)
                Items["Text"].Instance.Text = Text
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end
            
            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Label.Section.Window,
                    Page = Label.Section.Page,
                    Section = Label.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Alpha = Data.Alpha or Data.alpha or 0,
                    Callback = Data.Callback or Data.callback or function() end
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["EXAMPLAR_"],
                    Page = Colorpicker.Page,
                    Flag = Colorpicker.Flag,
                    Section = Colorpicker.Section,
                    Default = Colorpicker.Default,
                    Alpha = Colorpicker.Alpha,
                    Callback = Colorpicker.Callback,
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,

                    Name = Data.Name or Data.name or Label.Name,
                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.RightShift,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle",
                }

                local NewKeybind = Library:CreateKeybind({
                    Name = Keybind.Name,
                    Parent = Items["EXAMPLAR_"],
                    Flag = Keybind.Flag,
                    Section = Keybind.Section,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            return Label 
        end

        Library.Sections.Textbox = function(self, Data)
            Data = Data or { }

            local Textbox = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "",
                Callback = Data.Callback or Data.callback or function() end,
                Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",
                Numeric = Data.Numeric or Data.numeric or false,
                Finished = Data.Finished or Data.finished or false,

                Value = ""
            }

            local Items = { } do
                Items["Textbox"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Element"},
                    Parent = Textbox.Section.Items["ElementsHolder"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                })
                
                Items["Input"] = Instances:Create("TextBox", {
                    Theme = {TextColor3 = "Text", PlaceholderColor3 = "Inactive Text", BackgroundColor3 = "Element"},
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    ClipsDescendants = true,
                    Size = UDim2New(1, -25, 1, 0),
                    Position = UDim2New(0, 17, 0, 0),
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    CursorPosition = -1,
                    PlaceholderText = Textbox.Placeholder,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 12,
                    BackgroundColor3 = Library.Theme["Element"]
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 8)
                })                
            end
            
            function Textbox:Get()
                return Textbox.Value
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Library.Flags[Textbox.Flag] = Value

                if Textbox.Callback then
                    Library:SafeCall(Textbox.Callback, Value)
                end
            end
            
            if Textbox.Finished then 
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Items["Input"].Instance:GetPropertyChangedSignal("Text"):Connect(function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            if Textbox.Default then
                Textbox:Set(Textbox.Default)
            end

            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return Textbox
        end

        Library.Sections.Searchbox = function(self, Data) -- dropdowns but diff elements lol hahaha im not recoding it
            Data = Data or { }

            local Dropdown = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Dropdown",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "",
                Multi = Data.Multi or Data.multi or false,
                Items = Data.Items or Data.items or { },
                Callback = Data.Callback or Data.callback or function() end,

                Options = { },
                Value = { },
                IsOpen = false
            }

            local Items = { } do 
                Items["List"] = Instances:Create("Frame", {
                    Parent = Dropdown.Section.Items["ElementsHolder"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 200),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Text"},
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Dropdown.Name,
                    Size = UDim2New(0, 0, 0, 13),
                    Position = UDim2New(0, 17, 0, -2),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["ListBackground"] = Instances:Create("Frame", {
                    Parent = Items["List"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 17, 0, 22),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -25, 1, -22),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(0, 0, 0)
                })
                
                Items["Search"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Element"},
                    Parent = Items["ListBackground"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 1, 0, 1),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -2, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                })
                
                Items["Input"] = Instances:Create("TextBox", {
                    Theme = {TextColor3 = "Text", PlaceholderColor3 = "Inactive Text"},
                    Parent = Items["Search"].Instance,
                    Name = "\0",
                    FontFace = Library.MenuFont,
                    TextColor3 = Library.Theme["Text"],
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    Size = UDim2New(1, -16, 1, 0),
                    Position = UDim2New(0, 8, 0, 0),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    PlaceholderColor3 = Library.Theme["Inactive Text"],
                    CursorPosition = -1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["ListInline"] = Instances:Create("Frame", {
                    Theme = {BackgroundColor3 = "Element"},
                    Parent = Items["ListBackground"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 2, 0, 22),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -4, 1, -24),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Library.Theme["Element"]
                })
                
                Instances:Create("UIStroke", {
                    Theme = {Color = "Outline"},
                    Parent = Items["ListInline"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Outline"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                Instances:Create("UIStroke", {
                    Theme = {Color = "Border"},
                    Parent = Items["ListInline"].Instance,
                    Name = "\0",
                    Color = Library.Theme["Border"],
                    LineJoinMode = Enum.LineJoinMode.Miter,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    BorderOffset = UDimNew(0, 1)
                })
                
                Items["OptionHolder"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["ListInline"].Instance,
                    Name = "\0",
                    ScrollBarImageColor3 = FromRGB(0, 0, 0),
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 0,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    CanvasSize = UDim2New(0, 0, 0, 0)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
            end

            function Dropdown:SetVisibility(Bool)
                Items["List"].Instance.Visible = Bool
            end

            function Dropdown:Add(Option)
                local OptionItems = { } do 
                    OptionItems["Disabled"] = Instances:Create("TextButton", {
                        Parent = Items["OptionHolder"].Instance,
                        Name = "\0",
                        Text = "",
                        AutoButtonColor = false,
                        FontFace = Library.MenuFont,
                        TextColor3 = FromRGB(0, 0, 0),
                        TextTransparency = 1,
                        Size = UDim2New(1, 0, 0, 25),
                        Selectable = true,
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        BorderColor3 = FromRGB(0, 0, 0),
                        Active = true,
                        TextSize = 12,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                    
                    OptionItems["Accent1"] = Instances:Create("Frame", {
                        Parent = OptionItems["Disabled"].Instance,
                        Name = "\0",
                        BackgroundTransparency = 1,
                        Size = UDim2New(0, 1, 0, 0),
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(0, 0.5),
                        Position = UDim2New(0, 0, 0.5, 0),
                        ZIndex = 1,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(166, 147, 243)
                    })  OptionItems["Accent1"]:AddToTheme({BackgroundColor3 = "Accent"})
                    
                    OptionItems["Accent2"] = Instances:Create("Frame", {
                        Parent = OptionItems["Disabled"].Instance,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 1, 0.5, 0),
                        AnchorPoint = Vector2New(0, 0.5),
                        ZIndex = 1,
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(110, 97, 161)
                    })  OptionItems["Accent2"]:AddToTheme({BackgroundColor3 = "Dark Accent"})
                    
                    OptionItems["Text"] = Instances:Create("TextLabel", {
                    Theme = {TextColor3 = "Inactive Text"},
                        Parent = OptionItems["Disabled"].Instance,
                        Name = "\0",
                        FontFace = Library.MenuFont,
                        TextColor3 = Library.Theme["Inactive Text"],
                        BorderColor3 = FromRGB(0, 0, 0),
                        Text = Option,
                        AnchorPoint = Vector2New(0, 0.5),
                        Size = UDim2New(0, 0, 0, 15),
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 10, 0.5, -2),
                        BorderSizePixel = 0,
                        AutomaticSize = Enum.AutomaticSize.X,
                        TextSize = 12,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })  OptionItems["Text"]:AddToTheme({TextColor3 = function()
                        return Library.Theme["Inactive Text"]
                    end})
                    
                    OptionItems["Background"] = Instances:Create("Frame", {
                        Parent = OptionItems["Disabled"].Instance,
                        Name = "\0",
                        BorderColor3 = FromRGB(0, 0, 0),
                        Size = UDim2New(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                    
                    Instances:Create("UIGradient", {
                        Parent = OptionItems["Background"].Instance,
                        Name = "\0",
                        Transparency = NumSequence{NumSequenceKeypoint(0, 0.956250011920929), NumSequenceKeypoint(0.06, 0.9750000238418579), NumSequenceKeypoint(0.739, 1), NumSequenceKeypoint(1, 1)}
                    })                    
                end
                
                local OptionData = {
                    Button = OptionItems["Disabled"],
                    Accent1 = OptionItems["Accent1"],
                    Accent2 = OptionItems["Accent2"],
                    Text = OptionItems["Text"],
                    Background = OptionItems["Background"],
                    Name = Option,
                    Selected = false
                }

                function OptionData:Toggle(Status)
                    if Status == "Active" then 
                        OptionData.Accent1:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 1, 1, 0)})
                        OptionData.Accent2:Tween(nil, {BackgroundTransparency = 0, Size = UDim2New(0, 1, 1, 0)})
                        OptionData.Text:ChangeItemTheme({TextColor3 = "Accent"})
                        OptionData.Text:Tween(nil, {TextColor3 = Library.Theme.Accent})
                        OptionData.Background:Tween(nil, {BackgroundTransparency = 0})
                    else
                        OptionData.Accent1:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 1, 0, 0)})
                        OptionData.Accent2:Tween(nil, {BackgroundTransparency = 1, Size = UDim2New(0, 1, 0, 0)})
                        OptionData.Text:ChangeItemTheme({TextColor3 = function()
                            return Library.Theme["Inactive Text"]
                        end})
                        OptionData.Text:Tween(nil, {TextColor3 = Library.Theme["Inactive Text"]})
                        OptionData.Background:Tween(nil, {BackgroundTransparency = 1})
                    end
                end

                function OptionData:OnHover()
                    if OptionData.Selected then return end
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme["Inactive Text"]})
                end

                function OptionData:OnHoverLeave()
                    if OptionData.Selected then return end
                    OptionData.Text:Tween(nil, {TextColor3 = Library.Theme["Inactive Text"]})
                end

                OptionData.Button:OnHover(OptionData.OnHover)
                OptionData.Button:OnHoverLeave(OptionData.OnHoverLeave)

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Dropdown.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")
                        end
                    end

                    if Dropdown.Callback then
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Set(Option)
                if Dropdown.Multi then 
                    if type(Option) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]
                        
                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true 
                        OptionData:Toggle("Active")
                    end
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end
                end

                if Dropdown.Callback then   
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Remove(Option)
                if not Dropdown.Options[Option] then
                    return
                end

                Dropdown.Options[Option].Button:Clean()
                Dropdown.Options[Option] = nil
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            local SearchStepped

            Items["Input"]:Connect("Focused", function()
                SearchStepped = RunService.RenderStepped:Connect(function()
                    for Index, Value in Dropdown.Options do
                        if StringFind(StringLower(Value.Name), StringLower(Items["Input"].Instance.Text)) then
                            Value.Button.Instance.Visible = true
                        else
                            Value.Button.Instance.Visible = false
                        end
                    end
                end)
            end)

            Items["Input"]:Connect("FocusLost", function()
                SearchStepped:Disconnect()
            end)

            for Index, Value in Dropdown.Items do
                Dropdown:Add(Value)
            end

            if Dropdown.Default then 
                Dropdown:Set(Dropdown.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown
        end
    end

    Library.CreateSettingsPage = function(self, Window, KeybindList, Watermark)
        local SettingsPage = Window:Page({Icon = "rbxassetid://124693018107383", NoAutoIcon = true})
        
        local MenuSubPage = SettingsPage:SubPage({Name = "Menu", Icon = "rbxassetid://124693018107383"})
        local ThemeSubPage = SettingsPage:SubPage({Name = "Theme", Icon = "rbxassetid://124693018107383"})
        local ConfigsSubPage = SettingsPage:SubPage({Name = "Configs", Icon = "rbxassetid://86962395649126"})

        do -- Menu subpages
            local MenuSection = MenuSubPage:Section({Name = "Menu"}) do
                MenuSection:Toggle({Name = "Keybind List", Flag = "Keybind List", Default = true, Callback = function(Value)
                    KeybindList:SetVisibility(Value)
                end})

                MenuSection:Toggle({Name = "Watermark", Flag = "Watermark", Default = true, Callback = function(Value)
                    Watermark:SetVisibility(Value)
                end})

                if Library.IndicatorObj then
                    MenuSection:Toggle({Name = "Player Indicator", Flag = "Player Indicator", Default = true, Callback = function(Value)
                        Library.IndicatorObj:SetVisibility(Value)
                    end})
                end

                if Library.AmmoObj then
                    MenuSection:Toggle({Name = "Ammo", Flag = "Ammo", Default = true, Callback = function(Value)
                        Library.AmmoObj:SetVisibility(Value)
                    end})
                end

                if Library.HotbarObj then
                    MenuSection:Toggle({Name = "Hotbar", Flag = "Hotbar", Default = true, Callback = function(Value)
                        Library.HotbarObj:SetVisibility(Value)
                    end})
                end

                MenuSection:Label("Menu Keybind"):Keybind({
                    Name = "UI",
                    Flag = "MenuKeybind",
                    Mode = "Toggle",
                    Default = Library.MenuKeybind,
                    Callback = function()
                        Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
                    end
                })

                MenuSection:Slider({
                    Name = "Animation speed",
                    Flag = "Animation speed",
                    Default = Library.FadeSpeed,
                    Min = 0,
                    Max = 2,
                    Decimals = 0.01,
                    Callback = function(Value)
                        Library.FadeSpeed = Value
                    end
                })

                MenuSection:Slider({
                    Name = "Rainbow speed",
                    Flag = "Rainbow speed",
                    Default = Library.RainbowSpeed,
                    Min = 0.05,
                    Max = 1,
                    Decimals = 0.01,
                    Callback = function(Value)
                        Library.RainbowSpeed = Value
                    end
                })

                MenuSection:Button({Name = "Unload", Callback = function()
                    Library:Unload()
                end})
            end
        end

        do -- Theming (juanitahaxx)
            local ThemingSection = ThemeSubPage:Section({Name = "Theming"}) do
                local AccentLabel = ThemingSection:Label("Accent Color")
                AccentLabel:Colorpicker({
                    Flag = "AccentColor",
                    Default = Library.Theme.Accent,
                    Alpha = 0,
                    Callback = function(Value)
                        Library.Theme.Accent = Value
                        Library:ChangeTheme("Accent", Value)
                    end
                })

                AccentLabel:Colorpicker({
                    Flag = "DarkAccentColor",
                    Default = Library.Theme["Dark Accent"],
                    Alpha = 0,
                    Callback = function(Value)
                        Library.Theme["Dark Accent"] = Value
                        Library:ChangeTheme("Dark Accent", Value)
                    end
                })

                ThemingSection:Label("Glow Color"):Colorpicker({
                    Flag = "GlowColor",
                    Default = Library.Theme["Glow"],
                    Alpha = 0,
                    Callback = function(Value)
                        Library.Theme["Glow"] = Value
                        Library:ChangeTheme("Glow", Value)
                    end
                })

                ThemingSection:Slider({
                    Name = "Glow transparency",
                    Flag = "GlowTransparency",
                    Default = Library.GlowTransparency,
                    Min = 0,
                    Max = 1,
                    Decimals = 0.01,
                    Callback = function(Value)
                        Library.GlowTransparency = Value

                        for Index, Holder in {Library.Holder.Instance, Library.UnusedHolder.Instance} do
                            for _, Object in Holder:GetDescendants() do
                                if Object:IsA("ImageLabel") and StringFind(Object.Image, "18245826428", 1, true) then
                                    Object.ImageTransparency = Value
                                end
                            end
                        end
                    end
                })

                for Index, Name in {"Border", "Outline", "Background", "Inline", "Text", "Inactive Text", "Element", "Element 2", "Hovered Element"} do
                    ThemingSection:Label(Name):Colorpicker({
                        Flag = Name .. "Theming",
                        Default = Library.Theme[Name],
                        Alpha = 0,
                        Callback = function(Value)
                            Library.Theme[Name] = Value
                            Library:ChangeTheme(Name, Value)
                        end
                    })
                end
            end
        end

        do -- Config Subpages
            local ConfigsSection = ConfigsSubPage:Section({Name = "Profiles"}) do
                local ConfigName 
                local ConfigSelected
                
                local ConfigsSearchbox = ConfigsSection:Searchbox({
                    Name = "Profiles list",
                    Flag = "Profiles list",
                    Multi = false,
                    Items = { },
                    Callback = function(Value)
                        ConfigSelected = Value
                    end
                })

                ConfigsSection:Textbox({
                    Name = "Config name", 
                    Default = "", 
                    Flag = "ConfigName", 
                    Placeholder = "...", 
                    Callback = function(Value)
                        ConfigName = Value
                    end
                })

                ConfigsSection:Button({
                    Name = "Create",
                    Callback = function()
                        if ConfigName ~= "" then
                            if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                                writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                                Library:RefreshConfigsList(ConfigsSearchbox)
                            end
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Delete",
                    Callback = function()
                        if ConfigSelected ~= nil then
                            delfile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json")
                            Library:RefreshConfigsList(ConfigsSearchbox)
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Load",
                    Callback = function()
                        if ConfigSelected ~= nil then
                            local Success, Result = Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json"))
                            if Success then
                            else
                                Library:Alert("error", "failed to load " .. ConfigSelected .. ".json")
                            end
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Save",
                    Callback = function()
                        if ConfigSelected ~= nil then
                            writefile(Library.Folders.Configs .. "/" .. ConfigSelected .. ".json", Library:GetConfig())
                        end
                    end
                })

                ConfigsSection:Button({
                    Name = "Refresh",
                    Callback = function()
                        Library:RefreshConfigsList(ConfigsSearchbox)
                    end
                })

                Library:RefreshConfigsList(ConfigsSearchbox)
            end
        end
    end
end

-- La libreria no carga ninguna UI por si sola: crea las tuyas desde tu script.

getgenv().Library = Library
return Library

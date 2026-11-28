local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local guiParent = (gethui and gethui()) or game:GetService("CoreGui")
pcall(function()
    local old = guiParent:FindFirstChild("pchaxx13_UI")
    if old then old:Destroy() end
end)

-- ============================================================
-- LOADER UI (same look/size as the Player indicator panel: 170x79)
-- Centered, one line per step, Tahoma font
-- ============================================================
local Loader = { Steps = {}, Order = {}, Dead = false, Percent = 0, Existed = {} }
do
    local LOADER_W, LOADER_H = 170, 79 -- same as Player indicator
    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    local STEP_DELAY = 0.07 -- seconds each finished step stays on screen

    pcall(function()
        local old = guiParent:FindFirstChild("pchaxx13_LOADER")
        if old then old:Destroy() end
    end)

    -- Start downloading the UI library right away (in parallel with everything else)
    Loader.LibURL = "https://raw.githubusercontent.com/c4xc4x/32487285/refs/heads/main/library.lua"
    Loader.LibDone = false
    task.spawn(function()
        local ok, src = pcall(function() return game:HttpGet(Loader.LibURL) end)
        Loader.LibSrc = ok and src or nil
        Loader.LibDone = true
    end)

    -- Make the folders first (silently) so the Tahoma font can be saved; remember if they already existed
    do
        local root, assets = "pchaxx13", "pchaxx13/assets"
        if makefolder and isfolder then
            Loader.Existed.root = isfolder(root)
            if not Loader.Existed.root then pcall(makefolder, root) end
            Loader.Existed.assets = isfolder(assets)
            if not Loader.Existed.assets then pcall(makefolder, assets) end
        end
    end

    -- Tahoma (same file the UI library uses)
    local TahomaFont
    pcall(function()
        if not (writefile and isfile and getcustomasset and isfolder and isfolder("pchaxx13/assets")) then return end
        local ttf = "pchaxx13/assets/Tahoma.ttf"
        local cfg = "pchaxx13/assets/Tahoma.ttf.json"
        if not isfile(ttf) then
            local data = game:HttpGet("https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/tahoma_bold.ttf")
            if not data or data == "" then return end
            writefile(ttf, data)
        end
        writefile(cfg, HttpService:JSONEncode({
            name = "Tahoma",
            faces = { { name = "Regular", weight = 400, style = "normal", assetId = getcustomasset(ttf) } },
        }))
        TahomaFont = Font.new(getcustomasset(cfg), Enum.FontWeight.Regular)
    end)

    local C = {
        Background = Color3.fromRGB(16, 16, 16),
        Inline = Color3.fromRGB(23, 23, 23),
        Outline = Color3.fromRGB(60, 60, 60),
        Border = Color3.fromRGB(10, 10, 10),
        Accent = Color3.fromRGB(176, 176, 209),
        Text = Color3.fromRGB(255, 255, 255),
        Inactive = Color3.fromRGB(155, 155, 155),
        Element2 = Color3.fromRGB(64, 64, 64),
        Ok = Color3.fromRGB(120, 230, 120),
        Fail = Color3.fromRGB(230, 90, 90),
    }

    local function mk(class, props, parent)
        local o = Instance.new(class)
        for k, v in pairs(props) do o[k] = v end
        o.Parent = parent
        return o
    end
    local function strokes(parent)
        mk("UIStroke", { Color = C.Outline, LineJoinMode = Enum.LineJoinMode.Miter, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, parent)
        local s2 = mk("UIStroke", { Color = C.Border, LineJoinMode = Enum.LineJoinMode.Miter, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, parent)
        pcall(function() s2.BorderOffset = UDim.new(0, 1) end)
    end
    local function lbl(parent, props)
        local base = {
            BackgroundTransparency = 1, BorderSizePixel = 0, TextSize = 12,
            TextColor3 = C.Text, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }
        for k, v in pairs(props) do base[k] = v end
        local l = mk("TextLabel", base, parent)
        if TahomaFont then l.FontFace = TahomaFont else l.Font = Enum.Font.SourceSans end
        return l
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "pchaxx13_LOADER"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 10
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    if not pcall(function() gui.Parent = guiParent end) then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- panel: fixed size, centered
    local panel = mk("Frame", {
        Name = "Panel", BackgroundColor3 = C.Background, BorderSizePixel = 0, ClipsDescendants = true,
        Size = UDim2.new(0, LOADER_W, 0, LOADER_H),
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
    }, gui)
    strokes(panel)

    local top = mk("Frame", { BackgroundColor3 = C.Inline, BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 25) }, panel)
    mk("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(180, 180, 180)) }, top)
    local liner = mk("Frame", {
        AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = C.Accent, BorderSizePixel = 0,
    }, top)
    mk("ImageLabel", {
        ImageColor3 = C.Accent, ScaleType = Enum.ScaleType.Slice, ImageTransparency = 0.6,
        Size = UDim2.new(1, 8, 1, 8), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
        Image = "http://www.roblox.com/asset/?id=18245826428", BackgroundTransparency = 1, BorderSizePixel = 0,
        SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
    }, liner)
    local title = lbl(top, {
        Text = "pchaxx13", TextXAlignment = Enum.TextXAlignment.Center,
        AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, -2), Size = UDim2.new(1, 0, 1, 0),
    })

    local content = mk("Frame", {
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 25), Size = UDim2.new(1, 0, 1, -25),
    }, panel)

    -- line 1: what is loading right now
    local line1 = lbl(content, { Text = "hi", Position = UDim2.new(0, 8, 0, 5), Size = UDim2.new(1, -16, 0, 14) })

    -- progress bar (same as the Player indicator health bar)
    local bar = mk("Frame", {
        BackgroundColor3 = C.Element2, BorderSizePixel = 0, ClipsDescendants = true,
        Position = UDim2.new(0, 8, 0, 22), Size = UDim2.new(1, -16, 0, 12),
    }, content)
    strokes(bar)
    mk("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(163, 163, 163)) }, bar)
    local fill = mk("Frame", { BackgroundColor3 = C.Accent, BorderSizePixel = 0, Size = UDim2.new(0, 0, 1, 0) }, bar)
    mk("UIGradient", { Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(163, 163, 163)) }, fill)

    -- line 3: result of the step (left) and progress 0/100 (right)
    local line3 = lbl(content, { Text = "", TextColor3 = C.Inactive, Position = UDim2.new(0, 8, 0, 37), Size = UDim2.new(1, -62, 0, 14) })
    local countLbl = lbl(content, {
        Text = "0/100", TextColor3 = C.Accent, TextXAlignment = Enum.TextXAlignment.Right,
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 37), Size = UDim2.new(0, 50, 0, 14),
    })

    local MARK = { pending = "[ ]", loading = "[..]", ok = "[ok]", fail = "[!!]", skip = "[--]" }

    function Loader:Refresh()
        local n, sum, left = #self.Order, 0, 0
        for _, id in ipairs(self.Order) do
            local r = self.Steps[id]
            if r.State == "ok" or r.State == "fail" or r.State == "skip" then
                sum = sum + 1
            else
                left = left + 1
                if r.State == "loading" and r.Total then
                    sum = sum + math.min(r.Count / r.Total, 1)
                end
            end
        end
        local ratio = (n > 0) and math.clamp(sum / n, 0, 1) or 0
        self.Percent = math.floor(ratio * 100 + 0.5)
        self.Left = left
        countLbl.Text = self.Percent .. "/100"
        title.Text = (left > 0) and ("loading (" .. left .. " left)") or "done"
        pcall(function()
            TweenService:Create(fill, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(ratio, 0, 1, 0),
            }):Play()
        end)
    end

    -- id, visible name, total (optional, for counted steps like 0/4)
    function Loader:Add(id, name, total)
        self.Order[#self.Order + 1] = id
        self.Steps[id] = { Name = name, Total = total, State = "pending", Count = 0 }
        self:Refresh()
    end

    -- state: pending | loading | ok | fail | skip
    function Loader:Set(id, state, detail, count)
        local r = self.Steps[id]
        if not r or self.Dead then return end
        r.State = state
        if count then r.Count = count end
        if detail == nil then
            if state == "loading" then
                detail = r.Total and (r.Count .. "/" .. r.Total) or "loading..."
            elseif state == "pending" then
                detail = "pending"
            end
        end
        line1.Text = (MARK[state] or "[ ]") .. " " .. r.Name
        line1.TextColor3 = C.Text
        line3.Text = detail or ""
        line3.TextColor3 = C.Text
        self:Refresh()
        if state == "ok" or state == "fail" or state == "skip" then
            task.wait(STEP_DELAY) -- keep each line visible for a moment
        end
    end

    function Loader:Finish(failMsg, failDetail)
        local f = self.Steps.fonts
        local t0 = os.clock()
        while f and (f.State == "pending" or f.State == "loading") and os.clock() - t0 < 6 do
            task.wait(0.1)
        end
        if f and (f.State == "pending" or f.State == "loading") then
            self:Set("fonts", "fail", "timeout")
        end
        if failMsg then
            line1.Text = failMsg
            line1.TextColor3 = C.Fail
            line3.Text = failDetail or ""
            line3.TextColor3 = C.Fail
            title.Text = "failed"
            task.wait(5)
        else
            line1.Text = "welcome back"
            line1.TextColor3 = C.Text
            line3.Text = ""
            title.Text = "loaded"
            task.wait(0.5)
        end
        self.Dead = true
        pcall(function() gui:Destroy() end)
    end
end

Loader:Add("dir_root", "Folder pchaxx13")
Loader:Add("dir_assets", "Folder assets")
Loader:Add("ws_folder", "Workspace folder")
Loader:Add("img_esp", "Image esp.png")
Loader:Add("img_logo", "Image logo.png")
Loader:Add("assets", "Custom assets", 2)
Loader:Add("fonts", "Fonts", 6)
Loader:Add("lib", "UI library")

local IMAGE_B64 = "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"
local LOGO_B64 = "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"

local function b64decode(data)
    if crypt and crypt.base64decode then
        local ok, r = pcall(crypt.base64decode, data)
        if ok and r then return r end
    end
    if base64_decode then
        local ok, r = pcall(base64_decode, data)
        if ok and r then return r end
    end
    if base64 and base64.decode then
        local ok, r = pcall(base64.decode, data)
        if ok and r then return r end
    end

    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup = {}
    for i = 1, #chars do lookup[chars:sub(i, i)] = i - 1 end
    data = data:gsub("[^%w%+/=]", "")
    local out, n = {}, 0
    for i = 1, #data, 4 do
        local a = lookup[data:sub(i, i)] or 0
        local b = lookup[data:sub(i + 1, i + 1)] or 0
        local c = lookup[data:sub(i + 2, i + 2)]
        local d = lookup[data:sub(i + 3, i + 3)]
        local v = a * 262144 + b * 4096 + (c or 0) * 64 + (d or 0)
        n = n + 1; out[n] = string.char(math.floor(v / 65536) % 256)
        if c then n = n + 1; out[n] = string.char(math.floor(v / 256) % 256) end
        if d then n = n + 1; out[n] = string.char(v % 256) end
    end
    return table.concat(out)
end

local FOLDER = "pchaxx13"
local ASSETS = FOLDER .. "/assets"
local IMG_PATH = ASSETS .. "/esp.png"
local LOGO_PATH = ASSETS .. "/logo.png"

do
    local function folderStep(id, path)
        Loader:Set(id, "loading")
        if not (makefolder and isfolder) then
            Loader:Set(id, "skip", "not supported")
            return
        end
        local existed = (id == "dir_root") and Loader.Existed.root or Loader.Existed.assets
        if existed == nil then existed = isfolder(path) end
        if not isfolder(path) then pcall(makefolder, path) end
        if isfolder(path) then
            Loader:Set(id, "ok", existed and "already exists" or "created")
        else
            Loader:Set(id, "fail", "error")
        end
    end
    folderStep("dir_root", FOLDER)
    folderStep("dir_assets", ASSETS)

    Loader:Set("ws_folder", "loading")
    local wsExisted = workspace:FindFirstChild(FOLDER) ~= nil
    local wsOk = pcall(function()
        local root = workspace:FindFirstChild(FOLDER) or Instance.new("Folder")
        root.Name = FOLDER
        root.Parent = workspace
        local assets = root:FindFirstChild("assets") or Instance.new("Folder")
        assets.Name = "assets"
        assets.Parent = root
    end)
    Loader:Set("ws_folder", wsOk and "ok" or "fail", wsOk and (wsExisted and "already exists" or "created") or "error")

    local function writeStep(id, path, b64)
        Loader:Set(id, "loading")
        if not writefile then
            Loader:Set(id, "skip", "no writefile")
            return
        end
        local ok = pcall(function() writefile(path, b64decode(b64)) end)
        Loader:Set(id, ok and "ok" or "fail", ok and "saved" or "error")
    end
    writeStep("img_esp", IMG_PATH, IMAGE_B64)
    writeStep("img_logo", LOGO_PATH, LOGO_B64)
end

local IMAGE_ASSET = ""
local LOGO_ASSET = ""
do
    local getasset = getcustomasset or getsynasset
    local got = 0
    Loader:Set("assets", "loading", nil, 0)
    if getasset and isfile and isfile(IMG_PATH) then
        local ok, res = pcall(getasset, IMG_PATH)
        if ok then IMAGE_ASSET = res; got = got + 1 end
    end
    Loader:Set("assets", "loading", nil, got)
    if getasset and isfile and isfile(LOGO_PATH) then
        local ok, res = pcall(getasset, LOGO_PATH)
        if ok then LOGO_ASSET = res; got = got + 1 end
    end
    if not getasset then
        Loader:Set("assets", "skip", "not supported")
    else
        Loader:Set("assets", got == 2 and "ok" or "fail", got .. "/2", got)
    end
end

local State = { Glow = false, Enabled = false, Image = false, Name = false, Box = false, Aimlock = false, Notify = false, Health = false, Trigger = false, Test = false, Self = false, UseDisplay = false, Distance = false, Gun = false, HealthValue = false, HealthGlow = false, Arrows = false, ArrowsGlow = false, HeadDot = false, Tracers = false }
local Settings = {
    TriggerMethod = "Click",
    TestMethod = "Click",
    TestMaxDist = 2000,
    MaxDist = 3000,
    TestInfinite = true,

    LockSmoothOn = false,
    LockSmooth = 0,
    LockPredOn = false,
    LockPredH = 0,
    LockPredV = 0,
    LockAim = "Camera",

    LockTeamCheck = false,
    TestTeamCheck = false,
}
local UIReady = false

local genv = (getgenv and getgenv()) or _G

if genv.pchaxx13_ESPConn then
    pcall(function() genv.pchaxx13_ESPConn:Disconnect() end)
    genv.pchaxx13_ESPConn = nil
end
pcall(function()
    local old = guiParent:FindFirstChild("pchaxx13_ESP")
    if old then old:Destroy() end
end)

local BLACK = Color3.fromRGB(0, 0, 0)
local WHITE = Color3.fromRGB(255, 255, 255)

local VisCfg = {
    Name = { Size = 12, Gap = 3, Color = WHITE, OutlineColor = BLACK },
    Box = { Color = Color3.fromRGB(90, 111, 214), Thickness = 1, OutlineColor = BLACK, OutlineThickness = 1 },
    Image = { Color = WHITE, Opacity = 1 },
    RefreshRate = 60,
    RefreshAcc = 0,
    Glow = { Color = Color3.fromRGB(134, 154, 255), Transparency = 0.6, Outer = 20, Inner = 0 }, -- Outer = alcance hacia afuera (px), Inner = hacia adentro (0 = nada por dentro del box)
    Distance = { Size = 12, Color = WHITE },
    Gun = { Size = 12, Color = WHITE },
    Fonts = {
        Name = "Proggy Clean", Distance = "Proggy Clean", Gun = "Proggy Clean",
        Health = "Proggy Clean",
    },
    Method = "Static",
    Health = {
        Width = 1, SideGap = 1, TextSize = 12, OutlineColor = BLACK,
        BgColor = BLACK, -- fondo de la barra (la parte de vida perdida)
        Color1 = Color3.fromRGB(0, 255, 0),
        Color2 = Color3.fromRGB(255, 255, 0),
        Color3 = Color3.fromRGB(255, 0, 0),
    },
}
local VisVersion = 1
VisCfg.Accent = Color3.fromRGB(118, 134, 214)
VisCfg.HpGlow = { Color = Color3.fromRGB(134, 154, 255), Transparency = 0.6, Outer = 8 }
VisCfg.GlowAmount = 50 -- slider "Glow" (1-100): 50 = valores base
VisCfg.Arrows = {
    Color = VisCfg.Accent, GlowColor = VisCfg.Accent, GlowTransparency = 0.6,
    Size = 20, Position = 40, -- px / % del radio de la pantalla (fijos, sin sliders). La distancia maxima es Settings.MaxDist (slider "Distance")
    Show = { Name = true, Distance = true, Tool = false },
}
VisCfg.HeadDot = { Color = VisCfg.Accent }
VisCfg.Tracers = { Color = VisCfg.Accent, Origin = "Up", Thickness = 1 }

local FONT_URLS = {
    ["Proggy Clean"] = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/ProggyClean.ttf",
    ["Smallest Pixel-7"] = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/smallest_pixel-7.ttf",
    ["Tahoma"] = "https://github.com/i77lhm/storage/raw/refs/heads/main/fonts/tahoma_bold.ttf",
    ["Pixel Arial"] = "https://github.com/smi9/UnnamedCheats/raw/refs/heads/main/PixelArial.TTF",
    ["Arial"] = "https://raw.githubusercontent.com/smi9/UnnamedCheats/refs/heads/main/Arial.ttf",
    ["Zekton"] = "https://github.com/LuckyHub1/LuckyHub/raw/refs/heads/main/zekton_rg.ttf",
}

local FONT_SIZES = {
    ["Proggy Clean"]     = { Name = 12, Distance = 12, Gun = 12, Health = 12 },
    ["Smallest Pixel-7"] = { Name = 12, Distance = 12, Gun = 12, Health = 12 },
    ["Tahoma"]           = { Name = 12, Distance = 12, Gun = 12, Health = 12 },
    ["Pixel Arial"]      = { Name = 12, Distance = 12, Gun = 12, Health = 12 },
    ["Arial"]            = { Name = 12, Distance = 12, Gun = 12, Health = 12 },
    ["Zekton"]           = { Name = 12, Distance = 12, Gun = 12, Health = 12 },
}
local LoadedFonts = {}
local FontsVer = 0

local function loadCustomFont(name, url)
    if not (writefile and isfile and getcustomasset) then return end
    local fn = name:gsub("%s+", "")
    local ttf = ASSETS .. "/" .. fn .. ".ttf"
    local cfg = ASSETS .. "/" .. fn .. ".ttf.json"
    if not isfile(ttf) then
        local okDL, data = pcall(function() return game:HttpGet(url) end)
        if not okDL or not data or data == "" then return end
        if not pcall(writefile, ttf, data) then return end
    end
    local okCfg = pcall(function()
        writefile(cfg, game:GetService("HttpService"):JSONEncode({
            name = fn,
            faces = { { name = "Regular", weight = 400, style = "normal", assetId = getcustomasset(ttf) } },
        }))
    end)
    if not okCfg then return end
    local okF, font = pcall(Font.new, getcustomasset(cfg), Enum.FontWeight.Regular)
    if okF and font then
        LoadedFonts[name] = font
        FontsVer = FontsVer + 1
    end
end

task.spawn(function()
    Loader:Set("fonts", "loading", nil, 0)
    local total, done, okc = 0, 0, 0
    for _ in pairs(FONT_URLS) do total = total + 1 end
    for name, url in pairs(FONT_URLS) do
        task.spawn(function()
            pcall(loadCustomFont, name, url)
            done = done + 1
            if LoadedFonts[name] then okc = okc + 1 end
            if done < total then
                Loader:Set("fonts", "loading", nil, done)
            else
                Loader:Set("fonts", okc == total and "ok" or "fail", okc .. "/" .. total, done)
            end
        end)
    end
end)

local function applyFont(label, name)
    local f = LoadedFonts[name]
    if f then
        label.FontFace = f
    else
        local ok, e = pcall(function() return Enum.Font[name] end)
        label.Font = (ok and e) or Enum.Font.SourceSans
    end
end

local function pname(plr)
    return State.UseDisplay and plr.DisplayName or plr.Name
end

local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "pchaxx13_ESP"
ESPGui.ResetOnSpawn = false
ESPGui.IgnoreGuiInset = true
ESPGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
do
    local okP = pcall(function() ESPGui.Parent = guiParent end)
    if not okP then ESPGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
end

local ESPObjs = {}
local VisX = {} -- helpers de arrows / tracers / head dot (se rellena antes de updateESP)

-- Image asset id: acepta id numerico, rbxassetid://, link de roblox o una URL de imagen (se descarga a pchaxx13/assets)
VisCfg.ImgN = 0
function VisCfg.SetImage(v)
    v = tostring(v or ""):match("^%s*(.-)%s*$")
    if v == "" then VisCfg.CustomImage = nil return true end
    local id = v:match("^rbxassetid://(%d+)$") or v:match("^(%d+)$") or v:match("[?&]id=(%d+)")
    if id then VisCfg.CustomImage = "rbxassetid://" .. id return true end
    if v:find("^rbxasset") or v:find("^rbxthumb") then VisCfg.CustomImage = v return true end
    if v:find("^https?://") then
        local getasset = getcustomasset or getsynasset
        if not (writefile and getasset) then return false end
        local ok, data = pcall(function() return game:HttpGet(v) end)
        if not ok or type(data) ~= "string" or #data < 16 then return false end
        VisCfg.ImgN = VisCfg.ImgN + 1
        local path = ASSETS .. "/custom_fill_" .. VisCfg.ImgN .. ".png"
        if not pcall(writefile, path, data) then return false end
        local ok2, asset = pcall(getasset, path)
        if not ok2 then return false end
        VisCfg.CustomImage = asset
        return true
    end
    return false
end

local function newLine(parent)
    local line = Instance.new("Frame")
    line.BorderSizePixel = 0
    line.BackgroundColor3 = VisCfg.Box.Color
    line.Parent = parent

    local outline = Instance.new("Frame")
    outline.BorderSizePixel = 0
    outline.BackgroundColor3 = VisCfg.Box.OutlineColor
    outline.ZIndex = 0
    line.ZIndex = 1
    outline.Parent = line
    return line, outline
end

local function newLabel(parent)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Size = UDim2.new(0, 100, 0, VisCfg.Name.Size)
    l.Font = Enum.Font.SourceSans
    l.TextSize = VisCfg.Name.Size
    l.TextColor3 = VisCfg.Name.Color
    l.TextStrokeTransparency = 1
    l.TextTransparency = 0
    l.ZIndex = 2
    l.Parent = parent

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = VisCfg.Name.OutlineColor
    stroke.LineJoinMode = Enum.LineJoinMode.Miter
    stroke.Parent = l
    return l
end

local function destroyESP(plr)
    local obj = ESPObjs[plr]
    if obj then
        pcall(function() obj.Container:Destroy() end)
        pcall(function() obj.ArrowCont:Destroy() end)
        ESPObjs[plr] = nil
    end
end

local function createESP(plr)
    destroyESP(plr)
    local obj = { Lines = {}, Outlines = {}, FontsVer = -1, HpVer = -1 }

    local container = Instance.new("Frame")
    container.Name = "ESPObj"
    container.BackgroundTransparency = 1
    container.Visible = false
    container.Parent = ESPGui
    obj.Container = container

    local fill = Instance.new("ImageLabel")
    fill.Name = "BoxFillImage"
    fill.BackgroundTransparency = 1
    fill.BorderSizePixel = 0
    fill.ScaleType = Enum.ScaleType.Stretch
    fill.Image = IMAGE_ASSET
    fill.ZIndex = -2
    fill.Visible = false
    fill.Parent = container
    obj.Fill = fill

    for i = 1, 4 do
        obj.Lines[i], obj.Outlines[i] = newLine(container)
    end

    -- Glow: fade hacia afuera (4 franjas recortadas) + fade corto hacia adentro (1 recorte).
    -- Todo va DEBAJO de la linea blanca y su outline, asi que nunca los pisa.
    local function mkGlow(parent)
        local g = Instance.new("ImageLabel")
        g.Name = "Glow"
        g.BackgroundTransparency = 1
        g.BorderSizePixel = 0
        g.Image = "http://www.roblox.com/asset/?id=18245826428"
        g.ScaleType = Enum.ScaleType.Slice
        g.SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
        g.ImageColor3 = VisCfg.Glow.Color
        g.ImageTransparency = VisCfg.Glow.Transparency
        g.ZIndex = -1
        g.Parent = parent
        return g
    end
    local function mkClip()
        local c = Instance.new("Frame")
        c.Name = "GlowClip"
        c.BackgroundTransparency = 1
        c.BorderSizePixel = 0
        c.ClipsDescendants = true
        c.ZIndex = -1
        c.Visible = false
        c.Parent = container
        return c
    end
    obj.GlowOut, obj.GlowOutClips, obj.GlowIn = {}, {}, {}
    for i = 1, 4 do
        obj.GlowOutClips[i] = mkClip()
        obj.GlowOut[i] = mkGlow(obj.GlowOutClips[i])
    end
    obj.GlowInClip = mkClip()
    for i = 1, 4 do
        obj.GlowIn[i] = mkGlow(obj.GlowInClip)
    end

    local nameText = newLabel(container)
    nameText.TextYAlignment = Enum.TextYAlignment.Bottom
    nameText.Visible = false
    obj.Name = nameText

    local distText = newLabel(container)
    distText.TextYAlignment = Enum.TextYAlignment.Top
    distText.Visible = false
    obj.Dist = distText

    local gunText = newLabel(container)
    gunText.TextYAlignment = Enum.TextYAlignment.Top
    gunText.Visible = false
    obj.Gun = gunText

    local hpOutline = Instance.new("Frame")
    hpOutline.BackgroundColor3 = VisCfg.Health.OutlineColor
    hpOutline.BorderSizePixel = 0
    hpOutline.Visible = false
    hpOutline.ZIndex = 1
    hpOutline.Parent = container
    obj.HpOutline = hpOutline

    -- fondo de la barra (se ve cuando pierdes vida) + glow de la barra
    local hpBg = Instance.new("Frame")
    hpBg.BorderSizePixel = 0
    hpBg.BackgroundColor3 = VisCfg.Health.BgColor
    hpBg.Position = UDim2.new(0, 1, 0, 1)
    hpBg.ZIndex = 1
    hpBg.Parent = hpOutline
    obj.HpBg = hpBg

    local hpGlow = mkGlow(container)
    hpGlow.ZIndex = 0
    hpGlow.ImageColor3 = VisCfg.HpGlow.Color
    hpGlow.ImageTransparency = VisCfg.HpGlow.Transparency
    hpGlow.Visible = false
    obj.HpGlow = hpGlow

    local hpContainer = Instance.new("Frame")
    hpContainer.BackgroundTransparency = 1
    hpContainer.ClipsDescendants = true
    hpContainer.BorderSizePixel = 0
    hpContainer.ZIndex = 2
    hpContainer.Parent = hpOutline
    obj.HpContainer = hpContainer

    local hpBar = Instance.new("Frame")
    hpBar.BackgroundColor3 = WHITE
    hpBar.BorderSizePixel = 0
    hpBar.ZIndex = 2
    hpBar.Parent = hpContainer
    obj.HpBar = hpBar

    local grad = Instance.new("UIGradient")
    grad.Rotation = 90
    grad.Parent = hpBar
    obj.HpGradient = grad

    local hpText = newLabel(container)
    hpText.TextYAlignment = Enum.TextYAlignment.Center
    hpText.TextSize = VisCfg.Health.TextSize
    hpText.ZIndex = 3
    hpText.Visible = false
    obj.HpText = hpText

    -- tracer (linea con contorno negro)
    local trOut = Instance.new("Frame")
    trOut.BorderSizePixel = 0
    trOut.BackgroundColor3 = BLACK
    trOut.AnchorPoint = Vector2.new(0.5, 0.5)
    trOut.ZIndex = 0
    trOut.Visible = false
    trOut.Parent = container
    obj.TracerOut = trOut
    local tr = Instance.new("Frame")
    tr.BorderSizePixel = 0
    tr.BackgroundColor3 = VisCfg.Tracers.Color
    tr.AnchorPoint = Vector2.new(0.5, 0.5)
    tr.ZIndex = 1
    tr.Visible = false
    tr.Parent = container
    obj.Tracer = tr

    -- head dot (hexagono de 6 lineas con contorno negro)
    obj.Hex = {}
    for i = 1, 6 do
        local ln = Instance.new("Frame")
        ln.BorderSizePixel = 0
        ln.BackgroundColor3 = VisCfg.HeadDot.Color
        ln.AnchorPoint = Vector2.new(0.5, 0.5)
        ln.ZIndex = 2
        ln.Visible = false
        ln.Parent = container
        local st = Instance.new("UIStroke")
        st.Thickness = 1
        st.Color = BLACK
        st.LineJoinMode = Enum.LineJoinMode.Miter
        st.Parent = ln
        obj.Hex[i] = ln
    end

    -- arrows (jugadores fuera de pantalla): contenedor aparte porque el principal se oculta fuera de pantalla
    local arrowCont = Instance.new("Frame")
    arrowCont.Name = "ArrowObj"
    arrowCont.BackgroundTransparency = 1
    arrowCont.Visible = false
    arrowCont.Parent = ESPGui
    obj.ArrowCont = arrowCont
    local ag = mkGlow(arrowCont)
    ag.AnchorPoint = Vector2.new(0.5, 0.5)
    ag.ZIndex = 1
    ag.ImageColor3 = VisCfg.Arrows.GlowColor
    ag.ImageTransparency = VisCfg.Arrows.GlowTransparency
    ag.Visible = false
    obj.ArrowGlow = ag
    obj.Arrow = VisX.makeArrowVisual(arrowCont)
    obj.ArrowTexts, obj.ArrowOrder = {}, {}
    for i = 1, 3 do
        local lb = newLabel(arrowCont)
        lb.ZIndex = 3
        lb.Visible = false
        obj.ArrowTexts[i] = lb
    end

    ESPObjs[plr] = obj
    return obj
end

-- ============================================================
-- ESP OPTIMIZADO
--  * Las propiedades de GUI solo se escriben cuando cambian (cache por instancia)
--  * El box Dynamic se proyecta con matematicas en Lua (sin 16 llamadas a la API por parte)
--  * Se cachean Humanoid / root / lista de partes
--  * Jugadores lejanos se actualizan menos veces
-- ============================================================
local PC = setmetatable({}, { __mode = "k" })

local function setp(inst, prop, val)
    local c = PC[inst]
    if not c then c = {}; PC[inst] = c end
    if c[prop] ~= val then
        c[prop] = val
        inst[prop] = val
    end
end

local function setU2(inst, prop, sx, ox, sy, oy)
    local c = PC[inst]
    if not c then c = {}; PC[inst] = c end
    local t = c[prop]
    if not t then t = {}; c[prop] = t end
    if t[1] ~= sx or t[2] ~= ox or t[3] ~= sy or t[4] ~= oy then
        t[1], t[2], t[3], t[4] = sx, ox, sy, oy
        inst[prop] = UDim2.new(sx, ox, sy, oy)
    end
end

local ESPF = { ok = false }

-- Datos de camara calculados UNA vez por frame
local function prepFrame(cam)
    local cf = cam.CFrame
    local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
    local pc = cam:WorldToViewportPoint(cf * Vector3.new(0, 0, -1))
    local p1 = cam:WorldToViewportPoint(cf * Vector3.new(1, 0, -1))
    local p2 = cam:WorldToViewportPoint(cf * Vector3.new(0, 1, -1))
    local fx, fy = p1.X - pc.X, pc.Y - p2.Y
    local F = ESPF
    F.cam = cam
    F.x, F.y, F.z = x, y, z
    F.r00, F.r01, F.r02, F.r10, F.r11, F.r12, F.r20, F.r21, F.r22 = r00, r01, r02, r10, r11, r12, r20, r21, r22
    F.cx, F.cy, F.fx, F.fy = pc.X, pc.Y, fx, fy
    F.ok = fx > 0 and fy > 0 and fx == fx and fy == fy and not genv.pchaxx13_Stretch
end

local function getParts(obj, char)
    local now = os.clock()
    if obj.PartChar ~= char or now - (obj.PartT or 0) > 1 then
        local list = {}
        for _, p in ipairs(char:GetChildren()) do
            if p:IsA("BasePart") and p.Size.Magnitude <= 20 then list[#list + 1] = p end
        end
        obj.Parts, obj.PartChar, obj.PartT = list, char, now
    end
    return obj.Parts
end

-- Caja Dynamic rapida: devuelve minX, minY, maxX, maxY, nParts  (o nil si hay que usar el metodo lento)
local function dynBoxFast(char, obj, F)
    local parts = getParts(obj, char)
    local rootRef = obj.Root
    local rp = rootRef and rootRef.Parent and rootRef.Position or nil
    local x0, y0, z0 = F.x, F.y, F.z
    local R00, R01, R02, R10, R11, R12, R20, R21, R22 = F.r00, F.r01, F.r02, F.r10, F.r11, F.r12, F.r20, F.r21, F.r22
    local ccx, ccy, fx, fy = F.cx, F.cy, F.fx, F.fy
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    local n = 0
    for i = 1, #parts do
        local part = parts[i]
        if part.Parent == char and part.Name ~= "HumanoidRootPart" and part.Transparency < 0.95 then
            local px, py, pz, a00, a01, a02, a10, a11, a12, a20, a21, a22 = part.CFrame:GetComponents()
            -- partes lanzadas lejos del cuerpo no deben estirar la caja
            if rp and ((px - rp.X) ^ 2 + (py - rp.Y) ^ 2 + (pz - rp.Z) ^ 2 > 225) then continue end
            n = n + 1
            local sz = part.Size
            local hx, hy, hz = sz.X * 0.5, sz.Y * 0.5, sz.Z * 0.5
            if part.Name == "Head" then
                local sm = VisX.HeadMesh[part]
                if sm == nil then
                    sm = part:FindFirstChildOfClass("SpecialMesh") or false
                    VisX.HeadMesh[part] = sm
                end
                if sm and sm.MeshType == Enum.MeshType.Head then hy = hy * math.max(sm.Scale.Y, 1) end
            end
            local dx, dy, dz = px - x0, py - y0, pz - z0
            -- centro de la parte en espacio de camara
            local cxv = R00 * dx + R10 * dy + R20 * dz
            local cyv = R01 * dx + R11 * dy + R21 * dz
            local czv = R02 * dx + R12 * dy + R22 * dz
            -- ejes de la parte (ya multiplicados por medio tamaño) en espacio de camara
            local ux = (R00 * a00 + R10 * a10 + R20 * a20) * hx
            local uy = (R01 * a00 + R11 * a10 + R21 * a20) * hx
            local uz = (R02 * a00 + R12 * a10 + R22 * a20) * hx
            local vx = (R00 * a01 + R10 * a11 + R20 * a21) * hy
            local vy = (R01 * a01 + R11 * a11 + R21 * a21) * hy
            local vz = (R02 * a01 + R12 * a11 + R22 * a21) * hy
            local wx = (R00 * a02 + R10 * a12 + R20 * a22) * hz
            local wy = (R01 * a02 + R11 * a12 + R21 * a22) * hz
            local wz = (R02 * a02 + R12 * a12 + R22 * a22) * hz
            for sa = -1, 1, 2 do
                for sb = -1, 1, 2 do
                    for sc = -1, 1, 2 do
                        local qx = cxv + sa * ux + sb * vx + sc * wx
                        local qy = cyv + sa * uy + sb * vy + sc * wy
                        local qz = czv + sa * uz + sb * vz + sc * wz
                        local depth = -qz
                        if depth < 0.05 then return nil end -- esquina detras/pegada a la camara: metodo lento
                        local sx = ccx + qx / depth * fx
                        local sy = ccy - qy / depth * fy
                        if sx < minX then minX = sx end
                        if sx > maxX then maxX = sx end
                        if sy < minY then minY = sy end
                        if sy > maxY then maxY = sy end
                    end
                end
            end
        end
    end
    return minX, minY, maxX, maxY, n
end

-- Metodo lento original (por si alguna esquina queda detras de la camara, o metodo no-Dynamic)
local function slowBox(cam, char, method)
    local full = (method == "Dynamic")
    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    local parts = 0
    local rootp = char:FindFirstChild("HumanoidRootPart")
    for _, part in ipairs(char:GetChildren()) do
        if part:IsA("BasePart") and (not full or (part.Name ~= "HumanoidRootPart" and part.Transparency < 0.95
            and part.Size.Magnitude <= 20 and (not rootp or (part.Position - rootp.Position).Magnitude <= 15))) then
            parts = parts + 1
            local cf, hs = part.CFrame, part.Size / 2
            if full then
                for sxn = -1, 1, 2 do
                    for syn = -1, 1, 2 do
                        for szn = -1, 1, 2 do
                            local sp = cam:WorldToViewportPoint(cf * Vector3.new(hs.X * sxn, hs.Y * syn, hs.Z * szn))
                            minX = math.min(minX, sp.X); maxX = math.max(maxX, sp.X)
                            minY = math.min(minY, sp.Y); maxY = math.max(maxY, sp.Y)
                        end
                    end
                end
            else
                local s1 = cam:WorldToViewportPoint(cf * Vector3.new(hs.X, hs.Y, hs.Z))
                local s2 = cam:WorldToViewportPoint(cf * Vector3.new(-hs.X, -hs.Y, -hs.Z))
                minX = math.min(minX, s1.X, s2.X)
                maxX = math.max(maxX, s1.X, s2.X)
                minY = math.min(minY, s1.Y, s2.Y)
                maxY = math.max(maxY, s1.Y, s2.Y)
            end
        end
    end
    return minX, minY, maxX, maxY, parts
end

-- tablas reutilizables (evita crear tablas nuevas en cada frame)
local LR = { {}, {}, {}, {} }
local OCR = { {}, {}, {}, {} }
local function set4(t, a, b, c, d) t[1], t[2], t[3], t[4] = a, b, c, d end

-- ============================================================
-- Arrows / Tracers / Head dot
-- ============================================================
do
    -- PNG de la flecha: triangulo blanco con contorno NEGRO (el blanco se tiñe con ImageColor3; el negro se queda negro)
    local function buildArrowPng()
        local W, H, SS, OUT = 96, 96, 4, 5.5 -- contorno ~1px a 20px de flecha (antes 5/64)
        local pts = { { 48, 5, 87, 87 }, { 87, 87, 9, 87 }, { 9, 87, 48, 5 } }
        local E = {}
        for i, p in ipairs(pts) do
            local dx, dy = p[3] - p[1], p[4] - p[2]
            E[i] = { p[1], p[2], dx, dy, math.sqrt(dx * dx + dy * dy) }
        end
        local rows = {}
        local n = SS * SS
        for y = 0, H - 1 do
            local row = { "\0" }
            for x = 0, W - 1 do
                local o, f = 0, 0
                for j = 0, SS - 1 do
                    for i = 0, SS - 1 do
                        local px, py = x + (i + 0.5) / SS, y + (j + 0.5) / SS
                        local d = math.huge
                        for k = 1, 3 do
                            local e = E[k]
                            local dd = (e[3] * (py - e[2]) - e[4] * (px - e[1])) / e[5]
                            if dd < d then d = dd end
                        end
                        if d >= 0 then o = o + 1 end
                        if d >= OUT then f = f + 1 end
                    end
                end
                local a = math.floor(o / n * 255 + 0.5)
                local v = 0
                if o > 0 then
                    -- transicion contorno -> relleno mas seca (menos borroso al escalar)
                    local q = math.clamp((f / o - 0.5) * 1.8 + 0.5, 0, 1)
                    v = math.floor(q * 255 + 0.5)
                end
                row[#row + 1] = string.char(v, v, v, a)
            end
            rows[#rows + 1] = table.concat(row)
        end
        local raw = table.concat(rows)

        local CRCT = {}
        for i = 0, 255 do
            local c = i
            for _ = 1, 8 do
                if bit32.band(c, 1) == 1 then
                    c = bit32.bxor(0xEDB88320, bit32.rshift(c, 1))
                else
                    c = bit32.rshift(c, 1)
                end
            end
            CRCT[i + 1] = c
        end
        local function crc32(str)
            local c = 0xFFFFFFFF
            for i = 1, #str do
                c = bit32.bxor(CRCT[bit32.band(bit32.bxor(c, string.byte(str, i)), 0xFF) + 1], bit32.rshift(c, 8))
            end
            return bit32.bxor(c, 0xFFFFFFFF)
        end
        local a, b = 1, 0
        for i = 1, #raw do
            a = (a + string.byte(raw, i)) % 65521
            b = (b + a) % 65521
        end
        local function chunk(t, d)
            return string.pack(">I4", #d) .. t .. d .. string.pack(">I4", crc32(t .. d))
        end
        local z = "\120\1" .. "\1" .. string.pack("<I2", #raw) .. string.pack("<I2", 65535 - #raw) .. raw
            .. string.pack(">I4", b * 65536 + a)
        return "\137PNG\r\n\26\n"
            .. chunk("IHDR", string.pack(">I4I4", W, H) .. "\8\6\0\0\0")
            .. chunk("IDAT", z)
            .. chunk("IEND", "")
    end

    local okA, asset = pcall(function()
        local getasset = getcustomasset or getsynasset
        if not (writefile and getasset) then return nil end
        local path = ASSETS .. "/arrow_tri_v2.png"
        if not (isfile and isfile(path)) then writefile(path, buildArrowPng()) end
        return getasset(path)
    end)
    if okA and type(asset) == "string" and asset ~= "" then VisX.ArrowAsset = asset end

    -- si no se pudo generar el PNG se usa el caracter ▲ con contorno negro
    function VisX.makeArrowVisual(parent)
        if VisX.ArrowAsset then
            local i = Instance.new("ImageLabel")
            i.BackgroundTransparency = 1
            i.BorderSizePixel = 0
            i.Image = VisX.ArrowAsset
            i.ScaleType = Enum.ScaleType.Fit
            i.AnchorPoint = Vector2.new(0.5, 0.5)
            i.ZIndex = 2
            i.Parent = parent
            return i
        end
        local t = Instance.new("TextLabel")
        t.BackgroundTransparency = 1
        t.Text = "\u{25B2}"
        t.Font = Enum.Font.SourceSansBold
        t.TextScaled = true
        t.TextColor3 = WHITE
        t.AnchorPoint = Vector2.new(0.5, 0.5)
        t.ZIndex = 2
        local st = Instance.new("UIStroke")
        st.Thickness = 1
        st.Color = BLACK
        st.Parent = t
        t.Parent = parent
        return t
    end

    -- slider "Glow" (1-100): escala el alcance Y la intensidad de TODOS los glows (50 = valores base)
    function VisX.glow(outer, tr)
        local k = VisCfg.GlowAmount / 50
        return outer * k, math.clamp(1 - (1 - tr) * k, 0, 1)
    end
    VisX.HeadMesh = setmetatable({}, { __mode = "k" })

    local HEX_ANG = { -90, -30, 30, 90, 150, 210 } -- hexagono con punta arriba
    function VisX.placeHex(lines, cx, cy, R, col)
        for i = 1, 6 do
            local a1 = math.rad(HEX_ANG[i])
            local a2 = math.rad(HEX_ANG[i % 6 + 1])
            local x1, y1 = cx + R * math.cos(a1), cy + R * math.sin(a1)
            local x2, y2 = cx + R * math.cos(a2), cy + R * math.sin(a2)
            local ln = lines[i]
            setU2(ln, "Position", 0, (x1 + x2) * 0.5, 0, (y1 + y2) * 0.5)
            setU2(ln, "Size", 0, R + 1, 0, 1)
            setp(ln, "Rotation", math.deg(math.atan2(y2 - y1, x2 - x1)))
            setp(ln, "BackgroundColor3", col)
            setp(ln, "Visible", true)
        end
    end

    local function hideHex(lines)
        for i = 1, 6 do setp(lines[i], "Visible", false) end
    end

    function VisX.updateHead(obj, char, cam)
        local lines = obj.Hex
        if not State.HeadDot then hideHex(lines) return end
        local head = obj.HeadPart
        if not (head and head.Parent == char) then
            head = char:FindFirstChild("Head")
            obj.HeadPart = head
        end
        if not head then hideHex(lines) return end
        local sp, on = cam:WorldToViewportPoint(head.Position)
        if not on or sp.Z <= 0 then hideHex(lines) return end
        local pps = (cam.ViewportSize.Y * 0.5) / math.tan(math.rad(cam.FieldOfView) * 0.5) / sp.Z -- px por stud a esa profundidad
        local sz = head.Size
        local hw = math.min(sz.X, 1.3 * math.max(sz.Y, sz.Z))
        VisX.placeHex(lines, sp.X, sp.Y, math.max(hw * pps * 0.635, 3), VisCfg.HeadDot.Color)
    end

    function VisX.updateTracer(obj, cam, sx, sy)
        local tr, tro = obj.Tracer, obj.TracerOut
        if not State.Tracers then
            setp(tr, "Visible", false)
            setp(tro, "Visible", false)
            return
        end
        local T = VisCfg.Tracers
        local vs = cam.ViewportSize
        local ox, oy
        local o = T.Origin
        if o == "Down" then ox, oy = vs.X * 0.5, vs.Y
        elseif o == "Left" then ox, oy = 0, vs.Y * 0.5
        elseif o == "Right" then ox, oy = vs.X, vs.Y * 0.5
        else ox, oy = vs.X * 0.5, 0 end
        local dx, dy = sx - ox, sy - oy
        local len = math.sqrt(dx * dx + dy * dy)
        local rot = math.deg(math.atan2(dy, dx))
        local mx, my = ox + dx * 0.5, oy + dy * 0.5
        local th = T.Thickness
        setp(tro, "Visible", true)
        setp(tr, "Visible", true)
        setU2(tro, "Position", 0, mx, 0, my)
        setU2(tro, "Size", 0, len + 2, 0, th + 2)
        setp(tro, "Rotation", rot)
        setU2(tr, "Position", 0, mx, 0, my)
        setU2(tr, "Size", 0, len, 0, th)
        setp(tr, "Rotation", rot)
        setp(tr, "BackgroundColor3", T.Color)
    end

    function VisX.updateArrow(obj, plr, char, cam, rpos, dist)
        local A = VisCfg.Arrows
        local cont = obj.ArrowCont
        if not State.Arrows or dist > Settings.MaxDist then
            setp(cont, "Visible", false)
            return
        end
        local rel = cam.CFrame:PointToObjectSpace(rpos)
        local dx, dy = rel.X, -rel.Y
        local mag = math.sqrt(dx * dx + dy * dy)
        if mag < 1e-3 then dx, dy, mag = 0, 1, 1 end
        dx, dy = dx / mag, dy / mag
        local vs = cam.ViewportSize
        local radius = math.min(vs.X, vs.Y) * 0.5 * (A.Position / 100)
        local ax, ay = vs.X * 0.5 + dx * radius, vs.Y * 0.5 + dy * radius
        local size = A.Size
        setp(cont, "Visible", true)

        local ar = obj.Arrow
        setU2(ar, "Position", 0, ax, 0, ay)
        setU2(ar, "Size", 0, size, 0, size)
        setp(ar, "Rotation", math.deg(math.atan2(dy, dx)) + 90) -- la flecha base apunta hacia arriba
        setp(ar, VisX.ArrowAsset and "ImageColor3" or "TextColor3", A.Color)

        local gl = obj.ArrowGlow
        local showG = State.ArrowsGlow and true or false
        setp(gl, "Visible", showG)
        if showG then
            local PO, gTr = VisX.glow(math.max(size * 0.6, 6), A.GlowTransparency)
            setU2(gl, "Position", 0, ax, 0, ay)
            setU2(gl, "Size", 0, size + PO * 2, 0, size + PO * 2)
            setp(gl, "SliceScale", math.max(PO / 21, 0.1))
            setp(gl, "ImageColor3", A.GlowColor)
            setp(gl, "ImageTransparency", gTr)
        end

        -- texto (Name / Distance / Tool) PEGADO a la base de la flecha, por fuera (hacia el centro de la pantalla),
        -- en la direccion contraria a la que apunta, no simplemente "debajo" en pantalla
        local T = obj.ArrowTexts
        if obj.ArrowFontsVer ~= FontsVer then
            obj.ArrowFontsVer = FontsVer
            local F2 = VisCfg.Fonts
            applyFont(T[1], F2.Name)
            applyFont(T[2], F2.Distance)
            applyFont(T[3], F2.Gun)
        end
        local order = obj.ArrowOrder
        local n, bw = 0, 0
        local S = A.Show
        setp(T[1], "Visible", S.Name and true or false)
        if S.Name then
            n = n + 1; order[n] = T[1]
            setp(T[1], "Text", pname(plr))
            setp(T[1], "TextSize", VisCfg.Name.Size)
            setp(T[1], "TextColor3", VisCfg.Name.Color)
        end
        setp(T[2], "Visible", S.Distance and true or false)
        if S.Distance then
            n = n + 1; order[n] = T[2]
            setp(T[2], "Text", math.floor(dist) .. "st")
            setp(T[2], "TextSize", VisCfg.Distance.Size)
            setp(T[2], "TextColor3", VisCfg.Distance.Color)
        end
        setp(T[3], "Visible", S.Tool and true or false)
        if S.Tool then
            local tool = char and char:FindFirstChildOfClass("Tool")
            n = n + 1; order[n] = T[3]
            setp(T[3], "Text", tool and tool.Name or "none")
            setp(T[3], "TextSize", VisCfg.Gun.Size)
            setp(T[3], "TextColor3", VisCfg.Gun.Color)
        end
        if n > 0 then
            for k = 1, n do
                local w = order[k].TextBounds.X
                if w > bw then bw = w end
            end
            local lh = VisCfg.Name.Size + 1
            local H = n * lh
            local half = math.abs(dx) * bw * 0.5 + math.abs(dy) * H * 0.5 -- apoyo del rectangulo del texto en esa direccion
            local px, py = ax - dx * (size * 0.5 + 3 + half), ay - dy * (size * 0.5 + 3 + half)
            local top = py - H * 0.5
            for k = 1, n do
                setU2(order[k], "Position", 0, math.floor(px - 50 + 0.5), 0, math.floor(top + (k - 1) * lh + 0.5))
            end
        end
    end
end

local function updateESP(plr, obj, F)
    local cam = F.cam
    local c = obj.Container
    local char = plr.Character

    local hum = obj.Hum
    if not (hum and char and hum.Parent == char) then
        hum = char and char:FindFirstChildOfClass("Humanoid")
        obj.Hum = hum
    end
    local rootPart = obj.Root
    if not (rootPart and char and rootPart.Parent == char) then
        rootPart = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
            or char.PrimaryPart or char:FindFirstChildWhichIsA("BasePart"))
        obj.Root = rootPart
    end
    if not cam or not rootPart or (hum and hum.Health <= 0) then
        setp(c, "Visible", false)
        setp(obj.ArrowCont, "Visible", false)
        return
    end

    local rpos = rootPart.Position
    local rootPos, onScreen = cam:WorldToViewportPoint(rpos)
    local ddx, ddy, ddz = rpos.X - F.x, rpos.Y - F.y, rpos.Z - F.z
    local dist = math.sqrt(ddx * ddx + ddy * ddy + ddz * ddz)
    if not onScreen then
        setp(c, "Visible", false)
        VisX.updateArrow(obj, plr, char, cam, rpos, dist) -- fuera de pantalla -> flecha
        return
    end
    setp(obj.ArrowCont, "Visible", false)
    if dist > Settings.MaxDist then
        setp(c, "Visible", false)
        return
    end

    -- LOD: jugadores lejanos se actualizan cada 2 / 3 frames del ESP
    obj.Tick = (obj.Tick or 0) + 1
    local div = dist > 700 and 3 or (dist > 300 and 2 or 1)
    if div > 1 and obj.Tick % div ~= 0 and c.Visible then
        return
    end

    local method = VisCfg.Method
    local cx, cy, bw, bh
    if method == "Static" and hum then
        local isR6 = hum.RigType == Enum.HumanoidRigType.R6
        local topOff = isR6 and 2.8 or 3.0
        local botOff = isR6 and 3.0 or 3.5
        local top2D = cam:WorldToViewportPoint(rpos + Vector3.new(0, topOff, 0))
        local bot2D = cam:WorldToViewportPoint(rpos - Vector3.new(0, botOff, 0))
        local height = math.abs(top2D.Y - bot2D.Y)
        cx, cy, bw, bh = rootPos.X, (top2D.Y + bot2D.Y) / 2, height * 0.65, height
    else
        local minX, minY, maxX, maxY, parts
        if method == "Dynamic" and F.ok then
            minX, minY, maxX, maxY, parts = dynBoxFast(char, obj, F)
        end
        if not minX then
            minX, minY, maxX, maxY, parts = slowBox(cam, char, method)
        end
        if parts == 0 then
            setp(c, "Visible", false)
            return
        end
        if method == "Dynamic" then
            local tt = VisCfg.Box.Thickness
            cx, cy, bw, bh = (minX + maxX) / 2 - tt / 2, (minY + maxY) / 2 - tt / 2, (maxX - minX) + tt, (maxY - minY) + tt
        else
            cx, cy, bw, bh = (minX + maxX) / 2, (minY + maxY) / 2, maxX - minX, maxY - minY
        end
    end

    setp(c, "Visible", true)
    setp(c, "ZIndex", 10)

    local px, py = math.floor(cx), math.floor(cy)
    local sx, sy = math.floor(bw), math.floor(bh)
    local x, y = math.floor(px - sx / 2), math.floor(py - sy / 2)

    if obj.FontsVer ~= FontsVer then
        obj.FontsVer = FontsVer
        local F2 = VisCfg.Fonts
        applyFont(obj.Name, F2.Name)
        applyFont(obj.HpText, F2.Health)
        applyFont(obj.Dist, F2.Distance)
        applyFont(obj.Gun, F2.Gun)
    end

    local health, maxHealth, percent = 100, 100, 1
    if hum then
        health, maxHealth = hum.Health, hum.MaxHealth
        percent = maxHealth > 0 and math.clamp(health / maxHealth, 0, 1) or 0
    end

    local fill = obj.Fill
    local showFill = State.Box and State.Image
    setp(fill, "Visible", showFill)
    if showFill then
        setU2(fill, "Position", 0, x, 0, y)
        setU2(fill, "Size", 0, sx, 0, sy)
        setp(fill, "ImageColor3", VisCfg.Image.Color)
        setp(fill, "ImageTransparency", 1 - VisCfg.Image.Opacity)
        local img = VisCfg.CustomImage or IMAGE_ASSET
        if fill.Image ~= img then fill.Image = img end
    end

    local t, o = VisCfg.Box.Thickness, VisCfg.Box.OutlineThickness
    local L = obj.Lines
    setU2(L[1], "Position", 0, x, 0, y)
    setU2(L[1], "Size", 0, sx, 0, t)
    setU2(L[2], "Position", 0, x, 0, y + sy)
    setU2(L[2], "Size", 0, sx + t, 0, t)
    setU2(L[3], "Position", 0, x, 0, y)
    setU2(L[3], "Size", 0, t, 0, sy)
    setU2(L[4], "Position", 0, x + sx, 0, y)
    setU2(L[4], "Size", 0, t, 0, sy + t)

    local G = VisCfg.Glow
    local showGlow = State.Box and State.Glow -- el glow solo se ve si Box esta activo
    local PO, gTr = VisX.glow(G.Outer, G.Transparency)
    local PI = G.Inner
    local tw, th = sx + t, sy + t -- tamaño total del box (con las lineas)
    set4(LR[1], x, y, tw, t)
    set4(LR[2], x, y + sy, tw, t)
    set4(LR[3], x, y, t, th)
    set4(LR[4], x + sx, y, t, th)
    set4(OCR[1], x - PO, y - PO, tw + PO * 2, PO)
    set4(OCR[2], x - PO, y + th, tw + PO * 2, PO)
    set4(OCR[3], x - PO, y, PO, th)
    set4(OCR[4], x + tw, y, PO, th)
    local ix, iy, iw, ih = x + t, y + t, sx - t, sy - t -- interior del box (sin lineas)
    local inClip = obj.GlowInClip
    local showIn = showGlow and PI > 0 and iw > 0 and ih > 0
    setp(inClip, "Visible", showIn and true or false)
    if showIn then
        setU2(inClip, "Position", 0, ix, 0, iy)
        setU2(inClip, "Size", 0, iw, 0, ih)
    end
    local showOut = showGlow and PO > 0
    local boxOn = State.Box
    local boxCol, outCol = VisCfg.Box.Color, VisCfg.Box.OutlineColor
    for i = 1, 4 do
        local li = L[i]
        setp(li, "Visible", boxOn)
        setp(li, "BackgroundTransparency", 0)
        setp(li, "BackgroundColor3", boxCol)
        local r = LR[i]

        local oc, og = obj.GlowOutClips[i], obj.GlowOut[i]
        setp(oc, "Visible", showOut and true or false)
        if showOut then
            local cc = OCR[i]
            setU2(oc, "Position", 0, cc[1], 0, cc[2])
            setU2(oc, "Size", 0, cc[3], 0, cc[4])
            setU2(og, "Position", 0, r[1] - PO - cc[1], 0, r[2] - PO - cc[2])
            setU2(og, "Size", 0, r[3] + PO * 2, 0, r[4] + PO * 2)
            setp(og, "SliceScale", math.max(PO / 21, 0.1))
            setp(og, "ImageColor3", G.Color)
            setp(og, "ImageTransparency", gTr)
        end

        if showIn then
            local ig = obj.GlowIn[i]
            setU2(ig, "Position", 0, r[1] - PI - ix, 0, r[2] - PI - iy)
            setU2(ig, "Size", 0, r[3] + PI * 2, 0, r[4] + PI * 2)
            setp(ig, "SliceScale", math.max(PI / 21, 0.1))
            setp(ig, "ImageColor3", G.Color)
            setp(ig, "ImageTransparency", gTr)
        end
        local ol = obj.Outlines[i]
        setp(ol, "Visible", boxOn)
        setU2(ol, "Position", 0, -o, 0, -o)
        setU2(ol, "Size", 1, o * 2, 1, o * 2)
        setp(ol, "BackgroundColor3", outCol)
    end

    local nm = obj.Name
    setp(nm, "Visible", State.Name)
    if State.Name then
        setp(nm, "Text", pname(plr))
        setp(nm, "TextSize", VisCfg.Name.Size)
        setp(nm, "TextColor3", VisCfg.Name.Color)
        setU2(nm, "Position", 0, px - 50, 0, y - VisCfg.Name.Size - VisCfg.Name.Gap)
    end

    local belowY = y + sy + 3
    local dl = obj.Dist
    setp(dl, "Visible", State.Distance)
    if State.Distance then
        setp(dl, "Text", math.floor(dist) .. "st")
        setp(dl, "TextSize", VisCfg.Distance.Size)
        setp(dl, "TextColor3", VisCfg.Distance.Color)
        setU2(dl, "Position", 0, px - 50, 0, belowY)
        belowY = belowY + VisCfg.Distance.Size + 1
    end
    local gl = obj.Gun
    setp(gl, "Visible", State.Gun)
    if State.Gun then
        local tool = char:FindFirstChildOfClass("Tool")
        setp(gl, "Text", tool and tool.Name or "none")
        setp(gl, "TextSize", VisCfg.Gun.Size)
        setp(gl, "TextColor3", VisCfg.Gun.Color)
        setU2(gl, "Position", 0, px - 50, 0, belowY)
    end

    do
        local tx, ty = rootPos.X, rootPos.Y -- sin box: el tracer llega al personaje
        if State.Box then
            local o = VisCfg.Tracers.Origin
            if o == "Down" then tx, ty = px, y + sy -- origen abajo -> borde de abajo de la box
            elseif o == "Left" then tx, ty = x, py -- origen izquierda -> borde izquierdo
            elseif o == "Right" then tx, ty = x + sx, py -- origen derecha -> borde derecho
            else tx, ty = px, y end -- origen arriba -> borde de arriba
        end
        VisX.updateTracer(obj, cam, tx, ty)
    end
    VisX.updateHead(obj, char, cam)

    local hp = VisCfg.Health
    local showBar = State.Health and hum ~= nil
    local showVal = State.HealthValue and hum ~= nil
    local showHpGlow = showBar and State.HealthGlow
    setp(obj.HpOutline, "Visible", showBar and true or false)
    setp(obj.HpText, "Visible", showVal and true or false)
    setp(obj.HpGlow, "Visible", showHpGlow and true or false)
    if showBar or showVal then
        local w = hp.Width
        local gap = hp.SideGap + 1 -- separacion vacia entre el health bar y el box = 1px (sube el 1 para separarlo mas)
        local barHeight = math.floor((sy + 1) * percent)
        local outlineX = x - o - gap - w - 1

        if showBar then
            setp(obj.HpOutline, "BackgroundColor3", hp.OutlineColor)
            setU2(obj.HpOutline, "Size", 0, w + 2, 0, sy + 3)
            setU2(obj.HpOutline, "Position", 0, outlineX, 0, y - 1)
            setp(obj.HpBg, "BackgroundColor3", hp.BgColor)
            setU2(obj.HpBg, "Size", 0, w, 0, sy + 1)
            setU2(obj.HpContainer, "Size", 0, w, 0, barHeight)
            setU2(obj.HpContainer, "Position", 0, 1, 0, (sy + 1) - barHeight + 1)
            setU2(obj.HpBar, "Size", 0, w, 0, sy + 1)
            setU2(obj.HpBar, "Position", 0, 0, 0, -(sy + 1 - barHeight))

            if obj.HpVer ~= VisVersion then
                obj.HpVer = VisVersion
                obj.HpGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, hp.Color1),
                    ColorSequenceKeypoint.new(0.5, hp.Color2),
                    ColorSequenceKeypoint.new(1, hp.Color3),
                })
            end

            if showHpGlow then
                local HG = VisCfg.HpGlow
                local PO, gTr = VisX.glow(HG.Outer, HG.Transparency)
                setU2(obj.HpGlow, "Position", 0, outlineX - PO, 0, y - 1 - PO)
                setU2(obj.HpGlow, "Size", 0, w + 2 + PO * 2, 0, sy + 3 + PO * 2)
                setp(obj.HpGlow, "SliceScale", math.max(PO / 21, 0.1))
                setp(obj.HpGlow, "ImageColor3", HG.Color)
                setp(obj.HpGlow, "ImageTransparency", gTr)
            end
        end

        if showVal then
            local healthColor
            if percent > 0.5 then
                healthColor = hp.Color1:Lerp(hp.Color2, (1 - percent) * 2)
            else
                healthColor = hp.Color2:Lerp(hp.Color3, (0.5 - percent) * 2)
            end
            local txt = obj.HpText
            setp(txt, "Text", tostring(math.floor(health)))
            setp(txt, "TextSize", hp.TextSize)
            setp(txt, "TextColor3", healthColor)
            setp(txt, "TextXAlignment", Enum.TextXAlignment.Right)
            setU2(txt, "Size", 0, 0, 0, 0)
            setU2(txt, "Position", 0, outlineX - 2, 0, y + (sy + 1) - barHeight)
        end
    end
end

local function anyBoxVisualOn()
    return State.Enabled and (State.Name or State.Box or State.Health or State.Distance or State.Gun or State.Glow
        or State.HealthValue or State.HealthGlow or State.Arrows or State.ArrowsGlow or State.HeadDot or State.Tracers)
end

local function refresh()
    if not State.Self then destroyESP(LocalPlayer) end
    if not anyBoxVisualOn() then
        for plr in pairs(ESPObjs) do destroyESP(plr) end
    end
end

Players.PlayerRemoving:Connect(function(plr)
    destroyESP(plr)
end)

local espWarned = false
genv.pchaxx13_ESPConn = RunService.RenderStepped:Connect(function(dt)
    local boxes = anyBoxVisualOn()
    if not boxes then
        if next(ESPObjs) then
            for plr in pairs(ESPObjs) do destroyESP(plr) end
        end
        return
    end

    -- Refresh rate: cuantas veces por segundo se actualiza el ESP (si es >= tus fps, se actualiza cada frame)
    local interval = 1 / math.max(VisCfg.RefreshRate, 1)
    VisCfg.RefreshAcc = VisCfg.RefreshAcc + dt
    if VisCfg.RefreshAcc < interval * 0.9 then return end
    VisCfg.RefreshAcc = math.min(VisCfg.RefreshAcc - interval, interval)
    if VisCfg.RefreshAcc < 0 then VisCfg.RefreshAcc = 0 end

    local cam = workspace.CurrentCamera
    if not cam then return end
    local okF, errF = pcall(prepFrame, cam)
    if not okF then
        ESPF.ok = false
        ESPF.cam = cam
        if not espWarned then
            espWarned = true
            warn("[pchaxx13] Error en ESP (camara): " .. tostring(errF))
        end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer or State.Self then
            local obj = ESPObjs[plr]
            if not obj or not obj.Container.Parent then obj = createESP(plr) end
            local ok, err = pcall(updateESP, plr, obj, ESPF)
            if not ok and not espWarned then
                espWarned = true
                warn("[pchaxx13] Error en ESP: " .. tostring(err))
            end
        end
    end
end)

local Camera = workspace.CurrentCamera

local AimEngine = {}

local function frameAlpha(s, dt)

    if s <= 0 then return 1 end
    local tau = 0.004 + (s ^ 1.6) * 0.6
    return 1 - math.exp(-math.clamp(dt, 0, 0.1) / tau)
end

function AimEngine.track(plr, head, dt, st)
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart") or head
    local pos = root.Position
    if st.trackedPlayer ~= plr or not st.lastPos then
        st.trackedPlayer, st.lastPos, st.targetVel = plr, pos, Vector3.zero
        return
    end
    if dt > 0 then
        local raw = (pos - st.lastPos) / dt
        if raw.Magnitude > 300 then
            st.targetVel = Vector3.zero
        else
            st.targetVel = (st.targetVel or Vector3.zero):Lerp(raw, math.clamp(dt * 10, 0, 1))
        end
    end
    st.lastPos = pos
end

function AimEngine.getPoint(head, predH, predV, st)
    local vel = st.targetVel or Vector3.zero
    return head.Position + Vector3.new(vel.X * predH, vel.Y * predV, vel.Z * predH)
end

function AimEngine.aim(method, smooth, point, dt, st)
    Camera = workspace.CurrentCamera
    if not Camera then return end
    local cf = Camera.CFrame
    local camPos = cf.Position
    local to = point - camPos
    if to.Magnitude < 0.001 then return end
    local s = math.clamp(smooth, 0, 100) / 100
    local alpha = frameAlpha(s, dt)

    if method == "MouseRel" or method == "MouseAbs" then
        local pt, onScreen = Camera:WorldToViewportPoint(point)
        local canMove = (method == "MouseRel" and mousemoverel) or (method == "MouseAbs" and mousemoveabs)
        if onScreen and pt.Z > 0 and canMove then
            local m = UserInputService:GetMouseLocation()
            local d = Vector2.new(pt.X, pt.Y) - m
            local dx, dy = d.X * alpha + (st.rx or 0), d.Y * alpha + (st.ry or 0)
            local mx = dx >= 0 and math.floor(dx) or math.ceil(dx)
            local my = dy >= 0 and math.floor(dy) or math.ceil(dy)
            st.rx, st.ry = dx - mx, dy - my
            if mx ~= 0 or my ~= 0 then
                if method == "MouseRel" then
                    pcall(mousemoverel, mx, my)
                else
                    pcall(mousemoveabs, m.X + mx, m.Y + my)
                end
            end
            return
        end
        method = "Camera"
    end

    local target = CFrame.new(camPos, point)
    local dir = to.Unit
    local cur = cf.LookVector

    if s <= 0 then
        Camera.CFrame = target
    elseif method == "Camera" then
        Camera.CFrame = cf:Lerp(target, alpha)
    elseif method == "Linear" then
        local ang = math.acos(math.clamp(cur:Dot(dir), -1, 1))
        local speed = 35 - (35 - 0.6) * s
        local step = speed * math.clamp(dt, 0, 0.1)
        Camera.CFrame = (ang <= step) and target or cf:Lerp(target, step / ang)
    elseif method == "Adaptive" then
        local ang = math.acos(math.clamp(cur:Dot(dir), -1, 1))
        local a = math.clamp(alpha * (0.2 + ang * 2.5), 0, 1)
        Camera.CFrame = cf:Lerp(target, a)
    elseif method == "Spring" then
        local k = 900 - 860 * s
        local c = 2 * math.sqrt(k) * 0.9
        local v = st.vel or Vector3.zero
        local h = math.clamp(dt, 0, 0.05)
        v = v + ((dir - cur) * k - v * c) * h
        local nd = cur + v * h
        if nd.Magnitude < 0.001 then nd = dir end
        st.vel = v
        Camera.CFrame = CFrame.new(camPos, camPos + nd.Unit)
    else
        Camera.CFrame = target
    end
end

local LockAimState = { vel = Vector3.zero }

local LockedPlayer = nil
local deadNotified = false
local statusLabel
local setStatus

local UILib = nil
local NOTIF_TIME = 4

local function alert(kind, text)
    if not State.Notify or not UILib then return end
    pcall(function()
        if UILib.Alert then
            UILib:Alert(kind, text, NOTIF_TIME)
        else
            UILib:Notification(kind .. " (" .. tostring(text) .. ")", NOTIF_TIME, UILib.Theme.Accent)
        end
    end)
end

local function isTeammate(plr)
    return LocalPlayer.Team ~= nil and plr.Team == LocalPlayer.Team
end

local function itemIcon(it)
    if it:IsA("Tool") and it.TextureId ~= "" then return it.TextureId end
    for _, n in ipairs({ "Icon", "Image", "Texture", "TextureId", "Thumbnail" }) do
        local v = it:FindFirstChild(n)
        local val = (v and v:IsA("ValueBase")) and v.Value or it:GetAttribute(n)
        if val ~= nil and tostring(val) ~= "" then
            val = tostring(val)
            return tonumber(val) and ("rbxassetid://" .. val) or val
        end
    end
    return ""
end

local INVENTORY_PATH = "ReplicatedStorage.Players.%NAME%.Inventory"
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function findInventory(plr)
    local current = game
    for part in string.gmatch((INVENTORY_PATH:gsub("%%NAME%%", plr.Name)), "[^%.]+") do
        current = current and current:FindFirstChild(part)
    end
    return (current and current ~= game) and current or nil
end

-- indice nombre -> icono con las definiciones de items de ReplicatedStorage (se construye una vez, en segundo plano)
local IconIndex, IconIndexBuilding = nil, false
local function buildIconIndex()
    if IconIndex or IconIndexBuilding then return end
    IconIndexBuilding = true
    task.spawn(function()
        local idx, n = {}, 0
        local playersFolder = ReplicatedStorage:FindFirstChild("Players")
        pcall(function()
            for _, d in ipairs(ReplicatedStorage:GetDescendants()) do
                n = n + 1
                if n % 400 == 0 then task.wait() end
                if not idx[d.Name] and not d:IsA("ValueBase")
                    and not (playersFolder and d:IsDescendantOf(playersFolder)) then
                    local icon = itemIcon(d)
                    if icon ~= "" then idx[d.Name] = icon end
                end
            end
        end)
        IconIndex = idx
    end)
end

local COUNT_NAMES = { "Amount", "Count", "Quantity", "Stack", "Stacks" }
local PRICE_NAMES = { "Price", "Cost", "SellPrice", "Worth", "MoneyValue" }
local function readNumber(it, names)
    for _, n in ipairs(names) do
        local v = it:GetAttribute(n)
        if type(v) == "number" then return v end
        local c = it:FindFirstChild(n)
        if c and c:IsA("ValueBase") and type(c.Value) == "number" then return c.Value end
    end
    return nil
end

-- todo lo que tiene el jugador: inventario del juego (armadura, armas, items) + tools en mano/backpack
local function getInventoryData(plr)
    local list, names, total, hasPrice = {}, {}, 0, false
    local inv = findInventory(plr)
    if inv then
        for _, it in ipairs(inv:GetChildren()) do
            local icon = itemIcon(it)
            if icon == "" and IconIndex then icon = IconIndex[it.Name] or "" end
            local count = readNumber(it, COUNT_NAMES)
            if not count and (it:IsA("IntValue") or it:IsA("NumberValue")) then count = it.Value end
            local price = readNumber(it, PRICE_NAMES)
            if price then
                total = total + price * ((count and count > 0) and count or 1)
                hasPrice = true
            end
            list[#list + 1] = { Name = it.Name, Icon = icon, Count = count }
            names[it.Name] = true
        end
    end
    local function addTools(container)
        if not container then return end
        for _, it in ipairs(container:GetChildren()) do
            if it:IsA("Tool") and not names[it.Name] then
                names[it.Name] = true
                local icon = itemIcon(it)
                if icon == "" and IconIndex then icon = IconIndex[it.Name] or "" end
                list[#list + 1] = { Name = it.Name, Icon = icon }
            end
        end
    end
    addTools(plr.Character)
    addTools(plr:FindFirstChildOfClass("Backpack"))
    return list, hasPrice and total or nil, inv ~= nil
end

-- playtime en minutos: busca un valor tipo "PlayTime" del jugador; si no existe usa el tiempo en este server
local JoinTimes = {}
for _, p in ipairs(Players:GetPlayers()) do JoinTimes[p] = os.clock() end
Players.PlayerAdded:Connect(function(p) JoinTimes[p] = os.clock() end)

local PLAYTIME_PATTERNS = { "playtime", "play time", "timeplayed", "time played", "minutesplayed", "hoursplayed", "secondsplayed" }
local function isPlaytimeName(name)
    name = string.lower(name)
    for _, p in ipairs(PLAYTIME_PATTERNS) do
        if string.find(name, p, 1, true) then return true end
    end
    return false
end
local function toMinutes(name, v)
    name = string.lower(name)
    if string.find(name, "hour", 1, true) then return v * 60 end
    if string.find(name, "min", 1, true) then return v end
    return v / 60 -- por defecto se asume segundos
end

local PlaytimeCache = {}
local function getPlaytime(plr)
    local cached = PlaytimeCache[plr]
    if cached and os.clock() - cached.t < 5 then return cached.v, cached.session end

    local found
    pcall(function()
        local inv = findInventory(plr)
        local folder = inv and inv.Parent
        local function scan(root, skip)
            if not root then return end
            for k, v in pairs(root:GetAttributes()) do
                if type(v) == "number" and isPlaytimeName(k) then found = toMinutes(k, v) return end
            end
            for _, d in ipairs(root:GetDescendants()) do
                if d:IsA("ValueBase") and type(d.Value) == "number" and isPlaytimeName(d.Name)
                    and not (skip and d:IsDescendantOf(skip)) then
                    found = toMinutes(d.Name, d.Value)
                    return
                end
            end
        end
        for _, c in ipairs(plr:GetChildren()) do
            if c:IsA("ValueBase") and type(c.Value) == "number" and isPlaytimeName(c.Name) then
                found = toMinutes(c.Name, c.Value)
                break
            end
        end
        if not found then scan(plr:FindFirstChild("leaderstats")) end
        if not found then scan(folder, inv) end
        if not found then
            for k, v in pairs(plr:GetAttributes()) do
                if type(v) == "number" and isPlaytimeName(k) then found = toMinutes(k, v) break end
            end
        end
    end)

    local session = false
    if not found then
        found = (os.clock() - (JoinTimes[plr] or os.clock())) / 60
        session = true
    end
    PlaytimeCache[plr] = { v = found, session = session, t = os.clock() }
    return found, session
end

local TargetUI = { Indicator = nil, Inventory = nil }

local function refreshInventory()
    pcall(function()
        local plr = LockedPlayer
        if TargetUI.Inventory then
            if TargetUI.Inventory.SetPlayer then TargetUI.Inventory:SetPlayer(plr)
            elseif TargetUI.Inventory.SetTarget then TargetUI.Inventory:SetTarget(plr ~= nil) end
        end

        if not plr then
            if TargetUI.Inventory then TargetUI.Inventory:SetItems({}, nil) end
            if TargetUI.Indicator and TargetUI.Indicator.SetInfo then TargetUI.Indicator:SetInfo(nil) end
            return
        end

        buildIconIndex()
        local list, total, visible = getInventoryData(plr)
        local minutes, session = getPlaytime(plr)

        if TargetUI.Inventory then TargetUI.Inventory:SetItems(list, total) end
        if TargetUI.Indicator and TargetUI.Indicator.SetInfo then
            TargetUI.Indicator:SetInfo({
                Playtime = minutes, PlaytimeSession = session,
                Items = #list, Value = total, Visible = visible,
            })
        end
    end)
end

local function refreshTargetUI()
    if TargetUI.Indicator then
        pcall(function() TargetUI.Indicator:SetPlayer(LockedPlayer) end)
    end
    refreshInventory()
end

local function resetAim()
    LockAimState.vel = Vector3.zero
    LockAimState.targetVel = Vector3.zero
    LockAimState.trackedPlayer = nil
    LockAimState.lastPos = nil
    LockAimState.rx, LockAimState.ry = 0, 0
end

local function lockOnto(plr)
    resetAim()
    LockedPlayer = plr
    deadNotified = false
    alert("targetted", plr.Name)
    refreshTargetUI()
    setStatus()
end

local function unlock()
    if not LockedPlayer then return end
    local name = LockedPlayer.Name
    LockedPlayer = nil
    resetAim()
    alert("untargetted", name)
    refreshTargetUI()
    setStatus()
end

setStatus = function()
    if statusLabel then
        local text
        if not State.Aimlock then
            text = "Lock: disabled"
        elseif LockedPlayer then
            text = "Lock: " .. LockedPlayer.DisplayName
        else
            text = "Lock: ready (press your keybind)"
        end
        pcall(function() statusLabel:SetText(text) end)
    end
end

local function getHead(plr)
    local char = plr and plr.Character
    return char and char:FindFirstChild("Head")
end

local function getClosestToCursor()
    Camera = workspace.CurrentCamera
    local mouse = UserInputService:GetMouseLocation()
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and not (Settings.LockTeamCheck and isTeammate(plr)) then
            local char = plr.Character
            local head = getHead(plr)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local d = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    if d < bestDist then
                        best, bestDist = plr, d
                    end
                end
            end
        end
    end
    return best
end

local function lockNearest()
    local target = getClosestToCursor()
    if target then lockOnto(target) end
end

Players.PlayerRemoving:Connect(function(p)
    if p == LockedPlayer then unlock() end
end)

pcall(function() RunService:UnbindFromRenderStep("pchaxx13_Lock") end)
RunService:BindToRenderStep("pchaxx13_Lock", Enum.RenderPriority.Camera.Value + 1, function(dt)
    if not (State.Aimlock and LockedPlayer) then return end

    local char = LockedPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if hum.Health <= 0 then
            if not deadNotified then
                deadNotified = true
                alert("killed", LockedPlayer.Name)
            end
        else
            deadNotified = false
        end
    end
    local head = getHead(LockedPlayer)
    if not head then return end
    local predH = Settings.LockPredOn and Settings.LockPredH or 0
    local predV = Settings.LockPredOn and Settings.LockPredV or 0
    local smooth = Settings.LockSmoothOn and Settings.LockSmooth or 0
    AimEngine.track(LockedPlayer, head, dt, LockAimState)
    local point = AimEngine.getPoint(head, predH, predV, LockAimState)
    AimEngine.aim(Settings.LockAim, smooth, point, dt, LockAimState)
end)

local TRIGGER_DELAY = 0.12

local Clicker = {}
function Clicker.click()
    if mouse1click then
        if pcall(mouse1click) then return end
    end
    if mouse1press and mouse1release then
        pcall(function()
            mouse1press()
            task.wait(0.01)
            mouse1release()
        end)
    end

end
function Clicker.press()
    if mouse1press then
        return pcall(mouse1press)
    end
    return false
end
function Clicker.release()
    if mouse1release then pcall(mouse1release) end
end

local function newFire() return { target = nil, holding = false, last = 0 } end
local TrigFire, TestFire = newFire(), newFire()

local function stopFire(F)
    if F.holding then
        F.holding = false
        Clicker.release()
    end
    F.target = nil
end

local function isAlive(plr)
    local char = plr and plr.Parent and plr.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    return hum ~= nil and hum.Health > 0
end

local function driveFire(F, method)
    if not F.target then return end
    if method == "Hold" and mouse1press then
        if not F.holding then
            if Clicker.press() then F.holding = true end
        end
    else
        local now = os.clock()
        if now - F.last >= TRIGGER_DELAY then
            F.last = now
            task.spawn(Clicker.click)
        end
    end
end

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function playerUnderCursor(maxDist, teamCheck)
    Camera = workspace.CurrentCamera
    if not Camera then return nil end
    local mouse = UserInputService:GetMouseLocation()
    local ray = Camera:ViewportPointToRay(mouse.X, mouse.Y)
    local ignore = {}
    if LocalPlayer.Character then ignore[1] = LocalPlayer.Character end
    rayParams.FilterDescendantsInstances = ignore
    local result = workspace:Raycast(ray.Origin, ray.Direction * (maxDist or 1000), rayParams)
    if not result then return nil end
    local model = result.Instance:FindFirstAncestorOfClass("Model")
    local plr = model and Players:GetPlayerFromCharacter(model)
    if plr and plr ~= LocalPlayer and isAlive(plr) then
        if teamCheck and isTeammate(plr) then return nil end
        return plr
    end
    return nil
end

RunService.Heartbeat:Connect(function()
    if not State.Trigger then
        if TrigFire.target or TrigFire.holding then stopFire(TrigFire) end
        return
    end
    if UserInputService:GetFocusedTextBox() then return end

    if TrigFire.target and not isAlive(TrigFire.target) then stopFire(TrigFire) end
    if not TrigFire.target then
        local p = playerUnderCursor()
        if p then TrigFire.target = p end
    end
    driveFire(TrigFire, Settings.TriggerMethod)
end)

RunService.Heartbeat:Connect(function()
    if not State.Test then
        if TestFire.target or TestFire.holding then stopFire(TestFire) end
        return
    end
    if UserInputService:GetFocusedTextBox() then return end
    local dist = Settings.TestInfinite and 10000 or Settings.TestMaxDist
    local plr = playerUnderCursor(dist, Settings.TestTeamCheck)
    if plr then
        TestFire.target = plr
        driveFire(TestFire, Settings.TestMethod)
    elseif TestFire.target or TestFire.holding then
        stopFire(TestFire)
    end
end)

local Lighting = game:GetService("Lighting")
local SKY_FACES = { "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp" }

local function skyAll(asset)
    return { asset, asset, asset, asset, asset, asset }
end

local function skySet(bk, dn, ft, lf, rt, up)
    local ids = { bk, dn, ft, lf, rt, up }
    for i, id in ipairs(ids) do ids[i] = "rbxassetid://" .. id end
    return ids
end

local SKYBOXES = {
    ["Roblox Default"] = {
        "rbxasset://textures/sky/sky512_bk.tex", "rbxasset://textures/sky/sky512_dn.tex",
        "rbxasset://textures/sky/sky512_ft.tex", "rbxasset://textures/sky/sky512_lf.tex",
        "rbxasset://textures/sky/sky512_rt.tex", "rbxasset://textures/sky/sky512_up.tex",
    },
    ["Morning"] = skySet(6444884337, 6444884785, 6444884337, 6444884337, 6444884337, 6412503613),
    ["Evening"] = skySet(16136021536, 16136025360, 16136021536, 16136021536, 16136021536, 16136023362),
    ["Night"] = skySet(15536110634, 15536112543, 15536116141, 15536114370, 15536118762, 15536117282),
    ["Rain"] = skyAll("rbxassetid://10258337305"),
    ["c00lkidd"] = skyAll("rbxassetid://358313209"),
    ["Custom 1"] = skySet(2570432999, 2570433005, 2570432998, 2570433000, 2570432997, 2570432996),
    ["Custom 2"] = skySet(225469345, 225469349, 225469359, 225469364, 225469372, 225469380),
    ["Custom 3"] = skyAll("rbxassetid://10799413050"),
}
local SKY_ITEMS = { "Roblox Default", "Morning", "Evening", "Night", "Rain", "c00lkidd", "Custom 1", "Custom 2", "Custom 3" }

if IMAGE_ASSET ~= "" then
    SKYBOXES["PCMate"] = skyAll(IMAGE_ASSET)
    table.insert(SKY_ITEMS, 1, "PCMate")
end

local TECH_ITEMS = { "Compatibility", "Voxel", "ShadowMap", "Future" }

local WORLD_GROUPS = {
    Time = { "ClockTime" },
    Ambient = { "Ambient", "OutdoorAmbient" },
}

for _, sky in ipairs(genv.pchaxx13_SkyStash or {}) do
    pcall(function() sky.Parent = Lighting end)
end
genv.pchaxx13_SkyStash = {}
for _, atmo in ipairs(genv.pchaxx13_AtmoStash or {}) do
    pcall(function() atmo.Parent = Lighting end)
end
genv.pchaxx13_AtmoStash = {}

local noFog = Lighting.FogEnd > 3000

local World = {
    On = {},
    Orig = {},
    AtmoOrig = {},
    Stash = genv.pchaxx13_SkyStash,
    AtmoStash = genv.pchaxx13_AtmoStash,
    Val = {
        Brightness = 0,
        ClockTime = Lighting.ClockTime,
        FogStart = noFog and 0 or Lighting.FogStart,
        FogEnd = noFog and 400 or Lighting.FogEnd,
        FogColor = noFog and Color3.fromRGB(190, 190, 200) or Lighting.FogColor,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Saturation = 0,
        Contrast = 0,
        Tint = WHITE,
        Tech = "ShadowMap",
        Sky = SKY_ITEMS[1],
    },
}

pcall(function()
    World.Val.Tech = Lighting.Technology.Name
end)
if not table.find(TECH_ITEMS, World.Val.Tech) then World.Val.Tech = "ShadowMap" end

if genv.pchaxx13_WorldConn then
    pcall(function() genv.pchaxx13_WorldConn:Disconnect() end)
    genv.pchaxx13_WorldConn = nil
end
for _, name in ipairs({ "pchaxx13_CC", "pchaxx13_Sky" }) do
    local old = Lighting:FindFirstChild(name)
    if old then old:Destroy() end
end

local ColorFx = Instance.new("ColorCorrectionEffect")
ColorFx.Name = "pchaxx13_CC"
ColorFx.Enabled = false
ColorFx.Parent = Lighting

local WorldSky = nil

local function setTech(name)
    local enum = Enum.Technology[name]
    if sethiddenproperty then
        sethiddenproperty(Lighting, "Technology", enum)
    else
        Lighting.Technology = enum
    end
end

local ATMO_PROPS = { "Density", "Offset", "Color", "Decay" }

local function restoreAtmospheres()
    for _, atmo in ipairs(World.AtmoStash) do
        pcall(function() atmo.Parent = Lighting end)
    end
    table.clear(World.AtmoStash)
end

function World.clearSky()
    if WorldSky then
        WorldSky:Destroy()
        WorldSky = nil
    end
    for _, sky in ipairs(World.Stash) do
        pcall(function() sky.Parent = Lighting end)
    end
    table.clear(World.Stash)
end

function World.applySky()
    World.clearSky()
    if not World.On.Sky then return end
    local faces = SKYBOXES[World.Val.Sky]
    if not faces then error("skybox desconocida: " .. tostring(World.Val.Sky)) end
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Sky") then
            World.Stash[#World.Stash + 1] = child
            child.Parent = nil
        end
    end
    WorldSky = Instance.new("Sky")
    WorldSky.Name = "pchaxx13_Sky"
    WorldSky.CelestialBodiesShown = false
    for i, prop in ipairs(SKY_FACES) do
        WorldSky[prop] = faces[i]
    end
    WorldSky.Parent = Lighting
end

function World.set(name, on)
    if World.On[name] == on then return end
    World.On[name] = on
    local props = WORLD_GROUPS[name]
    if props then
        for _, p in ipairs(props) do
            if on then
                World.Orig[p] = Lighting[p]
            elseif World.Orig[p] ~= nil then
                Lighting[p] = World.Orig[p]
            end
        end
    elseif name == "Fog" then
        if on then
            World.Orig.FogStart, World.Orig.FogEnd, World.Orig.FogColor = Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor
        else
            if World.Orig.FogEnd ~= nil then
                Lighting.FogStart, Lighting.FogEnd, Lighting.FogColor = World.Orig.FogStart, World.Orig.FogEnd, World.Orig.FogColor
            end
            restoreAtmospheres()
        end
    elseif name == "Tech" then
        if on then
            local ok, cur = pcall(function() return Lighting.Technology.Name end)
            World.Orig.Tech = ok and cur or nil
            setTech(World.Val.Tech)
        elseif World.Orig.Tech then
            setTech(World.Orig.Tech)
        end
    elseif name == "Sky" then
        World.applySky()
    end
end

local lastSkyCheck = 0
genv.pchaxx13_WorldConn = RunService.RenderStepped:Connect(function()
    local on, val = World.On, World.Val

    for name, props in pairs(WORLD_GROUPS) do
        if on[name] then
            for _, p in ipairs(props) do
                if Lighting[p] ~= val[p] then Lighting[p] = val[p] end
            end
        end
    end

    if on.Fog then
        local fe = val.FogEnd
        local fs = math.min(val.FogStart, math.max(fe - 1, 0))
        if Lighting.FogStart ~= fs then Lighting.FogStart = fs end
        if Lighting.FogEnd ~= fe then Lighting.FogEnd = fe end
        if Lighting.FogColor ~= val.FogColor then Lighting.FogColor = val.FogColor end
        -- Con un Atmosphere en Lighting, Roblox ignora FogColor. Los quitamos mientras el fog este activo.
        for _, atmo in ipairs(Lighting:GetChildren()) do
            if atmo:IsA("Atmosphere") then
                World.AtmoStash[#World.AtmoStash + 1] = atmo
                atmo.Parent = nil
            end
        end
    end

    local anyFx = on.Brightness or on.Saturation or on.Contrast or on.Tint
    if ColorFx.Parent ~= Lighting then ColorFx.Parent = Lighting end
    if ColorFx.Enabled ~= (anyFx == true) then ColorFx.Enabled = anyFx == true end
    if anyFx then
        ColorFx.Brightness = on.Brightness and val.Brightness or 0
        ColorFx.Saturation = on.Saturation and val.Saturation or 0
        ColorFx.Contrast = on.Contrast and val.Contrast or 0
        ColorFx.TintColor = on.Tint and val.Tint or WHITE
    end

    if on.Sky and WorldSky and os.clock() - lastSkyCheck > 0.5 then
        lastSkyCheck = os.clock()
        if WorldSky.Parent ~= Lighting then WorldSky.Parent = Lighting end
        for _, child in ipairs(Lighting:GetChildren()) do
            if child:IsA("Sky") and child ~= WorldSky then
                World.Stash[#World.Stash + 1] = child
                child.Parent = nil
            end
        end
    end
end)


-- =====================================================================
-- CROSSHAIR
-- =====================================================================
local CROSSHAIR_FONTS = {
    "Proggy Clean", "Smallest Pixel-7", "Tahoma", "Pixel Arial", "Arial", "Zekton",
}

local Crosshair = {
    Cfg = {
        Enabled = false,
        Color1 = WHITE, Color2 = WHITE,           -- degradado desde el centro hacia afuera
        Gap = 4, Length = 10, Thickness = 2,
        Rotation = 0,
        Spin = false, SpinSpeed = 0.3,            -- vueltas por segundo
        Resize = false, ResizeSpeed = 1, Max = 20, Min = 10,
        Outline = true, OutlineColor1 = BLACK, OutlineColor2 = BLACK, OutlineThickness = 1,
        Smoothness = 0.1,
        StickTarget = false, StickBarrel = false,
        Position = "Center",                      -- "Center" | "Mouse"
        Transparency = 0,
        Dot = false, DotSize = 3,
        Text = { On = false, Value = "pchaxx13", Font = "Proggy Clean", Size = 12, Color = WHITE, Offset = 6 },
    },
    Angle = 0,
    Ver = 1,
    AppliedVer = 0,
    FontDirty = true,
    FontsVer = -1,
}

do
    if genv.pchaxx13_CrossConn then
        pcall(function() genv.pchaxx13_CrossConn:Disconnect() end)
        genv.pchaxx13_CrossConn = nil
    end
    pcall(function()
        local old = guiParent:FindFirstChild("pchaxx13_Crosshair")
        if old then old:Destroy() end
    end)

    local gui = Instance.new("ScreenGui")
    gui.Name = "pchaxx13_Crosshair"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    gui.Enabled = false
    do
        local okP = pcall(function() gui.Parent = guiParent end)
        if not okP then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    end

    local SIZE = 400
    local C = SIZE / 2

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.BackgroundTransparency = 1
    root.BorderSizePixel = 0
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.Position = UDim2.new(0.5, 0, 0.5, 0)
    root.Size = UDim2.new(0, SIZE, 0, SIZE)
    root.Parent = gui

    -- rotacion del degradado para que el color 1 quede en el centro y el color 2 en la punta
    local GRAD_ROT = { Top = 270, Bottom = 90, Left = 180, Right = 0, Dot = 0 }

    local function mk(z)
        local f = Instance.new("Frame")
        f.BorderSizePixel = 0
        f.BackgroundColor3 = WHITE
        f.ZIndex = z
        f.Parent = root
        local g = Instance.new("UIGradient")
        g.Parent = f
        return f, g
    end

    local parts = {}
    for _, name in ipairs({ "Top", "Bottom", "Left", "Right", "Dot" }) do
        local ol, olg = mk(1)
        local ln, lng = mk(2)
        olg.Rotation = GRAD_ROT[name]
        lng.Rotation = GRAD_ROT[name]
        parts[name] = { Outline = ol, Line = ln, OutlineGrad = olg, LineGrad = lng }
    end

    local label = Instance.new("TextLabel")
    label.Name = "Text"
    label.BackgroundTransparency = 1
    label.AnchorPoint = Vector2.new(0.5, 0)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.ZIndex = 3
    label.Visible = false
    label.Parent = gui
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = BLACK
    stroke.LineJoinMode = Enum.LineJoinMode.Miter
    stroke.Parent = label

    local function place(p, x, y, w, h, outline, ot, alpha)
        x, y, w, h = math.floor(x), math.floor(y), math.floor(w), math.floor(h)
        p.Line.Position = UDim2.new(0, x, 0, y)
        p.Line.Size = UDim2.new(0, w, 0, h)
        p.Line.BackgroundTransparency = alpha
        p.Line.Visible = true
        p.Outline.Visible = outline
        if outline then
            p.Outline.Position = UDim2.new(0, x - ot, 0, y - ot)
            p.Outline.Size = UDim2.new(0, w + ot * 2, 0, h + ot * 2)
            p.Outline.BackgroundTransparency = alpha
        end
    end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude

    -- Stick Barrel: hacia donde apunta el arma que tienes equipada (punto de pantalla), o nil
    local function barrelPoint(cam)
        local char = LocalPlayer.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if not tool then return nil end
        local part = tool:FindFirstChild("Barrel") or tool:FindFirstChild("Muzzle") or tool:FindFirstChild("Handle")
        if not (part and part:IsA("BasePart")) then return nil end
        local origin = part.Position
        local dir = part.CFrame.LookVector * 1000
        rayParams.FilterDescendantsInstances = { char }
        local hit = workspace:Raycast(origin, dir, rayParams)
        local world = hit and hit.Position or (origin + dir)
        local v, on = cam:WorldToViewportPoint(world)
        if on and v.Z > 0 then return v.X, v.Y end
        return nil
    end

    genv.pchaxx13_CrossConn = RunService.RenderStepped:Connect(function(dt)
        local cfg = Crosshair.Cfg
        if not cfg.Enabled then
            gui.Enabled = false
            Crosshair.PX = nil
            return
        end
        gui.Enabled = true

        -- colores (solo cuando cambian)
        if Crosshair.AppliedVer ~= Crosshair.Ver then
            Crosshair.AppliedVer = Crosshair.Ver
            local lineSeq = ColorSequence.new(cfg.Color1, cfg.Color2)
            local outSeq = ColorSequence.new(cfg.OutlineColor1, cfg.OutlineColor2)
            for name, p in pairs(parts) do
                if name == "Dot" then
                    p.LineGrad.Color = ColorSequence.new(cfg.Color1, cfg.Color1)
                else
                    p.LineGrad.Color = lineSeq
                end
                p.OutlineGrad.Color = outSeq
            end
            label.TextColor3 = cfg.Text.Color
        end

        -- posicion: Stick Target > Stick Barrel > Mouse/Center, con Smoothness
        local cam = workspace.CurrentCamera
        local tx, ty
        if cam then
            if cfg.StickTarget and LockedPlayer then
                local head = getHead(LockedPlayer)
                if head then
                    local v, on = cam:WorldToViewportPoint(head.Position)
                    if on and v.Z > 0 then tx, ty = v.X, v.Y end
                end
            end
            if not tx and cfg.StickBarrel then
                tx, ty = barrelPoint(cam)
            end
            if not tx then
                if cfg.Position == "Mouse" then
                    local m = UserInputService:GetMouseLocation()
                    tx, ty = m.X, m.Y
                else
                    local vp = cam.ViewportSize
                    tx, ty = vp.X / 2, vp.Y / 2
                end
            end
        else
            tx, ty = 0, 0
        end
        if not Crosshair.PX or cfg.Smoothness <= 0.01 then
            Crosshair.PX, Crosshair.PY = tx, ty
        else
            local alpha = 1 - math.exp(-dt * 30 / cfg.Smoothness)
            Crosshair.PX = Crosshair.PX + (tx - Crosshair.PX) * alpha
            Crosshair.PY = Crosshair.PY + (ty - Crosshair.PY) * alpha
        end
        root.Position = UDim2.new(0, math.floor(Crosshair.PX + 0.5), 0, math.floor(Crosshair.PY + 0.5))

        -- rotacion fija + spin
        if cfg.Spin then
            Crosshair.Angle = (Crosshair.Angle + cfg.SpinSpeed * 360 * dt) % 360
        else
            Crosshair.Angle = 0
        end
        root.Rotation = (cfg.Rotation + Crosshair.Angle) % 360

        -- tamaño (Resize: oscila entre Min y Max)
        local length = cfg.Length
        if cfg.Resize then
            local lo, hi = math.min(cfg.Min, cfg.Max), math.max(cfg.Min, cfg.Max)
            local k = 0.5 + 0.5 * math.sin(os.clock() * cfg.ResizeSpeed * math.pi)
            length = lo + (hi - lo) * k
        end
        local len = math.max(1, math.floor(length))
        local t = math.max(1, math.floor(cfg.Thickness))
        local gap = math.floor(cfg.Gap)
        local ol, ot, a = cfg.Outline, math.max(1, math.floor(cfg.OutlineThickness)), cfg.Transparency
        local half = math.floor(t / 2)

        place(parts.Top,    C - half,        C - gap - len, t,   len, ol, ot, a)
        place(parts.Bottom, C - half,        C + gap,       t,   len, ol, ot, a)
        place(parts.Left,   C - gap - len,   C - half,      len, t,   ol, ot, a)
        place(parts.Right,  C + gap,         C - half,      len, t,   ol, ot, a)

        if cfg.Dot then
            local d = math.max(1, math.floor(cfg.DotSize))
            place(parts.Dot, C - math.floor(d / 2), C - math.floor(d / 2), d, d, ol, ot, a)
        else
            parts.Dot.Line.Visible = false
            parts.Dot.Outline.Visible = false
        end

        local tx2 = cfg.Text
        label.Visible = tx2.On and tx2.Value ~= ""
        if label.Visible then
            if Crosshair.FontDirty or Crosshair.FontsVer ~= FontsVer then
                Crosshair.FontDirty = false
                Crosshair.FontsVer = FontsVer
                applyFont(label, tx2.Font)
            end
            label.Text = tx2.Value
            label.TextSize = tx2.Size
            label.TextColor3 = tx2.Color
            label.Size = UDim2.new(0, 400, 0, math.floor(tx2.Size) + 4)
            label.Position = UDim2.new(0, math.floor(Crosshair.PX + 0.5), 0, math.floor(Crosshair.PY + 0.5) + gap + len + tx2.Offset)
        end
    end)
end

-- ESP PREVIEW (mini UI con el mismo estilo que el Player indicator)
local function buildPreview(Library)
    pcall(function()
        local old = guiParent:FindFirstChild("pchaxx13_ESPPreview")
        if old then old:Destroy() end
    end)
    if genv.pchaxx13_PreviewConns then
        for _, cn in ipairs(genv.pchaxx13_PreviewConns) do pcall(function() cn:Disconnect() end) end
    end
    genv.pchaxx13_PreviewConns = {}

    local P = { On = false, FontsVer = -1, HpVer = -1 }
    local PW, PH, TOP = 170, 210, 25
    local SX, SY, BX, BY = 78, 120, 46, 22
    local C = {
        Background = Color3.fromRGB(16, 16, 16),
        Stage = Color3.fromRGB(12, 12, 12),
        Inline = Color3.fromRGB(23, 23, 23),
        Outline = Color3.fromRGB(60, 60, 60),
        Border = Color3.fromRGB(10, 10, 10),
    }

    local function accent()
        local ok, c = pcall(function() return Library.Theme.Accent end)
        return (ok and typeof(c) == "Color3") and c or Color3.fromRGB(176, 176, 209)
    end
    -- La libreria usa ZIndexBehavior Global: se sube el ZIndex de todo el contenido para que quede encima del fondo del panel
    local ZOFF = 52
    local function mk(class, props, parent)
        local o = Instance.new(class)
        for k, v in pairs(props) do o[k] = v end
        if o:IsA("GuiObject") then o.ZIndex = (props.ZIndex or 1) + ZOFF end
        o.Parent = parent
        return o
    end
    local function strokes(parent)
        mk("UIStroke", { Color = C.Outline, LineJoinMode = Enum.LineJoinMode.Miter, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, parent)
        local s2 = mk("UIStroke", { Color = C.Border, LineJoinMode = Enum.LineJoinMode.Miter, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, parent)
        pcall(function() s2.BorderOffset = UDim.new(0, 1) end)
    end

    -- etiquetas del preview (las crea el ESP con ZIndex 2): se suben igual que el resto del contenido
    local function previewLabel(parent)
        local l = newLabel(parent)
        l.ZIndex = l.ZIndex + ZOFF
        return l
    end

    -- Ventana del preview: la crea la libreria (mismo estilo y mismo drag suave que el resto de la UI)
    local libObj = Library.EspPreview and Library:EspPreview(PW, PH - TOP)
    if not libObj then
        warn("[pchaxx13] La libreria es vieja: sube el library.lua nuevo para ver el ESP Preview")
        return { SetVisible = function() end }
    end
    local stage = libObj.Stage

    local _unusedGui = Instance.new("ScreenGui")
    _unusedGui:Destroy()

    local cont = mk("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0) }, stage)

    -- ============================================================
    -- DUMMY (personaje real en un ViewportFrame, no dibujado)
    -- Clic derecho sobre el -> UI para poner un emote id / link y bailar
    -- ============================================================
    local viewport = mk("ViewportFrame", {
        Name = "DummyViewport", BackgroundTransparency = 1, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0), ZIndex = -20,
        Ambient = Color3.fromRGB(170, 170, 170), LightColor = Color3.fromRGB(140, 140, 140),
        LightDirection = Vector3.new(0.3, -0.6, 1),
    }, stage)
    local vpCam = mk("Camera", { FieldOfView = 30 }, viewport)
    viewport.CurrentCamera = vpCam

    local Dummy = { Model = nil, Animator = nil, Track = nil, Conn = nil, Building = false, Req = 0, Name = nil, Display = nil, Ext = nil, Loading = false }
    local DEFAULT_USER = "pcmateee"

    local STAGE_W, STAGE_H = PW, PH - TOP

    -- Mide el personaje (relativo al root) y encuadra la camara para que la caja Static lo RODEE siempre:
    -- la caja crece si el avatar es mas alto/ancho que el R15 normal (antes la camara se alejaba y el personaje quedaba mas grande que la caja).
    local function frameDummy(model)
        local hrp = model:FindFirstChild("HumanoidRootPart")
        local rootY, cx, cz = 0, 0, 0
        if hrp then rootY, cx, cz = hrp.Position.Y, hrp.Position.X, hrp.Position.Z end
        local top, bottom, half
        for _, part in ipairs(model:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Transparency < 0.95 then
                local hy = part.Size.Y / 2
                if part.Name == "Head" then
                    local sm = part:FindFirstChildOfClass("SpecialMesh")
                    if sm and sm.MeshType == Enum.MeshType.Head then hy = hy * sm.Scale.Y end
                end
                local t, b = part.Position.Y + hy, part.Position.Y - hy
                local hw = math.abs(part.Position.X - cx) + part.Size.X / 2
                top = top and math.max(top, t) or t
                bottom = bottom and math.min(bottom, b) or b
                half = half and math.max(half, hw) or hw
            end
        end
        if not top then
            local cf, size = model:GetBoundingBox()
            top, bottom, half = cf.Position.Y + size.Y / 2, cf.Position.Y - size.Y / 2, size.X / 2
            if not hrp then rootY = cf.Position.Y end
        end
        local MARGIN = 0.3
        local topOff = math.max(3.0, (top - rootY) + MARGIN)
        local botOff = math.max(3.5, (rootY - bottom) + MARGIN)
        Dummy.Ext = { Top = topOff, Bot = botOff, Half = half + MARGIN }

        local H = topOff + botOff
        local fov = 30
        local f = (STAGE_H / 2) / math.tan(math.rad(fov / 2))
        local d = f * H / SY -- distancia para que H studs midan SY pixeles en el plano del root
        local pxPerStud = SY / H
        local boxCenterY = rootY + (topOff - botOff) / 2
        local dy = (BY + SY / 2) - STAGE_H / 2
        local target = Vector3.new(cx, boxCenterY + dy / pxPerStud, cz)
        local front = hrp and hrp.CFrame.LookVector or Vector3.new(0, 0, -1)
        vpCam.FieldOfView = fov
        vpCam.CFrame = CFrame.lookAt(target + front * d, target)
    end

    -- proyeccion manual a pixeles del stage (WorldToViewportPoint usaria la camara del juego)
    local function proj(pos)
        local o = vpCam.CFrame:PointToObjectSpace(pos)
        local depth = -o.Z
        if depth < 0.05 then return nil end
        local f = (STAGE_H / 2) / math.tan(math.rad(vpCam.FieldOfView / 2))
        return STAGE_W / 2 + o.X / depth * f, STAGE_H / 2 - o.Y / depth * f
    end

    -- Devuelve x, y, ancho, alto de la caja en pixeles del stage.
    -- Static: fija alrededor del root (no sigue las extremidades). Dynamic: se ajusta a todas las partes visibles en cada frame.
    local function computeBox(dynamic)
        local m = Dummy.Model
        if not m then return BX, BY, SX, SY end
        if dynamic then
            local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
            local n = 0
            for _, part in ipairs(m:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Transparency < 0.95 then
                    local cf, hs = part.CFrame, part.Size / 2
                    if part.Name == "Head" then
                        -- la malla de la cabeza clasica es mas alta que la Part (escala 1.25)
                        local sm = part:FindFirstChildOfClass("SpecialMesh")
                        if sm and sm.MeshType == Enum.MeshType.Head then hs = Vector3.new(hs.X, hs.Y * sm.Scale.Y, hs.Z) end
                    end
                    for sxn = -1, 1, 2 do
                        for syn = -1, 1, 2 do
                            for szn = -1, 1, 2 do
                                local px, py = proj(cf * Vector3.new(hs.X * sxn, hs.Y * syn, hs.Z * szn))
                                if px then
                                    n = n + 1
                                    if px < minX then minX = px end
                                    if px > maxX then maxX = px end
                                    if py < minY then minY = py end
                                    if py > maxY then maxY = py end
                                end
                            end
                        end
                    end
                end
            end
            if n > 0 then
                -- linea izquierda/superior ocupan [x, x+t]: se corren t hacia afuera para que quede TODO por fuera del cuerpo
                local t = VisCfg.Box.Thickness
                return minX - t, minY - t, (maxX - minX) + t, (maxY - minY) + t
            end
        end
        local hrp = m:FindFirstChild("HumanoidRootPart")
        if hrp then
            local rp = hrp.Position
            local ext = Dummy.Ext or { Top = 3, Bot = 3.5, Half = 0 }
            local rx = proj(rp)
            local _, ty = proj(rp + Vector3.new(0, ext.Top, 0))
            local _, by = proj(rp - Vector3.new(0, ext.Bot, 0))
            if rx and ty and by then
                local h = math.abs(ty - by)
                local w = math.max(h * 0.65, 2 * ext.Half * h / (ext.Top + ext.Bot))
                return rx - w / 2, math.min(ty, by), w, h
            end
        end
        return BX, BY, SX, SY
    end

    local function cleanModel(model)
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("LuaSourceContainer") or d:IsA("Tool") or d:IsA("ForceField")
                or d:IsA("BillboardGui") or d:IsA("Sound") then
                pcall(function() d:Destroy() end)
            end
        end
        local hum = model:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                hum.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            end)
            if not hum:FindFirstChildOfClass("Animator") then
                Instance.new("Animator", hum)
            end
        end
        local hrp = model:FindFirstChild("HumanoidRootPart")
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("BasePart") then d.Anchored = true end
        end
        model.Name = "pchaxx13_Dummy"
    end

    -- ---- Rig propio: desactiva las uniones y calcula las posiciones de las partes a mano ----
    local function buildRig(model)
        local root = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
        local joints = {}
        for _, j in ipairs(model:GetDescendants()) do
            if j:IsA("JointInstance") and j.Part0 and j.Part1 then joints[#joints + 1] = j end
        end
        local known = { [root] = true }
        local order, byName = {}, {}
        local remaining = joints
        local progress = true
        while progress do
            progress = false
            local nextRem = {}
            for _, j in ipairs(remaining) do
                local k0, k1 = known[j.Part0], known[j.Part1]
                if k0 and not k1 then
                    known[j.Part1] = true
                    local e = { P0 = j.Part0, P1 = j.Part1, C0 = j.C0, C1 = j.C1, Fwd = true, T = CFrame.new(), Motor = j:IsA("Motor6D") }
                    order[#order + 1] = e
                    if e.Motor then byName[j.Part1.Name] = e end
                    progress = true
                elseif k1 and not k0 then
                    known[j.Part0] = true
                    order[#order + 1] = { P0 = j.Part0, P1 = j.Part1, C0 = j.C0, C1 = j.C1, Fwd = false, T = CFrame.new(), Motor = false }
                    progress = true
                elseif not (k0 and k1) then
                    nextRem[#nextRem + 1] = j
                end
            end
            remaining = nextRem
        end
        for _, j in ipairs(joints) do pcall(function() j.Enabled = false end) end
        return { Order = order, ByName = byName }
    end

    local function applyRig(rig)
        for _, e in ipairs(rig.Order) do
            if e.Fwd then
                e.P1.CFrame = e.P0.CFrame * e.C0 * e.T * e.C1:Inverse()
            else
                e.P0.CFrame = e.P1.CFrame * e.C1 * e.C0:Inverse()
            end
        end
    end

    local function resetPose()
        local rig = Dummy.Rig
        if not rig then return end
        for _, e in ipairs(rig.Order) do e.T = CFrame.new() end
        applyRig(rig)
    end

    -- Dummy estilo Roblox Studio: gris, sin ropa ni accesorios, con la cara sonriente por defecto
    local DUMMY_COLOR = Color3.fromRGB(163, 162, 165)
    local DUMMY_FACE = "rbxasset://textures/face.png"
    -- Cabeza clasica (Part 2x1x1 + SpecialMesh Head): es donde la cara por defecto se mapea bien
    local function classicHead(model)
        local old = model:FindFirstChild("Head")
        if not old then return end
        local new = Instance.new("Part")
        new.Name = "Head"
        new.Size = Vector3.new(2, 1, 1)
        new.CFrame = old.CFrame
        new.Anchored = true
        new.CanCollide = false
        new.TopSurface = Enum.SurfaceType.Smooth
        new.BottomSurface = Enum.SurfaceType.Smooth
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Head
        mesh.Scale = Vector3.new(1.25, 1.25, 1.25)
        mesh.Parent = new
        new.Parent = model
        -- el motor Neck (y los attachments) viven DENTRO de la cabeza vieja: hay que pasarlos a la nueva antes de destruirla
        for _, c in ipairs(old:GetChildren()) do
            if c:IsA("Attachment") or c:IsA("JointInstance") then c.Parent = new end
        end
        for _, j in ipairs(model:GetDescendants()) do
            if j:IsA("JointInstance") then
                if j.Part0 == old then j.Part0 = new end
                if j.Part1 == old then j.Part1 = new end
            end
        end
        pcall(function() old:Destroy() end)
    end

    local function styleDummy(model)
        pcall(classicHead, model)
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("Accessory") or d:IsA("Shirt") or d:IsA("Pants") or d:IsA("ShirtGraphic")
                or d:IsA("CharacterMesh") or d:IsA("BodyColors") or d:IsA("SurfaceAppearance") then
                pcall(function() d:Destroy() end)
            end
        end
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
                d.Color = DUMMY_COLOR
                d.Material = Enum.Material.Plastic
                if d:IsA("MeshPart") then pcall(function() d.TextureID = "" end) end
            end
        end
        local head = model:FindFirstChild("Head")
        if head then
            local face
            for _, c in ipairs(head:GetChildren()) do
                if c:IsA("Decal") or c:IsA("Texture") then
                    if face == nil and c:IsA("Decal") then face = c else pcall(function() c:Destroy() end) end
                end
            end
            if not face then
                face = Instance.new("Decal")
                face.Name = "face"
                face.Face = Enum.NormalId.Front
                face.Parent = head
            end
            face.Face = Enum.NormalId.Front
            face.Texture = DUMMY_FACE
            face.Transparency = 0
            face.Color3 = Color3.fromRGB(255, 255, 255)
        end
    end

    local function buildDummy()
        if Dummy.Model or Dummy.Building then return end
        Dummy.Building = true
        task.spawn(function()
            local model
            -- 1) dummy R15 por defecto (proporciones normales, estilo blocky) desde un HumanoidDescription vacio
            do
                local ok, m = pcall(function()
                    local desc = Instance.new("HumanoidDescription")
                    pcall(function()
                        desc.HeightScale, desc.WidthScale, desc.DepthScale, desc.HeadScale = 1, 1, 1, 1
                        desc.BodyTypeScale, desc.ProportionScale = 0, 0
                    end)
                    return Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
                end)
                if ok and m then model = m end
            end
            -- 2) fallback: clon de tu personaje si es R15 (luego se recolorea igual)
            if not model then
                local char = LocalPlayer.Character
                if char then
                    local prev = char.Archivable
                    pcall(function() char.Archivable = true end)
                    local ok, c = pcall(function() return char:Clone() end)
                    pcall(function() char.Archivable = prev end)
                    if ok and c then
                        local hum = c:FindFirstChildOfClass("Humanoid")
                        if hum and hum.RigType == Enum.HumanoidRigType.R15 then
                            model = c
                        else
                            pcall(function() c:Destroy() end)
                        end
                    end
                end
            end
            -- 3) fallback: avatar R15 desde tu userId
            if not model then
                local ok, m = pcall(function()
                    local desc = Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)
                    return Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
                end)
                if ok and m then model = m end
            end
            Dummy.Building = false
            if not model then return end
            cleanModel(model)
            styleDummy(model)
            model:PivotTo(CFrame.new(0, 0, 0))
            model.Parent = viewport
            Dummy.Model = model
            Dummy.Animator = model:FindFirstChildWhichIsA("Animator", true)
            local okRig, rig = pcall(buildRig, model)
            if okRig then Dummy.Rig = rig end
            resetPose() -- pose neutra (el clon podia traer la pose de carrera/salto de ese instante)
            frameDummy(model)
        end)
    end

    -- "bailar" = reproducir en bucle la animacion del id/link dado
    local function parseId(text)
        text = tostring(text or "")
        local pats = {
            "catalog/(%d+)", "store/asset/(%d+)", "library/(%d+)", "bundles/(%d+)",
            "[?&]id=(%d+)", "rbxassetid://(%d+)", "(%d%d+)",
        }
        for _, p in ipairs(pats) do
            local m = text:match(p)
            if m then return m end
        end
        return nil
    end

    -- Resuelve un id (emote de la tienda o animacion) -> animId real y/o KeyframeSequence
    local function resolveAnimation(id)
        local animId, ks
        local ok, objs = pcall(function() return game:GetObjects("rbxassetid://" .. id) end)
        if ok and type(objs) == "table" then
            for _, o in ipairs(objs) do
                if o:IsA("KeyframeSequence") then ks = ks or o end
                if o:IsA("Animation") and o.AnimationId ~= "" then animId = animId or o.AnimationId end
                local a = o:FindFirstChildWhichIsA("Animation", true)
                if a and a.AnimationId ~= "" then animId = animId or a.AnimationId end
                local k = o:FindFirstChildWhichIsA("KeyframeSequence", true)
                if k then ks = ks or k end
            end
        end
        if not animId and not ks then animId = "rbxassetid://" .. id end
        return animId, ks
    end

    local function getKeyframes(animId)
        local id = tostring(animId):match("%d+")
        if not id then return nil end
        local ks
        pcall(function()
            ks = game:GetService("KeyframeSequenceProvider"):GetKeyframeSequenceAsync("rbxassetid://" .. id)
        end)
        if ks then return ks end
        local ok, objs = pcall(function() return game:GetObjects("rbxassetid://" .. id) end)
        if ok and type(objs) == "table" then
            for _, o in ipairs(objs) do
                if o:IsA("KeyframeSequence") then return o end
                local k = o:FindFirstChildWhichIsA("KeyframeSequence", true)
                if k then return k end
            end
        end
        return nil
    end

    -- Reproduccion manual de keyframes sobre los Motor6D (no depende del Animator del ViewportFrame)
    local function flattenPose(pose, out)
        out[pose.Name] = pose.CFrame
        for _, c in ipairs(pose:GetChildren()) do
            if c:IsA("Pose") then flattenPose(c, out) end
        end
    end

    local function prepareFrames(ks)
        local frames = {}
        for _, kf in ipairs(ks:GetChildren()) do
            if kf:IsA("Keyframe") then
                local poses = {}
                for _, p in ipairs(kf:GetChildren()) do
                    if p:IsA("Pose") then flattenPose(p, poses) end
                end
                frames[#frames + 1] = { t = kf.Time, poses = poses }
            end
        end
        table.sort(frames, function(a, b) return a.t < b.t end)
        return frames
    end

    local function stopDance()
        Dummy.Req = Dummy.Req + 1
        if Dummy.Conn then pcall(function() Dummy.Conn:Disconnect() end) Dummy.Conn = nil end
        if Dummy.Track then
            pcall(function() Dummy.Track:Stop(0.2) end)
            pcall(function() Dummy.Track:Destroy() end)
            Dummy.Track = nil
        end
        resetPose()
    end

    local function playManual(ks)
        local rig = Dummy.Rig
        if not rig then return false end
        local frames = prepareFrames(ks)
        if #frames == 0 then return false end
        local len = frames[#frames].t
        if len <= 0 then len = 0.01 end
        if Dummy.Conn then pcall(function() Dummy.Conn:Disconnect() end) Dummy.Conn = nil end
        local clock = 0
        Dummy.Conn = RunService.RenderStepped:Connect(function(dt)
            clock = clock + dt
            local t = clock % len
            local a, b = frames[1], frames[1]
            local wrap = false
            for i = 1, #frames do
                if frames[i].t <= t then
                    a = frames[i]
                    b = frames[i + 1]
                    if not b then b = frames[1]; wrap = true end
                end
            end
            local span = wrap and (len - a.t) or (b.t - a.t)
            local alpha = span > 1e-4 and math.clamp((t - a.t) / span, 0, 1) or 0
            for name, cf in pairs(a.poses) do
                local e = rig.ByName[name]
                if e then
                    e.T = cf:Lerp(b.poses[name] or cf, alpha)
                end
            end
            applyRig(rig)
        end)
        return true, #frames, len
    end

    local function tryTrack(animId)
        if not Dummy.Animator then return nil end
        local anim = Instance.new("Animation")
        anim.AnimationId = animId
        local ok, track = pcall(function() return Dummy.Animator:LoadAnimation(anim) end)
        if not ok or not track then return nil end
        local t0 = os.clock()
        while track.Length == 0 and os.clock() - t0 < 2 do task.wait(0.1) end
        if track.Length == 0 then
            pcall(function() track:Destroy() end)
            return nil
        end
        return track
    end

    local function playDance(input, setStatus)
        local id = parseId(input)
        if not id then setStatus("id invalido") return end
        if not Dummy.Model then buildDummy() end
        local t0 = os.clock()
        while not Dummy.Model and os.clock() - t0 < 8 do task.wait(0.1) end
        if not Dummy.Model then setStatus("dummy no listo") return end
        stopDance()
        local req = Dummy.Req
        setStatus("cargando...")
        local animId, ks = resolveAnimation(id)
        if not ks and animId then ks = getKeyframes(animId) end
        if req ~= Dummy.Req then return end
        if ks then
            local okM, n, len = playManual(ks)
            if okM then
                setStatus(string.format("bailando %dkf %.1fs", n, len))
                return
            end
        end
        -- ultimo recurso: pista normal del Animator
        local track = animId and tryTrack(animId)
        if req ~= Dummy.Req then if track then pcall(function() track:Destroy() end) end return end
        if not track then setStatus("no se pudo cargar") return end
        track.Looped = true
        pcall(function() track.Priority = Enum.AnimationPriority.Action4 end)
        track:Play(0.2)
        Dummy.Track = track
        setStatus("bailando")
    end

    -- ---- cargar el personaje de otro jugador en el dummy (user id / link de perfil / nombre de usuario) ----
    local function parseUserId(text)
        text = (tostring(text or ""):gsub("^%s+", ""))
        text = (text:gsub("%s+$", ""))
        local id = text:match("users/(%d+)") or text:match("[?&][uU]ser[iI]d=(%d+)") or text:match("^(%d+)$")
        if id then return tonumber(id) end
        -- nombre de usuario suelto
        if #text >= 3 and text:match("^[%w_]+$") then
            local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(text) end)
            if ok and uid then return uid end
        end
        return nil
    end

    -- reemplaza el modelo del dummy (para avatares reales no se aplica el estilo gris de Studio)
    local function installModel(model, styled)
        cleanModel(model)
        if styled then styleDummy(model) end
        model:PivotTo(CFrame.new(0, 0, 0))
        stopDance()
        if Dummy.Model then pcall(function() Dummy.Model:Destroy() end) end
        Dummy.Model, Dummy.Animator, Dummy.Rig = nil, nil, nil
        model.Parent = viewport
        Dummy.Model = model
        Dummy.Animator = model:FindFirstChildWhichIsA("Animator", true)
        local okRig, rig = pcall(buildRig, model)
        if okRig then Dummy.Rig = rig end
        resetPose()
        frameDummy(model)
    end

    local function loadCharacter(input, setStatus)
        setStatus("buscando...")
        local id = parseUserId(input)
        if not id then setStatus("user id / link invalido") return false end
        Dummy.LoadReq = (Dummy.LoadReq or 0) + 1
        local req = Dummy.LoadReq
        setStatus("cargando " .. id .. "...")
        local t0 = os.clock()
        while Dummy.Building and os.clock() - t0 < 8 do task.wait(0.1) end
        local ok, model = pcall(function()
            local desc = Players:GetHumanoidDescriptionFromUserId(id)
            return Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
        end)
        if req ~= Dummy.LoadReq then
            if ok and model then pcall(function() model:Destroy() end) end
            return false
        end
        if not ok or not model then setStatus("no se pudo cargar") return false end
        -- username (y display name) del usuario cargado
        local okN, uname = pcall(function() return Players:GetNameFromUserIdAsync(id) end)
        if not okN or type(uname) ~= "string" or uname == "" then
            local typed = tostring(input or ""):match("^%s*([%w_]+)%s*$")
            uname = (typed and not typed:match("^%d+$")) and typed or tostring(id)
        end
        local display
        pcall(function()
            local info = game:GetService("UserService"):GetUserInfosByUserIdsAsync({ id })
            display = info and info[1] and info[1].DisplayName
        end)
        if req ~= Dummy.LoadReq then
            pcall(function() model:Destroy() end)
            return false
        end
        installModel(model, false)
        Dummy.Name = uname
        Dummy.Display = (type(display) == "string" and display ~= "") and display or uname
        setStatus("cargado: " .. uname)
        return true
    end

    local function resetDummy(setStatus)
        Dummy.LoadReq = (Dummy.LoadReq or 0) + 1
        stopDance()
        if Dummy.Model then pcall(function() Dummy.Model:Destroy() end) end
        Dummy.Model, Dummy.Animator, Dummy.Rig = nil, nil, nil
        Dummy.Name, Dummy.Display = nil, nil
        buildDummy()
        setStatus("dummy por defecto")
    end

    -- zona de clic derecho (sobre el personaje) -> mini ventana de la libreria (mismo estilo y animacion que el colorpicker)
    local hit = mk("TextButton", {
        Name = "DummyHit", BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
        Position = UDim2.new(0, BX - 12, 0, BY - 6), Size = UDim2.new(0, SX + 24, 0, SY + 12), ZIndex = 10,
    }, stage)

    local Pop = Library.CreatePopup and Library:CreatePopup({ Title = "Dummy", Width = 176 })
    local statusLabel
    local function setStatus(t) if statusLabel then statusLabel.Text = t end end
    local function closePopup() if Pop then Pop:SetOpen(false) end end

    if Pop then
        Pop:AddLabel("Emote id / link")
        local emoteBox = Pop:AddTextbox("id o link de la tienda", function(text)
            task.spawn(playDance, text, setStatus)
        end)
        Pop:AddButtons({
            { "Bailar", function() task.spawn(playDance, emoteBox:Get(), setStatus) end },
            { "Parar", function() stopDance(); setStatus("parado") end },
        })
        Pop:AddSeparator()
        Pop:AddLabel("Character (user id / link)")
        local charBox = Pop:AddTextbox("user id, link de perfil o usuario", function(text)
            task.spawn(loadCharacter, text, setStatus)
        end)
        Pop:AddButtons({
            { "Cargar", function() task.spawn(loadCharacter, charBox:Get(), setStatus) end },
            { "Reset", function() resetDummy(setStatus) end },
        })
        statusLabel = Pop:AddLabel("")
    else
        warn("[pchaxx13] La libreria es vieja: sube el library.lua nuevo para el menu del dummy")
    end

    hit.MouseButton2Click:Connect(function()
        if Pop then Pop:Open() end
    end)

    local fill = mk("ImageLabel", {
        BackgroundTransparency = 1, BorderSizePixel = 0, ScaleType = Enum.ScaleType.Stretch,
        Image = IMAGE_ASSET, ZIndex = -2, Visible = false,
    }, cont)

    local L, OL = {}, {}
    for i = 1, 4 do
        L[i], OL[i] = newLine(cont)
        -- mismo offset que el resto del preview: viewport < fill < glow < outline < linea < textos
        OL[i].ZIndex = ZOFF
        L[i].ZIndex = ZOFF + 1
    end

    local function mkGlow(parent)
        return mk("ImageLabel", {
            BackgroundTransparency = 1, BorderSizePixel = 0, Image = "http://www.roblox.com/asset/?id=18245826428",
            ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79)),
            ImageColor3 = VisCfg.Glow.Color, ImageTransparency = VisCfg.Glow.Transparency, ZIndex = -1,
        }, parent)
    end
    local GC, GL = {}, {}
    for i = 1, 4 do
        GC[i] = mk("Frame", { BackgroundTransparency = 1, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = -1, Visible = false }, cont)
        GL[i] = mkGlow(GC[i])
    end

    local nameT = previewLabel(cont)
    nameT.TextYAlignment = Enum.TextYAlignment.Bottom
    local distT = previewLabel(cont)
    distT.TextYAlignment = Enum.TextYAlignment.Top
    local gunT = previewLabel(cont)
    gunT.TextYAlignment = Enum.TextYAlignment.Top

    local hpOutline = mk("Frame", { BackgroundColor3 = VisCfg.Health.OutlineColor, BorderSizePixel = 0, ZIndex = 1 }, cont)
    local hpBg = mk("Frame", { BackgroundColor3 = VisCfg.Health.BgColor, BorderSizePixel = 0, ZIndex = 1, Position = UDim2.new(0, 1, 0, 1) }, hpOutline)
    local hpGlow = mkGlow(cont)
    hpGlow.Visible = false
    local hpContainer = mk("Frame", { BackgroundTransparency = 1, ClipsDescendants = true, BorderSizePixel = 0, ZIndex = 2 }, hpOutline)
    local hpBar = mk("Frame", { BackgroundColor3 = WHITE, BorderSizePixel = 0, ZIndex = 2 }, hpContainer)
    local hpGrad = mk("UIGradient", { Rotation = 90 }, hpBar)
    local hpText = previewLabel(cont)
    hpText.TextYAlignment = Enum.TextYAlignment.Center
    hpText.ZIndex = 3 + ZOFF

    -- head dot (hexagono) sobre la cabeza del dummy
    local hexL = {}
    for i = 1, 6 do
        hexL[i] = mk("Frame", {
            BorderSizePixel = 0, BackgroundColor3 = VisCfg.HeadDot.Color, AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 2, Visible = false,
        }, cont)
        mk("UIStroke", { Thickness = 1, Color = BLACK }, hexL[i])
    end

    -- nombre del preview: el del usuario cargado (o "Dummy" si no hay nadie cargado)
    local function previewName()
        if not Dummy.Model then return Dummy.Loading and "..." or "Dummy" end
        if Dummy.Name then return (State.UseDisplay and Dummy.Display) or Dummy.Name end
        return "Dummy"
    end

    local function step()
        -- el lienzo se centra con offsets ENTEROS (con AnchorPoint 0.5 caia en medio pixel y la caja/outline se veian borrosos)
        local par = stage.Parent
        if par and par:IsA("GuiObject") then
            local ps = par.AbsoluteSize
            local ox, oy = math.floor((ps.X - STAGE_W) / 2), math.floor((ps.Y - STAGE_H) / 2)
            if not P.Snapped or P.SnapX ~= ox or P.SnapY ~= oy then
                P.Snapped, P.SnapX, P.SnapY = true, ox, oy
                stage.AnchorPoint = Vector2.new(0, 0)
                stage.Position = UDim2.fromOffset(ox, oy)
            end
        end
        local now = os.clock()
        local ac = accent()

        if P.FontsVer ~= FontsVer then
            P.FontsVer = FontsVer
            local F2 = VisCfg.Fonts
            applyFont(nameT, F2.Name)
            applyFont(hpText, F2.Health)
            applyFont(distT, F2.Distance)
            applyFont(gunT, F2.Gun)
        end

        local percent = 0.525 + 0.475 * math.sin(now * 2.4)
        local health = math.floor(percent * 100 + 0.5)

        local bx0, by0, bw0, bh0 = computeBox(VisCfg.Method == "Dynamic")
        local sx, sy = math.floor(bw0), math.floor(bh0)
        local x, y = math.floor(bx0), math.floor(by0)
        local px = x + sx / 2
        local t, o = VisCfg.Box.Thickness, VisCfg.Box.OutlineThickness
        local boxOn = State.Box and true or false

        local showFill = State.Box and State.Image
        setp(fill, "Visible", showFill and true or false)
        if showFill then
            setU2(fill, "Position", 0, x, 0, y)
            setU2(fill, "Size", 0, sx, 0, sy)
            setp(fill, "ImageColor3", VisCfg.Image.Color)
            setp(fill, "ImageTransparency", 1 - VisCfg.Image.Opacity)
            local img = VisCfg.CustomImage or IMAGE_ASSET
            if fill.Image ~= img then fill.Image = img end
        end

        setU2(L[1], "Position", 0, x, 0, y)
        setU2(L[1], "Size", 0, sx, 0, t)
        setU2(L[2], "Position", 0, x, 0, y + sy)
        setU2(L[2], "Size", 0, sx + t, 0, t)
        setU2(L[3], "Position", 0, x, 0, y)
        setU2(L[3], "Size", 0, t, 0, sy)
        setU2(L[4], "Position", 0, x + sx, 0, y)
        setU2(L[4], "Size", 0, t, 0, sy + t)
        for i = 1, 4 do
            setp(L[i], "Visible", boxOn)
            setp(L[i], "BackgroundColor3", VisCfg.Box.Color)
            setp(OL[i], "Visible", boxOn)
            setU2(OL[i], "Position", 0, -o, 0, -o)
            setU2(OL[i], "Size", 1, o * 2, 1, o * 2)
            setp(OL[i], "BackgroundColor3", VisCfg.Box.OutlineColor)
        end

        local G = VisCfg.Glow
        local PO, gTr = VisX.glow(G.Outer, G.Transparency)
        local showOut = State.Box and State.Glow and PO > 0
        local tw, th = sx + t, sy + t
        local LR = {
            { x, y, tw, t }, { x, y + sy, tw, t }, { x, y, t, th }, { x + sx, y, t, th },
        }
        local OCR = {
            { x - PO, y - PO, tw + PO * 2, PO }, { x - PO, y + th, tw + PO * 2, PO },
            { x - PO, y, PO, th }, { x + tw, y, PO, th },
        }
        for i = 1, 4 do
            setp(GC[i], "Visible", showOut and true or false)
            if showOut then
                local cc, r = OCR[i], LR[i]
                setU2(GC[i], "Position", 0, cc[1], 0, cc[2])
                setU2(GC[i], "Size", 0, cc[3], 0, cc[4])
                setU2(GL[i], "Position", 0, r[1] - PO - cc[1], 0, r[2] - PO - cc[2])
                setU2(GL[i], "Size", 0, r[3] + PO * 2, 0, r[4] + PO * 2)
                setp(GL[i], "SliceScale", math.max(PO / 21, 0.1))
                setp(GL[i], "ImageColor3", G.Color)
                setp(GL[i], "ImageTransparency", gTr)
            end
        end

        setp(nameT, "Visible", State.Name and true or false)
        if State.Name then
            setp(nameT, "Text", previewName())
            setp(nameT, "TextSize", VisCfg.Name.Size - 1)
            setp(nameT, "TextColor3", VisCfg.Name.Color)
            setU2(nameT, "Position", 0, px - 50, 0, y - VisCfg.Name.Size - VisCfg.Name.Gap)
        end

        local belowY = y + sy + 3
        setp(distT, "Visible", State.Distance and true or false)
        if State.Distance then
            setp(distT, "Text", "0st")
            setp(distT, "TextSize", VisCfg.Distance.Size - 1)
            setp(distT, "TextColor3", VisCfg.Distance.Color)
            setU2(distT, "Position", 0, px - 50, 0, belowY)
            belowY = belowY + VisCfg.Distance.Size
        end
        setp(gunT, "Visible", State.Gun and true or false)
        if State.Gun then
            setp(gunT, "Text", "None")
            setp(gunT, "TextSize", VisCfg.Gun.Size - 1)
            setp(gunT, "TextColor3", VisCfg.Gun.Color)
            setU2(gunT, "Position", 0, px - 50, 0, belowY)
        end

        local hp = VisCfg.Health
        local showBar = State.Health and true or false
        local showVal = State.HealthValue and true or false
        local showHpGlow = showBar and State.HealthGlow and true or false
        setp(hpOutline, "Visible", showBar)
        setp(hpText, "Visible", showVal)
        setp(hpGlow, "Visible", showHpGlow)
        if showBar or showVal then
            local w = hp.Width
            local gap = hp.SideGap + 1
            local barHeight = math.floor((sy + 1) * percent)
            local outlineX = x - o - gap - w - 1
            if showBar then
                setp(hpOutline, "BackgroundColor3", hp.OutlineColor)
                setU2(hpOutline, "Size", 0, w + 2, 0, sy + 3)
                setU2(hpOutline, "Position", 0, outlineX, 0, y - 1)
                setp(hpBg, "BackgroundColor3", hp.BgColor)
                setU2(hpBg, "Size", 0, w, 0, sy + 1)
                setU2(hpContainer, "Size", 0, w, 0, barHeight)
                setU2(hpContainer, "Position", 0, 1, 0, (sy + 1) - barHeight + 1)
                setU2(hpBar, "Size", 0, w, 0, sy + 1)
                setU2(hpBar, "Position", 0, 0, 0, -(sy + 1 - barHeight))
                if P.HpVer ~= VisVersion then
                    P.HpVer = VisVersion
                    hpGrad.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, hp.Color1),
                        ColorSequenceKeypoint.new(0.5, hp.Color2),
                        ColorSequenceKeypoint.new(1, hp.Color3),
                    })
                end
                if showHpGlow then
                    local HG = VisCfg.HpGlow
                    local PO, gTr = VisX.glow(HG.Outer, HG.Transparency)
                    setU2(hpGlow, "Position", 0, outlineX - PO, 0, y - 1 - PO)
                    setU2(hpGlow, "Size", 0, w + 2 + PO * 2, 0, sy + 3 + PO * 2)
                    setp(hpGlow, "SliceScale", math.max(PO / 21, 0.1))
                    setp(hpGlow, "ImageColor3", HG.Color)
                    setp(hpGlow, "ImageTransparency", gTr)
                end
            end
            if showVal then
                local healthColor
                if percent > 0.5 then
                    healthColor = hp.Color1:Lerp(hp.Color2, (1 - percent) * 2)
                else
                    healthColor = hp.Color2:Lerp(hp.Color3, (0.5 - percent) * 2)
                end
                setp(hpText, "Text", tostring(health))
                setp(hpText, "TextSize", hp.TextSize - 1)
                setp(hpText, "TextColor3", healthColor)
                setp(hpText, "TextXAlignment", Enum.TextXAlignment.Right)
                setU2(hpText, "Size", 0, 0, 0, 0)
                setU2(hpText, "Position", 0, outlineX - 2, 0, y + (sy + 1) - barHeight)
            end
        end

        -- head dot sobre la cabeza del dummy
        local dm = Dummy.Model
        local headPart = dm and dm:FindFirstChild("Head")
        local drewHex = false
        if State.HeadDot and headPart then
            local hx, hy = proj(headPart.Position)
            local _, y1 = proj(headPart.Position + Vector3.new(0, 0.5, 0))
            local _, y2 = proj(headPart.Position - Vector3.new(0, 0.5, 0))
            if hx and y1 and y2 then
                local hsz = headPart.Size
                local hw = math.min(hsz.X, 1.3 * math.max(hsz.Y, hsz.Z))
                VisX.placeHex(hexL, hx, hy, math.max(hw * math.abs(y1 - y2) * 0.635, 3), VisCfg.HeadDot.Color)
                drewHex = true
            end
        end
        if not drewHex then
            for i = 1, 6 do setp(hexL[i], "Visible", false) end
        end
    end

    local cn = genv.pchaxx13_PreviewConns
    cn[#cn + 1] = RunService.RenderStepped:Connect(function()
        if P.On then pcall(step) end
    end)

    -- siempre arranca con pcmateee cargado; si no se puede cargar, queda el Dummy por defecto
    local function ensureCharacter()
        if P.Started or Dummy.Model or Dummy.Building then return end
        P.Started = true
        Dummy.Loading = true
        task.spawn(function()
            local ok = loadCharacter(DEFAULT_USER, setStatus)
            Dummy.Loading = false
            if not ok and not Dummy.Model and not Dummy.Building then
                Dummy.Name, Dummy.Display = nil, nil
                buildDummy()
                setStatus("dummy por defecto")
            end
        end)
    end

    function P:SetVisible(v)
        self.On = v and true or false
        if self.On then ensureCharacter() else closePopup() end
    end
    libObj.OnVisibility = function(v) P:SetVisible(v) end
    return P
end

local PANDORA_URL = Loader.LibURL
local LIB_ICON = "rbxassetid://10793494685"

local AIM_MAP = {
    ["Camera"] = "Camera",
    ["Linear"] = "Linear",
    ["Spring"] = "Spring",
    ["Adaptive"] = "Adaptive",
    ["Mouse Rel"] = "MouseRel",
    ["Mouse Abs"] = "MouseAbs",
}
local AIM_ITEMS = { "Camera", "Linear", "Spring", "Adaptive", "Mouse Rel", "Mouse Abs" }
local FIRE_ITEMS = { "Click", "Hold" }

-- =====================================================================
-- INVENTORY VIEWER (propio): mismo estilo que el Player indicator
-- (Section real, colores del tema y fuente de la UI; el titulo usa la fuente de titulos)
-- Solo icono centrado; si no hay icono, el nombre en el centro. Nada de mayusculas.
-- =====================================================================
local function buildInventoryViewer(Library)
    local CELL, GAP = 72, 5
    local GRID_PAD = 3   -- margen dentro de la grilla: sin esto el scroll recorta el borde de las celdas de los extremos
    local TITLE_PAD = 6  -- espacio a cada lado del titulo "Info" (entre el texto y la linea)
    local MAX_COLS, MAX_ROWS = 4, 4
    local MIN_WIDTH = 300
    local ICON = 52
    local EXTRA_W = 46 -- padding del panel (16) + margenes internos de la Section (30)

    -- Zekton se ve mas pequeño: la libreria le suma 1 a todo el texto
    local function fs(n) return (Library.UIFontName == "Zekton") and (n + 1) or n end

    local function make(class, props, theme)
        local o = Instance.new(class)
        o.Name = "\0"
        if o:IsA("GuiObject") then o.BorderSizePixel = 0 end
        local parent = props.Parent
        props.Parent = nil
        for k, v in pairs(props) do o[k] = v end
        o.Parent = parent
        if theme then Library:AddToTheme(o, theme) end
        return o
    end

    local function label(parent, text, size, xalign)
        local props = {
            Parent = parent, TextColor3 = Library.Theme["Text"], Text = text, TextSize = fs(size),
            BackgroundTransparency = 1,
            TextXAlignment = xalign or Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }
        if Library.MenuFont then props.FontFace = Library.MenuFont end
        return make("TextLabel", props, { TextColor3 = "Text" })
    end

    local function stroke(parent, key, offset)
        local props = {
            Parent = parent, Color = Library.Theme[key],
            LineJoinMode = Enum.LineJoinMode.Miter,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }
        if offset then props.BorderOffset = UDim.new(0, offset) end
        return make("UIStroke", props, { Color = key })
    end

    local function formatNumber(n)
        if Library.FormatNumber then return Library:FormatNumber(n) end
        local s = tostring(math.floor(n + 0.5))
        while true do
            local c
            s, c = s:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
            if c == 0 then break end
        end
        return s
    end

    local Viewer = {
        Enabled = true, HasTarget = false, Player = nil,
        Signature = nil, Cells = {}, Count = 0, Total = nil,
    }

    -- si la libreria ya habia creado uno propio, se esconde para no duplicar paneles
    pcall(function()
        local Old = Library.InventoryObj
        if Old and Old.SetVisibility then Old:SetVisibility(false) end
    end)

    local Panel = Library:CreatePanel("Inventory Viewer", MIN_WIDTH, UDim2.new(0.014, 0, 0.04, 0), nil, nil, true)
    local PanelFrame = Panel["Panel"].Instance
    PanelFrame.Visible = false

    -- "pagina" falsa para poder usar una Section real de la libreria (igual que el Player indicator)
    local HolderFrame = make("Frame", {
        Parent = Panel["Content"].Instance, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 130),
    })
    local FakePage = setmetatable({
        Window = nil, Items = { PageContent = { Instance = HolderFrame } }, SubPages = {},
    }, Library.Pages)

    local Section = Library.Pages.Section(FakePage, { Name = "Info" })
    Section.Items["Outline"].Instance.Size = UDim2.new(1, 0, 0, 130)
    local SectionTitle = Section.Items["Text"].Instance
    local function cleanTitle()
        -- sin contorno negro (como el titulo "Menu") y con mas separacion respecto a la linea
        SectionTitle.TextStrokeTransparency = 1
        local Pad = SectionTitle:FindFirstChildOfClass("UIPadding")
        if Pad then
            Pad.PaddingLeft = UDim.new(0, TITLE_PAD)
            Pad.PaddingRight = UDim.new(0, TITLE_PAD)
        end
    end
    cleanTitle()

    local ElementsHolder = Section.Items["ElementsHolder"].Instance
    local function FitSection()
        local Height = ElementsHolder.AbsoluteSize.Y + 34
        Section.Items["Outline"].Instance.Size = UDim2.new(1, 0, 0, Height)
        HolderFrame.Size = UDim2.new(1, 0, 0, Height + 2)
    end
    Library:Connect(ElementsHolder:GetPropertyChangedSignal("AbsoluteSize"), FitSection)

    -- fila superior: nombre del target (izquierda) y cantidad / valor (derecha)
    local Row = make("Frame", {
        Parent = ElementsHolder, BackgroundTransparency = 1, LayoutOrder = 1, Size = UDim2.new(1, 0, 0, 14),
    })
    local PlayerName = label(Row, "no target", 12)
    PlayerName.Size = UDim2.new(0.5, 0, 1, 0)
    local Header = label(Row, "0 items", 12, Enum.TextXAlignment.Right)
    Header.AnchorPoint = Vector2.new(1, 0)
    Header.Position = UDim2.new(1, 0, 0, 0)
    Header.Size = UDim2.new(0.5, 0, 1, 0)

    local Empty = label(ElementsHolder, "None", 12)
    Empty.LayoutOrder = 2
    Empty.Size = UDim2.new(1, 0, 0, 14)

    local Grid = make("ScrollingFrame", {
        Parent = ElementsHolder, Active = true, AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarImageColor3 = Library.Theme["Accent"],
        ScrollBarThickness = 4, ScrollingDirection = Enum.ScrollingDirection.Y,
        LayoutOrder = 3, Size = UDim2.new(0, CELL, 0, CELL), BackgroundTransparency = 1,
    }, { ScrollBarImageColor3 = "Accent" })

    make("UIPadding", {
        Parent = Grid, PaddingLeft = UDim.new(0, GRID_PAD), PaddingRight = UDim.new(0, GRID_PAD),
        PaddingTop = UDim.new(0, GRID_PAD), PaddingBottom = UDim.new(0, GRID_PAD),
    })

    local GridLayout = make("UIGridLayout", {
        Parent = Grid, CellSize = UDim2.new(0, CELL, 0, CELL),
        CellPadding = UDim2.new(0, GAP, 0, GAP), SortOrder = Enum.SortOrder.LayoutOrder,
    })

    function Viewer:Layout()
        local N = Viewer.Count
        local Cols = N == 0 and 1 or math.min(MAX_COLS, N)
        local Rows = N == 0 and 0 or math.ceil(N / Cols)
        local VisibleRows = math.min(MAX_ROWS, Rows)
        local NeedScroll = Rows > MAX_ROWS

        local GridW = Cols * CELL + (Cols - 1) * GAP + GRID_PAD * 2
        local GridH = VisibleRows * CELL + math.max(VisibleRows - 1, 0) * GAP + GRID_PAD * 2
        local ScrollW = NeedScroll and 8 or 0

        Grid.Visible = N > 0
        Empty.Visible = N == 0
        Grid.ScrollBarThickness = NeedScroll and 4 or 0
        Grid.Size = UDim2.new(0, GridW + ScrollW, 0, GridH)
        GridLayout.FillDirectionMaxCells = Cols

        PanelFrame.Size = UDim2.new(0, math.max(MIN_WIDTH, GridW + ScrollW + EXTRA_W), 0, 0)
        FitSection()
    end

    local function ClearCells()
        for _, Cell in ipairs(Viewer.Cells) do pcall(function() Cell:Destroy() end) end
        Viewer.Cells = {}
    end

    function Viewer:SetPlayer(Player)
        Viewer.Player = Player
        Viewer.HasTarget = Player ~= nil
        PlayerName.Text = Player and Player.Name or "no target"
        Viewer:Apply()
    end

    -- List = { {Name = "MPSSD", Icon = "rbxassetid://...", Count = 94}, ... }; Total = valor en $ (opcional)
    function Viewer:SetItems(List, Total)
        List = List or {}

        local Parts = {}
        for i, v in ipairs(List) do
            Parts[i] = v.Name .. "|" .. tostring(v.Icon or "") .. "|" .. tostring(v.Count or "")
        end
        local Signature = table.concat(Parts, ";") .. "#" .. tostring(Total)
        if Signature == Viewer.Signature then return end
        Viewer.Signature = Signature

        Viewer.Count = #List
        Viewer.Total = Total

        Header.Text = string.format("%d items%s", #List, Total and (", $" .. formatNumber(Total)) or "")

        ClearCells()

        for Index, Value in ipairs(List) do
            local Cell = make("Frame", {
                Parent = Grid, LayoutOrder = Index, BackgroundColor3 = Library.Theme["Background"],
            }, { BackgroundColor3 = "Background" })
            stroke(Cell, "Outline")
            stroke(Cell, "Border", 1)

            if Value.Icon and Value.Icon ~= "" then
                -- solo el icono, centrado (sin nombre)
                make("ImageLabel", {
                    Parent = Cell, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
                    Size = UDim2.new(0, ICON, 0, ICON), BackgroundTransparency = 1,
                    ScaleType = Enum.ScaleType.Fit, Image = Value.Icon,
                })
            else
                -- sin icono: el nombre, en el centro de la celda
                local Name = label(Cell, Value.Name, 12, Enum.TextXAlignment.Center)
                Name.AnchorPoint = Vector2.new(0.5, 0.5)
                Name.Position = UDim2.new(0.5, 0, 0.5, 0)
                Name.Size = UDim2.new(1, -8, 1, -8)
                Name.TextYAlignment = Enum.TextYAlignment.Center
                Name.TextWrapped = true
            end

            if Value.Count and Value.Count > 1 then
                local Count = label(Cell, "x" .. formatNumber(Value.Count), 11, Enum.TextXAlignment.Right)
                Count.AnchorPoint = Vector2.new(1, 0)
                Count.Position = UDim2.new(1, -3, 0, 2)
                Count.Size = UDim2.new(0.7, 0, 0, 12)
                Count.ZIndex = 2
            end

            Viewer.Cells[#Viewer.Cells + 1] = Cell
        end

        pcall(function() Library:OutlineTexts(Grid) end)
        Viewer:Layout()
    end

    -- visible solo con el toggle activo (sin target muestra "None")
    function Viewer:Apply()
        local Indicator = Library.IndicatorObj
        local Target = Viewer.Player or (Indicator and Indicator.Player)
        if not Viewer.Player then
            PlayerName.Text = Target and Target.Name or "no target"
        end
        PanelFrame.Visible = Viewer.Enabled
    end

    function Viewer:SetVisibility(Bool) Viewer.Enabled = Bool Viewer:Apply() end
    function Viewer:SetTarget(Bool) Viewer.HasTarget = Bool and true or false Viewer:Apply() end
    function Viewer:SetHideNoTarget() Viewer:Apply() end

    pcall(function() Library:OutlineTexts(HolderFrame) end)
    cleanTitle()
    Viewer:Layout()

    Library.InventoryObj = Viewer
    Library.HotbarObj = Viewer
    print("[pchaxx13] Inventory viewer v2 cargado (titulo Info)")
    return Viewer
end

local function buildUI(Library)
    UILib = Library
    task.delay(0.5, function() UIReady = true end)

    -- Titulos de seccion (Players, Settings, ...) con la misma fuente que el titulo pchaxx13 y el watermark
    pcall(function()
        local P = Library.Pages
        if P and P.Section and not P.__pcTitleFont then
            local orig = P.Section
            P.Section = function(self, Data)
                local sec = orig(self, Data)
                pcall(function()
                    if Library.TitleFont then
                        sec.Items["Text"].Instance.FontFace = Library.TitleFont
                    end
                end)
                return sec
            end
            P.__pcTitleFont = true
        end
    end)

    local function report(where, err)
        warn("[pchaxx13] Error en " .. where .. ": " .. tostring(err))
        pcall(function()
            if Library.Alert then
                Library:Alert("error", where .. ": " .. tostring(err), 8)
            else
                Library:Notification("error (" .. where .. ": " .. tostring(err) .. ")", 8, Library.Theme.Accent)
            end
        end)
    end

    local logo = (LOGO_ASSET ~= "" and LOGO_ASSET) or "rbxassetid://124454910007637"
    local Window = Library:Window({ Logo = logo, Build = "private" })
    -- Tamaño de la ventana (ancho, alto). Cambia estos dos numeros si la quieres mas grande/chica.
    local WINDOW_W, WINDOW_H = 600, 500
    pcall(function()
        Window.Items["MainFrame"].Instance.Size = UDim2.new(0, WINDOW_W, 0, WINDOW_H)
    end)
    local KeybindList = Library:KeybindList()
    local Watermark = Library:Watermark("pchaxx13", logo)

    -- Player list: la crea la libreria (se activa desde Settings > Menu > Player List)
    if Library.PlayerList then
        local okL, errL = pcall(function() Library:PlayerList() end)
        if not okL then warn("[pchaxx13] Player list: " .. tostring(errL)) end
    else
        warn("[pchaxx13] La libreria es vieja: sube el library.lua nuevo para ver la Player list")
    end

    -- Blur de fondo mientras el menu esta abierto (toggle + slider en Visuals > Settings)
    local BlurCfg = { On = false, Size = 16 }
    local blurFx
    do
        pcall(function()
            for _, o in ipairs(game:GetService("Lighting"):GetChildren()) do
                if o.Name == "pchaxx13_Blur" then o:Destroy() end
            end
        end)
        blurFx = Instance.new("BlurEffect")
        blurFx.Name = "pchaxx13_Blur"
        blurFx.Size = 0
        blurFx.Enabled = false
        blurFx.Parent = game:GetService("Lighting")
    end
    local function updateBlur()
        pcall(function()
            local want = BlurCfg.On and Window.IsOpen == true
            if want then blurFx.Enabled = true end
            local tw = game:GetService("TweenService"):Create(blurFx, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = want and BlurCfg.Size or 0 })
            tw:Play()
            if not want then
                tw.Completed:Connect(function()
                    if not (BlurCfg.On and Window.IsOpen == true) then blurFx.Enabled = false end
                end)
            end
        end)
    end
    pcall(function()
        local origSetOpen = Window.SetOpen
        Window.SetOpen = function(self, Bool)
            origSetOpen(self, Bool)
            updateBlur()
        end
    end)
    pcall(function()
        local origUnload = Library.Unload
        Library.Unload = function(self, ...)
            pcall(function() blurFx:Destroy() end)
            return origUnload(self, ...)
        end
    end)
    if Library.PlayerIndicator and (Library.InventoryViewer or Library.Hotbar) then
        local okP, errP = pcall(function()
            TargetUI.Indicator = Library:PlayerIndicator()
            local okI, inv = pcall(buildInventoryViewer, Library)
            if okI and inv then
                TargetUI.Inventory = inv
            else
                warn("[pchaxx13] Inventory viewer propio: " .. tostring(inv))
                TargetUI.Inventory = (Library.InventoryViewer or Library.Hotbar)(Library)
            end
        end)
        if not okP then warn("[pchaxx13] Player indicator / Inventory viewer: " .. tostring(errP)) end
        refreshTargetUI()

        -- titulo "Info" del Indicator: sin contorno negro y con el mismo espacio que el del Inventory Viewer
        pcall(function()
            for _, o in ipairs(Library.Holder.Instance:GetDescendants()) do
                if o:IsA("TextLabel") and o.Text == "Info" and o.Size.Y.Offset == 1 and o.TextStrokeTransparency < 1 then
                    o.TextStrokeTransparency = 1
                    local pad = o:FindFirstChildOfClass("UIPadding")
                    if pad then
                        pad.PaddingLeft = UDim.new(0, 6)
                        pad.PaddingRight = UDim.new(0, 6)
                    end
                end
            end
        end)
    else
        warn("[pchaxx13] La libreria de PANDORA_URL es la vieja: sube el library.lua nuevo para ver Player indicator e Inventory viewer")
    end

    task.spawn(function()
        while getgenv().Library do
            task.wait(1)
            if LockedPlayer then refreshInventory() end
        end
    end)

    local function keyCallback(flag, fn)
        local last = false
        return function(Value)
            if not UIReady then
                last = Value
                return
            end
            if Value == last then return end
            last = Value
            if UserInputService:GetFocusedTextBox() then return end
            local f = Library.Flags[flag]
            local ok, err = pcall(fn, Value, f and f.Mode or "Toggle")
            if not ok then report(flag, err) end
        end
    end

    local function stateToggle(key, extra)
        return function(v)
            State[key] = v
            local ok, err = pcall(function()
                refresh()
                if extra then extra(v) end
            end)
            if not ok then report("toggle " .. key, err) end
        end
    end

    local function runSection(name, fn)
        local ok, err = pcall(fn)
        if not ok then
            report("sección " .. name, err)
        end
    end

    local CombatPage = Window:Page({ Icon = LIB_ICON, NoAutoIcon = true })

    -- Tabs de la izquierda: tamaño del icono / alto del tab (se aplica aqui, no depende de la version de la libreria).
    -- Los assets traen margen transparente, por eso el cuadro del icono es mas grande que el tab: el margen no se ve.
    local TAB_ICON_SIZE = 45
    local TAB_HEIGHT = 62
    local function styleTab(sub, icon, size, offX, offY)
        pcall(function()
            local it = sub.Items
            local img = it.Icon.Instance
            if icon then img.Image = icon end
            img.ScaleType = Enum.ScaleType.Fit
            size = size or TAB_ICON_SIZE
            img.Size = UDim2.fromOffset(size, size)
            img.Position = UDim2.new(0.5, offX or 0, 0.5, offY or 0) -- offX/offY: mueve el icono en px (+X derecha, +Y abajo)
            it.Inactive.Instance.Size = UDim2.new(1, 0, 0, TAB_HEIGHT)
        end)
    end

    local function addPicker(owner, title, flag, default, apply)
        local function cb(v)
            local col = v
            if typeof(col) ~= "Color3" and type(col) == "table" then
                col = col.Color or col.Value or col[1]
            end
            if typeof(col) == "Color3" then apply(col) end
        end
        local opts = { Name = title, Flag = flag, Default = default, Callback = cb }
        local lastErr = "este elemento no tiene Colorpicker"
        for _, method in ipairs({ "Colorpicker", "ColorPicker" }) do
            local okI, fn = pcall(function() return owner[method] end)
            if okI and type(fn) == "function" then
                local ok, res = pcall(fn, owner, opts)
                if ok then return res end
                lastErr = res
            end
        end
        report("colorpicker " .. title, lastErr)
    end

    runSection("Aimlock", function()
        local Sub = CombatPage:SubPage({ Name = "Aimlock" })
        -- tamaño 42 (un pelin mas chico) y +7px a la derecha para alinear con los demas tabs; ajusta estos 2 numeros si hace falta
        styleTab(Sub, "rbxassetid://83942884414056", 42, 7, 0)
        local Sec = Sub:Section({ Name = "Aimlock" })

        local T = Sec:Toggle({
            Name = "Enabled", Flag = "pc_aimlock", Default = false,
            Callback = stateToggle("Aimlock", function(on)
                if not on then unlock() end
                setStatus()
            end),
        })
        T:Keybind({
            Name = "Aimlock", Flag = "pc_aimlock_key", Default = Enum.KeyCode.C, Mode = "Toggle",
            Callback = keyCallback("pc_aimlock_key", function(Value, mode)
                if not State.Aimlock then return end
                if mode == "Hold" then
                    if Value then lockNearest() else unlock() end
                elseif mode == "Always On" then
                    if not LockedPlayer then lockNearest() end
                else
                    if LockedPlayer then unlock() else lockNearest() end
                end
            end),
        })

        Sec:Toggle({
            Name = "Smoothing", Flag = "pc_lock_smooth_on", Default = false,
            Callback = function(v) Settings.LockSmoothOn = v end,
        })
        Sec:Slider({
            Name = "Smoothness", Flag = "pc_lock_smooth", Default = Settings.LockSmooth,
            Min = 0, Max = 100, Decimals = 1, Suffix = "%",
            Callback = function(v) Settings.LockSmooth = v end,
        })

        Sec:Toggle({
            Name = "Prediction", Flag = "pc_lock_pred_on", Default = false,
            Callback = function(v) Settings.LockPredOn = v end,
        })
        Sec:Slider({
            Name = "Horizontal", Flag = "pc_lock_pred_h", Default = Settings.LockPredH,
            Min = 0, Max = 0.5, Decimals = 0.01, Suffix = " s",
            Callback = function(v) Settings.LockPredH = v end,
        })
        Sec:Slider({
            Name = "Vertical", Flag = "pc_lock_pred_v", Default = Settings.LockPredV,
            Min = 0, Max = 0.5, Decimals = 0.01, Suffix = " s",
            Callback = function(v) Settings.LockPredV = v end,
        })

        Sec:Dropdown({
            Name = "Type", Flag = "pc_lock_aim", Multi = false, Items = AIM_ITEMS, Default = "Camera",
            Callback = function(v)
                Settings.LockAim = AIM_MAP[v] or "Camera"
                LockAimState.vel = Vector3.zero
            end,
        })
    end)

    runSection("Visuals", function()
        local Sub = CombatPage:SubPage({ Name = "Visuals" })
        styleTab(Sub, "rbxassetid://7992557358")
        local Left = Sub:Section({ Name = "Players" })
        local Right = Sub:Section({ Name = "Settings" })

        local visToggles = {}
        local function reg(t)
            visToggles[#visToggles + 1] = t
            return t
        end

        Left:Toggle({ Name = "Enabled", Flag = "pc_enabled", Default = false, Callback = stateToggle("Enabled") })
        Left:Toggle({ Name = "Self", Flag = "pc_self", Default = false, Callback = stateToggle("Self") })

        local nameT = reg(Left:Toggle({ Name = "Name", Flag = "pc_name", Default = false, Callback = stateToggle("Name") }))
        addPicker(nameT, "Name color", "pc_name_color", VisCfg.Name.Color, function(c) VisCfg.Name.Color = c end)
        Left:Toggle({ Name = "Use display", Flag = "pc_usedisplay", Default = false, Callback = stateToggle("UseDisplay") })

        local fillT, glowT
        local boxT = reg(Left:Toggle({ Name = "Bounding Box", Flag = "pc_box", Default = false, Callback = stateToggle("Box") }))
        addPicker(boxT, "Box color", "pc_box_color", VisCfg.Box.Color, function(c) VisCfg.Box.Color = c end)
        addPicker(boxT, "Box outline", "pc_box_outline", VisCfg.Box.OutlineColor, function(c) VisCfg.Box.OutlineColor = c end)

        fillT = reg(Left:Toggle({ Name = "Box fill", Flag = "pc_image", Default = false, Callback = stateToggle("Image") }))
        addPicker(fillT, "Image color", "pc_image_color", VisCfg.Image.Color, function(c) VisCfg.Image.Color = c end)

        glowT = reg(Left:Toggle({ Name = "Box Glow", Flag = "pc_glow", Default = false, Callback = stateToggle("Glow") }))
        addPicker(glowT, "Glow color", "pc_glow_color", VisCfg.Glow.Color, function(c) VisCfg.Glow.Color = c end)
        -- Box fill y Box Glow siempre se ven en el menu; el efecto solo se dibuja si Bounding Box esta activo

        local hpT = reg(Left:Toggle({ Name = "Health Bar", Flag = "pc_health", Default = false, Callback = stateToggle("Health") }))
        -- los 3 colores de la barra (vida alta / media / baja) + el fondo (la parte de vida perdida)
        addPicker(hpT, "Health high", "pc_hp_c1", VisCfg.Health.Color1, function(c)
            VisCfg.Health.Color1 = c
            VisVersion = VisVersion + 1
        end)
        addPicker(hpT, "Health mid", "pc_hp_c2", VisCfg.Health.Color2, function(c)
            VisCfg.Health.Color2 = c
            VisVersion = VisVersion + 1
        end)
        addPicker(hpT, "Health low", "pc_hp_c3", VisCfg.Health.Color3, function(c)
            VisCfg.Health.Color3 = c
            VisVersion = VisVersion + 1
        end)
        addPicker(hpT, "Health background", "pc_hp_bg", VisCfg.Health.BgColor, function(c) VisCfg.Health.BgColor = c end)

        reg(Left:Toggle({ Name = "Health Value", Flag = "pc_hp_value", Default = false, Callback = stateToggle("HealthValue") }))

        local arrowsT = reg(Left:Toggle({ Name = "Arrows", Flag = "pc_arrows", Default = false, Callback = stateToggle("Arrows") }))
        addPicker(arrowsT, "Arrows color", "pc_arrows_color", VisCfg.Arrows.Color, function(c) VisCfg.Arrows.Color = c end)

        -- que texto sale pegado a las arrows (Name / Distance / Tool)
        local function arrowInfo(v)
            local sel = {}
            if type(v) == "string" then
                sel[v] = true
            elseif type(v) == "table" then
                for _, val in ipairs(v) do sel[val] = true end
            end
            local S = VisCfg.Arrows.Show
            S.Name, S.Distance, S.Tool = sel.Name == true, sel.Distance == true, sel.Tool == true
        end
        local okAD = pcall(function()
            Left:Dropdown({
                Name = "Arrows info", Flag = "pc_arrows_info", Multi = true,
                Items = { "Name", "Distance", "Tool" }, Default = { "Name", "Distance" },
                Callback = arrowInfo,
            })
        end)
        if not okAD then
            Left:Dropdown({
                Name = "Arrows info", Flag = "pc_arrows_info", Multi = false,
                Items = { "Name", "Distance", "Tool" }, Default = "Name",
                Callback = arrowInfo,
            })
        end

        local gunT = reg(Left:Toggle({ Name = "Tool", Flag = "pc_gun", Default = false, Callback = stateToggle("Gun") }))
        addPicker(gunT, "Tool color", "pc_gun_color", VisCfg.Gun.Color, function(c) VisCfg.Gun.Color = c end)

        local distT = reg(Left:Toggle({ Name = "Distance", Flag = "pc_dist", Default = false, Callback = stateToggle("Distance") }))
        addPicker(distT, "Distance color", "pc_dist_color", VisCfg.Distance.Color, function(c) VisCfg.Distance.Color = c end)

        local tracersT = reg(Left:Toggle({ Name = "Tracers", Flag = "pc_tracers", Default = false, Callback = stateToggle("Tracers") }))
        addPicker(tracersT, "Tracers color", "pc_tracers_color", VisCfg.Tracers.Color, function(c) VisCfg.Tracers.Color = c end)
        Left:Dropdown({
            Name = "Tracers origin", Flag = "pc_tracers_origin", Multi = false,
            Items = { "Up", "Down", "Left", "Right" }, Default = "Up",
            Callback = function(v)
                if type(v) == "table" then v = v[1] end
                VisCfg.Tracers.Origin = v or "Up"
            end,
        })

        -- ESP Preview: la ventana la crea la libreria y se activa en Settings (engranaje) > Menu > ESP Preview
        local Preview = buildPreview(Library)

        Right:Toggle({
            Name = "Dynamic", Flag = "pc_vis_dynamic", Default = false,
            Callback = function(v)
                VisCfg.Method = v and "Dynamic" or "Static"
            end,
        })
        Right:Slider({
            Name = "Glow", Flag = "pc_glow_amount", Default = VisCfg.GlowAmount,
            Min = 1, Max = 100, Decimals = 1,
            Callback = function(v) VisCfg.GlowAmount = v end,
        })
        Right:Slider({
            Name = "Distance", Flag = "pc_vis_maxdist", Default = Settings.MaxDist,
            Min = 0, Max = 3000, Decimals = 10, Suffix = " st",
            Callback = function(v) Settings.MaxDist = v end,
        })

        local FONT_ITEMS = { "Proggy Clean", "Smallest Pixel-7", "Tahoma", "Pixel Arial", "Arial", "Zekton" }
        Right:Dropdown({
            Name = "ESP font", Flag = "pc_font_all", Multi = false, Items = FONT_ITEMS, Default = "Proggy Clean",
            Callback = function(v)
                if type(v) == "table" then v = v[1] end
                v = v or "Proggy Clean"
                for key in pairs(VisCfg.Fonts) do
                    VisCfg.Fonts[key] = v
                end
                local sz = FONT_SIZES[v]
                if sz then
                    VisCfg.Name.Size = sz.Name
                    VisCfg.Distance.Size = sz.Distance
                    VisCfg.Gun.Size = sz.Gun
                    VisCfg.Health.TextSize = sz.Health
                end
                FontsVer = FontsVer + 1
            end,
        })

        Right:Slider({
            Name = "Refresh rate", Flag = "pc_refresh", Default = VisCfg.RefreshRate,
            Min = 1, Max = 240, Decimals = 1, Suffix = " hz",
            Callback = function(v) VisCfg.RefreshRate = v end,
        })
        Right:Label("Image asset id")
        Right:Textbox({
            Flag = "pc_img_id", Placeholder = "id / rbxassetid / url", Default = "", Finished = true,
            Callback = function(v)
                task.spawn(function()
                    local ok, res = pcall(VisCfg.SetImage, v)
                    if not (ok and res) then
                        pcall(function()
                            Library:Notification("no se pudo cargar la imagen", 4, Library.Theme.Accent)
                        end)
                    end
                end)
            end,
        })
        Right:Slider({
            Name = "Image fill opacity", Flag = "pc_img_opacity", Default = VisCfg.Image.Opacity,
            Min = 0, Max = 1, Decimals = 0.01,
            Callback = function(v) VisCfg.Image.Opacity = v end,
        })

        Right:Toggle({
            Name = "Menu blur", Flag = "pc_blur", Default = false,
            Callback = function(v) BlurCfg.On = v; updateBlur() end,
        })
        Right:Slider({
            Name = "Blur amount", Flag = "pc_blur_size", Default = BlurCfg.Size,
            Min = 0, Max = 56, Decimals = 1,
            Callback = function(v) BlurCfg.Size = v; updateBlur() end,
        })

        Right:Toggle({ Name = "Notifications", Flag = "pc_notify", Default = true, Callback = stateToggle("Notify") })
    end)

    runSection("World", function()
        local Sub = CombatPage:SubPage({ Name = "World" })
        styleTab(Sub, "rbxassetid://84997869213448")
        -- Seccion "Lighting" (todo lo de mundo) a la izquierda; "Crosshair" a la derecha
        local Left = Sub:Section({ Name = "Lighting" })
        local Right = Left

        local function worldToggle(name)
            return function(v)
                local ok, err = pcall(World.set, name, v)
                if not ok then report("world " .. name, err) end
            end
        end

        local function worldSlider(section, title, flag, key, min, max, step, suffix)
            World.Val[key] = math.clamp(World.Val[key], min, max)
            section:Slider({
                Name = title, Flag = flag, Default = World.Val[key],
                Min = min, Max = max, Decimals = step, Suffix = suffix or "",
                Callback = function(v) World.Val[key] = v end,
            })
        end

        local function pick(v)
            if type(v) == "table" then v = v[1] end
            return v
        end

        Left:Toggle({ Name = "Brightness", Flag = "pc_w_brightness", Default = false, Callback = worldToggle("Brightness") })
        worldSlider(Left, "Brightness level", "pc_w_brightness_v", "Brightness", -1, 1, 0.05)

        Left:Toggle({ Name = "World time", Flag = "pc_w_time", Default = false, Callback = worldToggle("Time") })
        worldSlider(Left, "Hour", "pc_w_time_v", "ClockTime", 0, 24, 0.1, " h")

        local fogT = Left:Toggle({ Name = "Fog", Flag = "pc_w_fog", Default = false, Callback = worldToggle("Fog") })
        addPicker(fogT, "Fog color", "pc_w_fog_c", World.Val.FogColor, function(c) World.Val.FogColor = c end)
        worldSlider(Left, "Fog start", "pc_w_fog_s", "FogStart", 0, 1500, 10, " st")
        worldSlider(Left, "Fog end", "pc_w_fog_e", "FogEnd", 0, 3000, 10, " st")

        local ambT = Left:Toggle({ Name = "Ambient", Flag = "pc_w_amb", Default = false, Callback = worldToggle("Ambient") })
        addPicker(ambT, "Ambient color", "pc_w_amb_c", World.Val.Ambient, function(c) World.Val.Ambient = c end)
        local outL = Left:Label("Outdoor ambient")
        addPicker(outL, "Outdoor ambient", "pc_w_amb_o", World.Val.OutdoorAmbient, function(c) World.Val.OutdoorAmbient = c end)

        Right:Toggle({ Name = "Saturation", Flag = "pc_w_sat", Default = false, Callback = worldToggle("Saturation") })
        worldSlider(Right, "Saturation level", "pc_w_sat_v", "Saturation", -1, 3, 0.05)

        Right:Toggle({ Name = "Contrast", Flag = "pc_w_con", Default = false, Callback = worldToggle("Contrast") })
        worldSlider(Right, "Contrast level", "pc_w_con_v", "Contrast", -1, 2, 0.05)

        local tintT = Right:Toggle({ Name = "Tint", Flag = "pc_w_tint", Default = false, Callback = worldToggle("Tint") })
        addPicker(tintT, "Tint color", "pc_w_tint_c", World.Val.Tint, function(c) World.Val.Tint = c end)

        Right:Toggle({ Name = "Lighting mode", Flag = "pc_w_tech", Default = false, Callback = worldToggle("Tech") })
        Right:Dropdown({
            Name = "Mode", Flag = "pc_w_tech_v", Multi = false, Items = TECH_ITEMS, Default = World.Val.Tech,
            Callback = function(v)
                World.Val.Tech = pick(v) or World.Val.Tech
                if World.On.Tech then
                    local ok, err = pcall(setTech, World.Val.Tech)
                    if not ok then report("lighting mode", err) end
                end
            end,
        })

        Right:Toggle({ Name = "Skybox", Flag = "pc_w_sky", Default = false, Callback = worldToggle("Sky") })
        Right:Dropdown({
            Name = "Sky", Flag = "pc_w_sky_v", Multi = false, Items = SKY_ITEMS, Default = World.Val.Sky,
            Callback = function(v)
                World.Val.Sky = pick(v) or World.Val.Sky
                if World.On.Sky then
                    local ok, err = pcall(World.applySky)
                    if not ok then report("skybox", err) end
                end
            end,
        })

        -- ===== Crosshair (seccion nueva en el tab World) =====
        local CH = Crosshair.Cfg
        local CS = Sub:Section({ Name = "Crosshair" })
        local function chBump() Crosshair.Ver = Crosshair.Ver + 1 end
        local function chSlider(title, flag, key, min, max, step, suffix)
            CS:Slider({
                Name = title, Flag = flag, Default = CH[key],
                Min = min, Max = max, Decimals = step, Suffix = suffix or "",
                Callback = function(v) CH[key] = v end,
            })
        end

        local visT = CS:Toggle({ Name = "Visible", Flag = "pc_ch_on", Default = false, Callback = function(v) CH.Enabled = v end })
        addPicker(visT, "Crosshair color", "pc_ch_c1", CH.Color1, function(c) CH.Color1 = c; chBump() end)
        addPicker(visT, "Crosshair color 2", "pc_ch_c2", CH.Color2, function(c) CH.Color2 = c; chBump() end)

        chSlider("Gap", "pc_ch_gap", "Gap", 0, 50, 1, " px")
        chSlider("Length", "pc_ch_len", "Length", 1, 50, 1, " px")
        chSlider("Thickness", "pc_ch_thick", "Thickness", 1, 10, 1, " px")
        chSlider("Rotation", "pc_ch_rot", "Rotation", 0, 360, 1, " deg")

        CS:Toggle({ Name = "Spin", Flag = "pc_ch_spin", Default = false, Callback = function(v) CH.Spin = v end })
        chSlider("Spin speed", "pc_ch_spin_speed", "SpinSpeed", 0, 5, 0.1, " rps")

        CS:Toggle({ Name = "Resize", Flag = "pc_ch_resize", Default = false, Callback = function(v) CH.Resize = v end })
        chSlider("Resize speed", "pc_ch_resize_speed", "ResizeSpeed", 0, 5, 0.1)
        chSlider("Max", "pc_ch_max", "Max", 0, 50, 1, " px")
        chSlider("Min", "pc_ch_min", "Min", 0, 50, 1, " px")

        local outT = CS:Toggle({ Name = "Outline", Flag = "pc_ch_outline", Default = CH.Outline, Callback = function(v) CH.Outline = v end })
        addPicker(outT, "Outline color", "pc_ch_oc1", CH.OutlineColor1, function(c) CH.OutlineColor1 = c; chBump() end)
        addPicker(outT, "Outline color 2", "pc_ch_oc2", CH.OutlineColor2, function(c) CH.OutlineColor2 = c; chBump() end)
        chSlider("Outline thickness", "pc_ch_othick", "OutlineThickness", 1, 10, 1, " px")

        chSlider("Smoothness", "pc_ch_smooth", "Smoothness", 0, 5, 0.1)
        CS:Toggle({ Name = "Stick target", Flag = "pc_ch_stick_t", Default = false, Callback = function(v) CH.StickTarget = v end })
        CS:Toggle({ Name = "Stick barrel", Flag = "pc_ch_stick_b", Default = false, Callback = function(v) CH.StickBarrel = v end })
        CS:Dropdown({
            Name = "Position", Flag = "pc_ch_pos", Multi = false, Items = { "Center", "Mouse" }, Default = CH.Position,
            Callback = function(v)
                if type(v) == "table" then v = v[1] end
                CH.Position = v or "Center"
            end,
        })

        CS:Toggle({ Name = "Crosshair text", Flag = "pc_ch_text", Default = false, Callback = function(v) CH.Text.On = v end })
        CS:Dropdown({
            Name = "Text font", Flag = "pc_ch_text_font", Multi = false, Items = CROSSHAIR_FONTS, Default = CH.Text.Font,
            Callback = function(v)
                if type(v) == "table" then v = v[1] end
                CH.Text.Font = v or CH.Text.Font
                Crosshair.FontDirty = true
            end,
        })

        -- ============================================================
        -- AURA (auras de juju) y CHINA HAT: secciones nuevas debajo de Lighting/Crosshair (tab World)
        -- ============================================================
        do
        local okPA, errPA = pcall(function()
            local AuraSec = Sub:Section({ Name = "Player" })
            local HatSec = AuraSec -- Aura y China hat comparten la seccion Player
            local CamSec = Sub:Section({ Name = "Camera" })

            -- ---------- AURA ----------
            local function build_blue_heat_aura()
                        local model = Instance.new("Model")
                        model.Name = "blue heat"
                        local blueheatColor = Color3.fromRGB(15, 15, 255)
                        local parts_to_use = {"UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}
                        for _, partName in ipairs(parts_to_use) do
                            local part = Instance.new("Part")
                            part.Name = partName
                            part.Parent = model
                            local atom1 = Instance.new("ParticleEmitter")
                            atom1.Name = "BhAtom1"
                            atom1.Acceleration = Vector3.new(0, 1, 0)
                            atom1.Brightness = 10
                            atom1.Color = ColorSequence.new(blueheatColor)
                            atom1.Drag = 50
                            atom1.EmissionDirection = Enum.NormalId.Top
                            atom1.Enabled = true
                            atom1.Lifetime = NumberRange.new(0.4, 0.6)
                            atom1.LightEmission = 1
                            atom1.LightInfluence = 0
                            atom1.LockedToPart = false
                            atom1.Orientation = Enum.ParticleOrientation.FacingCamera
                            atom1.Rate = 20
                            atom1.RotSpeed = NumberRange.new(0, 0)
                            atom1.Rotation = NumberRange.new(-360, 360)
                            atom1.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.125), NumberSequenceKeypoint.new(1, 0)})
                            atom1.Speed = NumberRange.new(30, 40)
                            atom1.SpreadAngle = Vector2.new(90, 90)
                            atom1.Squash = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0)})
                            atom1.Texture = "rbxassetid://11448304274"
                            atom1.TimeScale = 0.75
                            atom1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.500529, 0), NumberSequenceKeypoint.new(1, 1)})
                            atom1.VelocityInheritance = 0
                            atom1.WindAffectsDrag = false
                            atom1.ZOffset = -1
                            atom1.Parent = part
                            local flame1 = Instance.new("ParticleEmitter")
                            flame1.Name = "BhFlame1"
                            flame1.Acceleration = Vector3.new(0, 1, 0)
                            flame1.Brightness = 10
                            flame1.Color = ColorSequence.new(blueheatColor)
                            flame1.EmissionDirection = Enum.NormalId.Top
                            flame1.Enabled = true
                            flame1.Lifetime = NumberRange.new(0.4, 0.6)
                            flame1.LightEmission = 1
                            flame1.LightInfluence = 0
                            flame1.LockedToPart = false
                            flame1.Orientation = Enum.ParticleOrientation.FacingCamera
                            flame1.Rate = 150
                            flame1.RotSpeed = NumberRange.new(0, 0)
                            flame1.Rotation = NumberRange.new(-360, 360)
                            flame1.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
                            flame1.Speed = NumberRange.new(1, 2)
                            flame1.SpreadAngle = Vector2.new(90, 90)
                            flame1.Texture = "rbxassetid://10545078665"
                            flame1.TimeScale = 0.75
                            flame1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.500529, 0), NumberSequenceKeypoint.new(1, 1)})
                            flame1.ZOffset = -1
                            flame1.Parent = part
                            local glow = Instance.new("ParticleEmitter")
                            glow.Name = "BhGlow"
                            glow.Acceleration = Vector3.new(0, 1, 0)
                            glow.Brightness = 10
                            glow.Color = ColorSequence.new(blueheatColor)
                            glow.EmissionDirection = Enum.NormalId.Top
                            glow.Enabled = true
                            glow.FlipbookFramerate = NumberRange.new(30, 30)
                            glow.FlipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
                            glow.FlipbookMode = Enum.ParticleFlipbookMode.OneShot
                            glow.Lifetime = NumberRange.new(0.4, 0.6)
                            glow.LightEmission = 1
                            glow.LightInfluence = 0
                            glow.LockedToPart = true
                            glow.Orientation = Enum.ParticleOrientation.FacingCamera
                            glow.Rate = 200
                            glow.RotSpeed = NumberRange.new(0, 0)
                            glow.Rotation = NumberRange.new(-360, 360)
                            glow.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.5)})
                            glow.Speed = NumberRange.new(0.1, 0.1)
                            glow.SpreadAngle = Vector2.new(360, 360)
                            glow.Texture = "rbxassetid://8451174579"
                            glow.TimeScale = 0.75
                            glow.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0.9125), NumberSequenceKeypoint.new(1, 1)})
                            glow.ZOffset = 1
                            glow.Parent = part
                        end
                        return model
                    end
            
                    local function build_heal_aura()
                        local model = Instance.new("Model")
                        model.Name = "heal aura"
                        local torso = Instance.new("Part")
                        torso.Name = "LowerTorso"
                        torso.Parent = model
                        local att = Instance.new("Attachment")
                        att.Parent = torso
                        local hw1 = Instance.new("ParticleEmitter")
                        hw1.Name = "HealingWave1"
                        hw1.Lifetime = NumberRange.new(1.5, 1.5)
                        hw1.SpreadAngle = Vector2.new(10, -10)
                        hw1.LockedToPart = true
                        hw1.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.1702454, 0.7, 0.014881), NumberSequenceKeypoint.new(0.2254601, 0.03125, 0.03125), NumberSequenceKeypoint.new(0.2852761, 0), NumberSequenceKeypoint.new(0.702454, 0), NumberSequenceKeypoint.new(0.8374233, 0.9125, 0.0601461), NumberSequenceKeypoint.new(1, 1)})
                        hw1.LightEmission = 0.4
                        hw1.Color = ColorSequence.new(Color3.fromRGB(234, 8, 255))
                        hw1.VelocitySpread = 10
                        hw1.Speed = NumberRange.new(3, 6)
                        hw1.Brightness = 10
                        hw1.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 3.0624998, 1.8805969), NumberSequenceKeypoint.new(0.6420546, 1.9999999, 1.7619393), NumberSequenceKeypoint.new(1, 0.7499999, 0.7499999)})
                        hw1.Rate = 20
                        hw1.Texture = "rbxassetid://8047533775"
                        hw1.RotSpeed = NumberRange.new(200, 400)
                        hw1.Rotation = NumberRange.new(-180, 180)
                        hw1.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
                        hw1.Parent = att
                        local hw2 = Instance.new("ParticleEmitter")
                        hw2.Name = "HealingWave2"
                        hw2.Lifetime = NumberRange.new(1.5, 1.5)
                        hw2.SpreadAngle = Vector2.new(10, -10)
                        hw2.LockedToPart = true
                        hw2.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.2254601, 0.03125, 0.03125), NumberSequenceKeypoint.new(0.6288344, 0.25625, 0.0593491), NumberSequenceKeypoint.new(0.8374233, 0.9125, 0.0601461), NumberSequenceKeypoint.new(1, 1)})
                        hw2.LightEmission = 1
                        hw2.Color = ColorSequence.new(Color3.fromRGB(238, 3, 255))
                        hw2.VelocitySpread = 10
                        hw2.Speed = NumberRange.new(3, 5)
                        hw2.Brightness = 10
                        hw2.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 3.125), NumberSequenceKeypoint.new(0.4165329, 1.3749999, 1.3749999), NumberSequenceKeypoint.new(1, 0.9375, 0.9375)})
                        hw2.Rate = 20
                        hw2.Texture = "rbxassetid://8047796070"
                        hw2.RotSpeed = NumberRange.new(100, 300)
                        hw2.Rotation = NumberRange.new(-180, 180)
                        hw2.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
                        hw2.Parent = att
                        local sparks = Instance.new("ParticleEmitter")
                        sparks.Name = "HealSparks"
                        sparks.Lifetime = NumberRange.new(0.5, 2)
                        sparks.SpreadAngle = Vector2.new(180, -180)
                        sparks.LightEmission = 1
                        sparks.Color = ColorSequence.new(Color3.fromRGB(255, 21, 255))
                        sparks.Drag = 3
                        sparks.VelocitySpread = 180
                        sparks.Speed = NumberRange.new(5, 15)
                        sparks.Brightness = 10
                        sparks.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.14687, 0.4374999, 0.1875001), NumberSequenceKeypoint.new(1, 0)})
                        sparks.Acceleration = Vector3.new(0, 3, 0)
                        sparks.ZOffset = -1
                        sparks.Rate = 40
                        sparks.Texture = "rbxassetid://8611887361"
                        sparks.RotSpeed = NumberRange.new(-30, 30)
                        sparks.Orientation = Enum.ParticleOrientation.VelocityParallel
                        sparks.Parent = att
                        local starSparks = Instance.new("ParticleEmitter")
                        starSparks.Name = "HealStarSparks"
                        starSparks.Lifetime = NumberRange.new(1.5, 1.5)
                        starSparks.SpreadAngle = Vector2.new(180, -180)
                        starSparks.LightEmission = 1
                        starSparks.Color = ColorSequence.new(Color3.fromRGB(226, 60, 255))
                        starSparks.Drag = 3
                        starSparks.VelocitySpread = 180
                        starSparks.Speed = NumberRange.new(5, 10)
                        starSparks.Brightness = 10
                        starSparks.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.1492777, 0.6874996, 0.6874996), NumberSequenceKeypoint.new(1, 0)})
                        starSparks.Acceleration = Vector3.new(0, 3, 0)
                        starSparks.ZOffset = 2
                        starSparks.Texture = "rbxassetid://8611887703"
                        starSparks.RotSpeed = NumberRange.new(-30, 30)
                        starSparks.Rotation = NumberRange.new(-30, 30)
                        starSparks.Parent = att
                        return model
                    end
            
                    local AURA_NAMES = {
                "starlight", "heavenly", "ribbon", "lightning", "sakura", "angel", "wind", "flow", "star",
                "blue heat", "heal aura",
            }
            local AURA_ASSETS = {
                starlight = 134645216613107, lightning = 88833232287502, heavenly = 139300897520961,
                ribbon = 132069507632161, sakura = 81755778619404, angel = 97658130917593,
                wind = 80694081850877, flow = 119913533725648, star = 73754563740680,
            }
            local AURA_BUILD = {
                ["blue heat"] = build_blue_heat_aura,
                ["heal aura"] = build_heal_aura,
            }

            local Aura = {
                Enabled = false,
                Color = Color3.fromRGB(133, 220, 255),
                Selected = { "angel" },
                Templates = {},
                Live = {},
                Conn = nil,
            }

            local function auraRecolor(root)
                local col = ColorSequence.new(Aura.Color)
                local list = root:GetDescendants()
                list[#list + 1] = root
                for _, d in ipairs(list) do
                    if d:IsA("PointLight") then
                        d.Color = Aura.Color
                    elseif d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") then
                        d.Color = col
                    end
                end
            end

            local function auraTemplate(name)
                if Aura.Templates[name] then return Aura.Templates[name] end
                local obj
                if AURA_BUILD[name] then
                    local ok, res = pcall(AURA_BUILD[name])
                    if ok then obj = res else report("aura " .. name, res) end
                elseif AURA_ASSETS[name] then
                    local ok, res = pcall(function()
                        return game:GetObjects("rbxassetid://" .. AURA_ASSETS[name])[1]
                    end)
                    if ok then obj = res else report("aura " .. name, res) end
                end
                Aura.Templates[name] = obj or false
                return obj or false
            end

            local function auraClear()
                for i = #Aura.Live, 1, -1 do
                    pcall(function() Aura.Live[i]:Destroy() end)
                    Aura.Live[i] = nil
                end
            end

            local function auraApply()
                auraClear()
                if not Aura.Enabled then return end
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                for _, name in ipairs(Aura.Selected) do
                    local tpl = auraTemplate(name)
                    if tpl then
                        local clone = tpl:Clone()
                        auraRecolor(clone)
                        for _, part in ipairs(clone:GetChildren()) do
                            local real = char:FindFirstChild(part.Name)
                            if real then
                                for _, child in ipairs(part:GetChildren()) do
                                    child.Parent = real
                                    Aura.Live[#Aura.Live + 1] = child
                                end
                            end
                        end
                        clone:Destroy()
                    end
                end
            end

            local function auraSetEnabled(on)
                Aura.Enabled = on and true or false
                if Aura.Conn then Aura.Conn:Disconnect(); Aura.Conn = nil end
                if Aura.Enabled then
                    Aura.Conn = LocalPlayer.CharacterAdded:Connect(function()
                        task.wait(1)
                        auraApply()
                    end)
                    task.spawn(auraApply)
                else
                    auraClear()
                end
            end

            local auraT = AuraSec:Toggle({
                Name = "Aura", Flag = "pc_aura", Default = false,
                Callback = auraSetEnabled,
            })
            addPicker(auraT, "Aura color", "pc_aura_color", Aura.Color, function(c)
                Aura.Color = c
                for _, obj in ipairs(Aura.Live) do
                    pcall(auraRecolor, obj)
                end
                for _, tpl in pairs(Aura.Templates) do
                    if tpl then pcall(auraRecolor, tpl) end
                end
            end)

            local function auraTypes(v)
                local list = {}
                if type(v) == "string" then
                    list[1] = v
                elseif type(v) == "table" then
                    for _, val in ipairs(v) do list[#list + 1] = val end
                end
                Aura.Selected = list
                task.spawn(auraApply)
            end
            local okD = pcall(function()
                AuraSec:Dropdown({
                    Name = "Aura type", Flag = "pc_aura_types", Multi = true,
                    Items = AURA_NAMES, Default = { "angel" },
                    Callback = auraTypes,
                })
            end)
            if not okD then
                AuraSec:Dropdown({
                    Name = "Aura type", Flag = "pc_aura_types", Multi = false,
                    Items = AURA_NAMES, Default = "angel",
                    Callback = auraTypes,
                })
            end

            -- ---------- CHINA HAT ----------
            local Hat = {
                Enabled = false,
                Color = Color3.fromRGB(255, 105, 180),
                Size = 1.7,
                Height = 1.1,
                Material = "Neon",
                Cone = nil, Mesh = nil, Weld = nil, Light = nil, Conn = nil,
            }

            local function hatDestroy()
                if Hat.Cone then pcall(function() Hat.Cone:Destroy() end) end
                Hat.Cone, Hat.Mesh, Hat.Weld, Hat.Light = nil, nil, nil, nil
            end

            local function hatApply()
                if Hat.Mesh then
                    Hat.Mesh.Scale = Vector3.new(Hat.Size, Hat.Height, Hat.Size)
                end
                if Hat.Weld then
                    -- al subir la altura el cono crece hacia arriba y no se hunde en la cabeza
                    Hat.Weld.C0 = CFrame.new(0, 0.9 + (Hat.Height - 1.1) * 0.5, 0)
                end
                if Hat.Cone then
                    Hat.Cone.Color = Hat.Color
                    local ok, mat = pcall(function() return Enum.Material[Hat.Material] end)
                    if ok and mat then Hat.Cone.Material = mat end
                end
                if Hat.Light then
                    Hat.Light.Color = Hat.Color
                end
            end

            local function hatCreate(Character)
                hatDestroy()
                if not Character then return end
                local Head = Character:FindFirstChild("Head") or Character:WaitForChild("Head", 5)
                if not Head or not Hat.Enabled then return end

                local Cone = Instance.new("Part")
                Cone.Name = "pchaxx13_ChinaHat"
                Cone.Size = Vector3.new(1, 1, 1)
                Cone.Transparency = 0.2
                Cone.Anchored = false
                Cone.CanCollide = false
                Cone.CanQuery = false
                Cone.CanTouch = false
                Cone.Massless = true

                local Mesh = Instance.new("SpecialMesh")
                Mesh.MeshType = Enum.MeshType.FileMesh
                Mesh.MeshId = "rbxassetid://1033714"
                Mesh.Parent = Cone

                local Weld = Instance.new("Weld")
                Weld.Part0 = Head
                Weld.Part1 = Cone
                Weld.Parent = Cone

                local Light = Instance.new("PointLight")
                Light.Brightness = 0
                Light.Range = 12
                Light.Shadows = true
                Light.Parent = Cone

                Cone.Color = Hat.Color
                Cone.Material = Enum.Material.Neon
                Hat.Cone, Hat.Mesh, Hat.Weld, Hat.Light = Cone, Mesh, Weld, Light
                hatApply()
                Cone.Parent = Character
                hatApply()
            end

            local function hatSetEnabled(on)
                Hat.Enabled = on and true or false
                if Hat.Conn then Hat.Conn:Disconnect(); Hat.Conn = nil end
                if Hat.Enabled then
                    Hat.Conn = LocalPlayer.CharacterAdded:Connect(function(ch)
                        task.spawn(hatCreate, ch)
                    end)
                    if LocalPlayer.Character then task.spawn(hatCreate, LocalPlayer.Character) end
                else
                    hatDestroy()
                end
            end

            local hatT = HatSec:Toggle({
                Name = "China hat", Flag = "pc_chinahat", Default = false,
                Callback = hatSetEnabled,
            })
            addPicker(hatT, "Hat color", "pc_chinahat_color", Hat.Color, function(c)
                Hat.Color = c
                hatApply()
            end)
            HatSec:Slider({
                Name = "Size", Flag = "pc_chinahat_size", Default = Hat.Size,
                Min = 0.5, Max = 5, Decimals = 0.1,
                Callback = function(v) Hat.Size = v; hatApply() end,
            })
            HatSec:Slider({
                Name = "Height", Flag = "pc_chinahat_height", Default = Hat.Height,
                Min = 0.2, Max = 4, Decimals = 0.1,
                Callback = function(v) Hat.Height = v; hatApply() end,
            })


            -- ---------- FREECAM (sin esconder nada de la pantalla) ----------
            if genv.pchaxx13_FreecamStop then pcall(genv.pchaxx13_FreecamStop) end
            local Freecam = { Active = false }
            do
                local pi, abs, clamp, exp, rad, sign, sqrt, tan =
                    math.pi, math.abs, math.clamp, math.exp, math.rad, math.sign, math.sqrt, math.tan
                local CAS = game:GetService("ContextActionService")
                local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value
                local STEP_NAME = "pchaxx13_Freecam"

                local NAV_GAIN = Vector3.new(1, 1, 1) * 64
                local PAN_GAIN = Vector2.new(0.75, 1) * 8
                local FOV_GAIN = 300
                local PITCH_LIMIT = rad(90)
                local VEL_STIFFNESS, PAN_STIFFNESS, FOV_STIFFNESS = 1.5, 1.0, 4.0

                local Spring = {}
                Spring.__index = Spring
                function Spring.new(freq, pos)
                    return setmetatable({ f = freq, p = pos, v = pos * 0 }, Spring)
                end
                function Spring:Update(dt, goal)
                    local f = self.f * 2 * pi
                    local p0, v0 = self.p, self.v
                    local offset = goal - p0
                    local decay = exp(-f * dt)
                    self.p = goal + (v0 * dt - offset * (f * dt + 1)) * decay
                    self.v = (f * dt * (offset * f - v0) + v0) * decay
                    return self.p
                end
                function Spring:Reset(pos)
                    self.p = pos
                    self.v = pos * 0
                end

                local cameraPos, cameraRot, cameraFov = Vector3.new(), Vector2.new(), 0
                local velSpring = Spring.new(VEL_STIFFNESS, Vector3.new())
                local panSpring = Spring.new(PAN_STIFFNESS, Vector2.new())
                local fovSpring = Spring.new(FOV_STIFFNESS, 0)

                local Input = {}
                do
                    local function thumbstickCurve(x)
                        local K_CURVATURE, K_DEADZONE = 2.0, 0.15
                        local function fCurve(v) return (exp(K_CURVATURE * v) - 1) / (exp(K_CURVATURE) - 1) end
                        local function fDeadzone(v) return fCurve((v - K_DEADZONE) / (1 - K_DEADZONE)) end
                        return sign(x) * clamp(fDeadzone(abs(x)), 0, 1)
                    end

                    local gamepad = {
                        ButtonX = 0, ButtonY = 0, DPadDown = 0, DPadUp = 0, ButtonL2 = 0, ButtonR2 = 0,
                        Thumbstick1 = Vector2.new(), Thumbstick2 = Vector2.new(),
                    }
                    local keyboard = {
                        W = 0, A = 0, S = 0, D = 0, E = 0, Q = 0, U = 0, H = 0, J = 0, K = 0, I = 0, Y = 0,
                        Up = 0, Down = 0, LeftShift = 0, RightShift = 0,
                    }
                    local mouse = { Delta = Vector2.new(), MouseWheel = 0 }

                    local NAV_GAMEPAD_SPEED = Vector3.new(1, 1, 1)
                    local NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
                    local PAN_MOUSE_SPEED = Vector2.new(1, 1) * (pi / 64)
                    local PAN_GAMEPAD_SPEED = Vector2.new(1, 1) * (pi / 8)
                    local FOV_WHEEL_SPEED = 1.0
                    local FOV_GAMEPAD_SPEED = 0.25
                    local NAV_ADJ_SPEED = 0.75
                    local NAV_SHIFT_MUL = 0.25
                    local navSpeed = 1

                    function Input.Vel(dt)
                        navSpeed = clamp(navSpeed + dt * (keyboard.Up - keyboard.Down) * NAV_ADJ_SPEED, 0.01, 4)
                        local kGamepad = Vector3.new(
                            thumbstickCurve(gamepad.Thumbstick1.X),
                            thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
                            thumbstickCurve(-gamepad.Thumbstick1.Y)
                        ) * NAV_GAMEPAD_SPEED
                        local kKeyboard = Vector3.new(
                            keyboard.D - keyboard.A + keyboard.K - keyboard.H,
                            keyboard.E - keyboard.Q + keyboard.I - keyboard.Y,
                            keyboard.S - keyboard.W + keyboard.J - keyboard.U
                        ) * NAV_KEYBOARD_SPEED
                        local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
                            or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
                        return (kGamepad + kKeyboard) * (navSpeed * (shift and NAV_SHIFT_MUL or 1))
                    end

                    function Input.Pan(dt)
                        local kGamepad = Vector2.new(
                            thumbstickCurve(gamepad.Thumbstick2.Y),
                            thumbstickCurve(-gamepad.Thumbstick2.X)
                        ) * PAN_GAMEPAD_SPEED
                        local kMouse = mouse.Delta * PAN_MOUSE_SPEED
                        mouse.Delta = Vector2.new()
                        return kGamepad + kMouse
                    end

                    function Input.Fov(dt)
                        local kGamepad = (gamepad.ButtonX - gamepad.ButtonY) * FOV_GAMEPAD_SPEED
                        local kMouse = mouse.MouseWheel * FOV_WHEEL_SPEED
                        mouse.MouseWheel = 0
                        return kGamepad + kMouse
                    end

                    local function Keypress(action, state, input)
                        keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
                        return Enum.ContextActionResult.Sink
                    end
                    local function GpButton(action, state, input)
                        gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
                        return Enum.ContextActionResult.Sink
                    end
                    local function MousePan(action, state, input)
                        local delta = input.Delta
                        mouse.Delta = Vector2.new(-delta.Y, -delta.X)
                        return Enum.ContextActionResult.Sink
                    end
                    local function Thumb(action, state, input)
                        gamepad[input.KeyCode.Name] = input.Position
                        return Enum.ContextActionResult.Sink
                    end
                    local function Trigger(action, state, input)
                        gamepad[input.KeyCode.Name] = input.Position.Z
                        return Enum.ContextActionResult.Sink
                    end
                    local function MouseWheel(action, state, input)
                        mouse[input.UserInputType.Name] = -input.Position.Z
                        return Enum.ContextActionResult.Sink
                    end
                    local function Zero(t)
                        for k, v in pairs(t) do t[k] = v * 0 end
                    end

                    function Input.StartCapture()
                        CAS:BindActionAtPriority("PCFreecamKeyboard", Keypress, false, INPUT_PRIORITY,
                            Enum.KeyCode.W, Enum.KeyCode.U, Enum.KeyCode.A, Enum.KeyCode.H,
                            Enum.KeyCode.S, Enum.KeyCode.J, Enum.KeyCode.D, Enum.KeyCode.K,
                            Enum.KeyCode.E, Enum.KeyCode.I, Enum.KeyCode.Q, Enum.KeyCode.Y,
                            Enum.KeyCode.Up, Enum.KeyCode.Down)
                        CAS:BindActionAtPriority("PCFreecamMousePan", MousePan, false, INPUT_PRIORITY, Enum.UserInputType.MouseMovement)
                        CAS:BindActionAtPriority("PCFreecamMouseWheel", MouseWheel, false, INPUT_PRIORITY, Enum.UserInputType.MouseWheel)
                        CAS:BindActionAtPriority("PCFreecamGamepadButton", GpButton, false, INPUT_PRIORITY, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
                        CAS:BindActionAtPriority("PCFreecamGamepadTrigger", Trigger, false, INPUT_PRIORITY, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
                        CAS:BindActionAtPriority("PCFreecamGamepadThumbstick", Thumb, false, INPUT_PRIORITY, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
                    end

                    function Input.StopCapture()
                        navSpeed = 1
                        Zero(gamepad); Zero(keyboard); Zero(mouse)
                        for _, name in ipairs({ "PCFreecamKeyboard", "PCFreecamMousePan", "PCFreecamMouseWheel",
                            "PCFreecamGamepadButton", "PCFreecamGamepadTrigger", "PCFreecamGamepadThumbstick" }) do
                            pcall(function() CAS:UnbindAction(name) end)
                        end
                    end
                end

                local function StepFreecam(dt)
                    local camera = workspace.CurrentCamera
                    if not camera then return end
                    local vel = velSpring:Update(dt, Input.Vel(dt))
                    local pan = panSpring:Update(dt, Input.Pan(dt))
                    local fov = fovSpring:Update(dt, Input.Fov(dt))

                    local zoomFactor = sqrt(tan(rad(70 / 2)) / tan(rad(cameraFov / 2)))
                    cameraFov = clamp(cameraFov + fov * FOV_GAIN * (dt / zoomFactor), 1, 120)
                    cameraRot = cameraRot + pan * PAN_GAIN * (dt / zoomFactor)
                    cameraRot = Vector2.new(clamp(cameraRot.X, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.Y % (2 * pi))

                    local cf = CFrame.new(cameraPos) * CFrame.fromOrientation(cameraRot.X, cameraRot.Y, 0)
                        * CFrame.new(vel * NAV_GAIN * dt)
                    cameraPos = cf.Position

                    camera.CFrame = cf
                    camera.Focus = cf
                    camera.FieldOfView = cameraFov
                end

                -- estado de la camara/mouse que se restaura al salir (NO se esconde ninguna GUI)
                local saved

                function Freecam.Start()
                    if Freecam.Active then return end
                    local camera = workspace.CurrentCamera
                    if not camera then return end

                    local cf = camera.CFrame
                    cameraRot = Vector2.new(cf:ToEulerAnglesYXZ())
                    cameraPos = cf.Position
                    cameraFov = camera.FieldOfView
                    velSpring:Reset(Vector3.new())
                    panSpring:Reset(Vector2.new())
                    fovSpring:Reset(0)

                    saved = {
                        fov = camera.FieldOfView,
                        ctype = camera.CameraType,
                        cframe = camera.CFrame,
                        focus = camera.Focus,
                        mouse = UserInputService.MouseBehavior,
                    }
                    camera.CameraType = Enum.CameraType.Custom
                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default

                    Freecam.Active = true
                    RunService:BindToRenderStep(STEP_NAME, Enum.RenderPriority.Camera.Value, StepFreecam)
                    Input.StartCapture()
                end

                function Freecam.Stop()
                    if not Freecam.Active then return end
                    Freecam.Active = false
                    Input.StopCapture()
                    pcall(function() RunService:UnbindFromRenderStep(STEP_NAME) end)

                    local camera = workspace.CurrentCamera
                    if camera and saved then
                        camera.FieldOfView = saved.fov
                        camera.CameraType = saved.ctype
                        camera.CFrame = saved.cframe
                        camera.Focus = saved.focus
                    end
                    if saved then UserInputService.MouseBehavior = saved.mouse end
                    saved = nil
                end
            end
            genv.pchaxx13_FreecamStop = function() Freecam.Stop() end

            -- ---------- CAMERA ----------
            if genv.pchaxx13_CamConn then pcall(function() genv.pchaxx13_CamConn:Disconnect() end) end
            genv.pchaxx13_CamConn = nil
            genv.pchaxx13_Stretch = false

            local currentCam = workspace.CurrentCamera
            local Cam = {
                Fov = false,  FovV = math.clamp(currentCam and currentCam.FieldOfView or 70, 30, 120), OrigFov = nil,
                Asp = false,  AspV = 0.75,
                Zoom = false, ZoomV = 300, OrigZoom = nil,
                Conn = nil,
            }

            local function camStep()
                local cam = workspace.CurrentCamera
                if Cam.Fov and cam and not Freecam.Active then cam.FieldOfView = Cam.FovV end
                if Cam.Zoom then LocalPlayer.CameraMaxZoomDistance = Cam.ZoomV end
                if Cam.Asp and cam then
                    -- estira la imagen (stretched res): 1 = normal, menos de 1 = mas ancho
                    cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, Cam.AspV, 0, 0, 0, 1)
                end
            end

            local function camRefresh()
                genv.pchaxx13_Stretch = Cam.Asp and true or false
                local any = Cam.Fov or Cam.Asp or Cam.Zoom
                if any and not Cam.Conn then
                    Cam.Conn = RunService.RenderStepped:Connect(function()
                        local ok, err = pcall(camStep)
                        if not ok then report("camera", err) end
                    end)
                    genv.pchaxx13_CamConn = Cam.Conn
                elseif not any and Cam.Conn then
                    Cam.Conn:Disconnect()
                    Cam.Conn = nil
                    genv.pchaxx13_CamConn = nil
                end
            end

            local function camSlider(name, flag, def, min, max, step, suffix, cb)
                CamSec:Slider({
                    Name = name, Flag = flag, Default = math.clamp(def, min, max),
                    Min = min, Max = max, Decimals = step, Suffix = suffix or "",
                    Callback = cb,
                })
            end

            -- FOV
            CamSec:Toggle({
                Name = "FOV", Flag = "pc_cam_fov", Default = false,
                Callback = function(v)
                    local cam = workspace.CurrentCamera
                    if v then
                        if cam and not Cam.OrigFov then Cam.OrigFov = cam.FieldOfView end
                        Cam.Fov = true
                    else
                        Cam.Fov = false
                        if cam and Cam.OrigFov then cam.FieldOfView = Cam.OrigFov end
                        Cam.OrigFov = nil
                    end
                    camRefresh()
                end,
            })
            camSlider("Field of view", "pc_cam_fov_v", Cam.FovV, 30, 120, 1, " deg", function(v) Cam.FovV = v end)

            -- Aspect ratio
            CamSec:Toggle({
                Name = "Aspect ratio", Flag = "pc_cam_asp", Default = false,
                Callback = function(v) Cam.Asp = v and true or false; camRefresh() end,
            })
            camSlider("Ratio", "pc_cam_asp_v", Cam.AspV, 0.2, 1.3, 0.01, "", function(v) Cam.AspV = v end)

            -- Max zoom
            CamSec:Toggle({
                Name = "Max zoom", Flag = "pc_cam_zoom", Default = false,
                Callback = function(v)
                    if v then
                        if not Cam.OrigZoom then Cam.OrigZoom = LocalPlayer.CameraMaxZoomDistance end
                        Cam.Zoom = true
                    else
                        Cam.Zoom = false
                        if Cam.OrigZoom then LocalPlayer.CameraMaxZoomDistance = Cam.OrigZoom end
                        Cam.OrigZoom = nil
                    end
                    camRefresh()
                end,
            })
            camSlider("Distance", "pc_cam_zoom_v", Cam.ZoomV, 10, 1000, 10, " st", function(v) Cam.ZoomV = v end)

            -- Freecam (toggle + keybind de una letra, igual que el Aimlock; no esconde nada)
            local freeOn = false
            local freeT = CamSec:Toggle({
                Name = "Freecam", Flag = "pc_cam_free", Default = false,
                Callback = function(v)
                    freeOn = v and true or false
                    if not freeOn then Freecam.Stop() end
                end,
            })
            freeT:Keybind({
                Name = "Freecam", Flag = "pc_cam_free_key", Default = Enum.KeyCode.P, Mode = "Toggle",
                Callback = keyCallback("pc_cam_free_key", function(Value, mode)
                    if not freeOn then return end
                    if mode == "Hold" then
                        if Value then Freecam.Start() else Freecam.Stop() end
                    elseif mode == "Always On" then
                        Freecam.Start()
                    else
                        if Freecam.Active then Freecam.Stop() else Freecam.Start() end
                    end
                end),
            })

            -- ---------- LAYOUT: Aura y China hat DEBAJO de Players/Settings ----------
            local okL, errL = pcall(function()
                local content = Sub.Items.PageContent.Instance
                local lay = content:FindFirstChildOfClass("UIListLayout")
                lay.FillDirection = Enum.FillDirection.Vertical
                lay.HorizontalFlex = Enum.UIFlexAlignment.None
                lay.VerticalFlex = Enum.UIFlexAlignment.None
                lay.Padding = UDim.new(0, 15)

                local function makeRow(order, scaleY, offY)
                    local row = Instance.new("Frame")
                    row.Name = "\0row" .. order
                    row.BackgroundTransparency = 1
                    row.BorderSizePixel = 0
                    row.LayoutOrder = order
                    row.Size = UDim2.new(1, 0, scaleY, offY)
                    local rl = Instance.new("UIListLayout")
                    rl.FillDirection = Enum.FillDirection.Horizontal
                    rl.HorizontalFlex = Enum.UIFlexAlignment.Fill
                    rl.VerticalFlex = Enum.UIFlexAlignment.Fill
                    rl.SortOrder = Enum.SortOrder.LayoutOrder
                    rl.Padding = UDim.new(0, 15)
                    rl.Parent = row
                    row.Parent = content
                    return row
                end
                local row1 = makeRow(1, 0.55, -8)
                local row2 = makeRow(2, 0.45, -7)

                local function place(sec, row, order)
                    local o = sec.Items.Outline.Instance
                    o.LayoutOrder = order
                    o.Parent = row
                end
                place(Left, row1, 1)
                place(CS, row1, 2)
                place(CamSec, row2, 1)
                place(AuraSec, row2, 2)
            end)
            if not okL then report("layout aura/china hat", errL) end
        end)
        if not okPA then report("aura / china hat", errPA) end
        end
    end)

    runSection("Misc", function()
        local Sub = CombatPage:SubPage({ Name = "Misc" })
        styleTab(Sub, "rbxassetid://5402357141")
        Sub:Section({ Name = "Misc" })
    end)

    local okS, errS = pcall(function() Library:CreateSettingsPage(Window, KeybindList, Watermark) end)
    if not okS then warn("[pchaxx13] Settings page: " .. tostring(errS)) end
    -- Tabs de la pagina de Settings (Menu / Theme / Configs): solo la altura, igual que los tabs principales (el icono no se toca)
    pcall(function()
        local SettingsPage = Window.Pages[#Window.Pages]
        for _, sub in ipairs(SettingsPage.SubPages) do
            pcall(function() sub.Items.Inactive.Instance.Size = UDim2.new(1, 0, 0, TAB_HEIGHT) end)
        end
    end)

    -- Player indicator e Inventory viewer arrancan desactivados
    for _, flag in ipairs({ "Player Indicator", "Inventory Viewer" }) do
        local setter = Library.SetFlags and Library.SetFlags[flag]
        if setter then pcall(setter, false) end
    end
    pcall(function() if Library.IndicatorObj then Library.IndicatorObj:SetVisibility(false) end end)
    pcall(function() if Library.InventoryObj then Library.InventoryObj:SetVisibility(false) end end)

    setStatus()
end

do
    Loader:Set("lib", "loading")
    -- was downloading in parallel since the start; timeout so a hung download can't freeze the loader forever
    local tWait = os.clock()
    while not Loader.LibDone and os.clock() - tWait < 20 do task.wait() end
    local ok, Library, why = false, nil, nil
    if not Loader.LibDone then
        why = "timeout"
    else
        local src = Loader.LibSrc
        if not src or src == "" then
            local okH, s2 = pcall(function() return game:HttpGet(PANDORA_URL) end)
            src = okH and s2 or nil
        end
        if not src or src == "" then
            why = "download failed"
        elseif src:find("pchaxx13_LOADER", 1, true) then
            -- library.lua is this very script (not the UI library): running it would relaunch the loader forever
            why = "wrong library.lua"
        else
            ok, Library = pcall(function() return loadstring(src)() end)
            if not (ok and Library) then why = "load error" end
        end
    end
    local libOk = (ok and Library) and true or false
    Loader:Set("lib", libOk and "ok" or "fail", libOk and "ready" or (why or "error"))

    -- the loading screen disappears first...
    Loader:Finish(not libOk and "UI library error" or nil, why)

    -- ...and only then the UI is built
    if ok and Library then
        local ok2, err = pcall(buildUI, Library)
        if not ok2 then warn("[pchaxx13] Error construyendo la UI: " .. tostring(err)) end
    else
        warn("[pchaxx13] No se pudo cargar la librería de UI (" .. tostring(why) .. "): " .. tostring(Library))
    end
end

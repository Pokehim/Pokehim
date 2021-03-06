-- API Calls
shared.notify = true
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/not-weuz/Lua/main/xlpui.lua"))()
local api = loadstring(game:HttpGet("https://raw.githubusercontent.com/not-weuz/xlpapi/main/api.lua"))()

if not isfolder("kocmoc") then makefolder("kocmoc") end
if isfile('kocmoc.xlp') == false then (syn and syn.request or http_request)({ Url = "http://127.0.0.1:6463/rpc?v=1",Method = "POST",Headers = {["Content-Type"] = "application/json",["Origin"] = "https://discord.com"},Body = game:GetService("HttpService"):JSONEncode({cmd = "INVITE_BROWSER",args = {code = "9vG8UJXuNf"},nonce = game:GetService("HttpService"):GenerateGUID(false)}),writefile('kocmoc.xlp', "discord")})end

-- Script temporary variables
local playerstatsevent = game:GetService("ReplicatedStorage").Events.RetrievePlayerStats
local statstable = playerstatsevent:InvokeServer()
local monsterspawners = game:GetService("Workspace").MonsterSpawners
local rarename

-- Script tables

local temptable = {
    version = "2.5.0",
    blackfield = "Ant Field",
    redfields = {},
    bluefields = {},
    whitefields = {},
    shouldiconvertballoonnow = false,
    balloondetected = false,
    puffshroomdetected = false,
    magnitude = 60,
    blacklist = {
        "e_mrFluk2281"
    },
    running = false,
    configname = "",
    tokenpath = game:GetService("Workspace").Collectibles,
    started = {
        vicious = false,
        mondo = false
    },
    detected = {
        vicious = false
    },
    tokensfarm = false,
    converting = false,
    honeystart = 0,
    grib = nil,
    gribpos = CFrame.new(0,0,0),
    honeycurrent = statstable.Totals.Honey,
    dead = false,
    float = false,
    pepsigodmode = false,
    pepsiautodig = false,
    alpha = false,
    beta = false,
    myhiveis = false,
    invis = false,
    sprouts = {
        detected = false,
        coords
    },
    cache = {
        autofarm = false,
        automondo = false,
        vicious = false
    },
    monstertypes = {"Ladybug", "Rhino", "Spider", "Scorpion", "Mantis", "Werewolf"}
}
for i,v in next, temptable.blacklist do if v == api.nickname then game.Players.LocalPlayer:Kick("You're blacklisted! Get clapped!") end end
if temptable.honeystart == 0 then temptable.honeystart = statstable.Totals.Honey end


for i,v in next, game:GetService("Workspace").MonsterSpawners:GetDescendants() do if v.Name == "TimerAttachment" then v.Name = "Attachment" end end
for i,v in next, game:GetService("Workspace").MonsterSpawners:GetChildren() do if v.Name == "RoseBush" then v.Name = "ScorpionBush" elseif v.Name == "RoseBush2" then v.Name = "ScorpionBush2" end end
for i,v in next, game:GetService("Workspace").FlowerZones:GetChildren() do if v:FindFirstChild("ColorGroup") then if v:FindFirstChild("ColorGroup").Value == "Red" then table.insert(temptable.redfields, v.Name) elseif v:FindFirstChild("ColorGroup").Value == "Blue" then table.insert(temptable.bluefields, v.Name) end else table.insert(temptable.whitefields, v.Name) end end
local flowertable = {}
for _,z in next, game:GetService("Workspace").Flowers:GetChildren() do table.insert(flowertable, z.Position) end
local collectorstable = {}
for _,v in next, getupvalues(require(game:GetService("ReplicatedStorage").Collectors).Exists) do for e,r in next, v do table.insert(collectorstable, e) end end
local fieldstable = {}
for _,v in next, game:GetService("Workspace").FlowerZones:GetChildren() do table.insert(fieldstable, v.Name) end
local toystable = {}
for _,v in next, game:GetService("Workspace").Toys:GetChildren() do table.insert(toystable, v.Name) end
local spawnerstable = {}
for _,v in next, game:GetService("Workspace").MonsterSpawners:GetChildren() do table.insert(spawnerstable, v.Name) end
local accesoriestable = {}
for _,v in next, game:GetService("ReplicatedStorage").Accessories:GetChildren() do if v.Name ~= "UpdateMeter" then table.insert(accesoriestable, v.Name) end end
table.sort(fieldstable)
table.sort(accesoriestable)
table.sort(toystable)
table.sort(spawnerstable)
table.sort(collectorstable)

-- config

local kocmoc = {
    rares = {},
    bestfields = {
        red = "Pepper Patch",
        white = "Coconut Field",
        blue = "Stump Field"
    },
    blacklistedfields = {},
    killerkocmoc = {},
    bltokens = {},
    toggles = {
        autofarm = false,
        farmclosestleaf = false,
        farmbubbles = false,
        autodig = false,
        farmrares = false,
        rgbui = false,
        farmflower = false,
        farmfuzzy = false,
        farmcoco = false,
        farmflame = false,
        farmclouds = false,
        killmondo = false,
        killvicious = false,
        loopspeed = false,
        loopjump = false,
        autoquest = false,
        autoboosters = false,
        autodispense = true,
        clock = true,
        freeantpass = false,
        honeystorm = false,
        autodoquest = false,
        disableseperators = false,
        npctoggle = false,
        loopfarmspeed = false,
        mobquests = false,
        traincrab = false,
        avoidmobs = false,
        farmsprouts = false,
        enabletokenblacklisting = false,
        farmunderballoons = false,
        farmsnowflakes = true,
        collectgingerbreads = true,
        collectcrosshairs = false,
        farmpuffshrooms = false
    },
    vars = {
        field = "Ant Field",
        convertat = 100,
        farmspeed = 60,
        prefer = "Tokens",
        walkspeed = 70,
        jumppower = 70,
        npcprefer = "All Quests",
        farmtype = "Walk"
    },
    dispensesettings = {
        blub = true,
        straw = true,
        treat = true,
        coconut = true,
        glue = true,
        rj = true,
        white = false,
        red = false,
        blue = false
    }
}

local defaultkocmoc = kocmoc

-- float pad

local floatpad = Instance.new("Part", game:GetService("Workspace"))
floatpad.CanCollide = false
floatpad.Anchored = true
floatpad.Transparency = 1
floatpad.Name = "FloatPad"

-- functions

function statsget() local StatCache = require(game.ReplicatedStorage.ClientStatCache) local stats = StatCache:Get() return stats end

function farm(trying)
    if temptable.started.mondo then
        if kocmoc.toggles.loopfarmspeed then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = kocmoc.vars.farmspeed end
        if kocmoc.vars.farmtype == "Walk" then api.walkTo(trying.Position) elseif kocmoc.vars.farmtype == "Pathfinding" then api.pathfind(trying.Position) end
    elseif (trying.Position-fieldposition).magnitude < 50 then
        if kocmoc.toggles.loopfarmspeed then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = kocmoc.vars.farmspeed end
        if kocmoc.vars.farmtype == "Walk" then api.walkTo(trying.Position) elseif kocmoc.vars.farmtype == "Pathfinding" then api.pathfind(trying.Position) end
    end
end

function disableall()
    if kocmoc.toggles.autofarm and not temptable.converting then
        temptable.cache.autofarm = true
        kocmoc.toggles.autofarm = false
    end
    if kocmoc.toggles.killmondo and not temptable.started.mondo then
        kocmoc.toggles.killmondo = false
        temptable.cache.automondo = true
    end
    if kocmoc.toggles.killvicious and not temptable.started.vicious then
        kocmoc.toggles.killvicious = false
        temptable.cache.vicious = true
    end
end

function enableall()
    if temptable.cache.autofarm then
        kocmoc.toggles.autofarm = true
        temptable.cache.autofarm = false
    end
    if temptable.cache.automondo then
        kocmoc.toggles.killmondo = true
        temptable.cache.automondo = false
    end
    if temptable.cache.vicious then
        kocmoc.toggles.killvicious = true
        temptable.cache.vicious = false
    end
end

function gettoken()
    task.wait()
    if temptable.running == false then
        for e,r in next, game:GetService("Workspace").Collectibles:GetChildren() do
            itb = false
            if r:FindFirstChildOfClass("Decal") and kocmoc.toggles.enabletokenblacklisting then
                if api.findvalue(kocmoc.bltokens, string.split(r:FindFirstChildOfClass("Decal").Texture, 'rbxassetid://')[2]) then
                    itb = true
                end
            end
            if r.Name == game.Players.LocalPlayer.Name and not r:FindFirstChild("got it") or tonumber((r.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <= temptable.magnitude and not r:FindFirstChild("got it") and not itb then
                farm(r) local val = Instance.new("IntValue",r) val.Name = "got it" break
            end
        end
    end
end

function converthoney()
    if temptable.converting then
        while game.Players.LocalPlayer.CoreStats.Pollen.Value > 1 and task.wait(1) and temptable.converting do
            if game.Players.LocalPlayer.CoreStats.Pollen.Value > 1 and temptable.converting and game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.TextBox.Text ~= "Stop Making Honey" and game.Players.LocalPlayer.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3 ~= Color3.new(201, 39, 28) or game.Players.LocalPlayer.CoreStats.Pollen.Value > 1 and temptable.converting and (game:GetService("Players").LocalPlayer.SpawnPos.Value.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 5 and shouldiconvertballoonnow then
                api.tween(1, game:GetService("Players").LocalPlayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0))
                game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking")
            elseif game.Players.LocalPlayer.CoreStats.Pollen.Value < 1 then
                task.wait(6)
                if game.Players.LocalPlayer.CoreStats.Pollen.Value < 1 then temptable.converting = false end
            end
        end
    end
end

function closestleaf()
    for i,v in next, game.Workspace.Flowers:GetChildren() do
        if temptable.running == false and tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude then
            farm(v)
            break
        end
    end
end

function getbubble()
    for i,v in next, game.workspace.Particles:GetChildren() do
        if string.find(v.Name, "Bubble") and temptable.running == false and tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude then
            farm(v)
            break
        end
    end
end

function getballoons()
    for i,v in next, game:GetService("Workspace").Balloons.FieldBalloons:GetChildren() do
        if v:FindFirstChild("BalloonRoot") and v:FindFirstChild("PlayerName") then
            if v:FindFirstChild("PlayerName").Value == game.Players.LocalPlayer.Name then
                if temptable.running == false and tonumber((v.BalloonRoot.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude then
                    farm(v.BalloonRoot)
                    break
                end
            end
        end
    end
end

function getflower()
    flowerrrr = flowertable[math.random(#flowertable)]if tonumber((flowerrrr-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) <=temptable.magnitude then if temptable.running == false then if kocmoc.toggles.loopfarmspeed then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = kocmoc.vars.farmspeed end api.walkTo(flowerrrr) end end
end

function getcloud()
    for i,v in next, game:GetService("Workspace").Clouds:GetChildren() do
        e = v:FindFirstChild("Plane")
        if e and temptable.running == false and tonumber((e.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude then
            farm(e)
            break
        end
    end
end

function getcoco()
    for i,v in next, game.workspace.Particles:GetChildren() do
        if v.Name == "WarningDisk" and v.BrickColor == BrickColor.new("Lime green") and temptable.running == false and tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude then
            farm(v)
            break
        end
    end
end

function getfuzzy()
    pcall(function()
        for i,v in next, game.workspace.Particles:GetChildren() do
            if v.Name == "DustBunnyInstance" and temptable.running == false and tonumber((v.Plane.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude then
                if v:FindFirstChild("Plane") then
                    farm(v:FindFirstChild("Plane"))
                    break
                end
            end
        end
    end)
end

function getflame()
    for i,v in next, game.workspace.Particles:GetChildren() do
        if v.Name == "FlamePart" and temptable.running == false and tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude then
            farm(v)
            break
        end
    end
end

function avoidmob()
    if kocmoc.toggles.avoidmobs then
        for i,v in next, game:GetService("Workspace").Monsters:GetChildren() do
            if v:FindFirstChild("Head") then
                if (v.Head.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude < 30 then
                    game.Players.LocalPlayer.Character.Humanoid.Jump = true
                end
            end
        end
    end
end

function getcrosshairs()
    for i,v in next, game.workspace.Particles:GetChildren() do
        if v.Name == "Crosshair" and temptable.running == false and tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude then
            if v ~= nil and v.BrickColor ~= BrickColor.new("Forest green") then farm(v) end
            break
        end
    end
end

function makequests()
    for i,v in next, game:GetService("Workspace").NPCs:GetChildren() do
        if v.Name ~= "Ant Challenge Info" and v.Name ~= "Bubble Bee Man 2" and v.Name ~= "Wind Shrine" and v.Name ~= "Gummy Bear" then if v:FindFirstChild("Platform") then if v.Platform:FindFirstChild("AlertPos") then if v.Platform.AlertPos:FindFirstChild("AlertGui") then if v.Platform.AlertPos.AlertGui:FindFirstChild("ImageLabel") then
            image = v.Platform.AlertPos.AlertGui.ImageLabel
            button = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.ActivateButton.MouseButton1Click
            if image.ImageTransparency == 0 then 
                api.tween(2,CFrame.new(v.Platform.Position.X, v.Platform.Position.Y+3, v.Platform.Position.Z))
                task.wait(3)
                for b,z in next, getconnections(button) do
                    z.Function()
                end
                task.wait(8)
                if image.ImageTransparency == 0 then
                    for b,z in next, getconnections(button) do
                        z.Function()
                    end
                end
            end
        end     
    end end end end end
end

-- gui

local ui = library.new(true, "????  kocmoc | "..temptable.version)
ui.ChangeToggleKey(Enum.KeyCode.Semicolon)

local homecategory = ui:Category("Home")
local main = ui:Category("Farming")
local combat = ui:Category("Combat")
local wayui = ui:Category("Waypoints")
--local timercat = ui:Category("Timers")
local misc = ui:Category("Misc")
local extrass = ui:Category("Extra")
local settings = ui:Category("Settings")

-- home category

local information = homecategory:Sector("Information")
information:Cheat("Label", "-- Thank you for using our script, "..api.nickname)
information:Cheat("Label", "-- Script version: "..temptable.version)
information:Cheat("Label", "-- Place version: "..game.PlaceVersion)
information:Cheat("Label", "-- Hide GUI Button: ;")
information:Cheat("Label", "-- Script by weuz_ and davidshavrov")
information:Cheat("Label", "-- Gained Honey: 0")
information:Cheat("Button", "-- Discord Invite", function() setclipboard("https://discord.gg/9vG8UJXuNf") end, {text="Copy"})
information:Cheat("Button", "-- Donation", function() setclipboard("https://qiwi.com/n/W33UZ") end, {text = 'Copy'})
local changelog = homecategory:Sector("Changelog")
changelog:Cheat("Label", "-- ???? Added Farm Puffshrooms")
changelog:Cheat("Label", "-- ???? Improved Farm Precise Crosshairs")

-- farming category

local farming = main:Sector("Farming")
farming:Cheat("Dropdown", "Field", function(Option) temptable.tokensfarm = false kocmoc.vars.field = Option end, {options=fieldstable})
farming:Cheat("Slider", "Convert at:", function(Value) kocmoc.vars.convertat = Value end, {min = 0, max = 100, suffix = "%"})
farming:Cheat("Checkbox", "Autofarm", function(State) kocmoc.toggles.autofarm = not kocmoc.toggles.autofarm end)
farming:Cheat("Checkbox", "Autodig", function(State) kocmoc.toggles.autodig = not kocmoc.toggles.autodig end)
farming:Cheat("Checkbox", "Auto Sprinkler", function(State) kocmoc.toggles.autosprinkler = not kocmoc.toggles.autosprinkler end)
farming:Cheat("Checkbox", "Farm Bubbles", function(State) kocmoc.toggles.farmbubbles = not kocmoc.toggles.farmbubbles end)
farming:Cheat("Checkbox", "Farm Flames", function(State) kocmoc.toggles.farmflame = not kocmoc.toggles.farmflame end)
farming:Cheat("Checkbox", "Farm Coconuts", function(State) kocmoc.toggles.farmcoco = not kocmoc.toggles.farmcoco end)
farming:Cheat("Checkbox", "Farm Precise Crosshairs", function(State) kocmoc.toggles.collectcrosshairs = not kocmoc.toggles.collectcrosshairs end)
farming:Cheat("Checkbox", "Farm Fuzzy Bombs", function(State) kocmoc.toggles.farmfuzzy = not kocmoc.toggles.farmfuzzy end)
farming:Cheat("Checkbox", "Farm Under Balloons", function(State) kocmoc.toggles.farmunderballoons = not kocmoc.toggles.farmunderballoons end)
farming:Cheat("Checkbox", "Farm Clouds", function(State) kocmoc.toggles.farmclouds = not kocmoc.toggles.farmclouds end)
farming:Cheat("Checkbox", "Farm Closest Leaves", function(State) kocmoc.toggles.farmclosestleaf = not kocmoc.toggles.farmclosestleaf end)

local farmingtwo = main:Sector("Farming")
farmingtwo:Cheat("Checkbox", "Auto Dispenser", function(State) kocmoc.toggles.autodispense = not kocmoc.toggles.autodispense end)
farmingtwo:Cheat("Checkbox", "Auto Field Boosters", function(State) kocmoc.toggles.autoboosters = not kocmoc.toggles.autoboosters end)
farmingtwo:Cheat("Checkbox", "Auto Wealth Clock", function(State) kocmoc.toggles.clock = not kocmoc.toggles.clock end)
farmingtwo:Cheat("Checkbox", "Auto Ginger Breads", function(State) kocmoc.toggles.collectgingerbreads = not kocmoc.toggles.collectgingerbreads end)
farmingtwo:Cheat("Checkbox", "Auto Free Antpasses", function(State) kocmoc.toggles.freeantpass = not kocmoc.toggles.freeantpass end)
farmingtwo:Cheat("Checkbox", "Farm Sprouts", function(State) kocmoc.toggles.farmsprouts = not kocmoc.toggles.farmsprouts end)
farmingtwo:Cheat("Checkbox", "Farm Puffshrooms", function(State) kocmoc.toggles.farmpuffshrooms = not kocmoc.toggles.farmpuffshrooms end)
farmingtwo:Cheat("Checkbox", "Farm Snowflakes ??????", function(State) kocmoc.toggles.farmsnowflakes = not kocmoc.toggles.farmsnowflakes end)
farmingtwo:Cheat("Checkbox", "Teleport To Rares ??????", function(State) kocmoc.toggles.farmrares = not kocmoc.toggles.farmrares end)
farmingtwo:Cheat("Checkbox", "Auto Accept/Confirm Quest", function(State) kocmoc.toggles.autoquest = not kocmoc.toggles.autoquest end)
farmingtwo:Cheat("Checkbox", "Auto Do Quests", function(State) kocmoc.toggles.autodoquest = not kocmoc.toggles.autodoquest end)
farmingtwo:Cheat("Checkbox", "Auto Honeystorm", function(State) kocmoc.toggles.honeystorm = not kocmoc.toggles.honeystorm end)

-- combat

local mobkill = combat:Sector("Combat")
mobkill:Cheat("Checkbox", "Train Crab", function(State) kocmoc.toggles.traincrab = not kocmoc.toggles.traincrab end)
mobkill:Cheat("Checkbox", "Kill Mondo", function(State) kocmoc.toggles.killmondo = not kocmoc.toggles.killmondo end)
mobkill:Cheat("Checkbox", "Kill Vicious", function(State) kocmoc.toggles.killvicious = not kocmoc.toggles.killvicious end)
mobkill:Cheat("Checkbox", "Avoid Mobs", function(State) kocmoc.toggles.avoidmobs = not kocmoc.toggles.avoidmobs end)

-- waypoints
local npctp = wayui:Sector("NPC")
for i,v in next, game:GetService("Workspace").NPCs:GetChildren() do npctp:Cheat("Button", v.Name, function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Platform.Position.X, v.Platform.Position.Y+3, v.Platform.Position.Z) end, {text = 'Teleport'}) end

local otps = wayui:Sector("Other")
otps:Cheat("Dropdown", "Field Teleports", function(Option) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").FlowerZones:FindFirstChild(Option).CFrame end, { options = fieldstable })
otps:Cheat("Dropdown", "Monster Teleports", function(Option) d = game:GetService("Workspace").MonsterSpawners:FindFirstChild(Option) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(d.Position.X, d.Position.Y+3, d.Position.Z) end, { options = spawnerstable })
otps:Cheat("Dropdown", "Toys Teleports", function(Option) d = game:GetService("Workspace").Toys:FindFirstChild(Option).Platform game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(d.Position.X, d.Position.Y+3, d.Position.Z) end, { options = toystable })
otps:Cheat("Button", "Teleport to hive", function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Players").LocalPlayer.SpawnPos.Value end, {text = ''})

-- misc

local miscc = misc:Sector("Misc")
miscc:Cheat("Button", "Hide nickname", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/not-weuz/Lua/main/nicknamespoofer.lua"))()end, { text = 'Spoof' })
miscc:Cheat("Button", "Ant Challenge Semi-Godmode", function(State) api.tween(1, CFrame.new(93.4228, 32.3983, 553.128)) task.wait(1) game.ReplicatedStorage.Events.ToyEvent:FireServer("Ant Challenge") game.Players.LocalPlayer.Character.HumanoidRootPart.Position = Vector3.new(93.4228, 42.3983, 553.128) task.wait(2) game.Players.LocalPlayer.Character.Humanoid.Name = 1 local l = game.Players.LocalPlayer.Character["1"]:Clone() l.Parent = game.Players.LocalPlayer.Character l.Name = "Humanoid" task.wait() game.Players.LocalPlayer.Character["1"]:Destroy() api.tween(1, CFrame.new(93.4228, 32.3983, 553.128)) task.wait(8) api.tween(1, CFrame.new(93.4228, 32.3983, 553.128)) end, {text=''})
miscc:Cheat("Checkbox", "Walk Speed", function(State) kocmoc.toggles.loopspeed = not kocmoc.toggles.loopspeed end)
miscc:Cheat("Checkbox", "Jump Power", function(State) kocmoc.toggles.loopjump = not kocmoc.toggles.loopjump end)

local miother = misc:Sector("Other")
miother:Cheat("Dropdown", "Equip Accesories", function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Accessory" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end, { options = accesoriestable })
miother:Cheat("Dropdown", "Equip Collectors", function(Option) local ohString1 = "Equip" local ohTable2 = { ["Mute"] = false, ["Type"] = Option, ["Category"] = "Collector" } game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2) end, { options = collectorstable })
miother:Cheat("Dropdown", "Generate Amulet", function(Option) local A_1 = Option.." Generator" local Event = game:GetService("ReplicatedStorage").Events.ToyEvent Event:FireServer(A_1) end, {	options = { "Supreme Star Amulet", "Diamond Star Amulet", "Gold Star Amulet","Silver Star Amulet","Bronze Star Amulet","Moon Amulet"}})
miother:Cheat("Button", "Export Stats Table", function() local StatCache = require(game.ReplicatedStorage.ClientStatCache)writefile("Stats_"..api.nickname..".json", StatCache:Encode()) end, {text = 'Export'})

local pepsimisc = misc:Sector("Pepsi Functions")
pepsimisc:Cheat("Label", "Anything from this sector was made by Pepsi")
pepsimisc:Cheat("Button", "Pepsi's Functions", function()
    Pepsi, dbg = Pepsi, dbg
    if not Pepsi then -- Loser
        loadstring(rawget(rawget(game:GetObjects("rbxassetid://3554165973"), 0x1):GetChildren(), 0x1).ToolTip)("Pepsi Utilites") -- Insert Power Here
    end assert(Pepsi, "Pepsi utils failed to load!") spawn(function()pcall(function()if (true or 2 == shared.devmode) and dbg.attach then pcall(dbg.attach, "pepsiswarm")end end)end)
    pepsimisc:Cheat("Checkbox", "Pepsi's Godmode", function(State)
        if temptable.pepsigodmode == false then
            temptable.pepsigodmode = true
            local tool = nil
            if kocmoc.toggles.autodig then
                tool = Pepsi.Tool()
            end
                if tool and autodig and dbg and dbg.sc and dbg.gse and (math.random(3) == 2 or Pepsi.IsMarked(tool, "scoop")) then
                    pcall(function()
                    pcall(dbg.sc, rawget(dbg.gse(tool:FindFirstChild("ClientScriptMouse")), "collectStart"), 11, ((shared.PepsiSwarm.mods.scoop and "GetMouseButtonsPressed") or "IsMouseButtonPressed"))
                    end)
                    if dbg and type(dbg.gse) == "function" then
                        pcall(function()
                            dbg.gse(Pepsi.Tool().ClientScriptMouse).onEquippedLocal(Pepsi.Mouse())
                        end)
                    end
                    Pepsi.Mark(tool, "scoop")
                end
            --end
            task.wait(0.5)
            local cam = Pepsi.GetCam()
            local cf, me = cam.CFrame, Pepsi.Lp
            local c, h = (me.Character or workspace:FindFirstChild(me.Name)), Pepsi.Human()
            h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            local nh = h:Clone()
            Pepsi.Mark(nh, "god")
            me.Character = nil
            nh:SetStateEnabled(15, false)
            nh:SetStateEnabled(1, false)
            nh:SetStateEnabled(0, false)
            nh.Parent = c
            h:Destroy()
            me.Character, cam.CameraSubject = c, nh
            Pepsi.Rs:wait()
            cam.CFrame = cf
            h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            local s = c:FindFirstChild("Animate")
            if s then
                s.Disabled = true
                Pepsi.Rs:wait()
                s.Disabled = false
            end
            delay(2, function()
                if nh then
                    nh.Health = 100
                end
            end)
            if dbg and type(dbg.gse) == "function" then
                pcall(function()
                    dbg.gse(Pepsi.Tool().ClientScriptMouse).onEquippedLocal(Pepsi.Mouse())
                end)
            end
        else
            temptable.pepsigodmode = false
            local me = Pepsi.Lp
            local c, h = (me.Character or workspace:FindFirstChild(me.Name)), Pepsi.Human()
            h:SetStateEnabled(15, true)
            h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
            me.Character = nil
            h:ChangeState(15)
            me.Character = c
            h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
            Pepsi.Mark(h, "god", false)
            if dbg and type(dbg.gse) == "function" then
                pcall(function() -- I would use securecall, however this game doesnt check that kinda stuff
                    dbg.gse(Pepsi.Tool().ClientScriptMouse).onEquippedLocal(Pepsi.Mouse())
                end)
            end
        end
    end)
    pepsimisc:Cheat("Checkbox", "Pepsi's Autodig", function(State)
        if temptable.pepsiautodig == false then
            temptable.pepsiautodig = true
                while temptable.pepsiautodig do
                    task.wait(0.01)
                    Pepsi.Obj({
                        dig = true
                    }, Pepsi.Char(), "ClickEvent", "FireServer", {namecall = true})
                    local k = 0
                    for _, c in pairs(Pepsi.GetChars()) do
                        k = 1 + k
                        if c and (kocmoc.toggles.autodig or kocmoc.toggles.autodig) then
                            Pepsi.Obj({
                                dig = true
                            }, c, "ClickEvent", "FireServer", {namecall = true})
                            task.wait(0.05)
                            if k % 2 == 1 then
                                if kocmoc.toggles.autodig or kocmoc.toggles.autodig then
                                    Pepsi.Obj({
                                        dig = true
                                    }, Pepsi.Char(), "ClickEvent", "FireServer", {namecall = true})
                                else
                                    return
                                end
                            end
                        end
                    end
                    task.wait()
                    Pepsi.Obj({
                        dig = true
                    }, workspace, "NPCs", "Onett", "ClickEvent", "FireServer", {namecall = true})
                end
            else
            end
            temptable.pepsiautodig = false
    end)
end, {text='Enable'})

-- extras

local extras = extrass:Sector("Extras")
extras:Cheat("Button", "Boost FPS", function()loadstring(game:HttpGet("https://raw.githubusercontent.com/not-weuz/Lua/main/fpsboost.lua"))()end, { text = 'Boost' })
extras:Cheat("Button", "Destroy Decals", function()loadstring(game:HttpGet("https://raw.githubusercontent.com/not-weuz/Lua/main/destroydecals.lua"))()end, { text = 'Destroy' })
extras:Cheat("Textbox", "Glider Speed", function(Value) local StatCache = require(game.ReplicatedStorage.ClientStatCache) local stats = StatCache:Get() stats.EquippedParachute = "Glider" local module = require(game:GetService("ReplicatedStorage").Parachutes) local st = module.GetStat local glidersTable = getupvalues(st) glidersTable[1]["Glider"].Speed = Value setupvalue(st, st[1]'Glider', glidersTable)
end)
extras:Cheat("Textbox", "Glider Float", function(Value) local StatCache = require(game.ReplicatedStorage.ClientStatCache) local stats = StatCache:Get() stats.EquippedParachute = "Glider" local module = require(game:GetService("ReplicatedStorage").Parachutes) local st = module.GetStat local glidersTable = getupvalues(st) glidersTable[1]["Glider"].Float = Value setupvalue(st, st[1]'Glider', glidersTable)
end)
extras:Cheat("Button", "Invisibility", function(State) api.teleport(CFrame.new(0,0,0)) wait(1) if game.Players.LocalPlayer.Character:FindFirstChild('LowerTorso') then Root = game.Players.LocalPlayer.Character.LowerTorso.Root:Clone() game.Players.LocalPlayer.Character.LowerTorso.Root:Destroy() Root.Parent = game.Players.LocalPlayer.Character.LowerTorso api.teleport(game:GetService("Players").LocalPlayer.SpawnPos.Value) end end)
extras:Cheat("Checkbox", "Float", function(State) temptable.float = not temptable.float end)

-- settings category

local farmsettings = settings:Sector("Autofarm Settings")
farmsettings:Cheat("Dropdown", "Prefer When Autofarming", function(Option) kocmoc.vars.prefer = Option end, {options = {"Tokens", "Other"}})
farmsettings:Cheat("Dropdown", "Tokens Collect Mode", function(Option) kocmoc.vars.farmtype = Option end, {options = {"Walk", "Pathfinding"}})
farmsettings:Cheat("Textbox", "Autofarming Walkspeed", function(Value) kocmoc.vars.farmspeed = Value end, {placeholder = "Default Value = 60"})
farmsettings:Cheat("Checkbox", "^ Loop Speed On Autofarming", function(State) kocmoc.toggles.loopfarmspeed = not kocmoc.toggles.loopfarmspeed end)
farmsettings:Cheat("Checkbox", "Walk In Field", function(State) kocmoc.toggles.farmflower = not kocmoc.toggles.farmflower end)
farmsettings:Cheat("Checkbox", "Enable Token Blacklisting", function(State) kocmoc.toggles.enabletokenblacklisting = not kocmoc.toggles.enabletokenblacklisting end)
farmsettings:Cheat("Slider", "Walk Speed", function(Value) kocmoc.vars.walkspeed = Value end, {min = 0, max = 120, suffix = "studs"})
farmsettings:Cheat("Slider", "Jump Power", function(Value) kocmoc.vars.jumppower = Value end, {min = 0, max = 120, suffix = "studs"})

local raresettings = settings:Sector("Tokens Settings")
raresettings:Cheat("Textbox", "Asset ID", function(Value) rarename = Value end, {placeholder = 'rbxassetid'})
raresettings:Cheat("Button", "Add Token To Rares List", function()
    table.insert(kocmoc.rares, rarename)
    game.CoreGui.xlpUI.Container.Categories.Settings.R["Tokens Settings"].Container["Rares List"]:Destroy()
    raresettings:Cheat("Dropdown", "Rares List", function(Option)
    end, {
        options = kocmoc.rares
    })
end, {text = 'Add'})
raresettings:Cheat("Button", "Remove Token From Rares List", function()
    table.remove(kocmoc.rares, api.tablefind(kocmoc.rares, rarename))
    game.CoreGui.xlpUI.Container.Categories.Settings.R["Tokens Settings"].Container["Rares List"]:Destroy()
    raresettings:Cheat("Dropdown", "Rares List", function(Option)
    end, {
        options = kocmoc.rares
    })
end, {text = 'Remove'})
raresettings:Cheat("Button", "Add Token To Blacklist", function()
    table.insert(kocmoc.bltokens, rarename)
    game.CoreGui.xlpUI.Container.Categories.Settings.R["Tokens Settings"].Container["Tokens Blacklist"]:Destroy()
    raresettings:Cheat("Dropdown", "Tokens Blacklist", function(Option)
    end, {
        options = kocmoc.bltokens
    })
end, {text = 'Add'})
raresettings:Cheat("Button", "Remove Token From Blacklist", function()
    table.remove(kocmoc.bltokens, api.tablefind(kocmoc.bltokens, rarename))
    game.CoreGui.xlpUI.Container.Categories.Settings.R["Tokens Settings"].Container["Tokens Blacklist"]:Destroy()
    raresettings:Cheat("Dropdown", "Tokens Blacklist", function(Option)
    end, {
        options = kocmoc.bltokens
    })
end, {text = 'Remove'})
raresettings:Cheat("Dropdown", "Tokens Blacklist", function(Option)end, {options = kocmoc.bltokens})
raresettings:Cheat("Dropdown", "Rares List", function(Option)end, {options = kocmoc.rares})

local dispsettings = settings:Sector("Auto Dispenser & Auto Boosters Settings")
dispsettings:Cheat("Checkbox", "Royal Jelly Dispenser", function(State) kocmoc.dispensesettings.rj = not kocmoc.dispensesettings.rj end)
dispsettings:Cheat("Checkbox", "Blueberry Dispenser", function(State) kocmoc.dispensesettings.blub = not kocmoc.dispensesettings.blub end)
dispsettings:Cheat("Checkbox", "Strawberry Dispenser", function(State) kocmoc.dispensesettings.straw = not kocmoc.dispensesettings.straw end)
dispsettings:Cheat("Checkbox", "Treat Dispenser", function(State) kocmoc.dispensesettings.treat = not kocmoc.dispensesettings.treat end)
dispsettings:Cheat("Checkbox", "Coconut Dispenser", function(State) kocmoc.dispensesettings.coconut = not kocmoc.dispensesettings.coconut end)
dispsettings:Cheat("Checkbox", "Glue Dispenser", function(State) kocmoc.dispensesettings.glue = not kocmoc.dispensesettings.glue end)
dispsettings:Cheat("Checkbox", "Mountain Top Booster", function(State) kocmoc.dispensesettings.white = not kocmoc.dispensesettings.white end)
dispsettings:Cheat("Checkbox", "Blue Field Booster", function(State) kocmoc.dispensesettings.blue = not kocmoc.dispensesettings.blue end)
dispsettings:Cheat("Checkbox", "Red Field Booster", function(State) kocmoc.dispensesettings.red = not kocmoc.dispensesettings.red end)

local guisettings = settings:Sector("GUI Settings")
guisettings:Cheat("Keybind", "Set toggle button", function(Value) ui.ChangeToggleKey(Value) game.CoreGui.xlpUI.Container.Categories.Home.L.Information.Container["-- Hide GUI Button: ;"].Title.Text = "-- Hide GUI Button: "..string.sub(tostring(Value), 14) end, {text = 'Set New'})
guisettings:Cheat("Dropdown", "GUI Options (Dropdown)", function(Option) if Option == "Color Reset" then game:GetService("CoreGui").xlpUI.Container.BackgroundColor3 = Color3.fromRGB(32,32,33) else game.CoreGui.xlpUI:Destroy() temptable.tokensfarm = false end end, { options = { "Destroy GUI", "Color Reset" } })
guisettings:Cheat("Checkbox", "Disable Separators", function(State)
    if kocmoc.toggles.disableseperators == false then
        kocmoc.toggles.disableseperators = true
        for i,v in next, game:GetService("CoreGui").xlpUI.Container:GetChildren() do
            if v.Name == "Separator" then
                v.Visible = false
            end
            task.wait()
        end
    else
        for i,v in next, game:GetService("CoreGui").xlpUI.Container:GetChildren() do
            if v.Name == "Separator" then
                v.Visible = true
            end
            task.wait()
        end
        kocmoc.toggles.disableseperators = false
    end
end)
guisettings:Cheat("Checkbox", "RGB GUI", function(State)
    if kocmoc.toggles.rgbui == false then
        kocmoc.toggles.rgbui = true
            while kocmoc.toggles.rgbui do
                for hue = 0, 255, 4 do
                    if kocmoc.toggles.rgbui then
                        game.CoreGui.xlpUI.Container.BorderColor3 = Color3.fromHSV(hue/256, 1, 1)
                        game.CoreGui.xlpUI.Container.BackgroundColor3 = Color3.fromHSV(hue/256, .5, .8)
                        task.wait()
                    end
                end
            end
        else
        end
        kocmoc.toggles.rgbui = false
end)
guisettings:Cheat("ColorPicker", "GUI Color", function(Value) game:GetService("CoreGui").xlpUI.Container.BackgroundColor3 = Value end)
guisettings:Cheat("Textbox", "GUI Transparency", function(Value)game:GetService("CoreGui").xlpUI.Container.BackgroundTransparency = Value for i,v in next, game:GetService("CoreGui").xlpUI.Container:GetChildren() do    if v.Name == "Separator" then    v.BackgroundTransparency = Value end end	game:GetService("CoreGui").xlpUI.Container.Shadow.ImageTransparency = Value end, { placeholder = "between 0 and 1"})

local kocmocs = settings:Sector("Configs")
kocmocs:Cheat("Textbox", "Config Name", function(Value) temptable.configname = Value end)
kocmocs:Cheat("Button", "Load Config", function() kocmoc = game:service'HttpService':JSONDecode(readfile("kocmoc/BSS_"..temptable.configname..".xlp")) end, {text = 'Load'})
kocmocs:Cheat("Button", "Save Config", function() writefile("kocmoc/BSS_"..temptable.configname..".xlp",game:service'HttpService':JSONEncode(kocmoc)) end, {text = 'Save'})
kocmocs:Cheat("Button", "Reset Config", function() kocmoc = defaultkocmoc end, {text = 'Reset'})

local fieldsettings = settings:Sector("Fields Settings")
fieldsettings:Cheat("Dropdown", "Best White Field", function(Option) kocmoc.bestfields.white = Option end, {options = temptable.whitefields})
fieldsettings:Cheat("Dropdown", "Best Red Field", function(Option) kocmoc.bestfields.red = Option end, {options = temptable.redfields})
fieldsettings:Cheat("Dropdown", "Best Blue Field", function(Option) kocmoc.bestfields.blue = Option end, {options = temptable.bluefields})
fieldsettings:Cheat("Dropdown", "Field", function(Option) temptable.blackfield = Option end, {options = fieldstable})
fieldsettings:Cheat("Button", "Add Field To Blacklist", function() table.insert(kocmoc.blacklistedfields, temptable.blackfield) game.CoreGui.xlpUI.Container.Categories.Settings.R["Fields Settings"].Container["Blacklisted Fields"]:Destroy() fieldsettings:Cheat("Dropdown", "Blacklisted Fields", function(Option) end, { options = kocmoc.blacklistedfields })end, {text = 'Add'})
fieldsettings:Cheat("Button", "Remove Field From Blacklist", function() table.remove(kocmoc.blacklistedfields, api.tablefind(kocmoc.blacklistedfields, temptable.blackfield)) game.CoreGui.xlpUI.Container.Categories.Settings.R["Fields Settings"].Container["Blacklisted Fields"]:Destroy() fieldsettings:Cheat("Dropdown", "Blacklisted Fields", function(Option) end, { options = kocmoc.blacklistedfields })end, {text = 'Remove'})
fieldsettings:Cheat("Dropdown", "Blacklisted Fields", function(Option) end, {options = kocmoc.blacklistedfields})

local aqs = settings:Sector("Auto Quest Settings")
aqs:Cheat("Dropdown", "Do NPC Quests", function(Option) kocmoc.vars.npcprefer = Option end, {options = {'All Quests', 'Bucko Bee', 'Brown Bear', 'Riley Bee', 'Polar Bear'}})
aqs:Cheat("Checkbox", "Do Monster Quests", function(State) kocmoc.toggles.mobquests = not kocmoc.toggles.mobquests end)
aqs:Cheat("Label", " ")
aqs:Cheat("Label", " ")
aqs:Cheat("Label", " ")
aqs:Cheat("Label", " ")
aqs:Cheat("Label", " ")

-- script

task.spawn(function() while task.wait() do
    if kocmoc.toggles.autofarm then
        if game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true) then
        local pollenprglbl = game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true)
        maxpollen = tonumber(pollenprglbl.Text:match("%d+$"))
        local pollencount = game.Players.LocalPlayer.CoreStats.Pollen.Value
        pollenpercentage = pollencount/maxpollen*100
        fieldselected = game:GetService("Workspace").FlowerZones[kocmoc.vars.field]
        if kocmoc.toggles.autodoquest and game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.Menus.Children.Quests.Content:FindFirstChild("Frame") then
            for i,v in next, game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.Menus.Children.Quests:GetDescendants() do
                if v.Name == "Description" then
                    if string.match(v.Parent.Parent.TitleBar.Text, kocmoc.vars.npcprefer) or kocmoc.vars.npcprefer == "All Quests" then
                        pollentypes = {'White Pollen', "Red Pollen", "Blue Pollen", "Blue Flowers", "Red Flowers", "White Flowers"}
                        text = v.Text
                        if api.returnvalue(fieldstable, text) and not string.find(v.Text, "Complete!") and not api.findvalue(kocmoc.blacklistedfields, api.returnvalue(fieldstable, text)) then
                            d = api.returnvalue(fieldstable, text)
                            fieldselected = game:GetService("Workspace").FlowerZones[d]
                            break
                        elseif api.returnvalue(pollentypes, text) and not string.find(v.Text, 'Complete!') then
                            d = api.returnvalue(pollentypes, text)
                            if d == "Blue Flowers" or d == "Blue Pollen" then
                                fieldselected = game:GetService("Workspace").FlowerZones[kocmoc.bestfields.blue]
                                break
                            elseif d == "White Flowers" or d == "White Pollen" then
                                fieldselected = game:GetService("Workspace").FlowerZones[kocmoc.bestfields.white]
                                break
                            elseif d == "Red Flowers" or d == "Red Pollen" then
                                fieldselected = game:GetService("Workspace").FlowerZones[kocmoc.bestfields.red]
                                break
                            end
                        elseif api.returnvalue(temptable.monstertypes, text) and kocmoc.toggles.mobquests and not string.find(text, "Complete!") then
                            goal = api.returnvalue(temptable.monstertypes, text)
                            for e,r in next, game:GetService("Workspace").MonsterSpawners:GetChildren() do
                                if string.match(r.Name, goal) and not r.Attachment.TimerGui.TimerLabel.Visible then
                                    api.tween(1,CFrame.new(r.Position.X, r.Position.Y+10, r.Position.Z))
                                    task.wait(1)
                                    while r.Attachment.TimerGui.TimerLabel.Visible == false and kocmoc.toggles.autofarm and kocmoc.toggles.autodoquest do
                                        task.wait()
                                        for index, monster in next, game:GetService("Workspace").Monsters:GetChildren() do
                                            if monster:FindFirstChild("Head") and (monster.Head.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude < 20 and string.match(r.Name, goal) then
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(monster.Head.Position.X+20, monster.Head.Position.Y, monster.Head.Position.Z)
                                                break
                                            else
                                                api.tween(1,CFrame.new(r.Position.X, r.Position.Y+10, r.Position.Z))
                                                task.wait(1)    
                                            end
                                        end
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
            end
        else
            fieldselected = game:GetService("Workspace").FlowerZones[kocmoc.vars.field]
        end
        fieldpos = CFrame.new(fieldselected.Position.X, fieldselected.Position.Y+3, fieldselected.Position.Z)
        fieldposition = fieldselected.Position
        if temptable.sprouts.detected and temptable.sprouts.coords and kocmoc.toggles.farmsprouts then
            fieldposition = temptable.sprouts.coords.Position
            fieldpos = temptable.sprouts.coords
        end
        if kocmoc.toggles.farmpuffshrooms then for i,v in next, workspace.Happenings.Puffshrooms:GetChildren() do if v:FindFirstChild("Puffball Stem") then fieldpos = v['Puffball Stem'].CFrame fieldposition = fieldpos.Position break end end end
        if tonumber(pollenpercentage) < tonumber(kocmoc.vars.convertat) then
            if not temptable.tokensfarm then
                api.tween(2, fieldpos)
                task.wait(2)
                temptable.tokensfarm = true
                if kocmoc.toggles.autosprinkler then game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"}) end
            else
                if kocmoc.toggles.killmondo then
                    while kocmoc.toggles.killmondo and game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") and not temptable.started.vicious do
                        temptable.started.mondo = true
                        while game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") do
                            disableall()
                            game:GetService("Workspace").Map.Ground.HighBlock.CanCollide = false 
                            mondopition = game.Workspace.Monsters["Mondo Chick (Lvl 8)"].Head.Position
                            api.tween(1, CFrame.new(mondopition.x, mondopition.y - 60, mondopition.z))
                            task.wait(1)
                            temptable.float = true
                        end
                        task.wait(.5) game:GetService("Workspace").Map.Ground.HighBlock.CanCollide = true temptable.float = false api.tween(.5, CFrame.new(73.2, 176.35, -167)) task.wait(1)
                        for i = 0, 300 do 
                            task.wait(.25) 
                            gettoken() 
                        end 
                        enableall() 
                        api.tween(2, fieldpos) 
                        temptable.started.mondo = false
                    end
                end
                if (fieldposition-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > temptable.magnitude then
                    api.tween(2, fieldpos)
                    task.wait(2)
                    if kocmoc.toggles.autosprinkler then game.ReplicatedStorage.Events.PlayerActivesCommand:FireServer({["Name"] = "Sprinkler Builder"}) end
                end
                if kocmoc.toggles.avoidmobs then avoidmob() end
                if kocmoc.vars.prefer == "Other" then
                    if kocmoc.toggles.farmflower then getflower() end
                    if kocmoc.toggles.farmclosestleaf then closestleaf() end
                    if kocmoc.toggles.farmbubbles then getbubble() end
                    if kocmoc.toggles.farmclouds then getcloud() end
                    if kocmoc.toggles.farmcoco then getcoco() end
                    if kocmoc.toggles.farmflame then getflame() end
                    if kocmoc.toggles.farmfuzzy then getfuzzy() end
                    if kocmoc.toggles.farmunderballoons then getballoons() end
                    if kocmoc.toggles.collectcrosshairs then getcrosshairs() end
                end
                gettoken()
                if kocmoc.vars.prefer == "Tokens" then
                    if kocmoc.toggles.farmflower then getflower() end
                    if kocmoc.toggles.farmclosestleaf then closestleaf() end
                    if kocmoc.toggles.farmbubbles then getbubble() end
                    if kocmoc.toggles.farmclouds then getcloud() end
                    if kocmoc.toggles.farmcoco then getcoco() end
                    if kocmoc.toggles.farmflame then getflame() end
                    if kocmoc.toggles.farmfuzzy then getfuzzy() end
                    if kocmoc.toggles.farmunderballoons then getballoons() end
                    if kocmoc.toggles.collectcrosshairs then getcrosshairs() end
                end
            end
        elseif tonumber(pollenpercentage) >= tonumber(kocmoc.vars.convertat) then
            temptable.tokensfarm = false
            api.tween(2, game:GetService("Players").LocalPlayer.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0))
            task.wait(2)
            temptable.converting = true
            repeat
            converthoney()
            until game.Players.LocalPlayer.CoreStats.Pollen.Value == 0
            if kocmoc.toggles.autoquest then makequests() end
        end
    end
end end end)


task.spawn(function()
    while task.wait(1) do
		if kocmoc.toggles.killvicious and temptable.detected.vicious and temptable.converting == false then
            temptable.started.vicious = true
            disableall()
			local vichumanoid = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
			for i,v in next, game.workspace.Particles:GetChildren() do
				for x in string.gmatch(v.Name, "Vicious") do
					if string.find(v.Name, "Vicious") then
						api.tween(1,CFrame.new(v.Position.x, v.Position.y, v.Position.z)) task.wait(1)
						api.tween(0.5, CFrame.new(v.Position.x, v.Position.y, v.Position.z)) task.wait(.5)
					end
				end
			end
			for i,v in next, game.workspace.Particles:GetChildren() do
				for x in string.gmatch(v.Name, "Vicious") do
                    while kocmoc.toggles.killvicious and temptable.detected.vicious do task.wait() if string.find(v.Name, "Vicious") then
                        for i=1, 4 do temptable.float = true vichumanoid.CFrame = CFrame.new(v.Position.x+10, v.Position.y, v.Position.z) task.wait(.3)
                        end
                    end end
                end
			end
            enableall()
			task.wait(1)
			temptable.float = false
            temptable.started.vicious = false
		end
	end
end)

game:GetService("Workspace").Particles.Folder2.ChildAdded:Connect(function(child)
    if child.Name == "Sprout" then
        temptable.sprouts.detected = true
        temptable.sprouts.coords = child.CFrame
    end
end)
game:GetService("Workspace").Particles.Folder2.ChildRemoved:Connect(function(child)
    if child.Name == "Sprout" then
        task.wait(30)
        temptable.sprouts.detected = false
        temptable.sprouts.coords = ""
    end
end)
Workspace.Particles.ChildAdded:Connect(function(instance)
    if string.find(instance.Name, "Vicious") then
        temptable.detected.vicious = true
    end
end)
Workspace.Particles.ChildRemoved:Connect(function(instance)
    if string.find(instance.Name, "Vicious") then
        temptable.detected.vicious = false
    end
end)

task.spawn(function() while task.wait(1) do
    temptable.honeycurrent = statsget().Totals.Honey
    if kocmoc.toggles.honeystorm then game.ReplicatedStorage.Events.ToyEvent:FireServer("Honeystorm") end
    if kocmoc.toggles.collectgingerbreads then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Gingerbread House") end
    if kocmoc.toggles.autodispense then
        if kocmoc.dispensesettings.rj then local A_1 = "Free Royal Jelly Dispenser" local Event = game:GetService("ReplicatedStorage").Events.ToyEvent Event:FireServer(A_1) end
        if kocmoc.dispensesettings.blub then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Blueberry Dispenser") end
        if kocmoc.dispensesettings.straw then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Strawberry Dispenser") end
        if kocmoc.dispensesettings.treat then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Treat Dispenser") end
        if kocmoc.dispensesettings.coconut then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Coconut Dispenser") end
        if kocmoc.dispensesettings.glue then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Glue Dispenser") end
    end
    if kocmoc.toggles.autoboosters then 
        if kocmoc.dispensesettings.white then game.ReplicatedStorage.Events.ToyEvent:FireServer("Field Booster") end
        if kocmoc.dispensesettings.red then game.ReplicatedStorage.Events.ToyEvent:FireServer("Red Field Booster") end
        if kocmoc.dispensesettings.blue then game.ReplicatedStorage.Events.ToyEvent:FireServer("Blue Field Booster") end
    end
    if kocmoc.toggles.clock then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Wealth Clock") end
    if kocmoc.toggles.freeantpass then game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Free Ant Pass Dispenser") end
    game.CoreGui.xlpUI.Container.Categories.Home.L["Information"].Container["-- Gained Honey: 0"].Title.Text = "-- Gained Honey: "..api.suffixstring(temptable.honeycurrent - temptable.honeystart)
end end)
task.spawn(function() while task.wait(0.001) do
    if kocmoc.toggles.farmpuffshrooms and kocmoc.toggles.autofarm then
        temptable.magnitude = 60
        for i,v in next, game:GetService("Workspace").Happenings.Puffshrooms:GetChildren() do
            for x in string.gmatch(v.Name, "Puffshroom") do
                if string.find(v.Name, "Puffshroom") then
                    temptable.magnitude = 15
                end
            end
        end
    end
    if kocmoc.toggles.traincrab then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-259, 111.8, 496.4) * CFrame.fromEulerAnglesXYZ(0, 110, 90) temptable.float = true temptable.float = false end
    if kocmoc.toggles.farmrares then for k,v in next, game.workspace.Collectibles:GetChildren() do decal = v:FindFirstChildOfClass("Decal") for e,r in next, kocmoc.rares do if decal.Texture == r or decal.Texture == "rbxassetid://"..r then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame break end end end end
    if kocmoc.toggles.autodig then if game.Players.LocalPlayer then if game.Players.LocalPlayer.Character then if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("ClickEvent", true) then clickevent = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("ClickEvent", true) or nil end end end if clickevent then clickevent:FireServer() end end end
end end)

game:GetService('RunService').Heartbeat:connect(function() 
    if kocmoc.toggles.autoquest then firesignal(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.NPC.ButtonOverlay.MouseButton1Click) end
    if kocmoc.toggles.loopspeed then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = kocmoc.vars.walkspeed end
    if kocmoc.toggles.loopjump then game.Players.LocalPlayer.Character.Humanoid.JumpPower = kocmoc.vars.jumppower end
end)

game:GetService('RunService').Heartbeat:connect(function()
    for i,v in next, game.Players.LocalPlayer.PlayerGui.ScreenGui:WaitForChild("MinigameLayer"):GetChildren() do for k,q in next, v:WaitForChild("GuiGrid"):GetDescendants() do if q.Name == "ObjContent" or q.Name == "ObjImage" then q.Visible = true end end end
end)

game:GetService('RunService').Heartbeat:connect(function() 
    if temptable.float then game.Players.LocalPlayer.Character.Humanoid.BodyTypeScale.Value = 0 floatpad.CanCollide = true floatpad.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y-3.75, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z) task.wait(0)  else floatpad.CanCollide = false end
end)

local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function() vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)task.wait(1)vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

task.spawn(function() while task.wait() do
    pos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    task.wait(0.0001)
    currentSpeed = (pos-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
    if currentSpeed > 0 then
        temptable.running = true
    else
        temptable.running = false
    end
end end)

task.spawn(function()while task.wait() do
    if kocmoc.toggles.farmsnowflakes then
        for i,v in next, temptable.tokenpath:GetChildren() do
            if v:FindFirstChildOfClass("Decal") and v:FindFirstChildOfClass("Decal").Texture == "rbxassetid://6087969886" and v.Transparency == 0 then
                api.tween(2, CFrame.new(v.Position.X, v.Position.Y+3, v.Position.Z))
                task.wait(2)
            end
        end
    end
end end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if kocmoc.toggles.autofarm then
            temptable.dead = true
            kocmoc.toggles.autofarm = false
            temptable.converting = false
            temptable.farmtoken = false
        end
        if temptable.dead then
            task.wait(30)
            temptable.dead = false
            kocmoc.toggles.autofarm = true local player = game.Players.LocalPlayer
            temptable.converting = false
            temptable.tokensfarm = true
        end
    end)
end)

for _,v in next, game.workspace.Collectibles:GetChildren() do
    if string.find(v.Name,"") then
        v:Destroy()
    end
end 

for _, part in next, workspace:FindFirstChild("FieldDecos"):GetDescendants() do if part:IsA("BasePart") then part.CanCollide = false part.Transparency = part.Transparency < 0.5 and 0.5 or part.Transparency task.wait() end end
for _, part in next, workspace:FindFirstChild("Decorations"):GetDescendants() do if part:IsA("BasePart") and (part.Parent.Name == "Bush" or part.Parent.Name == "Blue Flower") then part.CanCollide = false part.Transparency = part.Transparency < 0.5 and 0.5 or part.Transparency task.wait() end end

Game:GetService("LogService").MessageOut:Connect(function(Message, Type) if Type == Enum.MessageType.MessageWarning then d = 16759296 else return end api.webhook("https://discord.com/api/webhooks/924347479921680424/qkE0sD5kpa7mWB27aR9gYloOG5Du1_tm6PJK-GjJ2ARVvIziH9ZiV6mCJ0eFnwpcPKO9", d, "Script caught an error!, Version: "..temptable.version, Message) end)

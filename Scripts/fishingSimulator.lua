--#region waitForLoad
repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Workspace:FindFirstChild(game.Players.LocalPlayer.Name)
--#endregion

--------------------------------------------------
------------------- Init Data --------------------
--------------------------------------------------

--#region Get Services
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local GetDataStreams = game:GetService("ReplicatedStorage").CloudFrameShared.DataStreams

local PlayerLocal = game.Players.LocalPlayer
local PlayerCharacter = PlayerLocal.Character
local PlayerHumanoid = PlayerCharacter.Humanoid
local PlayerHumanoidRootPart = PlayerCharacter.HumanoidRootPart
--#endregion

--#region Init Data
local SCRIPTNAME = "אַרטהור"
local ISLANDLIST = {"Port Jackson", "Ancient Shores", "Shadow Isles", "Pharaoh's Dunes", "Eruption Island",
	"Monster's Borough" }
local SHOPLIST = { "Boat Store", "Raygan's Tavern", "Supplies Store", "Pets Store" }
local SEAMONLIST = { "GreatWhiteShark", "BigGreatWhiteShark", "NeonGreatWhiteShark", "KillerWhale", "NeonKillerWhale", "HammerheadShark"}
local folder_name = "artemis"
local file_name = PlayerLocal.Name .. "_settings.json"
settings = {}

local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end

function save_settings()
	if not isfolder(folder_name) then
		makefolder(folder_name)
	end
	writefile(folder_name .. "/" .. file_name, HttpService:JSONEncode(settings))
end

function read_settings()
	local status, value = pcall(function()
		if not isfolder(folder_name) then
			makefolder(folder_name)
		end
		return HttpService:JSONDecode(readfile(folder_name .. "/" .. file_name))
	end)
	if status then
		return value
	else
		settings.autoSellDelay = 0
		settings.boatSpeed = 85
		settings.boatSpeedToggle = false
		settings.playerSpeed = 30
		settings.playerJumpH = 50
		settings.playerMovementToggle = false
		settings.espToggle = false
        settings.espGreatWhiteShark = false
        settings.espBigGreatWhiteShark = false
        settings.espNeonGreatWhiteShark = false
        settings.espKillerWhale = false
        settings.espNeonKillerWhale = false
        settings.espHammerheadShark = false
		save_settings()
		return read_settings()
	end
end

settings = read_settings()
--#endregion

--------------------------------------------------
------------------ UI Library --------------------
--------------------------------------------------

--#region UI & Tab
local repo = 'https://raw.githubusercontent.com/its-arthur/artemis/main/Libs/'

local Library = loadstring(game:HttpGet(repo .. 'LinoriaLib.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    -- Set Center to true if you want the menu to appear in the center
    -- Set AutoShow to true if you want the menu to appear when it is created
    -- Position and Size are also valid options here
    -- but you do not need to define them unless you are changing them :)

    Title = SCRIPTNAME,
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    -- Creates a new tab titled Main
    ['Main'] = Window:AddTab('Main'),
    ['Misc'] = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
    ['Test'] = Window:AddTab('Test'),
}

--#endregion

--#region [Main] Sell
local autoSell = Tabs['Main']:AddLeftGroupbox('Sell Section')

autoSell:AddLabel('Sell Keybind :'):AddKeyPicker('Sell', {
    Default = 'Q',
    SyncToggleState = false,

    Mode = 'Hold', -- Modes: Always, Toggle, Hold

    Text = 'Auto sell Type :',
    NoUI = false,
})

autoSell:AddSlider('autoSellDelay', {
    Text = 'Delay :',
    Default = settings.autoSellDelay,
    Min = 0,
    Max = 5,
    Rounding = 1,
    Compact = false,
})

Options.autoSellDelay:OnChanged(function()
    settings.autoSellDelay = Options.autoSellDelay.Value
	save_settings()
end)
--#endregion

--#region [Main] Player Config
local playerConfig = Tabs['Main']:AddLeftGroupbox('Player Config')

playerConfig:AddSlider('playerSpeed', {
    Text = 'Walk Speed :',
    Default = settings.playerSpeed,
    Min = 25,
    Max = 100,
    Rounding = 1,
    Compact = false,
})

playerConfig:AddSlider('playerJumpH', {
    Text = 'Jump Height :',
    Default = settings.playerJumpH,
    Min = 50,
    Max = 100,
    Rounding = 1,
    Compact = false,
})

playerConfig:AddToggle('playerMovementToggle', {
    Text = 'Enable Player Movement',
    Default = settings.playerMovementToggle,
})

playerConfig:AddButton({
    Text = 'Infinite Jump',
    Func = function()
        game:GetService("UserInputService").JumpRequest:connect(function()
            game:GetService "Players".LocalPlayer.Character:FindFirstChildOfClass 'Humanoid':ChangeState("Jumping")
        end)
    end,
    DoubleClick = false,
})

playerConfig:AddLabel('Warning : Infinite Jump can not\nbe turn off.', true)

--#endregion

--#region [Main] Boat Config
local boatConfig = Tabs['Main']:AddLeftGroupbox('Boat Config')

boatConfig:AddSlider('boatSpeed', {
    Text = 'Boat Speed :',
    Default = settings.boatSpeed,
    Min = 15,
    Max = 190,
    Rounding = 1,
    Compact = false,
})

boatConfig:AddToggle('boatSpeedToggle', {
    Text = 'Enable Boat Speed',
    Default = settings.boatSpeedToggle,
})
--#endregion

--#region [Main] Teleport
local teleportList = Tabs['Main']:AddRightGroupbox('Teleport')

teleportList:AddButton({
    Text = 'Teleport to Boat',
    Func = function()
        -- repeat task.wait() until game.Workspace:FindFirstChild(("%s's Boat"):format(game.Players.LocalPlayer.Name)) 

		for i, v in pairs(game.Workspace:GetChildren()) do
			if v.Name == (PlayerLocal.Name .. "'s Boat") then
				teleport(v.Controller.VehicleSeat.CFrame + Vector3.new(0, 3, 0))
				boatTeleportCallBack(PlayerLocal.Name .. "'s Boat")
			end
		end
    end,
    DoubleClick = false,
})

teleportList:AddButton({
    Text = 'Teleport to Sunken Ship',
    Func = function()
        for i, v in pairs(game.Workspace:GetChildren()) do
			if string.find(v.Name, "ShipModel") then
				teleport(v.HitBox.CFrame)
				sunkenShipCallBack(v.Name)
				break
			end
		end
    end,
    DoubleClick = false,
})

teleportList:AddDropdown('islandTeleport', {
    Values = ISLANDLIST,
    Default = "--", -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Island List',
})

teleportList:AddDropdown('shopTeleport', {
    Values = SHOPLIST,
    Default = "--", -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Shop List',
})

teleportList:AddDropdown('playerTeleportList', {
    SpecialType = 'Player',
    Text = 'Player List',

    Callback = function(Value)
        playerSelected = Value
    end
})

teleportList:AddButton({
    Text = 'Teleport to Player',
    Func = function()
        for i,v in pairs(game.Players:GetPlayers()) do
            if playerSelected ~= nil and playerSelected ~= PlayerLocal.name then
                if string.lower(v.DisplayName) == string.lower(playerSelected) then
                    PlayerHumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame                
                end
            end
        end
    end,
    DoubleClick = false,
})



--#endregion

--#region [Main] ESP
local espConfig = Tabs['Main']:AddRightGroupbox('ESP')

espConfig:AddToggle('espToggle', {
    Text = 'Enable ESP',
    Default = settings.espToggle,

    Callback = function(Value)
        settings.espToggle = Value
        print(settings.espToggle)
    end
})

espConfig:AddDropdown('seaMonsterList', {
    Text = "Sea Monster List",
    Values = SEAMONLIST,
    Default = "--", -- number index of the value / string
    Multi = true, -- true / false, allows multiple choices to be selected
})

--#endregion

--#region [Misc] serverMisc
local serverMisc = Tabs['Misc']:AddLeftGroupbox('Server')

serverMisc:AddButton({
    Text = 'Rejoin',
    Func = function()
        game:GetService("TeleportService"):Teleport(2866967438, game.Players.LocalPlayer)
    end,
    DoubleClick = false,
})

serverMisc:AddButton({
    Text = 'Switch Server',
    Func = function()
        switchServer()
    end,
    DoubleClick = false,
})
--#endregion

--#region [Misc] toolsMisc
local toolsMisc = Tabs['Misc']:AddRightGroupbox('Tools')

toolsMisc:AddButton({
    Text = 'Infinite Yield',
    Func = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))();
    end,
    DoubleClick = false,
})
--#endregion

--#region [UI Settings] Menu
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- Example of dynamically-updating watermark with common traits (fps and ping)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter = FrameCounter + 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('%s | %s fps | %s ms'):format(
        SCRIPTNAME,
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library.KeybindFrame.Visible = true; -- todo: add a function for this

Library:OnUnload(function()
    WatermarkConnection:Disconnect()

    print('Unloaded!')
    Library.Unloaded = true
end)

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('artemis')
SaveManager:SetFolder('artemis/specific-game')

SaveManager:BuildConfigSection(Tabs['UI Settings'])

ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()
--#endregion

--#region [Test] test
local test = Tabs['Test']:AddLeftGroupbox('Test')

test:AddButton({
    Text = 'Bite',
    Func = function()
        GetDataStreams.FishBiting:InvokeServer()
    end,
    DoubleClick = false,
})

test:AddButton({
    Text = 'Catch',
    Func = function()
        GetDataStreams.FishCaught:FireServer()
    end,
    DoubleClick = false,
})
--#endregion

--------------------------------------------------
------------------ Function --------------------
--------------------------------------------------

--#region [autoSell] autoSell
task.spawn(function()
    while true do
        wait(settings.autoSellDelay)
        local state = Options.Sell:GetState()
        if state then
            print("Sell")
            GetDataStreams.processGameItemSold:InvokeServer("SellEverything")
        end

        if Library.Unloaded then break end
    end
end)
--#endregion

--#region [playerConfig] playerSpeed
Options.playerSpeed:OnChanged(function()
    settings.playerSpeed = Options.playerSpeed.Value
	save_settings()
end)
--#endregion

--#region [playerConfig] playerJumpH
Options.playerJumpH:OnChanged(function()
    settings.playerJumpH = Options.playerJumpH.Value
	save_settings()
end)
--#endregion

--#region [playerConfig] playerMovementToggle
Toggles.playerMovementToggle:OnChanged(function()
    settings.playerMovementToggle = Toggles.playerMovementToggle.Value
	save_settings()
end)

coroutine.resume(coroutine.create(function()
	while task.wait(0.1) do
		if settings.playerMovementToggle then
			PlayerHumanoid.WalkSpeed = settings.playerSpeed
			PlayerHumanoid.JumpPower = settings.playerJumpH
		else
			PlayerHumanoid.WalkSpeed = 30
			PlayerHumanoid.JumpPower = 50
		end
	end
end))
--#endregion

--#region [boatConfig] boatSpeed
Options.boatSpeed:OnChanged(function()
    settings.boatSpeed = Options.boatSpeed.Value
    print(settings.boatSpeed)
    save_settings()
end)
--#endregion

--#region [boatConfig] boatSpeedToggle
Toggles.boatSpeedToggle:OnChanged(function()
    settings.boatSpeedToggle = Toggles.boatSpeedToggle.Value
    save_settings()
end)

coroutine.resume(coroutine.create(function()
	while task.wait(0.1) do
		if settings.boatSpeedToggle then
			for i, v in pairs(game.Workspace:GetChildren()) do
				if v.Name == (PlayerLocal.Name .. "'s Boat") then
					v.Controller.VehicleSeat.MaxSpeed = tonumber(settings.boatSpeed)
				end
			end
		else
			for i, v in pairs(game.Workspace:GetChildren()) do
				if v.Name == (PlayerLocal.Name .. "'s Boat") then
					v.Controller.VehicleSeat.MaxSpeed = tonumber(65)
				end
			end
		end
	end
end))
--#endregion

--#region [Teleport] teleportCommand
function teleport(loc)
	bLocation = PlayerHumanoidRootPart.CFrame
	if PlayerHumanoid.Sit then
		PlayerHumanoid.Sit = false
	end
	wait()
	PlayerHumanoidRootPart.CFrame = loc
end
--#endregion

--region [Teleport] islandTeleport 
Options.islandTeleport:OnChanged(function()
    locationSelected = Options.islandTeleport.Value
    if locationSelected == "Port Jackson" then
        teleport(CFrame.new(1.8703980445862, 53.57190322876, -188.37982177734))
    elseif locationSelected == "Ancient Shores" then
        teleport(CFrame.new(-2436.431640625, 43.564971923828, -1683.4526367188))
    elseif locationSelected == "Shadow Isles" then
        teleport(CFrame.new(2196.9926757812, 43.491630554199, -2216.4543457031))
    elseif locationSelected == "Pharaoh's Dunes" then
        teleport(CFrame.new(-4142.74609375, 46.71378326416, 262.05679321289))
    elseif locationSelected == "Eruption Island" then
        teleport(CFrame.new(3022.9311523438, 52.347640991211, 1323.74609375))
    elseif locationSelected == "Monster's Borough" then
        teleport(CFrame.new(-3211.9047851562, 41.850345611572, 2735.306640625))
    end
end)
--#endregion

--#region [Teleport] shopTeleport
Options.shopTeleport:OnChanged(function()
    locationSelected = Options.shopTeleport.Value
    if locationSelected == "Boat Store" then
        GetDataStreams.EnterDoor:InvokeServer("BoatShopInterior", "Inside")
    elseif locationSelected == "Raygan's Tavern" then
        GetDataStreams.EnterDoor:InvokeServer("TavernInterior", "Inside")
    elseif locationSelected == "Supplies Store" then
        GetDataStreams.EnterDoor:InvokeServer("SuppliesStoreInterior", "MainEntrance")
    elseif locationSelected == "Pets Store" then
        GetDataStreams.EnterDoor:InvokeServer("PetShop", "MainEntrance")
    end
end)
--#endregion

--#region hasValue
function has_value (tab, val)
    for index, value in next, tab do
        if index == val then
            return true
        end
    end

    return false
end
--#endregion

--#region [Misc] serverHopCommand
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

function switchServer()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end
--#endregion

--#region [ESP] espConfig
Options.seaMonsterList:OnChanged(function()
    if has_value(Options.seaMonsterList.Value, 'GreatWhiteShark') then
        settings.espGreatWhiteShark = true
    else
        settings.espGreatWhiteShark = false
    end
    if has_value(Options.seaMonsterList.Value, 'BigGreatWhiteShark') then
        settings.espBigGreatWhiteShark = true
        
    else
        settings.espBigGreatWhiteShark = false
    end
    if has_value(Options.seaMonsterList.Value, 'NeonGreatWhiteShark') then
        settings.espNeonGreatWhiteShark = true
        
    else
        settings.espNeonGreatWhiteShark = false
    end
    if has_value(Options.seaMonsterList.Value, 'KillerWhale') then
        settings.espKillerWhale = true
        
    else
        settings.espKillerWhale = false
    end
    if has_value(Options.seaMonsterList.Value, 'NeonKillerWhale') then
        settings.espNeonKillerWhale = true
        
    else
        settings.espNeonKillerWhale = false
    end
    if has_value(Options.seaMonsterList.Value, 'HammerheadShark') then
        settings.espHammerheadShark = true
    else
        settings.espHammerheadShark = false
    end
    print(settings.espGreatWhiteShark)
    print(settings.espBigGreatWhiteShark)
    print(settings.espNeonGreatWhiteShark)
    print(settings.espKillerWhale)
    print(settings.espNeonKillerWhale)
    print(settings.espHammerheadShark)
end)

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/its-arthur/artemis/main/Libs/ESP.lua"))()
ESP.Players = false
ESP.Boxes = true
ESP.Names = true


local a,b,c,d,e,f = false,false,false,false,false,false
coroutine.resume(coroutine.create(function()
	while task.wait(0.1) do
		ESP:Toggle(settings.espToggle)
		if settings.espToggle == true then
			if a then
				a = true
				ESP:AddObjectListener(Workspace, {
					Name = "GreatWhiteShark",
					CustomName = "GreatWhiteShark",
					Color = Color3.fromRGB(0, 255, 68),
					IsEnabled = "GreatWhiteShark"
				})
			end
            if b then 
                b = true
                ESP:AddObjectListener(Workspace, {
					Name = "BigGreatWhiteShark",
					CustomName = "BigGreatWhiteShark",
					Color = Color3.fromRGB(255, 221, 0),
					IsEnabled = "BigGreatWhiteShark"
				})
            end
            if c then
                c = true
                ESP:AddObjectListener(Workspace, {
					Name = "NeonGreatWhiteShark",
					CustomName = "NeonGreatWhiteShark",
					Color = Color3.fromRGB(255, 0, 0),
					IsEnabled = "NeonGreatWhiteShark"
				})
            end
            if d then
                d = true
                ESP:AddObjectListener(Workspace, {
					Name = "KillerWhale",
					CustomName = "KillerWhale",
					Color = Color3.fromRGB(0, 89, 255),
					IsEnabled = "KillerWhale"
				})
            end
            if e then
                e = true
                ESP:AddObjectListener(Workspace, {
					Name = "NeonKillerWhale",
					CustomName = "NeonKillerWhale",
					Color = Color3.fromRGB(0, 255, 217),
					IsEnabled = "NeonKillerWhale"
				})
            end
            if f then
                f = true
                ESP:AddObjectListener(Workspace, {
					Name = "HammerheadShark",
					CustomName = "HammerheadShark",
					Color = Color3.fromRGB(255, 111, 0),
					IsEnabled = "HammerheadShark"
				})
            end
		elseif settings.espToggle == false then
			if not a then
				a = false
				ESP:AddObjectListener(Workspace, {
					Name = "GreatWhiteShark",
					CustomName = "GreatWhiteShark",
					Color = Color3.fromRGB(0, 255, 68),
					IsEnabled = "GreatWhiteShark"
				})
			end
            if not b then 
                b = false
                ESP:AddObjectListener(Workspace, {
					Name = "BigGreatWhiteShark",
					CustomName = "BigGreatWhiteShark",
					Color = Color3.fromRGB(255, 221, 0),
					IsEnabled = "BigGreatWhiteShark"
				})
            end
            if not c then
                c = false
                ESP:AddObjectListener(Workspace, {
					Name = "NeonGreatWhiteShark",
					CustomName = "NeonGreatWhiteShark",
					Color = Color3.fromRGB(255, 0, 0),
					IsEnabled = "NeonGreatWhiteShark"
				})
            end
            if not d then
                d = false
                ESP:AddObjectListener(Workspace, {
					Name = "KillerWhale",
					CustomName = "KillerWhale",
					Color = Color3.fromRGB(0, 89, 255),
					IsEnabled = "KillerWhale"
				})
            end
            if not e then
                e = false
                ESP:AddObjectListener(Workspace, {
					Name = "NeonKillerWhale",
					CustomName = "NeonKillerWhale",
					Color = Color3.fromRGB(0, 255, 217),
					IsEnabled = "NeonKillerWhale"
				})
            end
            if not f then
                f = false
                ESP:AddObjectListener(Workspace, {
					Name = "HammerheadShark",
					CustomName = "HammerheadShark",
					Color = Color3.fromRGB(255, 111, 0),
					IsEnabled = "HammerheadShark"
				})
            end
		end
		ESP.GreatWhiteShark = settings.espGreatWhiteShark
		ESP.BigGreatWhiteShark = settings.espBigGreatWhiteShark
		ESP.NeonGreatWhiteShark = settings.espNeonGreatWhiteShark
		ESP.KillerWhale = settings.espKillerWhale
		ESP.NeonKillerWhale = settings.espNeonKillerWhale
		ESP.HammerheadShark = settings.espHammerheadShark
	end
end))
--#endregion
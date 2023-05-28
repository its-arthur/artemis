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
local ISLANDLIST = { "Port Jackson", "Ancient Shores", "Shadow Isles", "Pharaoh's Dunes", "Eruption Island",
	"Monster's Borough" }
local SHOPLIST = { "Boat Store", "Raygan's Tavern", "Supplies Store", "Pets Store" }
local MAINCOLOR = Color3.fromRGB(49, 0, 128)



local folder_name = "ArthurHub"
local file_name = PlayerLocal.Name .. "_settings.json"
settings = {}

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
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/its-arthur/artemis/main/Libs/Orion.lua')))()
local Window = OrionLib:MakeWindow({
	Name = SCRIPTNAME,
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "OrionTest",
	IntroEnabled = true,
	IntroText = "סטאַרטינג סקריפּט"
})
local Main = Window:MakeTab({
	Name = "🚀ㅤ|ㅤMain",
	Icon = "",
	PremiumOnly = false
})

local Boat = Window:MakeTab({
	Name = "🚤ㅤ|ㅤBoat",
	Icon = "",
	PremiumOnly = false
})

local Teleport = Window:MakeTab({
	Name = "🌍ㅤ|ㅤTeleport",
	Icon = "",
	PremiumOnly = false
})

local Players = Window:MakeTab({
	Name = "👤ㅤ|ㅤPlayers",
	Icon = "",
	PremiumOnly = false
})

local Misc = Window:MakeTab({
	Name = "🔧ㅤ|ㅤMisc",
	Icon = "",
	PremiumOnly = false
})

local Test = Window:MakeTab({
	Name = "⚠️ㅤ|ㅤTest",
	Icon = "",
	PremiumOnly = false
})
--#endregion

--#region [AutoFish] Main
local AutoFishSection = Main:AddSection({
	Name = "Auto Fish Section"
})
--#endregion

--#region [Sell] Main
local SellSection = Main:AddSection({
	Name = "Sell All"
})

SellSection:AddBind({
	Name = "Sell All",
	Default = Enum.KeyCode.Q,
	Hold = false,
	Callback = function()
		GetDataStreams.processGameItemSold:InvokeServer("SellEverything")
		sellAllCallBack()
	end
})

local SellSection = Main:AddSection({
	Name = "Auto Sell All"
})

SellSection:AddSlider({
	Name = "Auto Sell Delay",
	Min = 0,
	Max = 10,
	Default = settings.autoSellDelay,
	Color = MAINCOLOR,
	Increment = 1,
	ValueName = "seconds",
	Callback = function(Value)
		settings.autoSellDelay = Value
		save_settings()
	end
})
--#endregion

--#region [ESP] Main
local ESPSection = Main:AddSection({
	Name = "ESP"
})

-- ESPSection:AddLabel("Green : Great White Shark")
-- ESPSection:AddLabel("Yellow : Big Great White Shark")
-- ESPSection:AddLabel("Red : Neon Great White Shark")
-- ESPSection:AddLabel("Blue : Killer Whale")
-- ESPSection:AddLabel("Light Blue : Neon Killer Whale")
-- ESPSection:AddLabel("Orange : Hammerhead Shark")

ESPSection:AddToggle({
	Name = "ESP",
	Default = settings.espToggle,
	Callback = function(Value)
		settings.espToggle = Value
		save_settings()
	end
})
--#endregion

--#region [BoatConfig] Boat
local BoatConfig = Boat:AddSection({
	Name = "Boat Config"
})

BoatConfig:AddButton({
	Name = "Teleport to boat",
	Callback = function()
		-- repeat task.wait() until game.Workspace:FindFirstChild(("%s's Boat"):format(game.Players.LocalPlayer.Name)) 

		for i, v in pairs(game.Workspace:GetChildren()) do
			if v.Name == (PlayerLocal.Name .. "'s Boat") then
				teleport(v.Controller.VehicleSeat.CFrame + Vector3.new(0, 3, 0))
				boatTeleportCallBack(PlayerLocal.Name .. "'s Boat")
			end
		end
	end
})

BoatConfig:AddSlider({
	Name = "Boat Speed",
	Min = 65,
	Max = 190,
	Default = settings.boatSpeed,
	Color = MAINCOLOR,
	Increment = 1,
	ValueName = "",
	Callback = function(Value)
		settings.boatSpeed = Value
		save_settings()
	end
})

BoatConfig:AddToggle({
	Name = "Enable Boat Speed",
	Default = settings.boatSpeedToggle,
	Callback = function(Value)
		settings.boatSpeedToggle = Value
		save_settings()
	end
})

--#endregion

--#region [IslandTeleport] Teleport
local TeleportToIsland = Teleport:AddSection({
	Name = "Island List"
})

TeleportToIsland:AddDropdown({
	Name = "Select Island",
	Default = "None",
	Options = ISLANDLIST,
	Callback = function(Value)
		locationSelected = Value
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
		islandTeleportCallBack(locationSelected)
	end
})
--#endregion

--#region [SunkenShipTeleport] Teleport
local TeleportToSunkenShip = Teleport:AddSection({
	Name = "Sunken Ship"
})

TeleportToSunkenShip:AddButton({
	Name = "Teleport to Sunken Ship",
	Callback = function()
		for i, v in pairs(game.Workspace:GetChildren()) do
			if string.find(v.Name, "ShipModel") then
				teleport(v.HitBox.CFrame)
				sunkenShipCallBack(v.Name)
				break
			end
		end
	end
})
--#endregion

--#region [ShopTeleport] Teleport
local TeleportToShop = Teleport:AddSection({
	Name = "Shop List"
})

TeleportToShop:AddDropdown({
	Name = "Select Shop",
	Default = "None",
	Options = SHOPLIST,
	Callback = function(Value)
		locationSelected = Value
		if locationSelected == "Boat Store" then
			GetDataStreams.EnterDoor:InvokeServer("BoatShopInterior", "Inside")
		elseif locationSelected == "Raygan's Tavern" then
			GetDataStreams.EnterDoor:InvokeServer("TavernInterior", "Inside")
		elseif locationSelected == "Supplies Store" then
			GetDataStreams.EnterDoor:InvokeServer("SuppliesStoreInterior", "MainEntrance")
		elseif locationSelected == "Pets Store" then
			GetDataStreams.EnterDoor:InvokeServer("PetShop", "MainEntrance")
		end
		shopTeleportCallBack(locationSelected)
	end
})
--endregion

--#region [Players] Players
Players:AddSlider({
	Name = "Walk Speed",
	Min = 30,
	Max = 100,
	Default = settings.playerSpeed,
	Color = MAINCOLOR,
	Increment = 1,
	ValueName = "",
	Callback = function(Value)
		settings.playerSpeed = Value
		save_settings()
	end
})

Players:AddSlider({
	Name = "Jump Height",
	Min = 50,
	Max = 100,
	Default = settings.playerJumpH,
	Color = MAINCOLOR,
	Increment = 1,
	ValueName = "",
	Callback = function(Value)
		settings.playerJumpH = Value
		save_settings()
	end
})

Players:AddToggle({
	Name = "Enable Player Movement",
	Default = settings.playerMovementToggle,
	Callback = function(Value)
		settings.playerMovementToggle = Value
		save_settings()
	end
})

local infiniteJumpStatus = Players:AddParagraph("Infinite Jump Status", "Warning : Infinite Jump can not be turn off.")

Players:AddButton({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(Value)
		Value = true
		infiniteJump(Value)
		infiniteJumpStatus:Set("Infinite Jump has been activated.")
	end
})
--#endregion

--#region [Misc] Misc
Misc:AddButton({
	Name = "Rejoin",
	Callback = function()
		game:GetService("TeleportService"):Teleport(2866967438, game.Players.LocalPlayer)
	end
})
Misc:AddButton({
	Name = "Infinite Yield",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))();
	end
})
Misc:AddButton({
	Name = "Delete UI",
	Callback = function()
		OrionLib:Destroy()
	end
})
--#endregion

--#region Test
Test:AddButton({
	Name = "Bite",
	Callback = function()
		GetDataStreams.FishBiting:InvokeServer()
	end
})

Test:AddButton({
	Name = "Catch",
	Callback = function()
		GetDataStreams.FishCaught:FireServer()
	end
})


--#endregion

--------------------------------------------------
------------------ Function --------------------
--------------------------------------------------

--#region Sell All
coroutine.resume(coroutine.create(function()
	while task.wait(settings.autoSellDelay) do
		if settings.autoSellDelay > 0 then
			print(settings.autoSellDelay)
			GetDataStreams.processGameItemSold:InvokeServer("SellEverything")
		end
	end
end))
--#endregion

--#region BoatSpeed
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

--#region ESP All
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
ESP.Players = false
ESP.Boxes = true
ESP.Names = true


local isAllOn = false
coroutine.resume(coroutine.create(function()
	while task.wait(0.1) do
		ESP:Toggle(settings.espToggle)
		if settings.espToggle == true then
			if isAllOn then
				isAllOn = true
				ESP:AddObjectListener(Workspace, {
					Name = "GreatWhiteShark",
					CustomName = "GreatWhiteShark",
					Color = Color3.fromRGB(0, 255, 68),
					IsEnabled = "GreatWhiteShark"
				})
				ESP:AddObjectListener(Workspace, {
					Name = "BigGreatWhiteShark",
					CustomName = "BigGreatWhiteShark",
					Color = Color3.fromRGB(255, 221, 0),
					IsEnabled = "BigGreatWhiteShark"
				})
				ESP:AddObjectListener(Workspace, {
					Name = "NeonGreatWhiteShark",
					CustomName = "NeonGreatWhiteShark",
					Color = Color3.fromRGB(255, 0, 0),
					IsEnabled = "NeonGreatWhiteShark"
				})
				ESP:AddObjectListener(Workspace, {
					Name = "KillerWhale",
					CustomName = "KillerWhale",
					Color = Color3.fromRGB(0, 89, 255),
					IsEnabled = "KillerWhale"
				})
				ESP:AddObjectListener(Workspace, {
					Name = "NeonKillerWhale",
					CustomName = "NeonKillerWhale",
					Color = Color3.fromRGB(0, 255, 217),
					IsEnabled = "NeonKillerWhale"
				})
				ESP:AddObjectListener(Workspace, {
					Name = "HammerheadShark",
					CustomName = "HammerheadShark",
					Color = Color3.fromRGB(255, 111, 0),
					IsEnabled = "HammerheadShark"
				})
			end
		elseif settings.espToggle == false then
			if not isAllOn then
				isAllOn = false
				ESP:AddObjectListener(Workspace, {
					Name = "GreatWhiteShark",
					CustomName = "GreatWhiteShark",
					Color = Color3.fromRGB(0, 255, 68),
					IsEnabled = "GreatWhiteShark"
				})
				ESP:AddObjectListener(Workspace, {
					Name = "BigGreatWhiteShark",
					CustomName = "BigGreatWhiteShark",
					Color = Color3.fromRGB(255, 221, 0),
					IsEnabled = "BigGreatWhiteShark"
				})
				ESP:AddObjectListener(Workspace, {
					Name = "NeonGreatWhiteShark",
					CustomName = "NeonGreatWhiteShark",
					Color = Color3.fromRGB(255, 0, 0),
					IsEnabled = "NeonGreatWhiteShark"
				})
				ESP:AddObjectListener(Workspace, {
					Name = "KillerWhale",
					CustomName = "KillerWhale",
					Color = Color3.fromRGB(0, 89, 255),
					IsEnabled = "KillerWhale"
				})
				ESP:AddObjectListener(Workspace, {
					Name = "NeonKillerWhale",
					CustomName = "NeonKillerWhale",
					Color = Color3.fromRGB(0, 255, 217),
					IsEnabled = "NeonKillerWhale"
				})
				ESP:AddObjectListener(Workspace, {
					Name = "HammerheadShark",
					CustomName = "HammerheadShark",
					Color = Color3.fromRGB(255, 111, 0),
					IsEnabled = "HammerheadShark"
				})
			end
		end
		ESP.GreatWhiteShark = settings.espToggle
		ESP.BigGreatWhiteShark = settings.espToggle
		ESP.NeonGreatWhiteShark = settings.espToggle
		ESP.KillerWhale = settings.espToggle
		ESP.NeonKillerWhale = settings.espToggle
		ESP.HammerheadShark = settings.espToggle
	end
end))
--#endregion

--#region Teleport
function teleport(loc)
	bLocation = PlayerHumanoidRootPart.CFrame
	if PlayerHumanoid.Sit then
		PlayerHumanoid.Sit = false
	end
	wait()
	PlayerHumanoidRootPart.CFrame = loc
end

--#endregion

--#region Notification
function sellAllCallBack()
	OrionLib:MakeNotification({
		Name = "Sell All Fish Successfully",
		Content = "You have sell everything in you inventory.",
		Image = "rbxassetid://4483345998",
		Time = 5
	})
end

function boatTeleportCallBack(boatName)
	OrionLib:MakeNotification({
		Name = "Teleport to Boat Successfully",
		Content = "Boat's Name : " .. boatName,
		Image = "rbxassetid://4483345998",
		Time = 5
	})
end

function islandTeleportCallBack(locationSelected)
	OrionLib:MakeNotification({
		Name = "Island Teleport Successfully.",
		Content = "Location : " .. locationSelected,
		Image = "rbxassetid://4483345998",
		Time = 5
	})
end

function sunkenShipCallBack(shipModel)
	if shipModel == "ShipModel5" or shipModel == "ShipModel6" then
		shipChestCount = 2
	else
		shipChestCount = 1
	end
	OrionLib:MakeNotification({
		Name = "Ship Found.",
		Content = "Chest Total : " .. shipChestCount,
		Image = "rbxassetid://4483345998",
		Time = 10
	})
end

function shopTeleportCallBack(locationSelected)
	OrionLib:MakeNotification({
		Name = "Shop Teleport Successfully.",
		Content = "Location : " .. locationSelected,
		Image = "rbxassetid://4483345998",
		Time = 5
	})
end

--#endregion

--#region Players Movement
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

--#region Infinite Jump
function infiniteJump(Value)
	game:GetService("UserInputService").JumpRequest:connect(function()
		if Value then
			game:GetService "Players".LocalPlayer.Character:FindFirstChildOfClass 'Humanoid':ChangeState("Jumping")
		end
	end)
end

--#endregion

OrionLib:Init()

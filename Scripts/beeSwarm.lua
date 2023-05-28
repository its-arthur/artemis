95.8183136, 29.7700119, 552.918335 --Ant Field
132.963409, 18.1719551, -25.6000061 --Bamboo Field
146.865021, 2.13494039, 100.725006 --Blue Flower Field
-188.5, 65.5000153, -101.595818 --Cactus Field
157.547073, 31.608448, 196.350006 --Clover Field
-254.478104, 68.9707947, 469.459045 --Coconut Field
-29.6986389, 1.5, 221.572845 --Dandelion Field
77.6849823, 173.500015, -165.431 --Mountain Top Field
-89.7000122, 1.95073581, 111.725006 --Mushroom Field
-327.459839, 17.5552464, 129.496735 --Rose Field
-43.4654312, 18.1220875, -13.5899963 --Spider Field
-178.174973, 18.1322384, -9.8549881 --Strawberry Field
424.483276, 94.4255676, -174.810959 --Stump Field
-208.951294, 1.5, 176.579224 --Sunflower Field

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Title of the library", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})
local a = Window:MakeTab({
	Name = "Tab 1",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Toggle = false
local stonkToggle = false
local showToggle = false
local type = "None"
local typeList = {"1","2","3","4","5",}

a:AddDropdown({
	Name = "Type Stonk",
	Default = "None",
	Options = typeList,
	Callback = function(Value)
		if va
	end
})


function activateStonk()
	coroutine.resume(coroutine.create(function()
		while task.wait(0.1) do
			if Toggle then
				if type == "Buy" then
					game.ReplicatedStorage.GLOBAL_VALUES.ConfigrationFolder.GlobalEvent:FireServer("Buy","Gold")
				elseif type == "Sell" then
					game.ReplicatedStorage.GLOBAL_VALUES.ConfigrationFolder.GlobalEvent:FireServer("Sell","Gold")
				end
			end
		end
	end))
end
activateStonk()

function stonkMode()
	coroutine.resume(coroutine.create(function()
		while task.wait(0.1) do
			if stonkToggle then
				goldPriceText:Set("Gold Price : "..game.ReplicatedStorage.GLOBAL_VALUES.Gold.Value)
				if game.ReplicatedStorage.GLOBAL_VALUES.Gold.Value < 200 then
					game.ReplicatedStorage.GLOBAL_VALUES.ConfigrationFolder.GlobalEvent:FireServer("Buy","Gold")
				elseif game.ReplicatedStorage.GLOBAL_VALUES.Gold.Value > 650 then
					game.ReplicatedStorage.GLOBAL_VALUES.ConfigrationFolder.GlobalEvent:FireServer("Sell","Gold")
				end
			end
		end
	end))
end
stonkMode()


OrionLib:Init()
teleport(CFrame.new(146.865021, 2.13494039, 100.725006)) --Blue Flower

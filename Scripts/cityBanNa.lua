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
local typeList = {"Buy","Sell"}

a:AddDropdown({
	Name = "Type Stonk",
	Default = "None",
	Options = typeList,
	Callback = function(Value)
		type = Value
	end
})
a:AddToggle({
	Name = "Toggle Stonk",
	Default = false,
	Callback = function(Value)
		Toggle = Value
	end    
})
a:AddToggle({
	Name = "Stonk Mode",
	Default = false,
	Callback = function(Value)
		stonkToggle = Value
	end    
})
goldPriceText = a:AddLabel("Gold Price : ")
a:AddToggle({
	Name = "Show Price",
	Default = false,
	Callback = function(Value)
		showToggle = Value
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

function showPrice()
	coroutine.resume(coroutine.create(function()
		while task.wait(0.1) do
			if showToggle then
				goldPriceText:Set("Gold Price : "..game.ReplicatedStorage.GLOBAL_VALUES.Gold.Value)
			end
		end
	end))
end
showPrice()
OrionLib:Init()
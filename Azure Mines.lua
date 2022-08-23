local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({Name = "End's Azure Mines Utility"})

local Main = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Misc = Window:MakeTab({
	Name = "Misc",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local Ore
local Raygun
local farming = false
local count
local deposit
local ESPtoggle

function addUi(part)
	local partgui = Instance.new("BillboardGui", part)
	partgui.Size = UDim2.new(1,0,1,0)
	partgui.AlwaysOnTop = true
	partgui.Name = "ESP"
	local frame = Instance.new("Frame", partgui)
	frame.BackgroundColor3 = Color3.fromRGB(255,80,60)
	frame.BackgroundTransparency = 0.75
	frame.Size = UDim2.new(1,0,1,0)
	frame.BorderSizePixel = 0
	local namegui = Instance.new("BillboardGui", part)
	namegui.Size = UDim2.new(3,0,1.5,0)
	namegui.SizeOffset = Vector2.new(0,1)
	namegui.AlwaysOnTop = true
	namegui.Name = "Namee"
	local text = Instance.new("TextLabel", namegui)
	text.Text = part.Name
	text.TextColor3 = Color3.fromRGB(255,80,60)
	text.TextTransparency = 0.25
	text.BackgroundTransparency = 1
	text.TextScaled = true
	text.Size = UDim2.new(1,0,1,0)
	text.Font = Enum.Font.GothamSemibold
	text.Name = "Text"
end

Misc:AddToggle({
	Name = "FullBright",
	Default = false,
	Callback = function(Value)
		local Lighting = game:GetService("Lighting")
		local stuff = {Lighting.GameBlur, Lighting.ColorCorrection, Lighting.Blur, Lighting.Bloom}
		if Value == true then
			for _, v in pairs(stuff) do
				v.Enabled = false
				game.Lighting.Atmosphere.Parent = game.ReplicatedStorage
			end
		else
			for _, v in pairs(stuff) do
				v.Enabled = true
				if game.ReplicatedStorage:FindFirstChild("Atmosphere") then
					game.ReplicatedStorage.Atmosphere.Parent = game.Lighting
				end
			end
		end

	end    
})

Main:AddDropdown({
	Name = "Select Ore",
	Default = "1",
	Options = {"Ambrosia", "Amethyst", "Antimatter", "Azure", "Baryte", "Boomite", "Coal", "Copper", "Constellatium", "Darkmatter", "Diamond", "Dragonglass", "Dragonstone", "Emerald", "Firecrystal", "Frightstone", "Frostarium", "Garnet", "Gold", "Illuminunium", "Iron", "Kappa", "Mithril", "Moonstone", "Newtonium", "Nightmarium", "Opal", "Painite", "Platinum", "Plutonium", "Pumpkinite", "Promethium", "Rainbonite", "Ruby", "Sapphire", "Silver", "Serendibite", "Sinistyte L", "Sinistyte M", "Sinistyte S", "Stellarite", "Stone", "Sulfur", "Symmetrium", "Topaz", "Twitchite", "Unobtainium", "Uranium"},
	Callback = function(Value)
		Ore = Value
	end    
})

Misc:AddToggle({
	Name = "Autofarm with Raygun [GAMEPASS NEEDED]",
	Default = false,
	Callback = function(Value)
		Raygun = Value
		if Raygun then
			
			if not game:GetService("Workspace").Players[game.Players.LocalPlayer.Name]:FindFirstChild("RayGun") then
				game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("RayGun").Parent = game:GetService("Workspace").Players[game.Players.LocalPlayer.Name]
				wait(0.1)
				game:GetService("Workspace").Players[game.Players.LocalPlayer.Name]:FindFirstChild("RayGun").Parent = game:GetService("Players").LocalPlayer.Backpack
			end
		end
		while Raygun do
			game.Players.LocalPlayer.Backpack.RayGun.Gun.Func:InvokeServer("Reload")
			wait(3)
		end
	end    
})

Main:AddToggle({
	Name = "Auto Deposit",
	Default = false,
	Callback = function(Value)
		deposit = Value
		while deposit do
			game.ReplicatedStorage.MoveAllItems:InvokeServer()
			task.wait(5)
		end
	end    
})

Main:AddButton({
	Name = "Teleport to Ore",
	Callback = function()
		for _,v in pairs(game.Workspace.Mine:GetChildren()) do
			if v.Name == Ore then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
				break
			end
		end
	end    
})

Main:AddToggle({
	Name = "Ore ESP",
	Default = false,
	Callback = function(Value)
		ESPtoggle = Value
		while ESPtoggle do
			task.wait(0.2)
			for _,v in pairs(game.Workspace.Mine:GetChildren()) do
				if v.Name == Ore and not v:FindFirstChildWhichIsA("BillboardGui") then
					addUi(v)
				end
			end
		end
		if not ESPtoggle then
			for _,v in pairs(game.Workspace.Mine:GetChildren()) do
				if v:FindFirstChild("ESP") then
					v.ESP:Destroy()
					v.Namee:Destroy()
				end
			end
		end
	end
})

Main:AddToggle({
	Name = "Enable Autofarm",
	Default = false,
	Callback = function(toggled)
		farming = toggled
		while farming do
			if not game:GetService("Workspace").Players[game.Players.LocalPlayer.Name]:FindFirstChild("Pickaxe") then
				game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pickaxe").Parent = game:GetService("Workspace").Players[game.Players.LocalPlayer.Name]
			end
			game.Workspace.Gravity = 0
			game:GetService("Workspace").Players[game.Players.LocalPlayer.Name].Pickaxe.PickaxeScript.Disabled = true
			task.wait(0.1)
			for _,v in pairs(game.Workspace.Mine:GetChildren()) do
				if not farming then
					break
				end
				if v.Name == Ore then
					v.CanCollide = false
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
					task.wait(0.1)
					game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
					if Raygun == true then
						game.Players.LocalPlayer.Backpack.RayGun.Gun.Func:InvokeServer("Fire", {Vector3.new(v.Position.X, v.Position.Y, v.Position.Z), 661203044677.2754, Vector3.new(v.Position.X, v.Position.Y-4, v.Position.Z)})
					end
					if not game:GetService("Workspace").Players[game.Players.LocalPlayer.Name]:FindFirstChild("Pickaxe") then
						game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pickaxe").Parent = game:GetService("Workspace").Players[game.Players.LocalPlayer.Name]
					end
					game:GetService("Workspace").Players[game.Players.LocalPlayer.Name].Pickaxe.SetTarget:InvokeServer(v)
					task.wait(0.3)
					game:GetService("Workspace").Players[game.Players.LocalPlayer.Name].Pickaxe.Activation:FireServer(true)
					count = 0
					repeat
						count = count + 1
						if not farming then
							break
						end
						if not game:GetService("Workspace").Players[game.Players.LocalPlayer.Name]:FindFirstChild("Pickaxe") then
							game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pickaxe").Parent = game:GetService("Workspace").Players[game.Players.LocalPlayer.Name]
							wait(0.1)
							break
						end
						if count >= 2000 then
							continue
						end
						task.wait(0.1)
					until v.Parent ~= workspace.Mine
					game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
					if not game:GetService("Workspace").Players[game.Players.LocalPlayer.Name]:FindFirstChild("Pickaxe") then
						game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pickaxe").Parent = game:GetService("Workspace").Players[game.Players.LocalPlayer.Name]
						task.wait(0.1)
					end
					game:GetService("Workspace").Players[game.Players.LocalPlayer.Name].Pickaxe.Activation:FireServer(false)
				end
			end
			if farming == false then
				game.Workspace.Gravity = 192
				if game:GetService("Workspace").Players[game.Players.LocalPlayer.Name]:FindFirstChild("Pickaxe") then
					game:GetService("Workspace").Players[game.Players.LocalPlayer.Name]:FindFirstChild("Pickaxe").PickaxeScript.Disabled = false
				elseif game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pickaxe") then
					game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Pickaxe").PickaxeScript.Disabled = false
				end
			end
		end
	end
})

OrionLib:Init()

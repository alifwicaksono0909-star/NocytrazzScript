repeat task.wait() until game:IsLoaded()
task.wait(1)
--================================================--
--                NOCYTRAZZ SCRIPT                --
--================================================--

-- UI Library (Mobile / Delta supported)
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Get Roblox profile image
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local ProfileImage = Players:GetUserThumbnailAsync(LocalPlayer.UserId, thumbType, thumbSize)

-- Main Window
local Window = OrionLib:MakeWindow({
	Name = "Nocytrazz Script",
	HidePremium = false,
	SaveConfig = true,
	ConfigFolder = "Nocytrazz",
	IntroEnabled = true,
	IntroText = "Nocytrazz Script Hub"
})

-- Pink border theme
OrionLib.Themes.Default.Main = Color3.fromRGB(255, 105, 180)

--================================================--
-- PROFILE TAB
--================================================--
local ProfileTab = Window:MakeTab({
	Name = "Profile",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

ProfileTab:AddParagraph(
	"Welcome",
	"Welcome "..LocalPlayer.Name
)

ProfileTab:AddButton({
	Name = "Show Roblox Profile",
	Callback = function()
		OrionLib:MakeNotification({
			Name = "Nocytrazz Script",
			Content = "Profile Loaded Successfully",
			Image = ProfileImage,
			Time = 5
		})
	end
})

--================================================--
-- BASIC SCRIPT TAB
--================================================--
local BasicTab = Window:MakeTab({
	Name = "Basic Script",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

--================================================--
-- ESP PLAYER (RED 3D BOX + NAME)
--================================================--
local ESPEnabled = false
local ESPObjects = {}

local function CreateESP(player)
	if player == LocalPlayer then return end
	if not player.Character then return end
	if not player.Character:FindFirstChild("HumanoidRootPart") then return end
	if ESPObjects[player] then return end

	-- Box ESP
	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = player.Character.HumanoidRootPart
	box.Size = Vector3.new(4, 6, 4)
	box.Color3 = Color3.fromRGB(255, 0, 0)
	box.Transparency = 0.5
	box.AlwaysOnTop = true
	box.ZIndex = 10
	box.Parent = Camera

	-- Name ESP
	local billboard = Instance.new("BillboardGui")
	billboard.Adornee = player.Character:WaitForChild("Head")
	billboard.Size = UDim2.new(0, 100, 0, 30)
	billboard.StudsOffset = Vector3.new(0, 2.7, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = Camera

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1,0,1,0)
	text.BackgroundTransparency = 1
	text.Text = player.Name
	text.TextColor3 = Color3.fromRGB(255, 0, 0)
	text.TextScaled = true
	text.Font = Enum.Font.GothamBold
	text.Parent = billboard

	ESPObjects[player] = {box, billboard}
end

local function RemoveESP()
	for _, objs in pairs(ESPObjects) do
		for _, v in pairs(objs) do
			if v then v:Destroy() end
		end
	end
	ESPObjects = {}
end

BasicTab:AddToggle({
	Name = "Player ESP (Red Box)",
	Default = false,
	Callback = function(state)
		ESPEnabled = state
		if state then
			for _, plr in pairs(Players:GetPlayers()) do
				CreateESP(plr)
			end
		else
			RemoveESP()
		end
	end
})

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(1)
		if ESPEnabled then
			CreateESP(plr)
		end
	end)
end)

--================================================--
-- TELEPORT TO PLAYER
--================================================--
local function GetPlayerList()
	local list = {}
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			table.insert(list, plr.Name)
		end
	end
	return list
end

BasicTab:AddDropdown({
	Name = "Teleport To Player",
	Options = GetPlayerList(),
	Callback = function(name)
		local target = Players:FindFirstChild(name)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame =
				target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
		end
	end
})

BasicTab:AddButton({
	Name = "Refresh Player List",
	Callback = function() end
})

--================================================--
-- WALKSPEED
--================================================--
BasicTab:AddSlider({
	Name = "WalkSpeed",
	Min = 16,
	Max = 200,
	Default = 16,
	Increment = 1,
	ValueName = "Speed",
	Color = Color3.fromRGB(255, 105, 180),
	Callback = function(value)
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
			LocalPlayer.Character.Humanoid.WalkSpeed = value
		end
	end
})

-- Init UI
OrionLib:Init()

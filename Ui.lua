--[[
🌈 Stylish GUI v4 - Professional Edition (Fixed)
💎 Beautiful animations & transitions
📱 Smooth drag & resize
--]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer

-- Anti-duplicate
local ID = "StyleGUI_" .. plr.UserId
if _G[ID] then
	plr:Kick("Script is already running")
	return
end
_G[ID] = true

-- Settings storage
local SettingsFile = "StyleGUI_Settings.json"
local Settings = {
	Farm = {
		FarmLv = false,
		AttackPlayer = false,
		AttackMobNearest = false
	},
	FarmSettings = {
		BringMob = true,
		AutoAttack = true
	}
}

-- Load settings
local function LoadSettings()
	if readfile and isfile then
		local success, result = pcall(function()
			if isfile(SettingsFile) then
				local data = readfile(SettingsFile)
				if data and data ~= "" then
					return game:GetService("HttpService"):JSONDecode(data)
				end
			end
			return nil
		end)
		
		if success and result then
			for category, values in pairs(result) do
				if Settings[category] then
					for key, value in pairs(values) do
						Settings[category][key] = value
					end
				end
			end
		end
	end
end

-- Save settings
local function SaveSettings()
	if writefile then
		pcall(function()
			local encoded = game:GetService("HttpService"):JSONEncode(Settings)
			writefile(SettingsFile, encoded)
		end)
	end
end

LoadSettings()

-- Themes
local Themes = {
	Dark = {bg = Color3.fromRGB(22,22,27), text = Color3.fromRGB(255,255,255), accent = Color3.fromRGB(50,50,60), accent2 = Color3.fromRGB(32,32,38), toggle = Color3.fromRGB(28,28,33)},
	Light = {bg = Color3.fromRGB(242,242,247), text = Color3.fromRGB(22,22,22), accent = Color3.fromRGB(208,208,218), accent2 = Color3.fromRGB(228,228,238), toggle = Color3.fromRGB(188,188,198)},
	Green = {bg = Color3.fromRGB(22,52,22), text = Color3.fromRGB(200,255,200), accent = Color3.fromRGB(42,82,42), accent2 = Color3.fromRGB(32,67,32), toggle = Color3.fromRGB(32,62,32)},
	Purple = {bg = Color3.fromRGB(48,28,72), text = Color3.fromRGB(235,210,255), accent = Color3.fromRGB(72,52,102), accent2 = Color3.fromRGB(58,38,88), toggle = Color3.fromRGB(62,42,88)}
}

local function ReadTheme()
	if readfile and isfile then
		local success, result = pcall(function()
			if isfile("StyleGUI_Theme.txt") then
				return readfile("StyleGUI_Theme.txt")
			end
			return nil
		end)
		if success and result and result ~= "" and Themes[result] then
			return result
		end
	end
	return "Dark"
end

local function SaveTheme(themeName)
	if writefile then
		pcall(function()
			writefile("StyleGUI_Theme.txt", themeName)
		end)
	end
end

local CT = ReadTheme()
if not Themes[CT] then CT = "Dark" end

local PageOrder = {"Home", "Settings", "More"}
local CP = "Home"
local isAnimating = false
local isSwitchingPage = false

-- GUI
local G = Instance.new("ScreenGui")
G.Name = "StyleGUI"
G.ResetOnSpawn = false
G.DisplayOrder = 999999
G.IgnoreGuiInset = true
G.Parent = plr:WaitForChild("PlayerGui")

G.Destroying:Connect(function() _G[ID] = nil end)

-- Toggle button
local TB = Instance.new("TextButton")
TB.Size = UDim2.new(0,42,0,42)
TB.Position = UDim2.new(0,20,0,80)
TB.BackgroundColor3 = Themes[CT].toggle
TB.Text = ""
TB.AutoButtonColor = false
TB.ZIndex = 10
TB.Parent = G

Instance.new("UICorner",TB).CornerRadius = UDim.new(1,0)

local TBS = Instance.new("UIStroke")
TBS.Thickness = 2.5
TBS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
TBS.Parent = TB

-- RGB animation
task.spawn(function()
	while TB and TB.Parent do
		for i=0,1,0.02 do
			if not TB or not TB.Parent then break end
			pcall(function() TBS.Color = Color3.fromHSV(i,0.8,1) end)
			task.wait(0.03)
		end
	end
end)

-- Icon
local IC = Instance.new("Frame")
IC.Size = UDim2.new(0,18,0,14)
IC.Position = UDim2.new(0.5,0,0.5,0)
IC.AnchorPoint = Vector2.new(0.5,0.5)
IC.BackgroundTransparency = 1
IC.ZIndex = 11
IC.Parent = TB

for i=0,2 do
	local L = Instance.new("Frame")
	L.Name = "L"..i
	L.Size = UDim2.new(1,0,0,2.5)
	L.Position = UDim2.new(0,0,0,i*5.5)
	L.BackgroundColor3 = Themes[CT].text
	L.BorderSizePixel = 0
	L.ZIndex = 12
	L.Parent = IC
	Instance.new("UICorner",L).CornerRadius = UDim.new(1,0)
end

-- Main frame
local MF = Instance.new("Frame")
MF.Size = UDim2.new(0,650,0,420)
MF.Position = UDim2.new(0.5,0,0.5,0)
MF.AnchorPoint = Vector2.new(0.5,0.5)
MF.BackgroundColor3 = Themes[CT].bg
MF.Visible = false
MF.ZIndex = 100
MF.Parent = G

Instance.new("UICorner",MF).CornerRadius = UDim.new(0,16)

local MFS = Instance.new("UIStroke")
MFS.Thickness = 3
MFS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MFS.Parent = MF

-- RGB border
task.spawn(function()
	while MF and MF.Parent do
		for i=0,1,0.02 do
			if not MF or not MF.Parent then break end
			pcall(function() MFS.Color = Color3.fromHSV(i,0.8,1) end)
			task.wait(0.03)
		end
	end
end)

-- Title bar
local TBar = Instance.new("Frame")
TBar.Size = UDim2.new(1,0,0,50)
TBar.BackgroundTransparency = 1
TBar.ZIndex = 101
TBar.Parent = MF

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-100,1,0)
Title.Position = UDim2.new(0,18,0,0)
Title.BackgroundTransparency = 1
Title.Text = "Control Panel"
Title.TextColor3 = Themes[CT].text
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 102
Title.Parent = TBar

-- Close button
local CB = Instance.new("TextButton")
CB.Size = UDim2.new(0,36,0,36)
CB.Position = UDim2.new(1,-42,0,7)
CB.BackgroundColor3 = Themes[CT].accent
CB.Text = "X"
CB.TextColor3 = Themes[CT].text
CB.Font = Enum.Font.GothamBold
CB.TextSize = 20
CB.BorderSizePixel = 0
CB.AutoButtonColor = false
CB.ZIndex = 103
CB.Parent = TBar

Instance.new("UICorner",CB).CornerRadius = UDim.new(0.45,0)

-- Resize handles
local function createHandle(name, pos, anchor)
	local H = Instance.new("Frame")
	H.Name = name
	H.Size = UDim2.new(0,20,0,20)
	H.Position = pos
	H.AnchorPoint = anchor
	H.BackgroundTransparency = 1
	H.ZIndex = 105
	H.Parent = MF
	return H
end

local RH_BR = createHandle("BR", UDim2.new(1,0,1,0), Vector2.new(1,1))
local RH_BL = createHandle("BL", UDim2.new(0,0,1,0), Vector2.new(0,1))
local RH_TR = createHandle("TR", UDim2.new(1,0,0,0), Vector2.new(1,0))
local RH_TL = createHandle("TL", UDim2.new(0,0,0,0), Vector2.new(0,0))

-- Sidebar
local SB = Instance.new("ScrollingFrame")
SB.Size = UDim2.new(0,140,1,-95)
SB.Position = UDim2.new(0,12,0,60)
SB.BackgroundColor3 = Themes[CT].accent2
SB.BorderSizePixel = 0
SB.ScrollBarThickness = 5
SB.ScrollBarImageColor3 = Themes[CT].accent
SB.AutomaticCanvasSize = Enum.AutomaticSize.Y
SB.CanvasSize = UDim2.new(0,0,0,0)
SB.ZIndex = 101
SB.Parent = MF

Instance.new("UICorner",SB).CornerRadius = UDim.new(0,12)

-- Content area
local CA = Instance.new("ScrollingFrame")
CA.Size = UDim2.new(1,-170,1,-95)
CA.Position = UDim2.new(0,160,0,60)
CA.BackgroundTransparency = 1
CA.BorderSizePixel = 0
CA.ScrollBarThickness = 6
CA.ScrollBarImageColor3 = Themes[CT].accent
CA.AutomaticCanvasSize = Enum.AutomaticSize.Y
CA.CanvasSize = UDim2.new(0,0,0,0)
CA.ClipsDescendants = true
CA.ZIndex = 101
CA.Parent = MF

-- Home page
local HP = Instance.new("Frame")
HP.Size = UDim2.new(1,-15,0,0)
HP.AutomaticSize = Enum.AutomaticSize.Y
HP.BackgroundTransparency = 1
HP.Visible = true
HP.ZIndex = 102
HP.Parent = CA

local HPT = Instance.new("TextLabel")
HPT.Size = UDim2.new(1,0,0,35)
HPT.BackgroundTransparency = 1
HPT.Text = "⚔️ Farm Options"
HPT.TextColor3 = Themes[CT].text
HPT.Font = Enum.Font.GothamBold
HPT.TextSize = 20
HPT.TextXAlignment = Enum.TextXAlignment.Left
HPT.ZIndex = 103
HPT.Parent = HP

-- Toggle buttons storage
local toggleButtons = {}

-- Create toggle function with easier clicking
local function CreateToggle(parent, text, yPos, category, settingKey)
	local Container = Instance.new("TextButton")
	Container.Size = UDim2.new(1,0,0,48)
	Container.Position = UDim2.new(0,0,0,yPos)
	Container.BackgroundColor3 = Themes[CT].accent2
	Container.BorderSizePixel = 0
	Container.AutoButtonColor = false
	Container.Text = ""
	Container.ZIndex = 103
	Container.Parent = parent
	
	Instance.new("UICorner",Container).CornerRadius = UDim.new(0,10)
	
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1,-70,1,0)
	Label.Position = UDim2.new(0,12,0,0)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.TextColor3 = Themes[CT].text
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 15
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 104
	Label.Parent = Container
	
	-- Toggle background - clickable
	local ToggleBG = Instance.new("TextButton")
	ToggleBG.Size = UDim2.new(0,52,0,28)
	ToggleBG.Position = UDim2.new(1,-58,0.5,-14)
	ToggleBG.BackgroundColor3 = Settings[category][settingKey] and Color3.fromRGB(50,200,50) or Color3.fromRGB(80,80,80)
	ToggleBG.BorderSizePixel = 0
	ToggleBG.AutoButtonColor = false
	ToggleBG.Text = ""
	ToggleBG.ZIndex = 104
	ToggleBG.Parent = Container
	
	Instance.new("UICorner",ToggleBG).CornerRadius = UDim.new(1,0)
	
	-- Toggle circle indicator
	local ToggleCircle = Instance.new("Frame")
	ToggleCircle.Size = UDim2.new(0,22,0,22)
	ToggleCircle.Position = Settings[category][settingKey] and UDim2.new(1,-25,0.5,-11) or UDim2.new(0,3,0.5,-11)
	ToggleCircle.BackgroundColor3 = Color3.fromRGB(255,255,255)
	ToggleCircle.BorderSizePixel = 0
	ToggleCircle.ZIndex = 105
	ToggleCircle.Parent = ToggleBG
	
	Instance.new("UICorner",ToggleCircle).CornerRadius = UDim.new(1,0)
	
	-- Toggle function
	local function toggleState()
		Settings[category][settingKey] = not Settings[category][settingKey]
		
		local newPos = Settings[category][settingKey] and UDim2.new(1,-25,0.5,-11) or UDim2.new(0,3,0.5,-11)
		local newColor = Settings[category][settingKey] and Color3.fromRGB(50,200,50) or Color3.fromRGB(80,80,80)
		
		TS:Create(ToggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = newPos}):Play()
		TS:Create(ToggleBG, TweenInfo.new(0.2), {BackgroundColor3 = newColor}):Play()
		
		SaveSettings()
		ShowNotification(text .. " " .. (Settings[category][settingKey] and "enabled ✅" or "disabled ❌"))
		
		-- Execute functionality based on setting
		if category == "Farm" then
			if settingKey == "FarmLv" then
				_G.FarmLvEnabled = Settings[category][settingKey]
				print("🎯 Farm Level:", _G.FarmLvEnabled and "ON" or "OFF")
			elseif settingKey == "AttackPlayer" then
				_G.AttackPlayerEnabled = Settings[category][settingKey]
				print("⚔️ Attack Player:", _G.AttackPlayerEnabled and "ON" or "OFF")
			elseif settingKey == "AttackMobNearest" then
				_G.AttackMobEnabled = Settings[category][settingKey]
				print("👹 Attack Mob Nearest:", _G.AttackMobEnabled and "ON" or "OFF")
			end
		elseif category == "FarmSettings" then
			if settingKey == "BringMob" then
				_G.BringMobEnabled = Settings[category][settingKey]
				print("🔄 Bring Mob:", _G.BringMobEnabled and "ON" or "OFF")
			elseif settingKey == "AutoAttack" then
				_G.AutoAttackEnabled = Settings[category][settingKey]
				print("⚡ Auto Attack:", _G.AutoAttackEnabled and "ON" or "OFF")
			end
		end
	end
	
	-- Click on entire container OR toggle button
	Container.MouseButton1Click:Connect(toggleState)
	ToggleBG.MouseButton1Click:Connect(function(e)
		e:Disconnect() -- Prevent double trigger
	end)
	
	-- Hover effects
	Container.MouseEnter:Connect(function()
		TS:Create(Container, TweenInfo.new(0.12), {
			BackgroundColor3 = Color3.new(
				math.min(Themes[CT].accent2.R*1.12,1),
				math.min(Themes[CT].accent2.G*1.12,1),
				math.min(Themes[CT].accent2.B*1.12,1)
			)
		}):Play()
	end)
	
	Container.MouseLeave:Connect(function()
		TS:Create(Container, TweenInfo.new(0.12), {BackgroundColor3 = Themes[CT].accent2}):Play()
	end)
	
	ToggleBG.MouseEnter:Connect(function()
		TS:Create(ToggleBG, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.new(
				math.min((Settings[category][settingKey] and Color3.fromRGB(50,200,50) or Color3.fromRGB(80,80,80)).R*1.15,1),
				math.min((Settings[category][settingKey] and Color3.fromRGB(50,200,50) or Color3.fromRGB(80,80,80)).G*1.15,1),
				math.min((Settings[category][settingKey] and Color3.fromRGB(50,200,50) or Color3.fromRGB(80,80,80)).B*1.15,1)
			)
		}):Play()
	end)
	
	ToggleBG.MouseLeave:Connect(function()
		TS:Create(ToggleBG, TweenInfo.new(0.1), {
			BackgroundColor3 = Settings[category][settingKey] and Color3.fromRGB(50,200,50) or Color3.fromRGB(80,80,80)
		}):Play()
	end)
	
	table.insert(toggleButtons, {container = Container, label = Label, toggleBG = ToggleBG, toggleCircle = ToggleCircle})
	return Container
end

-- Farm toggles
CreateToggle(HP, "🎯 Farm Level", 45, "Farm", "FarmLv")
CreateToggle(HP, "⚔️ Attack Player", 103, "Farm", "AttackPlayer")
CreateToggle(HP, "👹 Attack Mob Nearest", 161, "Farm", "AttackMobNearest")

-- Settings page
local SP = Instance.new("Frame")
SP.Size = UDim2.new(1,-15,0,0)
SP.AutomaticSize = Enum.AutomaticSize.Y
SP.BackgroundTransparency = 1
SP.Visible = false
SP.ZIndex = 102
SP.Parent = CA

local SPT = Instance.new("TextLabel")
SPT.Size = UDim2.new(1,0,0,35)
SPT.BackgroundTransparency = 1
SPT.Text = "⚙️ Farm Settings"
SPT.TextColor3 = Themes[CT].text
SPT.Font = Enum.Font.GothamBold
SPT.TextSize = 20
SPT.TextXAlignment = Enum.TextXAlignment.Left
SPT.ZIndex = 103
SPT.Parent = SP

-- Farm settings toggles
CreateToggle(SP, "🔄 Bring Mob", 45, "FarmSettings", "BringMob")
CreateToggle(SP, "⚡ Auto Attack", 103, "FarmSettings", "AutoAttack")

-- Theme section
local ThemeTitle = Instance.new("TextLabel")
ThemeTitle.Size = UDim2.new(1,0,0,35)
ThemeTitle.Position = UDim2.new(0,0,0,170)
ThemeTitle.BackgroundTransparency = 1
ThemeTitle.Text = "🎨 Theme Selection"
ThemeTitle.TextColor3 = Themes[CT].text
ThemeTitle.Font = Enum.Font.GothamBold
ThemeTitle.TextSize = 20
ThemeTitle.TextXAlignment = Enum.TextXAlignment.Left
ThemeTitle.ZIndex = 103
ThemeTitle.Parent = SP

-- Theme dropdown
local TDD = Instance.new("TextButton")
TDD.Size = UDim2.new(1,0,0,48)
TDD.Position = UDim2.new(0,0,0,215)
TDD.BackgroundColor3 = Themes[CT].accent2
TDD.Text = ""
TDD.BorderSizePixel = 0
TDD.AutoButtonColor = false
TDD.ZIndex = 103
TDD.Parent = SP

Instance.new("UICorner",TDD).CornerRadius = UDim.new(0,10)

local TDDL = Instance.new("TextLabel")
TDDL.Size = UDim2.new(1,-50,1,0)
TDDL.Position = UDim2.new(0,12,0,0)
TDDL.BackgroundTransparency = 1
TDDL.Text = "Current: " .. CT
TDDL.TextColor3 = Themes[CT].text
TDDL.Font = Enum.Font.GothamBold
TDDL.TextSize = 15
TDDL.TextXAlignment = Enum.TextXAlignment.Left
TDDL.ZIndex = 104
TDDL.Parent = TDD

local TDDA = Instance.new("TextLabel")
TDDA.Size = UDim2.new(0,30,1,0)
TDDA.Position = UDim2.new(1,-35,0,0)
TDDA.BackgroundTransparency = 1
TDDA.Text = "▼"
TDDA.TextColor3 = Themes[CT].text
TDDA.Font = Enum.Font.GothamBold
TDDA.TextSize = 14
TDDA.ZIndex = 104
TDDA.Parent = TDD

-- Theme list
local TL = Instance.new("Frame")
TL.Size = UDim2.new(1,0,0,0)
TL.Position = UDim2.new(0,0,0,273)
TL.BackgroundTransparency = 1
TL.ClipsDescendants = true
TL.Visible = false
TL.ZIndex = 103
TL.Parent = SP

local isOpen = false

-- More page
local MP = Instance.new("Frame")
MP.Size = UDim2.new(1,-15,0,0)
MP.AutomaticSize = Enum.AutomaticSize.Y
MP.BackgroundTransparency = 1
MP.Visible = false
MP.ZIndex = 102
MP.Parent = CA

local MPT = Instance.new("TextLabel")
MPT.Size = UDim2.new(1,0,0,35)
MPT.BackgroundTransparency = 1
MPT.Text = "📦 More Options"
MPT.TextColor3 = Themes[CT].text
MPT.Font = Enum.Font.GothamBold
MPT.TextSize = 20
MPT.TextXAlignment = Enum.TextXAlignment.Left
MPT.ZIndex = 103
MPT.Parent = MP

local MPD = Instance.new("TextLabel")
MPD.Size = UDim2.new(1,0,0,100)
MPD.Position = UDim2.new(0,0,0,45)
MPD.BackgroundTransparency = 1
MPD.Text = "🚀 Coming Soon!\n\n• Advanced Settings\n• Keybinds Manager\n• Plugin Support"
MPD.TextColor3 = Themes[CT].text
MPD.Font = Enum.Font.Gotham
MPD.TextSize = 15
MPD.TextWrapped = true
MPD.TextYAlignment = Enum.TextYAlignment.Top
MPD.TextXAlignment = Enum.TextXAlignment.Left
MPD.ZIndex = 103
MPD.Parent = MP

-- Credit
local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1,-170,0,30)
Credit.Position = UDim2.new(0,160,1,-35)
Credit.BackgroundTransparency = 1
Credit.Text = "UI by tru897tr"
Credit.Font = Enum.Font.GothamBold
Credit.TextSize = 13
Credit.TextTransparency = 0.5
Credit.TextColor3 = Themes[CT].text
Credit.TextXAlignment = Enum.TextXAlignment.Right
Credit.ZIndex = 101
Credit.Parent = MF

-- Notification system
local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0,280,1,-20)
NotifContainer.Position = UDim2.new(1,-290,0,10)
NotifContainer.BackgroundTransparency = 1
NotifContainer.ZIndex = 600
NotifContainer.Parent = G

local notifs = {}
local MAX_NOTIFS = 3

function ShowNotification(msg)
	if #notifs >= MAX_NOTIFS then
		local old = table.remove(notifs, 1)
		if old then
			TS:Create(old, TweenInfo.new(0.2), {Position = UDim2.new(1.2, 0, 0, old.Position.Y.Offset)}):Play()
			task.delay(0.25, function() if old then old:Destroy() end end)
			task.wait(0.15)
			for i, n in ipairs(notifs) do
				TS:Create(n, TweenInfo.new(0.2), {Position = UDim2.new(0, 0, 0, (i-1) * 72)}):Play()
			end
		end
	end
	
	local N = Instance.new("TextButton")
	N.Size = UDim2.new(1, 0, 0, 65)
	N.Position = UDim2.new(1.2, 0, 0, #notifs * 72)
	N.BackgroundColor3 = Themes[CT].accent2
	N.BorderSizePixel = 0
	N.AutoButtonColor = false
	N.Text = ""
	N.ZIndex = 601
	N.Parent = NotifContainer
	
	Instance.new("UICorner", N).CornerRadius = UDim.new(0, 10)
	
	local S = Instance.new("UIStroke")
	S.Thickness = 2
	S.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	S.Parent = N
	
	local rgbConn = RunService.Heartbeat:Connect(function()
		if MFS and N and N.Parent then
			S.Color = MFS.Color
		end
	end)
	
	N.Destroying:Connect(function() if rgbConn then rgbConn:Disconnect() end end)
	
	local I = Instance.new("TextLabel")
	I.Size = UDim2.new(0, 45, 1, -10)
	I.Position = UDim2.new(0, 5, 0, 0)
	I.BackgroundTransparency = 1
	I.Text = "✨"
	I.TextColor3 = Themes[CT].text
	I.Font = Enum.Font.GothamBold
	I.TextSize = 24
	I.ZIndex = 602
	I.Parent = N
	
	local M = Instance.new("TextLabel")
	M.Size = UDim2.new(1, -55, 1, -18)
	M.Position = UDim2.new(0, 50, 0, 5)
	M.BackgroundTransparency = 1
	M.Text = msg
	M.TextColor3 = Themes[CT].text
	M.Font = Enum.Font.Gotham
	M.TextSize = 13
	M.TextWrapped = true
	M.TextXAlignment = Enum.TextXAlignment.Left
	M.TextYAlignment = Enum.TextYAlignment.Top
	M.ZIndex = 602
	M.Parent = N
	
	local PBG = Instance.new("Frame")
	PBG.Size = UDim2.new(1, -16, 0, 3)
	PBG.Position = UDim2.new(0, 8, 1, -7)
	PBG.BackgroundColor3 = Themes[CT].accent
	PBG.BackgroundTransparency = 0.5
	PBG.BorderSizePixel = 0
	PBG.ZIndex = 602
	PBG.Parent = N
	
	Instance.new("UICorner", PBG).CornerRadius = UDim.new(1, 0)
	
	local PB = Instance.new("Frame")
	PB.Size = UDim2.new(1, 0, 1, 0)
	PB.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
	PB.BorderSizePixel = 0
	PB.ZIndex = 603
	PB.Parent = PBG
	
	Instance.new("UICorner", PB).CornerRadius = UDim.new(1, 0)
	
	table.insert(notifs, N)
	
	TS:Create(N, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, (#notifs - 1) * 72)
	}):Play()
	
	local progressTween = TS:Create(PB, TweenInfo.new(4, Enum.EasingStyle.Linear), {
		Size = UDim2.new(0, 0, 1, 0)
	})
	progressTween:Play()
	
	local function removeNotif()
		if not N or not N.Parent then return end
		if progressTween then progressTween:Cancel() end
		
		for i, n in ipairs(notifs) do
			if n == N then
				table.remove(notifs, i)
				break
			end
		end
		
		TS:Create(N, TweenInfo.new(0.2), {Position = UDim2.new(1.2, 0, 0, N.Position.Y.Offset)}):Play()
		task.delay(0.25, function() if N then N:Destroy() end end)
		
		for i, n in ipairs(notifs) do
			TS:Create(n, TweenInfo.new(0.2), {Position = UDim2.new(0, 0, 0, (i-1) * 72)}):Play()
		end
	end
	
	N.MouseButton1Click:Connect(removeNotif)
	
	N.MouseEnter:Connect(function()
		TS:Create(N, TweenInfo.new(0.12), {Size = UDim2.new(1, 5, 0, 65)}):Play()
	end)
	
	N.MouseLeave:Connect(function()
		TS:Create(N, TweenInfo.new(0.12), {Size = UDim2.new(1, 0, 0, 65)}):Play()
	end)
	
	task.delay(4, removeNotif)
end

-- Confirm dialog
local CF = Instance.new("Frame")
CF.Size = UDim2.new(0,360,0,180)
CF.Position = UDim2.new(0.5,0,0.5,0)
CF.AnchorPoint = Vector2.new(0.5,0.5)
CF.BackgroundColor3 = Themes[CT].bg
CF.Visible = false
CF.ZIndex = 300
CF.Parent = G

Instance.new("UICorner",CF).CornerRadius = UDim.new(0,14)

local CFS = Instance.new("UIStroke")
CFS.Thickness = 3
CFS.Color = Color3.fromRGB(255,50,50)
CFS.Parent = CF

local CFT = Instance.new("TextLabel")
CFT.Size = UDim2.new(1,-40,0,50)
CFT.Position = UDim2.new(0,20,0,15)
CFT.BackgroundTransparency = 1
CFT.Text = "Close Script?"
CFT.TextColor3 = Themes[CT].text
CFT.Font = Enum.Font.GothamBold
CFT.TextSize = 20
CFT.ZIndex = 301
CFT.Parent = CF

local CFD = Instance.new("TextLabel")
CFD.Size = UDim2.new(1,-40,0,40)
CFD.Position = UDim2.new(0,20,0,65)
CFD.BackgroundTransparency = 1
CFD.Text = "Script will be closed.\nAre you sure?"
CFD.TextColor3 = Themes[CT].text
CFD.Font = Enum.Font.Gotham
CFD.TextSize = 14
CFD.TextWrapped = true
CFD.ZIndex = 301
CFD.Parent = CF

local YB = Instance.new("TextButton")
YB.Size = UDim2.new(0,150,0,40)
YB.Position = UDim2.new(0,20,1,-50)
YB.BackgroundColor3 = Color3.fromRGB(255,50,50)
YB.Text = "Yes"
YB.TextColor3 = Color3.new(1,1,1)
YB.Font = Enum.Font.GothamBold
YB.TextSize = 16
YB.BorderSizePixel = 0
YB.AutoButtonColor = false
YB.ZIndex = 302
YB.Parent = CF

Instance.new("UICorner",YB).CornerRadius = UDim.new(0,10)

local NB = Instance.new("TextButton")
NB.Size = UDim2.new(0,150,0,40)
NB.Position = UDim2.new(1,-170,1,-50)
NB.BackgroundColor3 = Themes[CT].accent
NB.Text = "No"
NB.TextColor3 = Themes[CT].text
NB.Font = Enum.Font.GothamBold
NB.TextSize = 16
NB.BorderSizePixel = 0
NB.AutoButtonColor = false
NB.ZIndex = 302
NB.Parent = CF

Instance.new("UICorner",NB).CornerRadius = UDim.new(0,10)

-- Page objects
local Pages = {
	Home = HP,
	Settings = SP,
	More = MP
}

-- Menu buttons
local menuBtns = {}
local function createMenu(name, icon, pos)
	local B = Instance.new("TextButton")
	B.Size = UDim2.new(1,-14,0,42)
	B.Position = UDim2.new(0,7,0,7+pos*50)
	B.BackgroundColor3 = Themes[CT].accent
	B.BackgroundTransparency = (CP==name) and 0 or 1
	B.Text = ""
	B.BorderSizePixel = 0
	B.AutoButtonColor = false
	B.ZIndex = 102
	B.Parent = SB
	
	Instance.new("UICorner",B).CornerRadius = UDim.new(0,10)
	
	local L = Instance.new("TextLabel")
	L.Size = UDim2.new(1,0,1,0)
	L.BackgroundTransparency = 1
	L.Text = icon.." "..name
	L.TextColor3 = Themes[CT].text
	L.Font = Enum.Font.GothamBold
	L.TextSize = 14
	L.ZIndex = 103
	L.Parent = B
	
	menuBtns[name] = {btn=B, lbl=L}
	return B
end

createMenu("Home","🏠",0)
createMenu("Settings","⚙️",1)
createMenu("More","📦",2)

-- Theme buttons
local themeBtns = {}
for i,n in ipairs({"Dark","Light","Green","Purple"}) do
	local B = Instance.new("TextButton")
	B.Size = UDim2.new(1,0,0,48)
	B.Position = UDim2.new(0,0,0,(i-1)*54)
	B.BackgroundColor3 = Themes[n].bg
	B.Text = ""
	B.BorderSizePixel = 0
	B.AutoButtonColor = false
	B.ZIndex = 104
	B.Parent = TL
	
	Instance.new("UICorner",B).CornerRadius = UDim.new(0,10)
	
	local L = Instance.new("TextLabel")
	L.Size = UDim2.new(1,-20,1,0)
	L.Position = UDim2.new(0,10,0,0)
	L.BackgroundTransparency = 1
	L.Text = n
	L.TextColor3 = Themes[n].text
	L.Font = Enum.Font.GothamBold
	L.TextSize = 16
	L.TextXAlignment = Enum.TextXAlignment.Left
	L.ZIndex = 105
	L.Parent = B
	
	themeBtns[n] = B
end

-- Update theme function
local function UpdateTheme(t)
	if t == CT then return end
	CT = t
	
	local tweenTime = 0.3
	local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	
	-- Main elements
	TS:Create(MF, tweenInfo, {BackgroundColor3 = Themes[t].bg}):Play()
	TS:Create(Title, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(Credit, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(HPT, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(SPT, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(ThemeTitle, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(MPT, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(MPD, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(TDDL, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(TDDA, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	
	-- UI elements
	TS:Create(TDD, tweenInfo, {BackgroundColor3 = Themes[t].accent2}):Play()
	TS:Create(CB, tweenInfo, {BackgroundColor3 = Themes[t].accent, TextColor3 = Themes[t].text}):Play()
	TS:Create(TB, tweenInfo, {BackgroundColor3 = Themes[t].toggle}):Play()
	TS:Create(SB, tweenInfo, {BackgroundColor3 = Themes[t].accent2, ScrollBarImageColor3 = Themes[t].accent}):Play()
	TS:Create(CA, tweenInfo, {ScrollBarImageColor3 = Themes[t].accent}):Play()
	TS:Create(CF, tweenInfo, {BackgroundColor3 = Themes[t].bg}):Play()
	TS:Create(CFT, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(CFD, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(NB, tweenInfo, {BackgroundColor3 = Themes[t].accent, TextColor3 = Themes[t].text}):Play()
	
	-- Icon lines
	for i=0,2 do
		local L = IC:FindFirstChild("L"..i)
		if L then
			TS:Create(L, tweenInfo, {BackgroundColor3 = Themes[t].text}):Play()
		end
	end
	
	-- Menu buttons
	for n,d in pairs(menuBtns) do
		TS:Create(d.lbl, tweenInfo, {TextColor3 = Themes[t].text}):Play()
		if CP==n then
			TS:Create(d.btn, tweenInfo, {BackgroundColor3 = Themes[t].accent, BackgroundTransparency = 0}):Play()
		end
	end
	
	-- Toggle buttons
	for _, toggle in ipairs(toggleButtons) do
		TS:Create(toggle.container, tweenInfo, {BackgroundColor3 = Themes[t].accent2}):Play()
		TS:Create(toggle.label, tweenInfo, {TextColor3 = Themes[t].text}):Play()
		-- Update toggle colors based on current state
		local category, settingKey
		for cat, settings in pairs(Settings) do
			for key, _ in pairs(settings) do
				if toggle.container.Name == cat..key then
					category = cat
					settingKey = key
					break
				end
			end
		end
		if category and settingKey then
			local newColor = Settings[category][settingKey] and Color3.fromRGB(50,200,50) or Color3.fromRGB(80,80,80)
			TS:Create(toggle.toggleBG, tweenInfo, {BackgroundColor3 = newColor}):Play()
		end
	end
	
	-- Update label
	TDDL.Text = "Current: " .. t
	
	-- Flash effect
	local flash = Instance.new("Frame")
	flash.Size = UDim2.new(1, 0, 1, 0)
	flash.BackgroundColor3 = Themes[t].text
	flash.BackgroundTransparency = 0.9
	flash.BorderSizePixel = 0
	flash.ZIndex = 999
	flash.Parent = MF
	
	TS:Create(flash, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
		BackgroundTransparency = 1
	}):Play()
	
	task.delay(0.4, function() flash:Destroy() end)
	
	ShowNotification("Theme changed to " .. t .. " 🎨")
	SaveTheme(t)
end

-- Page switching
local function GetPageIndex(pageName)
	for i, name in ipairs(PageOrder) do
		if name == pageName then
			return i
		end
	end
	return 1
end

local function SwitchPage(targetPage)
	if isSwitchingPage or CP == targetPage then return end
	
	if isOpen then
		isOpen = false
		TS:Create(TL,TweenInfo.new(0.15),{Size=UDim2.new(1,0,0,0)}):Play()
		TS:Create(TDDA,TweenInfo.new(0.15),{Rotation=0}):Play()
		task.delay(0.15, function() TL.Visible = false end)
	end
	
	isSwitchingPage = true
	
	local currentIndex = GetPageIndex(CP)
	local targetIndex = GetPageIndex(targetPage)
	local direction = (targetIndex > currentIndex) and 1 or -1
	local distance = math.abs(targetIndex - currentIndex)
	
	local currentPageObj = Pages[CP]
	local targetPageObj = Pages[targetPage]
	local totalTime = 0.2 * distance
	
	for _, page in pairs(Pages) do
		if page ~= currentPageObj then
			page.Visible = false
			page.Position = UDim2.new(0, 0, 0, 0)
		end
	end
	
	if distance > 1 then
		for i = math.min(currentIndex, targetIndex), math.max(currentIndex, targetIndex) do
			local pageName = PageOrder[i]
			local pageObj = Pages[pageName]
			if pageObj ~= currentPageObj then
				local offset = (i - currentIndex) * direction
				pageObj.Position = UDim2.new(0, 0, offset, 0)
				pageObj.Visible = true
			end
		end
	end
	
	local startOffset = direction * distance
	targetPageObj.Position = UDim2.new(0, 0, startOffset, 0)
	targetPageObj.Visible = true
	
	for i = math.min(currentIndex, targetIndex), math.max(currentIndex, targetIndex) do
		local pageName = PageOrder[i]
		local pageObj = Pages[pageName]
		local targetOffset = (i - targetIndex) * direction
		
		local tw = TS:Create(pageObj, TweenInfo.new(totalTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, 0, targetOffset, 0)
		})
		tw:Play()
		
		if pageObj == targetPageObj then
			tw.Completed:Connect(function()
				for _, page in pairs(Pages) do
					if page ~= targetPageObj then
						page.Visible = false
						page.Position = UDim2.new(0, 0, 0, 0)
					end
				end
				targetPageObj.Position = UDim2.new(0, 0, 0, 0)
				isSwitchingPage = false
			end)
		end
	end
	
	CP = targetPage
	
	for n,d in pairs(menuBtns) do
		if n==targetPage then
			TS:Create(d.btn,TweenInfo.new(0.15),{BackgroundColor3=Themes[CT].accent,BackgroundTransparency=0}):Play()
		else
			TS:Create(d.btn,TweenInfo.new(0.15),{BackgroundTransparency=1}):Play()
		end
	end
end

local function ToggleTheme()
	if isAnimating then return end
	isAnimating = true
	
	isOpen = not isOpen
	if isOpen then
		TL.Visible = true
		TS:Create(TL,TweenInfo.new(0.25),{Size=UDim2.new(1,0,0,222)}):Play()
		TS:Create(TDDA,TweenInfo.new(0.25),{Rotation=180}):Play()
	else
		TS:Create(TL,TweenInfo.new(0.2),{Size=UDim2.new(1,0,0,0)}):Play()
		TS:Create(TDDA,TweenInfo.new(0.2),{Rotation=0}):Play()
		task.delay(0.2, function() TL.Visible=false end)
	end
	
	task.wait(0.3)
	isAnimating = false
end

local function ShowFrame()
	if isAnimating then return end
	isAnimating = true
	
	MF.Visible = true
	MF.Size = UDim2.new(0,0,0,0)
	TS:Create(MF,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,650,0,420)}):Play()
	
	task.wait(0.4)
	isAnimating = false
end

local function HideFrame()
	if isAnimating then return end
	isAnimating = true
	
	TS:Create(MF,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play()
	
	task.wait(0.3)
	MF.Visible=false
	isAnimating = false
end

local function ShowConfirm()
	if isAnimating then return end
	isAnimating = true
	
	CF.Visible = true
	CF.Size = UDim2.new(0,0,0,0)
	TS:Create(CF,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,360,0,180)}):Play()
	
	task.wait(0.35)
	isAnimating = false
end

local function HideConfirm()
	if isAnimating then return end
	isAnimating = true
	
	TS:Create(CF,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play()
	
	task.wait(0.25)
	CF.Visible=false
	isAnimating = false
end

-- Events
TB.MouseButton1Click:Connect(function()
	if MF.Visible then HideFrame() else ShowFrame() end
end)

CB.MouseButton1Click:Connect(ShowConfirm)
YB.MouseButton1Click:Connect(function() G:Destroy() _G[ID]=nil end)
NB.MouseButton1Click:Connect(HideConfirm)
TDD.MouseButton1Click:Connect(ToggleTheme)

for n,d in pairs(menuBtns) do
	d.btn.MouseButton1Click:Connect(function() SwitchPage(n) end)
end

for n,b in pairs(themeBtns) do
	b.MouseButton1Click:Connect(function() UpdateTheme(n) end)
end

-- Hover effects
local function safeHover(obj, enter, leave)
	obj.MouseEnter:Connect(enter)
	obj.MouseLeave:Connect(leave)
end

safeHover(TB,
	function() TS:Create(TB,TweenInfo.new(0.15),{Size=UDim2.new(0,46,0,46)}):Play() end,
	function() TS:Create(TB,TweenInfo.new(0.15),{Size=UDim2.new(0,42,0,42)}):Play() end
)

safeHover(CB,
	function() TS:Create(CB,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(255,60,60)}):Play() end,
	function() TS:Create(CB,TweenInfo.new(0.12),{BackgroundColor3=Themes[CT].accent}):Play() end
)

for n,d in pairs(menuBtns) do
	safeHover(d.btn,
		function()
			if CP~=n then
				TS:Create(d.btn,TweenInfo.new(0.12),{BackgroundColor3=Themes[CT].accent,BackgroundTransparency=0.5}):Play()
			end
		end,
		function()
			if CP~=n then
				TS:Create(d.btn,TweenInfo.new(0.12),{BackgroundTransparency=1}):Play()
			end
		end
	)
end

for n,b in pairs(themeBtns) do
	safeHover(b,
		function()
			TS:Create(b,TweenInfo.new(0.12),{BackgroundColor3=Color3.new(
				math.min(Themes[n].bg.R*1.2,1),
				math.min(Themes[n].bg.G*1.2,1),
				math.min(Themes[n].bg.B*1.2,1)
			)}):Play()
		end,
		function() TS:Create(b,TweenInfo.new(0.12),{BackgroundColor3=Themes[n].bg}):Play() end
	)
end

safeHover(TDD,
	function()
		TS:Create(TDD,TweenInfo.new(0.12),{BackgroundColor3=Color3.new(
			math.min(Themes[CT].accent2.R*1.12,1),
			math.min(Themes[CT].accent2.G*1.12,1),
			math.min(Themes[CT].accent2.B*1.12,1)
		)}):Play()
	end,
	function() TS:Create(TDD,TweenInfo.new(0.12),{BackgroundColor3=Themes[CT].accent2}):Play() end
)

safeHover(YB,
	function() TS:Create(YB,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(220,40,40)}):Play() end,
	function() TS:Create(YB,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(255,50,50)}):Play() end
)

safeHover(NB,
	function()
		TS:Create(NB,TweenInfo.new(0.1),{BackgroundColor3=Color3.new(
			math.min(Themes[CT].accent.R*1.15,1),
			math.min(Themes[CT].accent.G*1.15,1),
			math.min(Themes[CT].accent.B*1.15,1)
		)}):Play()
	end,
	function() TS:Create(NB,TweenInfo.new(0.1),{BackgroundColor3=Themes[CT].accent}):Play() end
)

-- Drag frame
local drag,dragS,startP
TBar.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		drag=true
		dragS=i.Position
		startP=MF.Position
		i.Changed:Connect(function()
			if i.UserInputState==Enum.UserInputState.End then drag=false end
		end)
	end
end)

UIS.InputChanged:Connect(function(i)
	if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-dragS
		MF.Position=UDim2.new(startP.X.Scale,startP.X.Offset+d.X,startP.Y.Scale,startP.Y.Offset+d.Y)
	end
end)

-- Drag toggle
local drag2,dragS2,startP2
TB.InputBegan:Connect(function(i)
	if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
		drag2=true
		dragS2=i.Position
		startP2=TB.Position
		i.Changed:Connect(function()
			if i.UserInputState==Enum.UserInputState.End then drag2=false end
		end)
	end
end)

UIS.InputChanged:Connect(function(i)
	if drag2 and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local d=i.Position-dragS2
		TB.Position=UDim2.new(startP2.X.Scale,startP2.X.Offset+d.X,startP2.Y.Scale,startP2.Y.Offset+d.Y)
	end
end)

-- Resize system
local resizing,resizeType,resizeStart,startSize,startPos
local minSize=Vector2.new(550,380)
local maxSize=Vector2.new(1000,800)

local function startResize(handle,rType)
	handle.InputBegan:Connect(function(i)
		if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
			resizing=true
			resizeType=rType
			resizeStart=i.Position
			startSize=MF.AbsoluteSize
			startPos=MF.Position
			i.Changed:Connect(function()
				if i.UserInputState==Enum.UserInputState.End then resizing=false end
			end)
		end
	end)
end

startResize(RH_BR,"BR")
startResize(RH_BL,"BL")
startResize(RH_TR,"TR")
startResize(RH_TL,"TL")

UIS.InputChanged:Connect(function(i)
	if resizing and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		local delta=i.Position-resizeStart
		local newW,newH=startSize.X,startSize.Y
		local newX,newY=startPos.X.Offset,startPos.Y.Offset
		
		if resizeType=="BR" then
			newW=math.clamp(startSize.X+delta.X,minSize.X,maxSize.X)
			newH=math.clamp(startSize.Y+delta.Y,minSize.Y,maxSize.Y)
		elseif resizeType=="BL" then
			local tempW=math.clamp(startSize.X-delta.X,minSize.X,maxSize.X)
			newW=tempW
			newH=math.clamp(startSize.Y+delta.Y,minSize.Y,maxSize.Y)
			newX=startPos.X.Offset+(startSize.X-tempW)
		elseif resizeType=="TR" then
			newW=math.clamp(startSize.X+delta.X,minSize.X,maxSize.X)
			local tempH=math.clamp(startSize.Y-delta.Y,minSize.Y,maxSize.Y)
			newH=tempH
			newY=startPos.Y.Offset+(startSize.Y-tempH)
		elseif resizeType=="TL" then
			local tempW=math.clamp(startSize.X-delta.X,minSize.X,maxSize.X)
			local tempH=math.clamp(startSize.Y-delta.Y,minSize.Y,maxSize.Y)
			newW=tempW
			newH=tempH
			newX=startPos.X.Offset+(startSize.X-tempW)
			newY=startPos.Y.Offset+(startSize.Y-tempH)
		end
		
		MF.Size=UDim2.new(0,newW,0,newH)
		MF.Position=UDim2.new(startPos.X.Scale,newX,startPos.Y.Scale,newY)
	end
end)

-- Initialize global variables from loaded settings
_G.FarmLvEnabled = Settings.Farm.FarmLv
_G.AttackPlayerEnabled = Settings.Farm.AttackPlayer
_G.AttackMobEnabled = Settings.Farm.AttackMobNearest
_G.BringMobEnabled = Settings.FarmSettings.BringMob
_G.AutoAttackEnabled = Settings.FarmSettings.AutoAttack

print("✅ Stylish GUI v4 - Fixed & Optimized")
print("🎨 Theme: "..CT)
print("💾 Settings: Loaded from file")
print("📊 Farm Level:", _G.FarmLvEnabled and "ON" or "OFF")
print("📊 Attack Player:", _G.AttackPlayerEnabled and "ON" or "OFF")
print("📊 Attack Mob:", _G.AttackMobEnabled and "ON" or "OFF")
print("📊 Bring Mob:", _G.BringMobEnabled and "ON" or "OFF")
print("📊 Auto Attack:", _G.AutoAttackEnabled and "ON" or "OFF")
print("💎 By: tru897tr")

task.delay(0.5, function()
	ShowNotification("Welcome! All settings loaded 🚀")
end)

-- Example usage of the settings in your actual farm code:
--[[
-- Farm Level Loop
task.spawn(function()
	while wait(0.1) do
		if _G.FarmLvEnabled then
			-- Your farm level code here
			print("Farming level...")
		end
	end
end)

-- Attack Player Loop
task.spawn(function()
	while wait(0.1) do
		if _G.AttackPlayerEnabled then
			-- Your attack player code here
			print("Attacking player...")
		end
	end
end)

-- Attack Mob Loop
task.spawn(function()
	while wait(0.1) do
		if _G.AttackMobEnabled then
			-- Your attack mob code here
			print("Attacking nearest mob...")
		end
	end
end)

-- Bring Mob Function
local function BringMob()
	if _G.BringMobEnabled then
		-- Your bring mob code here
		print("Bringing mobs...")
	end
end

-- Auto Attack Function
local function AutoAttack()
	if _G.AutoAttackEnabled then
		-- Your auto attack code here
		print("Auto attacking...")
	end
end
--]]

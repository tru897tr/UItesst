--[[
🌈 Stylish GUI v4 - Professional Edition
💎 Beautiful page transitions with direction
📱 Smooth animations
--]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

local plr = Players.LocalPlayer

-- Anti-duplicate
local ID = "StyleGUI_" .. plr.UserId
if _G[ID] then
	plr:Kick("Script is already running")
	return
end
_G[ID] = true

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

-- Page order system
local PageOrder = {"Home", "Settings", "More"}
local CP = "Home"

-- Animation lock to prevent spam
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

-- RGB animation with spam protection
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
MF.Size = UDim2.new(0,600,0,380)
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

-- RGB border with spam protection
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

-- Resize handles (invisible, 4 corners)
local function createHandle(name, pos, anchor)
	local H = Instance.new("Frame")
	H.Name = name
	H.Size = UDim2.new(0,25,0,25)
	H.Position = pos
	H.AnchorPoint = anchor
	H.BackgroundTransparency = 1
	H.ZIndex = 105
	H.Parent = MF
	return H
end

local RH_BR = createHandle("BR", UDim2.new(1,0,1,0), Vector2.new(1,1))
local RH_BL = createHandle("BL", UDim2.new(0,0,1,0), Vector2.new(0,1))
local RH_TR = createHandle("TR", UDim2.new(1,0,0,50), Vector2.new(1,0))
local RH_TL = createHandle("TL", UDim2.new(0,0,0,50), Vector2.new(0,0))

-- Sidebar
local SB = Instance.new("ScrollingFrame")
SB.Size = UDim2.new(0,125,1,-95)
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
CA.Size = UDim2.new(1,-155,1,-95)
CA.Position = UDim2.new(0,145,0,60)
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
HPT.Size = UDim2.new(1,0,0,40)
HPT.BackgroundTransparency = 1
HPT.Text = "Welcome"
HPT.TextColor3 = Themes[CT].text
HPT.Font = Enum.Font.GothamBold
HPT.TextSize = 22
HPT.TextXAlignment = Enum.TextXAlignment.Left
HPT.ZIndex = 103
HPT.Parent = HP

local HPD = Instance.new("TextLabel")
HPD.Size = UDim2.new(1,0,0,180)
HPD.Position = UDim2.new(0,0,0,50)
HPD.BackgroundTransparency = 1
HPD.Text = "Modern UI Design\n4 Beautiful Themes\nDrag & Drop Support\nRGB Border Effects\nMobile Compatible\nResizable Window\nSave Settings\n\nUse menu to navigate"
HPD.TextColor3 = Themes[CT].text
HPD.Font = Enum.Font.Gotham
HPD.TextSize = 16
HPD.TextWrapped = true
HPD.TextYAlignment = Enum.TextYAlignment.Top
HPD.TextXAlignment = Enum.TextXAlignment.Left
HPD.ZIndex = 103
HPD.Parent = HP

-- Settings page
local SP = Instance.new("Frame")
SP.Size = UDim2.new(1,-15,0,0)
SP.AutomaticSize = Enum.AutomaticSize.Y
SP.BackgroundTransparency = 1
SP.Visible = false
SP.ZIndex = 102
SP.Parent = CA

local SPT = Instance.new("TextLabel")
SPT.Size = UDim2.new(1,0,0,40)
SPT.BackgroundTransparency = 1
SPT.Text = "Settings"
SPT.TextColor3 = Themes[CT].text
SPT.Font = Enum.Font.GothamBold
SPT.TextSize = 22
SPT.TextXAlignment = Enum.TextXAlignment.Left
SPT.ZIndex = 103
SPT.Parent = SP

-- Theme dropdown
local TDD = Instance.new("TextButton")
TDD.Size = UDim2.new(1,0,0,45)
TDD.Position = UDim2.new(0,0,0,50)
TDD.BackgroundColor3 = Themes[CT].accent2
TDD.Text = ""
TDD.BorderSizePixel = 0
TDD.AutoButtonColor = false
TDD.ZIndex = 103
TDD.Parent = SP

Instance.new("UICorner",TDD).CornerRadius = UDim.new(0,12)

local TDDL = Instance.new("TextLabel")
TDDL.Size = UDim2.new(1,-60,1,0)
TDDL.Position = UDim2.new(0,15,0,0)
TDDL.BackgroundTransparency = 1
TDDL.Text = "Theme Selection"
TDDL.TextColor3 = Themes[CT].text
TDDL.Font = Enum.Font.GothamBold
TDDL.TextSize = 16
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
TL.Position = UDim2.new(0,0,0,105)
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
MPT.Size = UDim2.new(1,0,0,40)
MPT.BackgroundTransparency = 1
MPT.Text = "More Options"
MPT.TextColor3 = Themes[CT].text
MPT.Font = Enum.Font.GothamBold
MPT.TextSize = 22
MPT.TextXAlignment = Enum.TextXAlignment.Left
MPT.ZIndex = 103
MPT.Parent = MP

local MPD = Instance.new("TextLabel")
MPD.Size = UDim2.new(1,0,0,120)
MPD.Position = UDim2.new(0,0,0,50)
MPD.BackgroundTransparency = 1
MPD.Text = "Additional Features\n\n• Advanced Settings\n• Export/Import Config\n• Keybinds Manager\n• Plugin Support"
MPD.TextColor3 = Themes[CT].text
MPD.Font = Enum.Font.Gotham
MPD.TextSize = 16
MPD.TextWrapped = true
MPD.TextYAlignment = Enum.TextYAlignment.Top
MPD.TextXAlignment = Enum.TextXAlignment.Left
MPD.ZIndex = 103
MPD.Parent = MP

-- Credit
local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1,-155,0,30)
Credit.Position = UDim2.new(0,145,1,-35)
Credit.BackgroundTransparency = 1
Credit.Text = "UI by tru897tr"
Credit.Font = Enum.Font.GothamBold
Credit.TextSize = 14
Credit.TextTransparency = 0.4
Credit.TextColor3 = Themes[CT].text
Credit.TextXAlignment = Enum.TextXAlignment.Right
Credit.ZIndex = 101
Credit.Parent = MF

-- Notification system
local NotificationContainer = Instance.new("Frame")
NotificationContainer.Size = UDim2.new(0, 280, 1, -20)
NotificationContainer.Position = UDim2.new(1, -290, 0, 10)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.ZIndex = 500
NotificationContainer.Parent = G

local activeNotifications = {}
local maxNotifications = 3

local function CreateNotification(message, duration)
	duration = duration or 5
	
	-- Remove oldest notification if limit exceeded
	if #activeNotifications >= maxNotifications then
		local oldest = table.remove(activeNotifications, 1)
		if oldest and oldest.Parent then
			local fadeOut = TS:Create(oldest, TweenInfo.new(0.2), {
				Position = UDim2.new(1, 20, 0, oldest.Position.Y.Offset),
				BackgroundTransparency = 1
			})
			fadeOut:Play()
			fadeOut.Completed:Connect(function()
				oldest:Destroy()
			end)
			-- Update positions of remaining notifications
			task.wait(0.1)
			for i, notif in ipairs(activeNotifications) do
				TS:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
					Position = UDim2.new(0, 0, 0, (i-1) * 72)
				}):Play()
			end
		end
	end
	
	-- Create notification button (clickable)
	local Notif = Instance.new("TextButton")
	Notif.Size = UDim2.new(1, 0, 0, 65)
	Notif.Position = UDim2.new(1, 20, 0, #activeNotifications * 72)
	Notif.BackgroundColor3 = Themes[CT].accent2
	Notif.BorderSizePixel = 0
	Notif.AutoButtonColor = false
	Notif.Text = ""
	Notif.ZIndex = 501
	Notif.Parent = NotificationContainer
	
	Instance.new("UICorner", Notif).CornerRadius = UDim.new(0, 10)
	
	-- Gradient background
	local Gradient = Instance.new("UIGradient")
	Gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Themes[CT].accent2),
		ColorSequenceKeypoint.new(1, Color3.new(
			math.min(Themes[CT].accent2.R * 1.15, 1),
			math.min(Themes[CT].accent2.G * 1.15, 1),
			math.min(Themes[CT].accent2.B * 1.15, 1)
		))
	}
	Gradient.Rotation = 45
	Gradient.Parent = Notif
	
	-- Glowing border
	local NotifStroke = Instance.new("UIStroke")
	NotifStroke.Thickness = 1.5
	NotifStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	NotifStroke.Parent = Notif
	
	-- Animate border color
	task.spawn(function()
		while Notif and Notif.Parent do
			for i = 0, 1, 0.02 do
				if not Notif or not Notif.Parent then break end
				pcall(function()
					NotifStroke.Color = Color3.fromHSV(i, 0.6, 1)
				end)
				task.wait(0.05)
			end
		end
	end)
	
	-- Icon container
	local IconBg = Instance.new("Frame")
	IconBg.Size = UDim2.new(0, 40, 0, 40)
	IconBg.Position = UDim2.new(0, 8, 0.5, -20)
	IconBg.BackgroundColor3 = Themes[CT].accent
	IconBg.BorderSizePixel = 0
	IconBg.ZIndex = 502
	IconBg.Parent = Notif
	
	Instance.new("UICorner", IconBg).CornerRadius = UDim.new(0.3, 0)
	
	-- Icon
	local Icon = Instance.new("TextLabel")
	Icon.Size = UDim2.new(1, 0, 1, 0)
	Icon.BackgroundTransparency = 1
	Icon.Text = "✨"
	Icon.TextColor3 = Themes[CT].text
	Icon.Font = Enum.Font.GothamBold
	Icon.TextSize = 22
	Icon.ZIndex = 503
	Icon.Parent = IconBg
	
	-- Message
	local Msg = Instance.new("TextLabel")
	Msg.Size = UDim2.new(1, -65, 1, -20)
	Msg.Position = UDim2.new(0, 55, 0, 5)
	Msg.BackgroundTransparency = 1
	Msg.Text = message
	Msg.TextColor3 = Themes[CT].text
	Msg.Font = Enum.Font.Gotham
	Msg.TextSize = 13
	Msg.TextWrapped = true
	Msg.TextXAlignment = Enum.TextXAlignment.Left
	Msg.TextYAlignment = Enum.TextYAlignment.Top
	Msg.ZIndex = 502
	Msg.Parent = Notif
	
	-- Close button (X)
	local CloseBtn = Instance.new("TextButton")
	CloseBtn.Size = UDim2.new(0, 20, 0, 20)
	CloseBtn.Position = UDim2.new(1, -25, 0, 5)
	CloseBtn.BackgroundTransparency = 0.3
	CloseBtn.BackgroundColor3 = Themes[CT].accent
	CloseBtn.Text = "×"
	CloseBtn.TextColor3 = Themes[CT].text
	CloseBtn.Font = Enum.Font.GothamBold
	CloseBtn.TextSize = 16
	CloseBtn.BorderSizePixel = 0
	CloseBtn.AutoButtonColor = false
	CloseBtn.ZIndex = 504
	CloseBtn.Parent = Notif
	
	Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0.3, 0)
	
	-- Progress bar background
	local ProgressBg = Instance.new("Frame")
	ProgressBg.Size = UDim2.new(1, -16, 0, 2.5)
	ProgressBg.Position = UDim2.new(0, 8, 1, -7)
	ProgressBg.BackgroundColor3 = Themes[CT].accent
	ProgressBg.BackgroundTransparency = 0.5
	ProgressBg.BorderSizePixel = 0
	ProgressBg.ZIndex = 502
	ProgressBg.Parent = Notif
	
	Instance.new("UICorner", ProgressBg).CornerRadius = UDim.new(1, 0)
	
	-- Progress bar
	local Progress = Instance.new("Frame")
	Progress.Size = UDim2.new(1, 0, 1, 0)
	Progress.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
	Progress.BorderSizePixel = 0
	Progress.ZIndex = 503
	Progress.Parent = ProgressBg
	
	Instance.new("UICorner", Progress).CornerRadius = UDim.new(1, 0)
	
	-- Add shadow effect
	local Shadow = Instance.new("ImageLabel")
	Shadow.Size = UDim2.new(1, 20, 1, 20)
	Shadow.Position = UDim2.new(0, -10, 0, -10)
	Shadow.BackgroundTransparency = 1
	Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	Shadow.ImageColor3 = Color3.new(0, 0, 0)
	Shadow.ImageTransparency = 0.7
	Shadow.ScaleType = Enum.ScaleType.Slice
	Shadow.SliceCenter = Rect.new(10, 10, 10, 10)
	Shadow.ZIndex = 500
	Shadow.Parent = Notif
	
	-- Add to active list
	table.insert(activeNotifications, Notif)
	
	-- Slide in animation with bounce
	local slideIn = TS:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, 0, 0, (#activeNotifications - 1) * 72)
	})
	slideIn:Play()
	
	-- Progress bar animation
	local progressTween = TS:Create(Progress, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
		Size = UDim2.new(0, 0, 1, 0)
	})
	progressTween:Play()
	
	-- Remove notification function
	local function removeNotification()
		if not Notif or not Notif.Parent then return end
		
		-- Stop progress animation
		progressTween:Cancel()
		
		-- Remove from active list
		for i, notif in ipairs(activeNotifications) do
			if notif == Notif then
				table.remove(activeNotifications, i)
				break
			end
		end
		
		-- Slide out animation
		local slideOut = TS:Create(Notif, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 20, 0, Notif.Position.Y.Offset),
			BackgroundTransparency = 1
		})
		slideOut:Play()
		slideOut.Completed:Connect(function()
			Notif:Destroy()
			
			-- Update positions of remaining notifications
			for i, notif in ipairs(activeNotifications) do
				TS:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
					Position = UDim2.new(0, 0, 0, (i-1) * 72)
				}):Play()
			end
		end)
	end
	
	-- Click to close
	Notif.MouseButton1Click:Connect(removeNotification)
	CloseBtn.MouseButton1Click:Connect(removeNotification)
	
	-- Hover effect
	Notif.MouseEnter:Connect(function()
		TS:Create(Notif, TweenInfo.new(0.15), {
			Size = UDim2.new(1, 5, 0, 65),
			BackgroundColor3 = Color3.new(
				math.min(Themes[CT].accent2.R * 1.1, 1),
				math.min(Themes[CT].accent2.G * 1.1, 1),
				math.min(Themes[CT].accent2.B * 1.1, 1)
			)
		}):Play()
	end)
	
	Notif.MouseLeave:Connect(function()
		TS:Create(Notif, TweenInfo.new(0.15), {
			Size = UDim2.new(1, 0, 0, 65),
			BackgroundColor3 = Themes[CT].accent2
		}):Play()
	end)
	
	CloseBtn.MouseEnter:Connect(function()
		TS:Create(CloseBtn, TweenInfo.new(0.1), {
			BackgroundColor3 = Color3.fromRGB(255, 70, 70),
			BackgroundTransparency = 0
		}):Play()
	end)
	
	CloseBtn.MouseLeave:Connect(function()
		TS:Create(CloseBtn, TweenInfo.new(0.1), {
			BackgroundColor3 = Themes[CT].accent,
			BackgroundTransparency = 0.3
		}):Play()
	end)
	
	-- Auto remove after duration
	task.delay(duration, removeNotification)
	
	return Notif
end

-- Confirm dialog
local CF = Instance.new("Frame")
CF.Size = UDim2.new(0,380,0,190)
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
CFT.Size = UDim2.new(1,-40,0,55)
CFT.Position = UDim2.new(0,20,0,20)
CFT.BackgroundTransparency = 1
CFT.Text = "Close Script?"
CFT.TextColor3 = Themes[CT].text
CFT.Font = Enum.Font.GothamBold
CFT.TextSize = 22
CFT.ZIndex = 301
CFT.Parent = CF

local CFD = Instance.new("TextLabel")
CFD.Size = UDim2.new(1,-40,0,45)
CFD.Position = UDim2.new(0,20,0,75)
CFD.BackgroundTransparency = 1
CFD.Text = "Script will be completely closed.\nAre you sure?"
CFD.TextColor3 = Themes[CT].text
CFD.Font = Enum.Font.Gotham
CFD.TextSize = 15
CFD.TextWrapped = true
CFD.ZIndex = 301
CFD.Parent = CF

local YB = Instance.new("TextButton")
YB.Size = UDim2.new(0,160,0,42)
YB.Position = UDim2.new(0,20,1,-55)
YB.BackgroundColor3 = Color3.fromRGB(255,50,50)
YB.Text = "Yes"
YB.TextColor3 = Color3.new(1,1,1)
YB.Font = Enum.Font.GothamBold
YB.TextSize = 17
YB.BorderSizePixel = 0
YB.AutoButtonColor = false
YB.ZIndex = 302
YB.Parent = CF

Instance.new("UICorner",YB).CornerRadius = UDim.new(0,10)

local NB = Instance.new("TextButton")
NB.Size = UDim2.new(0,160,0,42)
NB.Position = UDim2.new(1,-180,1,-55)
NB.BackgroundColor3 = Themes[CT].accent
NB.Text = "No"
NB.TextColor3 = Themes[CT].text
NB.Font = Enum.Font.GothamBold
NB.TextSize = 17
NB.BorderSizePixel = 0
NB.AutoButtonColor = false
NB.ZIndex = 302
NB.Parent = CF

Instance.new("UICorner",NB).CornerRadius = UDim.new(0,10)

-- Page objects reference
local Pages = {
	Home = HP,
	Settings = SP,
	More = MP
}

-- Menu buttons
local menuBtns = {}
local function createMenu(name, icon, pos)
	local B = Instance.new("TextButton")
	B.Size = UDim2.new(1,-14,0,40)
	B.Position = UDim2.new(0,7,0,7+pos*48)
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
	L.TextSize = 15
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
	B.Size = UDim2.new(1,0,0,52)
	B.Position = UDim2.new(0,0,0,(i-1)*58)
	B.BackgroundColor3 = Themes[n].bg
	B.Text = ""
	B.BorderSizePixel = 0
	B.AutoButtonColor = false
	B.ZIndex = 104
	B.Parent = TL
	
	Instance.new("UICorner",B).CornerRadius = UDim.new(0,11)
	
	local L = Instance.new("TextLabel")
	L.Size = UDim2.new(1,-20,1,0)
	L.Position = UDim2.new(0,10,0,0)
	L.BackgroundTransparency = 1
	L.Text = n
	L.TextColor3 = Themes[n].text
	L.Font = Enum.Font.GothamBold
	L.TextSize = 17
	L.TextXAlignment = Enum.TextXAlignment.Left
	L.ZIndex = 105
	L.Parent = B
	
	themeBtns[n] = B
end

-- Functions
local function UpdateTheme(t)
	if t == CT then return end
	
	-- Store old theme for transition
	local oldTheme = CT
	CT = t
	
	-- Smooth color transition for all elements
	local transitionTime = 0.35
	local tweenInfo = TweenInfo.new(transitionTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	
	-- Main frame fade effect
	TS:Create(MF, tweenInfo, {BackgroundColor3 = Themes[t].bg}):Play()
	
	-- Text elements
	TS:Create(Title, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(Credit, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(HPT, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(HPD, tweenInfo, {TextColor3 = Themes[t].text}):Play()
	TS:Create(SPT, tweenInfo, {TextColor3 = Themes[t].text}):Play()
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
	
	-- Add a subtle flash effect on theme change
	local flash = Instance.new("Frame")
	flash.Size = UDim2.new(1, 0, 1, 0)
	flash.Position = UDim2.new(0, 0, 0, 0)
	flash.BackgroundColor3 = Themes[t].text
	flash.BackgroundTransparency = 0.85
	flash.BorderSizePixel = 0
	flash.ZIndex = 999
	flash.Parent = MF
	
	local flashTween = TS:Create(flash, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1
	})
	flashTween:Play()
	flashTween.Completed:Connect(function()
		flash:Destroy()
	end)
	
	-- Show notification
	CreateNotification("Theme changed to " .. t, 3)
	
	SaveTheme(t)
end

-- Get page index
local function GetPageIndex(pageName)
	for i, name in ipairs(PageOrder) do
		if name == pageName then
			return i
		end
	end
	return 1
end

-- Page switch with smooth continuous transition (UP/DOWN)
local function SwitchPage(targetPage)
	if isSwitchingPage then return end
	if CP == targetPage then return end
	
	isSwitchingPage = true
	
	local currentIndex = GetPageIndex(CP)
	local targetIndex = GetPageIndex(targetPage)
	local direction = (targetIndex > currentIndex) and 1 or -1
	local distance = math.abs(targetIndex - currentIndex)
	
	local currentPageObj = Pages[CP]
	local targetPageObj = Pages[targetPage]
	
	-- Calculate total animation time based on distance
	local totalTime = 0.2 * distance
	
	-- Hide all pages first
	for _, page in pairs(Pages) do
		if page ~= currentPageObj then
			page.Visible = false
			page.Position = UDim2.new(0, 0, 0, 0)
		end
	end
	
	-- If moving through middle pages, show them briefly during transition
	if distance > 1 then
		-- Show all middle pages in correct positions
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
	
	-- Prepare target page
	local startOffset = direction * distance
	targetPageObj.Position = UDim2.new(0, 0, startOffset, 0)
	targetPageObj.Visible = true
	
	-- Animate all visible pages smoothly
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
				-- Hide all pages except target
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
	
	-- Update current page
	CP = targetPage
	
	-- Update menu buttons with smooth animation
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
		TS:Create(TL,TweenInfo.new(0.3),{Size=UDim2.new(1,0,0,242)}):Play()
		TS:Create(TDDA,TweenInfo.new(0.3),{Rotation=180}):Play()
	else
		local tw = TS:Create(TL,TweenInfo.new(0.25),{Size=UDim2.new(1,0,0,0)})
		tw:Play()
		tw.Completed:Connect(function() TL.Visible=false end)
		TS:Create(TDDA,TweenInfo.new(0.25),{Rotation=0}):Play()
	end
	
	task.wait(0.35)
	isAnimating = false
end

local function ShowFrame()
	if isAnimating then return end
	isAnimating = true
	
	MF.Visible = true
	MF.Size = UDim2.new(0,0,0,0)
	local tw = TS:Create(MF,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,600,0,380)})
	tw:Play()
	tw.Completed:Connect(function()
		isAnimating = false
	end)
end

local function HideFrame()
	if isAnimating then return end
	isAnimating = true
	
	local tw = TS:Create(MF,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)})
	tw:Play()
	tw.Completed:Connect(function() 
		MF.Visible=false
		isAnimating = false
	end)
end

local function ShowConfirm()
	if isAnimating then return end
	isAnimating = true
	
	CF.Visible = true
	CF.Size = UDim2.new(0,0,0,0)
	local tw = TS:Create(CF,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,380,0,190)})
	tw:Play()
	tw.Completed:Connect(function()
		isAnimating = false
	end)
end

local function HideConfirm()
	if isAnimating then return end
	isAnimating = true
	
	local tw = TS:Create(CF,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)})
	tw:Play()
	tw.Completed:Connect(function() 
		CF.Visible=false
		isAnimating = false
	end)
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

-- Hover effects with spam protection
local hoverConnections = {}

local function safeHover(obj, hoverTween, leaveTween)
	if hoverConnections[obj] then return end
	
	hoverConnections[obj] = true
	
	obj.MouseEnter:Connect(function()
		hoverTween()
	end)
	
	obj.MouseLeave:Connect(function()
		leaveTween()
	end)
end

safeHover(TB,
	function() TS:Create(TB,TweenInfo.new(0.2),{Size=UDim2.new(0,46,0,46)}):Play() end,
	function() TS:Create(TB,TweenInfo.new(0.2),{Size=UDim2.new(0,42,0,42)}):Play() end
)

safeHover(CB,
	function() TS:Create(CB,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(255,60,60),TextColor3=Color3.new(1,1,1)}):Play() end,
	function() TS:Create(CB,TweenInfo.new(0.15),{BackgroundColor3=Themes[CT].accent,TextColor3=Themes[CT].text}):Play() end
)

for n,d in pairs(menuBtns) do
	safeHover(d.btn,
		function()
			if CP~=n then
				TS:Create(d.btn,TweenInfo.new(0.15),{BackgroundColor3=Themes[CT].accent,BackgroundTransparency=0.5}):Play()
			end
		end,
		function()
			if CP~=n then
				TS:Create(d.btn,TweenInfo.new(0.15),{BackgroundTransparency=1}):Play()
			end
		end
	)
end

for n,b in pairs(themeBtns) do
	safeHover(b,
		function()
			local bright=Color3.new(
				math.min(Themes[n].bg.R*1.25,1),
				math.min(Themes[n].bg.G*1.25,1),
				math.min(Themes[n].bg.B*1.25,1)
			)
			TS:Create(b,TweenInfo.new(0.15),{BackgroundColor3=bright}):Play()
		end,
		function()
			TS:Create(b,TweenInfo.new(0.15),{BackgroundColor3=Themes[n].bg}):Play()
		end
	)
end

safeHover(TDD,
	function()
		local bright=Color3.new(
			math.min(Themes[CT].accent2.R*1.15,1),
			math.min(Themes[CT].accent2.G*1.15,1),
			math.min(Themes[CT].accent2.B*1.15,1)
		)
		TS:Create(TDD,TweenInfo.new(0.15),{BackgroundColor3=bright}):Play()
	end,
	function()
		TS:Create(TDD,TweenInfo.new(0.15),{BackgroundColor3=Themes[CT].accent2}):Play()
	end
)

safeHover(YB,
	function() TS:Create(YB,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(220,40,40)}):Play() end,
	function() TS:Create(YB,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(255,50,50)}):Play() end
)

safeHover(NB,
	function()
		local bright=Color3.new(
			math.min(Themes[CT].accent.R*1.2,1),
			math.min(Themes[CT].accent.G*1.2,1),
			math.min(Themes[CT].accent.B*1.2,1)
		)
		TS:Create(NB,TweenInfo.new(0.12),{BackgroundColor3=bright}):Play()
	end,
	function()
		TS:Create(NB,TweenInfo.new(0.12),{BackgroundColor3=Themes[CT].accent}):Play()
	end
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

-- Drag toggle button
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

-- Resize from 4 corners
local resizing,resizeType,resizeStart,startSize,startPos
local minSize=Vector2.new(500,350)
local maxSize=Vector2.new(900,700)

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

print("✅ Stylish GUI v4 loaded successfully!")
print("🎨 Current theme:",CT)
print("💎 Created by tru897tr")

-- Show welcome notification
task.delay(0.5, function()
	CreateNotification("Welcome to the script! Hope you have a great experience.", 5)
end)

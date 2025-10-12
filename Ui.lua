--[[
🌈 Stylish GUI v4 - Professional Edition
💎 Clean design, smooth animations
📱 Mobile & PC support
--]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

local plr = Players.LocalPlayer

-- Key check
if (getgenv().Key or "") ~= "tru897tr" then
	plr:Kick("Invalid Key! Use: getgenv().Key = \"tru897tr\"")
	return
end
getgenv().Key = nil

-- Anti-duplicate
local ID = "StyleGUI_" .. plr.UserId
if _G[ID] then
	plr:Kick("Already running!")
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
	if isfile and readfile then
		local s,d = pcall(readfile, "theme.txt")
		if s and d ~= "" then return d end
	end
	return "Dark"
end

local function SaveTheme(t)
	if writefile then pcall(writefile, "theme.txt", t) end
end

local CT = ReadTheme()
if not Themes[CT] then CT = "Dark" end
local CP = "Home"

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

-- Resize handles (invisible, 4 corners only)
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
	CT = t
	MF.BackgroundColor3 = Themes[t].bg
	Title.TextColor3 = Themes[t].text
	Credit.TextColor3 = Themes[t].text
	HPT.TextColor3 = Themes[t].text
	HPD.TextColor3 = Themes[t].text
	SPT.TextColor3 = Themes[t].text
	TDDL.TextColor3 = Themes[t].text
	TDDA.TextColor3 = Themes[t].text
	TDD.BackgroundColor3 = Themes[t].accent2
	CB.BackgroundColor3 = Themes[t].accent
	CB.TextColor3 = Themes[t].text
	TB.BackgroundColor3 = Themes[t].toggle
	SB.BackgroundColor3 = Themes[t].accent2
	SB.ScrollBarImageColor3 = Themes[t].accent
	CA.ScrollBarImageColor3 = Themes[t].accent
	CF.BackgroundColor3 = Themes[t].bg
	CFT.TextColor3 = Themes[t].text
	CFD.TextColor3 = Themes[t].text
	NB.BackgroundColor3 = Themes[t].accent
	NB.TextColor3 = Themes[t].text
	
	for i=0,2 do
		local L = IC:FindFirstChild("L"..i)
		if L then L.BackgroundColor3 = Themes[t].text end
	end
	
	for n,d in pairs(menuBtns) do
		d.lbl.TextColor3 = Themes[t].text
		if CP==n then
			d.btn.BackgroundColor3 = Themes[t].accent
			d.btn.BackgroundTransparency = 0
		end
	end
	
	SaveTheme(t)
end

local function SwitchPage(p)
	CP = p
	HP.Visible = (p=="Home")
	SP.Visible = (p=="Settings")
	
	for n,d in pairs(menuBtns) do
		if n==p then
			TS:Create(d.btn,TweenInfo.new(0.2),{BackgroundColor3=Themes[CT].accent,BackgroundTransparency=0}):Play()
		else
			TS:Create(d.btn,TweenInfo.new(0.2),{BackgroundTransparency=1}):Play()
		end
	end
end

local function ToggleTheme()
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
end

local function ShowFrame()
	MF.Visible = true
	MF.Size = UDim2.new(0,0,0,0)
	TS:Create(MF,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,600,0,380)}):Play()
end

local function HideFrame()
	local tw = TS:Create(MF,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)})
	tw:Play()
	tw.Completed:Connect(function() MF.Visible=false end)
end

local function ShowConfirm()
	CF.Visible = true
	CF.Size = UDim2.new(0,0,0,0)
	TS:Create(CF,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,380,0,190)}):Play()
end

local function HideConfirm()
	local tw = TS:Create(CF,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)})
	tw:Play()
	tw.Completed:Connect(function() CF.Visible=false end)
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
TB.MouseEnter:Connect(function()
	TS:Create(TB,TweenInfo.new(0.2),{Size=UDim2.new(0,46,0,46)}):Play()
end)
TB.MouseLeave:Connect(function()
	TS:Create(TB,TweenInfo.new(0.2),{Size=UDim2.new(0,42,0,42)}):Play()
end)

CB.MouseEnter:Connect(function()
	TS:Create(CB,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(255,60,60),TextColor3=Color3.new(1,1,1)}):Play()
end)
CB.MouseLeave:Connect(function()
	TS:Create(CB,TweenInfo.new(0.15),{BackgroundColor3=Themes[CT].accent,TextColor3=Themes[CT].text}):Play()
end)

for n,d in pairs(menuBtns) do
	d.btn.MouseEnter:Connect(function()
		if CP~=n then
			TS:Create(d.btn,TweenInfo.new(0.15),{BackgroundColor3=Themes[CT].accent,BackgroundTransparency=0.5}):Play()
		end
	end)
	d.btn.MouseLeave:Connect(function()
		if CP~=n then
			TS:Create(d.btn,TweenInfo.new(0.15),{BackgroundTransparency=1}):Play()
		end
	end)
end

for n,b in pairs(themeBtns) do
	b.MouseEnter:Connect(function()
		local bright=Color3.new(
			math.min(Themes[n].bg.R*1.25,1),
			math.min(Themes[n].bg.G*1.25,1),
			math.min(Themes[n].bg.B*1.25,1)
		)
		TS:Create(b,TweenInfo.new(0.15),{BackgroundColor3=bright}):Play()
	end)
	b.MouseLeave:Connect(function()
		TS:Create(b,TweenInfo.new(0.15),{BackgroundColor3=Themes[n].bg}):Play()
	end)
end

TDD.MouseEnter:Connect(function()
	local bright=Color3.new(
		math.min(Themes[CT].accent2.R*1.15,1),
		math.min(Themes[CT].accent2.G*1.15,1),
		math.min(Themes[CT].accent2.B*1.15,1)
	)
	TS:Create(TDD,TweenInfo.new(0.15),{BackgroundColor3=bright}):Play()
end)
TDD.MouseLeave:Connect(function()
	TS:Create(TDD,TweenInfo.new(0.15),{BackgroundColor3=Themes[CT].accent2}):Play()
end)

YB.MouseEnter:Connect(function()
	TS:Create(YB,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(220,40,40)}):Play()
end)
YB.MouseLeave:Connect(function()
	TS:Create(YB,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(255,50,50)}):Play()
end)

NB.MouseEnter:Connect(function()
	local bright=Color3.new(
		math.min(Themes[CT].accent.R*1.2,1),
		math.min(Themes[CT].accent.G*1.2,1),
		math.min(Themes[CT].accent.B*1.2,1)
	)
	TS:Create(NB,TweenInfo.new(0.12),{BackgroundColor3=bright}):Play()
end)
NB.MouseLeave:Connect(function()
	TS:Create(NB,TweenInfo.new(0.12),{BackgroundColor3=Themes[CT].accent}):Play()
end)

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

-- Resize from 4 corners (invisible handles)
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
			-- Bottom-Right: expand width and height
			newW=math.clamp(startSize.X+delta.X,minSize.X,maxSize.X)
			newH=math.clamp(startSize.Y+delta.Y,minSize.Y,maxSize.Y)
		elseif resizeType=="BL" then
			-- Bottom-Left: contract width (move left), expand height
			local tempW=math.clamp(startSize.X-delta.X,minSize.X,maxSize.X)
			newW=tempW
			newH=math.clamp(startSize.Y+delta.Y,minSize.Y,maxSize.Y)
			newX=startPos.X.Offset+(startSize.X-tempW)
		elseif resizeType=="TR" then
			-- Top-Right: expand width, contract height (move up)
			newW=math.clamp(startSize.X+delta.X,minSize.X,maxSize.X)
			local tempH=math.clamp(startSize.Y-delta.Y,minSize.Y,maxSize.Y)
			newH=tempH
			newY=startPos.Y.Offset+(startSize.Y-tempH)
		elseif resizeType=="TL" then
			-- Top-Left: contract width (move left), contract height (move up)
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
print("📍 Click toggle button to open GUI")
print("💎 Created by tru897tr")

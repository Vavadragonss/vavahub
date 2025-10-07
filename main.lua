local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Vavahub",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Vavahub",
   LoadingSubtitle = "by Vavadragons",
   ShowText = "Show", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Vavahub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Vavahub Keysystem",
      Subtitle = "Key System",
      Note = "obtain a key with skill", -- Use this to tell the user how to get a key
      FileName = "VavahubKeyV1", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"nebulaexecutor2123","nebulaexecutor9210238123"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("Main", nil) -- Title, Image
local MainSection = MainTab:CreateSection("Aimbot")

local Button = MainTab:CreateButton({
   Name = "Aimbot (PRESS B TO TOGGLE)",
   Callback = function()
-- LocalScript - Persistent Aimlock UI with FriendCheck + No Dead Lock
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Settings
local AIMLOCK_KEY = Enum.KeyCode.B
local AIMLOCK_ENABLED = false
local LockPartOption = "Head" -- "Head" or "Body"
local FriendCheck = true
local WallCheck = true

-- Manual friend list (replace with your friends' UserIds)
local FriendIds = {
    [4652932604] = true,
    [2482480667] = true,
    [4792065404] = true,
    [8238694581] = true,
    [4826160344] = true,
    [1604362429] = true,
	[9342212559] = true, --ben alt
	[5007463912] = true, --jensen sister
	[2004490548] = true, --jensen alt
}

-- Helpers
local function isFriend(player)
    return FriendCheck and FriendIds[player.UserId]
end

local function canSee(part)
    if not WallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = part.Position - origin
    local ray = Ray.new(origin, direction)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
    return hit and hit:IsDescendantOf(part.Parent)
end

-- Get nearest valid target
local function getNearestTarget()
    local nearestDist = math.huge
    local nearestPlayer = nil

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            
            -- Must have HRP + Humanoid and not be dead
            if hrp and hum and hum.Health > 0 then
                if isFriend(player) then continue end
                
                local part = (LockPartOption == "Head")
                    and player.Character:FindFirstChild("Head")
                    or hrp

                if part and canSee(part) then
                    local dist = (Camera.CFrame.Position - part.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestPlayer = player
                    end
                end
            end
        end
    end

    return nearestPlayer
end

-- GUI
local CoreGui = game:GetService("CoreGui")
local gui = Instance.new("ScreenGui")
gui.Name = "AimlockGui"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.5, -110, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active, frame.Draggable = true, true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Aimlock"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.Font = Enum.Font.SourceSansBold

-- Close button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,24)
closeBtn.Position = UDim2.new(1,-35,0,3)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.MouseButton1Click:Connect(function()
    AIMLOCK_ENABLED = false
    gui:Destroy()
end)

-- Enable button
local enableBtn = Instance.new("TextButton", frame)
enableBtn.Size = UDim2.new(0, 100, 0, 30)
enableBtn.Position = UDim2.new(0.5, -50, 0, 40)
enableBtn.Text = "Enable"
enableBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
enableBtn.TextColor3 = Color3.new(1,1,1)
enableBtn.Font = Enum.Font.SourceSansBold
enableBtn.MouseButton1Click:Connect(function()
    AIMLOCK_ENABLED = not AIMLOCK_ENABLED
    enableBtn.Text = AIMLOCK_ENABLED and "Disable" or "Enable"
    enableBtn.BackgroundColor3 = AIMLOCK_ENABLED and Color3.fromRGB(200,0,0) or Color3.fromRGB(0,200,0)
end)

-- Head/Body selection button
local partBtn = Instance.new("TextButton", frame)
partBtn.Size = UDim2.new(0,100,0,30)
partBtn.Position = UDim2.new(0.5,-50,0,75)
partBtn.Text = "Part: "..LockPartOption
partBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
partBtn.TextColor3 = Color3.new(1,1,1)
partBtn.Font = Enum.Font.SourceSans
partBtn.MouseButton1Click:Connect(function()
    LockPartOption = (LockPartOption == "Head") and "Body" or "Head"
    partBtn.Text = "Part: "..LockPartOption
end)

-- FriendCheck toggle button
local friendBtn = Instance.new("TextButton", frame)
friendBtn.Size = UDim2.new(0,100,0,30)
friendBtn.Position = UDim2.new(0.5,-50,0,110)
friendBtn.Text = "FriendCheck: "..tostring(FriendCheck)
friendBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
friendBtn.TextColor3 = Color3.new(1,1,1)
friendBtn.Font = Enum.Font.SourceSans
friendBtn.MouseButton1Click:Connect(function()
    FriendCheck = not FriendCheck
    friendBtn.Text = "FriendCheck: "..tostring(FriendCheck)
end)

-- WallCheck toggle button
local wallBtn = Instance.new("TextButton", frame)
wallBtn.Size = UDim2.new(0,100,0,30)
wallBtn.Position = UDim2.new(0.5,-50,0,145)
wallBtn.Text = "WallCheck: "..tostring(WallCheck)
wallBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
wallBtn.TextColor3 = Color3.new(1,1,1)
wallBtn.Font = Enum.Font.SourceSans
wallBtn.MouseButton1Click:Connect(function()
    WallCheck = not WallCheck
    wallBtn.Text = "WallCheck: "..tostring(WallCheck)
end)

-- Keybind toggle
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == AIMLOCK_KEY then
        AIMLOCK_ENABLED = not AIMLOCK_ENABLED
        enableBtn.Text = AIMLOCK_ENABLED and "Disable" or "Enable"
        enableBtn.BackgroundColor3 = AIMLOCK_ENABLED and Color3.fromRGB(200,0,0) or Color3.fromRGB(0,200,0)
    end
end)

-- Aimlock loop
RunService.RenderStepped:Connect(function()
    if AIMLOCK_ENABLED then
        local target = getNearestTarget()
        if target and target.Character then
            local part = (LockPartOption == "Head")
                and target.Character:FindFirstChild("Head")
                or target.Character:FindFirstChild("HumanoidRootPart")

            if part then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            end
        end
    end
end)




   end,
})

local Slider = MainTab:CreateSlider({
   Name = "Walkspeed",
   Range = {0, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedConfig", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = (Value)
   end,
})

local Button = MainTab:CreateButton({
   Name = "Silent Aim",
   Callback = function()
		local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local aiming = false
local FOVRadius = 200 -- pixels
local FOVCircle -- Drawing the visible FOV circle
local targetPlayer = nil

-- Create a ScreenGui with a Frame to visualize FOV
local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))

local fovFrame = Instance.new("Frame")
fovFrame.Size = UDim2.new(0, FOVRadius*2, 0, FOVRadius*2)
fovFrame.Position = UDim2.new(0.5, -FOVRadius, 0.5, -FOVRadius)
fovFrame.BackgroundColor3 = Color3.new(1, 1, 1)
fovFrame.BackgroundTransparency = 0.5
fovFrame.BorderSizePixel = 0
fovFrame.Parent = screenGui

local function getNearestPlayerInFOV()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local myCharacter = LocalPlayer.Character
    if not myCharacter or not myCharacter:FindFirstChild("Head") then return nil end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
            if onScreen then
                local delta = Vector2.new(screenPos.X - Mouse.X, screenPos.Y - Mouse.Y)
                local distance = delta.Magnitude
                if distance <= FOVRadius then
                    -- Check line of sight
                    local origin = Camera.CFrame.Position
                    local direction = (head.Position - origin).unit * 500
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                    local result = workspace:Raycast(origin, direction, rayParams)
                    if not result or result.Instance:IsDescendantOf(player.Character) then
                        if distance < shortestDistance then
                            shortestDistance = distance
                            nearestPlayer = player
                        end
                    end
                end
            end
        end
    end
    return nearestPlayer
end

-- Detect shooting
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- On click, shoot at target if in FOV
        targetPlayer = getNearestPlayerInFOV()
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
            -- Aim at target's head (silent)
            -- You can simulate hit detection here or just "auto-aim"
            -- For example, you might fire a remote event to register a hit
            print("Shooting at: " .. targetPlayer.Name)
            -- Example: you could also set the mouse target to the head for a quick aim
            -- Mouse.TargetFilter = targetPlayer.Character.Head
        end
    end
end)

-- Keep updating the circle position
RunService.RenderStepped:Connect(function()
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    fovFrame.Position = UDim2.new(0, mousePos.X - FOVRadius, 0, mousePos.Y - FOVRadius)
end)
   end,
})

local HubsTab = Window:CreateTab("Hubs", nil) -- Title, Image

local Button = HubsTab:CreateButton({
   Name = "Infinite Yeild",
   Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
   end,
})

local Button = HubsTab:CreateButton({
   Name = "Free Private Server (MADE BY VAVADRAGONS)",
   Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/veil0x14/LocalScripts/refs/heads/main/pg.lua"))()   end,
})

local Button = HubsTab:CreateButton({
   Name = "Fling UI (made by me in 2 mins)",
   Callback = function()
		-- Paste into Studio Command Bar while playtesting
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FlingGUI"
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 300)
frame.Position = UDim2.new(0.5, -160, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.TextColor3 = Color3.new(1,1,1)
title.Text = "Fling Tool"
title.Parent = frame

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,50,0,25)
closeBtn.Position = UDim2.new(1,-55,0,5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Username input
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1,-20,0,30)
inputBox.Position = UDim2.new(0,10,0,50)
inputBox.PlaceholderText = "Type first 4 letters of username"
inputBox.Text = ""
inputBox.ClearTextOnFocus = false
inputBox.TextColor3 = Color3.new(1,1,1)
inputBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
inputBox.Parent = frame

-- Rotation input
local rotationBox = Instance.new("TextBox")
rotationBox.Size = UDim2.new(1,-20,0,30)
rotationBox.Position = UDim2.new(0,10,0,90)
rotationBox.PlaceholderText = "Rotation per step (degrees)"
rotationBox.Text = "45"
rotationBox.ClearTextOnFocus = false
rotationBox.TextColor3 = Color3.new(1,1,1)
rotationBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
rotationBox.Parent = frame

-- Fling time input
local timeBox = Instance.new("TextBox")
timeBox.Size = UDim2.new(1,-20,0,30)
timeBox.Position = UDim2.new(0,10,0,130)
timeBox.PlaceholderText = "Fling time (seconds)"
timeBox.Text = "0.5"
timeBox.ClearTextOnFocus = false
timeBox.TextColor3 = Color3.new(1,1,1)
timeBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
timeBox.Parent = frame

-- Fling button
local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(1,-20,0,40)
flingBtn.Position = UDim2.new(0,10,0,180)
flingBtn.Text = "Fling Player"
flingBtn.TextColor3 = Color3.new(1,1,1)
flingBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
flingBtn.Parent = frame

-- Fling logic
flingBtn.MouseButton1Click:Connect(function()
    local usernameInput = inputBox.Text:lower()
    if #usernameInput < 1 then return end

    local targetPlayer
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Name:lower():sub(1, #usernameInput) == usernameInput then
            targetPlayer = pl
            break
        end
    end
    if not targetPlayer or not targetPlayer.Character then return end

    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP or not myHRP or not targetHumanoid then return end

    -- Get values from textboxes
    local rotationDeg = tonumber(rotationBox.Text) or 45
    local flingTime = tonumber(timeBox.Text) or 0.5
    local steps = 20
    local stepDelay = flingTime/steps

    local originalPos = myHRP.Position

    for i=1,steps do
        -- Teleport near target
        local offset = Vector3.new((math.random()-0.5)*2, math.random()*1.5, (math.random()-0.5)*2) * 3
        myHRP.CFrame = targetHRP.CFrame + offset

        -- Spin and flip
        local angleY = math.rad(rotationDeg)
        local flip = math.rad(180) * (i%2) -- alternate upside down
        targetHRP.CFrame = targetHRP.CFrame * CFrame.Angles(flip, angleY, 0)

        RunService.Heartbeat:Wait()
    end

    myHRP.CFrame = CFrame.new(originalPos)
end)

   end,
})

local Button = HubsTab:CreateButton({
   Name = "ESP",
   Callback = function()
-- Robust Studio ESP with Username, Health, Distance, Close Button, and Draggable Frame
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Folder to hold ESP GUIs
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = workspace

local espEnabled = true
local ESPs = {}

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ESPControlGui"
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 80) -- bigger frame for easier dragging
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title label
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.Text = "ESP Control"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.Parent = frame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1,-20,0,25)
toggleBtn.Position = UDim2.new(0,10,0,35)
toggleBtn.Text = "Toggle ESP"
toggleBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Parent = frame

toggleBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    for _, v in pairs(ESPs) do
        v.Billboard.Enabled = espEnabled
    end
end)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40,0,25)
closeBtn.Position = UDim2.new(1,-45,0,35)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    ESPFolder:Destroy()
end)

-- Function to create ESP for a player
local function createESP(player)
    if player == LocalPlayer then return end

    local function setupCharacter(char)
        local hrp = char:WaitForChild("HumanoidRootPart")
        local humanoid = char:WaitForChild("Humanoid")

        local billboard = Instance.new("BillboardGui")
        billboard.Name = player.Name.."_ESP"
        billboard.Adornee = hrp
        billboard.Size = UDim2.new(0,160,0,50)
        billboard.StudsOffset = Vector3.new(0,3,0)
        billboard.AlwaysOnTop = true
        billboard.Enabled = espEnabled
        billboard.Parent = ESPFolder

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Text = ""
        label.Parent = billboard

        ESPs[player] = {Billboard = billboard, Label = label, HRP = hrp, Humanoid = humanoid}
    end

    if player.Character then
        setupCharacter(player.Character)
    end
    player.CharacterAdded:Connect(setupCharacter)
end

-- Create ESPs for all existing players
for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

-- Setup ESP for new players
Players.PlayerAdded:Connect(createESP)

-- Update ESPs every frame
RunService.RenderStepped:Connect(function()
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end

    for player, data in pairs(ESPs) do
        if data.HRP and data.Humanoid then
            local dist = (data.HRP.Position - myHRP.Position).Magnitude
            data.Label.Text = string.format("%s | HP: %d | Dist: %.1f", player.Name, math.floor(data.Humanoid.Health), dist)
        end
    end
end)



   end,
})

local Button = MainTab:CreateButton({
   Name = "Rejoin Game",
   Callback = function()
		local TeleportService = game:GetService("TeleportService")
local placeId = game.PlaceId -- teleport to same place

-- This will teleport the player to the same game
TeleportService:Teleport(placeId, game.Players.LocalPlayer)

   end,
})

local NightsTab = Window:CreateTab("99 Nights In The Forest", nil) -- Title, Image

local Button = NightsTab:CreateButton({
   Name = "Item Teleport UI (Requires max campfire level - still usable without)",
   Callback = function()
   -- Teleport Models GUI auto-populated
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportModelsGui"
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 170)
frame.Position = UDim2.new(0.5, -150, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Item Teleporter"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.Parent = frame

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,50,0,25)
closeBtn.Position = UDim2.new(1,-55,0,5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Helper: get PrimaryPart of model
local function getPrimaryPart(model)
    if model.PrimaryPart then return model.PrimaryPart end
    for _, p in pairs(model:GetDescendants()) do
        if p:IsA("BasePart") then return p end
    end
    return nil
end

-- Teleport function (first instance of a given name)
local function teleportFirstItem(names)
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local itemsFolder = workspace:FindFirstChild("Items")
    if not itemsFolder then return end

    for _, item in pairs(itemsFolder:GetChildren()) do
        if table.find(names, item.Name) then
            local part = getPrimaryPart(item)
            if part then
                hrp.CFrame = part.CFrame + Vector3.new(0,3,0)
                break -- teleport only to first available
            end
        end
    end
end

-- Logs Button
local logsBtn = Instance.new("TextButton")
logsBtn.Size = UDim2.new(0, 150, 0, 30)
logsBtn.Position = UDim2.new(0, 10, 0, 40)
logsBtn.Text = "Teleport First Log"
logsBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
logsBtn.TextColor3 = Color3.new(1,1,1)
logsBtn.Parent = frame
logsBtn.MouseButton1Click:Connect(function()
    teleportFirstItem({"Log"})
end)

-- ScrollFrame for dynamic items
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0, 150, 0, 100)
scrollFrame.Position = UDim2.new(0, 10, 0, 75)
scrollFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = frame

-- Populate scrollFrame with **unique item names**
local itemsFolder = workspace:FindFirstChild("Items")
if itemsFolder then
    local uniqueNames = {}
    for _, item in pairs(itemsFolder:GetChildren()) do
        if not table.find(uniqueNames, item.Name) then
            table.insert(uniqueNames, item.Name)
        end
    end

    for i, name in ipairs(uniqueNames) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,-10,0,25)
        btn.Position = UDim2.new(0,5,0,(i-1)*30)
        btn.Text = "Teleport "..name
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Parent = scrollFrame
        btn.MouseButton1Click:Connect(function()
            teleportFirstItem({name})
        end)
    end

    -- Fix CanvasSize for scrolling
    local totalHeight = #uniqueNames * 30
    scrollFrame.CanvasSize = UDim2.new(0,0,0, math.max(totalHeight, scrollFrame.AbsoluteSize.Y))
end

   end,
})

local Button = NightsTab:CreateButton({
   Name = "Teleport to trees (buggy)",
   Callback = function()
			-- Auto-Chop Trees (Teleport Only)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AutoChopGui"
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,30)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Auto-Chop Trees"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0,40,0,20)
closeBtn.Position = UDim2.new(1,-45,0,5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 100, 0, 40)
toggleBtn.Position = UDim2.new(0.5, -50, 0, 40)
toggleBtn.Text = "OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Parent = frame

local toggled = false
toggleBtn.MouseButton1Click:Connect(function()
    toggled = not toggled
    if toggled then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
        toggleBtn.Text = "ON"
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
        toggleBtn.Text = "OFF"
    end
end)

-- Helper: get PrimaryPart of a model
local function getPrimaryPart(model)
    if model.PrimaryPart then return model.PrimaryPart end
    for _, p in pairs(model:GetDescendants()) do
        if p:IsA("BasePart") then return p end
    end
    return nil
end

-- Helper: find closest tree
local function getClosestTree()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local foliage = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Foliage")
    if not foliage then return nil end

    local closest = nil
    local closestDist = math.huge
    for _, tree in pairs(foliage:GetChildren()) do
        if tree.Name == "Small Tree" then
            local part = getPrimaryPart(tree)
            if part then
                local dist = (hrp.Position - part.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = tree
                end
            end
        end
    end
    return closest
end

spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if toggled then
            local tree = getClosestTree()
            if tree then
                local part = getPrimaryPart(tree)
                if part then
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = part.CFrame + Vector3.new(0,3,0)
                    end
                    wait(0.5)
                end
            end
        end
    end
end)

   end,
})

local DrivingEmpireTab = Window:CreateTab("Driving Empire", nil) -- Title, Image

local Button = DrivingEmpireTab:CreateButton({
   Name = "AutoFarm GUI",
   Callback = function()
		-- LocalScript - AutoFarm Drive 10s → Teleport Vehicle Back (Fixed 90° left, 5Y higher)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

-- CONFIG
local START_POS = Vector3.new(-10740, 12.1, -2490)
local FIXED_CFRAME = CFrame.new(START_POS) * CFrame.Angles(0, math.rad(-90), 0) -- 90° left
local DRIVE_DURATION = 10 -- seconds
local TELEPORT_HEIGHT = 5 -- studs above ground

-- state
local autoFarm = false
local farmingCoroutine

-- GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AutoFarmGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 280, 0, 180)
frame.Position = UDim2.new(0.5, -140, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active, frame.Draggable = true, true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "AutoFarm Driver"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(50,50,50)
title.Font = Enum.Font.SourceSansBold

-- Close button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,40,0,24)
closeBtn.Position = UDim2.new(1,-45,0,3)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.MouseButton1Click:Connect(function()
    autoFarm = false
    gui:Destroy()
    pcall(function() VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game) end)
end)

-- Toggle button
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0,140,0,40)
toggleBtn.Position = UDim2.new(0.5,-70,0,40)
toggleBtn.Text = "OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.SourceSansBold

-- Teleport to Start button
local tpStartBtn = Instance.new("TextButton", frame)
tpStartBtn.Size = UDim2.new(0,180,0,36)
tpStartBtn.Position = UDim2.new(0.5,-90,0,92)
tpStartBtn.Text = "Teleport to Start"
tpStartBtn.BackgroundColor3 = Color3.fromRGB(0,120,200)
tpStartBtn.TextColor3 = Color3.new(1,1,1)
tpStartBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local seat = char:FindFirstChildWhichIsA("VehicleSeat")
        if not seat then
            for _, s in pairs(workspace:GetDescendants()) do
                if s:IsA("VehicleSeat") and s.Occupant and s.Occupant.Parent == char then
                    seat = s
                    break
                end
            end
        end
        if seat then
            local vehicle = seat.Parent
            if vehicle:IsA("Model") and vehicle.PrimaryPart then
                vehicle:SetPrimaryPartCFrame(FIXED_CFRAME + Vector3.new(0, TELEPORT_HEIGHT, 0))
            elseif vehicle:IsA("Model") then
                for _, p in pairs(vehicle:GetChildren()) do
                    if p:IsA("BasePart") then
                        p.CFrame = FIXED_CFRAME + Vector3.new(0, TELEPORT_HEIGHT, 0)
                    end
                end
            end
        else
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = FIXED_CFRAME + Vector3.new(0, TELEPORT_HEIGHT, 0) end
        end
    end
end)

-- helpers
local function pressW(down)
    pcall(function() VirtualInputManager:SendKeyEvent(down, Enum.KeyCode.W, false, game) end)
end

-- teleport back (always faces fixed direction, 5Y higher)
local function teleportBack()
    local char = LocalPlayer.Character
    if not char then return end

    local seat = char:FindFirstChildWhichIsA("VehicleSeat")
    if not seat then
        for _, s in pairs(workspace:GetDescendants()) do
            if s:IsA("VehicleSeat") and s.Occupant and s.Occupant.Parent == char then
                seat = s
                break
            end
        end
    end

    if seat then
        local vehicle = seat.Parent
        if vehicle:IsA("Model") and vehicle.PrimaryPart then
            vehicle:SetPrimaryPartCFrame(FIXED_CFRAME + Vector3.new(0, TELEPORT_HEIGHT, 0))
        elseif vehicle:IsA("Model") then
            for _, p in pairs(vehicle:GetChildren()) do
                if p:IsA("BasePart") then
                    p.CFrame = FIXED_CFRAME + Vector3.new(0, TELEPORT_HEIGHT, 0)
                end
            end
        end
    else
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = FIXED_CFRAME + Vector3.new(0, TELEPORT_HEIGHT, 0) end
    end
end

-- main loop
local function startFarming()
    if farmingCoroutine then return end
    farmingCoroutine = coroutine.wrap(function()
        while autoFarm do
            pressW(true)
            local t0 = tick()
            while tick() - t0 < DRIVE_DURATION do
                if not autoFarm then
                    pressW(false)
                    return
                end
                task.wait(0.1)
            end
            pressW(false)
            if not autoFarm then break end
            teleportBack()
            task.wait(0.5)
        end
        pressW(false)
        farmingCoroutine = nil
    end)
    farmingCoroutine()
end

-- toggle logic
toggleBtn.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    if autoFarm then
        toggleBtn.Text = "ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
        startFarming()
    else
        toggleBtn.Text = "OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
        pressW(false)
    end
end)

   end,
})

local PaintballTab = Window:CreateTab("Big Paintball 2", nil) -- Title, Image

local Button = PaintballTab:CreateButton({
   Name = "Teleport All",
   Callback = function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local TeleportEnabled = false

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PlayerMagnetGui"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0.5, -110, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "Player Magnet"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundColor3 = Color3.fromRGB(50,50,150)
title.Font = Enum.Font.SourceSansBold

-- Close button
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0,30,0,24)
closeBtn.Position = UDim2.new(1,-35,0,3)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.MouseButton1Click:Connect(function()
    TeleportEnabled = false
    gui:Destroy()
end)

-- Toggle button
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0,150,0,50)
toggleBtn.Position = UDim2.new(0.5,-75,0,50)
toggleBtn.Text = "Teleport Players: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,200,100)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.MouseButton1Click:Connect(function()
    TeleportEnabled = not TeleportEnabled
    toggleBtn.Text = "Teleport Players: "..(TeleportEnabled and "ON" or "OFF")
end)

-- B key toggle
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.B then
        TeleportEnabled = not TeleportEnabled
        toggleBtn.Text = "Teleport Players: "..(TeleportEnabled and "ON" or "OFF")
    end
end)

-- Function: teleport all other players in front of you
local function teleportPlayers()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local forward = hrp.CFrame.LookVector * 5 -- 5 studs in front
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(hrp.Position + forward + Vector3.new(0,3,0))
        end
    end
end

-- Loop to continuously teleport players while enabled
RunService.RenderStepped:Connect(function()
    if TeleportEnabled then
        teleportPlayers()
    end
end)
   end,
})

local InkTab = Window:CreateTab("Ink Games", nil) -- Title, Image

local Button = InkTab:CreateButton({
   Name = "OP SCRIPT",
   Callback = function()
			loadstring(game:HttpGet("https://pastebin.com/raw/4UW8z7zG"))()
   end,
})

local PlsDonateTab = Window:CreateTab("PLS DONATE", nil) -- Title, Image

local Button = PlsDonateTab:CreateButton({
   Name = "OP SCRIPT",
   Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/CF-Trail/tzechco-PlsDonateAutofarmBackup/main/old.lua'))()
   end,
})

local Button = DrivingEmpireTab:CreateButton({
   Name = "OP SCRIPT (Max Hub)",
   Callback = function()
			loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/e115b107e044a8cfc35b87ce573d558f.lua"))()
   end,
})

local PVBTab = Window:CreateTab("Plants VS Brainrots", nil) -- Title, Image

local Button = PVBTab:CreateButton({
   Name = "OP SCRIPT",
   Callback = function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/mynamewendel-ctrl/Blessed-Hub-X-/refs/heads/main/Plants-Vs-Brainrots.lua"))()   end,
})

local SABTab = Window:CreateTab("Steal A Brainrot", nil) -- Title, Image

local Button = SABTab:CreateButton({
   Name = "Nothing Right Now",
   Callback = function()
			print("Unavalible")
})

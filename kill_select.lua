local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local targetPlayer = nil
local isHolding = false
local connection = nil
local returnCFrame = nil
local mode = "OFF"
local returnedAfterDeath = false
local respawnWaitUntil = 0

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportHoldGUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 165)
mainFrame.Position = UDim2.new(0.5, -90, 0.5, -82)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 18)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -18, 1, 0)
titleLabel.Position = UDim2.new(0, 3, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "kill select"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 10
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 18, 0, 18)
closeButton.Position = UDim2.new(1, -18, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 11
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.9, 0, 0, 22)
inputBox.Position = UDim2.new(0.05, 0, 0, 24)
inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
inputBox.BorderSizePixel = 0
inputBox.PlaceholderText = "Player name..."
inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
inputBox.Text = ""
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.TextSize = 10
inputBox.Font = Enum.Font.Gotham
inputBox.ClearTextOnFocus = false
inputBox.Parent = mainFrame

local selectedLabel = Instance.new("TextLabel")
selectedLabel.Size = UDim2.new(0.9, 0, 0, 13)
selectedLabel.Position = UDim2.new(0.05, 0, 0, 48)
selectedLabel.BackgroundTransparency = 1
selectedLabel.Text = "Selected: —"
selectedLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
selectedLabel.TextSize = 8
selectedLabel.Font = Enum.Font.Gotham
selectedLabel.TextXAlignment = Enum.TextXAlignment.Left
selectedLabel.TextTruncate = Enum.TextTruncate.AtEnd
selectedLabel.Parent = mainFrame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.6, 0, 0, 24)
toggleButton.Position = UDim2.new(0.2, 0, 0, 66)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "OFF"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 12
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 14)
statusLabel.Position = UDim2.new(0, 0, 0, 94)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 8
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local returnLabel = Instance.new("TextLabel")
returnLabel.Size = UDim2.new(1, 0, 0, 12)
returnLabel.Position = UDim2.new(0, 0, 0, 109)
returnLabel.BackgroundTransparency = 1
returnLabel.Text = ""
returnLabel.TextColor3 = Color3.fromRGB(255, 200, 120)
returnLabel.TextSize = 8
returnLabel.Font = Enum.Font.Gotham
returnLabel.Parent = mainFrame

local modeButton = Instance.new("TextButton")
modeButton.Size = UDim2.new(0.9, 0, 0, 20)
modeButton.Position = UDim2.new(0.05, 0, 0, 140)
modeButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
modeButton.BorderSizePixel = 0
modeButton.Text = "Mode: OFF"
modeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
modeButton.TextSize = 9
modeButton.Font = Enum.Font.GothamBold
modeButton.Parent = mainFrame

local function trim(s)
    return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function findPlayer(name)
    name = trim(name):lower()
    if name == "" then return nil end

    local players = Players:GetPlayers()
    local bestMatch = nil

    for _, plr in ipairs(players) do
        if plr ~= player then
            local pName = plr.Name:lower()
            local pDisplay = plr.DisplayName:lower()
            if pName == name or pDisplay == name then
                return plr
            end
            if pName:sub(1, #name) == name or pDisplay:sub(1, #name) == name then
                bestMatch = bestMatch or plr
            end
        end
    end

    if bestMatch then return bestMatch end

    for _, plr in ipairs(players) do
        if plr ~= player then
            local pName = plr.Name:lower()
            local pDisplay = plr.DisplayName:lower()
            if pName:find(name, 1, true) or pDisplay:find(name, 1, true) then
                return plr
            end
        end
    end

    return nil
end

local function hasForceField(plr)
    if not plr or not plr.Character then return false end
    return plr.Character:FindFirstChildOfClass("ForceField") ~= nil
end

local function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
end

local function teleportBehind(target)
    if not target or not target.Character then return false end
    local targetRoot = getRoot(target.Character)
    if not targetRoot then return false end

    local myRoot = getRoot(character)
    if not myRoot then return false end

    local targetCF = targetRoot.CFrame
    local behindCF = CFrame.new(targetCF * CFrame.new(0, 0, 3).Position, targetCF.Position)

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end

    character:PivotTo(behindCF)
    myRoot.AssemblyLinearVelocity = Vector3.zero
    myRoot.AssemblyAngularVelocity = Vector3.zero

    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end

    return true
end

local function returnToSavedPosition()
    if not returnCFrame then
        statusLabel.Text = "Status: No return point!"
        return false
    end

    local myRoot = getRoot(character)
    if not myRoot then
        character = player.Character or player.CharacterAdded:Wait()
        myRoot = getRoot(character)
        if not myRoot then return false end
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end

    character:PivotTo(returnCFrame)
    myRoot.AssemblyLinearVelocity = Vector3.zero
    myRoot.AssemblyAngularVelocity = Vector3.zero

    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end

    return true
end

local function updateSelectedLabel(plr)
    if plr then
        selectedLabel.Text = "Selected: " .. plr.Name .. " (" .. plr.DisplayName .. ")"
        selectedLabel.TextColor3 = Color3.fromRGB(120, 255, 120)
    else
        selectedLabel.Text = "Selected: —"
        selectedLabel.TextColor3 = Color3.fromRGB(180, 220, 255)
    end
end

local function stopHold(doReturn)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    isHolding = false
    returnedAfterDeath = false
    respawnWaitUntil = 0
    toggleButton.Text = "OFF"
    toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)

    if doReturn then
        if returnToSavedPosition() then
            statusLabel.Text = "Status: Returned"
            returnLabel.Text = "Returned to saved point"
        end
    else
        statusLabel.Text = "Status: Idle"
    end
end

local function startHold(target)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    isHolding = true
    returnedAfterDeath = false
    respawnWaitUntil = 0
    toggleButton.Text = "ON"
    toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

    connection = RunService.Heartbeat:Connect(function()
        if not target or not target.Parent then
            stopHold(false)
            return
        end

        local targetChar = target.Character
        if not targetChar then return end

        local humanoid = targetChar:FindFirstChildOfClass("Humanoid")

        if humanoid and humanoid.Health <= 0 then
            if mode == "AUTO" then
                stopHold(true)
                return
            end

            if not returnedAfterDeath then
                returnToSavedPosition()
                returnedAfterDeath = true
                respawnWaitUntil = 0
                statusLabel.Text = "Status: Target dead — returned, waiting respawn..."
                returnLabel.Text = "Returned after target death"
            else
                statusLabel.Text = "Status: Waiting respawn..."
            end
            return
        end

        if returnedAfterDeath then
            local targetRoot = getRoot(targetChar)
            if not targetRoot then
                statusLabel.Text = "Status: Waiting respawn..."
                return
            end

            if respawnWaitUntil == 0 then
                respawnWaitUntil = os.clock() + 2
                statusLabel.Text = "Status: Waiting 2s after respawn..."
                return
            end

            if os.clock() < respawnWaitUntil then
                statusLabel.Text = "Status: Waiting 2s after respawn..."
                return
            end

            if hasForceField(target) or hasForceField(player) then
                statusLabel.Text = "Status: Shield — waiting..."
                return
            end

            returnedAfterDeath = false
            respawnWaitUntil = 0
        end

        if hasForceField(target) or hasForceField(player) then
            statusLabel.Text = "Status: Shield — waiting..."
            return
        end

        local targetRoot = getRoot(targetChar)
        if not targetRoot then return end

        statusLabel.Text = "Status: Holding " .. target.Name
        teleportBehind(target)
    end)
end

local function updateModeButton()
    modeButton.Text = "Mode: " .. mode
    if mode == "AUTO" then
        modeButton.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
    else
        modeButton.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    end
end

modeButton.MouseButton1Click:Connect(function()
    if mode == "OFF" then
        mode = "AUTO"
    else
        mode = "OFF"
    end
    updateModeButton()
    statusLabel.Text = "Status: Mode = " .. mode
end)

closeButton.MouseButton1Click:Connect(function()
    stopHold(false)
    screenGui:Destroy()
end)

toggleButton.MouseButton1Click:Connect(function()
    if isHolding then
        stopHold(true)
        return
    end

    local name = inputBox.Text
    if trim(name) == "" then
        statusLabel.Text = "Status: Enter a name!"
        updateSelectedLabel(nil)
        return
    end

    targetPlayer = findPlayer(name)
    if not targetPlayer then
        local total = #Players:GetPlayers() - 1
        statusLabel.Text = "Status: Not found! (online: " .. total .. ")"
        updateSelectedLabel(nil)
        return
    end

    updateSelectedLabel(targetPlayer)

    local myRoot = getRoot(character)
    if myRoot then
        returnCFrame = myRoot.CFrame
        returnLabel.Text = "Return point saved"
    else
        returnCFrame = nil
        returnLabel.Text = "Return point NOT saved"
    end

    returnedAfterDeath = false
    respawnWaitUntil = 0

    if hasForceField(targetPlayer) then
        statusLabel.Text = "Status: Shield — waiting..."
        startHold(targetPlayer)
        return
    end

    if teleportBehind(targetPlayer) then
        startHold(targetPlayer)
    else
        statusLabel.Text = "Status: Teleport failed!"
    end
end)

inputBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = inputBox.Text
    if trim(text) == "" then
        updateSelectedLabel(nil)
        return
    end

    local found = findPlayer(text)
    if found then
        updateSelectedLabel(found)
    else
        selectedLabel.Text = "Selected: — (not found)"
        selectedLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
    end
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    newChar:WaitForChild("HumanoidRootPart")
    if isHolding and targetPlayer and not returnedAfterDeath then
        if not hasForceField(targetPlayer) and not hasForceField(player) then
            teleportBehind(targetPlayer)
        end
    end
end)

updateModeButton()

local notice = Instance.new("Frame")
notice.Size = UDim2.new(0, 320, 0, 44)
notice.Position = UDim2.new(0.5, -160, 0.5, -160)
notice.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
notice.BackgroundTransparency = 0.15
notice.BorderSizePixel = 0
notice.Parent = screenGui

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0
stroke.Parent = notice

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = notice

local text = Instance.new("TextLabel")
text.Size = UDim2.new(1, -12, 1, 0)
text.Position = UDim2.new(0, 6, 0, 0)
text.BackgroundTransparency = 1
text.Text = "TG script avtor - @sunglowez"
text.TextColor3 = Color3.fromRGB(255, 255, 255)
text.TextSize = 16
text.Font = Enum.Font.GothamBold
text.TextXAlignment = Enum.TextXAlignment.Center
text.TextYAlignment = Enum.TextYAlignment.Center
text.Parent = notice

task.spawn(function()
    task.wait(2.5)
    notice:Destroy()
end)

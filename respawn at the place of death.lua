local player = game.Players.LocalPlayer

local deathPosition = nil
local respawnConnection = nil
local deathConnection = nil
local inputConnection = nil
local notification = nil

local function ShowNotification()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeathRespawnGUI"
    screenGui.Parent = player.PlayerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 350, 0, 80)
    mainFrame.Position = UDim2.new(0.5, -175, 0.2, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    mainFrame.Parent = screenGui
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
    })
    gradient.Parent = mainFrame
    
    local textLabel1 = Instance.new("TextLabel")
    textLabel1.Size = UDim2.new(1, 0, 0.6, 0)
    textLabel1.Position = UDim2.new(0, 0, 0, 0)
    textLabel1.BackgroundTransparency = 1
    textLabel1.Text = "tg avtor-- @sunglowez"
    textLabel1.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel1.TextScaled = true
    textLabel1.Font = Enum.Font.GothamBold
    textLabel1.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel1.TextStrokeTransparency = 0.5
    textLabel1.Parent = mainFrame
    
    local textLabel2 = Instance.new("TextLabel")
    textLabel2.Size = UDim2.new(1, 0, 0.4, 0)
    textLabel2.Position = UDim2.new(0, 0, 0.6, 0)
    textLabel2.BackgroundTransparency = 1
    textLabel2.Text = "Press  -  to delete script"
    textLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
    textLabel2.TextScaled = true
    textLabel2.Font = Enum.Font.Gotham
    textLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel2.TextStrokeTransparency = 0.5
    textLabel2.Parent = mainFrame
    
    mainFrame.BackgroundTransparency = 1
    mainFrame.Position = UDim2.new(0.5, -175, 0.1, 0)
    
    game:GetService("TweenService"):Create(
        mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.15, Position = UDim2.new(0.5, -175, 0.2, 0)}
    ):Play()
    
    notification = screenGui
    
    task.wait(5)
    
    game:GetService("TweenService"):Create(
        mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {BackgroundTransparency = 1, Position = UDim2.new(0.5, -175, 0.1, 0)}
    ):Play()
    
    task.wait(0.5)
    screenGui:Destroy()
    notification = nil
end

local function onDeath()
    local char = player.Character
    if char then
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            deathPosition = rootPart.Position
        end
    end
end

local function TeleportToDeathPosition(char)
    if deathPosition then
        local newChar = char or player.Character
        if newChar then
            local rootPart = newChar:FindFirstChild("HumanoidRootPart")
            if rootPart then
                rootPart.CFrame = CFrame.new(deathPosition)
            end
        end
    end
end

local function setupDeathListener(char)
    if deathConnection then
        deathConnection:Disconnect()
        deathConnection = nil
    end
    
    local character = char or player.Character
    if character then
        local hum = character:FindFirstChild("Humanoid")
        if hum then
            deathConnection = hum.Died:Connect(onDeath)
        end
    end
end

local function setupRespawnListener()
    if respawnConnection then
        respawnConnection:Disconnect()
        respawnConnection = nil
    end
    
    respawnConnection = player.CharacterAdded:Connect(function(char)
        local hum = char:WaitForChild("Humanoid")
        if hum then
            if deathConnection then
                deathConnection:Disconnect()
                deathConnection = nil
            end
            deathConnection = hum.Died:Connect(onDeath)
        end
        
        task.wait(0.1)
        TeleportToDeathPosition(char)
    end)
end

local function onKeyPress(input)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        local key = input.KeyCode.Name
        if key == "Minus" then
            if notification then
                notification:Destroy()
                notification = nil
            end
            
            if deathConnection then
                deathConnection:Disconnect()
                deathConnection = nil
            end
            if respawnConnection then
                respawnConnection:Disconnect()
                respawnConnection = nil
            end
            if inputConnection then
                inputConnection:Disconnect()
                inputConnection = nil
            end
            
            deathPosition = nil
            
            script:Destroy()
        end
    end
end

setupDeathListener()
setupRespawnListener()

coroutine.wrap(ShowNotification)()

inputConnection = game:GetService("UserInputService").InputBegan:Connect(onKeyPress)

script.AncestryChanged:Connect(function()
    if not script.Parent then
        if inputConnection then
            inputConnection:Disconnect()
            inputConnection = nil
        end
        if notification then
            notification:Destroy()
            notification = nil
        end
    end
end)

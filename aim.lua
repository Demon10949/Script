local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")

local TweenService = game:GetService("TweenService")

local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

local Camera = workspace.CurrentCamera

local ConfigFolder = "UltraAimbotConfig"

local ConfigFile = ConfigFolder .. "/Settings.json"

local DefaultConfig = {

    AimbotEnabled = false,

    CursorMagnetEnabled = false,

    EspEnabled = true,

    WallCheckEnabled = true,

    TeamCheckEnabled = true,

    FriendCheckEnabled = false,

    FovRadius = 200,

    TargetPart = "Head"

}

local Config = {}

for key, value in pairs(DefaultConfig) do

    Config[key] = value

end

pcall(function()

    if not isfolder(ConfigFolder) then

        makefolder(ConfigFolder)

    end

    if isfile(ConfigFile) then

        local data = HttpService:JSONDecode(readfile(ConfigFile))

        if type(data) == "table" then

            for key, value in pairs(data) do

                if Config[key] ~= nil and type(value) == type(Config[key]) then

                    Config[key] = value

                end

            end

        end

    end

end)

local AimbotEnabled = Config.AimbotEnabled

local CursorMagnetEnabled = Config.CursorMagnetEnabled

if not AimbotEnabled then

    CursorMagnetEnabled = false

end

local EspEnabled = Config.EspEnabled

local WallCheckEnabled = Config.WallCheckEnabled

local TeamCheckEnabled = Config.TeamCheckEnabled

local FriendCheckEnabled = Config.FriendCheckEnabled

local FovRadius = math.clamp(tonumber(Config.FovRadius) or 200, 10, 600)

local TargetPart = Config.TargetPart

local bodyParts = {

    "Head",

    "Torso",

    "HumanoidRootPart"

}

local currentPartIndex = 1

for i, part in ipairs(bodyParts) do

    if part == TargetPart then

        currentPartIndex = i

        break

    end

end

local espBoxes = {}

local function saveConfig()

    Config.AimbotEnabled = AimbotEnabled

    Config.CursorMagnetEnabled = CursorMagnetEnabled

    Config.EspEnabled = EspEnabled

    Config.WallCheckEnabled = WallCheckEnabled

    Config.TeamCheckEnabled = TeamCheckEnabled

    Config.FriendCheckEnabled = FriendCheckEnabled

    Config.FovRadius = FovRadius

    Config.TargetPart = TargetPart

    pcall(function()

        if not isfolder(ConfigFolder) then

            makefolder(ConfigFolder)

        end

        writefile(ConfigFile, HttpService:JSONEncode(Config))

    end)

end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "UltraAimbotMenuGui"

ScreenGui.ResetOnSpawn = false

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local NotificationContainer = Instance.new("Frame")

NotificationContainer.Size = UDim2.new(0, 420, 0, 100)

NotificationContainer.Position = UDim2.new(0.5, -210, 0, 0)

NotificationContainer.BackgroundTransparency = 1

NotificationContainer.Parent = ScreenGui

local function showLoadNotification()

    local label = Instance.new("TextLabel")

    label.Size = UDim2.new(0, 400, 0, 42)

    label.Position = UDim2.new(0, 10, 0, -55)

    label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

    label.BackgroundTransparency = 0.05

    label.BorderSizePixel = 1

    label.BorderColor3 = Color3.fromRGB(0, 153, 255)

    label.Text = "Ultra Aimbot loaded"

    label.TextColor3 = Color3.fromRGB(235, 235, 235)

    label.Font = Enum.Font.SourceSansBold

    label.TextSize = 17

    label.Parent = NotificationContainer

    local corner = Instance.new("UICorner")

    corner.CornerRadius = UDim.new(0, 6)

    corner.Parent = label

    local enterTween = TweenService:Create(

        label,

        TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),

        {

            Position = UDim2.new(0, 10, 0, 10)

        }

    )

    enterTween:Play()

    enterTween.Completed:Wait()

    task.wait(1.5)

    local exitTween = TweenService:Create(

        label,

        TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.In),

        {

            Position = UDim2.new(0, 10, 0, -55)

        }

    )

    exitTween:Play()

    exitTween.Completed:Wait()

    label:Destroy()

end

local MainFrame = Instance.new("Frame")

MainFrame.Size = UDim2.new(0, 280, 0, 390)

MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)

MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

MainFrame.BorderSizePixel = 2

MainFrame.BorderColor3 = Color3.fromRGB(0, 102, 204)

MainFrame.Visible = true

MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")

Title.Size = UDim2.new(1, -35, 0, 35)

Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

Title.Text = "  SMART AIMBOT + ESP (F1)"

Title.TextColor3 = Color3.fromRGB(0, 153, 255)

Title.Font = Enum.Font.SourceSansBold

Title.TextSize = 17

Title.TextXAlignment = Enum.TextXAlignment.Left

Title.Parent = MainFrame

local CloseButton = Instance.new("TextButton")

CloseButton.Size = UDim2.new(0, 35, 0, 35)

CloseButton.Position = UDim2.new(1, -35, 0, 0)

CloseButton.BackgroundColor3 = Color3.fromRGB(30, 10, 10)

CloseButton.BorderSizePixel = 0

CloseButton.Text = "X"

CloseButton.TextColor3 = Color3.fromRGB(255, 50, 50)

CloseButton.Font = Enum.Font.SourceSansBold

CloseButton.TextSize = 18

CloseButton.Parent = MainFrame

local StatusLabel = Instance.new("TextLabel")

StatusLabel.Size = UDim2.new(1, 0, 0, 30)

StatusLabel.Position = UDim2.new(0, 0, 0, 40)

StatusLabel.BackgroundTransparency = 1

StatusLabel.TextColor3 = Color3.fromRGB(200, 50, 50)

StatusLabel.Font = Enum.Font.SourceSans

StatusLabel.TextSize = 16

StatusLabel.Parent = MainFrame

local FovLabel = Instance.new("TextButton")

FovLabel.Size = UDim2.new(0, 120, 0, 30)

FovLabel.Position = UDim2.new(0, 10, 0, 80)

FovLabel.BackgroundTransparency = 1

FovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

FovLabel.TextXAlignment = Enum.TextXAlignment.Left

FovLabel.Font = Enum.Font.SourceSans

FovLabel.TextSize = 16

FovLabel.AutoButtonColor = false

FovLabel.Parent = MainFrame

local FovMinus = Instance.new("TextButton")

FovMinus.Size = UDim2.new(0, 30, 0, 25)

FovMinus.Position = UDim2.new(0, 150, 0, 82)

FovMinus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

FovMinus.TextColor3 = Color3.fromRGB(0, 153, 255)

FovMinus.Text = "-"

FovMinus.Font = Enum.Font.SourceSansBold

FovMinus.TextSize = 16

FovMinus.Parent = MainFrame

local FovPlus = Instance.new("TextButton")

FovPlus.Size = UDim2.new(0, 30, 0, 25)

FovPlus.Position = UDim2.new(0, 190, 0, 82)

FovPlus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

FovPlus.TextColor3 = Color3.fromRGB(0, 153, 255)

FovPlus.Text = "+"

FovPlus.Font = Enum.Font.SourceSansBold

FovPlus.TextSize = 16

FovPlus.Parent = MainFrame

local FovInput = Instance.new("TextBox")

FovInput.Size = UDim2.new(0, 45, 0, 25)

FovInput.Position = UDim2.new(0, 225, 0, 82)

FovInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

FovInput.TextColor3 = Color3.fromRGB(255, 255, 255)

FovInput.PlaceholderText = "..."

FovInput.Text = ""

FovInput.Font = Enum.Font.SourceSans

FovInput.TextSize = 14

FovInput.ClearTextOnFocus = true

FovInput.Parent = MainFrame

local TargetLabel = Instance.new("TextLabel")

TargetLabel.Size = UDim2.new(0, 120, 0, 30)

TargetLabel.Position = UDim2.new(0, 10, 0, 120)

TargetLabel.BackgroundTransparency = 1

TargetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)

TargetLabel.TextXAlignment = Enum.TextXAlignment.Left

TargetLabel.Font = Enum.Font.SourceSans

TargetLabel.TextSize = 16

TargetLabel.Parent = MainFrame

local TargetToggleBtn = Instance.new("TextButton")

TargetToggleBtn.Size = UDim2.new(0, 100, 0, 25)

TargetToggleBtn.Position = UDim2.new(0, 150, 0, 122)

TargetToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

TargetToggleBtn.TextColor3 = Color3.fromRGB(0, 153, 255)

TargetToggleBtn.Text = "Change"

TargetToggleBtn.Font = Enum.Font.SourceSans

TargetToggleBtn.TextSize = 14

TargetToggleBtn.Parent = MainFrame

local EspToggleBtn = Instance.new("TextButton")

EspToggleBtn.Size = UDim2.new(0, 120, 0, 25)

EspToggleBtn.Position = UDim2.new(0, 10, 0, 162)

EspToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

EspToggleBtn.Font = Enum.Font.SourceSansBold

EspToggleBtn.TextSize = 14

EspToggleBtn.Parent = MainFrame

local AimbotToggleBtn = Instance.new("TextButton")

AimbotToggleBtn.Size = UDim2.new(0, 120, 0, 25)

AimbotToggleBtn.Position = UDim2.new(0, 145, 0, 162)

AimbotToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

AimbotToggleBtn.Font = Enum.Font.SourceSansBold

AimbotToggleBtn.TextSize = 14

AimbotToggleBtn.Parent = MainFrame

local CursorToggleBtn = Instance.new("TextButton")

CursorToggleBtn.Size = UDim2.new(0, 120, 0, 25)

CursorToggleBtn.Position = UDim2.new(0, 10, 0, 200)

CursorToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

CursorToggleBtn.Font = Enum.Font.SourceSansBold

CursorToggleBtn.TextSize = 14

CursorToggleBtn.Parent = MainFrame

local WallToggleBtn = Instance.new("TextButton")

WallToggleBtn.Size = UDim2.new(0, 120, 0, 25)

WallToggleBtn.Position = UDim2.new(0, 145, 0, 200)

WallToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

WallToggleBtn.Font = Enum.Font.SourceSansBold

WallToggleBtn.TextSize = 14

WallToggleBtn.Parent = MainFrame

local TeamToggleBtn = Instance.new("TextButton")

TeamToggleBtn.Size = UDim2.new(0, 120, 0, 25)

TeamToggleBtn.Position = UDim2.new(0, 10, 0, 238)

TeamToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

TeamToggleBtn.Font = Enum.Font.SourceSansBold

TeamToggleBtn.TextSize = 14

TeamToggleBtn.Parent = MainFrame

local FriendToggleBtn = Instance.new("TextButton")

FriendToggleBtn.Size = UDim2.new(0, 120, 0, 25)

FriendToggleBtn.Position = UDim2.new(0, 145, 0, 238)

FriendToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

FriendToggleBtn.Font = Enum.Font.SourceSansBold

FriendToggleBtn.TextSize = 14

FriendToggleBtn.Parent = MainFrame

local InfoLabel = Instance.new("TextLabel")

InfoLabel.Size = UDim2.new(1, -20, 0, 70)

InfoLabel.Position = UDim2.new(0, 10, 0, 275)

InfoLabel.BackgroundTransparency = 1

InfoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)

InfoLabel.Text = "F1 - Menu\nF2 - Aimbot\nF3 - Magnet Cursor"

InfoLabel.Font = Enum.Font.SourceSans

InfoLabel.TextSize = 14

InfoLabel.TextXAlignment = Enum.TextXAlignment.Left

InfoLabel.TextYAlignment = Enum.TextYAlignment.Top

InfoLabel.Parent = MainFrame

local FOVDrawing = Drawing.new("Circle")

FOVDrawing.Visible = true

FOVDrawing.Radius = FovRadius

FOVDrawing.Color = Color3.fromRGB(0, 102, 204)

FOVDrawing.Thickness = 1

FOVDrawing.Filled = false

local dragging = false

local dragInput

local dragStart

local startPos

local function updateDrag(input)

    local delta = input.Position - dragStart

    MainFrame.Position = UDim2.new(

        startPos.X.Scale,

        startPos.X.Offset + delta.X,

        startPos.Y.Scale,

        startPos.Y.Offset + delta.Y

    )

end

Title.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true

        dragStart = input.Position

        startPos = MainFrame.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then

                dragging = false

            end

        end)

    end

end)

Title.InputChanged:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then

        dragInput = input

    end

end)

UserInputService.InputChanged:Connect(function(input)

    if input == dragInput and dragging then

        updateDrag(input)

    end

end)

local function isPlayerValid(player)

    if not player or player == LocalPlayer then

        return false

    end

    if player.Parent ~= Players then

        return false

    end

    if not player.Character or player.Character.Parent ~= workspace then

        return false

    end

    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not rootPart then

        return false

    end

    return humanoid.Health > 1

end

local function createESP(player)

    if player == LocalPlayer then

        return

    end

    if espBoxes[player] then

        for _, highlight in ipairs(espBoxes[player]) do

            pcall(function() highlight:Destroy() end)

        end

    end

    espBoxes[player] = {
        Character = nil,
        Highlights = {}
    }

end

local function removeESP(player)

    if espBoxes[player] then

        for _, highlight in ipairs(espBoxes[player].Highlights) do

            pcall(function() highlight:Destroy() end)

        end

        espBoxes[player] = nil

    end

end

for _, player in ipairs(Players:GetPlayers()) do

    if player ~= LocalPlayer then

        createESP(player)

    end

end

Players.PlayerAdded:Connect(function(player)

    if player ~= LocalPlayer then

        createESP(player)

    end

end)

Players.PlayerRemoving:Connect(removeESP)

local function isFriend(player)

    local success, result = pcall(function()

        return LocalPlayer:IsFriendsWith(player.UserId)

    end)

    return success and result

end

local function getESPColor(player)

    if TeamCheckEnabled and player.Team == LocalPlayer.Team then

        return Color3.fromRGB(50, 255, 50)

    end

    if FriendCheckEnabled and isFriend(player) then

        return Color3.fromRGB(50, 255, 50)

    end

    return Color3.fromRGB(255, 50, 50)

end

local function rebuildESPParts(player, data)

    for _, highlight in ipairs(data.Highlights) do

        pcall(function() highlight:Destroy() end)

    end

    data.Highlights = {}
    data.Character = player.Character

    if not data.Character then

        return

    end

    for _, part in ipairs(data.Character:GetDescendants()) do

        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then

            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPPart"
            highlight.Adornee = part
            highlight.FillTransparency = 0.72
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = getESPColor(player)
            highlight.OutlineColor = getESPColor(player)
            highlight.Parent = part
            table.insert(data.Highlights, highlight)

        end

    end

end

local function updateESP()

    for player, data in pairs(espBoxes) do

        if player == LocalPlayer then

            continue

        end

        if EspEnabled and isPlayerValid(player) and player.Character then

            if data.Character ~= player.Character then

                rebuildESPParts(player, data)

            end

            local color = getESPColor(player)

            for _, highlight in ipairs(data.Highlights) do

                if highlight and highlight.Parent then

                    highlight.FillColor = color
                    highlight.OutlineColor = color
                    highlight.Enabled = true

                end

            end

        else

            for _, highlight in ipairs(data.Highlights) do

                if highlight then

                    highlight.Enabled = false

                end

            end

        end

    end

end

local function isVisible(targetPartObj, targetCharacter)

    if not WallCheckEnabled then

        return true

    end

    local origin = Camera.CFrame.Position

    local direction = targetPartObj.Position - origin

    local ignored = {

        LocalPlayer.Character,

        targetCharacter,

        Camera

    }

    local raycastParams = RaycastParams.new()

    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    raycastParams.IgnoreWater = true

    for _ = 1, 50 do

        raycastParams.FilterDescendantsInstances = ignored

        local result = workspace:Raycast(

            origin,

            direction,

            raycastParams

        )

        if not result then

            return true

        end

        local hit = result.Instance

        if hit:IsDescendantOf(targetCharacter) then

            return true

        end

        if hit.CanCollide == false then

            table.insert(ignored, hit)

        else

            return false

        end

    end

    return false

end

local function canTarget(player)

    if not isPlayerValid(player) then

        return false

    end

    if TeamCheckEnabled and player.Team == LocalPlayer.Team then

        return false

    end

    if FriendCheckEnabled and isFriend(player) then

        return false

    end

    return true

end

local function getTargetPart(player)

    if not player.Character then

        return nil

    end

    local actualPart = TargetPart

    if TargetPart == "Torso" and player.Character:FindFirstChild("UpperTorso") then

        actualPart = "UpperTorso"

    end

    return player.Character:FindFirstChild(actualPart)

end

local function getBestTarget()

    local bestTargetPlayer = nil

    local lowestHealth = math.huge

    local screenCenter = Vector2.new(

        Camera.ViewportSize.X / 2,

        Camera.ViewportSize.Y / 2

    )

    for _, player in ipairs(Players:GetPlayers()) do

        if canTarget(player) then

            local part = getTargetPart(player)

            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if part and humanoid then

                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)

                if onScreen and screenPos.Z > 0 then

                    local distanceToCenter = (

                        Vector2.new(screenPos.X, screenPos.Y) - screenCenter

                    ).Magnitude

                    if distanceToCenter <= FovRadius then

                        if isVisible(part, player.Character) then

                            if humanoid.Health < lowestHealth then

                                lowestHealth = humanoid.Health

                                bestTargetPlayer = player

                            end

                        end

                    end

                end

            end

        end

    end

    return bestTargetPlayer

end

local function moveCursorToTarget(targetPart)

    if not targetPart then

        return

    end

    if type(mousemoverel) ~= "function" then

        return

    end

    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)

    if not onScreen or screenPos.Z <= 0 then

        return

    end

    local mousePosition = UserInputService:GetMouseLocation()

    local deltaX = screenPos.X - mousePosition.X

    local deltaY = screenPos.Y - mousePosition.Y

    local strength = 0.85

    local maxStep = 60

    local moveX = math.clamp(deltaX * strength, -maxStep, maxStep)

    local moveY = math.clamp(deltaY * strength, -maxStep, maxStep)

    if math.abs(moveX) > 0.2 or math.abs(moveY) > 0.2 then

        mousemoverel(moveX, moveY)

    end

end


local function updateUI()

    FovLabel.Text = "FOV: " .. FovRadius

    FOVDrawing.Radius = FovRadius

    TargetLabel.Text = "Target: " .. TargetPart

    AimbotToggleBtn.Text = "Aimbot: " .. (AimbotEnabled and "ON" or "OFF")

    AimbotToggleBtn.TextColor3 = AimbotEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)

    EspToggleBtn.Text = "ESP: " .. (EspEnabled and "ON" or "OFF")

    EspToggleBtn.TextColor3 = EspEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)

    CursorToggleBtn.Text = "Magnet Cursor: " .. (CursorMagnetEnabled and "ON" or "OFF")

    CursorToggleBtn.TextColor3 = CursorMagnetEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)

    WallToggleBtn.Text = "Wall Check: " .. (WallCheckEnabled and "ON" or "OFF")

    WallToggleBtn.TextColor3 = WallCheckEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)

    TeamToggleBtn.Text = "Team Check: " .. (TeamCheckEnabled and "ON" or "OFF")

    TeamToggleBtn.TextColor3 = TeamCheckEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)

    FriendToggleBtn.Text = "Friend Check: " .. (FriendCheckEnabled and "ON" or "OFF")

    FriendToggleBtn.TextColor3 = FriendCheckEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)

    StatusLabel.Text = "Aimbot: " .. (AimbotEnabled and "ON" or "OFF")

    StatusLabel.TextColor3 = AimbotEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)

end

FovLabel.MouseButton1Click:Connect(function()

    FovInput:CaptureFocus()

end)

FovInput.FocusLost:Connect(function()

    local value = tonumber(FovInput.Text)

    if value then

        FovRadius = math.clamp(math.floor(value), 10, 600)

        FovInput.Text = ""

        saveConfig()

        updateUI()

    end

end)

FovPlus.MouseButton1Click:Connect(function()

    FovRadius = math.clamp(FovRadius + 5, 10, 600)

    saveConfig()

    updateUI()

end)

FovMinus.MouseButton1Click:Connect(function()

    FovRadius = math.clamp(FovRadius - 5, 10, 600)

    saveConfig()

    updateUI()

end)

TargetToggleBtn.MouseButton1Click:Connect(function()

    currentPartIndex = currentPartIndex + 1

    if currentPartIndex > #bodyParts then

        currentPartIndex = 1

    end

    TargetPart = bodyParts[currentPartIndex]

    saveConfig()

    updateUI()

end)

EspToggleBtn.MouseButton1Click:Connect(function()

    EspEnabled = not EspEnabled

    saveConfig()

    updateUI()

end)

AimbotToggleBtn.MouseButton1Click:Connect(function()

    AimbotEnabled = not AimbotEnabled

    if not AimbotEnabled then

        CursorMagnetEnabled = false

    end

    saveConfig()

    updateUI()

end)

CursorToggleBtn.MouseButton1Click:Connect(function()

    if not AimbotEnabled then

        CursorMagnetEnabled = false

    else

        CursorMagnetEnabled = not CursorMagnetEnabled

    end

    saveConfig()

    updateUI()

end)


WallToggleBtn.MouseButton1Click:Connect(function()

    WallCheckEnabled = not WallCheckEnabled

    saveConfig()

    updateUI()

end)

TeamToggleBtn.MouseButton1Click:Connect(function()

    TeamCheckEnabled = not TeamCheckEnabled

    saveConfig()

    updateUI()

end)

FriendToggleBtn.MouseButton1Click:Connect(function()

    FriendCheckEnabled = not FriendCheckEnabled

    saveConfig()

    updateUI()

end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)

    if gameProcessed then

        return

    end

    if input.KeyCode == Enum.KeyCode.F1 then

        MainFrame.Visible = not MainFrame.Visible

    elseif input.KeyCode == Enum.KeyCode.F2 then

        AimbotEnabled = not AimbotEnabled

        if not AimbotEnabled then

            CursorMagnetEnabled = false

        end

        saveConfig()

        updateUI()

    elseif input.KeyCode == Enum.KeyCode.F3 then

        if AimbotEnabled then

            CursorMagnetEnabled = not CursorMagnetEnabled

        else

            CursorMagnetEnabled = false

        end

        saveConfig()

        updateUI()

    end

end)

local renderConnection

CloseButton.MouseButton1Click:Connect(function()

    if renderConnection then

        renderConnection:Disconnect()

    end

    if FOVDrawing then

        FOVDrawing:Remove()

    end

    for _, box in pairs(espBoxes) do

        box:Remove()

    end

    espBoxes = {}

    ScreenGui:Destroy()

    script:Destroy()

end)

updateUI()

task.spawn(showLoadNotification)

renderConnection = RunService.RenderStepped:Connect(function()

    if FOVDrawing then

        FOVDrawing.Position = Vector2.new(

            Camera.ViewportSize.X / 2,

            Camera.ViewportSize.Y / 2

        )

    end

    updateESP()

    local targetPlayer

    if AimbotEnabled or CursorMagnetEnabled then

        targetPlayer = getBestTarget()

    end

    if targetPlayer and targetPlayer.Character then

        local targetPartObj = getTargetPart(targetPlayer)

        if targetPartObj then

            if AimbotEnabled and not CursorMagnetEnabled then

                Camera.CFrame = CFrame.new(

                    Camera.CFrame.Position,

                    targetPartObj.Position

                )

            elseif AimbotEnabled and CursorMagnetEnabled then

                moveCursorToTarget(targetPartObj)

            end

        end

    end

end)

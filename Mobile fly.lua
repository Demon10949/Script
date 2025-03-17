local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50 -- Скорость полёта
local flightForce = Instance.new("BodyVelocity")
flightForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

-- Функция переключения полёта
local function toggleFlight()
    flying = not flying
    if flying then
        flightForce.Parent = rootPart
        flightForce.Velocity = Vector3.new(0, speed, 0)
    else
        flightForce.Parent = nil
    end
end

-- Создаём кнопку "Fly" на экране
local function createFlyButton()
    local flyButton = Instance.new("TextButton")
    flyButton.Name = "FlyButton"
    flyButton.Size = UDim2.new(0, 100, 0, 50)
    flyButton.Position = UDim2.new(0.85, 0, 0.85, 0) -- Рядом с кнопкой прыжка
    flyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    flyButton.Text = "Fly"
    flyButton.TextScaled = true
    flyButton.Parent = game:GetService("StarterGui"):SetCore("AddButton", {Button = flyButton})

    -- Обработчик нажатия
    flyButton.MouseButton1Click:Connect(toggleFlight)
end

-- Управление движением в воздухе
RunService.RenderStepped:Connect(function()
    if flying then
        local moveDirection = humanoid.MoveDirection
        flightForce.Velocity = Vector3.new(moveDirection.X * speed, flightForce.Velocity.Y, moveDirection.Z * speed)
    end
end)

-- Создаём кнопку, если игрок на мобильном устройстве
if UserInputService.TouchEnabled then
    createFlyButton()
end

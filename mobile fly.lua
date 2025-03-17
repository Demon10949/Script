local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50  -- Скорость передвижения в воздухе
local verticalSpeed = 50 -- Скорость подъёма и спуска
local flightForce = Instance.new("BodyVelocity")
flightForce.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
flightForce.Velocity = Vector3.zero

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

-- Функция создания кнопок
local function createButton(name, text, position, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(0, 80, 0, 40)  -- Сделал кнопку меньше
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    button.Text = text
    button.TextScaled = true
    button.Draggable = true  -- Теперь кнопку можно перемещать
    button.Parent = gui

    button.MouseButton1Click:Connect(callback)
    return button
end

-- Кнопка "Fly"
local flyButton = createButton("FlyButton", "Fly", UDim2.new(0.8, 0, 0.75, 0), function()
    flying = not flying
    if flying then
        flightForce.Parent = rootPart
        flyButton.Text = "Unfly"
    else
        flightForce.Parent = nil
        flyButton.Text = "Fly"
    end
end)

-- Кнопка "Up" (Подъём)
local upButton = createButton("UpButton", "Up", UDim2.new(0.88, 0, 0.75, 0), function()
    if flying then
        rootPart.Position = rootPart.Position + Vector3.new(0, verticalSpeed * 0.1, 0)
    end
end)

-- Кнопка "Down" (Спуск)
local downButton = createButton("DownButton", "Down", UDim2.new(0.88, 0, 0.82, 0), function()
    if flying then
        rootPart.Position = rootPart.Position - Vector3.new(0, verticalSpeed * 0.1, 0)
    end
end)

-- Обновление движения в воздухе
RunService.RenderStepped:Connect(function()
    if flying then
        local moveDirection = humanoid.MoveDirection
        flightForce.Velocity = Vector3.new(moveDirection.X * speed, flightForce.Velocity.Y, moveDirection.Z * speed)
    end
end)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Создаем GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0.5, -100, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Active = true
mainFrame.Draggable = true

local toggleButton = Instance.new("TextButton", mainFrame)
toggleButton.Size = UDim2.new(0, 180, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "ESP: OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)

local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 180, 0, 30)
closeButton.Position = UDim2.new(0, 10, 0, 60)
closeButton.Text = "Закрыть"
closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)

-- Переменные для ESP
local espEnabled = false
local espBoxes = {}

-- Функция создания ESP боксов
local function createESP(player)
    if player == Players.LocalPlayer then return end
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    espBoxes[player] = highlight
end

-- Включение/выключение ESP
local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        toggleButton.Text = "ESP: ON"
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                createESP(plr)
            end
        end
    else
        toggleButton.Text = "ESP: OFF"
        for _, box in pairs(espBoxes) do
            if box then
                box:Destroy()
            end
        end
        espBoxes = {}
    end
end

-- Обновление ESP при появлении новых игроков
Players.PlayerAdded:Connect(function(plr)
    if espEnabled then
        plr.CharacterAdded:Connect(function()
            createESP(plr)
        end)
    end
end)

-- Обработчик нажатия кнопки
toggleButton.MouseButton1Click:Connect(toggleESP)
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "TeleportGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Функция телепорта
local function teleportPlayer(x, y, z)
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
    end
end

-- Переменная для хранения основного фрейма
local mainFrame = nil

-- Создание мини-кнопки с изображением
local function createMinimizedButton()
    local miniButton = Instance.new("ImageButton")
    miniButton.Name = "MiniButton"
    miniButton.Size = UDim2.new(0, 40, 0, 40)
    miniButton.Position = UDim2.new(0, 10, 0.5, -20)
    miniButton.Image = "rbxassetid://124010884667015"
    miniButton.BackgroundTransparency = 1  -- Прозрачный фон
    miniButton.Active = true
    miniButton.Draggable = true
    miniButton.Parent = gui

    -- Добавляем эффект при наведении
    miniButton.MouseEnter:Connect(function()
        miniButton.Size = UDim2.new(0, 45, 0, 45)
    end)
    
    miniButton.MouseLeave:Connect(function()
        miniButton.Size = UDim2.new(0, 40, 0, 40)
    end)

    miniButton.MouseButton1Click:Connect(function()
        miniButton:Destroy()
        if mainFrame and mainFrame.Parent then
            mainFrame.Visible = true
        else
            createMainGUI()
        end
    end)
end

-- Создание основного GUI
local function createMainGUI()
    -- Удаляем старый фрейм если есть
    if mainFrame then
        mainFrame:Destroy()
    end

    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 200, 0, 150)
    mainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gui

    -- Верхняя панель
    local dragBar = Instance.new("Frame")
    dragBar.Name = "DragBar"
    dragBar.Size = UDim2.new(1, 0, 0, 20)
    dragBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    dragBar.Parent = mainFrame

    -- Кнопка закрытия
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -20, 0, 0)
    closeButton.Text = "X"
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.Parent = mainFrame

    -- Кнопка ТП на спавн
    local spawnButton = Instance.new("TextButton")
    spawnButton.Name = "SpawnButton"
    spawnButton.Size = UDim2.new(0.8, 0, 0, 40)
    spawnButton.Position = UDim2.new(0.1, 0, 0.3, 0)
    spawnButton.Text = "ТП на спавн"
    spawnButton.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    spawnButton.Parent = mainFrame

    -- Кнопка ТП на место
    local placeButton = Instance.new("TextButton")
    placeButton.Name = "PlaceButton"
    placeButton.Size = UDim2.new(0.8, 0, 0, 40)
    placeButton.Position = UDim2.new(0.1, 0, 0.6, 0)
    placeButton.Text = "ТП то песта"
    placeButton.BackgroundColor3 = Color3.fromRGB(80, 255, 120)
    placeButton.Parent = mainFrame

    -- Обработчики событий
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        createMinimizedButton()
    end)

    spawnButton.MouseButton1Click:Connect(function()
        teleportPlayer(331.7, 511.5, 397.9)
    end)

    placeButton.MouseButton1Click:Connect(function()
        teleportPlayer(113.7, 335.5, 568.2)
    end)
end

-- Первый запуск
createMainGUI()

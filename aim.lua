--[=[
    Roblox Ultra Smart Aimbot + ESP System (Fixed Center Target)
    Разработчик: Твой бро-скриптер
    Управление: 
    - F1: Открыть/Закрыть меню
    - F2: Включить/Выключить Аимбот
    - Зажать ЛКМ на заголовке: Перетаскивать меню
    - Крестик [X]: Полное удаление скрипта, UI и ESP
--]=]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки по умолчанию
local AimbotEnabled = false
local EspEnabled = true
local MenuOpen = true
local FovRadius = 200
local TargetPart = "Head" 

-- Список доступных частей тела для UI
local bodyParts = {"Head", "Torso", "HumanoidRootPart"}
local currentPartIndex = 1

-- Таблица для хранения ESP коробок
local espBoxes = {}

--- ### 1. Создание Серо-Черно-Синего UI ###
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraAimbotMenuGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 230)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) 
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 102, 204) 
MainFrame.Visible = MenuOpen
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
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
StatusLabel.Text = "Status (F2): DISABLED"
StatusLabel.TextColor3 = Color3.fromRGB(200, 50, 50) 
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 16
StatusLabel.Parent = MainFrame

local FovLabel = Instance.new("TextLabel")
FovLabel.Size = UDim2.new(0, 120, 0, 30)
FovLabel.Position = UDim2.new(0, 10, 0, 80)
FovLabel.BackgroundTransparency = 1
FovLabel.Text = "FOV: " .. FovRadius
FovLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
FovLabel.TextXAlignment = Enum.TextXAlignment.Left
FovLabel.Font = Enum.Font.SourceSans
FovLabel.TextSize = 16
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

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(0, 120, 0, 30)
TargetLabel.Position = UDim2.new(0, 10, 0, 120)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Text = "Target: " .. TargetPart
TargetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetLabel.Font = Enum.Font.SourceSans
TargetLabel.TextSize = 16
TargetLabel.Parent = MainFrame

local TargetToggleBtn = Instance.new("TextButton")
TargetToggleBtn.Size = UDim2.new(0, 100, 0, 25)
TargetToggleBtn.Position = UDim2.new(0, 130, 0, 122)
TargetToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TargetToggleBtn.TextColor3 = Color3.fromRGB(0, 153, 255)
TargetToggleBtn.Text = "Change"
TargetToggleBtn.Font = Enum.Font.SourceSans
TargetToggleBtn.TextSize = 14
TargetToggleBtn.Parent = MainFrame

local EspLabel = Instance.new("TextLabel")
EspLabel.Size = UDim2.new(0, 120, 0, 30)
EspLabel.Position = UDim2.new(0, 10, 0, 160)
EspLabel.BackgroundTransparency = 1
EspLabel.Text = "Visuals (ESP):"
EspLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
EspLabel.TextXAlignment = Enum.TextXAlignment.Left
EspLabel.Font = Enum.Font.SourceSans
EspLabel.TextSize = 16
EspLabel.Parent = MainFrame

local EspToggleBtn = Instance.new("TextButton")
EspToggleBtn.Size = UDim2.new(0, 100, 0, 25)
EspToggleBtn.Position = UDim2.new(0, 130, 0, 162)
EspToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
EspToggleBtn.Font = Enum.Font.SourceSansBold
EspToggleBtn.TextSize = 14
EspToggleBtn.Parent = MainFrame

-- Круг FOV (Drawing API)
local FOVDrawing = Drawing.new("Circle")
FOVDrawing.Visible = true
FOVDrawing.Radius = FovRadius
FOVDrawing.Color = Color3.fromRGB(0, 102, 204)
FOVDrawing.Thickness = 1
FOVDrawing.Filled = false
FOVDrawing.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

--- ### 2. Логика Перетаскивания Меню (Drag System) ###
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

--- ### 3. Логика ESP (ВХ Квадраты) ###
local function createESP(player)
	if espBoxes[player] then return end

	local box = Drawing.new("Square")
	box.Visible = false
	box.Color = Color3.fromRGB(255, 255, 255)
	box.Thickness = 1.5
	box.Filled = false

	espBoxes[player] = box
end

local function removeESP(player)
	if espBoxes[player] then
		espBoxes[player]:Remove()
		espBoxes[player] = nil
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then createESP(player) end
end
Players.PlayerAdded:Connect(function(player)
	if player ~= LocalPlayer then createESP(player) end
end)
Players.PlayerRemoving:Connect(removeESP)

local function updateESP()
	for player, box in pairs(espBoxes) do
		if EspEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChildOfClass("Humanoid") and player.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
			local rootPart = player.Character.HumanoidRootPart
			local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)

			if onScreen then
				local scaleFactor = 1 / (screenPos.Z * math.tan(math.rad(Camera.FieldOfView / 2))) * 1000
				local boxWidth = 3 * scaleFactor
				local boxHeight = 4.5 * scaleFactor

				box.Size = Vector2.new(boxWidth, boxHeight)
				box.Position = Vector2.new(screenPos.X - boxWidth / 2, screenPos.Y - boxHeight / 2)
				
				if player.Team ~= LocalPlayer.Team then
					box.Color = Color3.fromRGB(255, 50, 50) 
				else
					box.Color = Color3.fromRGB(50, 255, 50) 
				end
				
				box.Visible = true
			else
				box.Visible = false
			end
		else
			box.Visible = false 
		end
	end
end

--- ### 4. Функция Самоликвидации (Self-Destroy) ###
local renderConnection 

CloseButton.MouseButton1Click:Connect(function()
	if renderConnection then renderConnection:Disconnect() end
	if FOVDrawing then FOVDrawing:Remove() end
	
	for player, box in pairs(espBoxes) do
		box:Remove()
	end
	espBoxes = {}

	ScreenGui:Destroy() 
	script:Destroy()    
end)

--- ### 5. Логика Изменения Настроек Интерфейса ###
local function updateUI()
	FovLabel.Text = "FOV: " .. FovRadius
	FOVDrawing.Radius = FovRadius
	TargetLabel.Text = "Target: " .. TargetPart
	
	if AimbotEnabled then
		StatusLabel.Text = "Status (F2): ENABLED"
		StatusLabel.TextColor3 = Color3.fromRGB(50, 200, 50)
	else
		StatusLabel.Text = "Status (F2): DISABLED"
		StatusLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
	end

	if EspEnabled then
		EspToggleBtn.Text = "ESP: ON"
		EspToggleBtn.TextColor3 = Color3.fromRGB(50, 255, 50)
	else
		EspToggleBtn.Text = "ESP: OFF"
		EspToggleBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
	end
end

FovPlus.MouseButton1Click:Connect(function()
	FovRadius = math.clamp(FovRadius + 5, 10, 600)
	updateUI()
end)

FovMinus.MouseButton1Click:Connect(function()
	FovRadius = math.clamp(FovRadius - 5, 10, 600)
	updateUI()
end)

TargetToggleBtn.MouseButton1Click:Connect(function()
	currentPartIndex = currentPartIndex + 1
	if currentPartIndex > #bodyParts then currentPartIndex = 1 end
	TargetPart = bodyParts[currentPartIndex]
	updateUI()
end)

EspToggleBtn.MouseButton1Click:Connect(function()
	EspEnabled = not EspEnabled
	updateUI()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F1 then
		MenuOpen = not MenuOpen
		MainFrame.Visible = MenuOpen
	elseif input.KeyCode == Enum.KeyCode.F2 then
		AimbotEnabled = not AimbotEnabled
		updateUI()
	end
end)

--- ### 6. Wall Check ###
local function isVisible(targetPartObj, targetCharacter)
	local origin = Camera.CFrame.Position
	local direction = targetPartObj.Position - origin
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetCharacter, Camera}
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.IgnoreWater = true
	
	local raycastResult = workspace:Raycast(origin, direction, raycastParams)
	return raycastResult == nil
end

--- ### 7. Поиск цели по HP приоритету (ИСПРАВЛЕНО: Расчет от Центра Экрана) ###
local function getBestTarget()
	local bestTargetPlayer = nil
	local lowestHealth = math.huge
	
	-- ИСПРАВЛЕНИЕ: берем истинный математический центр экрана вместо позиции мыши
	local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character then
			
			local actualPart = TargetPart
			if TargetPart == "Torso" and player.Character:FindFirstChild("UpperTorso") then
				actualPart = "UpperTorso"
			end
			
			local part = player.Character:FindFirstChild(actualPart)
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
			
			if part and humanoid and humanoid.Health > 0 then
				local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
				
				if onScreen then
					-- Считаем дистанцию строго от геометрического центра круга FOV
					local distanceToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
					
					if distanceToCenter < FovRadius then
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

updateUI()

--- ### 8. Основной цикл рендера ###
renderConnection = RunService.RenderStepped:Connect(function()
	if FOVDrawing then
		FOVDrawing.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	end
	
	updateESP()
	
	if AimbotEnabled then
		local targetPlayer = getBestTarget()
		if targetPlayer and targetPlayer.Character then
			local actualPart = TargetPart
			if TargetPart == "Torso" and targetPlayer.Character:FindFirstChild("UpperTorso") then
				actualPart = "UpperTorso"
			end
			
			local targetPartObj = targetPlayer.Character:FindFirstChild(actualPart)
			if targetPartObj then
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPartObj.Position)
			end
		end
	end
end)

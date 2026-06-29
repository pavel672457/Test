-- TOUCH FLING для Delta Injector (МОБИЛЬНАЯ ВЕРСИЯ)
-- Работает при касании экрана: персонаж летит в направлении свайпа

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Настройки
local flingPower = 150 -- Сила полета (чем больше, тем дальше)
local flingEnabled = true -- Включен ли флинг
local cooldownTime = 0.5 -- Задержка между флингами

-- Переменные для касаний
local touchStart = nil
local touchEnd = nil
local lastFlingTime = 0

-- Создание GUI индикатора
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

-- Кнопка вкл/выкл
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0.02, 0, 0.85, 0)
toggleButton.Text = "🔴 ВЫКЛ"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
toggleButton.BorderSizePixel = 0
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16
toggleButton.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = toggleButton

-- Индикатор направления
local directionIndicator = Instance.new("TextLabel")
directionIndicator.Size = UDim2.new(0, 200, 0, 30)
directionIndicator.Position = UDim2.new(0.5, -100, 0.02, 0)
directionIndicator.Text = "СВАЙПНИ ДЛЯ ФЛИНГА"
directionIndicator.TextColor3 = Color3.new(1, 1, 1)
directionIndicator.BackgroundColor3 = Color3.new(0, 0, 0, 0.5)
directionIndicator.BorderSizePixel = 0
directionIndicator.Font = Enum.Font.SourceSansBold
directionIndicator.TextSize = 18
directionIndicator.Parent = screenGui

-- Функция флинга
local function performFling(direction)
    if not flingEnabled then return end
    if not rootPart or not rootPart.Parent then return end
    
    local currentTime = tick()
    if currentTime - lastFlingTime < cooldownTime then return end
    lastFlingTime = currentTime
    
    -- Нормализуем направление
    local normalizedDirection = direction.Unit
    
    -- Применяем силу
    local velocity = normalizedDirection * flingPower
    velocity = Vector3.new(velocity.X, 0.5, velocity.Z) -- Добавляем немного высоты
    
    -- Получаем BodyVelocity для контроля
    local bodyVelocity = rootPart:FindFirstChild("TouchFlingVelocity")
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "TouchFlingVelocity"
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = velocity
    bodyVelocity.Parent = rootPart
    
    -- Автоматическое удаление через 0.5 секунды
    game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
    
    -- Визуальный эффект
    directionIndicator.Text = "🚀 ФЛИНГ!"
    directionIndicator.BackgroundColor3 = Color3.new(0, 0.8, 0.2, 0.7)
    wait(0.3)
    directionIndicator.Text = "СВАЙПНИ ДЛЯ ФЛИНГА"
    directionIndicator.BackgroundColor3 = Color3.new(0, 0, 0, 0.5)
end

-- Обработка касаний (начало)
game:GetService("UserInputService").TouchStarted:Connect(function(input)
    if not flingEnabled then return end
    touchStart = input.Position
end)

-- Обработка касаний (конец)
game:GetService("UserInputService").TouchEnded:Connect(function(input)
    if not flingEnabled then return end
    if not touchStart then return end
    
    touchEnd = input.Position
    local delta = touchEnd - touchStart
    
    -- Минимальная длина свайпа для активации
    local minSwipeLength = 50
    if delta.Magnitude < minSwipeLength then
        touchStart = nil
        touchEnd = nil
        return
    end
    
    -- Определяем направление
    local direction = Vector3.new(delta.X, 0, -delta.Y)
    
    -- Преобразуем в мировые координаты
    local camera = workspace.CurrentCamera
    local forward = camera.CFrame.LookVector
    local right = camera.CFrame.RightVector
    
    local worldDirection = (right * direction.X + forward * direction.Z)
    worldDirection = Vector3.new(worldDirection.X, 0, worldDirection.Z)
    
    if worldDirection.Magnitude > 0 then
        performFling(worldDirection)
    end
    
    touchStart = nil
    touchEnd = nil
end)

-- Обработка свайпа (альтернативный метод)
game:GetService("UserInputService").TouchMoved:Connect(function(input)
    if not flingEnabled then return end
    if not touchStart then return end
    
    local currentPos = input.Position
    local delta = currentPos - touchStart
    
    -- Показываем направление в реальном времени
    if delta.Magnitude > 50 then
        local angle = math.atan2(delta.X, -delta.Y)
        local degrees = math.deg(angle)
        local directionText = ""
        
        if degrees > -22.5 and degrees <= 22.5 then
            directionText = "⬆️ ВВЕРХ"
        elseif degrees > 22.5 and degrees <= 67.5 then
            directionText = "↗️ ВВЕРХ-ВПРАВО"
        elseif degrees > 67.5 and degrees <= 112.5 then
            directionText = "➡️ ВПРАВО"
        elseif degrees > 112.5 and degrees <= 157.5 then
            directionText = "↘️ ВНИЗ-ВПРАВО"
        elseif degrees > -67.5 and degrees <= -22.5 then
            directionText = "↖️ ВВЕРХ-ВЛЕВО"
        elseif degrees > -112.5 and degrees <= -67.5 then
            directionText = "⬅️ ВЛЕВО"
        elseif degrees > -157.5 and degrees <= -112.5 then
            directionText = "↙️ ВНИЗ-ВЛЕВО"
        else
            directionText = "⬇️ ВНИЗ"
        end
        
        directionIndicator.Text = "👆 " .. directionText .. " (" .. math.floor(delta.Magnitude) .. "px)"
        directionIndicator.BackgroundColor3 = Color3.new(0.3, 0.6, 1, 0.7)
    end
end)

-- Кнопка вкл/выкл
toggleButton.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    if flingEnabled then
        toggleButton.Text = "🟢 ВКЛ"
        toggleButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
        directionIndicator.Text = "СВАЙПНИ ДЛЯ ФЛИНГА"
        directionIndicator.BackgroundColor3 = Color3.new(0, 0, 0, 0.5)
    else
        toggleButton.Text = "🔴 ВЫКЛ"
        toggleButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
        directionIndicator.Text = "⛔ ВЫКЛЮЧЕН"
        directionIndicator.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2, 0.7)
    end
end)

-- Обновление персонажа
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

print("✅ Touch Fling загружен! Свайпай по экрану для полета")
print("📱 Настройки: сила = " .. flingPower .. ", задержка = " .. cooldownTime .. "с")

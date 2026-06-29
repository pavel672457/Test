-- ============================================
-- FLY GUI ДЛЯ DELTA INJECTOR (СЕНСОРНОЕ УПРАВЛЕНИЕ)
-- Полное управление пальцами без клавиатуры
-- ============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Переменные
local flying = false
local speed = 50
local maxSpeed = 500
local minSpeed = 10
local bodyVelocity = nil
local noclipEnabled = false

-- Сенсорное управление
local touchMove = Vector3.new(0, 0, 0)
local touchUp = false
local touchDown = false
local joystickActive = false
local joystickStart = Vector2.new(0, 0)
local joystickCurrent = Vector2.new(0, 0)

-- Функции полёта
local function createBodyVelocity()
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1, 1, 1) * 100000
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = rootPart
    return bv
end

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        if guiElements then
            guiElements.NoclipBtn.Text = "🚫 NOCLIP ON"
            guiElements.NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        end
    else
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        if guiElements then
            guiElements.NoclipBtn.Text = "🚫 NOCLIP OFF"
            guiElements.NoclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end
    end
end

local function toggleFly()
    flying = not flying
    
    if flying then
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyVelocity = createBodyVelocity()
        humanoid.PlatformStand = true
        humanoid.AutoRotate = true
        if guiElements then
            guiElements.ToggleBtn.Text = "🛬 FLY ON"
            guiElements.ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            guiElements.StatusLabel.Text = "✈️ FLYING"
            guiElements.StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        humanoid.PlatformStand = false
        if guiElements then
            guiElements.ToggleBtn.Text = "🛫 FLY OFF"
            guiElements.ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            guiElements.StatusLabel.Text = "⛔ GROUNDED"
            guiElements.StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
end

-- ============================================
-- СОЗДАНИЕ GUI С СЕНСОРНЫМ УПРАВЛЕНИЕМ
-- ============================================

local function createMobileGUI()
    if player.PlayerGui:FindFirstChild("DeltaFlyGUI") then
        player.PlayerGui.DeltaFlyGUI:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeltaFlyGUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = player.PlayerGui
    
    -- ===== ОСНОВНАЯ ПАНЕЛЬ (ВНИЗУ) =====
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 0, 200)
    mainFrame.Position = UDim2.new(0, 0, 1, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = mainFrame
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.Text = "✈️ FLY CONTROL"
    title.TextColor3 = Color3.fromRGB(100, 200, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = mainFrame
    
    -- Статус
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 120, 0, 25)
    statusLabel.Position = UDim2.new(1, -130, 0, 5)
    statusLabel.Text = "⛔ GROUNDED"
    statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 14
    statusLabel.Parent = mainFrame
    
    -- ===== КНОПКИ УПРАВЛЕНИЯ =====
    
    -- Ряд 1: Toggle Fly и Noclip
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 160, 0, 50)
    toggleBtn.Position = UDim2.new(0.02, 0, 0.25, 0)
    toggleBtn.Text = "🛫 FLY OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 16
    toggleBtn.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleBtn
    
    local noclipBtn = Instance.new("TextButton")
    noclipBtn.Size = UDim2.new(0, 140, 0, 50)
    noclipBtn.Position = UDim2.new(0.3, 0, 0.25, 0)
    noclipBtn.Text = "🚫 NOCLIP OFF"
    noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    noclipBtn.Font = Enum.Font.GothamBold
    noclipBtn.TextSize = 14
    noclipBtn.Parent = mainFrame
    
    local noclipCorner = Instance.new("UICorner")
    noclipCorner.CornerRadius = UDim.new(0, 12)
    noclipCorner.Parent = noclipBtn
    
    -- ===== СЕНСОРНЫЙ ДЖОЙСТИК (СЛЕВА) =====
    local joystickBg = Instance.new("Frame")
    joystickBg.Size = UDim2.new(0, 120, 0, 120)
    joystickBg.Position = UDim2.new(0.02, 0, 0.6, 0)
    joystickBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    joystickBg.BackgroundTransparency = 0.85
    joystickBg.BorderSizePixel = 0
    joystickBg.Parent = mainFrame
    
    local joystickCorner = Instance.new("UICorner")
    joystickCorner.CornerRadius = UDim.new(1, 0)
    joystickCorner.Parent = joystickBg
    
    -- Круг джойстика
    local joystickCircle = Instance.new("Frame")
    joystickCircle.Size = UDim2.new(0, 50, 0, 50)
    joystickCircle.Position = UDim2.new(0.5, -25, 0.5, -25)
    joystickCircle.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    joystickCircle.BackgroundTransparency = 0.3
    joystickCircle.BorderSizePixel = 0
    joystickCircle.Parent = joystickBg
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = joystickCircle
    
    -- ===== КНОПКИ ВВЕРХ/ВНИЗ (СПРАВА) =====
    local upBtn = Instance.new("TextButton")
    upBtn.Size = UDim2.new(0, 60, 0, 50)
    upBtn.Position = UDim2.new(0.7, 0, 0.6, 0)
    upBtn.Text = "⬆️"
    upBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    upBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    upBtn.Font = Enum.Font.GothamBold
    upBtn.TextSize = 24
    upBtn.Parent = mainFrame
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 12)
    upCorner.Parent = upBtn
    
    local downBtn = Instance.new("TextButton")
    downBtn.Size = UDim2.new(0, 60, 0, 50)
    downBtn.Position = UDim2.new(0.85, 0, 0.6, 0)
    downBtn.Text = "⬇️"
    downBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    downBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    downBtn.Font = Enum.Font.GothamBold
    downBtn.TextSize = 24
    downBtn.Parent = mainFrame
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 12)
    downCorner.Parent = downBtn
    
    -- ===== УПРАВЛЕНИЕ СКОРОСТЬЮ =====
    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(0, 150, 0, 40)
    speedFrame.Position = UDim2.new(0.7, 0, 0.85, 0)
    speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    speedFrame.BackgroundTransparency = 0.5
    speedFrame.BorderSizePixel = 0
    speedFrame.Parent = mainFrame
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 10)
    speedCorner.Parent = speedFrame
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1, 0, 1, 0)
    speedLabel.Text = "⚡ 50"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 16
    speedLabel.Parent = speedFrame
    
    -- Кнопки скорости
    local speedMinus = Instance.new("TextButton")
    speedMinus.Size = UDim2.new(0, 35, 0, 35)
    speedMinus.Position = UDim2.new(0.58, 0, 0.85, 0)
    speedMinus.Text = "➖"
    speedMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedMinus.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    speedMinus.Font = Enum.Font.GothamBold
    speedMinus.TextSize = 20
    speedMinus.Parent = mainFrame
    
    local minusCorner = Instance.new("UICorner")
    minusCorner.CornerRadius = UDim.new(0, 8)
    minusCorner.Parent = speedMinus
    
    local speedPlus = Instance.new("TextButton")
    speedPlus.Size = UDim2.new(0, 35, 0, 35)
    speedPlus.Position = UDim2.new(0.92, 0, 0.85, 0)
    speedPlus.Text = "➕"
    speedPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedPlus.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    speedPlus.Font = Enum.Font.GothamBold
    speedPlus.TextSize = 20
    speedPlus.Parent = mainFrame
    
    local plusCorner = Instance.new("UICorner")
    plusCorner.CornerRadius = UDim.new(0, 8)
    plusCorner.Parent = speedPlus
    
    -- ===== КНОПКА ЗАКРЫТЬ =====
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 30)
    closeBtn.Position = UDim2.new(1, -45, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    return {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        ToggleBtn = toggleBtn,
        StatusLabel = statusLabel,
        NoclipBtn = noclipBtn,
        JoystickBg = joystickBg,
        JoystickCircle = joystickCircle,
        UpBtn = upBtn,
        DownBtn = downBtn,
        SpeedLabel = speedLabel,
        SpeedMinus = speedMinus,
        SpeedPlus = speedPlus,
        CloseBtn = closeBtn
    }
end

-- Создаём GUI
local guiElements = createMobileGUI()

-- ============================================
-- ОБРАБОТЧИК СЕНСОРНОГО ДЖОЙСТИКА
-- ============================================

local function updateJoystick(position)
    local bgPos = guiElements.JoystickBg.AbsolutePosition
    local bgSize = guiElements.JoystickBg.AbsoluteSize
    local center = bgPos + bgSize / 2
    local radius = bgSize.X / 2 - 25
    
    local diff = position - center
    local distance = diff.Magnitude
    
    if distance > radius then
        diff = diff.Unit * radius
    end
    
    -- Обновляем позицию кружка
    guiElements.JoystickCircle.Position = UDim2.new(0.5, diff.X - 25, 0.5, diff.Y - 25)
    
    -- Вычисляем направление движения
    local normalized = diff / radius
    if distance < 10 then
        touchMove = Vector3.new(0, 0, 0)
        joystickActive = false
    else
        joystickActive = true
        -- Преобразуем в 3D направление (относительно камеры)
        local camera = workspace.CurrentCamera
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        
        -- Инвертируем Y для правильного направления
        touchMove = (right * normalized.X) + (forward * -normalized.Y)
        touchMove = touchMove.Unit
    end
end

-- Обработка касаний для джойстика
guiElements.JoystickBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        joystickStart = input.Position
        updateJoystick(input.Position)
    end
end)

guiElements.JoystickBg.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        updateJoystick(input.Position)
    end
end)

guiElements.JoystickBg.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        -- Возвращаем джойстик в центр
        guiElements.JoystickCircle.Position = UDim2.new(0.5, -25, 0.5, -25)
        touchMove = Vector3.new(0, 0, 0)
        joystickActive = false
    end
end)

-- ============================================
-- ОБРАБОТЧИКИ КНОПОК
-- ============================================

-- Toggle Fly
guiElements.ToggleBtn.MouseButton1Click:Connect(toggleFly)

-- Noclip
guiElements.NoclipBtn.MouseButton1Click:Connect(function()
    toggleNoclip()
end)

-- Вверх (с удержанием)
local upPressed = false
guiElements.UpBtn.MouseButton1Down:Connect(function()
    upPressed = true
    touchUp = true
end)

guiElements.UpBtn.MouseButton1Up:Connect(function()
    upPressed = false
    touchUp = false
end)

guiElements.UpBtn.MouseLeave:Connect(function()
    upPressed = false
    touchUp = false
end)

-- Вниз (с удержанием)
local downPressed = false
guiElements.DownBtn.MouseButton1Down:Connect(function()
    downPressed = true
    touchDown = true
end)

guiElements.DownBtn.MouseButton1Up:Connect(function()
    downPressed = false
    touchDown = false
end)

guiElements.DownBtn.MouseLeave:Connect(function()
    downPressed = false
    touchDown = false
end)

-- Скорость
local function updateSpeed()
    guiElements.SpeedLabel.Text = "⚡ " .. speed
end

guiElements.SpeedPlus.MouseButton1Click:Connect(function()
    speed = math.min(speed + 10, maxSpeed)
    updateSpeed()
end)

guiElements.SpeedMinus.MouseButton1Click:Connect(function()
    speed = math.max(speed - 10, minSpeed)
    updateSpeed()
end)

-- Удержание для быстрой смены скорости
local function holdSpeed(button, increase)
    local holding = false
    button.MouseButton1Down:Connect(function()
        holding = true
        while holding do
            if increase then
                speed = math.min(speed + 10, maxSpeed)
            else
                speed = math.max(speed - 10, minSpeed)
            end
            updateSpeed()
            wait(0.1)
        end
    end)
    button.MouseButton1Up:Connect(function()
        holding = false
    end)
    button.MouseLeave:Connect(function()
        holding = false
    end)
end

holdSpeed(guiElements.SpeedPlus, true)
holdSpeed(guiElements.SpeedMinus, false)

-- Закрыть
guiElements.CloseBtn.MouseButton1Click:Connect(function()
    if flying then toggleFly() end
    if noclipEnabled then toggleNoclip() end
    guiElements.ScreenGui:Destroy()
end)

-- ============================================
-- ОСНОВНОЙ ЦИКЛ ДВИЖЕНИЯ (СЕНСОРНЫЙ)
-- ============================================

local runService = game:GetService("RunService")

runService.Heartbeat:Connect(function()
    if flying and bodyVelocity then
        local moveDir = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        
        -- Добавляем движение от джойстика
        if joystickActive then
            moveDir = moveDir + touchMove
        end
        
        -- Добавляем подъём/спуск
        if touchUp then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if touchDown then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        
        -- Нормализация и применение скорости
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * speed
            bodyVelocity.Velocity = moveDir
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- ============================================
-- ОБНОВЛЕНИЕ ПРИ ПЕРЕРОЖДЕНИИ
-- ============================================

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    if flying then
        wait(0.1)
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyVelocity = createBodyVelocity()
        humanoid.PlatformStand = true
    end
    
    if noclipEnabled then
        wait(0.1)
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ============================================
-- ФУНКЦИИ ДЛЯ КОНСОЛИ
-- ============================================

_G.MobileFly = {
    Toggle = toggleFly,
    SetSpeed = function(newSpeed)
        speed = math.clamp(newSpeed, minSpeed, maxSpeed)
        updateSpeed()
    end,
    GetSpeed = function() return speed end,
    IsFlying = function() return flying end,
    ToggleNoclip = toggleNoclip,
    Destroy = function()
        if guiElements and guiElements.ScreenGui then
            guiElements.ScreenGui:Destroy()
        end
        if flying then toggleFly() end
        if noclipEnabled then toggleNoclip() end
    end
}

-- ============================================
-- ПРИВЕТСТВЕННОЕ СООБЩЕНИЕ
-- ============================================

print("========================================")
print("📱 MOBILE FLY PRO LOADED!")
print("🕹️  Touch Controls Active")
print("========================================")
print("🎮 LEFT: Joystick for movement")
print("⬆️⬇️  RIGHT: Up/Down buttons")
print("⚡ Speed: " .. speed)
print("========================================")

-- Всплывающее уведомление
local function showStartupMessage()
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 350, 0, 80)
    notif.Position = UDim2.new(0.5, -175, 0.3, 0)
    notif.Text = "🕹️ TOUCH CONTROLS\nACTIVATED!"
    notif.TextColor3 = Color3.fromRGB(0, 255, 255)
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.3
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 24
    notif.TextScaled = true
    notif.Parent = guiElements.ScreenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 15)
    notifCorner.Parent = notif
    
    -- Анимация
    notif.BackgroundTransparency = 1
    notif.TextTransparency = 1
    for i = 1, 20 do
        wait(0.02)
        notif.BackgroundTransparency = 1 - (i / 20) * 0.7
        notif.TextTransparency = 1 - (i / 20)
    end
    
    wait(2)
    
    for i = 1, 20 do
        wait(0.02)
        notif.BackgroundTransparency = 0.3 + (i / 20) * 0.7
        notif.TextTransparency = (i / 20)
    end
    
    notif:Destroy()
end

coroutine.wrap(showStartupMessage)()

-- ============================================
-- FLY GUI ДЛЯ DELTA INJECTOR (МОБИЛЬНЫЙ)
-- Полностью оптимизирован под сенсорное управление
-- ============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Переменные полёта
local flying = false
local speed = 50
local maxSpeed = 500
local minSpeed = 10
local bodyVelocity = nil
local noclipEnabled = false

-- Функция для создания BodyVelocity
local function createBodyVelocity()
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1, 1, 1) * 100000
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = rootPart
    return bv
end

-- Функция Noclip (проход сквозь стены)
local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        print("🚫 Noclip: ON")
    else
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        print("🚫 Noclip: OFF")
    end
end

-- Функция включения/выключения полёта
local function toggleFly()
    flying = not flying
    
    if flying then
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyVelocity = createBodyVelocity()
        humanoid.PlatformStand = true
        humanoid.AutoRotate = true
        print("✈️ Fly: ON")
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
        print("✈️ Fly: OFF")
        if guiElements then
            guiElements.ToggleBtn.Text = "🛫 FLY OFF"
            guiElements.ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            guiElements.StatusLabel.Text = "⛔ GROUNDED"
            guiElements.StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
end

-- ============================================
-- СОЗДАНИЕ GUI ДЛЯ DELTA
-- ============================================

local function createDeltaGUI()
    -- Очищаем старые GUI
    if player.PlayerGui:FindFirstChild("DeltaFlyGUI") then
        player.PlayerGui.DeltaFlyGUI:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeltaFlyGUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = player.PlayerGui
    
    -- Главная панель (полупрозрачная)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Сглаживание
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = mainFrame
    
    -- Затемнение фона (для улучшения видимости)
    local blur = Instance.new("BlurEffect")
    blur.Size = 10
    blur.Parent = screenGui
    
    -- Заголовок
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 40)
    titleFrame.Position = UDim2.new(0, 0, 0, 0)
    titleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    titleFrame.BackgroundTransparency = 0.3
    titleFrame.BorderSizePixel = 0
    titleFrame.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 20)
    titleCorner.Parent = titleFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 1, 0)
    title.Text = "✈️ DELTA FLY PRO"
    title.TextColor3 = Color3.fromRGB(100, 200, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.Parent = titleFrame
    
    -- Статус
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 150, 0, 30)
    statusLabel.Position = UDim2.new(0.5, -75, 0.15, 0)
    statusLabel.Text = "⛔ GROUNDED"
    statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 16
    statusLabel.Parent = mainFrame
    
    -- Кнопка Toggle Fly (большая)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 200, 0, 60)
    toggleBtn.Position = UDim2.new(0.5, -100, 0.3, 0)
    toggleBtn.Text = "🛫 FLY OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 20
    toggleBtn.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 15)
    toggleCorner.Parent = toggleBtn
    
    -- Эффект нажатия
    local function addButtonEffect(button)
        button.MouseButton1Down:Connect(function()
            button.BackgroundColor3 = button.BackgroundColor3 * 0.7
            wait(0.05)
            button.BackgroundColor3 = button.BackgroundColor3 / 0.7
        end)
    end
    addButtonEffect(toggleBtn)
    
    -- Панель скорости
    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(0, 320, 0, 60)
    speedFrame.Position = UDim2.new(0.5, -160, 0.55, 0)
    speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    speedFrame.BackgroundTransparency = 0.3
    speedFrame.BorderSizePixel = 0
    speedFrame.Parent = mainFrame
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 12)
    speedCorner.Parent = speedFrame
    
    -- Кнопка минус
    local minusBtn = Instance.new("TextButton")
    minusBtn.Size = UDim2.new(0, 50, 0, 40)
    minusBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
    minusBtn.Text = "➖"
    minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minusBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 24
    minusBtn.Parent = speedFrame
    
    local minusCorner = Instance.new("UICorner")
    minusCorner.CornerRadius = UDim.new(0, 10)
    minusCorner.Parent = minusBtn
    addButtonEffect(minusBtn)
    
    -- Индикатор скорости
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 100, 0, 40)
    speedLabel.Position = UDim2.new(0.5, -50, 0.15, 0)
    speedLabel.Text = "⚡ 50"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    speedLabel.BackgroundTransparency = 0.5
    speedLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 18
    speedLabel.Parent = speedFrame
    
    local speedCorner2 = Instance.new("UICorner")
    speedCorner2.CornerRadius = UDim.new(0, 10)
    speedCorner2.Parent = speedLabel
    
    -- Кнопка плюс
    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 50, 0, 40)
    plusBtn.Position = UDim2.new(0.85, 0, 0.15, 0)
    plusBtn.Text = "➕"
    plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    plusBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 24
    plusBtn.Parent = speedFrame
    
    local plusCorner = Instance.new("UICorner")
    plusCorner.CornerRadius = UDim.new(0, 10)
    plusCorner.Parent = plusBtn
    addButtonEffect(plusBtn)
    
    -- Кнопка Noclip
    local noclipBtn = Instance.new("TextButton")
    noclipBtn.Size = UDim2.new(0, 150, 0, 40)
    noclipBtn.Position = UDim2.new(0.05, 0, 0.78, 0)
    noclipBtn.Text = "🚫 NOCLIP OFF"
    noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    noclipBtn.Font = Enum.Font.GothamBold
    noclipBtn.TextSize = 16
    noclipBtn.Parent = mainFrame
    
    local noclipCorner = Instance.new("UICorner")
    noclipCorner.CornerRadius = UDim.new(0, 12)
    noclipCorner.Parent = noclipBtn
    addButtonEffect(noclipBtn)
    
    -- Кнопка закрыть
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 100, 0, 40)
    closeBtn.Position = UDim2.new(0.75, 0, 0.78, 0)
    closeBtn.Text = "✕ CLOSE"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 12)
    closeCorner.Parent = closeBtn
    addButtonEffect(closeBtn)
    
    -- Возвращаем элементы
    return {
        ScreenGui = screenGui,
        MainFrame = mainFrame,
        ToggleBtn = toggleBtn,
        StatusLabel = statusLabel,
        SpeedLabel = speedLabel,
        PlusBtn = plusBtn,
        MinusBtn = minusBtn,
        NoclipBtn = noclipBtn,
        CloseBtn = closeBtn
    }
end

-- Создаём GUI
local guiElements = createDeltaGUI()

-- Обновление индикатора скорости
local function updateSpeedLabel()
    if guiElements and guiElements.SpeedLabel then
        guiElements.SpeedLabel.Text = "⚡ " .. speed
    end
end

-- ============================================
-- ОБРАБОТЧИКИ КНОПОК
-- ============================================

-- Toggle Fly
guiElements.ToggleBtn.MouseButton1Click:Connect(toggleFly)

-- Увеличение скорости (с удержанием)
local plusHolding = false
guiElements.PlusBtn.MouseButton1Down:Connect(function()
    plusHolding = true
    speed = math.min(speed + 10, maxSpeed)
    updateSpeedLabel()
    
    -- Быстрое увеличение при удержании
    coroutine.wrap(function()
        while plusHolding do
            wait(0.1)
            if plusHolding then
                speed = math.min(speed + 10, maxSpeed)
                updateSpeedLabel()
            end
        end
    end)()
end)

guiElements.PlusBtn.MouseButton1Up:Connect(function()
    plusHolding = false
end)

guiElements.PlusBtn.MouseLeave:Connect(function()
    plusHolding = false
end)

-- Уменьшение скорости (с удержанием)
local minusHolding = false
guiElements.MinusBtn.MouseButton1Down:Connect(function()
    minusHolding = true
    speed = math.max(speed - 10, minSpeed)
    updateSpeedLabel()
    
    coroutine.wrap(function()
        while minusHolding do
            wait(0.1)
            if minusHolding then
                speed = math.max(speed - 10, minSpeed)
                updateSpeedLabel()
            end
        end
    end)()
end)

guiElements.MinusBtn.MouseButton1Up:Connect(function()
    minusHolding = false
end)

guiElements.MinusBtn.MouseLeave:Connect(function()
    minusHolding = false
end)

-- Noclip
guiElements.NoclipBtn.MouseButton1Click:Connect(function()
    toggleNoclip()
    if noclipEnabled then
        guiElements.NoclipBtn.Text = "🚫 NOCLIP ON"
        guiElements.NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        guiElements.NoclipBtn.Text = "🚫 NOCLIP OFF"
        guiElements.NoclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

-- Закрыть GUI
guiElements.CloseBtn.MouseButton1Click:Connect(function()
    if flying then
        toggleFly()
    end
    if noclipEnabled then
        toggleNoclip()
    end
    guiElements.ScreenGui:Destroy()
    print("🚫 GUI Closed")
end)

-- ============================================
-- ОСНОВНОЙ ЦИКЛ ДВИЖЕНИЯ
-- ============================================

local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

runService.Heartbeat:Connect(function()
    if flying and bodyVelocity then
        local moveDir = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        local up = Vector3.new(0, 1, 0)
        
        -- Сенсорное управление (для телефона)
        -- Можно использовать виртуальные кнопки, но для простоты оставляем клавиши
        if userInput:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + forward
        end
        if userInput:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - forward
        end
        if userInput:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - right
        end
        if userInput:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + right
        end
        if userInput:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + up
        end
        if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - up
        end
        
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

_G.DeltaFly = {
    Toggle = toggleFly,
    SetSpeed = function(newSpeed)
        speed = math.clamp(newSpeed, minSpeed, maxSpeed)
        updateSpeedLabel()
        print("⚡ Speed: " .. speed)
    end,
    GetSpeed = function()
        return speed
    end,
    IsFlying = function()
        return flying
    end,
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
print("✈️  DELTA FLY PRO LOADED!")
print("📱 Optimized for Mobile")
print("========================================")
print("🟢 Speed: " .. speed)
print("🎮 Use on-screen buttons to control")
print("📌 Press FLY ON to start flying")
print("========================================")

-- Всплывающее уведомление
local function showNotification()
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 300, 0, 60)
    notif.Position = UDim2.new(0.5, -150, 0.1, 0)
    notif.Text = "✈️ FLY GUI ACTIVATED!"
    notif.TextColor3 = Color3.fromRGB(0, 255, 255)
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.3
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 22
    notif.Parent = guiElements.ScreenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 15)
    notifCorner.Parent = notif
    
    -- Анимация появления
    notif.BackgroundTransparency = 1
    notif.TextTransparency = 1
    for i = 1, 20 do
        wait(0.02)
        notif.BackgroundTransparency = 1 - (i / 20) * 0.7
        notif.TextTransparency = 1 - (i / 20)
    end
    
    wait(2)
    
    -- Анимация исчезновения
    for i = 1, 20 do
        wait(0.02)
        notif.BackgroundTransparency = 0.3 + (i / 20) * 0.7
        notif.TextTransparency = (i / 20)
    end
    
    notif:Destroy()
end

coroutine.wrap(showNotification)()

-- ============================================
-- ЗАЩИТА ОТ ВЫКЛЮЧЕНИЯ
-- ============================================

-- Пересоздаём GUI если оно было удалено
local function recreateGUI()
    if not guiElements or not guiElements.ScreenGui or not guiElements.ScreenGui.Parent then
        guiElements = createDeltaGUI()
        -- Переназначаем обработчики (упрощённо)
        guiElements.ToggleBtn.MouseButton1Click:Connect(toggleFly)
        -- ... и так далее (можно оптимизировать)
        print("🔄 GUI Recreated")
    end
end

-- Проверка каждые 5 секунд
coroutine.wrap(function()
    while true do
        wait(5)
        recreateGUI()
    end
end)()

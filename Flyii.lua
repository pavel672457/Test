-- ============================================
-- FLY GUI ДЛЯ DELTA INJECTOR (КНОПОЧНОЕ УПРАВЛЕНИЕ)
-- Полное управление кнопками для телефона
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

-- Кнопочное управление
local moveForward = false
local moveBackward = false
local moveLeft = false
local moveRight = false
local moveUp = false
local moveDown = false

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
-- СОЗДАНИЕ GUI С КНОПКАМИ
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
    
    -- ===== ОСНОВНАЯ ПАНЕЛЬ =====
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 0, 320)
    mainFrame.Position = UDim2.new(0, 0, 1, -320)
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
    
    -- ===== ВЕРХНИЙ РЯД КНОПОК =====
    -- Кнопка Toggle Fly
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 180, 0, 45)
    toggleBtn.Position = UDim2.new(0.02, 0, 0.12, 0)
    toggleBtn.Text = "🛫 FLY OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 16
    toggleBtn.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleBtn
    
    -- Кнопка Noclip
    local noclipBtn = Instance.new("TextButton")
    noclipBtn.Size = UDim2.new(0, 160, 0, 45)
    noclipBtn.Position = UDim2.new(0.3, 0, 0.12, 0)
    noclipBtn.Text = "🚫 NOCLIP OFF"
    noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    noclipBtn.Font = Enum.Font.GothamBold
    noclipBtn.TextSize = 14
    noclipBtn.Parent = mainFrame
    
    local noclipCorner = Instance.new("UICorner")
    noclipCorner.CornerRadius = UDim.new(0, 12)
    noclipCorner.Parent = noclipBtn
    
    -- ===== КНОПКИ ДВИЖЕНИЯ (СЕТКА 3x3) =====
    local buttonSize = 55
    local spacing = 10
    local startX = 0.05
    local startY = 0.35
    
    -- Функция создания кнопки движения
    local function createMovementButton(text, x, y, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, buttonSize, 0, buttonSize)
        btn.Position = UDim2.new(x, 0, y, 0)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.2
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 24
        btn.Parent = mainFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = btn
        
        return btn
    end
    
    -- Создаём сетку кнопок
    -- Ряд 1: ВВЕРХ (центр)
    local upBtn = createMovementButton("⬆", startX + (buttonSize + spacing) * 1 / 100, startY, Color3.fromRGB(0, 150, 255))
    
    -- Ряд 2: ВЛЕВО, (центр), ВПРАВО
    local leftBtn = createMovementButton("⬅", startX + (buttonSize + spacing) * 0 / 100, startY + (buttonSize + spacing) / 100, Color3.fromRGB(255, 150, 0))
    local centerBtn = createMovementButton("⬛", startX + (buttonSize + spacing) * 1 / 100, startY + (buttonSize + spacing) / 100, Color3.fromRGB(50, 50, 50))
    centerBtn.BackgroundTransparency = 0.8
    local rightBtn = createMovementButton("➡", startX + (buttonSize + spacing) * 2 / 100, startY + (buttonSize + spacing) / 100, Color3.fromRGB(255, 150, 0))
    
    -- Ряд 3: ВНИЗ (центр)
    local downBtn = createMovementButton("⬇", startX + (buttonSize + spacing) * 1 / 100, startY + (buttonSize + spacing) * 2 / 100, Color3.fromRGB(255, 150, 0))
    
    -- ===== КНОПКИ ВВЕРХ/ВНИЗ (ПО ВЫСОТЕ) СПРАВА =====
    local upHeightBtn = Instance.new("TextButton")
    upHeightBtn.Size = UDim2.new(0, 60, 0, 60)
    upHeightBtn.Position = UDim2.new(0.75, 0, 0.35, 0)
    upHeightBtn.Text = "⬆️⬆️"
    upHeightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    upHeightBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    upHeightBtn.BackgroundTransparency = 0.2
    upHeightBtn.Font = Enum.Font.GothamBold
    upHeightBtn.TextSize = 20
    upHeightBtn.Parent = mainFrame
    
    local upHeightCorner = Instance.new("UICorner")
    upHeightCorner.CornerRadius = UDim.new(0, 12)
    upHeightCorner.Parent = upHeightBtn
    
    local downHeightBtn = Instance.new("TextButton")
    downHeightBtn.Size = UDim2.new(0, 60, 0, 60)
    downHeightBtn.Position = UDim2.new(0.88, 0, 0.35, 0)
    downHeightBtn.Text = "⬇️⬇️"
    downHeightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    downHeightBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    downHeightBtn.BackgroundTransparency = 0.2
    downHeightBtn.Font = Enum.Font.GothamBold
    downHeightBtn.TextSize = 20
    downHeightBtn.Parent = mainFrame
    
    local downHeightCorner = Instance.new("UICorner")
    downHeightCorner.CornerRadius = UDim.new(0, 12)
    downHeightCorner.Parent = downHeightBtn
    
    -- ===== УПРАВЛЕНИЕ СКОРОСТЬЮ =====
    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(0, 250, 0, 40)
    speedFrame.Position = UDim2.new(0.5, -125, 0.85, 0)
    speedFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    speedFrame.BackgroundTransparency = 0.5
    speedFrame.BorderSizePixel = 0
    speedFrame.Parent = mainFrame
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 10)
    speedCorner.Parent = speedFrame
    
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.4, 0, 1, 0)
    speedLabel.Position = UDim2.new(0.3, 0, 0, 0)
    speedLabel.Text = "⚡ 50"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 16
    speedLabel.Parent = speedFrame
    
    local speedMinus = Instance.new("TextButton")
    speedMinus.Size = UDim2.new(0, 40, 0, 35)
    speedMinus.Position = UDim2.new(0.02, 0, 0.06, 0)
    speedMinus.Text = "➖"
    speedMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedMinus.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    speedMinus.Font = Enum.Font.GothamBold
    speedMinus.TextSize = 20
    speedMinus.Parent = speedFrame
    
    local minusCorner = Instance.new("UICorner")
    minusCorner.CornerRadius = UDim.new(0, 8)
    minusCorner.Parent = speedMinus
    
    local speedPlus = Instance.new("TextButton")
    speedPlus.Size = UDim2.new(0, 40, 0, 35)
    speedPlus.Position = UDim2.new(0.82, 0, 0.06, 0)
    speedPlus.Text = "➕"
    speedPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedPlus.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    speedPlus.Font = Enum.Font.GothamBold
    speedPlus.TextSize = 20
    speedPlus.Parent = speedFrame
    
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
        UpBtn = upBtn,
        DownBtn = downBtn,
        LeftBtn = leftBtn,
        RightBtn = rightBtn,
        UpHeightBtn = upHeightBtn,
        DownHeightBtn = downHeightBtn,
        SpeedLabel = speedLabel,
        SpeedMinus = speedMinus,
        SpeedPlus = speedPlus,
        CloseBtn = closeBtn
    }
end

-- Создаём GUI
local guiElements = createMobileGUI()

-- ============================================
-- ОБРАБОТЧИКИ КНОПОК (С УДЕРЖАНИЕМ)
-- ============================================

-- Функция для обработки удержания кнопок
local function setupHoldButton(button, onDown, onUp)
    local holding = false
    
    button.MouseButton1Down:Connect(function()
        holding = true
        onDown()
        
        -- Цикл удержания
        coroutine.wrap(function()
            while holding do
                wait(0.05)
                if holding then
                    onDown()
                end
            end
        end)()
    end)
    
    button.MouseButton1Up:Connect(function()
        holding = false
        if onUp then onUp() end
    end)
    
    button.MouseLeave:Connect(function()
        if holding then
            holding = false
            if onUp then onUp() end
        end
    end)
    
    -- Для сенсорного экрана
    button.TouchEnded:Connect(function()
        holding = false
        if onUp then onUp() end
    end)
end

-- Настройка кнопок движения
setupHoldButton(guiElements.UpBtn, function() moveForward = true end, function() moveForward = false end)
setupHoldButton(guiElements.DownBtn, function() moveBackward = true end, function() moveBackward = false end)
setupHoldButton(guiElements.LeftBtn, function() moveLeft = true end, function() moveLeft = false end)
setupHoldButton(guiElements.RightBtn, function() moveRight = true end, function() moveRight = false end)

-- Кнопки высоты
setupHoldButton(guiElements.UpHeightBtn, function() moveUp = true end, function() moveUp = false end)
setupHoldButton(guiElements.DownHeightBtn, function() moveDown = true end, function() moveDown = false end)

-- Toggle Fly
guiElements.ToggleBtn.MouseButton1Click:Connect(toggleFly)

-- Noclip
guiElements.NoclipBtn.MouseButton1Click:Connect(function()
    toggleNoclip()
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
-- ОСНОВНОЙ ЦИКЛ ДВИЖЕНИЯ
-- ============================================

local runService = game:GetService("RunService")

runService.Heartbeat:Connect(function()
    if flying and bodyVelocity then
        local moveDir = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        local up = Vector3.new(0, 1, 0)
        
        -- Движение вперёд/назад
        if moveForward then
            moveDir = moveDir + forward
        end
        if moveBackward then
            moveDir = moveDir - forward
        end
        
        -- Движение влево/вправо
        if moveLeft then
            moveDir = moveDir - right
        end
        if moveRight then
            moveDir = moveDir + right
        end
        
        -- Движение вверх/вниз
        if moveUp then
            moveDir = moveDir + up
        end
        if moveDown then
            moveDir = moveDir - up
        end
        
        -- Применение скорости
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
print("📱 BUTTON FLY PRO LOADED!")
print("🎮 Button Controls Active")
print("========================================")
print("🎯 Use on-screen buttons to fly!")
print("⬆⬇⬅➡ - Movement")
print("⬆️⬆️ - Fly Up | ⬇️⬇️ - Fly Down")
print("⚡ Speed: " .. speed)
print("========================================")

-- Всплывающее уведомление
local function showStartupMessage()
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 350, 0, 80)
    notif.Position = UDim2.new(0.5, -175, 0.3, 0)
    notif.Text = "🎮 BUTTON CONTROLS\nACTIVATED!"
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

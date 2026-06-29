-- ============================================
-- DELTA FLY GUI v3.1 - ИСПРАВЛЕННАЯ ВЕРСИЯ
-- Кнопка FLY ON/OFF полностью рабочая
-- ============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ===== НАСТРОЙКИ =====
local CONFIG = {
    Speed = 50,
    MaxSpeed = 500,
    MinSpeed = 10,
    FlyKey = Enum.KeyCode.F,
}

-- ===== ПЕРЕМЕННЫЕ =====
local flying = false
local speed = CONFIG.Speed
local bodyVelocity = nil
local noclipEnabled = false
local gui = nil  -- Будет хранить элементы GUI

-- Состояния кнопок
local keys = {
    Forward = false,
    Backward = false,
    Left = false,
    Right = false,
    Up = false,
    Down = false
}

-- ===== ФУНКЦИИ ПОЛЁТА =====
local function createBodyVelocity()
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1, 1, 1) * 100000
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = rootPart
    return bv
end

-- ГЛАВНАЯ ФУНКЦИЯ ВКЛЮЧЕНИЯ/ВЫКЛЮЧЕНИЯ ПОЛЁТА
local function toggleFly()
    flying = not flying  -- Переключаем состояние
    
    if flying then
        -- ВКЛЮЧАЕМ ПОЛЁТ
        if bodyVelocity then 
            bodyVelocity:Destroy() 
            bodyVelocity = nil
        end
        bodyVelocity = createBodyVelocity()
        humanoid.PlatformStand = true
        humanoid.AutoRotate = true
        
        -- Обновляем GUI
        if gui and gui.ToggleBtn then
            gui.ToggleBtn.Text = "🛬 FLY ON"
            gui.ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            gui.StatusLabel.Text = "✈️ FLYING"
            gui.StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        end
        print("✈️ FLY: ON")
        
    else
        -- ВЫКЛЮЧАЕМ ПОЛЁТ
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        humanoid.PlatformStand = false
        
        -- Обновляем GUI
        if gui and gui.ToggleBtn then
            gui.ToggleBtn.Text = "🛫 FLY OFF"
            gui.ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            gui.StatusLabel.Text = "⛔ GROUNDED"
            gui.StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
        print("✈️ FLY: OFF")
    end
end

local function toggleNoclip()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        if gui and gui.NoclipBtn then
            gui.NoclipBtn.Text = "🚫 NOCLIP ON"
            gui.NoclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        end
        print("🚫 NOCLIP: ON")
    else
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        if gui and gui.NoclipBtn then
            gui.NoclipBtn.Text = "🚫 NOCLIP OFF"
            gui.NoclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end
        print("🚫 NOCLIP: OFF")
    end
end

-- ===== СОЗДАНИЕ GUI =====
local function createGUI()
    -- Удаляем старый GUI
    if player.PlayerGui:FindFirstChild("DeltaFlyGUI") then
        player.PlayerGui.DeltaFlyGUI:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeltaFlyGUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = player.PlayerGui
    
    -- Основная панель
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 20)
    mainCorner.Parent = mainFrame
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.Text = "✈️ DELTA FLY PRO"
    title.TextColor3 = Color3.fromRGB(100, 200, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = mainFrame
    
    -- Статус
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 150, 0, 25)
    statusLabel.Position = UDim2.new(1, -160, 0, 10)
    statusLabel.Text = "⛔ GROUNDED"
    statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 14
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right
    statusLabel.Parent = mainFrame
    
    -- Кнопка закрыть
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 30)
    closeBtn.Position = UDim2.new(1, -40, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    -- ===== ВЕРХНИЕ КНОПКИ =====
    -- Toggle Fly (ГЛАВНАЯ КНОПКА)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 170, 0, 40)
    toggleBtn.Position = UDim2.new(0.03, 0, 0.13, 0)
    toggleBtn.Text = "🛫 FLY OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 15
    toggleBtn.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleBtn
    
    -- Noclip
    local noclipBtn = Instance.new("TextButton")
    noclipBtn.Size = UDim2.new(0, 160, 0, 40)
    noclipBtn.Position = UDim2.new(0.5, 0, 0.13, 0)
    noclipBtn.Text = "🚫 NOCLIP OFF"
    noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noclipBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    noclipBtn.Font = Enum.Font.GothamBold
    noclipBtn.TextSize = 13
    noclipBtn.Parent = mainFrame
    
    local noclipCorner = Instance.new("UICorner")
    noclipCorner.CornerRadius = UDim.new(0, 10)
    noclipCorner.Parent = noclipBtn
    
    -- ===== КНОПКИ ДВИЖЕНИЯ =====
    local btnSize = 55
    local spacing = 8
    local startX = 0.08
    local startY = 0.30
    
    local function createMoveBtn(text, x, y, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, btnSize, 0, btnSize)
        btn.Position = UDim2.new(x, 0, y, 0)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.15
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 26
        btn.Parent = mainFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 12)
        corner.Parent = btn
        
        return btn
    end
    
    -- Сетка 3x3
    local upBtn = createMoveBtn("⬆", startX + (btnSize + spacing) * 1 / 400, startY, Color3.fromRGB(0, 150, 255))
    local leftBtn = createMoveBtn("⬅", startX + (btnSize + spacing) * 0 / 400, startY + (btnSize + spacing) / 400, Color3.fromRGB(255, 150, 0))
    local centerBtn = createMoveBtn("●", startX + (btnSize + spacing) * 1 / 400, startY + (btnSize + spacing) / 400, Color3.fromRGB(50, 50, 50))
    centerBtn.BackgroundTransparency = 0.8
    centerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    centerBtn.TextSize = 14
    local rightBtn = createMoveBtn("➡", startX + (btnSize + spacing) * 2 / 400, startY + (btnSize + spacing) / 400, Color3.fromRGB(255, 150, 0))
    local downBtn = createMoveBtn("⬇", startX + (btnSize + spacing) * 1 / 400, startY + (btnSize + spacing) * 2 / 400, Color3.fromRGB(255, 150, 0))
    
    -- ===== КНОПКИ ВЫСОТЫ =====
    local upHeightBtn = Instance.new("TextButton")
    upHeightBtn.Size = UDim2.new(0, 65, 0, 65)
    upHeightBtn.Position = UDim2.new(0.78, 0, 0.30, 0)
    upHeightBtn.Text = "⬆⬆"
    upHeightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    upHeightBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    upHeightBtn.BackgroundTransparency = 0.15
    upHeightBtn.Font = Enum.Font.GothamBold
    upHeightBtn.TextSize = 22
    upHeightBtn.Parent = mainFrame
    
    local upHeightCorner = Instance.new("UICorner")
    upHeightCorner.CornerRadius = UDim.new(0, 12)
    upHeightCorner.Parent = upHeightBtn
    
    local downHeightBtn = Instance.new("TextButton")
    downHeightBtn.Size = UDim2.new(0, 65, 0, 65)
    downHeightBtn.Position = UDim2.new(0.89, 0, 0.30, 0)
    downHeightBtn.Text = "⬇⬇"
    downHeightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    downHeightBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    downHeightBtn.BackgroundTransparency = 0.15
    downHeightBtn.Font = Enum.Font.GothamBold
    downHeightBtn.TextSize = 22
    downHeightBtn.Parent = mainFrame
    
    local downHeightCorner = Instance.new("UICorner")
    downHeightCorner.CornerRadius = UDim.new(0, 12)
    downHeightCorner.Parent = downHeightBtn
    
    -- ===== УПРАВЛЕНИЕ СКОРОСТЬЮ =====
    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(0, 300, 0, 40)
    speedFrame.Position = UDim2.new(0.5, -150, 0.88, 0)
    speedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
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
    speedMinus.Size = UDim2.new(0, 40, 0, 32)
    speedMinus.Position = UDim2.new(0.02, 0, 0.1, 0)
    speedMinus.Text = "−"
    speedMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedMinus.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    speedMinus.Font = Enum.Font.GothamBold
    speedMinus.TextSize = 22
    speedMinus.Parent = speedFrame
    
    local minusCorner = Instance.new("UICorner")
    minusCorner.CornerRadius = UDim.new(0, 8)
    minusCorner.Parent = speedMinus
    
    local speedPlus = Instance.new("TextButton")
    speedPlus.Size = UDim2.new(0, 40, 0, 32)
    speedPlus.Position = UDim2.new(0.85, 0, 0.1, 0)
    speedPlus.Text = "+"
    speedPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedPlus.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    speedPlus.Font = Enum.Font.GothamBold
    speedPlus.TextSize = 22
    speedPlus.Parent = speedFrame
    
    local plusCorner = Instance.new("UICorner")
    plusCorner.CornerRadius = UDim.new(0, 8)
    plusCorner.Parent = speedPlus
    
    -- Перетаскивание GUI
    local dragging = false
    local dragStart = nil
    local dragOffset = nil
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            dragOffset = Vector2.new(mainFrame.Position.X.Offset, mainFrame.Position.Y.Offset)
        end
    end)
    
    mainFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            local newX = math.clamp(dragOffset.X + delta.X, -300, 300)
            local newY = math.clamp(dragOffset.Y + delta.Y, -400, 400)
            mainFrame.Position = UDim2.new(0.5, newX, 0.5, newY)
        end
    end)
    
    mainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
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

-- ===== СОЗДАЁМ GUI =====
gui = createGUI()

-- ===== НАСТРАИВАЕМ ОБРАБОТЧИКИ =====

-- Функция для обработки удержания кнопок
local function setupHold(button, onDown, onUp)
    local holding = false
    local connection = nil
    
    local function startHold()
        holding = true
        onDown()
        
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if holding then
                onDown()
            end
        end)
    end
    
    local function stopHold()
        holding = false
        if connection then
            connection:Disconnect()
            connection = nil
        end
        if onUp then onUp() end
    end
    
    button.MouseButton1Down:Connect(startHold)
    button.MouseButton1Up:Connect(stopHold)
    button.MouseLeave:Connect(stopHold)
    
    -- Для сенсорного экрана
    button.TouchBegan:Connect(function()
        startHold()
    end)
    
    button.TouchEnded:Connect(function()
        stopHold()
    end)
end

-- Настройка кнопок движения
setupHold(gui.UpBtn, function() keys.Forward = true end, function() keys.Forward = false end)
setupHold(gui.DownBtn, function() keys.Backward = true end, function() keys.Backward = false end)
setupHold(gui.LeftBtn, function() keys.Left = true end, function() keys.Left = false end)
setupHold(gui.RightBtn, function() keys.Right = true end, function() keys.Right = false end)
setupHold(gui.UpHeightBtn, function() keys.Up = true end, function() keys.Up = false end)
setupHold(gui.DownHeightBtn, function() keys.Down = true end, function() keys.Down = false end)

-- ===== ГЛАВНАЯ КНОПКА FLY ON/OFF =====
-- Используем MouseButton1Click для надёжности
gui.ToggleBtn.MouseButton1Click:Connect(function()
    toggleFly()
end)

-- Дополнительно для сенсорного экрана
gui.ToggleBtn.TouchTap:Connect(function()
    toggleFly()
end)

-- ===== КНОПКА NOCLIP =====
gui.NoclipBtn.MouseButton1Click:Connect(function()
    toggleNoclip()
end)

gui.NoclipBtn.TouchTap:Connect(function()
    toggleNoclip()
end)

-- ===== УПРАВЛЕНИЕ СКОРОСТЬЮ =====
local function updateSpeed()
    if gui and gui.SpeedLabel then
        gui.SpeedLabel.Text = "⚡ " .. speed
    end
end

gui.SpeedPlus.MouseButton1Click:Connect(function()
    speed = math.min(speed + 10, CONFIG.MaxSpeed)
    updateSpeed()
end)

gui.SpeedMinus.MouseButton1Click:Connect(function()
    speed = math.max(speed - 10, CONFIG.MinSpeed)
    updateSpeed()
end)

-- Удержание для скорости
local function holdSpeed(button, increase)
    local holding = false
    button.MouseButton1Down:Connect(function()
        holding = true
        while holding do
            if increase then
                speed = math.min(speed + 10, CONFIG.MaxSpeed)
            else
                speed = math.max(speed - 10, CONFIG.MinSpeed)
            end
            updateSpeed()
            wait(0.08)
        end
    end)
    button.MouseButton1Up:Connect(function() holding = false end)
    button.MouseLeave:Connect(function() holding = false end)
end

holdSpeed(gui.SpeedPlus, true)
holdSpeed(gui.SpeedMinus, false)

-- ===== ЗАКРЫТЬ GUI =====
gui.CloseBtn.MouseButton1Click:Connect(function()
    if flying then toggleFly() end
    if noclipEnabled then toggleNoclip() end
    gui.ScreenGui:Destroy()
end)

-- ===== ОСНОВНОЙ ЦИКЛ ДВИЖЕНИЯ =====
local runService = game:GetService("RunService")

runService.Heartbeat:Connect(function()
    if flying and bodyVelocity then
        local moveDir = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        local up = Vector3.new(0, 1, 0)
        
        if keys.Forward then moveDir = moveDir + forward end
        if keys.Backward then moveDir = moveDir - forward end
        if keys.Left then moveDir = moveDir - right end
        if keys.Right then moveDir = moveDir + right end
        if keys.Up then moveDir = moveDir + up end
        if keys.Down then moveDir = moveDir - up end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * speed
            bodyVelocity.Velocity = moveDir
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- ===== БЫСТРОЕ ВКЛЮЧЕНИЕ ПО КЛАВИШЕ F =====
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == CONFIG.FlyKey then
        toggleFly()
    end
end)

-- ===== ОБНОВЛЕНИЕ ПРИ ПЕРЕРОЖДЕНИИ =====
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

-- ===== КОМАНДЫ ДЛЯ КОНСОЛИ =====
_G.DeltaFly = {
    Toggle = toggleFly,
    SetSpeed = function(s)
        speed = math.clamp(s, CONFIG.MinSpeed, CONFIG.MaxSpeed)
        updateSpeed()
        print("⚡ Speed: " .. speed)
    end,
    GetSpeed = function() return speed end,
    IsFlying = function() return flying end,
    ToggleNoclip = toggleNoclip,
    Destroy = function()
        if flying then toggleFly() end
        if noclipEnabled then toggleNoclip() end
        if gui and gui.ScreenGui then
            gui.ScreenGui:Destroy()
        end
    end
}

-- ===== ПРИВЕТСТВИЕ =====
print("")
print("╔════════════════════════════════════════╗")
print("║  ✈️  DELTA FLY PRO v3.1               ║")
print("║  📱 Fixed: Fly Button Working!       ║")
print("╠════════════════════════════════════════╣")
print("║  🎮 Controls:                         ║")
print("║  ⬆ ⬇ ⬅ ➡  - Movement                ║")
print("║  ⬆⬆ / ⬇⬇  - Up / Down              ║")
print("║  🟢 FLY ON - Start flying            ║")
print("║  🔴 FLY OFF - Stop flying            ║")
print("║  📌 Press F to toggle flight          ║")
print("║  ⚡ Speed: " .. speed .. "                         ║")
print("╚════════════════════════════════════════╝")
print("")

-- Уведомление
local function showNotification()
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 300, 0, 60)
    notif.Position = UDim2.new(0.5, -150, 0.2, 0)
    notif.Text = "🎮 FLY CONTROLS READY!"
    notif.TextColor3 = Color3.fromRGB(0, 255, 200)
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.4
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 20
    notif.Parent = gui.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = notif
    
    notif.BackgroundTransparency = 1
    notif.TextTransparency = 1
    for i = 1, 15 do
        wait(0.02)
        notif.BackgroundTransparency = 1 - (i / 15) * 0.6
        notif.TextTransparency = 1 - (i / 15)
    end
    
    wait(1.5)
    
    for i = 1, 15 do
        wait(0.02)
        notif.BackgroundTransparency = 0.4 + (i / 15) * 0.6
        notif.TextTransparency = (i / 15)
    end
    
    notif:Destroy()
end

coroutine.wrap(showNotification)()

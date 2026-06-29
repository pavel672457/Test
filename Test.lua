-- Fly GUI для мобильных инжекторов (Arceus X, Hydrogen, Delta и др.)
-- Работает с сенсорным управлением

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50
local bodyVelocity = nil

-- Создание GUI
local function createFlyGUI()
    -- Главный экран
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FlyGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player.PlayerGui
    
    -- Основная панель (внизу экрана)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 360, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -180, 1, -220)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BackgroundTransparency = 0.2
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Сглаживание углов
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 5)
    title.Text = "✈️ FLIGHT CONTROL"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = mainFrame
    
    -- Кнопка Toggle Fly (большая)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 160, 0, 60)
    toggleBtn.Position = UDim2.new(0.5, -80, 0.3, 0)
    toggleBtn.Text = "🛫 FLY OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 16
    toggleBtn.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = toggleBtn
    
    -- Кнопка увеличения скорости
    local speedUp = Instance.new("TextButton")
    speedUp.Size = UDim2.new(0, 70, 0, 40)
    speedUp.Position = UDim2.new(0.05, 0, 0.7, 0)
    speedUp.Text = "⬆️"
    speedUp.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedUp.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    speedUp.Font = Enum.Font.GothamBold
    speedUp.TextSize = 20
    speedUp.Parent = mainFrame
    
    local speedUpCorner = Instance.new("UICorner")
    speedUpCorner.CornerRadius = UDim.new(0, 8)
    speedUpCorner.Parent = speedUp
    
    -- Кнопка уменьшения скорости
    local speedDown = Instance.new("TextButton")
    speedDown.Size = UDim2.new(0, 70, 0, 40)
    speedDown.Position = UDim2.new(0.35, 0, 0.7, 0)
    speedDown.Text = "⬇️"
    speedDown.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedDown.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    speedDown.Font = Enum.Font.GothamBold
    speedDown.TextSize = 20
    speedDown.Parent = mainFrame
    
    local speedDownCorner = Instance.new("UICorner")
    speedDownCorner.CornerRadius = UDim.new(0, 8)
    speedDownCorner.Parent = speedDown
    
    -- Индикатор скорости
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 100, 0, 40)
    speedLabel.Position = UDim2.new(0.6, 0, 0.7, 0)
    speedLabel.Text = "⚡ 50"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
    speedLabel.BackgroundTransparency = 0.5
    speedLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 16
    speedLabel.Parent = mainFrame
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 8)
    speedCorner.Parent = speedLabel
    
    -- Кнопка закрыть GUI
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn
    
    -- Кнопка переключения режима (для будущих функций)
    local modeBtn = Instance.new("TextButton")
    modeBtn.Size = UDim2.new(0, 40, 0, 40)
    modeBtn.Position = UDim2.new(1, -80, 0.3, 0)
    modeBtn.Text = "⚙️"
    modeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    modeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    modeBtn.Font = Enum.Font.GothamBold
    modeBtn.TextSize = 20
    modeBtn.Parent = mainFrame
    
    local modeCorner = Instance.new("UICorner")
    modeCorner.CornerRadius = UDim.new(0, 8)
    modeCorner.Parent = modeBtn
    
    -- Возвращаем все элементы для управления
    return {
        ToggleBtn = toggleBtn,
        SpeedUp = speedUp,
        SpeedDown = speedDown,
        SpeedLabel = speedLabel,
        CloseBtn = closeBtn,
        ModeBtn = modeBtn,
        MainFrame = mainFrame,
        ScreenGui = screenGui
    }
end

-- Функции управления полётом
local function toggleFly()
    flying = not flying
    
    if flying then
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        humanoid.PlatformStand = true
        humanoid.AutoRotate = true
        guiElements.ToggleBtn.Text = "🛬 FLY ON"
        guiElements.ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        print("✈️ Fly: ON")
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        humanoid.PlatformStand = false
        guiElements.ToggleBtn.Text = "🛫 FLY OFF"
        guiElements.ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        print("✈️ Fly: OFF")
    end
end

-- Создаём GUI
local guiElements = createFlyGUI()

-- Обновление индикатора скорости
local function updateSpeedLabel()
    guiElements.SpeedLabel.Text = "⚡ " .. speed
end

-- Обработчики нажатий (мобильные)
guiElements.ToggleBtn.MouseButton1Click:Connect(toggleFly)

guiElements.SpeedUp.MouseButton1Click:Connect(function()
    speed = math.min(speed + 10, 500)
    updateSpeedLabel()
end)

guiElements.SpeedDown.MouseButton1Click:Connect(function()
    speed = math.max(speed - 10, 10)
    updateSpeedLabel()
end)

guiElements.CloseBtn.MouseButton1Click:Connect(function()
    guiElements.ScreenGui:Destroy()
    if flying then toggleFly() end
    print("GUI Closed")
end)

-- Долгое нажатие для быстрого изменения скорости
local function holdSpeedButton(button, increase)
    local holding = true
    local timer = 0
    
    button.MouseButton1Down:Connect(function()
        holding = true
        timer = tick()
        
        -- Быстрое изменение при удержании
        while holding and timer + 0.1 < tick() do
            if increase then
                speed = math.min(speed + 10, 500)
            else
                speed = math.max(speed - 10, 10)
            end
            updateSpeedLabel()
            timer = tick()
            wait(0.05)
        end
    end)
    
    button.MouseButton1Up:Connect(function()
        holding = false
    end)
end

holdSpeedButton(guiElements.SpeedUp, true)
holdSpeedButton(guiElements.SpeedDown, false)

-- Сенсорные джойстики (опционально)
local function createJoystick()
    -- Левая половина экрана для движения
    local leftJoystick = Instance.new("Frame")
    leftJoystick.Size = UDim2.new(0.5, 0, 0.5, 0)
    leftJoystick.Position = UDim2.new(0, 0, 0.5, 0)
    leftJoystick.BackgroundTransparency = 1
    leftJoystick.Parent = guiElements.ScreenGui
    
    -- Правая половина для поворота (можно добавить)
end

-- Основной цикл движения (мобильная оптимизация)
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

runService.Heartbeat:Connect(function()
    if flying and bodyVelocity then
        local moveDir = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        local up = Vector3.new(0, 1, 0)
        
        -- Сенсорное управление (для мобильных)
        -- Кнопки на экране для движения (можно добавить)
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
        
        -- Также можно добавить сенсорные кнопки для подъёма/спуска
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * speed
            bodyVelocity.Velocity = moveDir
        else
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)

-- Обновление при перерождении
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    if flying then
        wait(0.1)
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 100000
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        humanoid.PlatformStand = true
    end
end)

-- Функция для консоли (для отладки)
_G.MobileFly = {
    Toggle = toggleFly,
    SetSpeed = function(newSpeed)
        speed = math.clamp(newSpeed, 10, 500)
        updateSpeedLabel()
        print("Speed: " .. speed)
    end,
    GetSpeed = function()
        return speed
    end,
    IsFlying = function()
        return flying
    end
}

print("📱 Mobile Fly GUI Loaded!")
print("🟢 Speed: " .. speed .. " | Press Toggle to fly")

-- Уведомление при запуске
local function showStartupNotification()
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 300, 0, 50)
    notif.Position = UDim2.new(0.5, -150, 0.2, 0)
    notif.Text = "✈️ FLY GUI ACTIVATED"
    notif.TextColor3 = Color3.fromRGB(0, 255, 0)
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.5
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 20
    notif.Parent = guiElements.ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notif
    
    game:GetService("Debris"):AddItem(notif, 2)
end

showStartupNotification()

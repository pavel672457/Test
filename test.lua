-- Fly Script для Roblox Executor (Synapse X, Krnl, ScriptWare и др.)
-- Работает через локальный скрипт

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50
local flySpeed = 50
local bodyVelocity = nil

-- Функция создания BodyVelocity
local function createBodyVelocity()
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1, 1, 1) * 100000
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = rootPart
    return bv
end

-- Включение/выключение полёта
local function toggleFly()
    flying = not flying
    
    if flying then
        if bodyVelocity then bodyVelocity:Destroy() end
        bodyVelocity = createBodyVelocity()
        humanoid.PlatformStand = true
        humanoid.AutoRotate = true
        print("✈️ Fly: ON")
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        humanoid.PlatformStand = false
        print("✈️ Fly: OFF")
    end
end

-- Управление клавишами
local function onKeyPress(key)
    if key == "F" then
        toggleFly()
    end
end

-- Подписка на события ввода
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleFly()
    end
end)

-- Основной цикл движения
game:GetService("RunService").Heartbeat:Connect(function()
    if flying and bodyVelocity then
        local moveDir = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        local forward = camera.CFrame.LookVector
        local right = camera.CFrame.RightVector
        local up = Vector3.new(0, 1, 0)
        
        -- Обработка клавиш
        local uis = game:GetService("UserInputService")
        
        if uis:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + forward
        end
        if uis:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - forward
        end
        if uis:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - right
        end
        if uis:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + right
        end
        if uis:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + up
        end
        if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - up
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

-- Обновление при перерождении
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
end)

-- GUI уведомление о состоянии
local function createNotification(text, color)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 30)
    frame.Position = UDim2.new(0.5, -100, 0.2, 0)
    frame.BackgroundColor3 = color or Color3.fromRGB(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.Parent = screenGui
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.Parent = frame
    
    game:GetService("Debris"):AddItem(screenGui, 2)
end

-- Копирайт и управление
print("✈️ Fly Script Loaded!")
print("📌 Press [F] to toggle flight")
print("🎮 WASD - Move | Space - Up | Shift - Down")

-- Горячие клавиши для удобства
local function setupHotkeys()
    -- Изменение скорости (цифры 1-9)
    local speedKeys = {
        [Enum.KeyCode.One] = 10,
        [Enum.KeyCode.Two] = 25,
        [Enum.KeyCode.Three] = 50,
        [Enum.KeyCode.Four] = 75,
        [Enum.KeyCode.Five] = 100,
        [Enum.KeyCode.Six] = 150,
        [Enum.KeyCode.Seven] = 200,
        [Enum.KeyCode.Eight] = 300,
        [Enum.KeyCode.Nine] = 500,
    }
    
    game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        local newSpeed = speedKeys[input.KeyCode]
        if newSpeed then
            speed = newSpeed
            createNotification("⚡ Speed: " .. speed, Color3.fromRGB(0, 255, 0))
        end
        
        -- Сброс скорости (0)
        if input.KeyCode == Enum.KeyCode.Zero then
            speed = 50
            createNotification("⚡ Speed reset to 50", Color3.fromRGB(255, 255, 0))
        end
    end)
end

setupHotkeys()

-- Функция для использования в консоли
_G.Fly = {
    Toggle = toggleFly,
    SetSpeed = function(newSpeed)
        speed = newSpeed
        print("Speed set to: " .. speed)
    end,
    GetSpeed = function()
        return speed
    end,
    IsFlying = function()
        return flying
    end
}

print("✅ Type _G.Fly:Toggle() to toggle flight")

-- Инфинити джамп для Delta Injector (МОБИЛЬНАЯ ВЕРСИЯ)
-- Используйте кнопку на экране или нажмите на джойстик

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local jumpEnabled = false
local jumpButton = nil

-- Создание GUI кнопки для телефона
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 60)
button.Position = UDim2.new(0.85, -75, 0.85, -30) -- Правый нижний угол
button.Text = "ИНФИНИТИ ДЖАМП"
button.TextColor3 = Color3.new(1, 1, 1)
button.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
button.BorderSizePixel = 0
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = screenGui

-- Круглая кнопка для джойстика
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = button

-- Функция прыжка
local function infiniteJump()
    while jumpEnabled and humanoid and humanoid.Parent do
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        wait(0.15) -- Задержка для мобильных устройств
    end
end

-- Обработчик нажатия на кнопку
button.MouseButton1Click:Connect(function()
    jumpEnabled = not jumpEnabled
    if jumpEnabled then
        button.Text = "✅ ДЖАМП ВКЛ"
        button.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
        print("Инфинити джамп ВКЛЮЧЕН (Мобильный)")
        spawn(infiniteJump)
    else
        button.Text = "ИНФИНИТИ ДЖАМП"
        button.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
        print("Инфинити джамп ВЫКЛЮЧЕН (Мобильный)")
    end
end)

-- Обработчик касания для телефона
button.TouchTap:Connect(function()
    jumpEnabled = not jumpEnabled
    if jumpEnabled then
        button.Text = "✅ ДЖАМП ВКЛ"
        button.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
        print("Инфинити джамп ВКЛЮЧЕН (Мобильный)")
        spawn(infiniteJump)
    else
        button.Text = "ИНФИНИТИ ДЖАМП"
        button.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
        print("Инфинити джамп ВЫКЛЮЧЕН (Мобильный)")
    end
end)

-- Обновление персонажа при респавне
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    if jumpEnabled then
        spawn(infiniteJump)
    end
end)

-- Альтернативный вариант: активация через двойной тап по экрану
local tapCount = 0
local tapTimer = nil

game:GetService("UserInputService").TouchTap:Connect(function()
    if tapTimer then
        tapTimer:Disconnect()
        tapTimer = nil
    end
    
    tapCount = tapCount + 1
    
    if tapCount >= 2 then
        tapCount = 0
        -- Двойной тап включает/выключает джамп
        jumpEnabled = not jumpEnabled
        if jumpEnabled then
            button.Text = "✅ ДЖАМП ВКЛ"
            button.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
            spawn(infiniteJump)
        else
            button.Text = "ИНФИНИТИ ДЖАМП"
            button.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
        end
    else
        tapTimer = game:GetService("Debris"):AddItem(Instance.new("Part"), 0.3)
        tapTimer.Destroying:Connect(function()
            tapCount = 0
        end)
    end
end)

print("Скрипт загружен! Нажми на кнопку на экране или сделай двойной тап")

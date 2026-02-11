-- Gonzo Lagger LocalScript
-- Pune in StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local remote = ReplicatedStorage:WaitForChild("ping")

local running = false
local intensity = 10

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GonzoLaggerGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 220)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
mainFrame.Name = "Gonzo Lagger"

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "Gonzo Lagger"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = mainFrame

-- MINIMIZE BUTTON
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0,30,0,30)
minimize.Position = UDim2.new(1,-35,0,5)
minimize.Text = "-"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 22
minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
minimize.TextColor3 = Color3.fromRGB(255,255,255)
minimize.Parent = mainFrame
Instance.new("UICorner", minimize).CornerRadius = UDim.new(1,0)

-- SLIDER BACK
local sliderBack = Instance.new("Frame")
sliderBack.Size = UDim2.new(0.8,0,0,15)
sliderBack.Position = UDim2.new(0.1,0,0.4,0)
sliderBack.BackgroundColor3 = Color3.fromRGB(50,50,50)
sliderBack.Parent = mainFrame
Instance.new("UICorner", sliderBack).CornerRadius = UDim.new(1,0)

-- SLIDER BAR
local sliderBar = Instance.new("Frame")
sliderBar.Size = UDim2.new(0.2,0,1,0)
sliderBar.BackgroundColor3 = Color3.fromRGB(0,170,255)
sliderBar.Parent = sliderBack
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1,0)

-- INTENSITY LABEL
local intensityLabel = Instance.new("TextLabel")
intensityLabel.Size = UDim2.new(1,0,0,25)
intensityLabel.Position = UDim2.new(0,0,0.5,0)
intensityLabel.BackgroundTransparency = 1
intensityLabel.Text = "Intensity: 10"
intensityLabel.Font = Enum.Font.Gotham
intensityLabel.TextSize = 16
intensityLabel.TextColor3 = Color3.new(1,1,1)
intensityLabel.Parent = mainFrame

-- START BUTTON
local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(0.5,0,0,40)
startButton.Position = UDim2.new(0.25,0,0.7,0)
startButton.Text = "START"
startButton.Font = Enum.Font.GothamBold
startButton.TextSize = 18
startButton.BackgroundColor3 = Color3.fromRGB(0,170,0)
startButton.TextColor3 = Color3.new(1,1,1)
startButton.Parent = mainFrame
Instance.new("UICorner", startButton).CornerRadius = UDim.new(0,10)

-- RESIZE HANDLE
local resize = Instance.new("Frame")
resize.Size = UDim2.new(0,20,0,20)
resize.Position = UDim2.new(1,-20,1,-20)
resize.BackgroundColor3 = Color3.fromRGB(80,80,80)
resize.Parent = mainFrame

local resizing = false

resize.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = true
	end
end)

resize.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
		mainFrame.Size = UDim2.new(0,
			math.clamp(input.Position.X - mainFrame.AbsolutePosition.X,200,600),
			0,
			math.clamp(input.Position.Y - mainFrame.AbsolutePosition.Y,150,400)
		)
	end
end)

-- SLIDER FUNCTION
sliderBack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local relative = (input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X
		relative = math.clamp(relative,0,1)
		sliderBar.Size = UDim2.new(relative,0,1,0)
		intensity = math.floor(relative * 100)
		intensityLabel.Text = "Intensity: "..intensity
	end
end)

-- START FUNCTION
startButton.MouseButton1Click:Connect(function()
	running = not running
	
	if running then
		startButton.Text = "STOP"
		startButton.BackgroundColor3 = Color3.fromRGB(170,0,0)
		
		task.spawn(function()
			while running do
				for i = 1, intensity do
					remote:FireServer()
				end
				task.wait(0.1)
			end
		end)
	else
		startButton.Text = "START"
		startButton.BackgroundColor3 = Color3.fromRGB(0,170,0)
	end
end)

-- MINIMIZED BUTTON
local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(0,60,0,60)
miniButton.Position = UDim2.new(0.5,-30,0.5,-30)
miniButton.Text = "G"
miniButton.Visible = false
miniButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
miniButton.TextColor3 = Color3.new(1,1,1)
miniButton.Font = Enum.Font.GothamBold
miniButton.TextSize = 30
miniButton.Parent = screenGui
miniButton.Active = true
miniButton.Draggable = true
Instance.new("UICorner", miniButton).CornerRadius = UDim.new(1,0)

minimize.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	miniButton.Visible = true
end)

miniButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = true
	miniButton.Visible = false
end)

local heavenHub = Instance.new("ScreenGui")
heavenHub.Name = "HeavenHub"
heavenHub.Parent = game.Players.LocalPlayer.PlayerGui
heavenHub.Enabled = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = heavenHub

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

local mainTab = Instance.new("TextButton")
mainTab.Size = UDim2.new(0.5, 0, 0, 30)
mainTab.Position = UDim2.new(0, 0, 0, 0)
mainTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainTab.BorderSizePixel = 0
mainTab.Text = "Main"
mainTab.TextColor3 = Color3.fromRGB(200, 200, 200)
mainTab.Font = Enum.Font.SourceSansBold
mainTab.Parent = mainFrame

local creditsTab = Instance.new("TextButton")
creditsTab.Size = UDim2.new(0.5, 0, 0, 30)
creditsTab.Position = UDim2.new(0.5, 0, 0, 0)
creditsTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
creditsTab.BorderSizePixel = 0
creditsTab.Text = "Credits"
creditsTab.TextColor3 = Color3.fromRGB(150, 150, 150)
creditsTab.Font = Enum.Font.SourceSansBold
creditsTab.Parent = mainFrame

local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
contentFrame.BorderSizePixel = 0
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 500)
contentFrame.ScrollBarThickness = 5
contentFrame.Parent = mainFrame

local espSettings = {
  box = true,
  outline = false,
  chams = false,
  direction = false,
  name = true,
}

local espPreview = Instance.new("Frame")
espPreview.Size = UDim2.new(0, 100, 0, 100)
espPreview.Position = UDim2.new(0, 10, 0, 10)
espPreview.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espPreview.BorderSizePixel = 0
espPreview.Parent = contentFrame

local boxToggle = Instance.new("TextButton")
boxToggle.Size = UDim2.new(1, -20, 0, 30)
boxToggle.Position = UDim2.new(0, 10, 0, 120)
boxToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
boxToggle.BorderSizePixel = 0
boxToggle.Text = "Box: On"
boxToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
boxToggle.Font = Enum.Font.SourceSansBold
boxToggle.Parent = contentFrame
boxToggle.MouseButton1Click:Connect(function()
  espSettings.box = not espSettings.box
  boxToggle.Text = "Box: " .. (espSettings.box and "On" or "Off")
end)

local outlineToggle = Instance.new("TextButton")
outlineToggle.Size = UDim2.new(1, -20, 0, 30)
outlineToggle.Position = UDim2.new(0, 10, 0, 150)
outlineToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
outlineToggle.BorderSizePixel = 0
outlineToggle.Text = "Outline: Off"
outlineToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
outlineToggle.Font = Enum.Font.SourceSansBold
outlineToggle.Parent = contentFrame
outlineToggle.MouseButton1Click:Connect(function()
  espSettings.outline = not espSettings.outline
  outlineToggle.Text = "Outline: " .. (espSettings.outline and "On" or "Off")
end)

local chamsToggle = Instance.new("TextButton")
chamsToggle.Size = UDim2.new(1, -20, 0, 30)
chamsToggle.Position = UDim2.new(0, 10, 0, 180)
chamsToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
chamsToggle.BorderSizePixel = 0
chamsToggle.Text = "Chams: Off"
chamsToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
chamsToggle.Font = Enum.Font.SourceSansBold
chamsToggle.Parent = contentFrame
chamsToggle.MouseButton1Click:Connect(function()
  espSettings.chams = not espSettings.chams
  chamsToggle.Text = "Chams: " .. (espSettings.chams and "On" or "Off")
end)

local directionToggle = Instance.new("TextButton")
directionToggle.Size = UDim2.new(1, -20, 0, 30)
directionToggle.Position = UDim2.new(0, 10, 0, 210)
directionToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
directionToggle.BorderSizePixel = 0
directionToggle.Text = "Direction: Off"
directionToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
directionToggle.Font = Enum.Font.SourceSansBold
directionToggle.Parent = contentFrame
directionToggle.MouseButton1Click:Connect(function()
  espSettings.direction = not espSettings.direction
  directionToggle.Text = "Direction: " .. (espSettings.direction and "On" or "Off")
end)

local nameToggle = Instance.new("TextButton")
nameToggle.Size = UDim2.new(1, -20, 0, 30)
nameToggle.Position = UDim2.new(0, 10, 0, 240)
nameToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
nameToggle.BorderSizePixel = 0
nameToggle.Text = "Name: On"
nameToggle.TextColor3 = Color3.fromRGB(220, 220, 220)
nameToggle.Font = Enum.Font.SourceSansBold
nameToggle.Parent = contentFrame
nameToggle.MouseButton1Click:Connect(function()
  espSettings.name = not espSettings.name
  nameToggle.Text = "Name: " .. (espSettings.name and "On" or "Off")
end)

local function createESP(player)
  local character = player.Character
  if character then
    local head = character:FindFirstChild("Head")
    if head then
      local esp = Instance.new("BillboardGui")
      esp.Size = UDim2.new(0, 50, 0, 20)
      esp.Adornee = head
      esp.AlwaysOnTop = true
      esp.Parent = head

      local textLabel = Instance.new("TextLabel")
      textLabel.Size = UDim2.new(1, 0, 1, 0)
      textLabel.BackgroundTransparency = 1
      textLabel.Text = espSettings.name and player.Name or ""
      textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
      textLabel.Parent = esp

      if espSettings.box then
        local box = Instance.new("BoxHandleAd

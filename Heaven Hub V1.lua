local UILib = loadstring(game:HttpGet('https://raw.githubusercontent.com/StepBroFurious/Script/main/HydraHubUi.lua'))()
local Window = UILib.new("HeavenHub", nil, "User")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESP = {
    Enabled = false,
    Boxes = false,
    Names = false,
    Distance = false,
    Tracers = false,
    Outline = false,
    Chams = false,
    Color = Color3.fromRGB(255, 0, 0),
    Objects = {}
}

local Cheats = {
    Speed = 16,
    Jump = 50,
    FlyEnabled = false,
    Noclip = false,
    InfJump = false,
    ClickTP = false
}

local Category = Window:Category("ESP", "rbxassetid://8395621517")
local SubButton = Category:Button("Visuals", "rbxassetid://8395747586")
local Section = SubButton:Section("Controls", "Left")

local function CreateDrawing(type, properties)
    local drawing = Drawing.new(type)
    for prop, value in pairs(properties or {}) do
        drawing[prop] = value
    end
    return drawing
end

local function CreateESP(player)
    if player == LocalPlayer or not player.Character then return end
    
    local char = player.Character
    local root = char:WaitForChild("HumanoidRootPart")
    local head = char:WaitForChild("Head")
    
    local espObj = {
        Box = CreateDrawing("Square", {Thickness = 1, Visible = false, Color = ESP.Color}),
        BoxOutline = CreateDrawing("Square", {Thickness = 3, Visible = false, Color = Color3.fromRGB(0, 0, 0)}),
        Name = CreateDrawing("Text", {Size = 14, Center = true, Visible = false, Color = ESP.Color, Text = player.Name}),
        Distance = CreateDrawing("Text", {Size = 12, Center = true, Visible = false, Color = ESP.Color}),
        Tracer = CreateDrawing("Line", {Thickness = 1, Visible = false, Color = ESP.Color, From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)}),
        Chams = Instance.new("Highlight")
    }
    
    espObj.Chams.FillColor = ESP.Color
    espObj.Chams.OutlineColor = Color3.fromRGB(0, 0, 0)
    espObj.Chams.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    espObj.Chams.Parent = char
    
    ESP.Objects[player] = espObj
end

local function UpdateESP()
    if not ESP.Enabled then
        for _, espObj in pairs(ESP.Objects) do
            for _, drawing in pairs(espObj) do
                if drawing:IsA("Drawing") then drawing.Visible = false end
                if drawing:IsA("Highlight") then drawing.Enabled = false end
            end
        end
        return
    end

    for player, espObj in pairs(ESP.Objects) do
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
            local root = char.HumanoidRootPart
            local head = char.Head
            local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and (root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) or 0
            
            if onScreen then
                local headPos = Camera:WorldToViewportPoint(head.Position)
                local size = (Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0)).Y - headPos.Y) * 2
                
                if ESP.Boxes then
                    espObj.Box.Size = Vector2.new(size * 0.6, size)
                    espObj.Box.Position = Vector2.new(rootPos.X - espObj.Box.Size.X/2, rootPos.Y - espObj.Box.Size.Y/2)
                    espObj.Box.Visible = true
                    espObj.Box.Color = ESP.Color
                else
                    espObj.Box.Visible = false
                end
                
                if ESP.Outline and ESP.Boxes then
                    espObj.BoxOutline.Size = espObj.Box.Size + Vector2.new(4, 4)
                    espObj.BoxOutline.Position = espObj.Box.Position - Vector2.new(2, 2)
                    espObj.BoxOutline.Visible = true
                else
                    espObj.BoxOutline.Visible = false
                end
                
                if ESP.Names then
                    espObj.Name.Position = Vector2.new(rootPos.X, rootPos.Y - size/2 - 15)
                    espObj.Name.Visible = true
                    espObj.Name.Color = ESP.Color
                else
                    espObj.Name.Visible = false
                end
                
                if ESP.Distance then
                    espObj.Distance.Text = math.floor(distance) .. " studs"
                    espObj.Distance.Position = Vector2.new(rootPos.X, rootPos.Y + size/2 + 10)
                    espObj.Distance.Visible = true
                    espObj.Distance.Color = ESP.Color
                else
                    espObj.Distance.Visible = false
                end
                
                if ESP.Tracers then
                    espObj.Tracer.To = Vector2.new(rootPos.X, rootPos.Y + size/2)
                    espObj.Tracer.Visible = true
                    espObj.Tracer.Color = ESP.Color
                else
                    espObj.Tracer.Visible = false
                end
                
                if ESP.Chams then
                    espObj.Chams.Enabled = true
                    espObj.Chams.FillColor = ESP.Color
                else
                    espObj.Chams.Enabled = false
                end
            else
                for _, drawing in pairs(espObj) do
                    if drawing:IsA("Drawing") then drawing.Visible = false end
                    if drawing:IsA("Highlight") then drawing.Enabled = false end
                end
            end
        end
    end
end

for _, player in pairs(Players:GetPlayers()) do
    CreateESP(player)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        CreateESP(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if ESP.Objects[player] then
        for _, drawing in pairs(ESP.Objects[player]) do
            drawing:Remove()
        end
        ESP.Objects[player] = nil
    end
end)

Section:Toggle({Title = "ESP Enabled", Description = "Toggle all ESP features", Default = false}, function(value)
    ESP.Enabled = value
    Window:Notification({Title = "HeavenHub", Description = "ESP " .. (value and "Enabled" or "Disabled")})
end)

Section:Toggle({Title = "Box ESP", Description = "Show player boxes", Default = false}, function(value)
    ESP.Boxes = value
end)

Section:Toggle({Title = "Name ESP", Description = "Show player names", Default = false}, function(value)
    ESP.Names = value
end)

Section:Toggle({Title = "Distance ESP", Description = "Show player distance", Default = false}, function(value)
    ESP.Distance = value
end)

Section:Toggle({Title = "Tracer ESP", Description = "Show bottom screen tracers", Default = false}, function(value)
    ESP.Tracers = value
end)

Section:Toggle({Title = "Box Outline", Description = "Add box outlines", Default = false}, function(value)
    ESP.Outline = value
end)

Section:Toggle({Title = "Chams ESP", Description = "Highlight players", Default = false}, function(value)
    ESP.Chams = value
end)

Section:ColorPicker({Title = "ESP Color", Description = "Set ESP color", Default = Color3.fromRGB(255, 0, 0)}, function(value)
    ESP.Color = value
    for _, espObj in pairs(ESP.Objects) do
        for _, drawing in pairs(espObj) do
            if drawing:IsA("Drawing") and drawing ~= espObj.BoxOutline then
                drawing.Color = value
            end
            if drawing:IsA("Highlight") then
                drawing.FillColor = value
            end
        end
    end
end)

Section:Button({Title = "Refresh ESP", ButtonName = "Refresh", Description = "Refresh ESP objects"}, function()
    for _, espObj in pairs(ESP.Objects) do
        for _, drawing in pairs(espObj) do
            drawing:Remove()
        end
    end
    ESP.Objects = {}
    for _, player in pairs(Players:GetPlayers()) do
        CreateESP(player)
    end
    Window:Notification({Title = "HeavenHub", Description = "ESP refreshed"})
end)

local MovementCat = Window:Category("Movement", "rbxassetid://8395621517")
local MovementButton = MovementCat:Button("Cheats", "rbxassetid://8395747586")
local MovementSection = MovementButton:Section("Controls", "Left")

MovementSection:Slider({Title = "Walk Speed", Description = "Set movement speed", Default = 16, Min = 16, Max = 200}, function(value)
    Cheats.Speed = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

MovementSection:Slider({Title = "Jump Power", Description = "Set jump height", Default = 50, Min = 50, Max = 200}, function(value)
    Cheats.Jump = value
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)

MovementSection:Toggle({Title = "Fly", Description = "Toggle flight", Default = false}, function(value)
    Cheats.FlyEnabled = value
    if value then
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        
        spawn(function()
            while Cheats.FlyEnabled and LocalPlayer.Character do
                local cam = workspace.CurrentCamera
                local moveDir = Vector3.new()
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                bodyVelocity.Velocity = moveDir * Cheats.Speed
                wait()
            end
            bodyVelocity:Destroy()
        end)
    end
end)

MovementSection:Toggle({Title = "Noclip", Description = "Walk through walls", Default = false}, function(value)
    Cheats.Noclip = value
    spawn(function()
        while Cheats.Noclip and LocalPlayer.Character do
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not value
                end
            end
            wait()
        end
    end)
end)

MovementSection:Toggle({Title = "Infinite Jump", Description = "Jump repeatedly", Default = false}, function(value)
    Cheats.InfJump = value
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if Cheats.InfJump and LocalPlayer.Character then
            LocalPlayer.Character.Humanoid:ChangeState("Jumping")
        end
    end)
end)

MovementSection:Toggle({Title = "Click TP", Description = "Teleport to mouse", Default = false}, function(value)
    Cheats.ClickTP = value
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if Cheats.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and LocalPlayer.Character then
            local mouse = LocalPlayer:GetMouse()
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 5, 0))
        end
    end)
end)

MovementSection:Button({Title = "Reset Speed/Jump", ButtonName = "Reset", Description = "Reset to default"}, function()
    Cheats.Speed = 16
    Cheats.Jump = 50
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
    Window:Notification({Title = "HeavenHub", Description = "Speed and Jump reset"})
end)

local MiscCat = Window:Category("Miscellaneous", "rbxassetid://8395621517")
local MiscButton = MiscCat:Button("Utilities", "rbxassetid://8395747586")
local MiscSection = MiscButton:Section("Tools", "Left")

MiscSection:Button({Title = "Kill Player", ButtonName = "Kill", Description = "Kill selected player"}, function()
    Window:Prompt({Title = "Kill Player", Description = "Enter player name to kill"}, function(name)
        local target = Players:FindFirstChild(name)
        if target and target.Character then
            target.Character.Humanoid.Health = 0
            Window:Notification({Title = "HeavenHub", Description = "Killed " .. name})
        end
    end)
end)

MiscSection:Button({Title = "Teleport To", ButtonName = "TP", Description = "Teleport to player"}, function()
    Window:Prompt({Title = "Teleport", Description = "Enter player name"}, function(name)
        local target = Players:FindFirstChild(name)
        if target and target.Character and LocalPlayer.Character then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
            Window:Notification({Title = "HeavenHub", Description = "Teleported to " .. name})
        end
    end)
end)

MiscSection:Keybind({Title = "Toggle UI", Description = "Hide/show UI", Default = Enum.KeyCode.RightShift}, function()
    Window.MainUI.Enabled = not Window.MainUI.Enabled
end)

RunService.RenderStepped:Connect(UpdateESP)

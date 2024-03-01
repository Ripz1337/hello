--Init
if not game:IsLoaded() then game.Loaded:Wait() end
if not syn or not protectgui then getgenv().protectgui = function() end end

--HTTP
Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Jonathan-2k/Dependencies/main/Crumbleware%20UI"))()
ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainstreamed/Linoria/main/ThemeManager.lua"))()
SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainstreamed/Linoria/main/SaveManager.lua"))()
esp = loadstring(game:HttpGet("https://pastebin.com/raw/fKf3NWhn"))()

Library:Notify("Script Loaded!, Press End To Open! Made By Yellow_FireFighter#3625")

--Variables
local CrumbleWare = 1.25
local resume = coroutine.resume
local create = coroutine.create
local RVelocity, YVelocity = nil, 0.5
local Players = game.Players
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local WorldToScreen = Camera.WorldToScreenPoint
ReplicatedStorage = game.ReplicatedStorage
UniversalTables = require(ReplicatedStorage.Modules:WaitForChild("UniversalTables"))
FPS = 0

--Create Instances

local FovCircle = Drawing.new("Circle")
FovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
FovCircle.Radius = 0
FovCircle.Filled = false
FovCircle.Color = Color3.fromRGB(255, 255, 255)
FovCircle.Visible = false
FovCircle.Transparency = 0
FovCircle.NumSides = 0
FovCircle.Thickness = 0

local Snapline_Line = Drawing.new("Line")
Snapline_Line.Visible = true
Snapline_Line.Thickness = 1
Snapline_Line.Transparency = 1
Snapline_Line.From = Vector2.new(game.workspace.CurrentCamera.ViewportSize.X / 2, game.workspace.CurrentCamera.ViewportSize.Y / 2)
Snapline_Line.To = Vector2.new(game.workspace.CurrentCamera.ViewportSize.X / 2, game.workspace.CurrentCamera.ViewportSize.Y / 2)
Snapline_Line.Color = Color3.fromRGB(255, 255, 255)

local Crosshair_Horizontal = Drawing.new("Line")
Crosshair_Horizontal.Visible = false
Crosshair_Horizontal.Thickness = 1
Crosshair_Horizontal.Transparency = 1
Crosshair_Horizontal.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
Crosshair_Horizontal.To = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
Crosshair_Horizontal.Color = Color3.fromRGB(255, 255, 255)

local Crosshair_Vertical = Drawing.new("Line")
Crosshair_Vertical.Visible = false
Crosshair_Vertical.Thickness = 1
Crosshair_Vertical.Transparency = 1
Crosshair_Vertical.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
Crosshair_Vertical.To = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
Crosshair_Vertical.Color = Color3.fromRGB(255, 255, 255)

--GetTarget
function getPositionOnScreen(Vector)
    local Vec3, OnScreen = WorldToScreen(Camera, Vector)
    return Vector2.new(Vec3.X, Vec3.Y), OnScreen
end

function GetTarget()
    local Target
    local DistanceToMouse

    --Player

    for _, Player in pairs(Players:GetChildren()) do
        if Player ~= game.Players.LocalPlayer then
            if Player == LocalPlayer then continue end

            local Character = Player.Character
            if not Character then continue end

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            local Humanoid = Character:FindFirstChild("Humanoid")
            if not HumanoidRootPart or not Humanoid or Humanoid and Humanoid.Health <= 0 then continue end

            local ScreenPosition, OnScreen = getPositionOnScreen(HumanoidRootPart.Position)
            if not OnScreen then continue end

            local Distance = (Vector2.new(game.workspace.CurrentCamera.ViewportSize.X / 2, game.workspace.CurrentCamera.ViewportSize.Y / 2) - ScreenPosition).Magnitude
            if Distance <= (DistanceToMouse or Options.FovRadius.Value or 2000) then
                Target = Character[Options.TargetPart.Value] or false
                DistanceToMouse = Distance
            end
        end
    end


--Prediction
function CalculateHPrediction(TargetPos, TargetVelo, BulletVelocity)

    local PredictionAmount = (TargetPos - Camera.CFrame.p).Magnitude / BulletVelocity
    local NewPos = TargetPos + TargetVelo * PredictionAmount

    return NewPos
end

function CalculateYPrediction(TargetPos, TargetVelo, BulletVelocity)

    local PredictionAmount = 0
    local NewPos = 0

    return NewPos
end

--Resolver
function ResolveVelocity(Before, After, Delta)

    local Displacement = (After - Before)
	local Velocity = Displacement / Delta

    return Velocity
end

function GetNewHeadCFrame(Target)
    local Head = Target.Head
    local HumanoidRootPart = Target.HumanoidRootPart

    local NewHeadCFrame = HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)

    return NewHeadCFrame
end

--Extra Functions

function HitMarker()
    coroutine.wrap(function()
        if HitMarker then
            local Line = Drawing.new("Line")
            local Line2 = Drawing.new("Line")
            local Line3 = Drawing.new("Line")
            local Line4 = Drawing.new("Line")

            local x, y = Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2

            Line.From = Vector2.new(x + 4, y + 4)
            Line.To = Vector2.new(x + 10, y + 10)
            Line.Color = HitMarkerColor
            Line.Visible = true 

            Line2.From = Vector2.new(x + 4, y - 4)
            Line2.To = Vector2.new(x + 10, y - 10)
            Line2.Color = HitMarkerColor
            Line2.Visible = true 

            Line3.From = Vector2.new(x - 4, y - 4)
            Line3.To = Vector2.new(x - 10, y - 10)
            Line3.Color = HitMarkerColor
            Line3.Visible = true 

            Line4.From = Vector2.new(x - 4, y + 4)
            Line4.To = Vector2.new(x - 10, y + 10)
            Line4.Color = HitMarkerColor
            Line4.Visible = true

            Line.Transparency = 1
            Line2.Transparency = 1
            Line3.Transparency = 1
            Line4.Transparency = 1

            Line.Thickness = 1
            Line2.Thickness = 1
            Line3.Thickness = 1
            Line4.Thickness = 1

            wait(0.3)
            for i = 1,0,-0.1 do
                wait()
                Line.Transparency = i 
                Line2.Transparency = i
                Line3.Transparency = i
                Line4.Transparency = i
            end
            Line:Remove()
            Line2:Remove()
            Line3:Remove()
            Line4:Remove()
        end
	end)()
end

function HitTracer(v1, v2)
    local colorSequence = ColorSequence.new({
    ColorSequenceKeypoint.new(0, HitTracerColor),
    ColorSequenceKeypoint.new(1,  HitTracerColor),
    })
    -- main part
    local Part = Instance.new("Part", Instance.new("Part", workspace))
    Part.Size = Vector3.new(1, 1, 1)
    Part.Transparency = 1
    Part.CanCollide = false
    Part.CFrame = CFrame.new(v1)
    Part.Anchored = true
    -- attachment
    local Attachment = Instance.new("Attachment", Part)
    -- part 2
    local Part2 = Instance.new("Part", Instance.new("Part", workspace))
    Part2.Size = Vector3.new(1, 1, 1)
    Part2.Transparency =  1
    Part2.CanCollide = false
    Part2.CFrame = CFrame.new(v2)
    Part2.Anchored = true
    Part2.Color = Color3.fromRGB(255, 0, 255)
    -- another attachment
    local Attachment2 = Instance.new("Attachment", Part2)
    -- beam
    local Beam = Instance.new("Beam", Part)
    Beam.FaceCamera = true
    Beam.Color = colorSequence
    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.LightEmission = 6
    Beam.LightInfluence = 1
    Beam.Width0 = 1
    Beam.Width1 = 0.6
    Beam.Texture = "rbxassetid://446111271"
    Beam.LightEmission = 1
    Beam.LightInfluence = 1
    Beam.TextureMode = Enum.TextureMode.Wrap -- wrap so length can be set by TextureLength
    Beam.TextureLength = 3 -- repeating texture is 1 stud long 
    Beam.TextureSpeed = 3
    delay(2, function()
    for i = 0.5, 1, 0.02 do
    wait()
    Beam.Transparency = NumberSequence.new(i)
    end
    Part:Destroy()
    Part2:Destroy()
    end)
end


local VFX = nil; for i,v in next, getgc(true) do
    if typeof(v) == "table" and rawget(v, "RecoilCamera") then
        VFX = v
        break
    end
end

--Library

local Window = Library:CreateWindow({
    Title = 'Crumbleware | Alpha v' .. CrumbleWare .. ' | Paid',
    Center = true, 
    AutoShow = false,
})

local Tabs = {
    Combat = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings')
}

--[[Combat]]--

local MainCombat = Tabs.Combat:AddLeftTabbox()
local CombatA = MainCombat:AddTab('Main')
local CombatB = MainCombat:AddTab('Fov')

CombatA:AddToggle("CEnabled", {Text = "Enabled", Default = false, Tooltip = 'Enables Combat Features'})
CombatA:AddToggle("SEnabled", {Text = "Silent Aim", Default = false, Tooltip = 'Enables Silent Aim Features'})
CombatA:AddToggle("AEnabled", {Text = "Aimbot", Default = false, Tooltip = 'Enables Aimbot Features'})
CombatA:AddToggle("TargetBots", {Text = "Target Bots", Default = false, Tooltip = 'Aimbot and Silent Aim Will Target Bots'})
CombatA:AddDropdown('TargetPart', {Values = { 'Head', 'HumanoidRootPart' },Default = 1,Multi = false,Text = 'Target',Tooltip = 'Changes the Target'})
CombatA:AddToggle("PredictEnabled", {Text = "Prediction", Default = false, Tooltip = 'Enables Prediction'})
CombatA:AddToggle("SnapEnabled", {Text = "Snaplines", Default = false, Tooltip = 'Enables Snaplines'}):AddColorPicker('SnaplineColor', {Default = Color3.fromRGB(255, 0, 0), Title = 'Snapline Color'})
Options.SnaplineColor:OnChanged(function() Snapline_Line.Color = Options.SnaplineColor.Value end)

CombatB:AddToggle("FovEnabled", {Text = "Fov Enabled", Default = false, Tooltip = 'Toggles The Circle'}):AddColorPicker('FovColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Circle Color'})
Options.FovColor:OnChanged(function() FovCircle.Color = Options.FovColor.Value end)
Toggles.FovEnabled:OnChanged(function() FovCircle.Visible = Toggles.FovEnabled.Value end)
CombatB:AddSlider('FovRadius', {Text = 'Radius', Default = 80, Min = 0, Max = 1200, Rounding = 0, Compact = true}):OnChanged(function() FovCircle.Radius = Options.FovRadius.Value  end )
CombatB:AddToggle("FovFilled", {Text = "Filled", Default = false, Tooltip = 'Fills The Circle'}):OnChanged(function() FovCircle.Filled = Toggles.FovFilled.Value end)
CombatB:AddSlider('FovTransparency', {Text = 'Transparency', Default = 100, Min = 0, Max = 100, Rounding = 2, Compact = true}):OnChanged(function() FovCircle.Transparency = Options.FovTransparency.Value / 100 end)
CombatB:AddSlider('FovSides', {Text = 'Sides', Default = 14, Min = 3, Max = 64, Rounding = 0, Compact = true}):OnChanged(function() FovCircle.NumSides = Options.FovSides.Value end)
CombatB:AddSlider('FovThickness', {Text = 'Thickness', Default = 0, Min = 0, Max = 10, Rounding = 0, Compact = true}):OnChanged(function() FovCircle.Thickness = Options.FovThickness.Value end)

local OtherCombat = Tabs.Combat:AddRightTabbox()
local OtherA = OtherCombat:AddTab('Gun Mods')
local OtherB = OtherCombat:AddTab('HitSounds')

OtherA:AddToggle("GEnabled", {Text = "Enabled", Default = false, Tooltip = 'Enables Gun Mods'})
OtherA:AddToggle('GunMods_NoRecoil', {Text = 'No Recoil', Default = false}):OnChanged(function()
    local RecoilCamera = VFX.RecoilCamera;
    VFX.RecoilCamera = function(...)
        if Toggles.GunMods_NoRecoil.Value and Toggles.GEnabled.Value then
            return 0
        else
           return RecoilCamera(...)
        end
    end
end)
OtherB:AddDropdown('HeadEnabled', {Values = {"Test"}, Default = 1, Multi = false, Text = 'Headshot Sound'}):OnChanged(function()
    if Options.HeadEnabled.Value == "None" then
        return
    end
    --headshot_sound.SoundId = hit_sounds[Options.HeadEnabled.Value]
end)
OtherB:AddSlider('HeadVolume', {Text = 'Volume', Default = 1, Min = 0, Max = 10, Rounding = 2, Compact = true}):OnChanged(function()
    --headshot_sound.Volume = Options.HeadVolume.Value
end)
OtherB:AddDropdown('BodyEnabled', {Values = {"Test"}, Default = 1, Multi = false, Text = 'Bodyshot Sound'}):OnChanged(function()
    if Options.BodyEnabled.Value == "None" then 
        return
    end
    --bodyshot_sound.SoundId =  hit_sounds[Options.BodyEnabled.Value]
end)
OtherB:AddSlider('BodyVolume', {Text = 'Volume', Default = 1, Min = 0, Max = 10, Rounding = 2, Compact = true}):OnChanged(function()
   -- bodyshot_sound.Volume = Options.BodyVolume.Value
end)

local CombatResolver = Tabs.Combat:AddRightTabbox()
local ResolveA = CombatResolver:AddTab('Resolver')

ResolveA:AddToggle("ResolverEnabled", {Text = "Enabled", Default = false, Tooltip = 'Resolves Antiaim'})
ResolveA:AddToggle("VelocityReEnabled", {Text = "Velocity Rebuilder", Default = false, Tooltip = 'Resolves Velocity Breaker'})
ResolveA:AddToggle("NoHeadReEnabled", {Text = "Body Rebuilder", Default = false, Tooltip = 'Resolves No Head'})

--[[End Of Combat]]--

--[[Visual]]--

local ESP = Tabs.Visuals:AddLeftTabbox()
local ESPA = ESP:AddTab('Main Esp')
local ESPB = ESP:AddTab('Other Esp')

ESPA:AddToggle("EEnabled", {Text = "Enabled", Default = false, Tooltip = 'Enables ESP'}):OnChanged(function() esp.enabled = Toggles.EEnabled.Value end)
ESPA:AddToggle("NameEnabled", {Text = "Names", Default = false, Tooltip = 'Enables Name ESP'}):OnChanged(function() esp.settings.name.enabled = Toggles.NameEnabled.Value end)
Toggles.NameEnabled:AddColorPicker('NameColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Name Color'})
Options.NameColor:OnChanged(function() esp.settings.name.color = Options.NameColor.Value end)
ESPA:AddToggle("DistanceEnabled", {Text = "Distance", Default = false, Tooltip = 'Enables Distance ESP'}):OnChanged(function() esp.settings.distance.enabled = Toggles.DistanceEnabled.Value end)
Toggles.DistanceEnabled:AddColorPicker('DistanceColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Distance Color'})
Options.DistanceColor:OnChanged(function() esp.settings.distance.color = Options.DistanceColor.Value end)
ESPA:AddToggle("HealthBEnabled", {Text = "HealthBar", Default = false, Tooltip = 'Enables HealthBar ESP'}):OnChanged(function() esp.settings.healthbar.enabled = Toggles.HealthBEnabled.Value end)
ESPA:AddToggle("HealthTEnabled", {Text = "HealthText", Default = false, Tooltip = 'Enables HealthText ESP'}):OnChanged(function() esp.settings.healthtext.enabled = Toggles.HealthTEnabled.Value end)
Toggles.HealthTEnabled:AddColorPicker('HealthTextColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Health Text Color'})
Options.HealthTextColor:OnChanged(function() esp.settings.healthtext.color = Options.HealthTextColor.Value end)
ESPA:AddToggle("ChamsEnabled", {Text = "Chams", Default = false, Tooltip = 'Enables Chams ESP'}):OnChanged(function() esp.settings_chams.enabled = Toggles.ChamsEnabled.Value end)
Toggles.ChamsEnabled:AddColorPicker('ChamsVisibleColor', {Default = Color3.fromRGB(0, 255, 0), Title = 'Chams Visible Color'})
Options.ChamsVisibleColor:OnChanged(function() esp.settings_chams.visible_Color = Options.ChamsVisibleColor.Value end)
Toggles.ChamsEnabled:AddColorPicker('ChamsNotVisibleColor', {Default = Color3.fromRGB(255, 0, 0), Title = 'Chams Hidden Color'})
Options.ChamsNotVisibleColor:OnChanged(function() esp.settings_chams.invisible_Color = Options.ChamsNotVisibleColor.Value end)
ESPA:AddToggle("ArrowEnabled", {Text = "Arrow", Default = false, Tooltip = 'Enables Arrow ESP'}):OnChanged(function() esp.settings.arrow.enabled = Toggles.ArrowEnabled.Value end)
Toggles.ArrowEnabled:AddColorPicker('ArrowColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Arrow Color'})
Options.ArrowColor:OnChanged(function() esp.settings.arrow.color = Options.ArrowColor.Value end)
ESPA:AddToggle("AngleEnabled", {Text = "Angle", Default = false, Tooltip = 'Enables Angle ESP'}):OnChanged(function() esp.settings.viewangle.enabled = Toggles.AngleEnabled.Value end)
Toggles.AngleEnabled:AddColorPicker('AngleColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Angle Color'})
Options.AngleColor:OnChanged(function() esp.settings.viewangle.color = Options.AngleColor.Value end)
ESPA:AddToggle("TracerEnabled", {Text = "Tracers", Default = false, Tooltip = 'Enables Tracer ESP'}):OnChanged(function() esp.settings.tracer.enabled = Toggles.TracerEnabled.Value end)
Toggles.TracerEnabled:AddColorPicker('TracerColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Tracer Color'})
Options.TracerColor:OnChanged(function() esp.settings.tracer.color = Options.TracerColor.Value end)
ESPA:AddToggle("SkeletonEnabled", {Text = "Skeleton", Default = false, Tooltip = 'Enables Skeleton ESP'}):OnChanged(function() esp.settings.skeleton.enabled = Toggles.SkeletonEnabled.Value end)
Toggles.SkeletonEnabled:AddColorPicker('SkeletonColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Skeleton Color'})
Options.SkeletonColor:OnChanged(function() esp.settings.skeleton.color = Options.SkeletonColor.Value end)

ESPB:AddToggle("BEnabled", {Text = "Enabled", Default = false, Tooltip = 'Enables Other ESP'}):OnChanged(function()  end)
ESPB:AddToggle("BNames", {Text = "Names", Default = false, Tooltip = 'Enables Names For Other ESP'}):OnChanged(function() esp.customsettings.names.enabled = Toggles.BNames.Value end)
Toggles.BNames:AddColorPicker('BNameColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Name Color'})
Options.BNameColor:OnChanged(function()  esp.customsettings.names.color = Options.BNameColor.Value end)
ESPB:AddToggle("BDistance", {Text = "Distance", Default = false, Tooltip = 'Enables Distance For Other ESP'}):OnChanged(function() esp.customsettings.distance.enabled = Toggles.BDistance.Value end)
ESPB:AddToggle("BChams", {Text = "Chams", Default = false, Tooltip = 'Enables Chams For Other ESP'}):OnChanged(function() esp.customsettings.chams.enabled = Toggles.BChams.Value end)
Toggles.BChams:AddColorPicker('BChamsColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Name Color'})
Options.BChamsColor:OnChanged(function()  esp.customsettings.chams.fill_color = Options.BChamsColor.Value end)

local ESPS = Tabs.Visuals:AddRightTabbox()
local ESPSA = ESPS:AddTab('MainEsp Settings')
local ESPSB = ESPS:AddTab('OtherEsp Settings')

ESPSA:AddToggle("TeamCheckEnabled", {Text = "Team Check", Default = false, Tooltip = 'Enables Team Check'}):OnChanged(function() esp.teamcheck = Toggles.TeamCheckEnabled.Value end)
ESPSA:AddSlider('MaxDis', {Text = 'Max Distance', Default = 0, Min = 0, Max = 5000, Rounding = 0, Compact = false}):OnChanged(function() esp.maxdist = Options.MaxDis.Value  end)
ESPSA:AddToggle("DisplayName", {Text = "Display Name", Default = false, Tooltip = 'Changes What Name Is Shown'}):OnChanged(function() esp.settings.name.displaynames = Toggles.DisplayName.Value end)
ESPSA:AddToggle("NameOutline", {Text = "Name Outline", Default = true, Tooltip = 'Changes If The Outline Is Visible'}):OnChanged(function() esp.settings.name.outline = Toggles.DisplayName.Value end)
ESPSA:AddSlider('TextSize', {Text = 'Text Size', Default = 13, Min = 0, Max = 20, Rounding = 1, Compact = false}):OnChanged(function() esp.fontsize = Options.TextSize.Value end)
ESPSA:AddToggle("HealthBarOutline", {Text = "HealthBar Outline", Default = true, Tooltip = 'Changes If The Outline Is Visible'}):OnChanged(function() esp.settings.healthbar.outline = Toggles.HealthBarOutline.Value end)
ESPSA:AddToggle("HealthTextOutline", {Text = "HealthText Outline", Default = true, Tooltip = 'Changes If The Outline Is Visible'}):OnChanged(function() esp.settings.healthtext.outline = Toggles.HealthTextOutline.Value end)
ESPSA:AddToggle("DistanceOutline", {Text = "Distance Outline", Default = true, Tooltip = 'Changes If The Outline Is Visible'}):OnChanged(function() esp.settings.distance.outline = Toggles.DistanceOutline.Value end)
ESPSA:AddSlider('ViewAngleSize', {Text = 'View Angle', Default = 6, Min = 0, Max = 20, Rounding = 0, Compact = false}):OnChanged(function() esp.settings.viewangle.size = Options.ViewAngleSize.Value end)
ESPSA:AddDropdown('TracerOrigin', {Values = { 'Bottom', 'Top', 'Middle' },Default = 3,Multi = false,Text = 'Tracer Origin',Tooltip = 'Changes the Tracer Origin'}):OnChanged(function() esp.settings.tracer.origin = Options.TracerOrigin.Value end)
ESPSA:AddToggle("ArrowFilled", {Text = "Arrow Filled", Default = true, Tooltip = 'Changes If The Arrow Is Filled'}):OnChanged(function() esp.settings.arrow.filled = Toggles.ArrowFilled.Value end)
ESPSA:AddSlider('ArrowRadius', {Text = 'Arrow Radius', Default = 100, Min = 0, Max = 800, Rounding = 0, Compact = false}):OnChanged(function() esp.settings.arrow.radius = Options.ArrowRadius.Value end)
ESPSA:AddSlider('ArrowSize', {Text = 'Arrow Size', Default = 25, Min = 0, Max = 100, Rounding = 1, Compact = false}):OnChanged(function() esp.settings.arrow.size = Options.ArrowSize.Value end)

ESPSB:AddSlider('BMaxDis', {Text = 'Max Distance', Default = 5000, Min = 0, Max = 5000, Rounding = 0, Compact = false}):OnChanged(function() esp.customsettings.maxdist = Options.BMaxDis.Value  end)
ESPSA:AddToggle("BTextOutline", {Text = "Text Outline", Default = false, Tooltip = 'Enables Text Outline'}):OnChanged(function() esp.customsettings.names.outline = Toggles.BTextOutline.Value end)
ESPSB:AddSlider('BTextSize', {Text = 'Text Size', Default = 13, Min = 0, Max = 20, Rounding = 0, Compact = false}):OnChanged(function() esp.customsettings.names.size = Options.BTextSize.Value  end)
ESPSB:AddSlider('BChamsInTrans', {Text = 'Chams Fill Transperancy', Default = 0, Min = 0, Max = 100, Rounding = 0, Compact = false}):OnChanged(function() esp.customsettings.chams.fill_transparency = Options.BChamsInTrans.Value / 100 end)
ESPSB:AddSlider('BChamsOutTrans', {Text = 'Chams Outline Transperancy', Default = 0, Min = 0, Max = 100, Rounding = 0, Compact = false}):OnChanged(function() esp.customsettings.chams.outline_transparency = Options.BChamsOutTrans.Value / 100 end)

local Visuals0 = Tabs.Visuals:AddLeftTabbox()
local Visuals1 = Visuals0:AddTab('Other')
local Visuals2 = Visuals0:AddTab('Other Settings')

Visuals2:AddSlider('ViewModelX', {Text = 'Viewmodel-X', Default = 0, Min = -5, Max = 5, Rounding = 2, Compact = false})
Visuals2:AddSlider('ViewModelY', {Text = 'Viewmodel-Y', Default = 0, Min = -5, Max = 5, Rounding = 2, Compact = false})
Visuals2:AddSlider('ViewModelZ', {Text = 'Viewmodel-Z', Default = 0, Min = -5, Max = 5, Rounding = 2, Compact = false})
Visuals2:AddSlider('ThirdPersonDistance', {Text = 'ThirdPerson Distance', Default = 5, Min = 0, Max = 10, Rounding = 2, Compact = false})
Visuals2:AddDropdown("ArmChamsMat", {Text = "Arm Chams Material", Default = "SmoothPlastic", Values = {"ForceField", "Neon", "SmoothPlastic", "Glass"}})
Visuals2:AddLabel('Arm Chams Color'):AddColorPicker('ArmChamsColor', { Default = Color3.new(1, 1, 1), Title = 'Arm Chams Color'})
Visuals2:AddDropdown("GunChamsMat", {Text = "Gun Chams Material", Default = "SmoothPlastic", Values = {"ForceField", "Neon", "SmoothPlastic", "Glass"}})
Visuals2:AddLabel('Gun Chams Color'):AddColorPicker('GunChamsColor', { Default = Color3.new(1, 1, 1), Title = 'Gun Chams Color'})
Visuals2:AddSlider('ZoomAmount', {Text = 'Zoom Amount', Default = 5, Min = 0, Max = 30, Rounding = 1, Compact = false})
Visuals2:AddSlider('CrossHairSize', {Text = 'Crosshair-Size', Default = 5, Min = 0, Max = 25, Rounding = 1, Compact = false}) Options.CrossHairSize:OnChanged(function() 
    Crosshair_Horizontal.From = Vector2.new(Camera.ViewportSize.X / 2 - Options.CrossHairSize.Value, Camera.ViewportSize.Y / 2)
    Crosshair_Horizontal.To = Vector2.new(Camera.ViewportSize.X / 2 + Options.CrossHairSize.Value, Camera.ViewportSize.Y / 2)
    Crosshair_Vertical.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - Options.CrossHairSize.Value)
    Crosshair_Vertical.To = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 + Options.CrossHairSize.Value) 
end)

Visuals1:AddToggle("VisualsEnabled", {Text = "Enabled", Default = false, Tooltip = 'Enables Visuals'})
Visuals1:AddToggle("ViewModelEnabled", {Text = "Viewmodel", Default = false})
Visuals1:AddToggle("FullBrightEnabled", {Text = "FullBright", Default = false})
Visuals1:AddToggle("ThirdPersonEnabled", {Text = "Third Peron", Default = false}):AddKeyPicker("ThirdPersonKey", {Default = "P", SyncToggleState = true, Mode = "Toggle", Text = "Third Person", NoUI = false});
Visuals1:AddToggle("ArmChamsEnabled", {Text = "Arm Chams", Default = false})
Visuals1:AddToggle("GunChamsEnabled", {Text = "Gun Chams", Default = false})
--[[Visuals1:AddToggle("HitMarkEnabled", {Text = "Hit Markers", Default = false}):OnChanged(function() HitMarker = Toggles.HitMarkEnabled.Value end)
Toggles.HitMarkEnabled:AddColorPicker('HitMarkerColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Hit Marker Color'})
Options.HitMarkerColor:OnChanged(function() HitMarkerColor = Options.HitMarkerColor.Value end)
Visuals1:AddToggle("HitTracerEnabled", {Text = "Hit Tracers", Default = false}):OnChanged(function() HitTracer = Toggles.HitTracerEnabled.Value end)
Toggles.HitTracerEnabled:AddColorPicker('HitTracerColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'Hit Tracer Color'})
Options.HitTracerColor:OnChanged(function() HitTracerColor = Options.HitTracerColor.Value end)
Visuals1:AddToggle("HitLogEnabled", {Text = "Hit Logs", Default = false}):OnChanged(function() HitLog = Toggles.HitLogEnabled.Value end)]]
Visuals1:AddToggle("ZoomEnabled", {Text = "Zoom", Default = false}):AddKeyPicker("ZoomKey", {Default = "X", SyncToggleState = true, Mode = "Toggle", Text = "Zoom", NoUI = false}):OnChanged(function() repeat if not Toggles.ZoomEnabled.Value then Camera.FieldOfView = 90 end until Camera.FieldOfView ~= Options.ZoomAmount.Value end)
Visuals1:AddToggle("CrosshairEnabled", {Text = "Crosshair", Default = false}):OnChanged(function() Crosshair_Vertical.Visible = Toggles.CrosshairEnabled.Value Crosshair_Horizontal.Visible = Toggles.CrosshairEnabled.Value end)
Toggles.CrosshairEnabled:AddColorPicker('CrossHairColor', {Default = Color3.fromRGB(255, 255, 255), Title = 'CrossHair Color'})
Options.CrossHairColor:OnChanged(function()
    Crosshair_Horizontal.Color = Options.CrossHairColor.Value
    Crosshair_Vertical.Color = Options.CrossHairColor.Value
end)

--[[End Of Visuals]]--

--[[Misc]]--

--Movement

--local MainMovement = Tabs.Movement:AddLeftGroupbox('Main')



--local SettingsMovement = Tabs.Movement:AddLeftGroupbox('Settings')



--Anti-Aim

local MainAnti = Tabs.Movement:AddRightGroupbox('Anti-Aim')

MainAnti:AddToggle("AntiEnabled", {Text = "Enabled", Default = false}):OnChanged(function() end)
MainAnti:AddToggle("VeloBreaker", {Text = "Velocity Breaker", Default = false}):OnChanged(function() end)
MainAnti:AddToggle("ForceAngles", {Text = "Force Angles", Default = false})
--[[MainAnti:AddToggle("Head", {Text = "Head Spoofer", Default = false})
MainAnti:AddToggle("Arms", {Text = "Arm Spoofer", Default = false})
MainAnti:AddToggle("Legs", {Text = "Leg Spoofer", Default = false})]]

--local SettingsAnti = Tabs.Movement:AddRightGroupbox('Anti-Aim Settings')



--Chat Spammer

local MainChat = Tabs.Movement:AddLeftGroupbox('Chat')

MainChat:AddToggle("chatspam", {Text = "Enabled", Default = false}):OnChanged(function() end)
MainChat:AddInput('message', {
    Default = 'Crumbleware > Octohook (.gg/Eytqrxtdv7)',
    Numeric = false,
    Finished = false,

    Text = 'Message',
    Tooltip = 'What Message is spammed',

    Placeholder = 'Crumbleware > Octohook (.gg/Eytqrxtdv7)'
})
MainChat:AddSlider("delayc", {Text = "Chat Delay", Min = 2, Max = 10, Default = 2, Rounding = 1})

task.spawn(function()
    while task.wait(Options.delayc.Value) do
        if Toggles.chatspam.Value then
            local args = {
                [1] = Options.message.Value,
                [2] = "Global"
            }
            game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(args))
        end
    end
end)

--[[End Of Misc]]--

--[[Settings]]--

Library:SetWatermarkVisibility(true)
Library:SetWatermark('Crumbleware | Alpha v' .. CrumbleWare .. ' | Paid | ' .. FPS)
Library.KeybindFrame.Visible = true;
Library:OnUnload(function()
    Library.Unloaded = true
end)
Library:OnUnload(function()
	Library.Unloaded = true
end)
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
local UI = Tabs['UI Settings']:AddRightGroupbox('UI')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('YellowFire')
SaveManager:SetFolder('YellowFire/ProjectDelta')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
-------------
UI:AddToggle('watermark', {
	Text = 'WaterMark',
	Default = true,
	Tooltip = 'Toggles the Water Mark',
})

Toggles.watermark:OnChanged(function()
	mark = Toggles.watermark.Value
	Library:SetWatermarkVisibility(mark)
end)
-------------
UI:AddToggle('Keybinds', {
	Text = 'KeyBind List',
	Default = false,
	Tooltip = 'Toggles the KeyBind List',
})

Toggles.Keybinds:OnChanged(function()
	keybind = Toggles.Keybinds.Value
	Library.KeybindFrame.Visible = keybind
end)

--[[End Of Settings]]--

--Hooks

local oldHook = nil	
oldHook = hookfunction(require(ReplicatedStorage.Modules.FPS.Bullet).CreateBullet, function(...)
	local args = {...}
	if Toggles.CEnabled.Value and Toggles.SEnabled.Value and GetTarget() then
        Target = GetTarget()
		if Target ~= nil or Target ~= false then
            if Toggles.PredictEnabled.Value then
                local BulletVelocity = ReplicatedStorage.AmmoTypes[args[6]]:GetAttribute("MuzzleVelocity")
                local TravelTime = (Target.Position - Camera.CFrame.p).Magnitude / BulletVelocity
                if Toggles.ResolverEnabled.Value ~= true or Toggles.VelocityReEnabled.Value ~= true then
                    Target = Target.Position + Target.Parent:FindFirstChild("HumanoidRootPart").Velocity * TravelTime
                else
                    Target = Target.Position + ResolvedVelocity * TravelTime
                end
            else
                Target = Target.Position
            end

            Shooting = true

            if Target ~= nil then
                args[9] = {CFrame = CFrame.lookAt(game.Players.LocalPlayer.Character.HumanoidRootPart.Position + 
                Vector3.new(0, UniversalTables.UniversalTable.GameSettings.RootScanHeight, 0), Target)}
            end

			return oldHook(table.unpack(args))
		end
	end
	return oldHook(table.unpack(args))
end)

__namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local Args, Method, Script = {...}, getnamecallmethod():lower(), getcallingscript()
    if Method == "fireserver" then
        if tostring(self):lower() == "errorlog" or tostring(self):lower() == "errrorlog" then
            return
        end
        local Args_4 = Args[4]
        if type(Args_4) == "table" and Args_4[1] and Args_4[1].step then
            local Hit = Args[2]
            local TargetStuds = math.floor((Hit.Position - Camera.CFrame.p).Magnitude + 0.5)
            --[[if syn then
                syn.set_thread_identity(7)  
            else
                setthreadidentity(7)
            end]]

            --HitMarker()

            --[[if HitTracer then
                task.spawn(
                    HitTracer(Camera.CFrame.p, Hit.CFrame.p)
                )
            end]]

            --if HitLog then
                --Library:Notify("Hit registration | Player: " .. Hit.Parent.Name .. ", Hit: " .. Hit.Name ..  ", Distance: " .. math.floor(TargetStuds / 3.5714285714 + 0.5) .. "m (" .. TargetStuds .. " studs)")
            --end
        end
    end
    local Args, Method, Script = {...}, getnamecallmethod():lower(), getcallingscript()
    if Method == "setprimarypartcframe" and Toggles.ViewModelEnabled.Value and Toggles.VisualsEnabled.Value and not Toggles.ThirdPersonEnabled.Value then
        return __namecall(self, Camera.CFrame * CFrame.new(0.05, -1.35, 0.7) * CFrame.new(Options.ViewModelX.Value, -Options.ViewModelY.Value, -Options.ViewModelZ.Value)) -- x -y -z
    end
    
    if Method == "setprimarypartcframe" and Toggles.VisualsEnabled.Value and Toggles.ThirdPersonEnabled.Value then
        return __namecall(self, Camera.CFrame * CFrame.new(0.05, -1.35, 0.7) * CFrame.new(999, -999, -999)) -- x -y -z
    end

    return __namecall(self, ...)
end))

local __newindex = nil
__newindex = hookmetamethod(game, "__newindex", function(i, v, n_v)
    if i == Camera and v == "CFrame" then
        LastCameraCFrame = n_v
        if Toggles.ThirdPersonEnabled.Value and Toggles.VisualsEnabled.Value then
            return __newindex(i, v, n_v + Camera.CFrame.LookVector * - Options.ThirdPersonDistance.Value)
        end
    end
    return __newindex(i, v, n_v)
end)

PreviousPosition = Vector3.new(0,0,0)
local OriginalAutoRotate = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid") and Player.Character:FindFirstChildOfClass("Humanoid").AutoRotate or true
local AntiaimAngle = CFrame.new()
local Jitter = false
game:GetService("RunService").RenderStepped:Connect(function(Delta)
    FPS = FPS + 1
    local Target = GetTarget()
    if Target ~= false and Target ~= nil and Target.Parent:FindFirstChild("HumanoidRootPart") and Toggles.ResolverEnabled.Value and Toggles.VelocityReEnabled.Value and Target then
        local HumanoidRootPart = GetTarget().Parent:FindFirstChild("HumanoidRootPart")
        local CurrentPosition = HumanoidRootPart.Position
	    ResolvedVelocity = ResolveVelocity(PreviousPosition, CurrentPosition, Delta)
	    PreviousPosition = CurrentPosition
    end

    if Toggles.VisualsEnabled.Value and Toggles.ZoomEnabled.Value then
        Camera.FieldOfView = Options.ZoomAmount.Value
    end

    if Toggles.FullBrightEnabled.Value then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").ClockTime = 14
        game:GetService("Lighting").FogEnd = 100000
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end

    if Target ~= false and Target ~= nil and Target.Parent:FindFirstChild("HumanoidRootPart") and Toggles.ResolverEnabled.Value and Toggles.NoHeadReEnabled.Value and Target then
        local Head = Target.Parent:FindFirstChild("Head")

        Head.CFrame = GetNewHeadCFrame(Target.Parent)
    end

    if Toggles.CEnabled.Value and Toggles.SnapEnabled.Value and GetTarget() then
        local SnapVector, OnScreen = Camera:worldToViewportPoint(GetTarget().Position)
        if OnScreen then
            Snapline_Line.From = Vector2.new(game.workspace.CurrentCamera.ViewportSize.X / 2, game.workspace.CurrentCamera.ViewportSize.Y / 2)
            Snapline_Line.To = Vector2.new(SnapVector.X, SnapVector.Y)
            Snapline_Line.Visible = true
        else
            Snapline_Line.Visible = false
        end
    else
        Snapline_Line.Visible = false
    end

    local Check = game:GetService("Workspace").Camera:FindFirstChild("ViewModel")
    if Toggles.VisualsEnabled.Value and Check ~= nil then
        for i,v in pairs(game:GetService("Workspace").Camera.ViewModel:GetDescendants()) do
            if Toggles.ArmChamsEnabled.Value then
                if v.ClassName == "MeshPart" then
                    if v.Parent.Name == "WastelandShirt" or v.Parent.Name == "GhillieTorso" or v.Parent.Name == "CivilianPants" or v.Parent.Name == "CamoShirt" or v.Parent.Name == "HandWraps" or v.Parent.Name == "CombatGloves" then
                        v.Transparency = 1
                    end
                end
                if v.ClassName == "MeshPart" then
                    if v.Name == "LeftHand" or v.Name == "LeftLowerArm" or v.Name == "LeftUpperArm" or v.Name == "RightHand" or v.Name == "RightLowerArm" or v.Name == "RightUpperArm" then
                        v.Material = (Options.ArmChamsMat.Value)
                        v.Color = (Options.ArmChamsColor.Value)
                    end
                end
                if v.ClassName == "Part" then
                    if v.Name == "AimPartCanted" or v.Name == "AimPart" then
                        v.Size = Vector3.new(0, 0, 0)
                        v.Transparency = 1
                    end
                end
            end
        end
        if Toggles.GunChamsEnabled.Value then
            for i,v in pairs(game:GetService("Workspace").Camera.ViewModel.Item:GetDescendants()) do
                if v.ClassName == "MeshPart" or v.ClassName == "Part" then
                    v.Material = (Options.GunChamsMat.Value)
                    v.Color = (Options.GunChamsColor.Value)
                end
                if v:FindFirstChild("SurfaceAppearance") then
                    v.SurfaceAppearance:Destroy()
                end
            end
        end
    end

    --[[local Head = Player.Character:FindFirstChild("Head")
    local HumanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")

    if Toggles.Head.Value and Player.Character:FindFirstChild("Head") then
        if Head:FindFirstChild("Neck") then
            Neck = Head.Neck
            Head.Neck.Parent = nil  
        end
        Head.CanCollide = false
        Head.CFrame = Head.CFrame + Vector3.new(0, -10 ,0)

        if Head.Position.Y < -150000 then
            Neck.Parent = Head
            task.wait()
            Head.Neck.Parent = nil 
        end
    else
        if not Head:FindFirstChild("Neck") then
            Neck.Parent = Head  
        end
    end

    if Toggles.Arms.Value and Player.Character:FindFirstChild("LeftUpperArm") then
        if Player.Character.LeftUpperArm:FindFirstChild("LeftShoulder") then
            Left = Player.Character.LeftUpperArm.LeftShoulder
            Left.Parent = nil
        end
        if Player.Character.RightUpperArm:FindFirstChild("RightShoulder") then
            Right = Player.Character.RightUpperArm.RightShoulder
            Right.Parent = nil
        end
    
        Player.Character.RightUpperArm.CFrame = Player.Character.RightUpperArm.CFrame + Vector3.new(0,-10,0)
        Player.Character.LeftUpperArm.CFrame = Player.Character.RightUpperArm.CFrame + Vector3.new(0,-10,0)

        if Player.Character.LeftUpperArm.Position.Y < -150000 then
            Left.Parent = Player.Character.LeftUpperArm
            Right.Parent = Player.Character.RightUpperArm
            task.wait()
            Left.Parent = nil
            Right.Parent = nil
        end
    else
        if not Player.Character.LeftUpperArm:FindFirstChild("LeftShoulder") then
            Left.Parent = Player.Character.LeftUpperArm
            Right.Parent = Player.Character.RightUpperArm
        end
    end

    if Toggles.Legs.Value and Player.Character:FindFirstChild("LeftUpperLeg") then
        if Player.Character.LeftUpperLeg:FindFirstChild("LeftHip") then
            LeftL = Player.Character.LeftUpperLeg.LeftHip
            LeftL.Parent = nil
        end
        if Player.Character.RightUpperLeg:FindFirstChild("RightHip") then
            RightL = Player.Character.RightUpperLeg.RightHip
            RightL.Parent = nil
        end

        Player.Character.LeftUpperLeg.CFrame = Player.Character.LeftUpperLeg.CFrame + Vector3.new(0,-10,0)
        Player.Character.RightUpperLeg.CFrame = Player.Character.RightUpperLeg.CFrame + Vector3.new(0,-10,0)

        if Player.Character.LeftUpperLeg.Position.Y < -150000 then
            Left.Parent = Player.Character.LeftUpperLeg
            Right.Parent = Player.Character.RightUpperLeg
            task.wait()
            LeftL.Parent = nil
            RightL.Parent = nil
        end
    else
        if not Player.Character.LeftUpperLeg:FindFirstChild("LeftHip") then
            LeftL.Parent = Player.Character.LeftUpperLeg
            RightL.Parent = Player.Character.RightUpperLeg
        end
    end]]
end)

--Velo Breaker

resume(create(function()
    while true do
        if Toggles.AntiEnabled.Value and Toggles.VeloBreaker.Value then
            if (not RootPart) or (not RootPart.Parent) or (not RootPart.Parent.Parent) then
                RootPart = Character:FindFirstChild("HumanoidRootPart")
            else
                RVelocity = RootPart.Velocity
        
                RootPart.Velocity = type(Velocity) == "vector" and Vector3.new(Options.VeloBreaker.Value,0,Options.VeloBreaker.Value) or Velocity(RVelocity)
            
                RStepped:wait()
            
                RootPart.Velocity = RVelocity
            end
        end
        Heartbeat:wait()
    end
end))

resume(create(function()
    while wait(1) do
        Library:SetWatermark('Crumbleware | Alpha v' .. CrumbleWare .. ' | Paid | ' .. FPS .. " |")
        Library:SetWatermarkVisibility(Toggles.watermark.Value)
        FPS = 0
    end
end))

Environment.Load = Load -- lol.Load()

setmetatable(Environment, {__call = Load})

return Environment

local GUILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/UnknownKellyMC9/CustomScripts/main/UI_Library/Kavo.lua"))()

local Players = game:GetService('Players')
local Building = false
local Development = true

if Development then
   game:GetService("StarterGui"):SetCore("SendNotification", {
       Title = "Development In Progress";
       Text = "This script is in development, you can cause the bugs easily";
       Duration = 35
   })
end

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}

do
    function RunLoops:BindToRenderStep(name, num, func)
        if self.RenderStepTable[name] == nil then
            self.RenderStepTable[name] = game:GetService("RunService").RenderStepped:Connect(func)
        end
    end

    function RunLoops:UnbindFromRenderStep(name)
        if self.RenderStepTable[name] then
            self.RenderStepTable[name]:Disconnect()
            self.RenderStepTable[name] = nil
        end
    end

    function RunLoops:BindToStepped(name, num, func)
        if self.StepTable[name] == nil then
            self.StepTable[name] = game:GetService("RunService").Stepped:Connect(func)
        end
    end

    function RunLoops:UnbindFromStepped(name)
        if self.StepTable[name] then
            self.StepTable[name]:Disconnect()
            self.StepTable[name] = nil
        end
    end

    function RunLoops:BindToHeartbeat(name, num, func)
        if self.HeartTable[name] == nil then
            self.HeartTable[name] = game:GetService("RunService").Heartbeat:Connect(func)
        end
    end

    function RunLoops:UnbindFromHeartbeat(name)
        if self.HeartTable[name] then
            self.HeartTable[name]:Disconnect()
            self.HeartTable[name] = nil
        end
    end
end

local function runcode(func)
    pcall(function()
        spawn(function()
            func()
        end)
    end)
end

local function applyHitboxSettings(character, size, transparency)
    character.HumanoidRootPart.Size = Vector3.new(size, size, size)
    character.HumanoidRootPart.Transparency = transparency
    character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
    character.HumanoidRootPart.Material = "Neon"
    character.HumanoidRootPart.CanCollide = false
end

local Windows = GUILibrary:CreateWindow({
    ["Title"] = "Hitbox Expander",
    ["Theme"] = "BloodTheme"
})

local Tabs = {
    ["Main"] = Windows.NewTab("Main"),
    ["Details"] = Windows.NewTab("Details")
}

local Sections = {
    ["Settings"] = Tabs["Main"].NewSection("Settings"), 
    ["GUI"] = Tabs["Details"].NewSection("Details")
}

runcode(function()
    local Executed = false
    local HitboxExpansion = {["Enabled"] = false}
    local HitboxTeam = {["Enabled"] = false}
    local HitboxSize = {["Value"] = 5}
    local HitboxTransparency = {["Value"] = 1}

    local function updateHitboxSettings()
        local localPlayer = Players.LocalPlayer
        local HitboxStatus = HitboxExpansion["Enabled"]
        local TeamCheck = HitboxTeam["Enabled"]

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local isHitboxEnabled = HitboxStatus and (not TeamCheck or localPlayer.Team ~= player.Team)

                pcall(function()
                    if isHitboxEnabled then
                        applyHitboxSettings(player.Character, HitboxSize["Value"], HitboxTransparency["Value"])
                    else
                        applyHitboxSettings(player.Character, 2, 1)
                    end
                end)
            end
        end
    end

    RunLoops:BindToStepped("UpdateHitboxSettings", 1, updateHitboxSettings)

    Sections["Settings"].NewToggle({
        ["Name"] = "Hitbox Toggle",
        ["Function"] = function(call)
            HitboxExpansion["Enabled"] = call do
                if not Executed then
	                game:GetService("StarterGui"):SetCore("SendNotification", {
	                    Title = "Recommended";
					    Text = "Adjust the Hitbox Transparency to make hitbox visible or invisible.";
					    Duration = 25
					})
			    end
                Executed = true
            end
        end,
        ["InfoText"] = "Toggles the current hitbox state."
    })

    Sections["Settings"].NewToggle({
        ["Name"] = "Team Check",
        ["Function"] = function(call)
            HitboxTeam["Enabled"] = call
        end,
        ["InfoText"] = "Prevents your own team being affected."
    })

    Sections["Settings"].NewSlider({
        ["Name"] = "Hitbox Size",
        ["Min"] = 5,
        ["Max"] = 50,
        ["Default"] = 5,
        ["Function"] = function(val)
            HitboxSize["Value"] = val
        end,
        ["InfoText"] = "Increases the size of the hitbox."
    })

    Sections["Settings"].NewSlider({
        ["Name"] = "Hitbox Transparency",
        ["Min"] = 0,
        ["Max"] = 100,
        ["Default"] = 50,
        ["Function"] = function(val)
            HitboxTransparency["Value"] = 1 - (val / 100)
        end,
        ["InfoText"] = "Increases the transparency of the hitbox."
    })
end)

local GUILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/UnknownKellyMC9/CustomScripts/main/UI_Library/Kavo.lua"))()

local function RunCode(func)
    pcall(function()
        spawn(function()
            func()
        end)
    end)
end

local Windows = GuiLibrary:CreateWindow({
    ["Title"] = "Hitbox Expander",
    ["Theme"] = "Ocean"
})

local Tabs = {
	["Main"] = Windows.NewTab("Main")
}

local Sections = {
    ["Settings"] = Tabs["Main"].NewSection("Settings")
}

RunCode(function()
    local func
    local func2
    local HitboxExpansion = {["Enabled"] = false}
    Sections["Settings"].NewToggle({
        ["Name"] = "Hitbox Toggle",
        ["Function"] = function(call)
            HitboxExpansion["Enabled"] = call
            if HitboxExpansion["Enabled"] then
               
            end
        end,
        ["InfoText"] = "Toggles the current hitbox state."
    })
end)

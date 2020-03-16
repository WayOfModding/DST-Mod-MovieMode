local require       = GLOBAL.require
local assert        = GLOBAL.assert

-- counter:
--      * 0 -> Hide HUD
--      * 1 -> Hide character and shadow
--      * 2 -> Show HUD, character and shadow
local counter = 0

local function MakeFunction(inst)
    local EntityScript  = GLOBAL.EntityScript
    local CanDoAction   = EntityScript.CanDoAction

    local function CantDoAction() return false end

    local function Toggle_HUD(show)
        local hud = inst.HUD
        assert(hud ~= nil, "Player HUD missing!")
        hud:Toggle()
    end

    local function Toggle_Entity(show)
        -- Toggle shadow
        inst.DynamicShadow:Enable(show)

        if show then
            -- Enable actions
            inst:AddTag("inspectable")
            inst.CanDoAction = CanDoAction
            -- Enable components
            if inst.components.talker then
                inst.components.talker:StopIgnoringAll()
            end
        else
            -- Disable actions
            inst:RemoveTag("inspectable")
            inst.CanDoAction = CantDoAction
            -- Disable components
            if inst.components.talker then
                inst.components.talker:IgnoreAll()
            end
        end

        if not GLOBAL.TheNet:GetIsServerAdmin() then
            return
        end

        -- features only available for ServerAdmin
        if show then
            -- Show player
            inst:Show()
            -- Enable combat
            inst:RemoveTag("notarget")
            inst:RemoveTag("invisible")
            inst:RemoveTag("debugnoattack")
            -- Enable lightning strike
            inst:AddTag("lightningtarget")
        else
            -- Hide player
            inst:Hide()
            -- Disable combat
            inst:AddTag("notarget")
            inst:AddTag("invisible")
            inst:AddTag("debugnoattack")
            -- Disable lightning strike
            inst:RemoveTag("lightningtarget")
        end

        if inst.components.health ~= nil then
            inst.components.health:SetInvincible(not show)
        end

        if inst.components.inventory then
            inst.components.inventory.ignoresound = not show
        end
    end

    return function()
        if counter == 0 then
            Toggle_HUD(false)
        elseif counter == 1 then
            Toggle_Entity(false)
        else
            Toggle_HUD(true)
            Toggle_Entity(true)
        end

        counter = (counter + 1) % 3
    end
end

AddPlayerPostInit(function(inst)
    if inst == nil then
        return
    end
    local TheNet    = GLOBAL.TheNet
    -- test
    --[[
    print("KK-TEST> TheNet:GetIsServer() = ",           tostring(TheNet:GetIsServer()))
    print("KK-TEST> TheNet:GetServerIsDedicated() = ",  tostring(TheNet:GetServerIsDedicated()))
    print("KK-TEST> TheNet:GetIsClient() = ",           tostring(TheNet:GetIsClient()))
    print("KK-TEST> TheNet:GetIsServerAdmin() = ",      tostring(TheNet:GetIsServerAdmin()))
    --]]
    -- bind key
    local ToggleMovieMode = MakeFunction(inst)
    assert(ToggleMovieMode ~= nil, "Fail to create ToggleMovieMode function!")
    local TheInput  = GLOBAL.TheInput
    local KEY_C     = GetModConfigData("MOVIE_KEY") or GLOBAL.KEY_C
    TheInput:AddKeyUpHandler(KEY_C, ToggleMovieMode)
end)

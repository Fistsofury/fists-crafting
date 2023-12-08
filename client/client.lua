local playerJob = nil

-- Function to request the player's job from the server
function requestPlayerJob()
    TriggerServerEvent('fists-crafting:GetJob')
end

-- Event handler for receiving the job information
RegisterNetEvent('fists-crafting:SendJob', function(job)
    playerJob = job
end)

CreateThread(function()
    local PromptGroup = BccUtils.Prompt:SetupPromptGroup() 
    local smeltingPrompt = PromptGroup:RegisterPrompt("Open Smelting", 0x4CC0E2FE, 1, 1, true, 'hold', {timedeventhash = "MEDIUM_TIMED_EVENT"}) 
    local someThresholdDistance = 5.0

    while true do
        Wait(5)
        requestPlayerJob()  -- Request the player's job
        local playerCoords = GetEntityCoords(PlayerPedId())
        local nearSmeltingLocation = false

        for key, location in pairs(Config.Locations.SmeltingLocations) do
            if #(playerCoords - location.coords) < someThresholdDistance then
                nearSmeltingLocation = true
                break
            end
        end

        local allowedToSmelt = (#Config.Jobs.SmelterJobs == 0) or table.includes(Config.Jobs.SmelterJobs, playerJob)
        
        if nearSmeltingLocation and allowedToSmelt then
            PromptGroup:ShowGroup("Smelting Station Nearby")
            if smeltingPrompt:HasCompleted() then
                TriggerEvent('smelting:openMenu') -- Open the smelting menu
            end
        else
           -- PromptGroup:HideGroup()
        end
    end
end)




-- Apothecary
RegisterNetEvent('fists-crafting:mortarpestle', function()
    onMortarPestleUse()
end)

local Animations = exports.vorp_animations.initiate()
local mortarpestleObjects = {}

function onMortarPestleUse()
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, -0.5))
    local h = GetEntityHeading(playerPed)

    if BccUtils and BccUtils.Object then
        Animations.playAnimation('riverwash', 2000)
        local obj = BccUtils.Object:Create('p_mortarpestle01x', x, y, z, h, true, 'standard')
        table.insert(mortarpestleObjects, vector3(x, y, z))
    else
        if config.debug then
        print("Error: BccUtils or BccUtils.Objects is not available.")
        end
    end
end

Citizen.CreateThread(function()
    local PromptGroup = BccUtils.Prompt:SetupPromptGroup()
    local apothecaryPrompt = PromptGroup:RegisterPrompt("Open Apothecary", 0x4CC0E2FE, 1, 1, true, 'hold', {timedeventhash = "MEDIUM_TIMED_EVENT"})

    while true do
        Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local nearAnyObject = false

        for _, objCoords in ipairs(mortarpestleObjects) do
            if #(playerCoords - objCoords) < 5 then 
                nearAnyObject = true
                break
            end
        end

        if nearAnyObject then
            PromptGroup:ShowGroup("Mix Herbs with Mortar and Pestle")
            if apothecaryPrompt:HasCompleted() then
                TriggerEvent('apothecary:openMenu')
            end
        end
    end
end)




--Cooking

RegisterNetEvent('fists-crafting:campfire', function()
    onCampfireUse()
end)

local campfireObjects = {}

function onCampfireUse()
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 2.0, -0.5))
    local h = GetEntityHeading(playerPed)

    if BccUtils and BccUtils.Object then
        Animations.playAnimation('campfire', 2000)
        local obj = BccUtils.Object:Create('p_campfire01x', x, y, z, h, true, 'standard')
        table.insert(campfireObjects, vector3(x, y, z))
    else
        if config.debug then
        print("Error: BccUtils or BccUtils.Objects is not available.")
        end
    end
end


Citizen.CreateThread(function()
    local PromptGroup = BccUtils.Prompt:SetupPromptGroup()
    local craftingPrompt = PromptGroup:RegisterPrompt("Open Cooking", 0x4CC0E2FE, 1, 1, true, 'hold', {timedeventhash = "MEDIUM_TIMED_EVENT"})

    while true do
        Citizen.Wait(0)

        local playerCoords = GetEntityCoords(PlayerPedId())
        local nearAnyObject = false

        for _, objCoords in ipairs(campfireObjects) do
            if #(playerCoords - objCoords) < 5 then 
                nearAnyObject = true
                break
            end
        end

        if nearAnyObject then
            PromptGroup:ShowGroup("Start Cooking")
            if craftingPrompt:HasCompleted() then
                TriggerEvent('cooking:openMenu')
            end
        end
    end
end)


--Brewing
RegisterNetEvent('fists-crafting:campfireWithCauldron', function()
    onBrewingUse()
end)

local brewingObjects = {}

function onBrewingUse()
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, -0.5))
    local h = GetEntityHeading(playerPed)

    if BccUtils and BccUtils.Object then
        Animations.playAnimation('campfire', 2000)
        local obj = BccUtils.Object:Create('s_cul_cookfire01x', x, y, z, h, true, 'standard')
        table.insert(brewingObjects, vector3(x, y, z))
    else
        if config.debug then
        print("Error: BccUtils or BccUtils.Objects is not available.")
        end
    end
end

Citizen.CreateThread(function()
    local PromptGroup = BccUtils.Prompt:SetupPromptGroup()
    local brewingPrompt = PromptGroup:RegisterPrompt("Open Brewing", 0x4CC0E2FE, 1, 1, true, 'hold', {timedeventhash = "MEDIUM_TIMED_EVENT"})

    while true do
        Citizen.Wait(5)
        requestPlayerJob() 

        local playerCoords = GetEntityCoords(PlayerPedId())
        local nearAnyObject = false

        for _, objCoords in ipairs(brewingObjects) do
            if #(playerCoords - objCoords) < 5 then 
                nearAnyObject = true
                break
            end
        end

        local allowedToBrew = (#Config.Jobs.BrewingJobs == 0) or table.includes(Config.Jobs.BrewingJobs, playerJob)

        if nearAnyObject and allowedToBrew then
            PromptGroup:ShowGroup("Start Brewing")
            if brewingPrompt:HasCompleted() then
                TriggerEvent('brewing:openMenu')
            end
        end
    end
end)





RegisterCommand('smelting', function()
    TriggerEvent('smelting:openMenu')
end, false)

RegisterCommand('apothecary', function()
    TriggerEvent('apothecary:openMenu')
end, false)

RegisterCommand('crafting', function()
    TriggerEvent('crafting:openMenu')
end, false)

RegisterCommand('cooking', function()
    TriggerEvent('cooking:openMenu')
end, false)







RegisterNetEvent('crafting:openMenu')
AddEventHandler('crafting:openMenu', function()
    openCraftingMenu()
end)

RegisterNetEvent('apothecary:openMenu')
AddEventHandler('apothecary:openMenu', function()
    openApothecaryMenu()
end)

RegisterNetEvent('smelting:openMenu')
AddEventHandler('smelting:openMenu', function()
    openSmeltingMenu()
end)

RegisterNetEvent('cooking:openMenu')
AddEventHandler('cooking:openMenu', function()
    openCookingMenu()
end)

RegisterNetEvent('brewing:openMenu')
AddEventHandler('brewing:openMenu', function()
    openBrewingMenu()
end)




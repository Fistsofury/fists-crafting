local playerJob = nil
local Animations = exports.vorp_animations.initiate()

local mortarpestleObjects = {}
local campfireObjects = {}
local brewingObjects = {}

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
    print("Opening smelting menu")
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

RegisterNetEvent('carpentry:openMenu')
AddEventHandler('carpentry:openMenu', function()
    openCarpentryMenu()
end)


function createPropAndPlayAnimation(propName, animName, animDuration, offsetX, offsetY, offsetZ, objectsTable)
    local playerPed = PlayerPedId()
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, offsetX, offsetY, offsetZ))
    local h = GetEntityHeading(playerPed)

    if BccUtils and BccUtils.Object then
        if animName and animDuration then
            Animations.playAnimation(animName, animDuration)
        end
        local obj = BccUtils.Object:Create(propName, x, y, z, h, true, 'standard')
        if obj then
            print(propName .. " created")  
            table.insert(objectsTable, vector3(x, y, z))
        else
            print("Failed to create " .. propName) 
        end
    else
        print("BccUtils or BccUtils.Object not available")  
    end
end

function onMortarPestleUse()
    createPropAndPlayAnimation('p_mortarpestle01x', 'riverwash', 2000, 0.0, 1.0, -0.5, mortarpestleObjects)
end

function onCampfireUse()
    createPropAndPlayAnimation('p_campfire01x', 'campfire', 2000, 0.0, 2.0, -0.5, campfireObjects)
end

function onBrewingUse()
    createPropAndPlayAnimation('s_cul_cookfire01x', 'campfire', 2000, 0.0, 1.0, -0.5, brewingObjects)
end

RegisterNetEvent('fists-crafting:mortarpestle', onMortarPestleUse)
RegisterNetEvent('fists-crafting:campfire', onCampfireUse)
RegisterNetEvent('fists-crafting:campfireWithCauldron', onBrewingUse)




function requestPlayerJob()
    TriggerServerEvent('fists-crafting:GetJob')
end


RegisterNetEvent('fists-crafting:SendJob', function(job)
    print("Received job update: " .. job) 
    playerJob = job
end)


function handleCraftingStation(stationType, promptTitle, craftingEvent, locations, objects, checkJob)
    local PromptGroup = BccUtils.Prompt:SetupPromptGroup()
    local craftingPrompt = PromptGroup:RegisterPrompt(promptTitle, 0x4CC0E2FE, 1, 1, true, 'hold', {timedeventhash = "MEDIUM_TIMED_EVENT"})
    local someThresholdDistance = 3.0
    local lastJobRequestTime = 0

    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local nearStation = false


        if locations then
            for _, location in pairs(locations) do
                if #(playerCoords - location.coords) < someThresholdDistance then
                    nearStation = true
                    break
                end
            end
        elseif objects then
            for _, objCoords in ipairs(objects) do
                if #(playerCoords - objCoords) < someThresholdDistance then
                    nearStation = true
                    break
                end
            end
        end


        if nearStation and (GetGameTimer() - lastJobRequestTime > 30000) then
            requestPlayerJob()
            lastJobRequestTime = GetGameTimer()
        end

        local allowedToUse = not checkJob or (#Config.Jobs[stationType..'Jobs'] == 0) or table.includes(Config.Jobs[stationType..'Jobs'], playerJob)
        --print("Checking station: " .. stationType)


        if nearStation and allowedToUse then
            PromptGroup:ShowGroup(promptTitle)
            if craftingPrompt:HasCompleted() then
                --print("Prompt completed for " .. stationType)
                TriggerEvent(craftingEvent)
            end
        else
           -- PromptGroup:HideGroup()
        end
    end
end

Citizen.CreateThread(function()
handleCraftingStation("Smelter", "Open Smelting", 'smelting:openMenu', Config.Locations.SmeltingLocations, nil, true)
end)

Citizen.CreateThread(function()
handleCraftingStation("Crafting", "Start crafting", 'crafting:openMenu', Config.Locations.CraftingLocations, nil, true)
end)

Citizen.CreateThread(function()
handleCraftingStation("Carpentry", "Carpentry Station Nearby", 'carpentry:openMenu', Config.Locations.CarpentryLocations, nil, true)
end)

Citizen.CreateThread(function()
handleCraftingStation("Apothecary", "Mix Herbs with Mortar and Pestle", 'apothecary:openMenu', nil, mortarpestleObjects, true)
end)

Citizen.CreateThread(function()
handleCraftingStation("Cooking", "Start Cooking", 'cooking:openMenu', nil, campfireObjects, true)
end)

Citizen.CreateThread(function()
handleCraftingStation("Brewing", "Start Brewing", 'brewing:openMenu', nil, brewingObjects, true)
end)


RegisterCommand('smelting', function()
    print("Smelting command triggered") 
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

RegisterCommand('brewing', function()
    TriggerEvent('brewing:openMenu')
end, false)

RegisterCommand('carpentry', function()
    TriggerEvent('carpentry:openMenu')
end, false)



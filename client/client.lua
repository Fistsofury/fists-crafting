CreateThread(function() --PROMPT FOR SMELTING
    local PromptGroup = BccUtils.Prompt:SetupPromptGroup() 
    local smeltingPrompt = PromptGroup:RegisterPrompt("Open Smelting", 0x4CC0E2FE, 1, 1, true, 'hold', {timedeventhash = "MEDIUM_TIMED_EVENT"}) 
    while true do
        Wait(5)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local nearSmeltingLocation = false
        for key, location in pairs(Config.SmeltingLocations) do
            if #(playerCoords - location.coords) < someThresholdDistance then
                nearSmeltingLocation = true
                break
            end
        end
        if nearSmeltingLocation then
            PromptGroup:ShowGroup("Smelting Station Nearby")
            if smeltingPrompt:HasCompleted() then
                TriggerEvent('smelting:openMenu') -- Open the smelting menu
            end
        else
            smeltingPrompt:TogglePrompt(false)
        end
    end
end)

RegisterCommand('smelting', function()
    TriggerEvent('smelting:openMenu')
end, false)














RegisterNetEvent('smelting:openMenu')
AddEventHandler('smelting:openMenu', function()
    openSmeltingMenu()
end)
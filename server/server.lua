local VORPcore = {}
TriggerEvent("getCore", function(core)
    VORPcore = core
    print("VORPcore set:", VORPcore)
end)


RegisterNetEvent('fists-crafting:GetJob', function()
    local Character = VORPcore.getUser(source).getUsedCharacter
    local playerJob = Character.job
    TriggerClientEvent('fists-crafting:SendJob', source, playerJob)
end)


VorpInv = exports.vorp_inventory:vorp_inventoryApi() --still needed?

function CraftItem(source, recipe)
    local User = VORPcore.getUser(source)
    local Character = User.getUsedCharacter
    local identifier = Character.identifier
    local charidentifier = Character.charIdentifier
    if not recipe then
        TriggerClientEvent("vorp:TipRight", source, "This recipe doesn't exist.", 5000)
        return
    end
    exports.oxmysql:fetch('SELECT xp FROM crafting_xp WHERE charidentifier = ? AND category = ?', {charidentifier, recipe.category}, function(result) -- DB check for XP
        if #result == 0 then
            exports.oxmysql:execute('INSERT INTO crafting_xp (charidentifier, category, xp) VALUES (?, ?, 0)', {charidentifier, recipe.category}) --IF XP then update
        else
            local xp = result[1].xp
            if xp < recipe.xpRequirement then
                TriggerClientEvent("vorp:TipRight", source, "You don't have enough XP to craft this item.", 5000)
                return
            end
        end
        local missingItems = {}
        for _, ingredientInfo in pairs(recipe.requiredItems) do -- loop recipes
            local ingredient = ingredientInfo.item
            local quantity = tonumber(ingredientInfo.quantity)
            local playerItemCount = VorpInv.getItemCount(source, ingredient)
            
            if playerItemCount < quantity then
                table.insert(missingItems, ingredientInfo.label)  
            end
        end
        if #missingItems > 0 then --Missing items
            local missingItemsStr = table.concat(missingItems, ", ")
            TriggerClientEvent("vorp:TipRight", source, "You are missing the following ingredients: " .. missingItemsStr, 5000)
            return
        end
        if not exports.vorp_inventory:canCarryItem(source, recipe.name, 1) then --Space check
            TriggerClientEvent("vorp:TipRight", source, "You can't carry this item.", 5000)
            return
        end
        -- Add a delay for the crafting time
        Citizen.Wait(recipe.craftingTime * 1000)
        for _, ingredientInfo in pairs(recipe.requiredItems) do
            local ingredient = ingredientInfo.item
            local quantity = tonumber(ingredientInfo.quantity)
            VorpInv.subItem(source, ingredient, quantity)
            print("Item taken", ingredient, quantity)
        end
        VorpInv.addItem(source, recipe.name, 1)
        print("Item Added", recipe.name)
        exports.oxmysql:execute('UPDATE crafting_xp SET xp = xp + ? WHERE charidentifier = ? AND category = ?', {recipe.xpReward, charidentifier, recipe.category})
        TriggerClientEvent("vorp:TipRight", source, "You have crafted a " .. recipe.label .. ".", 5000)  
    end)
end

RegisterNetEvent('getCraftingXP') --For XP to be displayed in the menu & send
AddEventHandler('getCraftingXP', function(category)
    local _source = source
    local User = VORPcore.getUser(_source)
    local charidentifier = User.getUsedCharacter.charIdentifier
    exports.oxmysql:fetch('SELECT xp FROM crafting_xp WHERE charidentifier = ? AND category = ?', {charidentifier, category}, function(result)
        if result and #result > 0 then
            local xp = result[1].xp
            if config.debug then
                print("Fetched crafting XP for category: " .. category)
            end
            TriggerClientEvent('receiveCraftingXP', _source, category, xp)
        else
            if config.debug then
                print("No crafting XP record found for category: " .. category)
            end
            TriggerClientEvent('receiveCraftingXP', _source, category, 0)  
        end
    end)
end)

RegisterServerEvent('fists-crafting:startCraftingAnimation')
AddEventHandler('fists-crafting:startCraftingAnimation', function(duration)
    local _source = source
    TriggerClientEvent('playCraftingAnimation', _source, duration)
end)

RegisterServerEvent("fists-crafting:craftItem1")
AddEventHandler("fists-crafting:craftItem1", function(itemName)
    local _source = source
    local recipe = nil
    for _, r in pairs(Config.recipes) do
        if r.name == itemName then
            recipe = r
            break
        end
    end

    if recipe then
        CraftItem(_source, recipe)
    else
        print("Recipe not found:", itemName)
    end
end)

RegisterNetEvent('fists-crafting:getRecipes')
AddEventHandler('fists-crafting:getRecipes', function()
    if config.debug then
    print(" get recipes triggered")  --  print
    end
    local _source = source
    local recipesToSend = Config.recipes

    TriggerClientEvent('fists-crafting:receiveRecipes', source, recipesToSend)
end)

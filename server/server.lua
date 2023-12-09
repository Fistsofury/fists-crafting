local VORPcore = {} 

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

RegisterNetEvent('fists-crafting:GetJob', function()
    local Character = VORPcore.getUser(source).getUsedCharacter
    local playerJob = Character.job
    TriggerClientEvent('fists-crafting:SendJob', source, playerJob)
end)

--Apothecary function
exports.vorp_inventory:registerUsableItem("mortarpestle", function(data)
    local _source = data.source
 
    if Config.debug then
    print("Data received in registerUsableItem callback:", _source, item, label)
    end
    if label == nil then
        label = "Unknown Item"
        if Config.debug then
        print("Warning: label was nil. Setting default label.")
        end
    end
    TriggerClientEvent('vorp:TipRight', _source, "You used a " .. label, 4000)
    TriggerClientEvent('fists-crafting:mortarpestle', _source)
end)

-- Cooking
exports.vorp_inventory:registerUsableItem("campfire", function(data)
    local _source = data.source
 
    if Config.debug then
    print("Data received in registerUsableItem callback:", _source, item, label)
    end
    if label == nil then
        label = "Unknown Item"  
        if Config.debug then
        print("Warning: label was nil. Setting default label.")
        end
    end
    TriggerClientEvent('vorp:TipRight', _source, "You used a " .. label, 4000)
    TriggerClientEvent('fists-crafting:campfire', _source)
end)

--Brewing
exports.vorp_inventory:registerUsableItem("cauldron", function(data)
    local _source = data.source
 
    if Config.debug then
    print("Data received in registerUsableItem callback:", _source, item, label)
    end
    if label == nil then
        label = "Unknown Item"  
        if Config.debug then
        print("Warning: label was nil. Setting default label.")
        end
    end
    TriggerClientEvent('vorp:TipRight', _source, "You used a " .. label, 4000)
    TriggerClientEvent('fists-crafting:campfireWithCauldron', _source)
end)

 ---Apothecary Craft Item function
 RegisterNetEvent('fists-crafting:craftItem')
 AddEventHandler('fists-crafting:craftItem', function(recipeHeader, recipeName, quantity)
     local source = source
     local recipeList = Config.Recipes[recipeHeader .. "Recipes"]
     if not recipeList then
         VORPcore.NotifyRightTip(source, "Invalid recipe header: " .. recipeHeader, 4000)
         return
     end
 
     local recipe = nil
     for _, r in ipairs(recipeList) do
         if r.name == recipeName then
             recipe = r
             break
         end
     end
 
     if not recipe then
         VORPcore.NotifyRightTip(source, "No recipe found for: " .. recipeName, 4000)
         return
     end
     local User = VORPcore.getUser(source)
     local Character = User.getUsedCharacter
     local charidentifier = Character.charIdentifier
 
     exports.oxmysql:fetch('SELECT * FROM CharacterCraftingXP WHERE CharIdentifier = ? AND RecipeHeader = ? AND Category = ?', {charidentifier, recipeHeader, recipe.category}, function(result)
         if #result == 0 then
             exports.oxmysql:execute('INSERT INTO CharacterCraftingXP (CharIdentifier, RecipeHeader, Category, XP) VALUES (?, ?, ?, 0)', {charidentifier, recipeHeader, recipe.category})
         end
 
         if recipe.xpRequirement > 0 then
             local xp = result[1] and result[1].XP or 0
             if xp < recipe.xpRequirement then
                 VORPcore.NotifyRightTip(source, "You do not have enough XP to craft this item.", 4000)
                 return
             end
         end
         local requiredItems = recipe.requiredItems
         for _, ingredient in pairs(requiredItems) do
             local itemCount = exports.vorp_inventory:getItemCount(source, nil, ingredient.item)
             if itemCount < ingredient.quantity * quantity then
                 VORPcore.NotifyRightTip(source, "Insufficient Ingredients", 4000)
                 return
             end
         end
         local canCarry = exports.vorp_inventory:canCarryItem(source, recipe.name, quantity)
         if not canCarry then
             VORPcore.NotifyRightTip(source, "Inventory Full", 4000)
             return
         end
         for _, ingredient in pairs(requiredItems) do
             exports.vorp_inventory:subItem(source, ingredient.item, ingredient.quantity * quantity)
         end
         exports.vorp_inventory:addItem(source, recipe.name, quantity)
         VORPcore.NotifyRightTip(source, "Crafting Successful", 4000)
         exports.oxmysql:execute('UPDATE CharacterCraftingXP SET XP = XP + ? WHERE CharIdentifier = ? AND RecipeHeader = ? AND Category = ?', {recipe.xpReward, charidentifier, recipeHeader, recipe.category})
     end)
 end)
 
 


 RegisterNetEvent('getCraftingXP') -- For XP to be displayed in the menu & send
 AddEventHandler('getCraftingXP', function(category)
     local _source = source
     local User = VORPcore.getUser(_source)
     local charidentifier = User.getUsedCharacter.charIdentifier
 
     exports.oxmysql:fetch('SELECT xp FROM CharacterCraftingXP WHERE CharIdentifier = ? AND RecipeHeader = ? AND Category = ?', {charidentifier, 'Apothecary', category}, function(result)
         local xp = 0
         if result and #result > 0 then
             xp = result[1].xp
         end
         TriggerClientEvent('receiveCraftingXP', _source, 'Apothecary', category, xp)
     end)
 end)
 
 
RegisterServerEvent('fists-crafting:startCraftingAnimation')
AddEventHandler('fists-crafting:startCraftingAnimation', function(duration)
    local _source = source
    TriggerClientEvent('playCraftingAnimation', _source, duration)
end)


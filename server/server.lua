local VORPcore = {} 

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

BccUtils = exports['bcc-utils'].initiate()

RegisterNetEvent('fists-crafting:GetJob', function()
    local Character = VORPcore.getUser(source).getUsedCharacter
    local playerJob = Character.job
    TriggerClientEvent('fists-crafting:SendJob', source, playerJob)
end)

---Craft Item function
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
        local totalXPAwarded = recipe.xpReward * quantity
        exports.vorp_inventory:addItem(source, recipe.name, quantity)
        VORPcore.NotifyRightTip(source, "Crafting Successful", 4000)
        exports.oxmysql:execute('UPDATE CharacterCraftingXP SET XP = XP + ? WHERE CharIdentifier = ? AND RecipeHeader = ? AND Category = ?', {totalXPAwarded, charidentifier, recipeHeader, recipe.category})
    end)
end)

RegisterNetEvent("fists-crafting:addCraftItem")
AddEventHandler("fists-crafting:addCraftItem", function(stationType)
   local _source = source
   local User = VORPcore.getUser(_source)
   local Character = User.getUsedCharacter
   if stationType == 'crafting' then
       exports.vorp_inventory:addItem(_source, 'campfire', 1)  
   elseif stationType == 'apothecary' then
       exports.vorp_inventory:addItem(_source, 'mortarpestle', 1)  
   elseif stationType == 'brewing' then
       exports.vorp_inventory:addItem(_source, 'cauldron', 1)  
   end

end)

RegisterServerEvent('fists-crafting:startCraftingAnimation')
AddEventHandler('fists-crafting:startCraftingAnimation', function(duration)
   local _source = source
   TriggerClientEvent('playCraftingAnimation', _source, duration)
end)

local function handleUsableItem(source, itemName, triggerEvent)
    if Config.debug then
        print("Using item:", itemName)
    end
    exports.vorp_inventory:subItem(source, itemName, 1)
    TriggerClientEvent('vorp:TipRight', source, "You used a " .. itemName, 4000)
    TriggerClientEvent(triggerEvent, source)
end

exports.vorp_inventory:registerUsableItem("mortarpestle", function(data)
    handleUsableItem(data.source, "mortarpestle", 'fists-crafting:mortarpestle')
end)

exports.vorp_inventory:registerUsableItem("cookingcampfire", function(data)
    handleUsableItem(data.source, "campfire", 'fists-crafting:campfire')
end)

exports.vorp_inventory:registerUsableItem("cauldron", function(data)
    handleUsableItem(data.source, "cauldron", 'fists-crafting:campfireWithCauldron')
end)

 

--VERSION CHECK
local repo = 'https://github.com/Fistsofury/fists-crafting'
BccUtils.Versioner.checkRelease(GetCurrentResourceName(), repo)
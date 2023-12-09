FeatherMenu = exports['feather-menu'].initiate()

VorpCore = {}
TriggerEvent("getCore", function(core)
    VorpCore = core
end)
BccUtils = exports['bcc-utils'].initiate()

--Group recipes
function groupRecipesByCategory(recipes)
    local categories = {}
    for _, recipe in ipairs(recipes) do
        if not categories[recipe.category] then
            categories[recipe.category] = {}
        end
        table.insert(categories[recipe.category], recipe)
    end
    return categories
end

-- Utility function to check if a table includes a value
function table.includes(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

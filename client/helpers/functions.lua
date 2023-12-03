FeatherMenu = exports['feather-menu'].initiate()
VorpCore = {}
TriggerEvent("getCore", function(core)
    VorpCore = core
end)
BccUtils = exports['bcc-utils'].initiate()

function groupRecipesByCategory(recipes)
    local categories = {}
    for key, recipe in ipairs(recipes) do
        if not categories[recipe.category] then
            categories[recipe.category] = {}
        end
        table.insert(categories[recipe.category], recipe)
    end
    return categories
end
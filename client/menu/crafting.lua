local craftingCategories = groupRecipesByCategory(Config.Recipes.CraftingRecipes)


function openCraftingMenu()
    local CraftingMenu = FeatherMenu:RegisterMenu('crafting:menu', {
        style = {
            ['background-image'] = 'url("nui://fists-crafting/fists-background.png")',
        },
        draggable = true
    })

    local mainPage = CraftingMenu:RegisterPage('main:page')
    mainPage:RegisterElement('header', { value = 'Crafting Menu', slot = "header" })

    for category, recipes in pairs(craftingCategories) do
        local categoryPage = CraftingMenu:RegisterPage('category:' .. category)
        categoryPage:RegisterElement('header', { value = category })

        for key, recipe in ipairs(recipes) do
            local recipePage = CraftingMenu:RegisterPage('recipe:' .. recipe.name)
            recipePage:RegisterElement('header', { value = recipe.label })

            local ingredientsList = "Ingredients:\n"
            for key, ingredient in pairs(recipe.requiredItems) do
                ingredientsList = ingredientsList .. ingredient.label .. " x" .. ingredient.quantity .. "\n"
            end
            recipePage:RegisterElement('textdisplay', { value = ingredientsList })

            local maxQuantity = Config.CraftingQuantity or 10  -- Default to 10 if not specified
            local quantity = 1
            recipePage:RegisterElement('slider', {
                label = "Quantity",
                start = 1,
                min = 1,
                max = maxQuantity,
                steps = 1, 
            }, function(data)
                quantity = data.value
                if config.debug then
                    print("Smelting " .. recipe.name .. " x" .. qunatity)
                end
            end)

            recipePage:RegisterElement('button', {
                label = "Craft",
            }, function()
                if config.debug then
                print("Crafting " .. recipe.name)
                end
            end)

            recipePage:RegisterElement('button', {
                label = "Back",
            }, function()
                categoryPage:RouteTo()
            end)

            categoryPage:RegisterElement('button', {
                label = recipe.label,
            }, function()
                recipePage:RouteTo()
            end)
        end

        mainPage:RegisterElement('button', {
            label = category,
        }, function()
            categoryPage:RouteTo()
        end)
    end

    CraftingMenu:Open({ startupPage = mainPage })
end

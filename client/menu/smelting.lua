local smeltingCategories = groupRecipesByCategory(Config.Recipes.SmeltingRecipes)


function openSmeltingMenu()
    local SmeltingMenu = FeatherMenu:RegisterMenu('smelting:menu', {
        style = {
            ['background-image'] = 'url("nui://fists-crafting/fists-background.png")',
        },
        draggable = true
    })

    local mainPage = SmeltingMenu:RegisterPage('main:page')
    mainPage:RegisterElement('header', { value = 'Smelting Menu', slot = "header" })

    for category, recipes in pairs(smeltingCategories) do
        local categoryPage = SmeltingMenu:RegisterPage('category:' .. category)
        categoryPage:RegisterElement('header', { value = category })

        for key, recipe in ipairs(recipes) do
            local recipePage = SmeltingMenu:RegisterPage('recipe:' .. recipe.name)
            recipePage:RegisterElement('header', { value = recipe.label })

            local ingredientsList = "Ingredients:\n"
            for key, ingredient in pairs(recipe.requiredItems) do
                ingredientsList = ingredientsList .. ingredient.label .. " x" .. ingredient.quantity .. "\n"
            end
            recipePage:RegisterElement('textdisplay', { value = ingredientsList })

            recipePage:RegisterElement('button', {
                label = "Smelt",
            }, function()
                if config.debug then
                print("Smelting " .. recipe.name)
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

    SmeltingMenu:Open({ startupPage = mainPage })
end

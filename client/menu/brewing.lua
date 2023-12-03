local brewingCategories = groupRecipesByCategory(Config.Recipes.BrewingRecipes)


function openBrewingMenu()
    local BrewingMenu = FeatherMenu:RegisterMenu('brewing:menu', {
        style = {
            ['background-image'] = 'url("nui://fists-crafting/fists-background.png")',
        },
        draggable = true
    })

    local mainPage = BrewingMenu:RegisterPage('main:page')
    mainPage:RegisterElement('header', { value = 'Brewing Menu', slot = "header" })

    for category, recipes in pairs(brewingCategories) do
        local categoryPage = BrewingMenu:RegisterPage('category:' .. category)
        categoryPage:RegisterElement('header', { value = category })

        for key, recipe in ipairs(recipes) do
            local recipePage = BrewingMenu:RegisterPage('recipe:' .. recipe.name)
            recipePage:RegisterElement('header', { value = recipe.label })

            local ingredientsList = "Ingredients:\n"
            for key, ingredient in pairs(recipe.requiredItems) do
                ingredientsList = ingredientsList .. ingredient.label .. " x" .. ingredient.quantity .. "\n"
            end
            recipePage:RegisterElement('textdisplay', { value = ingredientsList })

            recipePage:RegisterElement('button', {
                label = "Brew",
            }, function()
                if config.debug then
                print("Brew " .. recipe.name)
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

    BrewingMenu:Open({ startupPage = mainPage })
end

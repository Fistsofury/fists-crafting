local apothecaryCategories = groupRecipesByCategory(Config.Recipes.ApothecaryRecipes)


function openApothecaryMenu()
    local ApothecaryMenu = FeatherMenu:RegisterMenu('apothecary:menu', {
        style = {
            ['background-image'] = 'url("nui://fists-crafting/fists-background.png")',
        },
        draggable = true
    })

    local mainPage = ApothecaryMenu:RegisterPage('main:page')
    mainPage:RegisterElement('header', { value = 'Crafting Menu', slot = "header" })

    for category, recipes in pairs(apothecaryCategories) do
        local categoryPage = ApothecaryMenu:RegisterPage('category:' .. category)
        categoryPage:RegisterElement('header', { value = category })

        for key, recipe in ipairs(recipes) do
            local recipePage = ApothecaryMenu:RegisterPage('recipe:' .. recipe.name)
            recipePage:RegisterElement('header', { value = recipe.label })

            local ingredientsList = "Ingredients:\n"
            for key, ingredient in pairs(recipe.requiredItems) do
                ingredientsList = ingredientsList .. ingredient.label .. " x" .. ingredient.quantity .. "\n"
            end
            recipePage:RegisterElement('textdisplay', { value = ingredientsList })

            recipePage:RegisterElement('button', {
                label = "Mix",
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

    ApothecaryMenu:Open({ startupPage = mainPage })
end

local apothecaryCategories = groupRecipesByCategory(Config.Recipes.ApothecaryRecipes)


function openApothecaryMenu()
    local ApothecaryMenu = FeatherMenu:RegisterMenu('apothecary:menu', {
        style = {
            ['background-image'] = 'url("nui://fists-crafting/fists-background.png")',
        },
        draggable = true
    })

    local mainPage = ApothecaryMenu:RegisterPage('main:page')
    mainPage:RegisterElement('header', { value = 'Mixing Menu', slot = "header" })

    for category, recipes in pairs(apothecaryCategories) do
        local categoryPage = ApothecaryMenu:RegisterPage('category:' .. category)
        categoryPage:RegisterElement('header', { value = category })

        for key, recipe in ipairs(recipes) do
            local recipePage = ApothecaryMenu:RegisterPage('recipe:' .. recipe.name)
            recipePage:RegisterElement('header', { value = recipe.label })
            categoryPage:RegisterElement('button', {
                label = "Back",
                slot = "footer",
            }, function()
                mainPage:RouteTo()
            end)


            local ingredientsList = "Ingredients:\n"
            for key, ingredient in pairs(recipe.requiredItems) do
                ingredientsList = ingredientsList .. ingredient.label .. " x" .. ingredient.quantity .. "\n"
            end
            recipePage:RegisterElement('textdisplay', { value = ingredientsList })

            local maxQuantity = Config.ApothecaryQuantity or 10  -- Default to 10 if not specified
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
                    print("Mixing " .. recipe.name .. " x" .. qunatity)
                end
            end)

            recipePage:RegisterElement('button', {
                label = "Mix",
            }, function()
                if config.debug then
                print("Mixing " .. recipe.name)
                end
            end)

            recipePage:RegisterElement('button', {
                label = "Back",
            }, function()
                mainPage:RouteTo()
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
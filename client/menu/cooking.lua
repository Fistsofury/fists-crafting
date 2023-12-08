local cookingCategories = groupRecipesByCategory(Config.Recipes.CookingRecipes)


function openCookingMenu()
    local cookingMenu = FeatherMenu:RegisterMenu('cooking:menu', {
        style = {
            ['background-image'] = 'url("nui://fists-crafting/fists-background.png")',
        },
        draggable = true
    })

    local mainPage = cookingMenu:RegisterPage('main:page')
    mainPage:RegisterElement('header', { value = 'Cooking Menu', slot = "header" })

    for category, recipes in pairs(cookingCategories) do
        local categoryPage = cookingMenu:RegisterPage('category:' .. category)
        categoryPage:RegisterElement('header', { value = category })

        for key, recipe in ipairs(recipes) do
            local recipePage = cookingMenu:RegisterPage('recipe:' .. recipe.name)
            recipePage:RegisterElement('header', { value = recipe.label })

            local ingredientsList = "Ingredients:\n"
            for key, ingredient in pairs(recipe.requiredItems) do
                ingredientsList = ingredientsList .. ingredient.label .. " x" .. ingredient.quantity .. "\n"
            end
            recipePage:RegisterElement('textdisplay', { value = ingredientsList })

            local maxQuantity = Config.CookingQuantity or 10  -- Default to 10 if not specified
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
                    print("Cooking " .. recipe.name .. " x" .. qunatity)
                end
            end)

            recipePage:RegisterElement('button', {
                label = "Cook",
            }, function()
                if config.debug then
                print("Cooking " .. recipe.name)
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

    cookingMenu:Open({ startupPage = mainPage })
end

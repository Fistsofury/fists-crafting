local brewingCategories = groupRecipesByCategory(Config.Recipes.BrewingRecipes)


function openBrewingMenu()
    local brewingMenu = FeatherMenu:RegisterMenu('brewing:menu', {
        style = {
            ['background-image'] = 'url("nui://fists-crafting/fists-background.png")',
        },
        draggable = true
    })

    local mainPage = brewingMenu:RegisterPage('main:page')
    mainPage:RegisterElement('header', { value = 'Brewing Menu', slot = "header" })

    for category, recipes in pairs(brewingCategories) do
        local categoryPage = brewingMenu:RegisterPage('category:' .. category)
        categoryPage:RegisterElement('header', { value = category })

        for key, recipe in ipairs(recipes) do
            local recipePage = brewingMenu:RegisterPage('recipe:' .. recipe.name)
            recipePage:RegisterElement('header', { value = recipe.label })

            local ingredientsList = "Ingredients:\n"
            for _, ingredient in pairs(recipe.requiredItems) do
                ingredientsList = ingredientsList .. ingredient.label .. " x" .. ingredient.quantity .. "\n"
            end
            recipePage:RegisterElement('textdisplay', { value = ingredientsList })

            local maxQuantity = Config.BrewingQuantity or 10
            local quantity = 1
            recipePage:RegisterElement('slider', {
                label = "Quantity",
                start = 1,
                min = 1,
                max = maxQuantity,
                steps = 1, 
            }, function(data)
                quantity = data.value
            end)

            -- Closure to capture the current recipe
            local function brewButtonFunction()
                print("Brewing button pressed: " .. recipe.name, "x" .. quantity)
                TriggerServerEvent('fists-crafting:craftItem', 'Brewing', recipe.name, quantity)
            end

            recipePage:RegisterElement('button', { label = "Brew" }, brewButtonFunction)

            categoryPage:RegisterElement('button', {
                label = recipe.label,
            }, function()
                recipePage:RouteTo()
            end)

            recipePage:RegisterElement('button', { label = "Back" }, function()
                categoryPage:RouteTo()
            end)
        end

        categoryPage:RegisterElement('button', {
            label = "Back",
            slot = "footer",
        }, function()
            mainPage:RouteTo()
        end)

        mainPage:RegisterElement('button', {
            label = category,
        }, function()
            categoryPage:RouteTo()
        end)
    end

    brewingMenu:Open({ startupPage = mainPage })
end


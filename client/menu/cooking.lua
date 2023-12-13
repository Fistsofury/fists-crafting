local cookingCategories = groupRecipesByCategory(Config.Recipes.CookingRecipes)


function openCookingMenu()
    local cookingMenu = FeatherMenu:RegisterMenu('cooking:menu', {
        style = {
            --['background-image'] = 'url("nui://fists-crafting/fists-background.png")',
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
            for _, ingredient in pairs(recipe.requiredItems) do
                ingredientsList = ingredientsList .. ingredient.label .. " x" .. ingredient.quantity .. "\n"
            end
            recipePage:RegisterElement('textdisplay', { value = ingredientsList })

            local maxQuantity = Config.CookingQuantity or 10
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
            local function cookButtonFunction()
                if Config.debug then
                print("Cooking button pressed: " .. recipe.name, "x" .. quantity)
                end
                progressbar.start("Cooking " .. recipe.label, recipe.craftingTime, function ()
                    TriggerServerEvent('fists-crafting:craftItem', 'Cooking', recipe.name, quantity)
                end, 'circle')
            end

            recipePage:RegisterElement('button', { label = "Cook" }, cookButtonFunction)

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

        mainPage:RegisterElement('button', {
            label = "Pick Up Campfire",
            slot = "footer",
        }, function()
            removePlacedObject('cooking')
            cookingMenu:Close()
        end)
    end

    cookingMenu:Open({ startupPage = mainPage })
end


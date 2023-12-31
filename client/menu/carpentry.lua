local carpentryCategories = groupRecipesByCategory(Config.Recipes.CarpentryRecipes)


function openCarpentryMenu()
    local carpentryMenu = FeatherMenu:RegisterMenu('carpentry:menu', {
        style = {
            --['background-image'] = 'url("nui://fists-crafting/fists-background.png")',
        },
        draggable = true
    })

    local mainPage = carpentryMenu:RegisterPage('main:page')
    mainPage:RegisterElement('header', { value = 'Smelt Menu', slot = "header" })

    for category, recipes in pairs(carpentryCategories) do
        local categoryPage = carpentryMenu:RegisterPage('category:' .. category)
        categoryPage:RegisterElement('header', { value = category })

        for key, recipe in ipairs(recipes) do
            local recipePage = carpentryMenu:RegisterPage('recipe:' .. recipe.name)
            recipePage:RegisterElement('header', { value = recipe.label })

            local ingredientsList = "Ingredients:\n"
            for _, ingredient in pairs(recipe.requiredItems) do
                ingredientsList = ingredientsList .. ingredient.label .. " x" .. ingredient.quantity .. "\n"
            end
            recipePage:RegisterElement('textdisplay', { value = ingredientsList })

            local maxQuantity = Config.CarpentryQuantity or 10
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
            local function buildButtonFunction()
                if Config.debug then
                print("Build button pressed: " .. recipe.name, "x" .. quantity)
                end
                progressbar.start("Building " .. recipe.label, recipe.craftingTime, function ()
                    TriggerServerEvent('fists-crafting:craftItem', 'Carpentry', recipe.name, quantity)
                end, 'circle')
            end

            recipePage:RegisterElement('button', { label = "Build" }, buildButtonFunction)

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

    carpentryMenu:Open({ startupPage = mainPage })
end


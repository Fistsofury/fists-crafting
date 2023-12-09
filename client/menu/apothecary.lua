local apothecaryCategories = groupRecipesByCategory(Config.Recipes.ApothecaryRecipes)
local categoryXP = {}

function openApothecaryMenu()
    local apothecaryMenu = FeatherMenu:RegisterMenu('apothecary:menu', {
        style = {
            ['background-image'] = 'url("nui://fists-crafting/fists-background.png")',
        },
        draggable = true
    })

    local mainPage = apothecaryMenu:RegisterPage('main:page')
    mainPage:RegisterElement('header', { value = 'Mixing Menu', slot = "header" })

    for category, recipes in pairs(apothecaryCategories) do
        local categoryPage = apothecaryMenu:RegisterPage('category:' .. category)
        categoryPage:RegisterElement('header', { value = category })

        for key, recipe in ipairs(recipes) do
            local recipePage = apothecaryMenu:RegisterPage('recipe:' .. recipe.name)
            recipePage:RegisterElement('header', { value = recipe.label })

            local xpDisplayValue = categoryXP[category] and ("Your XP: " .. categoryXP[category]) or "Loading XP..."
            recipePage:RegisterElement('textdisplay', { value = xpDisplayValue })


            local ingredientsList = "Ingredients:\n"
            for _, ingredient in pairs(recipe.requiredItems) do
                ingredientsList = ingredientsList .. ingredient.label .. " x" .. ingredient.quantity .. "\n"
            end
            recipePage:RegisterElement('textdisplay', { value = ingredientsList })

            local maxQuantity = Config.ApothecaryQuantity or 10
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
            local function mixButtonFunction()
                print("Mixing button pressed: " .. recipe.name, "x" .. quantity)
                TriggerServerEvent('fists-crafting:craftItem', 'Apothecary', recipe.name, quantity)
            end

            recipePage:RegisterElement('button', { label = "Mix" }, mixButtonFunction)

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

    apothecaryMenu:Open({ startupPage = mainPage })
end

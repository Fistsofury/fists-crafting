RegisterNetEvent('smelting:openMenu')
AddEventHandler('smelting:openMenu', function()
    openSmeltingMenu()
end)

function openSmeltingMenu()
    local SmeltingMenu = FeatherMenu:RegisterMenu('smelting:menu', {
        style = {
            ['background-image'] = 'url("nui://fists-crafting/fists-background.png")',
        },
        draggable = true
    })

    local mainPage = SmeltingMenu:RegisterPage('main:page')
    mainPage:RegisterElement('header', { value = 'Smelting Menu', slot = "header" })

    for _, recipe in pairs(Config.Smeltingrecipes) do
        local recipePage = SmeltingMenu:RegisterPage(recipe.name)
        recipePage:RegisterElement('header', { value = recipe.label, slot = "header" })

        local ingredientsList = "Ingredients:\n"
        for _, ingredient in pairs(recipe.requiredItems) do
            ingredientsList = ingredientsList .. ingredient.label .. " x" .. ingredient.quantity .. "\n"
        end

        recipePage:RegisterElement('textdisplay', { value = ingredientsList, slot = "content" })
        recipePage:RegisterElement('button', { label = "Craft", slot = "footer" }, function()
        end)

        mainPage:RegisterElement('button', { label = recipe.label, slot = "content" }, function()
            recipePage:RouteTo()
        end)
    end

    SmeltingMenu:Open({ startupPage = mainPage })
end
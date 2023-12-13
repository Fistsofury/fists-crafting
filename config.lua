Config = {
    debug = true,  -- Set to false to disable debug messages
    
    ApothecaryQuantity = 5, -- Maximum quantity on the crafting slider in each menu
    BrewingQuantity = 10,
    CarpentryQuantity = 10,
    CookingQuantity = 10,
    CraftingQuantity = 20,
    SmelterQuantity = 50,

    adminCommands = true, -- True if you want to test crafting with the commands line 168+ in client.lua

    lockToXP = true, -- Currently in test not working in this version.

    Jobs = {
        SmelterJobs = {
            --"carpenter",
            --"woodworker"
            -- Add more jobs here or remove all jobs to make it pass the job check I.E not require a job.
        },

        CarpentryJobs = {

        },

        CraftingJobs = {

        },

        ApothecaryJobs = {
            --"Sheriff"
        },

        BrewingJobs = {

        },

        CookingJobs = {

        },
    },

    Locations = {
        SmeltingLocations = {
            {
                name = "Strawberry",
                coords = vector3(-1820.0, -567.89, 156.0)
            } -- Add more locations here
        },

        CarpentryLocations = {
            {
                name = "Blackwater Carpentry",
                coords = vector3(-867.09, -1286.39, 43.1)
            }, -- Add more locations here
        },

        CraftingLocations = {
            {
                name = "Blackwater",
                coords = vector3(-870.36, -1389.12, 43.53)
            } -- Add more locations here
        }
    },

    Recipes = {
        CraftingRecipes = { -- For crafting locations
            {
                name = "consumable_breakfast", -- db item name
                label = "Breakfast",  --Label that you want to appear on the menu
                category = "Food",  --what Category, changable to whatever you want
                requiredItems = { 
                    {item = "meat", label = "Meat", quantity = 2},
                    {item = "salt", label = "Salt", quantity = 1}
                },
                xpRequirement = 0, --Amount of xp needed to craft
                xpReward = 1, --Amount of xp awarded for a succesful craft
                craftingTime = 5000 -- time in milliseconds , 5 seconds
            },
        },
        ApothecaryRecipes = { --for mixing potions pestle and mortar item
            {
                name = "consumable_game", -- db item name
                label = "Potion 1",  --Label that you want to appear on the menu
                category = "Medicine",  --what Category, changable to whatever you want
                requiredItems = { 
                    {item = "corn", label = "Corn", quantity = 2},
                    {item = "copper", label = "Copper", quantity = 1}
                },
                xpRequirement = 0, --Amount of xp needed to craft
                xpReward = 2, --Amount of xp awarded for a succesful craft
                craftingTime = 5000 -- time in milliseconds , 5 seconds
            },
        },
        
        SmeltingRecipes = { --Smelting locations
            {
                name = "goldbar", -- db item name
                label = "Gold Bar",  --Label that you want to appear on the menu
                category = "Ore",  --what Category, changable to whatever you want
                requiredItems = {
                    {item = "gold_nugget", label = "Gold Nugget", quantity = 8},
                },
                xpRequirement = 0, --Amount of xp needed to craft
                xpReward = 1, --Amount of xp awarded for a succesful craft
                craftingTime = 5000 -- time in milliseconds , 5 seconds
            },
            {
                name = "button", -- db item name
                label = "Example 1",  --Label that you want to appear on the menu
                category = "Example Category 2",  --what Category, changable to whatever you want
                requiredItems = {
                    {item = "gold_nugget", label = "Gold Nugget", quantity = 8},
                },
                xpRequirement = 0, --Amount of xp needed to craft
                xpReward = 1, --Amount of xp awarded for a succesful craft
                craftingTime = 5000 -- time in milliseconds , 5 seconds
            },
            {
                name = "button2", -- db item name
                label = "Example 2",  --Label that you want to appear on the menu
                category = "Ore",  --what Category, changable to whatever you want
                requiredItems = {
                    {item = "gold_nugget", label = "Gold Nugget", quantity = 8},
                },
                xpRequirement = 0, --Amount of xp needed to craft
                xpReward = 1, --Amount of xp awarded for a succesful craft
                craftingTime = 5000 -- time in milliseconds , 5 seconds
            },

        },
        CarpentryRecipes = { --Carpentry locations
            {
                name = "wooden_bench", -- db item name
                label = "Wooden Bench",  --Label that you want to appear on the menu
                category = "Furniture",  --what Category, changable to whatever you want
                requiredItems = { 
                    {item = "nails", label = "Nails", quantity = 20},
                    {item = "wooden_boards", label = "Wooden Boards", quantity = 8}
                },
                xpRequirement = 10, --Amount of xp needed to craft
                xpReward = 0, --Amount of xp awarded for a succesful craft
                craftingTime = 5000 -- time in milliseconds , 5 seconds
            }
        },
        BrewingRecipes = {-- brewing prop based 
            {
                name = "ginsengtea", -- db item name
                label = "Ginseng Tea",  --Label that you want to appear on the menu
                category = "Tea",  --what Category, changable to whatever you want
                useprop = "",
                requiredItems = {
                    {item = "Alaskan_Ginseng", label = "Alaskan Ginseng", quantity = 1},
                    {item = "water", label = "Salt", quantity = 1}
                },
                xpRequirement = 10, --Amount of xp needed to craft
                xpReward = 0, --Amount of xp awarded for a succesful craft
                craftingTime = 5000 -- time in milliseconds , 5 seconds
            }
        },
        CookingRecipes = {--cooking campfire based
            {
                name = "consumable_breakfast", -- db item name
                label = "Breakfast",  --Label that you want to appear on the menu
                category = "Food",  --what Category, changable to whatever you want
                job = "", --list of jobs you want to have access to the recipe
                useprop = "",
                requiredItems = {
                    {item = "meat", label = "Meat", quantity = 2},
                    {item = "salt", label = "Salt", quantity = 1}
                },
                xpRequirement = 0, --Amount of xp needed to craft
                xpReward = 1, --Amount of xp awarded for a succesful craft
                craftingTime = 5000 -- time in milliseconds , 5 seconds
            }
        }
    }
}
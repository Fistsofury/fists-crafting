Config = {
    debug = true  -- Set to false to disable debug messages

    Config.SmelterJobs = {
        "BWBlacksmith",
        "woodworker",
        -- Add more jobs here or remove all jobs to make it pass the job check I.E not require a job.
    }
    
    Config.CarpentryJobs = {
        "carpenter",
        "woodworker",
        -- Add more jobs here or remove all jobs to make it pass the job check I.E not require a job.
    }
    
    Config.CraftingJobs = {
        "carpenter",
        "woodworker",
        -- Add more jobs here or remove all jobs to make it pass the job check I.E not require a job.
    }
    
    Config.ApothecaryJobs = {
        "carpenter",
        "woodworker",
        -- Add more jobs here or remove all jobs to make it pass the job check I.E not require a job.
    }
    
    Config.BrewingJobs = {
        "carpenter",
        "woodworker",
        -- Add more jobs here or remove all jobs to make it pass the job check I.E not require a job.
    }
    
    Config.CookingJobs = {
        "carpenter",
        "woodworker",
        -- Add more jobs here or remove all jobs to make it pass the job check I.E not require a job.
    }
    
    Config.SmeltingLocations = {
        {
            name = "Strawberry",
            coords = vector3(-1820.0, -567.89, 156.0),
        }
     -- Add more locations here
    }
    
    Config.CarpentryLocations = {
        {
            name = "Blackwater Carpentry",
            coords = vector3(-867.09, -1286.39, 43.1),
        },
        -- Add more locations here
    }
    
    
    Config.CraftingLocations = {
        {
            
            name = "Blackwater", 
            coords = vector3(-870.36, -1389.12, 43.53),
        }
     -- Add more locations here
    }
    
}






Config.Craftingrecipes = { --CRAFTING RECIPES
    { 
        name = "consumable_breakfast", -- db item name
        label = "Breakfast",  --Label that you want to appear on the menu
        category = "Food",  --what Category, changable to whatever you want
        requiredItems = { 
            {item = "meat", label = "Meat", quantity = 2},  
            {item = "salt", label = "Salt", quantity = 1} 
        }, 
        xpRequirement = 10, --Amount of xp needed to craft
        xpReward = 0, --Amount of xp awarded for a succesful craft
        --craftingTime = 5 -- time in seconds it takes to craft
    },

   
    -- Add more recipes here
}

Config.Apothecaryrecipes = { --APOTHECARY RECIPES
    { 
        name = "consumable_breakfast", -- db item name
        label = "Breakfast",  --Label that you want to appear on the menu
        category = "Food",  --what Category, changable to whatever you want
        requiredItems = { 
            {item = "meat", label = "Meat", quantity = 2},  
            {item = "salt", label = "Salt", quantity = 1} 
        }, 
        xpRequirement = 10, --Amount of xp needed to craft
        xpReward = 0, --Amount of xp awarded for a succesful craft
        --craftingTime = 5 -- time in seconds it takes to craft
    },  
    -- Add more recipes here
}

Config.Smeltingrecipes = { --SMELTING RECIPES
    { 
        name = "goldbar", -- db item name
        label = "Gold Bar",  --Label that you want to appear on the menu
        category = "Ore",  --what Category, changable to whatever you want
        requiredItems = { 
            {item = "gold_nugget", label = "Gold Nugget", quantity = 8},  
        }, 
        xpRequirement = 2, --Amount of xp needed to craft
        xpReward = 0, --Amount of xp awarded for a succesful craft
        --craftingTime = 5 -- time in seconds it takes to craft
    },  
    -- Add more recipes here
}

Config.Carpentryrecipes = { --Carpentry Recipes
    -- Food
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
        --craftingTime = 5 -- time in seconds it takes to craft
    },  
    -- Add more recipes here
}

Config.Brewingrecipes = { -- BREWING RECIPES
    -- Food
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
        --craftingTime = 5 -- time in seconds it takes to craft
    },  
    -- Add more recipes here
}

Config.Cookingrecipes = { -- COOKING RECIPES
    -- Food
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
        xpRequirement = 10, --Amount of xp needed to craft
        xpReward = 0, --Amount of xp awarded for a succesful craft
        --craftingTime = 5 -- time in seconds it takes to craft
    },  
    -- Add more recipes here
}





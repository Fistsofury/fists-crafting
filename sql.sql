CREATE TABLE CharacterCraftingXP (
    EntryID INT AUTO_INCREMENT PRIMARY KEY,
    CharIdentifier VARCHAR(255) NOT NULL, 
    RecipeHeader VARCHAR(255) NOT NULL,   
    Category VARCHAR(255) NOT NULL,       
    XP INT NOT NULL DEFAULT 0             
);




INSERT INTO `items`(`item`, `label`, `limit`, `can_remove`, `type`, `usable`)
VALUES
    ('cauldron', 'Cauldron', 5, 1, 'item_standard', 0),
     ('cookingcampfire', 'Campfire', 5, 1, 'item_standard', 0),
    ('mortarpestle', 'Mortar and Pestle', 5, 1, 'item_standard', 0);

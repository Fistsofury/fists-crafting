CREATE TABLE CharacterCraftingXP (
    EntryID INT AUTO_INCREMENT PRIMARY KEY,
    CharIdentifier VARCHAR(255) NOT NULL, -- Identifier for the character
    RecipeHeader VARCHAR(255) NOT NULL,   -- e.g., Apothecary, Crafting
    Category VARCHAR(255) NOT NULL,       -- e.g., Medicine, Food, Ore
    XP INT NOT NULL DEFAULT 0             -- XP earned in this category
);



--Insert SQL campfire should already exist
INSERT INTO `items`(`item`, `label`, `limit`, `can_remove`, `type`, `usable`)
VALUES
    ('cauldron', 'Cauldron', 5, 1, 'item_standard', 0),
    ('mortarpestle', 'Mortar and Pestle', 5, 1, 'item_standard', 0);

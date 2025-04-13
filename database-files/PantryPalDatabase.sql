DROP DATABASE IF EXISTS PantryPal;

CREATE DATABASE IF NOT EXISTS PantryPal;

USE PantryPal;

CREATE TABLE users(
    userId INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    username varchar(50) NOT NULL UNIQUE,
    firstName varchar(50) NOT NULL,
    lastName varchar(50) NOT NULL,
    email varchar(120) NOT NULL UNIQUE,
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status boolean NOT NULL DEFAULT TRUE,
    bio text
);

CREATE TABLE recipes(
    recipeId INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    chefId int NOT NULL,
    title varchar(50) NOT NULL,
    description text NOT NULL,
    instructions text DEFAULT NULL,
    datePosted DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    prepTime int NOT NULL,
    servings double NOT NULL,
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    difficulty ENUM('EASY', 'MEDIUM', 'HARD') DEFAULT NULL,
    calories int DEFAULT NULL,
    FOREIGN KEY (chefId) REFERENCES users(userId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE ingredients(
    ingredientId INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    name varchar(50) NOT NULL UNIQUE,
    cost ENUM('CHEAP', 'MODERATE', 'EXPENSIVE') DEFAULT NULL
);

CREATE TABLE recipeIngredients(
    recipeId INT NOT NULL,
    ingredientId INT NOT NULL,
    quantity DOUBLE NOT NULL,
    unit tinytext NOT NULL,
    PRIMARY KEY (recipeId, ingredientId),
    FOREIGN KEY (recipeId) REFERENCES recipes(recipeId) ON DELETE CASCADE ON UPDATE CASCADE ,
    FOREIGN KEY (ingredientId) REFERENCES ingredients(ingredientId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE admins(
    adminId INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    firstName varchar(50) NOT NULL,
    lastName varchar(50) NOT NULL,
    email varchar(120) NOT NULL UNIQUE,
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE challenges(
    challengeId INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    studentId INT,
    description text NOT NULL,
    status ENUM('UNCLAIMED', 'IN PROGRESS', 'COMPLETED') default 'UNCLAIMED',
    approvedById INT NOT NULL,
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    difficulty ENUM('EASY', 'MEDIUM', 'HARD') DEFAULT NULL,
    FOREIGN KEY (approvedById) REFERENCES admins(adminId) ON UPDATE RESTRICT ON DELETE RESTRICT,
    FOREIGN KEY (studentId) REFERENCES users(userId) ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE challengeIngredients
(
    challengeId INT NOT NULL,
    ingredientId INT NOT NULL,
    PRIMARY KEY (challengeId, ingredientId),
    FOREIGN KEY (challengeId) REFERENCES challenges(challengeId) ON UPDATE RESTRICT ON DELETE RESTRICT ,
    FOREIGN KEY (ingredientId) REFERENCES ingredients(ingredientId) ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE challengeRequests(
    requestID INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    requestedById INT NOT NULL,
    dateSubmitted DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('NOT REVIEWED', 'APPROVED', 'DENIED') NOT NULL DEFAULT 'NOT REVIEWED',
    reviewedBy INT DEFAULT NULL,
    description text,
    FOREIGN KEY (requestedById) REFERENCES users(userId) ON DELETE RESTRICT,
    FOREIGN KEY (reviewedBy) REFERENCES  admins(adminId) ON DELETE RESTRICT
);

CREATE TABLE requestIngredients
(
    requestId INT NOT NULL,
    ingredientId INT NOT NULL,
    PRIMARY KEY (requestId, ingredientId),
    FOREIGN KEY (requestId) REFERENCES challengeRequests(requestId) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ingredientId) REFERENCES ingredients(ingredientId) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE reviews
(
    reviewId INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    userId INT NOT NULL,
    recipeId INT NOT NULL,
    rating tinyint(5) CHECK (rating BETWEEN 0 and 5),
    description text,
    datePosted DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    upVotes int NOT NULL DEFAULT 0,
    downVotes int NOT NULL DEFAULT 0,
    FOREIGN KEY (userId) REFERENCES users(userId) ON DELETE CASCADE ON UPDATE CASCADE ,
    FOREIGN KEY (recipeId) REFERENCES recipes(recipeId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE substitutions(
    originalIngredientId INT NOT NULL,
    subIngredientId INT NOT NULL,
    recipeId INT NOT NULL,
    PRIMARY KEY (originalIngredientId, subIngredientId, recipeId),
    quantity double NOT NULL,
    unit tinytext NOT NULL,
    FOREIGN KEY (originalIngredientId) REFERENCES ingredients(ingredientId),
    FOREIGN KEY (subIngredientId) REFERENCES ingredients(ingredientId),
    FOREIGN KEY (recipeId) REFERENCES  recipes(recipeId)
);

CREATE TABLE categories
(
    categoryId INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    categoryName varchar(50) NOT NULL,
    recipeId int NOT NULL,
    description text,
    FOREIGN KEY (recipeId) REFERENCES recipes(recipeId) ON DELETE CASCADE ON UPDATE CASCADE
);

# ADDING DATA
-- Users
INSERT INTO users (username, firstName, lastName, email, bio) VALUES
('KaleYeah', 'Isabel', 'Nicholson', 'isabel.nicholson@example.com', 'Passionate about plant-based cooking and driven by a mission to create good-tasting food using locally sourced and environmentally friendly ingredients'),
('spiceking', 'Derek', 'Ramsey', 'derek.ramsey@example.com', 'Obsessed with global spices and fusion cooking.'),
('plantplate', 'Amara', 'Singh', 'amara.singh@example.com', 'Vegan enthusiast creating colorful plant-based dishes.'),
('grillguru', 'Tom', 'Hawkins', 'tom.hawkins@example.com', 'Backyard BBQ master. Brisket is life.'),
('quickbitequeen', 'Nina', 'Choi', 'nina.choi@example.com', 'Fast, fresh, and flavorful meals for the busy life.'),
('chefantoine', 'Antoine', 'Lamar', 'antoine.lamar@example.com', 'Modern French cuisine with a twist.'),
('cozycooker', 'Ella', 'Brown', 'ella.brown@example.com', 'Home-style comfort food with a healthy touch.'),
('noodleninja', 'Kenji', 'Takeda', 'kenji.takeda@example.com', 'Noodle wizard. Ramen, udon, and more.'),
('sweettooth', 'Lana', 'Vega', 'lana.vega@example.com', 'Dessert-first mindset. Cakes, cookies, confections.'),
('wildherbs', 'Theo', 'Green', 'theo.green@example.com', 'Foraging, fermenting, and flavors from the forest.'),
('saucysara', 'Sara', 'Dunlop', 'sara.dunlop@example.com', 'Saucier in training. Sauce is the soul of a dish.'),
('mealmaster', 'James', 'Lee', 'james.lee@example.com', 'Meal prep addict and clean eating advocate.'),
('theegghead', 'Luis', 'Moreno', 'luis.moreno@example.com', 'Every day starts with eggs. Omelets are an art.'),
('stircrazy', 'Ivy', 'Nguyen', 'ivy.nguyen@example.com', 'Stir-fry aficionado with a wok collection.'),
('rawveganista', 'Sofia', 'Grant', 'sofia.grant@example.com', 'Raw vegan chef creating flavor from simplicity.'),
('glutenfreelove', 'Marco', 'Valdez', 'marco.valdez@example.com', 'Baking gluten-free bread that doesn’t suck.'),
('onepotwonder', 'Aiden', 'Clark', 'aiden.clark@example.com', 'One-pot meals, big flavor, minimal mess.'),
('cheftalia', 'Talia', 'Bennett', 'talia.bennett@example.com', 'Italian classics from my nonna’s kitchen.'),
('midnightmunchies', 'Oscar', 'Reed', 'oscar.reed@example.com', 'Late night eats with a creative twist.'),
('kitchenwitch', 'Maeve', 'Donovan', 'maeve.donovan@example.com', 'Herbal magic and kitchen alchemy.'),
('flavorjunkie', 'Ray', 'Daniels', 'ray.daniels@example.com', 'If it’s spicy, I’m in. Chili peppers in everything.'),
('southernspirit', 'Janelle', 'Robinson', 'janelle.robinson@example.com', 'Southern soul food and family traditions.'),
('basilandbeets', 'Luca', 'Ferrari', 'luca.ferrari@example.com', 'Plant-forward dishes with Italian roots.'),
('chefkaterina', 'Katerina', 'Dimitriou', 'katerina.d@example.com', 'Greek cuisine lover – tzatziki forever.'),
('coffeencurry', 'Priya', 'Malhotra', 'priya.malhotra@example.com', 'Caffeine and curries – my two essentials.'),
('crispychick', 'Blake', 'Reynolds', 'blake.reynolds@example.com', 'Chicken all ways: fried, grilled, smoked.'),
('misoqueen', 'Yuki', 'Tanaka', 'yuki.tanaka@example.com', 'Japanese home cook with a love for miso.'),
('chefmateo', 'Mateo', 'Rios', 'mateo.rios@example.com', 'Cooking is love made visible.'),
('bbqbaron', 'Rick', 'Barnes', 'rick.barnes@example.com', 'Texas-style BBQ and grill games strong.'),
('fermentfreak', 'Casey', 'Wolfe', 'casey.wolfe@example.com', 'Kimchi, krauts, kombucha – I ferment it all.'),
('urbanfarmer', 'Noah', 'Wright', 'noah.wright@example.com', 'Farm-to-table cooking from my backyard.'),
('tacotuesday', 'Carmen', 'Lopez', 'carmen.lopez@example.com', 'Tacos every day if I could.'),
('chefevelyn', 'Evelyn', 'Chambers', 'evelyn.chambers@example.com', 'Fine dining, elegant plating, bold flavors.'),
('currykid', 'Raj', 'Patel', 'raj.patel@example.com', 'Curries from all corners of India.'),
('nomnomnadia', 'Nadia', 'Ali', 'nadia.ali@example.com', 'Family meals that are quick, tasty, and budget-friendly.'),
('toastboss', 'Grant', 'Wells', 'grant.wells@example.com', 'Avocado toast + food photography = my thing.'),
('chefomar', 'Omar', 'Zane', 'omar.zane@example.com', 'Inspired by Moroccan spices and slow-cooked meals.'),
('kitchenkat', 'Kat', 'Bishop', 'kat.bishop@example.com', 'Comfort food queen. Big pots, bigger flavors.'),
('fusionfrenzy', 'Miles', 'King', 'miles.king@example.com', 'Blending East and West on every plate.'),
('chefbella', 'Isabella', 'Moretti', 'isabella.moretti@example.com', 'Rustic Italian dishes made with love.'),
('eggcellent', 'George', 'Wu', 'george.wu@example.com', 'All about brunch and beautiful plating.'),
('meatmaven', 'Connor', 'Stone', 'connor.stone@example.com', 'Carnivore at heart. Steaks, ribs, chops.'),
('koreankitchen', 'Eunji', 'Park', 'eunji.park@example.com', 'Banchan, BBQ, and bold Korean flavors.'),
('pantrypro', 'Olivia', 'Klein', 'olivia.klein@example.com', 'Making magic with whatever’s in the pantry.'),
('chefzane', 'Zane', 'McCarthy', 'zane.mccarthy@example.com', 'Driven by detail and perfect execution.'),
('thebakelab', 'Tobias', 'Clark', 'tobias.clark@example.com', 'Precision baking and recipe experimentation.'),
('snackattack', 'Leah', 'Scott', 'leah.scott@example.com', 'Snacks over meals. Chips, dips, and nibbles.'),
('chefaria', 'Aria', 'Nguyen', 'aria.nguyen@example.com', 'Colorful plates, global inspiration.'),
('brothsnbones', 'Emmett', 'James', 'emmett.james@example.com', 'Soup whisperer. Bone broth every season.'),
('vegantwist', 'Camila', 'Torres', 'camila.torres@example.com', 'Giving classic comfort food a vegan twist.'),
('simplefeasts', 'Harper', 'Evans', 'harper.evans@example.com', 'Minimalist meals. Big taste, no fluff.');


-- Admins
INSERT INTO admins (firstName, lastName, email) VALUES
('Martha', 'Baker', 'martha.baker@recipehub.com'),
('Jonas', 'Ford', 'jonas.ford@recipehub.com'),
('Clara', 'Nguyen', 'clara.nguyen@recipehub.com'),
('Samuel', 'Young', 'samuel.young@recipehub.com'),
('Felicia', 'Grant', 'felicia.grant@recipehub.com'),
('Omar', 'Peterson', 'omar.peterson@recipehub.com'),
('Diana', 'Morales', 'diana.morales@recipehub.com');


-- Ingredients
INSERT INTO ingredients (ingredientId, name, cost) VALUES
-- Vegetables
(1, 'Tomato', 'CHEAP'),
(2, 'Onion', 'CHEAP'),
(3, 'Garlic', 'CHEAP'),
(4, 'Carrot', 'CHEAP'),
(5, 'Bell Pepper', 'CHEAP'),
(6, 'Zucchini', 'CHEAP'),
(7, 'Spinach', 'CHEAP'),
(8, 'Broccoli', 'MODERATE'),
(9, 'Cauliflower', 'MODERATE'),
(10, 'Kale', 'MODERATE'),
(11, 'Asparagus', 'EXPENSIVE'),
(12, 'Mushroom', 'MODERATE'),
(13, 'Sweet Potato', 'MODERATE'),
(14, 'Eggplant', 'MODERATE'),
(15, 'Leek', 'MODERATE'),

-- Herbs & Spices
(16, 'Basil', 'CHEAP'),
(17, 'Parsley', 'CHEAP'),
(18, 'Thyme', 'CHEAP'),
(19, 'Rosemary', 'CHEAP'),
(20, 'Cilantro', 'CHEAP'),
(21, 'Oregano', 'CHEAP'),
(22, 'Turmeric', 'MODERATE'),
(23, 'Cumin', 'CHEAP'),
(24, 'Coriander', 'CHEAP'),
(25, 'Paprika', 'CHEAP'),
(26, 'Chili Flakes', 'CHEAP'),
(27, 'Cinnamon', 'MODERATE'),
(28, 'Nutmeg', 'MODERATE'),
(29, 'Cardamom', 'EXPENSIVE'),
(30, 'Saffron', 'EXPENSIVE'),

-- Meats & Protein
(31, 'Chicken Breast', 'MODERATE'),
(32, 'Ground Beef', 'MODERATE'),
(33, 'Bacon', 'MODERATE'),
(34, 'Salmon', 'EXPENSIVE'),
(35, 'Tuna', 'MODERATE'),
(36, 'Shrimp', 'EXPENSIVE'),
(37, 'Eggs', 'CHEAP'),
(38, 'Tofu', 'CHEAP'),
(39, 'Lentils', 'CHEAP'),
(40, 'Chickpeas', 'CHEAP'),
(41, 'Black Beans', 'CHEAP'),

-- Dairy & Alternatives
(42, 'Milk', 'CHEAP'),
(43, 'Butter', 'MODERATE'),
(44, 'Cheddar Cheese', 'MODERATE'),
(45, 'Mozzarella', 'MODERATE'),
(46, 'Parmesan', 'EXPENSIVE'),
(47, 'Cream', 'MODERATE'),
(48, 'Greek Yogurt', 'MODERATE'),
(49, 'Coconut Milk', 'MODERATE'),
(50, 'Almond Milk', 'MODERATE'),

-- Pantry
(51, 'Flour', 'CHEAP'),
(52, 'Sugar', 'CHEAP'),
(53, 'Salt', 'CHEAP'),
(54, 'Baking Powder', 'CHEAP'),
(55, 'Baking Soda', 'CHEAP'),
(56, 'Yeast', 'CHEAP'),
(57, 'Olive Oil', 'MODERATE'),
(58, 'Vegetable Oil', 'CHEAP'),
(59, 'Soy Sauce', 'CHEAP'),
(60, 'Vinegar', 'CHEAP'),
(61, 'Honey', 'MODERATE'),
(62, 'Maple Syrup', 'EXPENSIVE'),

-- Grains & Pasta
(63, 'White Rice', 'CHEAP'),
(64, 'Brown Rice', 'CHEAP'),
(65, 'Quinoa', 'MODERATE'),
(66, 'Couscous', 'MODERATE'),
(67, 'Pasta', 'CHEAP'),
(68, 'Oats', 'CHEAP'),
(69, 'Bread Crumbs', 'CHEAP'),
(70, 'Tortillas', 'CHEAP'),

-- Fruits
(71, 'Apple', 'CHEAP'),
(72, 'Banana', 'CHEAP'),
(73, 'Lemon', 'CHEAP'),
(74, 'Lime', 'CHEAP'),
(75, 'Orange', 'CHEAP'),
(76, 'Avocado', 'EXPENSIVE'),
(77, 'Blueberries', 'EXPENSIVE'),
(78, 'Strawberries', 'MODERATE'),
(79, 'Raisins', 'CHEAP'),
(80, 'Pineapple', 'MODERATE'),

-- Nuts & Seeds
(81, 'Peanuts', 'CHEAP'),
(82, 'Almonds', 'MODERATE'),
(83, 'Chia Seeds', 'MODERATE'),
(84, 'Sunflower Seeds', 'CHEAP'),
(85, 'Walnuts', 'EXPENSIVE'),
(86, 'Cashews', 'EXPENSIVE'),
(87, 'Sesame Seeds', 'CHEAP'),

-- Condiments
(88, 'Mayonnaise', 'MODERATE'),
(89, 'Ketchup', 'CHEAP'),
(90, 'Mustard', 'CHEAP'),
(91, 'Hot Sauce', 'CHEAP'),
(92, 'BBQ Sauce', 'MODERATE'),
(93, 'Pesto', 'MODERATE'),
(94, 'Peanut Butter', 'MODERATE'),
(95, 'Tahini', 'MODERATE'),

-- Specialty
(96, 'Gochujang', 'MODERATE'),
(97, 'Miso Paste', 'MODERATE'),
(98, 'Harissa', 'MODERATE'),
(99, 'Nori Sheets', 'EXPENSIVE'),
(100, 'Coconut Cream', 'MODERATE'),
(101, 'Paneer', 'MODERATE'),
(102, 'Tempeh', 'MODERATE'),
(103, 'Jackfruit', 'MODERATE'),
(104, 'Molasses', 'MODERATE'),
(105, 'Tamarind Paste', 'MODERATE'),
(106, 'Vegetable Broth', 'MODERATE'),
(107, 'Teriyaki Sauce', 'MODERATE'),
(108, 'Sesame Oil', 'MODERATE'),
(109, 'Oat Flour', 'MODERATE'),
(110, 'Cabbage', 'CHEAP'),
(111, 'Cucumber', 'CHEAP'),
(112, 'Feta Cheese', 'MODERATE'),
(113, 'Mango', 'MODERATE'),
(114, 'Cocoa Powder', 'MODERATE'),
(115, 'Slider Buns', 'CHEAP'),
(116, 'Arborio Rice', 'MODERATE'),
(117, 'Sundried Tomatoes', 'MODERATE'),
(118, 'Acorn Squash', 'MODERATE'),
(119, 'Cranberries', 'MODERATE'),
(120, 'Rice Noodles', 'CHEAP'),
(121, 'Soba Noodles', 'MODERATE'),
(122, 'Polenta', 'CHEAP'),
(123, 'Ricotta', 'MODERATE'),
(124, 'Lemongrass', 'MODERATE'),
(125, 'Star Anise', 'EXPENSIVE'),
(126, 'Cloves', 'MODERATE'),
(127, 'Zaatar', 'MODERATE'),
(128, 'Sumac', 'MODERATE'),
(129, 'Edamame', 'MODERATE'),
(130, 'Ginger', 'CHEAP'),
(131, 'Watercress', 'EXPENSIVE'),
(132, 'Microgreens', 'EXPENSIVE'),
(133, 'Plantains', 'MODERATE'),
(134, 'Beets', 'CHEAP'),
(135, 'Ricotta Salata', 'EXPENSIVE'),
(136, 'Shallots', 'MODERATE'),
(137, 'Green Beans', 'CHEAP'),
(138, 'Pear', 'MODERATE'),
(139, 'Cantaloupe', 'MODERATE'),
(140, 'Bulgur', 'CHEAP'),
(141, 'Farro', 'MODERATE'),
(142, 'Freekeh', 'MODERATE'),
(143, 'Barley', 'CHEAP'),
(144, 'Celeriac', 'MODERATE'),
(145, 'Horseradish', 'MODERATE'),
(146, 'Wasabi Paste', 'EXPENSIVE'),
(147, 'Togarashi', 'EXPENSIVE'),
(148, 'Smoked Paprika', 'MODERATE'),
(149, 'Black Garlic', 'EXPENSIVE'),
(150, 'Truffle Oil', 'EXPENSIVE'),
(151, 'Pickled Jalapeños', 'CHEAP'),
(152, 'Red Cabbage', 'CHEAP'),
(153, 'Green Onion', 'CHEAP'),
(154, 'Ghee', 'MODERATE'),
(155, 'Buttermilk', 'MODERATE'),
(156, 'Cream Cheese', 'MODERATE'),
(157, 'Coconut Sugar', 'MODERATE'),
(158, 'Date Syrup', 'EXPENSIVE'),
(159, 'Agave Nectar', 'MODERATE'),
(160, 'Sourdough Starter', 'CHEAP'),
(161, 'Mango Chutney', 'MODERATE'),
(162, 'Furikake', 'EXPENSIVE'),
(163, 'Matcha Powder', 'EXPENSIVE'),
(164, 'Caraway Seeds', 'MODERATE'),
(165, 'Dijon Mustard', 'MODERATE'),
(166, 'Pumpkin Puree', 'CHEAP');

-- Recipes
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES
(1, 'Classic Spaghetti Bolognese', 'A hearty Italian meat sauce served over tender spaghetti, slow-simmered with herbs and tomatoes.', 45, 4, 'MEDIUM', 650),
(5, 'Spicy Chickpea Curry', 'A vegan curry made with chickpeas, tomatoes, and a warm blend of spices. Perfect with rice or naan.', 35, 4, 'EASY', 420),
(9, 'Triple Chocolate Brownies', 'Fudgy brownies packed with cocoa, chocolate chips, and chunks of dark chocolate.', 50, 9, 'EASY', 380),
(13, 'Garlic Butter Shrimp Pasta', 'Juicy shrimp sautéed in garlic butter and tossed with spaghetti and lemon zest.', 30, 2, 'MEDIUM', 560),
(7, 'Homestyle Chicken Pot Pie', 'Flaky crust with creamy chicken and vegetable filling. The ultimate comfort food.', 75, 6, 'HARD', 710),
(21, 'Vegan Buddha Bowl', 'A colorful bowl with quinoa, roasted sweet potatoes, kale, chickpeas, and tahini dressing.', 40, 2, 'EASY', 510),
(30, 'BBQ Pulled Pork Sliders', 'Slow-cooked pork in smoky BBQ sauce, served on soft slider buns with slaw.', 240, 8, 'HARD', 730),
(3, 'Tofu Stir-Fry with Peanut Sauce', 'Tofu, bell peppers, and broccoli in a sweet and spicy peanut sauce over jasmine rice.', 25, 3, 'EASY', 480),
(18, 'Mushroom Risotto', 'Creamy Arborio rice with mushrooms, Parmesan, and thyme, stirred to perfection.', 50, 3, 'MEDIUM', 560),
(41, 'Avocado Toast with Poached Eggs', 'Crispy toast topped with smashed avocado, poached eggs, and chili flakes.', 15, 2, 'EASY', 370),
(17, 'Sweet Potato Tacos', 'Roasted sweet potatoes, black beans, and avocado in soft tortillas with lime crema.', 35, 4, 'EASY', 520),
(11, 'Lemon Herb Grilled Chicken', 'Chicken breast marinated with lemon, garlic, and herbs, grilled to juicy perfection.', 45, 2, 'MEDIUM', 460),
(20, 'Creamy Tomato Basil Soup', 'Smooth and comforting tomato soup blended with cream and fresh basil.', 30, 3, 'EASY', 380),
(44, 'Teriyaki Tofu Rice Bowl', 'Pan-seared tofu glazed in teriyaki sauce served over rice with steamed veggies.', 25, 2, 'EASY', 490),
(8, 'Beef and Broccoli Stir-Fry', 'Quick and classic stir-fry with marinated beef, broccoli, and garlic soy sauce.', 20, 3, 'MEDIUM', 560),
(15, 'Gluten-Free Banana Pancakes', 'Fluffy gluten-free pancakes made with ripe bananas and oat flour.', 25, 2, 'EASY', 400),
(28, 'Shrimp Tacos with Slaw', 'Crispy shrimp, cabbage slaw, and spicy mayo on corn tortillas.', 30, 4, 'MEDIUM', 540),
(6, 'Eggplant Parmesan', 'Layers of crispy eggplant, marinara, and mozzarella baked until bubbly.', 50, 5, 'HARD', 610),
(23, 'Thai Peanut Noodle Salad', 'Cold noodles tossed in a creamy peanut sauce with crunchy veggies and herbs.', 35, 3, 'EASY', 530),
(39, 'Stuffed Bell Peppers', 'Bell peppers filled with spiced rice, lentils, and tomato sauce then baked.', 60, 4, 'MEDIUM', 490),
(12, 'Butternut Squash Soup', 'A velvety soup made with roasted butternut squash and warm spices.', 50, 4, 'EASY', 420),
(19, 'Grilled Salmon with Dill Sauce', 'Perfectly grilled salmon fillets topped with a creamy dill yogurt sauce.', 35, 2, 'MEDIUM', 580),
(25, 'Quinoa Stuffed Eggplant', 'Roasted eggplants stuffed with herbed quinoa and veggies.', 60, 2, 'HARD', 510),
(31, 'Chili Con Carne', 'A spicy stew of ground beef, beans, and tomato with bold spices.', 55, 5, 'MEDIUM', 670),
(16, 'Zucchini Fritters', 'Crispy fritters made with grated zucchini and herbs.', 30, 3, 'EASY', 440),
(4, 'Coconut Chickpea Stew', 'A creamy, mildly spiced stew with chickpeas and coconut milk.', 40, 4, 'EASY', 510),
(10, 'Pasta Primavera', 'Colorful spring veggies tossed with pasta and a garlic olive oil sauce.', 25, 3, 'EASY', 480),
(26, 'Chicken Fajitas', 'Sizzling chicken with peppers and onions served in warm tortillas.', 30, 4, 'MEDIUM', 600),
(14, 'Banana Oat Muffins', 'Wholesome muffins made with banana, oats, and a touch of cinnamon.', 35, 6, 'EASY', 360),
(33, 'Miso Ramen Bowl', 'Umami-rich broth with noodles, tofu, and miso.', 45, 2, 'HARD', 620),
(2, 'Peanut Butter Energy Balls', 'No-bake snack balls with oats, peanut butter, and chia seeds.', 15, 10, 'EASY', 150),
(6, 'Shakshuka', 'Poached eggs in a spicy tomato and bell pepper sauce.', 30, 3, 'EASY', 390),
(7, 'Gnocchi with Pesto', 'Potato gnocchi tossed in a fresh basil pesto sauce.', 20, 2, 'EASY', 530),
(24, 'Crispy Tofu Lettuce Wraps', 'Savory tofu bites in crisp lettuce with sesame-ginger glaze.', 25, 2, 'EASY', 410),
(18, 'Bulgur Wheat Salad', 'A fresh and zesty salad with bulgur, herbs, and lemon.', 20, 3, 'EASY', 340),
(11, 'Veggie Fried Rice', 'Fried rice with colorful veggies, soy sauce, and sesame oil.', 20, 4, 'EASY', 460),
(30, 'Chickpea Shawarma Bowl', 'Middle Eastern flavors with roasted chickpeas and tahini sauce.', 35, 2, 'MEDIUM', 530),
(5, 'Beef Stroganoff', 'Tender beef in a creamy mushroom sauce over pasta.', 50, 4, 'HARD', 700),
(22, 'Blueberry Pancakes', 'Fluffy pancakes with juicy blueberries and maple syrup.', 30, 3, 'EASY', 420),
(13, 'Tofu Katsu Curry', 'Breaded tofu with a rich Japanese-style curry sauce.', 45, 2, 'MEDIUM', 580);



-- Recipe 1: Classic Spaghetti Bolognese
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES
(1, 32, 500, 'g'), -- Ground Beef
(1, 2, 1, 'pc'),   -- Onion
(1, 3, 3, 'cloves'), -- Garlic
(1, 1, 4, 'pcs'),  -- Tomato
(1, 21, 1, 'tsp'), -- Oregano
(1, 67, 400, 'g'), -- Pasta

-- Recipe 2: Spicy Chickpea Curry
(2, 40, 400, 'g'), -- Chickpeas
(2, 2, 1, 'pc'),   -- Onion
(2, 3, 3, 'cloves'), -- Garlic
(2, 1, 3, 'pcs'),  -- Tomato
(2, 23, 1, 'tsp'), -- Cumin
(2, 22, 1, 'tsp'), -- Turmeric

-- Recipe 3: Triple Chocolate Brownies
(3, 52, 200, 'g'), -- Sugar
(3, 51, 150, 'g'), -- Flour
(3, 43, 100, 'g'), -- Butter
(3, 37, 2, 'pcs'), -- Eggs
(3, 114, 60, 'g'), -- Cocoa Powder

-- Recipe 4: Garlic Butter Shrimp Pasta
(4, 36, 300, 'g'), -- Shrimp
(4, 3, 4, 'cloves'), -- Garlic
(4, 43, 50, 'g'),  -- Butter
(4, 67, 200, 'g'), -- Pasta
(4, 73, 1, 'pc'),  -- Lemon

-- Recipe 5: Homestyle Chicken Pot Pie
(5, 31, 300, 'g'), -- Chicken Breast
(5, 4, 2, 'pcs'),  -- Carrot
(5, 2, 1, 'pc'),   -- Onion
(5, 6, 1, 'pc'),   -- Zucchini
(5, 43, 50, 'g'),  -- Butter
(5, 51, 200, 'g'), -- Flour

-- Recipe 6: Vegan Buddha Bowl
(6, 65, 100, 'g'), -- Quinoa
(6, 13, 1, 'pc'),  -- Sweet Potato
(6, 10, 1, 'cup'), -- Kale
(6, 40, 100, 'g'), -- Chickpeas
(6, 95, 2, 'tbsp'), -- Tahini

-- Recipe 7: BBQ Pulled Pork Sliders
(7, 92, 100, 'ml'), -- BBQ Sauce
(7, 2, 1, 'pc'),    -- Onion
(7, 110, 1, 'cup'), -- Cabbage
(7, 115, 8, 'pcs'), -- Slider Buns

-- Recipe 8: Tofu Stir-Fry with Peanut Sauce
(8, 38, 200, 'g'), -- Tofu
(8, 5, 1, 'pc'),   -- Bell Pepper
(8, 8, 1, 'cup'),  -- Broccoli
(8, 94, 2, 'tbsp'), -- Peanut Butter
(8, 63, 200, 'g'), -- White Rice

-- Recipe 9: Mushroom Risotto
(9, 12, 200, 'g'), -- Mushroom
(9, 116, 200, 'g'), -- Arborio Rice
(9, 3, 2, 'cloves'), -- Garlic
(9, 46, 50, 'g'),  -- Parmesan
(9, 18, 1, 'tsp'), -- Thyme

-- Recipe 10: Avocado Toast with Poached Eggs
(10, 76, 1, 'pc'), -- Avocado
(10, 37, 2, 'pcs'), -- Eggs
(10, 70, 2, 'slices'), -- Tortillas (as toast base)
(10, 26, 0.5, 'tsp'), -- Chili Flakes

-- Recipe 11: Sweet Potato Tacos
(11, 13, 1, 'pc'), -- Sweet Potato
(11, 41, 100, 'g'), -- Black Beans
(11, 76, 1, 'pc'), -- Avocado
(11, 70, 4, 'pcs'), -- Tortillas
(11, 74, 1, 'pc'),  -- Lime

-- Recipe 12: Lemon Herb Grilled Chicken
(12, 31, 300, 'g'), -- Chicken Breast
(12, 73, 1, 'pc'),  -- Lemon
(12, 17, 1, 'tbsp'), -- Parsley
(12, 3, 2, 'cloves'), -- Garlic

-- Recipe 13: Creamy Tomato Basil Soup
(13, 1, 6, 'pcs'), -- Tomato
(13, 47, 100, 'ml'), -- Cream
(13, 16, 1, 'tbsp'), -- Basil
(13, 2, 1, 'pc'),  -- Onion

-- Recipe 14: Teriyaki Tofu Rice Bowl
(14, 38, 200, 'g'), -- Tofu
(14, 107, 2, 'tbsp'), -- Teriyaki Sauce
(14, 63, 200, 'g'), -- White Rice
(14, 8, 1, 'cup'), -- Broccoli

-- Recipe 15: Beef and Broccoli Stir-Fry
(15, 32, 300, 'g'), -- Ground Beef
(15, 8, 1, 'cup'), -- Broccoli
(15, 3, 2, 'cloves'), -- Garlic
(15, 59, 2, 'tbsp'), -- Soy Sauce

-- Recipe 16: Gluten-Free Banana Pancakes
(16, 72, 2, 'pcs'), -- Banana
(16, 109, 100, 'g'), -- Oat Flour
(16, 37, 2, 'pcs'), -- Eggs
(16, 52, 2, 'tbsp'), -- Sugar

-- Recipe 17: Shrimp Tacos with Slaw
(17, 36, 200, 'g'), -- Shrimp
(17, 110, 1, 'cup'), -- Cabbage
(17, 88, 2, 'tbsp'), -- Mayonnaise
(17, 70, 4, 'pcs'), -- Tortillas

-- Recipe 18: Eggplant Parmesan
(18, 14, 1, 'pc'), -- Eggplant
(18, 1, 4, 'pcs'), -- Tomato
(18, 45, 100, 'g'), -- Mozzarella
(18, 69, 50, 'g'), -- Bread Crumbs

-- Recipe 19: Thai Peanut Noodle Salad
(19, 94, 2, 'tbsp'), -- Peanut Butter
(19, 5, 1, 'pc'), -- Bell Pepper
(19, 70, 2, 'pcs'), -- Tortillas (used like wraps/salad base)
(19, 24, 1, 'tsp'), -- Coriander

-- Recipe 20: Stuffed Bell Peppers
(20, 5, 4, 'pcs'), -- Bell Pepper
(20, 64, 100, 'g'), -- Brown Rice
(20, 39, 100, 'g'), -- Lentils
(20, 1, 2, 'pcs'), -- Tomato

-- Recipe 21: Butternut Squash Soup
(21, 13, 1, 'pc'), -- Sweet Potato (as squash substitute)
(21, 3, 2, 'cloves'),
(21, 27, 0.5, 'tsp'), -- Cinnamon
(21, 47, 100, 'ml'), -- Cream

-- Recipe 22: Grilled Salmon with Dill Sauce
(22, 34, 2, 'fillets'),
(22, 48, 100, 'ml'), -- Greek Yogurt
(22, 17, 1, 'tbsp'), -- Parsley (sub for dill)
(22, 73, 1, 'pc'), -- Lemon

-- Recipe 23: Quinoa Stuffed Eggplant
(23, 14, 1, 'pc'),
(23, 65, 100, 'g'),
(23, 5, 1, 'pc'),
(23, 3, 2, 'cloves'),

-- Recipe 24: Chili Con Carne
(24, 32, 300, 'g'),
(24, 41, 100, 'g'),
(24, 1, 3, 'pcs'),
(24, 25, 1, 'tsp'), -- Paprika

-- Recipe 25: Zucchini Fritters
(25, 6, 2, 'pcs'),
(25, 37, 2, 'pcs'),
(25, 51, 50, 'g'),
(25, 17, 1, 'tbsp'),

-- Recipe 26: Coconut Chickpea Stew
(26, 40, 400, 'g'),
(26, 49, 200, 'ml'),
(26, 3, 2, 'cloves'),
(26, 22, 1, 'tsp'),

-- Recipe 27: Pasta Primavera
(27, 5, 1, 'pc'),
(27, 6, 1, 'pc'),
(27, 67, 200, 'g'),
(27, 57, 2, 'tbsp'),

-- Recipe 28: Chicken Fajitas
(28, 31, 300, 'g'),
(28, 5, 2, 'pcs'),
(28, 2, 1, 'pc'),
(28, 70, 4, 'pcs'),

-- Recipe 29: Banana Oat Muffins
(29, 72, 2, 'pcs'),
(29, 68, 100, 'g'),
(29, 54, 1, 'tsp'),
(29, 27, 0.5, 'tsp'),

-- Recipe 30: Miso Ramen Bowl
(30, 38, 150, 'g'),
(30, 97, 1, 'tbsp'),
(30, 5, 1, 'pc'),
(30, 67, 150, 'g'),

-- Recipe 31: Peanut Butter Energy Balls
(31, 94, 3, 'tbsp'),
(31, 68, 100, 'g'),
(31, 83, 1, 'tbsp'),
(31, 52, 2, 'tbsp'),

-- Recipe 32: Shakshuka
(32, 1, 4, 'pcs'),
(32, 5, 1, 'pc'),
(32, 3, 2, 'cloves'),
(32, 37, 3, 'pcs'),

-- Recipe 33: Gnocchi with Pesto
(33, 93, 2, 'tbsp'),
(33, 67, 250, 'g'),
(33, 46, 30, 'g'),
(33, 3, 1, 'clove'),

-- Recipe 34: Crispy Tofu Lettuce Wraps
(34, 38, 200, 'g'),
(34, 110, 4, 'leaves'),
(34, 108, 1, 'tbsp'),
(34, 5, 1, 'pc'),

-- Recipe 35: Bulgur Wheat Salad (sub with couscous)
(35, 66, 100, 'g'),
(35, 20, 1, 'tbsp'),
(35, 73, 1, 'pc'),
(35, 5, 1, 'pc'),

-- Recipe 36: Veggie Fried Rice
(36, 63, 200, 'g'),
(36, 5, 1, 'pc'),
(36, 8, 1, 'cup'),
(36, 59, 1, 'tbsp'),
(36, 108, 1, 'tsp'),

-- Recipe 37: Chickpea Shawarma Bowl
(37, 40, 200, 'g'),
(37, 95, 1, 'tbsp'),
(37, 10, 1, 'cup'),
(37, 74, 1, 'pc'),

-- Recipe 38: Beef Stroganoff
(38, 32, 300, 'g'),
(38, 12, 200, 'g'),
(38, 47, 100, 'ml'),
(38, 67, 200, 'g'),

-- Recipe 39: Blueberry Pancakes
(39, 78, 100, 'g'),
(39, 51, 100, 'g'),
(39, 37, 2, 'pcs'),
(39, 62, 2, 'tbsp'),

-- Recipe 40: Tofu Katsu Curry
(40, 38, 200, 'g'),
(40, 69, 50, 'g'),
(40, 12, 1, 'pc'),
(40, 1, 3, 'pcs');


-- Recipe Reviews
INSERT INTO reviews (userId, recipeId, rating, description) VALUES
-- Recipe 1: Classic Spaghetti Bolognese
(18, 1, 5, 'Reminds me of my nonna’s Sunday dinners. Absolutely classic.'),
(40, 1, 4, 'Great flavor, but I added a splash of red wine for depth.'),

-- Recipe 2: Spicy Chickpea Curry
(3, 2, 5, 'Love the warmth of the spices. A regular in my vegan rotation.'),
(25, 2, 4, 'Perfect blend of heat and comfort. Next time I’ll add potatoes.'),

-- Recipe 3: Triple Chocolate Brownies
(9, 3, 5, 'Chocolate heaven. Gooey and rich – just how I like it!'),
(44, 3, 5, 'Tested with my coffee break crew. Gone in 5 minutes.'),

-- Recipe 5: Homestyle Chicken Pot Pie
(7, 5, 4, 'Comfort in a crust. Filling could use more seasoning but still cozy.'),
(6, 5, 5, 'I love the veggie mix! Added peas and it was divine.'),

-- Recipe 6: Eggplant Parmesan
(23, 6, 5, 'Crispy and cheesy – just like my favorite trattoria!'),
(16, 6, 4, 'Great recipe, but I swapped in gluten-free breadcrumbs.'),

-- Recipe 9: Mushroom Risotto
(33, 9, 5, 'Creamy, earthy, and beautifully balanced. Stirring was worth it!'),

-- Recipe 10: Avocado Toast with Poached Eggs
(35, 10, 4, 'Simple and tasty. Added chili oil for a little zing.'),
(40, 10, 5, 'Gorgeous brunch plate. Poached eggs were perfect.'),

-- Recipe 14: Teriyaki Tofu Rice Bowl
(26, 14, 4, 'Tofu was so flavorful! My go-to for quick dinners.'),
(8, 14, 5, 'Loved the balance of sweet and savory. Added extra sauce.'),

-- Recipe 15: Gluten-Free Banana Pancakes
(16, 15, 5, 'As a gluten-free baker, I’m impressed. Fluffy and flavorful!'),

-- Recipe 17: Sweet Potato Tacos
(31, 17, 5, 'Super satisfying and plant-powered. The lime crema made it pop.'),

-- Recipe 19: Grilled Salmon with Dill Sauce
(2, 19, 5, 'The yogurt sauce really elevated the dish. Will make again.'),
(22, 19, 4, 'Well-balanced and elegant. Needed a pinch more salt for me.'),

-- Recipe 23: Quinoa Stuffed Eggplant
(23, 23, 5, 'Great plant-forward dish. Loved the textures.'),
(3, 23, 5, 'Hearty and satisfying. Even my non-vegan friends were impressed.'),

-- Recipe 24: Chili Con Carne
(1, 24, 5, 'Bold, spicy, and full of flavor. My go-to game day recipe.'),
(20, 24, 4, 'Really hearty. I added chipotle and it hit harder.'),

-- Recipe 27: Pasta Primavera
(5, 27, 4, 'Bright, fresh, and fast. Added lemon zest and loved it.'),

-- Recipe 30: Peanut Butter Energy Balls
(9, 30, 5, 'Snacked on these all week. Quick, easy, and energizing.'),
(2, 30, 5, 'Great for meal prep. I roll them in coconut flakes too.'),

-- Recipe 32: Shakshuka
(13, 32, 5, 'A classic done right. Eggs cooked perfectly in the sauce.'),
(14, 32, 4, 'Wok-fried twist turned out great. Would eat again.'),

-- Recipe 33: Gnocchi with Pesto
(18, 33, 5, 'Tastes like home. The pesto was so vibrant!'),

-- Recipe 36: Veggie Fried Rice
(14, 36, 5, 'Perfect for leftover rice. My wok got a workout and I loved it.'),
(42, 36, 4, 'Savory and satisfying. I tossed in kimchi for fun.'),

-- Recipe 38: Beef Stroganoff
(41, 38, 5, 'Rich, creamy, and comforting. Great for cold nights.'),
(6, 38, 4, 'A little heavy, but very flavorful. Added garlic for punch.'),
-- Recipe 1: Classic Spaghetti Bolognese
(36, 1, 2, 'A bit bland for my taste. Needed more garlic and maybe chili.'),

-- Recipe 3: Triple Chocolate Brownies
(47, 3, 3, 'Too sweet for me, and mine turned out more cakey than fudgy.'),

-- Recipe 5: Homestyle Chicken Pot Pie
(21, 5, 2, 'Crust was nice, but the filling was too dry and needed more herbs.'),

-- Recipe 13: Garlic Butter Shrimp Pasta
(38, 13, 2, 'Shrimp was overcooked when I followed the timing. Sauce was a bit oily.'),

-- Recipe 14: Teriyaki Tofu Rice Bowl
(15, 14, 3, 'Texture was good but I found the sauce a bit too sweet.'),

-- Recipe 17: Sweet Potato Tacos
(30, 17, 2, 'The filling was mushy and lacked seasoning. Tacos need more punch!'),

-- Recipe 22: Grilled Salmon with Dill Sauce
(45, 22, 3, 'Salmon cooked well, but the yogurt sauce wasn’t for me.'),

-- Recipe 24: Chili Con Carne
(50, 24, 1, 'Way too salty. I had to toss it. Maybe a typo in the seasoning?'),

-- Recipe 25: Quinoa Stuffed Eggplant
(34, 25, 2, 'Looks good on the plate but was kinda dry and underseasoned.'),

-- Recipe 26: Chicken Fajitas
(27, 26, 3, 'Not bad, but pretty basic. Expected more bold flavor.'),

-- Recipe 28: Shrimp Tacos with Slaw
(19, 28, 2, 'Shrimp lacked crunch and the slaw was soggy.'),

-- Recipe 29: Banana Oat Muffins
(16, 29, 3, 'Good texture but not sweet enough. Had to drizzle maple syrup on top.'),

-- Recipe 31: Chili Con Carne (again)
(4, 31, 2, 'Too spicy and greasy for me. Not a fan of the texture.'),

-- Recipe 33: Gnocchi with Pesto
(46, 33, 2, 'Gnocchi turned gummy. Pesto didn’t really stick.'),

-- Recipe 36: Veggie Fried Rice
(37, 36, 2, 'Tasted flat. Needed more soy sauce or sesame oil.'),

-- Recipe 39: Blueberry Pancakes
(48, 39, 1, 'Turned out dense and dry. Definitely needs more moisture.'),

-- Recipe 13: Tofu Katsu Curry
(26, 40, 2, 'Breaded tofu didn’t stay crispy and the curry was too mild.'),
(11, 40, 3, 'It was okay but not quite authentic. I missed the depth of a real Japanese curry.');


-- Challenges
INSERT INTO challenges (studentId, description, status, approvedById) VALUES
(3, 'Use: Chickpeas, coconut milk, turmeric, and spinach', 'COMPLETED', 2),
(14, 'Make a stir-fry using only bell pepper, tofu, and soy sauce', 'IN PROGRESS', 1),
(21, 'Sweet Potato & Black Bean challenge', 'COMPLETED', 3),
(7, 'Create a comfort dish using chicken breast, carrots, and milk', 'IN PROGRESS', 5),
(19, 'Forage & Ferment: Use wild mushrooms, vinegar, and garlic', 'COMPLETED', 6),
(10, 'Holiday Leftovers Remix', 'COMPLETED', 4),
(25, 'Use: Cumin, chickpeas, zucchini, and Greek yogurt', 'IN PROGRESS', 1),
(6, 'Pantry Challenge: Cook with only flour, butter, eggs, and onions', 'COMPLETED', 2),
(12, 'Use: Salmon, asparagus, and lemon', 'IN PROGRESS', 3),
(30, 'Post-Workout Fuel: Peanut butter, oats, banana, and chia seeds', 'COMPLETED', 7),
(17, 'Use: Eggplant, mozzarella, tomato, and breadcrumbs', 'IN PROGRESS', 6),
(23, 'Farmers Market: Kale, sweet potato, and quinoa', 'COMPLETED', 2),
(28, 'One-pot meal using lentils, bell peppers, and couscous', 'COMPLETED', 5),
(15, 'Gluten-free breakfast challenge', 'IN PROGRESS', 3),
(9, 'Bake with: cocoa powder, almond flour, and maple syrup', 'COMPLETED', 4),
(2, 'Spice Bomb: Incorporate turmeric, cumin, chili flakes, and coriander', 'IN PROGRESS', 7),
(5, 'Challenge: Make a dish with tuna, chickpeas, and lemon', 'UNCLAIMED', 2),
(4, 'Create BBQ sliders with ingredients you already have at home', 'UNCLAIMED', 1),
(22, 'Southern Soul Challenge: Use black beans, cabbage, and hot sauce', 'UNCLAIMED', 6),
(11, 'Use: Eggs, spinach, and cheddar cheese in a single dish', 'UNCLAIMED', 3);


INSERT INTO challengeIngredients (challengeId, ingredientId) VALUES
-- Challenge 1: Chickpeas, coconut milk, turmeric, and spinach
(1, 40), -- Chickpeas
(1, 49), -- Coconut Milk
(1, 22), -- Turmeric
(1, 7),  -- Spinach

-- Challenge 2: Bell pepper, tofu, soy sauce
(2, 5),
(2, 38),
(2, 59),

-- Challenge 3: Sweet potato & black bean
(3, 13),
(3, 41),

-- Challenge 4: Chicken breast, carrots, milk
(4, 31),
(4, 4),
(4, 42),

-- Challenge 5: Mushrooms, vinegar, garlic
(5, 12),
(5, 60),
(5, 3),

-- Challenge 6: Holiday Leftovers Remix (thematic - common leftovers)
(6, 31), -- Chicken Breast
(6, 2),  -- Onion
(6, 51), -- Flour
(6, 43), -- Butter

-- Challenge 7: Cumin, chickpeas, zucchini, Greek yogurt
(7, 23),
(7, 40),
(7, 6),
(7, 48),

-- Challenge 8: Flour, butter, eggs, onions
(8, 51),
(8, 43),
(8, 37),
(8, 2),

-- Challenge 9: Salmon, asparagus, lemon
(9, 34),
(9, 11),
(9, 73),

-- Challenge 10: Peanut butter, oats, banana, chia seeds
(10, 94),
(10, 68),
(10, 72),
(10, 83),

-- Challenge 11: Eggplant, mozzarella, tomato, breadcrumbs
(11, 14),
(11, 45),
(11, 1),
(11, 69),

-- Challenge 12: Kale, sweet potato, quinoa
(12, 10),
(12, 13),
(12, 65),

-- Challenge 13: Lentils, bell peppers, couscous
(13, 39),
(13, 5),
(13, 66),

-- Challenge 14: Gluten-free breakfast challenge
(14, 72), -- Banana
(14, 109), -- Oat Flour
(14, 37),  -- Eggs

-- Challenge 15: Cocoa powder, almond flour, maple syrup
(15, 114),
(15, 82), -- Almonds (to represent almond flour)
(15, 62),

-- Challenge 16: Turmeric, cumin, chili flakes, coriander
(16, 22),
(16, 23),
(16, 26),
(16, 24),

-- Challenge 17: Tuna, chickpeas, lemon
(17, 35),
(17, 40),
(17, 73),

-- Challenge 18: BBQ sliders with what's on hand
(18, 92), -- BBQ Sauce
(18, 2),  -- Onion
(18, 110), -- Cabbage
(18, 115), -- Slider Buns

-- Challenge 19: Black beans, cabbage, hot sauce
(19, 41),
(19, 110),
(19, 91),

-- Challenge 20: Eggs, spinach, cheddar cheese
(20, 37),
(20, 7),
(20, 44);


-- Approved requests (linked to challenges 1–10)
INSERT INTO challengeRequests (requestedById, status, reviewedBy) VALUES
(3, 'APPROVED', 2),   -- requestId = 1 (Challenge 1)
(14, 'APPROVED', 1),  -- requestId = 2 (Challenge 2)
(21, 'APPROVED', 3),  -- requestId = 3 (Challenge 3)
(7, 'APPROVED', 5),   -- requestId = 4 (Challenge 4)
(19, 'APPROVED', 6),  -- requestId = 5 (Challenge 5)
(10, 'APPROVED', 4),  -- requestId = 6 (Challenge 6)
(25, 'APPROVED', 1),  -- requestId = 7 (Challenge 7)
(6, 'APPROVED', 2),   -- requestId = 8 (Challenge 8)
(12, 'APPROVED', 3),  -- requestId = 9 (Challenge 9)
(30, 'APPROVED', 7),  -- requestId = 10 (Challenge 10)

-- Unapproved requests (NOT REVIEWED or DENIED)
(8, 'NOT REVIEWED', NULL),       -- requestId = 11
(17, 'DENIED', 3),        -- requestId = 12
(4, 'NOT REVIEWED', NULL),       -- requestId = 13
(5, 'DENIED', 2),         -- requestId = 14
(15, 'NOT REVIEWED', NULL);      -- requestId = 15


-- Approved Requests (1–10)
INSERT INTO requestIngredients (requestId, ingredientId) VALUES
-- Request 1: Chickpeas, coconut milk, turmeric, spinach
(1, 40),
(1, 49),
(1, 22),
(1, 7),

-- Request 2: Bell pepper, tofu, soy sauce
(2, 5),
(2, 38),
(2, 59),

-- Request 3: Sweet potato, black beans
(3, 13),
(3, 41),

-- Request 4: Chicken breast, carrots, milk
(4, 31),
(4, 4),
(4, 42),

-- Request 5: Mushrooms, vinegar, garlic
(5, 12),
(5, 60),
(5, 3),

-- Request 6: Chicken, onion, flour, butter
(6, 31),
(6, 2),
(6, 51),
(6, 43),

-- Request 7: Cumin, chickpeas, zucchini, Greek yogurt
(7, 23),
(7, 40),
(7, 6),
(7, 48),

-- Request 8: Flour, butter, eggs, onions
(8, 51),
(8, 43),
(8, 37),
(8, 2),

-- Request 9: Salmon, asparagus, lemon
(9, 34),
(9, 11),
(9, 73),

-- Request 10: Peanut butter, oats, banana, chia seeds
(10, 94),
(10, 68),
(10, 72),
(10, 83),

-- Unapproved Requests
-- Request 11: Spinach, feta, sun-dried tomatoes (unapproved combo)
(11, 7),
(11, 112),
(11, 1),

-- Request 12: Beef, pineapple, ketchup (rejected flavor combo)
(12, 32),
(12, 80),
(12, 89),

-- Request 13: Tofu, peanut butter, eggplant
(13, 38),
(13, 94),
(13, 14),

-- Request 14: Tuna, cheddar cheese, mayo (rejected tuna melt remix)
(14, 35),
(14, 44),
(14, 88),

-- Request 15: Chickpeas, cardamom, oats (unusual breakfast idea)
(15, 40),
(15, 29),
(15, 68);

INSERT INTO substitutions (originalIngredientId, subIngredientId, recipeId, quantity, unit) VALUES
-- Recipe 1: Classic Spaghetti Bolognese
(32, 39, 1, 300, 'g'), -- Swap Ground Beef with Lentils for a veg-friendly version

-- Recipe 2: Spicy Chickpea Curry
(49, 42, 2, 100, 'ml'), -- Swap Coconut Milk with Milk for a non-vegan version

-- Recipe 3: Triple Chocolate Brownies
(43, 94, 3, 100, 'g'), -- Swap Butter with Peanut Butter for a nutty twist

-- Recipe 6: Eggplant Parmesan
(45, 44, 18, 100, 'g'), -- Swap Mozzarella with Cheddar Cheese

-- Recipe 8: Beef and Broccoli Stir-Fry
(32, 38, 15, 200, 'g'), -- Swap Beef with Tofu for a vegetarian version

-- Recipe 10: Avocado Toast with Poached Eggs
(76, 72, 10, 1, 'pc'), -- Swap Avocado with Banana (creative breakfast twist)

-- Recipe 11: Lemon Herb Grilled Chicken
(31, 36, 11, 200, 'g'); -- Swap Chicken Breast with Shrimp


-- Ingredient Categories
INSERT INTO categories (recipeId, categoryName) VALUES
(1, 'PASTA'),
(2, 'VEGAN'),
(3, 'DESSERT'),
(4, 'SEAFOOD'),
(5, 'COMFORT FOOD'),
(6, 'VEGAN'),
(7, 'BBQ'),
(8, 'VEGETARIAN'),
(9, 'ITALIAN'),
(10, 'BREAKFAST'),
(11, 'VEGETARIAN'),
(12, 'GRILL'),
(13, 'SOUP'),
(14, 'ASIAN'),
(15, 'STIR FRY'),
(16, 'BREAKFAST'),
(17, 'TACOS'),
(18, 'VEGETARIAN'),
(19, 'ASIAN'),
(20, 'VEGETARIAN'),
(21, 'SOUP'),
(22, 'SEAFOOD'),
(23, 'VEGETARIAN'),
(24, 'COMFORT FOOD'),
(25, 'VEGETARIAN'),
(26, 'VEGAN'),
(27, 'PASTA'),
(28, 'MEXICAN'),
(29, 'BREAKFAST'),
(30, 'ASIAN'),
(31, 'SNACK'),
(32, 'BREAKFAST'),
(33, 'ITALIAN'),
(34, 'VEGETARIAN'),
(35, 'MEDITERRANEAN'),
(36, 'ASIAN'),
(37, 'MEDITERRANEAN'),
(38, 'COMFORT FOOD'),
(39, 'BREAKFAST'),
(40, 'ASIAN');

# additional recipes
-- Recipe: Grilled Peach Burrata Salad
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (12, 'Grilled Peach Burrata Salad', 'Juicy grilled peaches with burrata, arugula, and balsamic.', 15, 2, 'EASY', 410);
INSERT INTO categories (recipeId, categoryName) VALUES (41, 'SALAD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (41, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (41, 132, 20.0, 'g');
-- Recipe: Farro & Roasted Beet Bowl
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Farro & Roasted Beet Bowl', 'Nutty farro with roasted beets, feta, and herbs.', 45, 3, 'EASY', 480);
INSERT INTO categories (recipeId, categoryName) VALUES (42, 'BOWL');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (42, 141, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (42, 134, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (42, 112, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (42, 57, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (42, 17, 1.0, 'tbsp');
-- Recipe: Ricotta Lemon Toast
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (35, 'Ricotta Lemon Toast', 'Toast topped with whipped ricotta, lemon, and honey.', 10, 2, 'EASY', 360);
INSERT INTO categories (recipeId, categoryName) VALUES (43, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (43, 123, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (43, 73, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (43, 61, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (43, 69, 2.0, 'slices');
-- Recipe: Thai Basil Tofu Stir-Fry
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Thai Basil Tofu Stir-Fry', 'Stir-fried tofu with garlic, chilies, and Thai basil.', 25, 2, 'MEDIUM', 510);
INSERT INTO categories (recipeId, categoryName) VALUES (44, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (44, 38, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (44, 3, 3.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (44, 26, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (44, 16, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (44, 59, 2.0, 'tbsp');
-- Recipe: Gochujang Glazed Eggplant
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (26, 'Gochujang Glazed Eggplant', 'Roasted eggplant halves glazed in spicy gochujang.', 30, 2, 'MEDIUM', 470);
INSERT INTO categories (recipeId, categoryName) VALUES (45, 'VEGETARIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (45, 14, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (45, 96, 1.5, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (45, 108, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (45, 153, 2.0, 'stalks');
-- Recipe: Creamy Polenta with Mushrooms
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (20, 'Creamy Polenta with Mushrooms', 'Soft polenta topped with garlic mushrooms and thyme.', 40, 2, 'MEDIUM', 500);
INSERT INTO categories (recipeId, categoryName) VALUES (46, 'COMFORT FOOD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (46, 122, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (46, 12, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (46, 3, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (46, 47, 50.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (46, 18, 1.0, 'tsp');
-- Recipe: Buttermilk Pancakes with Blueberry Syrup
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Buttermilk Pancakes with Blueberry Syrup', 'Fluffy pancakes served with warm blueberry syrup.', 30, 3, 'EASY', 450);
INSERT INTO categories (recipeId, categoryName) VALUES (47, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (47, 155, 200.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (47, 51, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (47, 77, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (47, 62, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (47, 54, 1.0, 'tsp');
-- Recipe: Harissa Roasted Cauliflower Tacos
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (25, 'Harissa Roasted Cauliflower Tacos', 'Spicy roasted cauliflower in soft tortillas with lime crema.', 35, 4, 'MEDIUM', 520);
INSERT INTO categories (recipeId, categoryName) VALUES (48, 'TACOS');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (48, 9, 1.0, 'head');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (48, 98, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (48, 70, 4.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (48, 74, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (48, 48, 50.0, 'g');
-- Recipe: Baked Plantain Chips with Guac
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (15, 'Baked Plantain Chips with Guac', 'Crispy baked plantains served with avocado dip.', 25, 2, 'EASY', 390);
INSERT INTO categories (recipeId, categoryName) VALUES (49, 'SNACK');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (49, 133, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (49, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (49, 76, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (49, 74, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (49, 53, 0.5, 'tsp');
-- Recipe: Chickpea Shakshuka
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (13, 'Chickpea Shakshuka', 'Classic shakshuka with chickpeas for extra heartiness.', 30, 2, 'EASY', 460);
INSERT INTO categories (recipeId, categoryName) VALUES (50, 'VEGETARIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (50, 1, 4.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (50, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (50, 3, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (50, 40, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (50, 37, 2.0, 'pcs');
-- Recipe: Creamy Avocado Pasta
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (15, 'Creamy Avocado Pasta', 'Pasta tossed in a smooth avocado, garlic, and lemon sauce.', 20, 2, 'EASY', 490);
INSERT INTO categories (recipeId, categoryName) VALUES (51, 'PASTA');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (51, 67, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (51, 76, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (51, 3, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (51, 73, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (51, 57, 1.0, 'tbsp');
-- Recipe: Za’atar Roasted Carrots with Yogurt
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (24, 'Za’atar Roasted Carrots with Yogurt', 'Sweet roasted carrots with herbed yogurt and za’atar.', 30, 2, 'EASY', 430);
INSERT INTO categories (recipeId, categoryName) VALUES (52, 'VEGETARIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (52, 4, 4.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (52, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (52, 48, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (52, 127, 1.0, 'tsp');
-- Recipe: Curried Pumpkin Lentil Soup
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Curried Pumpkin Lentil Soup', 'Hearty soup with red lentils, pumpkin, and curry spices.', 40, 4, 'EASY', 440);
INSERT INTO categories (recipeId, categoryName) VALUES (53, 'SOUP');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (53, 166, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (53, 39, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (53, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (53, 3, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (53, 23, 1.0, 'tsp');
-- Recipe: Stuffed Bell Peppers with Farro
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Stuffed Bell Peppers with Farro', 'Roasted bell peppers filled with seasoned farro and veggies.', 45, 3, 'MEDIUM', 530);
INSERT INTO categories (recipeId, categoryName) VALUES (54, 'COMFORT FOOD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (54, 5, 3.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (54, 141, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (54, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (54, 6, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (54, 57, 1.0, 'tbsp');
-- Recipe: Smoked Paprika Chicken Skewers
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (4, 'Smoked Paprika Chicken Skewers', 'Juicy grilled chicken with smoky paprika spice rub.', 30, 2, 'MEDIUM', 570);
INSERT INTO categories (recipeId, categoryName) VALUES (55, 'GRILL');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (55, 31, 300.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (55, 148, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (55, 3, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (55, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (55, 73, 1.0, 'pc');
-- Recipe: Sweet Potato & Black Bean Quesadillas
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (5, 'Sweet Potato & Black Bean Quesadillas', 'Crispy quesadillas filled with mashed sweet potatoes and beans.', 25, 2, 'EASY', 520);
INSERT INTO categories (recipeId, categoryName) VALUES (56, 'MEXICAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (56, 13, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (56, 41, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (56, 44, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (56, 70, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (56, 23, 1.0, 'tsp');
-- Recipe: Butternut Squash & Sage Risotto
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Butternut Squash & Sage Risotto', 'Creamy risotto with roasted squash and sage.', 45, 3, 'HARD', 580);
INSERT INTO categories (recipeId, categoryName) VALUES (57, 'ITALIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (57, 116, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (57, 118, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (57, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (57, 43, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (57, 18, 1.0, 'tsp');
-- Recipe: Turkey & Cranberry Panini
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (5, 'Turkey & Cranberry Panini', 'Pressed sandwich with sliced turkey, cranberry, and cheddar.', 20, 2, 'EASY', 530);
INSERT INTO categories (recipeId, categoryName) VALUES (58, 'SANDWICH');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (58, 119, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (58, 44, 80.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (58, 69, 2.0, 'slices');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (58, 43, 1.0, 'tbsp');
-- Recipe: Barley & Roasted Veggie Pilaf
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Barley & Roasted Veggie Pilaf', 'Earthy barley pilaf with oven-roasted vegetables and herbs.', 40, 4, 'EASY', 470);
INSERT INTO categories (recipeId, categoryName) VALUES (59, 'VEGETARIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (59, 143, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (59, 4, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (59, 6, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (59, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (59, 21, 1.0, 'tsp');
-- Recipe: Tuna & Cucumber Pita Bites
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (5, 'Tuna & Cucumber Pita Bites', 'Simple tuna salad stuffed into fresh cucumber slices and pita.', 10, 2, 'EASY', 320);
INSERT INTO categories (recipeId, categoryName) VALUES (60, 'SNACK');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (60, 35, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (60, 111, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (60, 48, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (60, 73, 1.0, 'pc');
-- Recipe: Pear & Walnut Spinach Salad
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Pear & Walnut Spinach Salad', 'Fresh salad with pear, toasted walnuts, and a maple vinaigrette.', 15, 2, 'EASY', 420);
INSERT INTO categories (recipeId, categoryName) VALUES (61, 'SALAD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (61, 7, 2.0, 'cups');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (61, 138, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (61, 85, 30.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (61, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (61, 62, 1.0, 'tsp');
-- Recipe: Creamy Coconut Chickpea Curry
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (25, 'Creamy Coconut Chickpea Curry', 'Rich coconut curry with chickpeas and warm Indian spices.', 30, 4, 'EASY', 510);
INSERT INTO categories (recipeId, categoryName) VALUES (62, 'VEGAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (62, 49, 200.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (62, 40, 300.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (62, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (62, 22, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (62, 23, 1.0, 'tsp');
-- Recipe: Roasted Red Pepper Hummus Wrap
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (3, 'Roasted Red Pepper Hummus Wrap', 'A quick veggie wrap with roasted pepper hummus and greens.', 15, 2, 'EASY', 440);
INSERT INTO categories (recipeId, categoryName) VALUES (63, 'WRAP');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (63, 5, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (63, 40, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (63, 3, 1.0, 'clove');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (63, 95, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (63, 70, 2.0, 'pcs');
-- Recipe: Truffle Mushroom Pasta
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (1, 'Truffle Mushroom Pasta', 'Creamy pasta with sautéed mushrooms and a hint of truffle.', 30, 2, 'MEDIUM', 620);
INSERT INTO categories (recipeId, categoryName) VALUES (64, 'PASTA');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (64, 67, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (64, 12, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (64, 47, 100.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (64, 150, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (64, 46, 30.0, 'g');
-- Recipe: Coconut Mango Chia Pudding
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Coconut Mango Chia Pudding', 'A chilled pudding with coconut milk, mango, and chia seeds.', 10, 2, 'EASY', 350);
INSERT INTO categories (recipeId, categoryName) VALUES (65, 'DESSERT');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (65, 49, 150.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (65, 113, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (65, 83, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (65, 62, 1.0, 'tbsp');
-- Recipe: Dijon Mustard Roasted Chicken
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (4, 'Dijon Mustard Roasted Chicken', 'Baked chicken legs brushed with herbed Dijon mustard glaze.', 50, 3, 'MEDIUM', 560);
INSERT INTO categories (recipeId, categoryName) VALUES (66, 'DINNER');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (66, 31, 400.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (66, 165, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (66, 19, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (66, 3, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (66, 57, 1.0, 'tbsp');
-- Recipe: Balsamic Glazed Brussels & Cranberries
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (19, 'Balsamic Glazed Brussels & Cranberries', 'Roasted Brussels sprouts with tangy cranberries and glaze.', 30, 2, 'EASY', 390);
INSERT INTO categories (recipeId, categoryName) VALUES (67, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (67, 119, 30.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (67, 57, 1.0, 'tbsp');
-- Recipe: Cream Cheese Stuffed French Toast
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Cream Cheese Stuffed French Toast', 'Thick-cut bread filled with cream cheese and berries.', 20, 2, 'EASY', 480);
INSERT INTO categories (recipeId, categoryName) VALUES (68, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (68, 69, 4.0, 'slices');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (68, 156, 80.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (68, 37, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (68, 78, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (68, 62, 1.0, 'tbsp');
-- Recipe: Barley Risotto with Spinach & Lemon
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Barley Risotto with Spinach & Lemon', 'Creamy barley risotto with bright lemon and greens.', 40, 3, 'MEDIUM', 510);
INSERT INTO categories (recipeId, categoryName) VALUES (69, 'ITALIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (69, 143, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (69, 7, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (69, 73, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (69, 3, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (69, 46, 30.0, 'g');
-- Recipe: Ginger Soy Edamame Stir-Fry
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (29, 'Ginger Soy Edamame Stir-Fry', 'Quick veggie stir-fry with edamame and ginger-soy sauce.', 20, 2, 'EASY', 420);
INSERT INTO categories (recipeId, categoryName) VALUES (70, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (70, 129, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (70, 59, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (70, 130, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (70, 5, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (70, 108, 1.0, 'tbsp');
-- Recipe: Mediterranean Stuffed Sweet Potatoes
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Mediterranean Stuffed Sweet Potatoes', 'Baked sweet potatoes filled with chickpeas, tahini, and herbs.', 40, 2, 'EASY', 500);
INSERT INTO categories (recipeId, categoryName) VALUES (71, 'MEDITERRANEAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (71, 13, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (71, 40, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (71, 95, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (71, 17, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (71, 73, 1.0, 'pc');
-- Recipe: Japanese Tamago Sando
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (26, 'Japanese Tamago Sando', 'Creamy Japanese egg salad sandwich on fluffy bread.', 15, 2, 'EASY', 450);
INSERT INTO categories (recipeId, categoryName) VALUES (72, 'SANDWICH');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (72, 37, 3.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (72, 88, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (72, 69, 2.0, 'slices');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (72, 165, 0.5, 'tsp');
-- Recipe: Moroccan-Spiced Carrot Soup
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (27, 'Moroccan-Spiced Carrot Soup', 'Creamy soup with cumin, ginger, and a touch of harissa.', 35, 3, 'EASY', 430);
INSERT INTO categories (recipeId, categoryName) VALUES (73, 'SOUP');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (73, 4, 4.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (73, 98, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (73, 23, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (73, 130, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (73, 49, 100.0, 'ml');
-- Recipe: Vegan Pad Thai with Tofu
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Vegan Pad Thai with Tofu', 'Rice noodles stir-fried with tofu, peanuts, and tangy sauce.', 30, 2, 'MEDIUM', 540);
INSERT INTO categories (recipeId, categoryName) VALUES (74, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (74, 120, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (74, 38, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (74, 81, 30.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (74, 59, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (74, 74, 1.0, 'pc');
-- Recipe: Caramelized Banana Oatmeal
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (13, 'Caramelized Banana Oatmeal', 'Warm oats topped with caramelized bananas and cinnamon.', 15, 1, 'EASY', 400);
INSERT INTO categories (recipeId, categoryName) VALUES (75, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (75, 68, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (75, 72, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (75, 62, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (75, 27, 0.5, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (75, 42, 150.0, 'ml');
-- Recipe: Togarashi Roasted Chickpeas
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (25, 'Togarashi Roasted Chickpeas', 'Crunchy roasted chickpeas seasoned with Japanese togarashi.', 30, 4, 'EASY', 320);
INSERT INTO categories (recipeId, categoryName) VALUES (76, 'SNACK');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (76, 40, 300.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (76, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (76, 147, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (76, 53, 0.5, 'tsp');
-- Recipe: Grilled Pineapple Tofu Skewers
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Grilled Pineapple Tofu Skewers', 'Sweet & savory tofu and pineapple grilled to perfection.', 25, 2, 'EASY', 480);
INSERT INTO categories (recipeId, categoryName) VALUES (77, 'GRILL');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (77, 38, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (77, 80, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (77, 59, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (77, 108, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (77, 3, 2.0, 'cloves');
-- Recipe: Matcha Coconut Energy Bites
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Matcha Coconut Energy Bites', 'No-bake bites with oats, coconut, and matcha.', 10, 6, 'EASY', 180);
INSERT INTO categories (recipeId, categoryName) VALUES (78, 'SNACK');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (78, 68, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (78, 157, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (78, 163, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (78, 94, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (78, 83, 1.0, 'tbsp');
-- Recipe: Freekeh & Roasted Veggie Bowl
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Freekeh & Roasted Veggie Bowl', 'Nutty grain bowl with colorful vegetables and lemon tahini.', 35, 2, 'MEDIUM', 490);
INSERT INTO categories (recipeId, categoryName) VALUES (79, 'GRAIN BOWL');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (79, 142, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (79, 6, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (79, 152, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (79, 73, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (79, 95, 1.0, 'tbsp');
-- Recipe: Spaghetti with Black Garlic & Olive Oil
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (1, 'Spaghetti with Black Garlic & Olive Oil', 'A simple yet flavorful pasta with black garlic and herbs.', 20, 2, 'EASY', 510);
INSERT INTO categories (recipeId, categoryName) VALUES (80, 'PASTA');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (80, 67, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (80, 149, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (80, 57, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (80, 17, 1.0, 'tbsp');
-- Recipe: Butternut Squash Gnocchi
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (20, 'Butternut Squash Gnocchi', 'Soft handmade gnocchi from roasted squash and flour.', 60, 2, 'HARD', 620);
INSERT INTO categories (recipeId, categoryName) VALUES (81, 'ITALIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (81, 118, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (81, 51, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (81, 46, 30.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (81, 43, 1.0, 'tbsp');
-- Recipe: Rainbow Spring Rolls with Peanut Sauce
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Rainbow Spring Rolls with Peanut Sauce', 'Fresh veggie rolls with a sweet and salty dipping sauce.', 35, 2, 'MEDIUM', 470);
INSERT INTO categories (recipeId, categoryName) VALUES (82, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (82, 120, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (82, 110, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (82, 4, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (82, 94, 2.0, 'tbsp');
-- Recipe: Date & Almond Breakfast Bars
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (16, 'Date & Almond Breakfast Bars', 'Chewy bars with dates, oats, and toasted almonds.', 30, 6, 'EASY', 330);
INSERT INTO categories (recipeId, categoryName) VALUES (83, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (83, 68, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (83, 82, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (83, 158, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (83, 27, 0.5, 'tsp');
-- Recipe: Vegan Jackfruit Tacos
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (15, 'Vegan Jackfruit Tacos', 'Pulled jackfruit with smoky spices in soft tortillas.', 30, 3, 'EASY', 500);
INSERT INTO categories (recipeId, categoryName) VALUES (84, 'MEXICAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (84, 103, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (84, 25, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (84, 23, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (84, 70, 3.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (84, 74, 1.0, 'pc');
-- Recipe: Roasted Celeriac Mash
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (7, 'Roasted Celeriac Mash', 'A root veggie alternative to mashed potatoes.', 35, 2, 'EASY', 390);
INSERT INTO categories (recipeId, categoryName) VALUES (85, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (85, 144, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (85, 43, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (85, 47, 50.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (85, 53, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (85, 28, 0.25, 'tsp');
-- Recipe: Cold Soba Noodle Salad
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (29, 'Cold Soba Noodle Salad', 'Chilled buckwheat noodles with cucumber and sesame.', 20, 2, 'EASY', 440);
INSERT INTO categories (recipeId, categoryName) VALUES (86, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (86, 121, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (86, 111, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (86, 59, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (86, 87, 1.0, 'tbsp');
-- Recipe: Sourdough French Toast
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Sourdough French Toast', 'Rich, golden toast using tangy sourdough starter.', 15, 2, 'EASY', 460);
INSERT INTO categories (recipeId, categoryName) VALUES (87, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (87, 160, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (87, 37, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (87, 42, 100.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (87, 27, 0.5, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (87, 62, 1.0, 'tbsp');
-- Recipe: Horseradish & Beet Slaw
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (30, 'Horseradish & Beet Slaw', 'Bold slaw with shredded beets and a horseradish kick.', 15, 3, 'EASY', 280);
INSERT INTO categories (recipeId, categoryName) VALUES (88, 'SALAD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (88, 134, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (88, 145, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (88, 60, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (88, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (88, 53, 0.5, 'tsp');
-- Recipe: Mango Chutney Glazed Meatballs
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (4, 'Mango Chutney Glazed Meatballs', 'Sweet and spicy meatballs with Indian-style chutney glaze.', 40, 3, 'MEDIUM', 580);
INSERT INTO categories (recipeId, categoryName) VALUES (89, 'DINNER');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (89, 32, 300.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (89, 161, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (89, 3, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (89, 130, 1.0, 'tbsp');
-- Recipe: Caraway Roasted Carrots
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (11, 'Caraway Roasted Carrots', 'Oven-roasted carrots with aromatic caraway seeds.', 30, 2, 'EASY', 360);
INSERT INTO categories (recipeId, categoryName) VALUES (90, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (90, 4, 3.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (90, 164, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (90, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (90, 53, 0.5, 'tsp');
-- Recipe: Italian White Bean & Kale Stew
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Italian White Bean & Kale Stew', 'A rustic Tuscan-style stew with kale, white beans, and herbs.', 40, 4, 'EASY', 460);
INSERT INTO categories (recipeId, categoryName) VALUES (91, 'SOUP');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (91, 10, 2.0, 'cups');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (91, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (91, 3, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (91, 106, 500.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (91, 57, 1.0, 'tbsp');
-- Recipe: Korean Bibimbap with Gochujang Sauce
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (26, 'Korean Bibimbap with Gochujang Sauce', 'Rice bowl topped with sautéed vegetables, egg, and spicy sauce.', 40, 2, 'MEDIUM', 550);
INSERT INTO categories (recipeId, categoryName) VALUES (92, 'KOREAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (92, 63, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (92, 7, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (92, 4, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (92, 96, 1.5, 'tbsp');
-- Recipe: Coconut Lime Chicken Skewers
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (4, 'Coconut Lime Chicken Skewers', 'Grilled chicken marinated in coconut milk, lime, and garlic.', 30, 3, 'MEDIUM', 520);
INSERT INTO categories (recipeId, categoryName) VALUES (93, 'GRILL');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (93, 31, 300.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (93, 49, 100.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (93, 74, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (93, 3, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (93, 57, 1.0, 'tbsp');
-- Recipe: Spiced Lentil Fritters
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Spiced Lentil Fritters', 'Crispy lentil patties seasoned with turmeric and cumin.', 25, 4, 'EASY', 480);
INSERT INTO categories (recipeId, categoryName) VALUES (94, 'SNACK');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (94, 39, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (94, 22, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (94, 23, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (94, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (94, 58, 1.0, 'tbsp');
-- Recipe: Mango Avocado Salsa
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (15, 'Mango Avocado Salsa', 'Bright, tropical salsa with sweet mango and creamy avocado.', 10, 2, 'EASY', 250);
INSERT INTO categories (recipeId, categoryName) VALUES (95, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (95, 113, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (95, 76, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (95, 74, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (95, 152, 0.5, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (95, 20, 1.0, 'tbsp');
-- Recipe: Creamy Sun-Dried Tomato Penne
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (1, 'Creamy Sun-Dried Tomato Penne', 'A rich pasta dish with sun-dried tomatoes and a creamy sauce.', 30, 3, 'MEDIUM', 610);
INSERT INTO categories (recipeId, categoryName) VALUES (96, 'PASTA');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (96, 67, 250.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (96, 117, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (96, 47, 100.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (96, 46, 40.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (96, 3, 2.0, 'cloves');
-- Recipe: Breakfast Grain Bowl with Pear & Almonds
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (16, 'Breakfast Grain Bowl with Pear & Almonds', 'Warm bowl of cooked grains topped with pear and toasted almonds.', 20, 2, 'EASY', 430);
INSERT INTO categories (recipeId, categoryName) VALUES (97, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (97, 140, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (97, 138, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (97, 82, 20.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (97, 62, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (97, 27, 0.5, 'tsp');
-- Recipe: Baked Falafel Balls with Lemon Tahini Sauce
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (3, 'Baked Falafel Balls with Lemon Tahini Sauce', 'Herb-packed falafel served with a creamy lemon tahini drizzle.', 35, 3, 'MEDIUM', 490);
INSERT INTO categories (recipeId, categoryName) VALUES (98, 'MIDDLE EASTERN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (98, 40, 250.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (98, 17, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (98, 23, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (98, 73, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (98, 95, 2.0, 'tbsp');
-- Recipe: Pineapple Teriyaki Tofu Bowl
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Pineapple Teriyaki Tofu Bowl', 'Sweet and savory tofu bowl with pineapple and rice.', 30, 2, 'EASY', 500);
INSERT INTO categories (recipeId, categoryName) VALUES (99, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (99, 38, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (99, 80, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (99, 107, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (99, 63, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (99, 153, 1.0, 'stalk');
-- Recipe: Cauliflower Shawarma Wrap
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (25, 'Cauliflower Shawarma Wrap', 'Roasted cauliflower with spices wrapped in pita with sauce.', 35, 2, 'MEDIUM', 520);
INSERT INTO categories (recipeId, categoryName) VALUES (100, 'VEGAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (100, 9, 1.0, 'head');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (100, 25, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (100, 70, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (100, 95, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (100, 73, 1.0, 'pc');
-- Recipe: Spicy Peanut Sweet Potato Noodles
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (15, 'Spicy Peanut Sweet Potato Noodles', 'Spiralized sweet potatoes tossed in a spicy peanut sauce.', 30, 2, 'MEDIUM', 540);
INSERT INTO categories (recipeId, categoryName) VALUES (101, 'NOODLES');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (101, 13, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (101, 94, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (101, 59, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (101, 74, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (101, 3, 2.0, 'cloves');
-- Recipe: Warm Couscous Salad with Roasted Veggies
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Warm Couscous Salad with Roasted Veggies', 'A light, satisfying salad of couscous and oven-roasted veg.', 35, 3, 'EASY', 470);
INSERT INTO categories (recipeId, categoryName) VALUES (102, 'SALAD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (102, 66, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (102, 5, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (102, 6, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (102, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (102, 21, 1.0, 'tsp');
-- Recipe: Spaghetti Squash Primavera
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (18, 'Spaghetti Squash Primavera', 'Light spaghetti squash noodles with colorful sautéed vegetables.', 45, 2, 'MEDIUM', 460);
INSERT INTO categories (recipeId, categoryName) VALUES (103, 'VEGETARIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (103, 4, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (103, 8, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (103, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (103, 46, 30.0, 'g');
-- Recipe: Creamy Dijon Potato Salad
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (4, 'Creamy Dijon Potato Salad', 'Classic potato salad with a Dijon mustard twist.', 25, 4, 'EASY', 520);
INSERT INTO categories (recipeId, categoryName) VALUES (104, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (104, 165, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (104, 88, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (104, 153, 1.0, 'stalk');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (104, 60, 1.0, 'tbsp');
-- Recipe: Tempeh Bacon Avocado Sandwich
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (15, 'Tempeh Bacon Avocado Sandwich', 'Smoky tempeh “bacon” layered with avocado on toasted bread.', 20, 2, 'EASY', 520);
INSERT INTO categories (recipeId, categoryName) VALUES (105, 'SANDWICH');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (105, 102, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (105, 76, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (105, 69, 2.0, 'slices');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (105, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (105, 25, 1.0, 'tsp');
-- Recipe: Red Lentil & Carrot Curry
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Red Lentil & Carrot Curry', 'Creamy curry made with red lentils, carrots, and spices.', 35, 3, 'EASY', 510);
INSERT INTO categories (recipeId, categoryName) VALUES (106, 'CURRY');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (106, 39, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (106, 4, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (106, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (106, 49, 150.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (106, 22, 1.0, 'tsp');
-- Recipe: Roasted Eggplant & Feta Flatbread
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (24, 'Roasted Eggplant & Feta Flatbread', 'Crispy flatbread topped with eggplant, feta, and herbs.', 30, 2, 'MEDIUM', 530);
INSERT INTO categories (recipeId, categoryName) VALUES (107, 'MEDITERRANEAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (107, 14, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (107, 112, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (107, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (107, 16, 1.0, 'tbsp');
-- Recipe: Matcha White Chocolate Cookies
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Matcha White Chocolate Cookies', 'Chewy cookies with grassy matcha and sweet white chocolate.', 25, 6, 'EASY', 390);
INSERT INTO categories (recipeId, categoryName) VALUES (108, 'DESSERT');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (108, 51, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (108, 163, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (108, 52, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (108, 43, 80.0, 'g');
-- Recipe: Black Bean & Quinoa Burgers
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Black Bean & Quinoa Burgers', 'Protein-packed vegetarian burgers with smoky flavor.', 40, 4, 'MEDIUM', 520);
INSERT INTO categories (recipeId, categoryName) VALUES (109, 'BURGER');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (109, 41, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (109, 65, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (109, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (109, 25, 1.0, 'tsp');
-- Recipe: Cold Cucumber Yogurt Soup
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (11, 'Cold Cucumber Yogurt Soup', 'Refreshing chilled soup with cucumber, mint, and yogurt.', 15, 2, 'EASY', 350);
INSERT INTO categories (recipeId, categoryName) VALUES (110, 'SOUP');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (110, 111, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (110, 48, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (110, 3, 1.0, 'clove');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (110, 73, 1.0, 'pc');
-- Recipe: Creamy Polenta with Roasted Shallots
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (20, 'Creamy Polenta with Roasted Shallots', 'Buttery polenta topped with caramelized shallots and herbs.', 35, 2, 'MEDIUM', 490);
INSERT INTO categories (recipeId, categoryName) VALUES (111, 'COMFORT FOOD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (111, 122, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (111, 136, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (111, 43, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (111, 18, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (111, 57, 1.0, 'tbsp');
-- Recipe: Togarashi Edamame Snack Bowl
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (29, 'Togarashi Edamame Snack Bowl', 'Spicy Japanese-style roasted edamame with sesame and togarashi.', 15, 2, 'EASY', 340);
INSERT INTO categories (recipeId, categoryName) VALUES (112, 'SNACK');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (112, 129, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (112, 108, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (112, 147, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (112, 53, 0.5, 'tsp');
-- Recipe: Date Syrup Tahini Bites
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Date Syrup Tahini Bites', 'No-bake bites with tahini, oats, and sweet date syrup.', 10, 6, 'EASY', 220);
INSERT INTO categories (recipeId, categoryName) VALUES (113, 'SNACK');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (113, 95, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (113, 158, 1.5, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (113, 68, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (113, 27, 0.5, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (113, 83, 1.0, 'tbsp');
-- Recipe: Pickled Jalapeño Grilled Cheese
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (5, 'Pickled Jalapeño Grilled Cheese', 'A spicy twist on grilled cheese with pickled jalapeños.', 15, 2, 'EASY', 540);
INSERT INTO categories (recipeId, categoryName) VALUES (114, 'SANDWICH');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (114, 69, 2.0, 'slices');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (114, 44, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (114, 151, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (114, 43, 1.0, 'tbsp');
-- Recipe: Caraway Roasted Red Cabbage Steaks
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (11, 'Caraway Roasted Red Cabbage Steaks', 'Roasted cabbage wedges with caraway seed and olive oil.', 30, 2, 'EASY', 400);
INSERT INTO categories (recipeId, categoryName) VALUES (115, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (115, 152, 1.0, 'head');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (115, 164, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (115, 57, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (115, 53, 1.0, 'tsp');
-- Recipe: Coconut Cream Fruit Parfait
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Coconut Cream Fruit Parfait', 'Layers of coconut cream, fresh fruit, and maple syrup.', 10, 2, 'EASY', 360);
INSERT INTO categories (recipeId, categoryName) VALUES (116, 'DESSERT');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (116, 100, 150.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (116, 77, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (116, 78, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (116, 62, 1.0, 'tbsp');
-- Recipe: Pumpkin Spiced Breakfast Muffins
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (16, 'Pumpkin Spiced Breakfast Muffins', 'Moist muffins made with pumpkin puree and warm spices.', 35, 6, 'EASY', 410);
INSERT INTO categories (recipeId, categoryName) VALUES (117, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (117, 166, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (117, 51, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (117, 27, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (117, 28, 0.25, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (117, 54, 1.0, 'tsp');
-- Recipe: Black Garlic Udon Noodles
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Black Garlic Udon Noodles', 'Umami-rich noodles tossed with black garlic and soy glaze.', 20, 2, 'MEDIUM', 540);
INSERT INTO categories (recipeId, categoryName) VALUES (118, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (118, 67, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (118, 149, 3.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (118, 59, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (118, 153, 2.0, 'stalks');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (118, 108, 1.0, 'tbsp');
-- Recipe: Roasted Beets with Ricotta Salata
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (24, 'Roasted Beets with Ricotta Salata', 'Sweet roasted beets paired with salty ricotta salata.', 35, 2, 'EASY', 430);
INSERT INTO categories (recipeId, categoryName) VALUES (119, 'SALAD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (119, 134, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (119, 135, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (119, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (119, 73, 1.0, 'pc');
-- Recipe: Miso Butter Green Beans
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (7, 'Miso Butter Green Beans', 'Crisp-tender green beans tossed in savory miso butter.', 15, 2, 'EASY', 380);
INSERT INTO categories (recipeId, categoryName) VALUES (120, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (120, 137, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (120, 97, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (120, 43, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (120, 3, 1.0, 'clove');
-- Recipe: Acorn Squash & Farro Salad
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Acorn Squash & Farro Salad', 'Hearty salad with roasted squash, farro, and herbs.', 40, 3, 'MEDIUM', 490);
INSERT INTO categories (recipeId, categoryName) VALUES (121, 'GRAIN BOWL');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (121, 118, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (121, 141, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (121, 17, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (121, 57, 1.0, 'tbsp');
-- Recipe: Soba Noodle Stir Fry with Lemongrass
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (29, 'Soba Noodle Stir Fry with Lemongrass', 'Stir-fried soba noodles with fresh lemongrass and veggies.', 25, 2, 'MEDIUM', 460);
INSERT INTO categories (recipeId, categoryName) VALUES (122, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (122, 121, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (122, 5, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (122, 124, 1.0, 'stalk');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (122, 59, 2.0, 'tbsp');
-- Recipe: Buttermilk Cardamom Pancakes
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Buttermilk Cardamom Pancakes', 'Fluffy pancakes with floral cardamom and tangy buttermilk.', 25, 3, 'EASY', 440);
INSERT INTO categories (recipeId, categoryName) VALUES (123, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (123, 155, 200.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (123, 51, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (123, 29, 0.5, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (123, 37, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (123, 62, 2.0, 'tbsp');
-- Recipe: Spicy Ghee Popcorn
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (15, 'Spicy Ghee Popcorn', 'Popcorn tossed with ghee, chili flakes, and cumin.', 10, 2, 'EASY', 320);
INSERT INTO categories (recipeId, categoryName) VALUES (124, 'SNACK');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (124, 154, 1.5, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (124, 26, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (124, 23, 0.5, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (124, 53, 0.5, 'tsp');
-- Recipe: Wasabi Tuna Rice Balls
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (26, 'Wasabi Tuna Rice Balls', 'Onigiri-style rice balls with spicy wasabi tuna filling.', 30, 3, 'MEDIUM', 500);
INSERT INTO categories (recipeId, categoryName) VALUES (125, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (125, 63, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (125, 35, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (125, 146, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (125, 99, 3.0, 'pcs');
-- Recipe: Smoked Paprika Roasted Chickpeas
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Smoked Paprika Roasted Chickpeas', 'Crispy, smoky chickpeas perfect for snacking.', 25, 4, 'EASY', 390);
INSERT INTO categories (recipeId, categoryName) VALUES (126, 'SNACK');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (126, 40, 300.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (126, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (126, 148, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (126, 53, 1.0, 'tsp');
-- Recipe: Saffron & Almond Milk Rice Pudding
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (13, 'Saffron & Almond Milk Rice Pudding', 'Fragrant rice pudding with saffron and almond milk.', 45, 4, 'MEDIUM', 470);
INSERT INTO categories (recipeId, categoryName) VALUES (127, 'DESSERT');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (127, 63, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (127, 50, 300.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (127, 52, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (127, 30, 1.0, 'pinch');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (127, 82, 20.0, 'g');
-- Recipe: Spiced Celeriac & Apple Soup
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (11, 'Spiced Celeriac & Apple Soup', 'Smooth root veggie soup with sweet apple and nutmeg.', 35, 3, 'EASY', 420);
INSERT INTO categories (recipeId, categoryName) VALUES (128, 'SOUP');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (128, 144, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (128, 71, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (128, 28, 0.25, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (128, 106, 400.0, 'ml');
-- Recipe: Clove & Cinnamon Poached Pears
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Clove & Cinnamon Poached Pears', 'Delicately spiced pears simmered in syrup.', 40, 2, 'EASY', 300);
INSERT INTO categories (recipeId, categoryName) VALUES (129, 'DESSERT');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (129, 138, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (129, 126, 3.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (129, 27, 1.0, 'stick');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (129, 52, 2.0, 'tbsp');
-- Recipe: Creamy Barley Risotto with Leek
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (7, 'Creamy Barley Risotto with Leek', 'Comforting risotto made with barley and sautéed leek.', 45, 3, 'MEDIUM', 530);
INSERT INTO categories (recipeId, categoryName) VALUES (130, 'ITALIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (130, 143, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (130, 15, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (130, 46, 30.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (130, 47, 50.0, 'ml');
-- Recipe: Ginger Lemongrass Chicken Soup
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (4, 'Ginger Lemongrass Chicken Soup', 'Light, aromatic soup with chicken, lemongrass, and ginger.', 40, 3, 'MEDIUM', 450);
INSERT INTO categories (recipeId, categoryName) VALUES (131, 'SOUP');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (131, 31, 300.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (131, 124, 1.0, 'stalk');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (131, 130, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (131, 106, 500.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (131, 153, 1.0, 'stalk');
-- Recipe: Paneer Tikka Wraps
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (25, 'Paneer Tikka Wraps', 'Grilled spiced paneer in warm tortillas with yogurt sauce.', 30, 2, 'MEDIUM', 540);
INSERT INTO categories (recipeId, categoryName) VALUES (132, 'INDIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (132, 101, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (132, 25, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (132, 48, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (132, 70, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (132, 73, 1.0, 'pc');
-- Recipe: Couscous with Raisins & Almonds
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Couscous with Raisins & Almonds', 'A North African-style side with sweet and nutty flavor.', 20, 2, 'EASY', 470);
INSERT INTO categories (recipeId, categoryName) VALUES (133, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (133, 66, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (133, 79, 30.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (133, 82, 20.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (133, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (133, 27, 0.5, 'tsp');
-- Recipe: Polenta Cakes with Sumac Yogurt
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (24, 'Polenta Cakes with Sumac Yogurt', 'Crispy fried polenta with tangy yogurt and sumac drizzle.', 35, 2, 'MEDIUM', 500);
INSERT INTO categories (recipeId, categoryName) VALUES (134, 'VEGETARIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (134, 122, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (134, 57, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (134, 48, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (134, 128, 1.0, 'tsp');
-- Recipe: Tofu & Plantain Curry
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (15, 'Tofu & Plantain Curry', 'A Caribbean-inspired curry with sweet plantains and tofu.', 35, 3, 'MEDIUM', 530);
INSERT INTO categories (recipeId, categoryName) VALUES (135, 'CURRY');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (135, 38, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (135, 133, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (135, 49, 150.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (135, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (135, 23, 1.0, 'tsp');
-- Recipe: Gochujang Tempeh Tacos
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Gochujang Tempeh Tacos', 'Spicy Korean fusion tacos with gochujang-marinated tempeh.', 30, 3, 'MEDIUM', 520);
INSERT INTO categories (recipeId, categoryName) VALUES (136, 'FUSION');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (136, 102, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (136, 96, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (136, 110, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (136, 70, 3.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (136, 87, 1.0, 'tsp');
-- Recipe: Carrot & Star Anise Soup
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Carrot & Star Anise Soup', 'A sweet-spiced carrot soup infused with star anise.', 35, 3, 'MEDIUM', 430);
INSERT INTO categories (recipeId, categoryName) VALUES (137, 'SOUP');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (137, 4, 4.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (137, 125, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (137, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (137, 106, 500.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (137, 57, 1.0, 'tbsp');
-- Recipe: Orange Glazed Salmon with Farro
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (4, 'Orange Glazed Salmon with Farro', 'Seared salmon with a citrus glaze served over nutty farro.', 30, 2, 'MEDIUM', 580);
INSERT INTO categories (recipeId, categoryName) VALUES (138, 'DINNER');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (138, 34, 250.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (138, 75, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (138, 141, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (138, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (138, 18, 1.0, 'tsp');
-- Recipe: Matcha Ricotta Pancakes
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Matcha Ricotta Pancakes', 'Fluffy pancakes with ricotta and vibrant matcha flavor.', 25, 3, 'EASY', 440);
INSERT INTO categories (recipeId, categoryName) VALUES (139, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (139, 123, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (139, 163, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (139, 51, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (139, 37, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (139, 62, 2.0, 'tbsp');
-- Recipe: Zucchini Boats with Quinoa & Cranberries
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Zucchini Boats with Quinoa & Cranberries', 'Roasted zucchini stuffed with spiced quinoa and cranberries.', 40, 2, 'MEDIUM', 510);
INSERT INTO categories (recipeId, categoryName) VALUES (140, 'VEGETARIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (140, 6, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (140, 65, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (140, 119, 30.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (140, 82, 20.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (140, 57, 1.0, 'tbsp');
-- Recipe: Thai Peanut Tempeh Bowl
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Thai Peanut Tempeh Bowl', 'Tempeh and veggies tossed in a rich peanut sauce over rice.', 30, 2, 'MEDIUM', 520);
INSERT INTO categories (recipeId, categoryName) VALUES (141, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (141, 102, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (141, 94, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (141, 59, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (141, 63, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (141, 5, 1.0, 'pc');
-- Recipe: Grilled Eggplant with Sumac Yogurt
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (20, 'Grilled Eggplant with Sumac Yogurt', 'Charred eggplant rounds served over creamy sumac yogurt.', 30, 2, 'MEDIUM', 490);
INSERT INTO categories (recipeId, categoryName) VALUES (142, 'MEDITERRANEAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (142, 14, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (142, 48, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (142, 128, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (142, 57, 1.0, 'tbsp');
-- Recipe: Mango Chutney Chickpea Salad
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (25, 'Mango Chutney Chickpea Salad', 'Sweet, spicy, and tangy chickpea salad with chutney dressing.', 15, 2, 'EASY', 460);
INSERT INTO categories (recipeId, categoryName) VALUES (143, 'SALAD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (143, 40, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (143, 161, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (143, 111, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (143, 20, 1.0, 'tbsp');
-- Recipe: Sourdough Garlic Flatbread
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (1, 'Sourdough Garlic Flatbread', 'Crispy flatbread with garlic, herbs, and sourdough tang.', 90, 4, 'HARD', 450);
INSERT INTO categories (recipeId, categoryName) VALUES (144, 'BREAD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (144, 160, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (144, 51, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (144, 3, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (144, 57, 1.0, 'tbsp');
-- Recipe: Cantaloupe Mint Smoothie
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (13, 'Cantaloupe Mint Smoothie', 'Light and refreshing fruit smoothie with a hint of mint.', 10, 2, 'EASY', 300);
INSERT INTO categories (recipeId, categoryName) VALUES (145, 'SMOOTHIE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (145, 139, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (145, 50, 200.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (145, 61, 1.0, 'tbsp');
-- Recipe: Barley & Watercress Salad with Citrus Vinaigrette
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Barley & Watercress Salad with Citrus Vinaigrette', 'Peppery watercress with barley and citrus dressing.', 25, 2, 'EASY', 420);
INSERT INTO categories (recipeId, categoryName) VALUES (146, 'SALAD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (146, 143, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (146, 131, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (146, 75, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (146, 57, 1.0, 'tbsp');
-- Recipe: Ricotta Salata & Beet Crostini
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (24, 'Ricotta Salata & Beet Crostini', 'Earthy beets and salty ricotta salata on toasted bread.', 20, 2, 'EASY', 390);
INSERT INTO categories (recipeId, categoryName) VALUES (147, 'APPETIZER');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (147, 134, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (147, 135, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (147, 69, 2.0, 'slices');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (147, 57, 1.0, 'tbsp');
-- Recipe: Acorn Squash Soup with Clove Cream
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Acorn Squash Soup with Clove Cream', 'Roasted squash soup with warm clove-spiced cream topping.', 45, 4, 'MEDIUM', 480);
INSERT INTO categories (recipeId, categoryName) VALUES (148, 'SOUP');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (148, 118, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (148, 126, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (148, 47, 50.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (148, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (148, 57, 1.0, 'tbsp');
-- Recipe: Horseradish Mashed Potatoes
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (7, 'Horseradish Mashed Potatoes', 'Creamy mashed potatoes with a bold horseradish finish.', 30, 3, 'EASY', 460);
INSERT INTO categories (recipeId, categoryName) VALUES (149, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (149, 145, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (149, 43, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (149, 42, 50.0, 'ml');
-- Recipe: Agave Lime Glazed Shrimp
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (4, 'Agave Lime Glazed Shrimp', 'Sweet and tangy shrimp sautéed in agave and lime.', 20, 2, 'MEDIUM', 510);
INSERT INTO categories (recipeId, categoryName) VALUES (150, 'SEAFOOD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (150, 36, 250.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (150, 159, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (150, 74, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (150, 3, 2.0, 'cloves');
-- Recipe: Tempeh Bahn Mi Sandwich
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Tempeh Bahn Mi Sandwich', 'Vietnamese-inspired sandwich with pickled veg and crispy tempeh.', 30, 2, 'MEDIUM', 560);
INSERT INTO categories (recipeId, categoryName) VALUES (151, 'FUSION');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (151, 102, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (151, 111, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (151, 4, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (151, 60, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (151, 69, 2.0, 'slices');
-- Recipe: Green Bean Almondine
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (7, 'Green Bean Almondine', 'Tender green beans with toasted almonds and lemon.', 20, 2, 'EASY', 410);
INSERT INTO categories (recipeId, categoryName) VALUES (152, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (152, 137, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (152, 82, 30.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (152, 73, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (152, 57, 1.0, 'tbsp');

-- Recipe: Freekeh Breakfast Bowl with Poached Egg
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (13, 'Freekeh Breakfast Bowl with Poached Egg', 'Nutty freekeh with sautéed greens and a perfectly poached egg.', 25, 2, 'EASY', 460);
INSERT INTO categories (recipeId, categoryName) VALUES (153, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (153, 142, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (153, 7, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (153, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (153, 3, 1.0, 'clove');
-- Recipe: Roasted Carrot & Ginger Hummus
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (15, 'Roasted Carrot & Ginger Hummus', 'Smooth hummus with roasted carrots and a ginger kick.', 30, 4, 'EASY', 420);
INSERT INTO categories (recipeId, categoryName) VALUES (154, 'DIP');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (154, 4, 3.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (154, 40, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (154, 130, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (154, 95, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (154, 73, 1.0, 'pc');
-- Recipe: Coconut Tamarind Eggplant Curry
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (25, 'Coconut Tamarind Eggplant Curry', 'A rich, tangy curry with eggplant, tamarind, and coconut milk.', 40, 3, 'MEDIUM', 530);
INSERT INTO categories (recipeId, categoryName) VALUES (155, 'CURRY');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (155, 14, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (155, 49, 150.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (155, 105, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (155, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (155, 22, 1.0, 'tsp');
-- Recipe: Butternut Squash & Ricotta Toast
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Butternut Squash & Ricotta Toast', 'Roasted squash, creamy ricotta, and herbs on crusty bread.', 20, 2, 'EASY', 440);
INSERT INTO categories (recipeId, categoryName) VALUES (156, 'SNACK');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (156, 118, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (156, 123, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (156, 69, 2.0, 'slices');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (156, 18, 1.0, 'tsp');
-- Recipe: Mushroom & Barley Stuffed Peppers
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Mushroom & Barley Stuffed Peppers', 'Bell peppers filled with herbed barley and mushrooms.', 50, 3, 'MEDIUM', 500);
INSERT INTO categories (recipeId, categoryName) VALUES (157, 'COMFORT FOOD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (157, 5, 3.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (157, 143, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (157, 12, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (157, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (157, 21, 1.0, 'tsp');
-- Recipe: Pear & Walnut Chia Parfait
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Pear & Walnut Chia Parfait', 'A layered parfait of pears, chia, and toasted walnuts.', 10, 2, 'EASY', 390);
INSERT INTO categories (recipeId, categoryName) VALUES (158, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (158, 138, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (158, 83, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (158, 48, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (158, 85, 20.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (158, 61, 1.0, 'tbsp');
-- Recipe: Grilled Tofu with Wasabi Soy Glaze
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Grilled Tofu with Wasabi Soy Glaze', 'Charred tofu with bold wasabi-soy glaze.', 25, 2, 'MEDIUM', 480);
INSERT INTO categories (recipeId, categoryName) VALUES (159, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (159, 38, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (159, 146, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (159, 59, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (159, 108, 1.0, 'tbsp');
-- Recipe: Sourdough French Toast with Banana & Cocoa
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Sourdough French Toast with Banana & Cocoa', 'Classic French toast with cocoa and caramelized bananas.', 20, 2, 'EASY', 470);
INSERT INTO categories (recipeId, categoryName) VALUES (160, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (160, 160, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (160, 72, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (160, 37, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (160, 114, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (160, 62, 1.0, 'tbsp');
-- Recipe: Warm Farro Salad with Feta & Sundried Tomato
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Warm Farro Salad with Feta & Sundried Tomato', 'A Mediterranean grain salad with salty feta and tomato.', 30, 2, 'EASY', 490);
INSERT INTO categories (recipeId, categoryName) VALUES (161, 'SALAD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (161, 141, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (161, 117, 40.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (161, 112, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (161, 57, 1.0, 'tbsp');
-- Recipe: Pumpkin Tahini Pasta
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (20, 'Pumpkin Tahini Pasta', 'Creamy vegan pasta with pumpkin and tahini sauce.', 25, 2, 'MEDIUM', 510);
INSERT INTO categories (recipeId, categoryName) VALUES (162, 'PASTA');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (162, 67, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (162, 166, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (162, 95, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (162, 3, 2.0, 'cloves');
-- Recipe: Roasted Celeriac & Apple Mash
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (11, 'Roasted Celeriac & Apple Mash', 'A sweet and earthy twist on mashed potatoes.', 35, 2, 'EASY', 420);
INSERT INTO categories (recipeId, categoryName) VALUES (163, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (163, 144, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (163, 71, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (163, 43, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (163, 53, 1.0, 'tsp');
-- Recipe: Microgreens & Ricotta Flatbread
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (24, 'Microgreens & Ricotta Flatbread', 'Crisp flatbread topped with creamy ricotta and fresh greens.', 20, 2, 'EASY', 460);
INSERT INTO categories (recipeId, categoryName) VALUES (164, 'APPETIZER');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (164, 123, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (164, 132, 20.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (164, 57, 1.0, 'tbsp');
-- Recipe: Thai Basil Shrimp Stir Fry
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (27, 'Thai Basil Shrimp Stir Fry', 'Juicy shrimp stir-fried with garlic, chili, and Thai basil.', 20, 2, 'MEDIUM', 530);
INSERT INTO categories (recipeId, categoryName) VALUES (165, 'SEAFOOD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (165, 36, 250.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (165, 3, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (165, 26, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (165, 16, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (165, 59, 2.0, 'tbsp');
-- Recipe: Quinoa & Green Bean Stir-Fry
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Quinoa & Green Bean Stir-Fry', 'A healthy stir-fry with quinoa, green beans, and sesame.', 20, 2, 'EASY', 460);
INSERT INTO categories (recipeId, categoryName) VALUES (166, 'VEGAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (166, 65, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (166, 137, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (166, 108, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (166, 3, 1.0, 'clove');
-- Recipe: Jackfruit BBQ Sliders with Slaw
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (15, 'Jackfruit BBQ Sliders with Slaw', 'Pulled jackfruit in smoky BBQ sauce with cabbage slaw.', 30, 3, 'MEDIUM', 520);
INSERT INTO categories (recipeId, categoryName) VALUES (167, 'SANDWICH');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (167, 103, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (167, 92, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (167, 115, 3.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (167, 110, 1.0, 'cup');
-- Recipe: Spiced Couscous with Roasted Grapes
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Spiced Couscous with Roasted Grapes', 'Sweet-savory couscous with cinnamon-roasted grapes.', 30, 2, 'MEDIUM', 490);
INSERT INTO categories (recipeId, categoryName) VALUES (168, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (168, 66, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (168, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (168, 27, 0.5, 'tsp');
-- Recipe: Molasses Glazed Carrots
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (11, 'Molasses Glazed Carrots', 'Sweet roasted carrots glazed in warm molasses.', 25, 2, 'EASY', 410);
INSERT INTO categories (recipeId, categoryName) VALUES (169, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (169, 4, 4.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (169, 104, 1.5, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (169, 57, 1.0, 'tbsp');
-- Recipe: Tofu Pesto Grain Bowl
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Tofu Pesto Grain Bowl', 'Protein-packed bowl with tofu, pesto, and grains.', 30, 2, 'EASY', 500);
INSERT INTO categories (recipeId, categoryName) VALUES (170, 'BOWL');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (170, 38, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (170, 93, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (170, 65, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (170, 7, 1.0, 'cup');
-- Recipe: Stuffed Mushrooms with Walnuts & Herbs
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Stuffed Mushrooms with Walnuts & Herbs', 'Savory stuffed mushrooms with a walnut-herb filling.', 35, 4, 'MEDIUM', 480);
INSERT INTO categories (recipeId, categoryName) VALUES (171, 'APPETIZER');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (171, 12, 8.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (171, 85, 40.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (171, 17, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (171, 69, 2.0, 'tbsp');
-- Recipe: Roasted Pineapple Tempeh Bowl
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Roasted Pineapple Tempeh Bowl', 'Sweet roasted pineapple and marinated tempeh over rice.', 30, 2, 'MEDIUM', 520);
INSERT INTO categories (recipeId, categoryName) VALUES (172, 'FUSION');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (172, 102, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (172, 80, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (172, 59, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (172, 63, 150.0, 'g');
-- Recipe: Savory Oatmeal with Togarashi & Egg
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (13, 'Savory Oatmeal with Togarashi & Egg', 'Hearty oatmeal with a spicy Japanese twist.', 15, 1, 'EASY', 410);
INSERT INTO categories (recipeId, categoryName) VALUES (173, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (173, 68, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (173, 147, 0.5, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (173, 59, 1.0, 'tbsp');
-- Recipe: Caraway Roasted Potatoes
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (7, 'Caraway Roasted Potatoes', 'Oven-roasted potatoes tossed in caraway and sea salt.', 35, 3, 'EASY', 460);
INSERT INTO categories (recipeId, categoryName) VALUES (174, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (174, 164, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (174, 57, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (174, 53, 1.0, 'tsp');
-- Recipe: Chocolate Avocado Mousse
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (9, 'Chocolate Avocado Mousse', 'A decadent, dairy-free mousse with avocado and cocoa.', 15, 2, 'EASY', 420);
INSERT INTO categories (recipeId, categoryName) VALUES (175, 'DESSERT');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (175, 76, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (175, 114, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (175, 62, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (175, 50, 50.0, 'ml');
-- Recipe: Spaghetti with Ghee & Black Garlic
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (1, 'Spaghetti with Ghee & Black Garlic', 'A bold-flavored pasta with richness from ghee and garlic.', 20, 2, 'EASY', 500);
INSERT INTO categories (recipeId, categoryName) VALUES (176, 'PASTA');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (176, 67, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (176, 154, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (176, 149, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (176, 17, 1.0, 'tbsp');
-- Recipe: Sweet Potato & Peanut Butter Smoothie
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (13, 'Sweet Potato & Peanut Butter Smoothie', 'Creamy, high-protein smoothie with roasted sweet potato.', 10, 2, 'EASY', 420);
INSERT INTO categories (recipeId, categoryName) VALUES (177, 'SMOOTHIE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (177, 13, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (177, 94, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (177, 50, 250.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (177, 62, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (177, 27, 0.5, 'tsp');
-- Recipe: Ricotta Salata Watermelon Salad
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (24, 'Ricotta Salata Watermelon Salad', 'A bright, salty-sweet salad with juicy watermelon.', 15, 2, 'EASY', 350);
INSERT INTO categories (recipeId, categoryName) VALUES (178, 'SALAD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (178, 135, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (178, 74, 1.0, 'pc');
-- Recipe: Baked Eggs in Creamy Leek Nest
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (7, 'Baked Eggs in Creamy Leek Nest', 'Creamy baked leeks cradle perfectly soft eggs.', 25, 2, 'MEDIUM', 460);
INSERT INTO categories (recipeId, categoryName) VALUES (179, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (179, 15, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (179, 37, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (179, 47, 50.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (179, 43, 1.0, 'tbsp');
-- Recipe: Plantain & Black Bean Stew
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (15, 'Plantain & Black Bean Stew', 'A Caribbean-style vegan stew with spices and sweetness.', 40, 3, 'MEDIUM', 510);
INSERT INTO categories (recipeId, categoryName) VALUES (180, 'STEW');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (180, 133, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (180, 41, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (180, 2, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (180, 3, 2.0, 'cloves');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (180, 57, 1.0, 'tbsp');
-- Recipe: Grilled Polenta with Mushrooms & Truffle Oil
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (20, 'Grilled Polenta with Mushrooms & Truffle Oil', 'Crisp grilled polenta topped with truffle-sautéed mushrooms.', 30, 2, 'MEDIUM', 530);
INSERT INTO categories (recipeId, categoryName) VALUES (181, 'FANCY');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (181, 122, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (181, 12, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (181, 150, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (181, 18, 1.0, 'tsp');
-- Recipe: Roasted Beet & Farro Sliders
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Roasted Beet & Farro Sliders', 'Earthy mini veggie burgers made from beets and farro.', 45, 4, 'HARD', 480);
INSERT INTO categories (recipeId, categoryName) VALUES (182, 'SLIDER');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (182, 134, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (182, 141, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (182, 69, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (182, 90, 1.0, 'tbsp');
-- Recipe: Cardamom Date Oatmeal
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (16, 'Cardamom Date Oatmeal', 'Warm, spiced oats sweetened with dates and cardamom.', 10, 1, 'EASY', 390);
INSERT INTO categories (recipeId, categoryName) VALUES (183, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (183, 68, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (183, 158, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (183, 29, 0.25, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (183, 42, 150.0, 'ml');
-- Recipe: Mango Avocado Rice Paper Rolls
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Mango Avocado Rice Paper Rolls', 'Fresh, tropical veggie rolls with tangy dipping sauce.', 25, 2, 'EASY', 430);
INSERT INTO categories (recipeId, categoryName) VALUES (184, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (184, 113, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (184, 76, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (184, 111, 1.0, 'pc');
-- Recipe: Spicy Harissa Lentil Dip
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (25, 'Spicy Harissa Lentil Dip', 'Bold, creamy lentil dip with North African flavors.', 20, 4, 'EASY', 410);
INSERT INTO categories (recipeId, categoryName) VALUES (185, 'DIP');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (185, 39, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (185, 98, 1.5, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (185, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (185, 73, 1.0, 'pc');
-- Recipe: Almond-Crusted Chicken Tenders
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (4, 'Almond-Crusted Chicken Tenders', 'Crispy chicken strips baked with an almond coating.', 30, 3, 'EASY', 540);
INSERT INTO categories (recipeId, categoryName) VALUES (186, 'DINNER');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (186, 31, 300.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (186, 82, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (186, 69, 30.0, 'g');
-- Recipe: Stuffed Acorn Squash with Bulgur & Cranberries
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (23, 'Stuffed Acorn Squash with Bulgur & Cranberries', 'Fall-inspired squash halves with herby bulgur stuffing.', 45, 2, 'MEDIUM', 500);
INSERT INTO categories (recipeId, categoryName) VALUES (187, 'VEGETARIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (187, 118, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (187, 140, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (187, 119, 30.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (187, 17, 1.0, 'tbsp');
-- Recipe: Gochujang Rice Cakes with Edamame
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (26, 'Gochujang Rice Cakes with Edamame', 'Chewy rice cakes in a spicy-sweet Korean sauce.', 30, 2, 'MEDIUM', 540);
INSERT INTO categories (recipeId, categoryName) VALUES (188, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (188, 120, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (188, 96, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (188, 129, 100.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (188, 153, 1.0, 'stalk');
-- Recipe: Shaved Cucumber & Watercress Salad
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (24, 'Shaved Cucumber & Watercress Salad', 'Light, peppery salad with bright vinaigrette.', 10, 2, 'EASY', 310);
INSERT INTO categories (recipeId, categoryName) VALUES (189, 'SALAD');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (189, 111, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (189, 131, 1.0, 'cup');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (189, 60, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (189, 57, 1.0, 'tbsp');
-- Recipe: Toasted Walnut & Blue Cheese Pasta
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (1, 'Toasted Walnut & Blue Cheese Pasta', 'Creamy pasta with sharp cheese and nutty crunch.', 25, 2, 'MEDIUM', 520);
INSERT INTO categories (recipeId, categoryName) VALUES (190, 'PASTA');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (190, 67, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (190, 85, 30.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (190, 47, 50.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (190, 46, 30.0, 'g');
-- Recipe: Baked Oatmeal with Coconut Sugar & Banana
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (16, 'Baked Oatmeal with Coconut Sugar & Banana', 'Warm baked oats sweetened with banana and coconut sugar.', 30, 3, 'EASY', 450);
INSERT INTO categories (recipeId, categoryName) VALUES (191, 'BREAKFAST');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (191, 68, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (191, 72, 2.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (191, 157, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (191, 50, 200.0, 'ml');
-- Recipe: Thai Cucumber Noodle Salad with Peanut Sauce
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (8, 'Thai Cucumber Noodle Salad with Peanut Sauce', 'Spiralized cucumber tossed in spicy peanut dressing.', 20, 2, 'EASY', 470);
INSERT INTO categories (recipeId, categoryName) VALUES (192, 'ASIAN');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (192, 111, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (192, 94, 1.5, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (192, 74, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (192, 59, 1.0, 'tbsp');
-- Recipe: Maple Dijon Tempeh Skewers
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (15, 'Maple Dijon Tempeh Skewers', 'Sweet-savory grilled tempeh on skewers.', 30, 2, 'MEDIUM', 490);
INSERT INTO categories (recipeId, categoryName) VALUES (193, 'GRILL');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (193, 102, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (193, 165, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (193, 62, 1.5, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (193, 57, 1.0, 'tbsp');
-- Recipe: Wild Mushroom & Thyme Quiche
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (20, 'Wild Mushroom & Thyme Quiche', 'A savory tart packed with mushrooms and fresh herbs.', 60, 4, 'HARD', 560);
INSERT INTO categories (recipeId, categoryName) VALUES (194, 'BRUNCH');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (194, 12, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (194, 37, 3.0, 'pcs');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (194, 42, 100.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (194, 18, 1.0, 'tsp');
-- Recipe: Spaghetti with Saffron Cream Sauce
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (1, 'Spaghetti with Saffron Cream Sauce', 'Elegant saffron-infused pasta in a silky cream sauce.', 25, 2, 'MEDIUM', 580);
INSERT INTO categories (recipeId, categoryName) VALUES (195, 'PASTA');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (195, 67, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (195, 30, 1.0, 'pinch');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (195, 47, 100.0, 'ml');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (195, 3, 1.0, 'clove');
-- Recipe: Baked Ricotta with Zaatar & Olive Oil
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (24, 'Baked Ricotta with Zaatar & Olive Oil', 'Whipped ricotta baked until golden with a zaatar crust.', 20, 2, 'EASY', 460);
INSERT INTO categories (recipeId, categoryName) VALUES (196, 'APPETIZER');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (196, 123, 150.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (196, 127, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (196, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (196, 69, 2.0, 'tbsp');
-- Recipe: Sunflower Seed Granola Bars
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (16, 'Sunflower Seed Granola Bars', 'Chewy homemade bars with oats and sunflower crunch.', 20, 6, 'EASY', 380);
INSERT INTO categories (recipeId, categoryName) VALUES (197, 'SNACK');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (197, 68, 200.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (197, 84, 30.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (197, 61, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (197, 94, 2.0, 'tbsp');
-- Recipe: Crispy Chickpeas with Smoked Paprika
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (6, 'Crispy Chickpeas with Smoked Paprika', 'Roasted spiced chickpeas perfect for snacking or topping.', 25, 4, 'EASY', 410);
INSERT INTO categories (recipeId, categoryName) VALUES (198, 'SNACK');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (198, 40, 300.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (198, 148, 1.0, 'tsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (198, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (198, 53, 0.5, 'tsp');
-- Recipe: Roasted Brussels Sprouts with Molasses Glaze
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (11, 'Roasted Brussels Sprouts with Molasses Glaze', 'Caramelized sprouts finished with a sweet molasses drizzle.', 30, 3, 'EASY', 420);
INSERT INTO categories (recipeId, categoryName) VALUES (199, 'SIDE');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (199, 104, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (199, 57, 1.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (199, 53, 1.0, 'tsp');
-- Recipe: Butternut Squash Tacos with Feta & Pesto
INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories) VALUES (25, 'Butternut Squash Tacos with Feta & Pesto', 'Roasted squash with crumbled feta and herb pesto.', 35, 3, 'MEDIUM', 510);
INSERT INTO categories (recipeId, categoryName) VALUES (200, 'TACOS');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (200, 118, 1.0, 'pc');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (200, 112, 50.0, 'g');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (200, 93, 2.0, 'tbsp');
INSERT INTO recipeIngredients (recipeId, ingredientId, quantity, unit) VALUES (200, 70, 3.0, 'pcs');
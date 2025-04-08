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
    status ENUM('IN PROGRESS', 'COMPLETED'),
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
    FOREIGN KEY (recipeId) REFERENCES recipes(recipeId)
);

# ADDING DATA
-- Users
INSERT INTO users (username, firstName, lastName, email, bio) VALUES
('chefjulia', 'Julia', 'Martinez', 'julia.martinez@example.com', 'Pastry chef with a sweet tooth and a love for French desserts.'),
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
(116, 'Arborio Rice', 'MODERATE');

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
(5, 'Challenge: Make a dish with tuna, chickpeas, and lemon', 'IN PROGRESS', 2),
(4, 'Create BBQ sliders with ingredients you already have at home', 'COMPLETED', 1),
(22, 'Southern Soul Challenge: Use black beans, cabbage, and hot sauce', 'COMPLETED', 6),
(11, 'Use: Eggs, spinach, and cheddar cheese in a single dish', 'IN PROGRESS', 3);


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
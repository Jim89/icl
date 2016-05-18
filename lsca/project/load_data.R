# Step 0 - prep env -------------------------------------------------------
library(dplyr)
library(readr)
library(readxl)

db <- src_postgres(dbname = "lsca")

# Step 1 - read data -------------------------------------------------------
ingredients <- read_csv("./data/hw/ingredients.csv")
menu_items <- read_csv("./data/hw/menu_items.csv")
menuitem <-  read_csv("./data/hw/menuitem.csv") %>% mutate(date = lubridate::ymd(date))
portion_uom_types <- read_csv("./data/hw/portion_uom_types.csv")
pos_ordersale <- read_csv("./data/hw/pos_ordersale.csv") %>% mutate(date = lubridate::ymd(date))
recipe_ingredient_assignments <- read_csv("./data/hw/recipe_ingredient_assignments.csv")
recipe_sub_recipe_assignments <- read_csv("./data/hw/recipe_sub_recipe_assignments.csv")
recipes <- read_csv("./data/hw/recipes.csv")
store_restaurant <- read_excel("./data/hw/store_restaurant.xlsx")
sub_recipe_ingr_assignments <- read_csv("./data/hw/sub_recipe_ingr_assignments.csv")
sub_recipes <- read_csv("./data/hw/sub_recipes.csv")


# Step 2 - set lowercase names --------------------------------------------
colnames(ingredients) <- colnames(ingredients) %>% tolower()
colnames(menu_items) <- colnames(menu_items) %>% tolower()
colnames(menuitem) <- colnames(menuitem) %>% tolower()
colnames(portion_uom_types) <- colnames(portion_uom_types) %>% tolower()
colnames(pos_ordersale) <- colnames(pos_ordersale) %>% tolower()
colnames(recipe_ingredient_assignments) <- colnames(recipe_ingredient_assignments) %>% tolower()
colnames(recipe_sub_recipe_assignments) <- colnames(recipe_sub_recipe_assignments) %>% tolower()
colnames(recipes) <- colnames(recipes) %>% tolower()
colnames(store_restaurant) <- colnames(store_restaurant) %>% tolower()
colnames(sub_recipe_ingr_assignments) <- colnames(sub_recipe_ingr_assignments) %>% tolower()
colnames(sub_recipes) <- colnames(sub_recipes) %>% tolower()

# Step 3 - copy to db -----------------------------------------------------

tmp <- copy_to(db, ingredients, temporary = FALSE)
tmp <- copy_to(db, menu_items, temporary = FALSE)
tmp <- copy_to(db, menuitem, temporary = FALSE)
tmp <- copy_to(db, portion_uom_types, temporary = FALSE)
tmp <- copy_to(db, pos_ordersale, temporary = FALSE)
tmp <- copy_to(db, recipe_ingredient_assignments, temporary = FALSE)
tmp <- copy_to(db, recipe_sub_recipe_assignments, temporary = FALSE)
tmp <- copy_to(db, recipes, temporary = FALSE)
tmp <- copy_to(db, store_restaurant, temporary = FALSE)
tmp <- copy_to(db, sub_recipe_ingr_assignments, temporary = FALSE)
tmp <- copy_to(db, sub_recipes, temporary = FALSE)


# Step 4 - clean up -------------------------------------------------------

rm(list = ls())
gc()




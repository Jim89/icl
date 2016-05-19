library(tidyr)
# 
# # Link orders to menuitem
# sales_to_menu <- pos_ordersale %>%
#   left_join(menuitem, by = c("md5key_ordersale" = "md5key_ordersale")) %>%
#   select(ordernumber,
#          meallocation,
#          transactionid,
#          storenumber.x,
#          date.x,
#          categorydescription,
#          departmentdescription,
#          description,
#          quantity,
#          plu,
#          id) %>%
#   rename(storenumber = storenumber.x,
#          date = date.x) %>%
#   collect()
# 
# 
# # Link to menu_items
# sales_to_menu_to_menu_items <- sales_to_menu %>%
#   left_join(menu_items, by = c("plu" = "plu",
#                                "id" = "menuitemid"),
#             copy = TRUE)
# 
# # Link to recipies
# sales_to_recipe <- sales_to_menu_to_menu_items %>%
#   left_join(recipes, copy = TRUE, by = c("recipeid" = "recipeid"))
# 
# # Link to ingredient quantities
# sales_to_ingredient_quanties <-
#   sales_to_recipe %>%
#   left_join(recipe_ingredient_assignments, copy = TRUE)


# Recipies to ingredients
tom_let_recipes <- recipes %>%
  left_join(recipe_ingredient_assignments) %>%
  left_join(ingredients) %>%
  select(recipeid,
         ingredientid,
         quantity,
         ingredientname,
         portionuomtypeid) %>%
  left_join(portion_uom_types) %>%
  collect() %>%
  mutate(tom = ifelse(grepl("tomato|Tomato", ingredientname), 1, 0),
         let = ifelse(grepl("lettuce|Lettuce", ingredientname), 1, 0)) %>%
  filter(tom == 1 | let == 1) %>% 
  select(recipeid,
         ingredientname,
         quantity,
         portiontypedescription,
         tom,
         let) %>% 
  mutate(quantity_clean = ifelse(portiontypedescription == "Gram",
                                 quantity,
                                 28.3495 * quantity),
         ingredient = ifelse(tom == 1, "tomato", "lettuce")) %>% 
  select(recipeid, ingredient, quantity_clean) %>% 
  spread(ingredient, quantity_clean) %>% 
  mutate(lettuce = ifelse(is.na(lettuce), 0, lettuce),
         tomato = ifelse(is.na(tomato), 0, tomato))


# Sub-recipes to ingredients
tom_let_sub_recipes <- sub_recipes %>% 
  left_join(sub_recipe_ingr_assignments) %>% 
  left_join(ingredients) %>% 
  select(subrecipeid,
         ingredientid,
         quantity,
         ingredientname,
         portionuomtypeid) %>% 
  left_join(portion_uom_types) %>%
  collect() %>% 
  mutate(tom = ifelse(grepl("tomato|Tomato", ingredientname), 1, 0),
         let = ifelse(grepl("lettuce|Lettuce", ingredientname), 1, 0)) %>%
  filter(tom == 1 | let == 1) %>% 
  select(subrecipeid,
         ingredientname,
         quantity,
         portiontypedescription,
         tom,
         let) %>% 
  mutate(quantity_clean = ifelse(portiontypedescription == "Gram",
                                 quantity,
                                 28.3495 * quantity),
         ingredient = ifelse(tom == 1, "tomato", "lettuce")) %>% 
  select(subrecipeid, ingredient, quantity_clean) %>% 
  spread(ingredient, quantity_clean) %>% 
  mutate(lettuce = ifelse(is.na(lettuce), 0, lettuce),
         tomato = ifelse(is.na(tomato), 0, tomato))


# Create a unified view of recipes to ingredients
recipe_to_sub_tom_let <- recipe_sub_recipe_assignments %>% 
  # inner_join(tom_let_recipes, copy = TRUE) %>% 
  select(recipeid, subrecipeid, factor) %>% 
  inner_join(tom_let_sub_recipes, copy = T) %>% 
  mutate(Lettuce = lettuce * factor,
         Tomato = tomato * factor) %>% 
  select(recipeid, subrecipeid, lettuce, tomato) %>% 
  rename(sub_let = lettuce,
         sub_tom = tomato) %>% 
  collect() 


# All recipies with SOME tomato or lettuce, and the required amount  
recipes_to_tom_let <- tom_let_recipes %>% 
  full_join(recipe_to_sub_tom_let) %>% 
  select(recipeid, lettuce, tomato, sub_let, sub_tom) %>% 
  rowwise() %>% 
  mutate(total_lettuce = sum(lettuce, sub_let, na.rm = T),
         total_tomato = sum(tomato, sub_tom, na.rm = T)) %>% 
  select(recipeid, total_lettuce, total_tomato) %>% 
  collect()

  
# Join menu items to lettuce and tomato needs
menu_items_to_tom_let <- menu_items %>% 
  collect() %>% 
  inner_join(recipes_to_tom_let)

# Use menuitem to link ordersale md5 IDs to total lettuce and tomato requirements
let_tom_reqs <- menuitem %>%
  select(md5key_ordersale, quantity, plu, id, date) %>% 
  collect() %>% 
  inner_join(menu_items_to_tom_let, by = c("plu" = "plu", 
                                           "id" = "menuitemid")) %>% 
  mutate(lettuce = quantity * total_lettuce,
         tomato = quantity * total_tomato) %>% 
  select(md5key_ordersale, lettuce, tomato) %>% 
  group_by(md5key_ordersale) %>% 
  summarise(lettuce = sum(lettuce),
            tomato = sum(tomato))

# Link lettuce and tomato requirements to sales
sales_to_demand <- pos_ordersale %>% 
  collect() %>% 
  inner_join(let_tom_reqs)

# Summarise by data to create ts
daily_demand <- sales_to_demand %>% 
  group_by(date) %>% 
  summarise(lettuce = sum(lettuce),
            tomato = sum(tomato))
  
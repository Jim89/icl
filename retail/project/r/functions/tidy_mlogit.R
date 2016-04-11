tidy_mlogit <- function(model_fit){
  tbl <- summary(model_fit)$CoefTable %>% 
          as.data.frame() %>% 
          add_rownames() %>% 
          rename(Coefficient = rowname) %>% 
          mutate(Coefficient = ifelse(grepl("asda", Coefficient), "Asda", Coefficient),
                 Coefficient = ifelse(grepl("morris", Coefficient), "Morrisons", Coefficient),
                 Coefficient = ifelse(grepl("sains", Coefficient), "Sainsburys", Coefficient),
                 Coefficient = ifelse(grepl("tesco", Coefficient), "Tesco", Coefficient),
                 Coefficient = ifelse(grepl("^price", Coefficient), "Price", Coefficient),
                 Coefficient = ifelse(grepl("promo_p", Coefficient), "Price Promo.", Coefficient),
                 Coefficient = ifelse(grepl("promo_u", Coefficient), "Unit Promo.", Coefficient),
                 Coefficient = ifelse(grepl("loy", Coefficient), "Loyalty", Coefficient))
}  
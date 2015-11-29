library(readxl)

data <- read_excel("./ampl_models/CEO_Comp.xlsx")

fit <- lm(comp ~ years + change_stock + change_sales + mba, data)

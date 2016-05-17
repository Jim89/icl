
vungle <- readxl::read_excel("./data/labs02/Copy of ABtesting vungle.xlsx", sheet = 2)

a <- vungle[which(vungle$Strategy == "Vungle A"), "eRPM"]
b <- vungle[which(vungle$Strategy == "Vungle B"), "eRPM"]

t.test(a, b, paired = T)

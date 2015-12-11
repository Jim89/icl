library(quantmod)

symbols <- c("RDSA", "HSBA", "BP", "VOD", "GSK", "BTI", "SAB", "DGE", "BG", "RIO")
y_symbols <- c("RDS-A", "HSBA.L", "BP.L", "VOD.L", "GSK.L", "BTI", "SAB.L", "DGE.L", "BG.L", "RIO.L")
getSymbols(symbols, src = "google")
getSymbols(y_symbols)

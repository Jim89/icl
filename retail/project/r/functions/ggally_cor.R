# Source function for GGally pairs plot, helpfully adapted from 
# https://github.com/tonytonov/ggally/blob/master/R/gg-plots.r

ggally_cor <- function(data, mapping, corAlignPercent = 0.6, ...){
  
  # xVar <- data[,as.character(mapping$x)]
  # yVar <- data[,as.character(mapping$y)]
  # x_bad_rows <- is.na(xVar)
  # y_bad_rows <- is.na(yVar)
  # bad_rows <- x_bad_rows | y_bad_rows
  # if (any(bad_rows)) {
  #   total <- sum(bad_rows)
  #   if (total > 1) {
  #     warning("Removed ", total, " rows containing missing values")
  #   } else if (total == 1) {
  #     warning("Removing 1 row that contained a missing value")
  #   }
  #
  #   xVar <- xVar[!bad_rows]
  #   yVar <- yVar[!bad_rows]
  # }
  
  # mapping$x <- mapping$y <- NULL
  
  xCol <- as.character(mapping$x)
  yCol <- as.character(mapping$y)
  colorCol <- as.character(mapping$colour)
  
  if(length(colorCol) > 0) {
    if(colorCol %in% colnames(data)) {
      rows <- complete.cases(data[,c(xCol,yCol,colorCol)])
    } else {
      rows <- complete.cases(data[,c(xCol,yCol)])
    }
  } else {
    rows <- complete.cases(data[,c(xCol,yCol)])
  }
  
  if(any(!rows)) {
    total <- sum(!rows)
    if (total > 1) {
      warning("Removed ", total, " rows containing missing values")
    } else if (total == 1) {
      warning("Removing 1 row that contained a missing value")
    }
  }
  data <- data[rows, ]
  xVal <- data[,xCol]
  yVal <- data[,yCol]
  
  
  if(length(names(mapping)) > 0){
    for(i in length(names(mapping)):1){
      # find the last value of the aes, such as cyl of as.factor(cyl)
      tmp_map_val <- as.character(mapping[names(mapping)[i]][[1]])
      if(tmp_map_val[length(tmp_map_val)] %in% colnames(data))
        mapping[names(mapping)[i]] <- NULL
      
      if(length(names(mapping)) < 1){
        mapping <- NULL
        break;
      }
    }
  }
  
  
  # splits <- str_c(as.character(mapping$group), as.character(mapping$colour), sep = ", ", collapse = ", ")
  # splits <- str_c(colorCol, sep = ", ", collapse = ", ")
  final_text <- ""
  if(length(colorCol) < 1)
    colorCol <- "ggally_NO_EXIST"
  # browser()
  if(colorCol != "ggally_NO_EXIST" && colorCol %in% colnames(data)) {
    
    txt <- str_c("ddply(data, .(", colorCol, "), summarize, ggally_cor = cor(", xCol,", ", yCol,"))[,c('", colorCol, "', 'ggally_cor')]")
    
    con <- textConnection(txt)
    on.exit(close(con))
    cord <- eval(parse(con))
    
    # browser()
    cord$ggally_cor <- signif(as.numeric(cord$ggally_cor), 3)
    
    # put in correct order
    lev <- levels(data[[colorCol]])
    ord <- rep(-1, nrow(cord))
    for(i in 1:nrow(cord)) {
      for(j in seq_along(lev)){
        if(identical(as.character(cord[i, colorCol]), as.character(lev[j]))) {
          ord[i] <- j
        }
      }
    }
    # print(order(ord[ord >= 0]))
    # print(lev)
    cord <- cord[order(ord[ord >= 0]), ]
    
    cord$label <- str_c(cord[[colorCol]], ": ", cord$ggally_cor)
    
    # calculate variable ranges so the gridlines line up
    xmin <- min(xVal)
    xmax <- max(xVal)
    xrange <- c(xmin-.01*(xmax-xmin),xmax+.01*(xmax-xmin))
    ymin <- min(yVal)
    ymax <- max(yVal)
    yrange <- c(ymin-.01*(ymax-ymin),ymax+.01*(ymax-ymin))
    
    
    # print(cord)
    p <- ggally_text(
      label   = str_c("Cor : ", signif(cor(xVal,yVal),3)),
      mapping = mapping,
      xP      = 0.5,
      yP      = 0.9,
      xrange  = xrange,
      yrange  = yrange,
      color   = "black",
      ...
    ) +
      #element_bw() +
      theme(legend.position = "none")
    
    xPos <- rep(corAlignPercent, nrow(cord)) * diff(xrange) + min(xrange)
    yPos <- seq(from = 0.9, to = 0.2, length.out = nrow(cord) + 1) * diff(yrange) + min(yrange)
    yPos <- yPos[-1]
    # print(range(yVal))
    # print(yPos)
    cordf <- data.frame(xPos = xPos, yPos = yPos, labelp = cord$label)
    p <- p + geom_text(
      data=cordf,
      aes(
        x = xPos,
        y = yPos,
        label = labelp,
        color = labelp
      ),
      hjust = 1,
      ...
      
    )
    
    p$type <- "continuous"
    p$subType <- "cor"
    p
  } else {
    # calculate variable ranges so the gridlines line up
    xmin <- min(xVal)
    xmax <- max(xVal)
    xrange <- c(xmin-.01*(xmax-xmin),xmax+.01*(xmax-xmin))
    ymin <- min(yVal)
    ymax <- max(yVal)
    yrange <- c(ymin-.01*(ymax-ymin),ymax+.01*(ymax-ymin))
    
    cor_obj <- cor.test(xVal, yVal)
    cor_signif <- symnum(cor_obj$p.value, corr = FALSE,
                         cutpoints = c(0, .001, .01, .05, .1, 1),
                         symbols = c("***", "**", "*", ".", " "))
    cor_text_size <- 5 + 10*abs(cor_obj$estimate)
    
    p <- ggally_text(
      label = paste(
        signif(cor_obj$estimate, 3),
        cor_signif,
        sep="",collapse=""
      ),
      mapping,
      xP=0.5,
      yP=0.5,
      xrange = xrange,
      yrange = yrange,
      size=8,
      ...
    ) +
      #element_bw() +
      theme(legend.position = "bottom",
            axis.text.y = element_text(size = 10, colour = "black"),
            axis.text.x = element_text(size = 10, colour = "black"),
            legend.text = element_text(size = 10),
            legend.title = element_text(size = 10),
            strip.text = element_text(size = 10, colour = "black"),
            strip.background = element_rect(fill = "white"),
            panel.grid.minor.x = element_blank(),
            panel.grid.major.x = element_blank(),
            panel.grid.minor.y = element_blank(),
            panel.grid.major.y = element_blank(),
            panel.margin.y = unit(0.1, units = "in"),
            panel.background = element_rect(fill = "white", colour = "lightgrey"),
            panel.border = element_rect(colour = "black", fill = NA))
    
    p$type <- "continuous"
    p$subType <- "cor"
    p
  }
}
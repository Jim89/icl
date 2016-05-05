
# Create normalise --------------------------------------------------------
# Normalise is a functiont that takes in a numeric vector and normalises it,
# subtracting the mean from each element, before dividing by the standard deviation
normalise <- function(vec) {
    ans <- (vec - mean(vec)) / sd(vec)
    return(ans)
}

# PV
pv <- function(x, r, t) {
  x/((1+r)^t)
}

# npv
npv <- function(cost, pv){
  pv - cost
}

# fv
fv <- function ( pv, r, t ) {
  pv * ((1+r)^t)
}

# bond prices
bond_price <- function(principal, coupon, yield, mat) {
  sum(sapply(1:mat, function(x) ((floor(x/mat)*principal)+coupon*principal)/((1+yield)^x)))
}

# convert simple to compound rate:

compound_to_simple <- function( rate, compounding_periods) {
  ((1 + (rate/compounding_periods))^compounding_periods)-1
}

simple_to_compound <- function( rate, compounding_periods) {
  compounding_periods*(((1+rate)^(1/compounding_periods))-1)
}





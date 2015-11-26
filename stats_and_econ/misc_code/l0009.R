load("./data/mroz.RData")

fit <- glm(inlf ~ nwifeinc + educ + exper + expersq + age + kidslt6 + kidsge6, data, family = binomial(link = "logit"))

# rearrange AIC formula to get log likelihood
log_likelihood <- (fit$aic - 2*length(fit$coefficients))/(-2)

# get log likelyhood from deviance:
fit$deviance/(-2)

# get pseudo r^2
1 - fit$deviance/fit$null.deviance

# correct predicted
mean(abs(data$inlf - fit$fitted.values) <= .5)

# overall signif
overall <- fit$null.deviance - fit$deviance
pchisq(overall, df = (fit$df.null - fit$df.residual), lower.tail = F)

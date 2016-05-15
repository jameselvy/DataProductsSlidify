# http://www.r-bloggers.com/visually-weighted-regression-in-r-a-la-solomon-hsiang/
# http://rstudio-pubs-static.s3.amazonaws.com/1001_3177e85f5e4840be840c84452780db52.html# mixtools
library(mixtools)    # install.packages("mixtools")

# http://stackoverflow.com/questions/25313578/any-suggestions-for-how-i-can-plot-mixem-type-data-using-ggplot2
comp.proportions <- c(5000, 4000, 500)
comp.means <- c(1.5, 3, 8)
comp.stdevs <- c(1.5, 2, 4)

# create component distributions
comp.1 <- rnorm(comp.proportions[1], mean=comp.means[1], sd=comp.stdevs[1]); den.comp.1 <- density(comp.1)
comp.2 <- rnorm(comp.proportions[2], mean=comp.means[2], sd=comp.stdevs[2]); den.comp.2 <- density(comp.2)
comp.3 <- rnorm(comp.proportions[3], mean=comp.means[3], sd=comp.stdevs[3]); den.comp.3 <- density(comp.3)

# build up mix distribution
mix <- c(comp.1, comp.2, comp.3)

# plot of mixed distribution
hist(mix, freq = F, main = "Synthesized tri-modal distribution", xlab = "Data")    # proportions
#plot(density(mix), col = "black")
lines(den.comp.1$x, den.comp.1$y * (comp.proportions[1] / sum(comp.proportions)), col = "red", lwd = 2)
lines(den.comp.2$x, den.comp.2$y * (comp.proportions[2] / sum(comp.proportions)), col = "blue", lwd = 2)
lines(den.comp.3$x, den.comp.3$y * (comp.proportions[3] / sum(comp.proportions)), col = "green", lwd = 2)

# Use mixtools to generate decomposition
mixModel <- normalmixEM(mix, lambda=NULL, mu=NULL, sigma=NULL, k=3)   # k=3 as we expect three populations are sampled
plot(mixModel, which = 2, main2 = "Decomposition of tri-modal distribution using 'mixtools'")
summary(mixModel)

# compare actual proportions with 'mixmode' model prediction
# round((proportions / sum(proportions)) * 100, 0)
# round(mixModel$lambda * 100, 0)
# 
# # compare actual means with 'mixmode' model prediction
# means
# round(mixModel$mu, 2)
# 
# # compare actual stDevs with 'mixmode' model prediction
# sds
# round(mixModel$sigma, 2)

# make dataframe of comparisons
comparisonTable <- data.frame(round((proportions / sum(proportions)) * 100, 0), means, sds, round(mixModel$lambda * 100, 0), round(mixModel$mu, 2), round(mixModel$sigma, 2), row.names = c("Sample1", "Sample2", "Sample3")) 
names(comparisonTable) <- c("percent", "mean", "sd", "mix.percent", "mix.mean", "mix.sd")
comparisonTable


# http://dsp.stackexchange.com/questions/26358/how-to-detect-whether-a-signal-is-unimodal-or-bimodal
library(diptest)   # install.packages("diptest")
dip.test(mixModel)





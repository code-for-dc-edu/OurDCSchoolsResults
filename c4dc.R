# R version 3.0.2
# written by winnie

data <- read.csv("~/Dropbox/c4dc/ourschoolsdc-2014-05-11.csv")

# whether old_boundary is the same as new_boundary
data$change <- ifelse(as.character(data$old_boundary) == as.character(data$new_boundary), 0, 1)

dim(data)
table(data$ward, useNA = "always")
table(data$ward, data$change, useNA = "always")
table(data$change, data$boundaries_value)
table(data$cluster, useNA = "always")
table(data$old_boundary, useNA = "always")
unique(data$address)[1:20]
table(data$boundaries_value, useNA = "always")

# create data for cluster
dataC <- subset(data, select = c(boundaries_value, feederpatterns_value, eschoicesets_value, mschoicesets_value, msproximity_value, hslottery_value, setasides_value))
dim(dataC)
dataC <- na.exclude(dataC)
dim(dataC)

dif <- apply(dataC, 2, max) - apply(dataC, 2, min)
dataC.dat <- sweep(dataC, 2, dif, FUN = "/")
n <- nrow(dataC.dat)
wss <- rep(0, 10)
wss[1] <- (n - 1) * sum(apply(dataC.dat, 2, var))
for (i in 2:10)
  wss[i] <- sum(kmeans(dataC.dat, centers = i)$withinss)
png("~/Desktop/wss.png", width = 480, height = 480)
plot(1:10, wss, type = "b", xlab = "Number of groups", ylab = "Within groups sum of squares")
dev.off()

cluster1 <- kmeans(dataC, center = 3)
aggregate(dataC,by = list(cluster1$cluster),FUN = mean)
dataC <- data.frame(dataC, cluster1$cluster)
dataC$cluster <- data$cluster1.cluster
dataC <- subset(dataC, select = -cluster1.cluster)



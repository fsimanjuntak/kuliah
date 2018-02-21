library(cluster)
x = c(1,3,4,7,9, 14, 16, 17)
y= c(9.5, 8.5,8, 6.5, 5.5, 3, 2, 1.5)

z= c(1,3,6,10,16);

df = data.frame(z)

agn <- agnes(x=df, diss = FALSE, stand = TRUE, method = "single")
DendAgn <-as.dendrogram(agn)
plot(DendAgn)



#create vectors -- these will be our columns
a <- c(0,2,0,2,1)
b <- c(0,0,2,2,1)

c <- c(2,3,5,6,4)
d <- c(6,3,5,2,4)

M <- cbind(c,d)

cov(M)
library(tidyverse)


#question 5.a.1
n <- 15
x_avg <- 30
sd <- 5
se <- sd/sqrt(n)

t_a1 <-  qt(0.025,n-1)
t_a2 <-  qt(0.975,n-1)

ci_a1 <- (x_avg + (se*t_a1))
ci_a2 <- (x_avg + (se*t_a2))


#question 5.a.2
t_b1 <-  qt(0.005,n-1)
t_b2 <-  qt(0.995,n-1)

ci_b1 <- (x_avg + (se*t_b1))
ci_b2 <- (x_avg + (se*t_b2))



#question 5.a.3
t_c1 <-  qt(0.1,n-1)
t_c2 <-  qt(0.9,n-1)

ci_c1 <- (x_avg + (se*t_c1))
ci_c2 <- (x_avg + (se*t_c2))



#question 5.c
t_c1 <- sqrt((25*14)/ qchisq(0.025, 14))
t_c2  <- sqrt((25*14)/ qchisq(0.975, 14))

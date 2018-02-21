
falseacceptanceerror= 0.0005
#given false probability acceptance error = 0.0005, determine the value of d
#normal distributin, z= (d - m0)/sqrt(sd2)
d = qnorm(falseacceptanceerror,mean=0.5002, sd=sqrt(0.0100))

#obtain the value of false rejection rate
1-pnorm(d, mean=0.5002, sd=sqrt(0.0100))


significance = pnorm(d, mean=0.0262, sd=sqrt(0.0100))
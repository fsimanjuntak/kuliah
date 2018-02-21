rm(list = ls())
library("dplyr")
score_reexam = c(45,39,10,25,15,49,30,32,22,41)
score_exam = c(39,35,13,22,16,41,27,25,20,33)
df = 9
confidence_interval = 0.95

t_alpha = qt(confidence_interval, df)
t_alpha
t.test(score_reexam, score_exam, alternative = "greater", conf.level = 0.95, var.equal = FALSE, paired = TRUE)



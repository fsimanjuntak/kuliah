rm(list = ls())
library("dplyr")
score_reexam = c(45,39,10,25,15,49,30,32,22,41)
score_exam = c(39,35,13,22,16,41,27,25,20,33)
confidence_interval = 0.95

t_result <- t.test(score_reexam, score_exam, alternative = "great", conf.level = 0.95, var.equal = FALSE, paired = FALSE)
t_result

t_alpha <- qt(confidence_interval, t_result$parameter)
t_alpha
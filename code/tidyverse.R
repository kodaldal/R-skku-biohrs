a <- read.csv("https://raw.githubusercontent.com/jinseob2kim/R-skku-biohrs/main/data/smc_example1.csv")

library(magrittr)
a %>% head

a %>% head(n = 10)
10 %>% head(a, .)   
10 %>% head(a, n = .)

subset(a, Sex == "M")
a %>% subset(Sex == "M")

## original 
a$Sex                  ## data.frame style
a[, "Sex"]             ## matrix style
a[["Sex"]]             ## list style

## tidyverse style
a %>% .$Sex
a %>% .[, "Sex"]
a %>% .[["Sex"]]


a %>% .$EXMD_BZ_YYYY
a %>% .[, "EXMD_BZ_YYYY"]
a %>% .[["EXMD_BZ_YYYY"]]
head(subset(a, EXMD_BZ_YYYY == 2009))
a %>% subset(EXMD_BZ_YYYY = 2009) %>% head
a %>% subset(., EXMD_BZ_YYYY = 2009) %>% head

b <- subset(a, EXMD_BZ_YYYY == 2009)
model <- glm(LDL ~ FBS + BMI, data = b)
summ.model <- summary(model)
summ.model$coefficients

a %>% 
  a %>% subset(EXMD_BZ_YYYY == 2009) %>% 
  glm(LDL ~ FBS + BMI, data = .) %>% 
  summary() %>% 
  .$coefficients

aggregate(cbind(WSTC, BMI) ~ Q_PHX_DX_HTN, data = ex, mean)

b <- subset(a, Age >= 50) 
aggregate(. ~ Sex + Smoking, data = b, 
          FUN = function(x){c(mean = mean(x), sd = sd(x))})

a %>% 
  subset(EXMD_BZ_YYYY %in% 2009:2012) %>% 
  aggregate(. ~ Q_PHX_DX_HTN + Q_PHX_DX_DM, data = ., 
            FUN = function(x) {c(mean = mean(x), sd = sd(x))})
a %>% 
  subset(EXMD_BZ_YYYY %in% 2009:2012) %>% 
  aggregate(. ~ Q_PHX_DX_HTN + Q_PHX_DX_DM, data = ., 
            FUN = function(x) {c(mean = mean(x), sd = sd(x))}) -> out

out <- a %>% 
  subset(EXMD_BZ_YYYY %in% 2009:2012) %>% 
  aggregate(. ~ Q_PHX_DX_HTN + Q_PHX_DX_DM, data = ., 
            FUN = function(x) {c(mean = mean(x), sd = sd(x))})


library(dplyr)   

a %>% subset(Sex == "M") %>% .[, c("Sex", "Age", "Height", "Weight", "BMI", "DM", "HTN")] %>% .[order(.$Age), ]
a %>% subset(Sex == "M") %>% .[, 2:8] %>% .[order(.$Age), ]
a %>% filter(Sex == "M") %>% select(Sex:HTN) %>% arrange(Age)

b <- a %>% mutate(new_x = 1, new_y = 2)
a %>% transmute(new_x = 1, new_y = 2)

aggregate(BMI ~ Sex + Smoking, data = a,
          FUN = function(x) {c(mean = mean(x), sd = sd(x))})
          

a %>% 
  group_by(Sex, Smoking) %>% 
  summarize(count = n(),              ## n()는 샘플수 
            meanBMI = mean(BMI),
            sdBMI = sd(BMI))

a %>% 
  subset(Age >= 50) %>%
  aggregate(. ~ Sex + Smoking, data = ., 
            FUN = function(x){c(mean = mean(x), sd = sd(x))})

a %>% 
  filter(Age >= 50) %>% 
  select(-STRESS_EXIST) %>%
  group_by(Sex, Smoking) %>%
  summarize_all(list(mean = mean, sd =sd))
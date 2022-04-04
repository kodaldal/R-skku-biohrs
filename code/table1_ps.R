## Setup

# install.packages("data.table")
# install.packages("curl")
# install.packages("tableone")

library(data.table)
library(curl)

library(tableone)

## Exam data: 09-15
dt <- read.csv("https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv")

for (v in grep("Q_", vars.tb1, value = T)){
  dt[[v]] <- factor(dt[[v]])
}

vars.tb1 <- names(dt)[-c(1:3)]

# create table1
CreateTableOne(vars.tb1, data=dt)

zz <- CreateTableOne(vars.tb1, data=dt, strata = "Q_PHX_DX_STK")

print(zz, nonnormal = c("GCT", "GFR"), 
      exact = c("Q_SMK_YN"), smd = T,
      showAllLevels = T, cramVars = c("QPHX_DX_HTDZ"))

write.csv(print(zz), "tbl.csv", row.names = T)
getwd()

## table 1
vars.tb1 <- setdiff(names(data.final), c("RN_INDI", "COD1", "COD2", "Indexdate"))
CreateTableOne(vars = vars.tb1, data = data.final)

CreateTableOne(vars.tb1, strata = "SEX", data = data.final) %>% 
  print(showAllLevels = T, nonnormal = c("Day_FU", "MIday"), exact = "MI", smd = T) %>% write.csv("tb1.csv", row.names = T)


## Matching
library(MatchIt)
vars.mat <- c("Age", "Prev_Glucocorticoids", "Prev_Mild_liver_dz", "Prev_Chronic_pulmonary_dz")
cc <- matchit(as.formula(paste0("SEX ~", paste(vars.mat, collapse = "+"))), data = data.final, ratio = 1)

data.mat <- match.data(cc)
data.final[, ps := cc$distance][, w := ifelse(SEX == "2", 1/ps, 1/(1 - ps))]
data.final[, w := ifelse(w > 10, 10, w)]                                       ## Weight limit 10
data.design <- survey::svydesign(ids = ~1, weights = ~w, data = data.final)

CreateTableOne(vars.tb1, strata = "SEX", data = data.mat) %>% 
  print(showAllLevels = T, nonnormal = c("Day_FU", "MIday"), exact = "MI", smd = T)

svyCreateTableOne(vars.tb1, strata = "SEX", data = data.design) %>% 
  print(showAllLevels = T, nonnormal = c("Day_FU", "MIday"), exact = "MI", smd = T) 




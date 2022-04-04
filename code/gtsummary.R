## Setup

# install.packages("tidyverse")
# install.packages("data.table")
# install.packages("gtsummary")

library(tidyverse)
library(data.table)
library(gtsummary)

## Load file

url <- "https://raw.githubusercontent.com/jinseob2kim/lecture-snuhlab/master/data/example_g1e.csv"
dt <- fread(url, header=T)
dt

dt2 <- dt %>% select("EXMD_BZ_YYYY", "Q_PHX_DX_STK", "Q_SMK_YN",
                     "HGHT", "WGHT" ,"TOT_CHOL", "TG")
dt2

dt2 %>%
  tbl_summary(
    by = EXMD_BZ_YYYY,
    statistic = list(all_continuous() ~ "{mean} ({sd})",
                     all_categorical() ~ "{n} / {N} ({p}%)"),
    label = Q_SMK_YN ~ "smoking y/n",
    missing_text = "Missing"
  )
#############

tbl_summary(dt[, ..vars.tb1], by="QP_PHX_DX_DM") -> zz

as_flex_table() %>%
  flextable::save_as_doxc(zz, path="./table.docx")
library(haven);library(data.table);library(magrittr);library(fst)
# Set core number when data.table
setDTthreads(0)  ## 0: All

## SAS to fst/csv
for (v in c("bnc", "bnd", "m20", "m30", "m40", "m60", "inst", "g1e_0208", "g1e_0915")){
  read_sas(file.path("nhis/data", paste0("nsc2_", v, "_1000.sas7bdat"))) %>% 
    #write_fst(file.path("data", paste0("nsc2_", v, "_1000.fst")))
    fwrite(file.path("nhis/data", paste0("nsc2_", v, "_1000.csv")))
}


## fst
setwd("D:/_study/Dev/R/R-skku-biohrs/nhis/")

inst <- read_fst("data/nsc2_inst_1000.fst", as.data.table = T)
bnc <- read_fst("data/nsc2_bnc_1000.fst", as.data.table = T) 
bnd <- read_fst("data/nsc2_bnd_1000.fst", as.data.table = T) 
m20 <- read_fst("data/nsc2_m20_1000.fst", as.data.table = T) 
m30 <- read_fst("data/nsc2_m30_1000.fst", as.data.table = T) 
m40 <- read_fst("data/nsc2_m40_1000.fst", as.data.table = T) 
m60 <- read_fst("data/nsc2_m60_1000.fst", as.data.table = T) 
g1e_0915 <- read_fst("data/nsc2_g1e_0915_1000.fst", as.data.table = T) 


## csv
# bnd <- fread("data/nsc2_bnd_1000.csv") 
# lubridate::ym(bnd$DTH_YYYYMM) %>% lubridate::ceiling_date(unit = "month")

inst <- fread("data/nsc2_inst_1000.csv")
bnc <- fread("data/nsc2_bnc_1000.csv") 
bnd <- fread("data/nsc2_bnd_1000.csv") [, Deathdate := (lubridate::ym(DTH_YYYYMM) %>% lubridate::ceiling_date(unit = "month") - 1)][]
m20 <- fread("data/nsc2_m20_1000.csv") 
m30 <- fread("data/nsc2_m30_1000.csv") 
m40 <- fread("data/nsc2_m40_1000.csv")[SICK_CLSF_TYPE %in% c(1, 2, NA)]
m60 <- fread("data/nsc2_m60_1000.csv") 
# g1e_0915 <- fread("data/nsc2_g1e_0915_1000.csv") 


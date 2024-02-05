# load library
library(readxl)
library(lmerTest)
library(lme4)


# specify file name
file_name <- "/Users/giuseppe/Library/CloudStorage/OneDrive-King'sCollegeLondon/SantAnna/progetto_inzhikevich/funzioni_domanda_calogero/reset_times_FS.xlsx"
dataframe <- read_excel(file_name,col_types = c("numeric", "numeric", "numeric", "numeric", "numeric"))

model <- glm( (" TIME ~ C(solver) + tau + step + current"), data = dataframe)
summary(model)

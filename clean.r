library(dplyr)

df <- read.csv("raw_data.csv")

# From Gemini
df <- df |> mutate(across(c(RELATIONTO, TDOTLOC, TYPEOFCRAS, FIRSTHARMF, MANNEROFCO, WEATHER, LIGHTCONDI), 
                          as.factor))

df$DATEOFCRAS <- as.Date(df$DATEOFCRAS, format = "%m/%d/%Y")

# Fix the mangled RELATIONTO column using regular expressions
# DRIVEWAY, ALLEY AC -> DRIVEWAY, ALLEY ACCESS, ETC.
# INTERSECTION RELA* -> INTERSECTION RELATED



summary(df)
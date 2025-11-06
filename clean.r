library(dplyr)

df <- read.csv("raw_data.csv")

# From Gemini
df <- df |> mutate(across(c(RELATIONTO, TDOTLOC, TYPEOFCRAS, FIRSTHARMF, MANNEROFCO, WEATHER, LIGHTCONDI), 
                          as.factor))

df$DATEOFCRAS <- as.Date(df$DATEOFCRAS, format = "%m/%d/%Y")

# Fix the mangled RELATIONTO column using regular expressions
# DRIVEWAY, ALLEY AC* -> DRIVEWAY, ALLEY ACCESS, ETC.
# INTERSECTION RELA* -> INTERSECTION RELATED

levels(df$RELATIONTO) <- gsub(df$RELATIONTO, "DRIVEWAY, ALLEY AC\\w+", "DRIVEWAY, ALLEY ACCESS, ETC.")
levels(df$RELATIONTO) <- gsub(df$RELATIONTO, "INTERSECTION RELA\\w+", "INTERSECTION RELATED")

# Drop unneeded columns (same value for all instances/useless data)
df <- df |> select(-Shape.., 
                   -MSLINK, -RELATIONT2, -URBAN, -NBR_TENN_C, 
                   -NBR_RT2, -SPCL_CSE, -CNTY_SEQ, -YEAROFCRAS, 
                   -LOCATE_TYP, -Hour)

summary(df)
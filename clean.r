library(dplyr)

df <- read.csv("raw_data.csv")

# Fix the mangled RELATIONTO column using regular expressions
# DRIVEWAY* -> DRIVEWAY, ALLEY ACCESS, ETC.
# INTERSECTION RELA* -> INTERSECTION RELATED

df$RELATIONTO <- gsub("DRIVEWAY(\\w+|\\W)*$", "DRIVEWAY, ALLEY ACCESS, ETC.", df$RELATIONTO)
df$RELATIONTO <- gsub("INTERSECTION RELA(\\W|\\w)*", "INTERSECTION RELATED", df$RELATIONTO)

# Replace -- with NAs
df[df == "--"] <- NA

# From Gemini
df <- df |> mutate(across(c(RELATIONTO, TDOTLOC, TYPEOFCRAS, FIRSTHARMF, MANNEROFCO, WEATHER, LIGHTCONDI),
                          as.factor))

df$DATEOFCRAS <- as.Date(df$DATEOFCRAS, format = "%m/%d/%Y")


# Drop unneeded columns (same value for all instances/useless data)
df <- df |> select(-Shape..,
                   -MSLINK, -RELATIONT2, -URBAN, -NBR_TENN_C,
                   -NBR_RT2, -SPCL_CSE, -CNTY_SEQ, -YEAROFCRAS,
                   -LOCATE_TYP, -Hour)

summary(df)

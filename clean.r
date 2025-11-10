library(tidyr, dplyr)

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

# Hot-deck impute or randomly impute NAs
# Recycles the sample sample, needs to be changed using the VIM library
# Deletion was not used to prevent bias
set.seed(123)

randFirstHarm <- sample(na.omit(df$FIRSTHARMF), size = 1)

randManner <- sample(na.omit(df$MANNEROFCO), size = 1)

randWeather <- sample(na.omit(df$WEATHER), size = 1)

randLight <- sample(na.omit(df$LIGHTCONDI), size = 1)

df <- df |> replace_na(list(FIRSTHARMF = randFirstHarm, MANNEROFCO = randManner, WEATHER = randWeather, LIGHTCONDI = randLight))

# Drop the TDOTLOC feature (duplicates values of RELATIONTO)
df <- df |> select(-TDOTLOC)

# Enrichment
# Derive a new attribute crashSeverity from TYPEOFCRAS
df$crashSeverity <- as.factor(ifelse(df$TYPEOFCRAS %in% c("Prop Damage (over)", "Prop Damage (under)"), "Property Damage",
                                     ifelse(df$TYPEOFCRAS == "Suspected Minor Injury", "Minor Injury",
                                            ifelse(df$TYPEOFCRAS == "Suspected Serious Injury", "Serious Injury", "Fatal"))
                                     )
                              )

library(tidyr, dplyr, VIM)

df <- read.csv("raw_data.csv")

# Fix the mangled RELATIONTO column using regular expressions
# DRIVEWAY* -> DRIVEWAY, ALLEY ACCESS, ETC.
# INTERSECTION RELA* -> INTERSECTION RELATED

df$RELATIONTO <- gsub("DRIVEWAY(\\w+|\\W)*$", "DRIVEWAY, ALLEY ACCESS, ETC.", df$RELATIONTO)
df$RELATIONTO <- gsub("INTERSECTION RELA(\\W|\\w)*", "INTERSECTION RELATED", df$RELATIONTO)

# Replace -- with NAs
df[df == "--"] <- NA

# From Gemini
df <- df |> dplyr::mutate(across(c(RELATIONTO, TDOTLOC, TYPEOFCRAS, FIRSTHARMF, MANNEROFCO, WEATHER, LIGHTCONDI),
                          as.factor))

df$DATEOFCRAS <- as.Date(df$DATEOFCRAS, format = "%m/%d/%Y")


# Drop unneeded columns (same value for all instances/useless data)
df <- df |> dplyr::select(-Shape..,
                   -MSLINK, -RELATIONT2, -URBAN, -NBR_TENN_C,
                   -NBR_RT2, -SPCL_CSE, -CNTY_SEQ, -YEAROFCRAS,
                   -LOCATE_TYP, -Hour)

summary(df)

# Hot-deck impute or randomly impute NAs
# Using VIM to hot-deck impute some features
# Deletion was not used to prevent bias
set.seed(123)

# With the help of Mr. C
df <- df |> rowwise() |> mutate(RELATIONTO = case_when(
  is.na(RELATIONTO) & TDOTLOC == "At an Intersection" ~ sample(c("INTERSECTION RELATED", "INTERSECTION"), 1),
  is.na(RELATIONTO) & TDOTLOC == "Along Roadway" ~ sample(na.omit(unique(df$RELATIONTO)), 1, replace = TRUE),
  TRUE ~ as.character(RELATIONTO)
)) |> ungroup() |> mutate(RELATIONTO = factor(RELATIONTO))

df <- df |> hotdeck(variable = c("FIRSTHARMF", "MANNEROFCO", "WEATHER", "LIGHTCONDI"), imp_var = FALSE)

# Drop the TDOTLOC feature (duplicates values of RELATIONTO)
df <- df |> dplyr::select(-TDOTLOC)

# Enrichment
# Derive a new attribute crashSeverity from TYPEOFCRAS
df$crashSeverity <- as.factor(ifelse(df$TYPEOFCRAS %in% c("Prop Damage (over)", "Prop Damage (under)"), "Property Damage",
                                     ifelse(df$TYPEOFCRAS == "Suspected Minor Injury", "Minor Injury",
                                            ifelse(df$TYPEOFCRAS == "Suspected Serious Injury", "Serious Injury", "Fatal"))
                                     )
                              )

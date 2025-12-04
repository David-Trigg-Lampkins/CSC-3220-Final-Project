library(dplyr)
library(ggplot2)

theme_update(legend.position = "bottom")

# Begin log mile (BLM)
df |> ggplot(aes(x=BLM, fill=crashSeverity)) + 
  geom_histogram(binwidth = 1) +
  scale_fill_manual(values = c("Property Damage" = "blue", "Injury" = "maroon")) +
  facet_grid(crashSeverity ~ .)

# Bar chart of relation to
df |> ggplot(aes(y=RELATIONTO, fill=RELATIONTO)) +
  geom_bar()

# Histogram of date
df |> ggplot(aes(x=DATEOFCRAS, fill=crashSeverity)) +
  geom_histogram() +
  scale_fill_manual(values = c("Property Damage" = "blue", "Injury" = "maroon")) +
  facet_grid(crashSeverity ~ .)

# Histogram of time
df |> ggplot(aes(x=TIMEO, fill=crashSeverity)) +
  geom_histogram() +
  scale_fill_manual(values = c("Property Damage" = "blue", "Injury" = "maroon")) +
  facet_grid(crashSeverity ~ .)

# Box plots of numeric data
# Total killed was omitted due to the very small frequency
df |> ggplot(aes(x=TOTALINJU, fill=crashSeverity)) +
  geom_boxplot()

df |> ggplot(aes(x=TOTAL_INCA)) +
  geom_boxplot()

df |> ggplot(aes(x=TOTAL_OTHE)) +
  geom_boxplot()

df |> ggplot(aes(x=TOTALVEHIC)) +
  geom_boxplot()

# Bar chart of first harm
df |> ggplot(aes(y=FIRSTHARMF, fill=FIRSTHARMF)) +
  geom_bar()

# Bar chart of manner of collision
df |> ggplot(aes(y=MANNEROFCO, fill=MANNEROFCO)) +
  geom_bar()

# Bar chart of weather
df |> ggplot(aes(y=WEATHER, fill=WEATHER)) +
  geom_bar()

# Bar chart of lighting condition
df |> ggplot(aes(y=LIGHTCONDI, fill=LIGHTCONDI)) +
  geom_bar()

# Bar chart of crash severity
df |> ggplot(aes(y=crashSeverity, fill=crashSeverity)) +
  geom_bar() +
  scale_fill_manual(values = c("Property Damage" = "blue", Injury = "maroon"))
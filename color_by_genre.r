setwd("~/Desktop/data_analysis/Final project/Develish-Data-Demons")

library(tidyverse)
library(ggthemes)

creator_data <- read_csv('creators_with_descriptions.csv') 

plot1a <- creator_data %>%
  mutate(birthDecade = ifelse((birthYear<1500), "<=1400s", 0)) %>%
  mutate(birthDecade = ifelse((birthYear>1499) & (birthYear<1600), "1500s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1599) & (birthYear<1700), "1600s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1699) & (birthYear<1800), "1700s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1799) & (birthYear<1810), "1800s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1809) & (birthYear<1820), "1810s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1819) & (birthYear<1830), "1820s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1829) & (birthYear<1840), "1830s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1839) & (birthYear<1850), "1840s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1849) & (birthYear<1860), "1850s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1859) & (birthYear<1870), "1860s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1869) & (birthYear<1880), "1870s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1879) & (birthYear<1890), "1880s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1889) & (birthYear<1900), "1890s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1899) & (birthYear<1910), "1900s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1909) & (birthYear<1920), "1910s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1919) & (birthYear<1930), "1920s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1929) & (birthYear<1940), "1930s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1939) & (birthYear<1950), "1940s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1949) & (birthYear<1960), "1950s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1959) & (birthYear<1970), "1960s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1969) & (birthYear<1980), "1970s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1979) & (birthYear<1990), "1980s", birthDecade)) %>%
  mutate(birthDecade = ifelse((birthYear>1989) & (birthYear<2000), "1990s", birthDecade))
  

plot_SUM <- plot1a %>%
  group_by(birthDecade) %>%
  mutate(TOTcharacters_by_birthDecade = sum(Number_of_characters))%>%
  filter(!is.na(birthDecade)) %>%
  select(Number_of_characters, Description, birthDecade, TOTcharacters_by_birthDecade) %>%
  group_by(birthDecade) %>%
  add_count(birthDecade) %>%
  mutate(TOTcharacters_by_birthDecade =TOTcharacters_by_birthDecade/n) %>%
  group_by(birthDecade, Description)

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2")

ggplot(data=plot_SUM)+
  aes(x=birthDecade, y=TOTcharacters_by_birthDecade) +
  geom_col(aes(fill=Description))+
  scale_fill_manual(values=cbPalette)+
  labs(x = "Birth decade of creator",
       y = "Total number of characters\n")+
  theme_economist_white(gray_bg = FALSE)+
  scale_y_continuous(minor_breaks = seq(0 , 220, 25), 
                     breaks = seq(0, 220, 50), 
                     position = "right")+
  theme(axis.text.x = element_text(angle = -45, hjust = 0.1),
        axis.text.y = element_text(vjust = -0.5, hjust = -10),
        panel.grid.minor = element_line(colour="grey", size=0.3),
        panel.grid = element_line(colour="grey", size=0.3))

ggsave("genre_total_characters.pdf")



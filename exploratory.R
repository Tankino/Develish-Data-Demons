setwd("~/Desktop/data_analysis/Final project/Develish-Data-Demons")

library(tidyverse)
library(ggthemes)

creator_data <- read_csv("creator_data_cleaned.csv") 

genre_data <- count(creator_data, genre)

creators_with_descriptions <- creator_data %>%
  filter(!is.na(Description)) %>%
  write_csv("creators_with_descriptions.csv")

creators_with_genre <- creator_data %>%
  filter(!is.na(genre))

plot1a <- creator_data %>%
  select(birthYear, Number_of_characters) %>%
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
  summarise(TOTcharacters_by_birthDecade = sum(Number_of_characters))

plot_SUM <- plot_SUM[-c(25),]

ggplot(data=plot_SUM)+
  aes(x=birthDecade, y=TOTcharacters_by_birthDecade) +
  geom_col()+
  labs(x = "Birth decade of creator",
       y = "Total number of characters\n")+
  theme_economist_white(gray_bg = FALSE)+
  scale_color_economist()+
  scale_y_continuous(minor_breaks = seq(0 , 750, 50), breaks = seq(0, 700, 100), 
                     position = "right")+
  theme(axis.text.x = element_text(angle = -45, hjust = 0.1),
        axis.text.y = element_text(vjust = -0.5, hjust = -10),
        panel.grid.minor = element_line(colour="grey", size=0.3),
        panel.grid = element_line(colour="grey", size=0.3))

ggsave("total_characters.pdf")

plot_AVG <- plot1a %>%
  group_by(birthDecade) %>%
  mutate(AVGcharacters_by_birthDecade = mean(Number_of_characters)) %>%
  add_count(birthDecade) %>%
  mutate(prop_contribution=Number_of_characters/n) %>%
  mutate(max_prop=ifelse(max(prop_contribution)==prop_contribution, prop_contribution, NA)) %>%
  filter(!is.na(max_prop)) %>%
  filter(!is.na(birthDecade))

ggplot(data=plot_AVG)+
  aes(x=birthDecade)+
  geom_col(aes(y=AVGcharacters_by_birthDecade))+
  labs(x = "Birth decade of creator",
       y = "Average number of characters")+
  theme_economist_white(gray_bg = FALSE)+
  scale_color_economist()+
  scale_y_continuous(minor_breaks = seq(1 , 16, 1), breaks = seq(1, 16, 2),
                     position = "right")+
  theme(axis.text.x = element_text(angle = -45, hjust = 0.1),
        axis.text.y = element_text(vjust = -0.5, hjust = -0.5),
        panel.grid.minor = element_line(colour="grey", size=0.3),
        panel.grid = element_line(colour="grey", size=0.3))+
  geom_col(aes(y=max_prop), fill='pink')


ggsave("average_characters.pdf")


plot_AUTHORS <- plot1a %>%
  group_by(birthDecade)%>%
  arrange(birthDecade)%>%
  mutate(not_available = ifelse(birthYear == "NA", 1, 2))%>%
  subset(not_available==2)

ggplot(data=plot_AUTHORS)+
  aes(x=birthDecade) +
  geom_bar()+
  labs(x = "Birth decade of creator",
       y = "Total number of creator\n")+
  theme_economist_white(gray_bg = FALSE)+
  scale_color_economist()+
  scale_y_continuous( position = "right")+
  theme(axis.text.x = element_text(angle = -45, hjust = 0.1),
        axis.text.y = element_text(vjust = -0.5, hjust = -10),
        panel.grid.minor = element_line(colour="grey", size=0.3),
        panel.grid = element_line(colour="grey", size=0.3))

ggsave("total_authors.pdf")

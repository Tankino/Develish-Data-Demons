setwd("~/Desktop/data_analysis/Final project/Develish-Data-Demons")

library(tidyverse)
library(ggthemes)

creator_data <- read_csv("creator_data_cleaned.csv") 
# loading the file which Dorian prepossessed in python

with_decade_variable <- creator_data %>%
  select(birthYear, Number_of_characters) %>%
# The following step was to code for a new variable indicating decade, which was done in 
# a possible not super efficient way but it worked. Ctrl C and V were my friends.
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

plot_total_characters <- with_decade_variable %>%
  group_by(birthDecade) %>%
  filter(!is.na(birthDecade)) %>%
# to get rid of all the authors for whom we don't know the birth decade so they
# don't get added to the chart too. In hindsight this could have been done before so 
# as to not repeat for each plot. Oh well.
  mutate(TOTcharacters_by_birthDecade = sum(Number_of_characters))

sum(plot_total_characters$Number_of_characters)
# to know the total number of characters made by authors with birth date on Wikipedia

ggplot(data=plot_total_characters)+
  aes(x=birthDecade, y=TOTcharacters_by_birthDecade) +
  geom_col()+
  labs(x = "Birth decade of creator",
       y = "Total number of characters\n",
       caption = "n = 1927")+
  theme_economist_white(gray_bg = FALSE)+
  scale_y_continuous(breaks = seq(0, 700, 100), 
                     position = "right")+
  theme(axis.text.x = element_text(angle = -45, hjust = 0.1, size = 20),
        axis.text.y = element_text(vjust = -0.5, hjust = -10, size = 20),
        axis.title=element_text(size=20),
        panel.grid = element_line(colour="grey", size=0.3),
        plot.caption = element_text(size = 14))

ggsave("total_characters.pdf")

plot_AVG <- with_decade_variable %>%
  group_by(birthDecade) %>%
  mutate(AVGcharacters_by_birthDecade = mean(Number_of_characters)) %>%
  add_count(birthDecade) %>%
  mutate(prop_contribution=Number_of_characters/n) %>%
# this was to calculate the proportional contribution of each author to the average for that decade. 
  mutate(max_prop=ifelse(max(prop_contribution)==prop_contribution, prop_contribution, NA)) %>%
# this was to keep only the highest proportional contribution
  filter(!is.na(max_prop)) %>%
  arrange(birthDecade) %>%
  filter(!is.na(birthDecade))
# filtering out the unknowns

plot_AVG <- plot_AVG[-c(12, 18, 22),]
# this step was necessary because for 3 decades, there was an equally highest proportional contribution,
# I removed the second manually. Probably a better way to do this automatically, but this worked too.

ggplot(data=plot_AVG)+
  aes(x=birthDecade)+
  geom_col(aes(y=AVGcharacters_by_birthDecade, fill="Total"))+
  labs(x = "Birth decade of creator",
       y = "Average number of characters\n",
       caption = "n = 1927")+
  theme_economist_white(gray_bg = FALSE)+
  scale_fill_manual(values=c("pink", "grey"))+
  scale_y_continuous(minor_breaks = seq(1 , 16, 1), breaks = seq(1, 16, 2),
                     position = "right")+
  theme(axis.text.x = element_text(angle = -45, hjust = 0.1, size = 14),
        axis.text.y = element_text(vjust = 0, hjust = -0.5, size = 14),
        axis.title=element_text(size=14),
        panel.grid.minor = element_line(colour="grey", size=0.3),
        panel.grid = element_line(colour="grey", size=0.3),
        legend.title = element_blank())+
  geom_col(aes(y=max_prop, fill='Proportion from largest creator'))+
  annotate("text", x="1870s", y=11.5, label = " <--Alice in Wonderland effect")


ggsave("average_characters.pdf")


plot_total_authors <- with_decade_variable %>%
  group_by(birthDecade)%>%
  mutate(not_available = ifelse(birthYear == "NA", 1, 2))%>%
  subset(not_available==2)
# here we have a different way to filter out those without birth year, leftover
# from before I discovered is.na

ggplot(data=plot_total_authors)+
  aes(x=birthDecade) +
  geom_bar()+
  labs(x = "Birth decade of creator",
       y = "Total number of creator\n",
       caption = "n = 1927")+
  theme_economist_white(gray_bg = FALSE)+
  scale_y_continuous( position = "right")+
  theme(axis.text.x = element_text(angle = -45, hjust = 0.1, size = 20),
        axis.text.y = element_text(vjust = -0.5, hjust = -10, size = 20),
        axis.title=element_text(size=20),
        panel.grid.minor = element_line(colour="grey", size=0.3),
        panel.grid = element_line(colour="grey", size=0.3),
        plot.caption = element_text(size = 14))


ggsave("total_authors.pdf")

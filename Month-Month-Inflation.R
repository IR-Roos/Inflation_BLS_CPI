setwd("/Users/iregmii/Documents/Data Projects/Inflation_BLS_CPI")
#### MONTH OVER MONTH INFLATION - UNANNUALIZED #### 
#install.packages("RColorBrewer")
library(RColorBrewer)
library(hrbrthemes)
library(janitor)
library(tidyverse)
library(ggtext)
library(ggrepel)
library(huxtable)
library(scales)
library(lubridate)
library(tidytext)
library(viridis)
library(dplyr)
library(RColorBrewer)
library(ggplot2)
library(ggrepel)

theme_inflation <- theme_classic() +
  theme(text = element_text(family = "Larsseit", face="bold", color ="#1E8456"),
        plot.title = element_text(family = "Larsseit"),
        plot.subtitle = element_text(family = "Larsseit"),
        plot.caption = element_text(family="Larsseit"),
        strip.text = element_text(family="Larsseit")) +
  theme(panel.grid.major.y = element_line(size=0.5),
        plot.title = element_text(size = 15, face="bold"),
        plot.subtitle = element_text(size = 10),
        plot.title.position = "plot",
        axis.text.x = element_text(size = 8),
        axis.text.y = element_text(size = 8),
        legend.title = element_blank())

cpi <- cpi_data
#MOM#

CORE_MOM <- cpi %>%
  filter(period != "M13") %>%
  filter(seasonal == "S") %>%
  arrange(date) %>%
  group_by(item_name) %>% ##(group_by tells R to perform a function within a group)
  filter(item_name == "All items") %>% 
  mutate(PchangeMOM = (value/lag(value)-1)) 
date = as.Date(CORE_MOM$date)
CORE_MOM <- CORE_MOM %>% 
  mutate(num_label = round(100*PchangeMOM, 2))%>% 
  filter(year >= 2020)#%>% 
#filter(date == max(date) | date == "2020-02-01" | date == "2023-02-01"| date == "2023-01-01")

CORE_MOM <- CORE_MOM %>%
  mutate(num_label_1 = replace(num_label, date <= "2022-02-01", "")) 

#CPI_Labels <- CORE_MOM 
#CPI_Labels$num_label_new <-NA
#CPI_Labels$num_label_new[which(CPI_Labels$num_label == max(CPI_Labels$date))] <- 
#CPI_Labels$group[which(CPI_Labels$num_label == max(CPI_Labels$date))]


ggplot(CORE_MOM, aes(x = date, y = PchangeMOM, fill = item_name,)) + 
  geom_bar(stat = 'identity', fill = "#6EA4BF")  +  
  geom_point() + 
  geom_line(color="#2D779C", size = 1.5) + 
  theme_inflation + theme(legend.position = "none") +
  scale_y_continuous(labels = percent) + 
  scale_x_date(date_labels = "%b %y", breaks= "3 month") +
  #geom_text(aes(label = num_label), check_overlap = TRUE) +
  geom_text(data = CORE_MOM, aes(x=date, y=PchangeMOM, label=num_label), nudge_y = 0.0003, size=4, face="bold", color="#1E8456")+
  labs(y = NULL,
       x = NULL,
       title = "Monthly Percent Increase in   Goods and Services - Month Over Month",
       subtitle = "Core inflation increased by 0.4%", 
       caption ="BLS, CPI, 2022 weights, seasonally adjusted. Author's calculation. Ira Regmi, Roosevelt Institute")

ggsave("Fig M.1.png", dpi="retina", width = 12, height=6.75, units = "in")



###### View List of All Items ####################

CPI_Item_Names = cpi[,c('series_id', 'item_name')]




###### Services less Rent of Shelter 

Services_Less_Rent <- cpi %>%
  filter(period != "M13") %>%
  filter(seasonal == "S") %>%
  arrange(date) %>%
  group_by(item_name) %>% ##(group_by tells R to perform a function within a group)
  filter(item_name == "Services less rent of shelter") %>% 
  mutate(PchangeMOM = (value/lag(value)-1))
date = as.Date(Services_Less_Rent$date)
Services_Less_Rent <- Services_Less_Rent %>% 
  mutate(num_label = round(100*PchangeMOM, 2))%>% 
  filter(year >= 2022)
#filter(date == max(date) | date == "2020-02-01" | date == "2023-02-01"| date == "2023-01-01")

Services_Less_Rent <- Services_Less_Rent %>%
  mutate(num_label_1 = replace(num_label, date <= "2022-02-01", "")) 


ggplot(Services_Less_Rent, aes(x = date, y = PchangeMOM, fill = item_name,)) + 
  geom_bar(stat = 'identity', fill = "#6EA4BF")  +  
  geom_point() + 
  geom_line(color="#2D779C", size = 1.5) + 
  theme_inflation + theme(legend.position = "none") +
  scale_y_continuous(labels = percent) + 
  scale_x_date(date_labels = "%b %y", breaks= "2 month") +
  #geom_text(aes(label = num_label), check_overlap = TRUE) +
  geom_text(data = Services_Less_Rent, aes(x=date, y=PchangeMOM, label=num_label), nudge_y = 0.0003, size=3, face="bold", color="#1E8456")+
  labs(y = NULL,
       x = NULL,
       title = "Monthly Percent Increase in Services Less Rent of Shelter",
       subtitle = "Services exclusing rent remains much higher than pre-pandemic levels", 
       caption ="BLS, CPI, 2022 weights, seasonally adjusted. Author's calculation. Ira Regmi, Roosevelt Institute")

ggsave("Fig M.2.0.png", dpi="retina", width = 12, height=6.75, units = "in")

#filter(date == max(date) | date == "2020-02-01" | date == "2023-02-01"| date == "2023-01-01")

######### Core Goods - FOOD


Food <- cpi %>%
  filter(period != "M13") %>%
  filter(seasonal == "S") %>%
  arrange(date) %>%
  group_by(item_name) %>% ##(group_by tells R to perform a function within a group)
  filter(item_name == "Food") %>% 
  mutate(PchangeMOM = (value/lag(value)-1))
date = as.Date(Food$date)
Food <- Food %>% 
  mutate(num_label = round(100*PchangeMOM, 2))%>% 
  filter(year >= 2020)
#filter(date == max(date) | date == "2020-02-01" | date == "2023-02-01"| date == "2023-01-01")

Food <- Food %>%
  mutate(num_label_1 = replace(num_label, date <= "2022-02-01", "")) 


ggplot(Food, aes(x = date, y = PchangeMOM, fill = item_name,)) + 
  geom_bar(stat = 'identity', fill = "#6EA4BF")  +  
  geom_point() + 
  geom_line(color="#2D779C", size = 1.5) + 
  theme_inflation + theme(legend.position = "none") +
  scale_y_continuous(labels = percent) + 
  scale_x_date(date_labels = "%b %y", breaks= "2 month") +
  #geom_text(aes(label = num_label), check_overlap = TRUE) +
  geom_text(data = Food, aes(x=date, y=PchangeMOM, label=num_label), nudge_y = 0.0003, size=3, face="bold", color="#1E8456")+
  labs(y = NULL,
       x = NULL,
       title = "Food Inflation Takes a Dip",
       subtitle = "Food prices are decellerating but still remain high", 
       caption ="BLS, CPI, 2022 weights, seasonally adjusted. Author's calculation. Ira Regmi, Roosevelt Institute")

ggsave("Fig M.3.0.png", dpi="retina", width = 12, height=6.75, units = "in")


##### CORE GOODS

Goods_List <- c("Used cars and trucks", "Apparel", "New vehicles", "Energy commodities") 
Goods <- cpi %>%
  filter(period != "M13") %>%
  filter(seasonal == "S") %>%
  arrange(date) %>%
  group_by(item_name) %>% ##(group_by tells R to perform a function within a group)
  filter(item_name %in% Goods_List) %>%
  mutate(PchangeMOM = (value/lag(value)-1))
date = as.Date(Goods$date)

Goods <- Goods %>% 
  mutate(num_label = round(100*PchangeMOM, 2))

Goods <- Goods %>%
  mutate(num_label_1 = replace(num_label, date <= "2022-01-01", "")) %>%
  filter(year >= 2022)

ggplot(Goods, aes(x = date, y = PchangeMOM)) + 
  geom_line() +  
  geom_point() + facet_wrap(facet = "item_name", nrow=2) +
  geom_line(color="#2D779C", size = 1.5) + 
  theme_inflation + theme(legend.position = "none") +
  scale_y_continuous(labels = percent) + 
  scale_x_date(date_labels = "%b %y", breaks= "2 month") +
  #geom_text(aes(label = num_label), check_overlap = TRUE) +
  geom_text(data = Goods, aes(x=date, y=PchangeMOM, label=num_label), nudge_y = 0.05, size=3, face="bold", color="#1E8456")+
  labs(y = NULL,
       x = NULL,
       title = "Month-Over-Month Percentage Change in  Goods Prices",
       subtitle = "Used Cars saw significant decline in prices", 
       caption ="BLS, CPI, 2022 weights, seasonally adjusted. Author's calculation. Ira Regmi, Roosevelt Institute")

ggsave("Fig M.4.0.png", dpi="retina", width = 12, height=6.75, units = "in")

####  Shelter, Energy and Transportation Services

Services_List <- c("Energy services", "Motor vehicle insurance", "Airline fares") 
Services <- cpi %>%
  filter(period != "M13") %>%
  filter(seasonal == "S") %>%
  arrange(date) %>%
  group_by(item_name) %>% ##(group_by tells R to perform a function within a group)
  filter(item_name %in% Services_List) %>%
  mutate(PchangeMOM = (value/lag(value)-1))
date = as.Date(Services$date)

Services <- Services %>% 
  mutate(num_label = round(100*PchangeMOM, 2))

Services <- Services %>%
  mutate(num_label_1 = replace(num_label, date <= "2022-01-01", "")) %>%
  filter(year >= 2022)

ggplot(Services, aes(x = date, y = PchangeMOM)) + 
  geom_line() +  
  geom_point() + facet_wrap(facet = "item_name", nrow=2) +
  geom_line(color="#2D779C", size = 1.5) + 
  theme_inflation + theme(legend.position = "none") +
  scale_y_continuous(labels = percent) + 
  scale_x_date(date_labels = "%b %y", breaks= "2 month") +
  #geom_text(aes(label = num_label), check_overlap = TRUE) +
  geom_text(data = Services, aes(x=date, y=PchangeMOM, label=num_label), nudge_y = 0.05, size=3, face="bold", color="#1E8456")+
  labs(y = NULL,
       x = NULL,
       title = "Year over Year Percentage Change Services",
       subtitle = "TKTKTK", 
       caption ="BLS, CPI, 2022 weights, seasonally adjusted. Author's calculation. Ira Regmi, Roosevelt Institute")

ggsave("Fig M.5.0.png", dpi="retina", width = 12, height=6.75, units = "in")

##### RENT and OER

Shelter_List <- c("Rent of primary residence", "Owners' equivalent rent of residences") 
Shelter <- cpi %>%
  filter(period != "M13") %>%
  filter(seasonal == "S") %>%
  arrange(date) %>%
  group_by(item_name) %>% ##(group_by tells R to perform a function within a group)
  filter(item_name %in% Shelter_List) %>%
  mutate(PchangeMOM = (value/lag(value)-1))
date = as.Date(Shelter$date)

Shelter <- Shelter %>% 
  mutate(num_label = round(100*PchangeMOM, 2))

Shelter <- Shelter %>%
  mutate(num_label_1 = replace(num_label, date <= "2022-01-01", "")) %>%
  filter(year >= 2021)

ggplot(Shelter, aes(x = date, y = PchangeMOM)) + 
  geom_line() +  
  geom_point() + facet_wrap(facet = "item_name", nrow=2) +
  geom_line(color="#2D779C", size = 1.5) + 
  theme_inflation + theme(legend.position = "none") +
  scale_y_continuous(labels = percent) + 
  scale_x_date(date_labels = "%b %y", breaks= "2 month") +
  #geom_text(aes(label = num_label), check_overlap = TRUE) +
  geom_text(data = Shelter, aes(x=date, y=PchangeMOM, label=num_label), nudge_y = 0.003, size=3, face="bold", color="#1E8456")+
  labs(y = NULL,
       x = NULL,
       title = "Monthly Percentage Change Shelter",
       subtitle = "TKTKTK", 
       caption ="BLS, CPI, 2022 weights, seasonally adjusted. Author's calculation. Ira Regmi, Roosevelt Institute")

ggsave("Fig M.6.0.png", dpi="retina", width = 12, height=6.75, units = "in")

#################################### PICK AN ITEM 
Pick_Item <- c("Shelter") 
Pick_Item <- cpi %>%
  filter(period != "M13") %>%
  filter(seasonal == "S") %>%
  arrange(date) %>%
  group_by(item_name) %>% ##(group_by tells R to perform a function within a group)
  filter(item_name %in% Pick_Item) %>%
  mutate(PchangeMOM = (value/lag(value)-1))
date = as.Date(Pick_Item$date)
Pick_Item <- Pick_Item%>% 
  mutate(num_label = round(100*PchangeMOM, 2))%>% 
  filter(year >= 2020)#%>% 
#filter(date == max(date) | date == "2020-02-01" | date == "2023-02-01"| date == "2023-01-01")

Pick_Item <- Pick_Item %>%
  mutate(num_label_1 = replace(num_label, date <= "2022-02-01", "")) 


ggplot(Pick_Item, aes(x = date, y = PchangeMOM, fill = item_name,)) + 
  geom_bar(stat = 'identity', fill = "#6EA4BF")  +  
  geom_point() + 
  geom_line(color="#2D779C", size = 1.5) + 
  theme_inflation + theme(legend.position = "none") +
  scale_y_continuous(labels = percent) + 
  scale_x_date(date_labels = "%b %y", breaks= "3 month") +
  #geom_text(aes(label = num_label), check_overlap = TRUE) +
  geom_text(data = Pick_Item, aes(x=date, y=PchangeMOM, label=num_label), nudge_y = 0.0003, size=3, face="bold", color="#1E8456")+
  labs(y = NULL,
       x = NULL,
       title = "shelter",
       subtitle = "TKTK", 
       caption ="BLS, CPI, 2022 weights, seasonally adjusted. Author's calculation. Ira Regmi, Roosevelt Institute")

ggsave("Fig M.7.0.png", dpi="retina", width = 12, height=6.75, units = "in")


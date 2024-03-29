library(rvest)
library(httr)

#db <- data.frame()

#base_url <- "https://www.redfin.com"

#data <- read.csv("C:/Users/roriv/OneDrive/Documents/Spring 24 School Work/Data mining/ProjectCrawler/fullListHouses.csv")

#full_url <- paste0(base_url, data[1, ])
#print(full_url)



#for(link in data){
#  full_url <- paste0(base_url, link)
#  page <- read_html(full_url)
#  address <- page %>% html_nodes("[data-testid='property-card-details']")
#  city <- page %>%
#  beds <- page %>% 
#  bath <- page %>% 
#  garage <- page %>%
#  house_area <- page %>%
#  lot_area <- page %>%
#  type <- page %>%
#  year_built <- page
#  year_renovated <- page
#  db <- rbind(db, data.frame(beds, bath))
#}


csv1 <- read.csv("C:/Users/roriv/OneDrive/Documents/Spring 24 School Work/Data mining/LACountyDB0to400.csv")
csv2 <- read.csv("C:/Users/roriv/OneDrive/Documents/Spring 24 School Work/Data mining/LACountyDBfrom400to500.csv")

combined_csv <- rbind(csv1, csv2)

#View(combined_csv)
write.csv(combined_csv, file = "C:/Users/roriv/OneDrive/Documents/Spring 24 School Work/Data mining/LACountyDBFinal.csv", row.names = FALSE)

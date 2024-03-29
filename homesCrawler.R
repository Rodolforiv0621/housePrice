library(rvest)
library(stringr)
library(httr)
library(readr)

# Base URL of website
base_url <- "https://www.redfin.com/zipcode/"

# Reading in LA County zipcodes
zipcodeData <- read.csv("C:/Users/roriv/Downloads/Zip_Codes_LA_Countyfrom90303last300.csv")

# Creating empty data frame
houses <- data.frame()

# For loop for the different pages
for(i in 1:101){
  print(paste0("starting: ", i))
  
  page_number <- 1
  
  more_pages <- TRUE
  
  # While loop used to load more content
  while(more_pages){
    print(paste0("page: ", page_number))
    
    full_url <- paste0(base_url, zipcodeData[i,1], "/filter/property-type=house,include=sold-2yr")
    
    if(page_number > 1){
      full_url <- paste0(full_url, "/page-", page_number)
    }
      
    page <- try(read_html(full_url), silent=TRUE)
    if(inherits(page, "try-error")){
      print(paste0("Failed: ", full_url))
      more_pages <- FALSE
      next
    }
    homes_text <- page %>% html_nodes("[data-rf-test-id='homes-description']") %>% html_text()
    first_number <- str_extract(homes_text, "\\d+")
    first_number <- as.integer(first_number)
    if(first_number == 0){
      print(paste0("No homes: ", zipcodeData[i,1]))
      more_pages <- FALSE
      next
    }
    
    # Extracts the elements from the html page
    price <- page %>% html_nodes(".bp-Homecard__Price--value") %>% html_text()
    address <- page %>% html_nodes(".bp-Homecard__Address") %>% html_text()
    num_bed <- page %>% html_nodes(".bp-Homecard__Stats--beds") %>% html_text()
    num_bath <- page %>% html_nodes(".bp-Homecard__Stats--baths") %>% html_text()
    home_area_value <- page %>% html_nodes(".bp-Homecard__Stats--sqft") %>% html_nodes(".bp-Homecard__LockedStat--value") %>% html_text()
    home_area_label <- page %>% html_nodes(".bp-Homecard__Stats--sqft") %>% html_nodes(".bp-Homecard__LockedStat--label") %>% html_text()
    #lot_size_value <- page %>% html_nodes(".bp-Homecard__Stats--lotsize") %>% html_nodes(".bp-Homecard__LockedStat--value") %>% html_text()
    #lot_size_label <- page %>% html_nodes(".bp-Homecard__Stats--lotsize") %>% html_nodes(".bp-Homecard__LockedStat--label") %>% html_text()
    home_area <- paste(home_area_value, home_area_label)
    #lot_size <- paste(lot_size_value, lot_size_label)
    zip_code <- str_extract(address, "(?<=,\\s[A-Z]{2}\\s)\\d{5}")
    
    # Checks which has the most rows of data
    max_length <- max(length(address), length(num_bed), length(num_bath), length(home_area), length(price), length(zip_code))
    
    
    # Function to lengthen vectors
    lengthen_vector <- function(vec, max_length) {
      length(vec) <- max_length
      return(vec)
    }
    
    # Extend the vectors to have the same length and fill in missing values with NA
    address <- lengthen_vector(address, max_length)
    num_bed <- lengthen_vector(num_bed, max_length)
    num_bath <- lengthen_vector(num_bath, max_length)
    home_area <- lengthen_vector(home_area, max_length)
    zip_code <- lengthen_vector(zip_code, max_length)
    price <- lengthen_vector(price, max_length)
    
    # Combines all data into data frame
    houses <- rbind(houses, data.frame(address, zip_code, num_bed, num_bath, home_area, price, stringsAsFactors = FALSE))
    
    
    pagesText <- page %>% html_nodes("[data-rf-test-name='download-and-save-page-number-text']") %>% html_text()
    getNumbers <- regmatches(pagesText, gregexpr("[0-9]+", pagesText))[[1]]
    numberOfPages <- as.integer(tail(getNumbers, 1))
    if(numberOfPages > page_number){
      page_number <- page_number+1
    }else{
      more_pages <- FALSE
    }
    # Checks to see if there is more data to load
    #next_button <- page %>% html_node(".PageArrow--hidden")
    #print(xml2::xml_length(next_button))
    #if(xml2::xml_length(next_button) != 0 && page_number != 1){
    #  more_pages <- FALSE
    #} else{
    #  page_number <- page_number + 1
    #}
    
  }
  print(paste0("finished: ", zipcodeData[i,1]))
}

############
#Viewing page 1 of 2
#To solve page problem for single pages and mulitple pages
############



# View data frame
View(houses)

# Save file
write.csv(houses, file = "C:/Users/roriv/OneDrive/Documents/Spring 24 School Work/Data mining/LACountyDBfrom400to500.csv", row.names = FALSE)

##################
#      DATA      #
##################

data <- read_csv("data/melbourne_weather.csv", show_col_types = FALSE)

transposed_data <- data %>%
  pivot_longer(cols = -Month, names_to = "Metric", values_to = "Value") %>%
  pivot_wider(names_from = Month, values_from = Value)


################## Transportation Data load ##################
tram_data <- read_csv("data/tram_stop.csv")
train_data <- read_csv("data/train_station.csv")

# Touristic Stations
shuttle_data <- read_csv("data/visitor_shuttle.csv")
skybus_data <- read_csv("data/skybus_stop.csv")
citytram_data <- read_csv("data/city_tram.csv")

# Overview of Tram 
tram_length_data <- read_csv("data/tram_length.csv")

# Tourist data
tourist_data <- read_csv("data/australia_tourist.csv")

# Convert the data from wide to long format
tourist_data_long <- tourist_data %>%
  pivot_longer(cols = -Year, names_to = "Country", values_to = "Value")

# Function to get data for a specific year
get_data_for_year <- function(year) {
  tourist_data_long <- tourist_data %>%
    filter(Year == year) %>%  # Year 필터 적용
    pivot_longer(cols = -Year, names_to = "Country", values_to = "Value") %>%  # 열 변환
    arrange(desc(Value)) %>%  # Value 값으로 내림차순 정렬
    head(10)  # 상위 10개 국가만 반환
  return(tourist_data_long)
}

# Prepare list of data for each year
years <- sort(unique(tourist_data_long$Year))
yearly_data <- lapply(years, get_data_for_year)

# GeoJSON file (Melbourne)
melbourne_geojson <- st_read("data/melbourne_city.geojson")

# Filter tram stops and train stations
state_choiceVec <- c("All Stops", "Tram Stops", "Train Stations")

# Touristic transportation choices
touristic_choiceVec <- c("All Touristic Stops", "Visitor Shuttle", "SkyBus", "City Circle Tram")

# Tram route numbers
tram_numbers <- sort(unique(tram_data$routeussp))
train_lines <- sort(unique(train_data$routeussp))


################## Restaurant Data load ##################
restaurant_data1 <- read_csv("data/new_restaurant_data.csv")
restaurant_data2 <- read_csv("data/melbourne_restaurant_reviews.csv")
restaurant_data <- left_join(restaurant_data1, restaurant_data2, by = c("Trading name" = "name"))
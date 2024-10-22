# load library
library(shiny)
library(shinythemes)
library(fontawesome)
library(shinyWidgets)
library(highcharter)
library(bslib)
library(dplyr)
library(readr)
library(jsonlite)
library(leaflet)
library(geojsonio)
library(sf)

###################### Data Pre-processing ######################

# Data load
tram_data <- read_csv("tram_stop.csv")
train_data <- read_csv("train_station.csv")

# Touristic Stations
shuttle_data <- read_csv("visitor_shuttle.csv")
skybus_data <- read_csv("skybus_stop.csv")
citytram_data <- read_csv("city_tram.csv")

# GeoJSON file (Melbourne)
melbourne_geojson <- st_read("melbourne_city.geojson")

# Filter tram stops and train stations
state_choiceVec <- c("All Stops", "Tram Stops", "Train Stations")

# Touristic transportation choices
touristic_choiceVec <- c("All Touristic Stops", "Visitor Shuttle", "SkyBus", "City Circle Tram")

# Tram route numbers
tram_numbers <- sort(unique(tram_data$routeussp))
train_lines <- sort(unique(train_data$routeussp))


##################################### User Interface #####################################
 
ui <- page_navbar(
  title = "Melbourne Touristic information",
  theme = bs_theme(
    bootswatch = "cerulean",
    navbar_bg = "#d3d3d3"
  ),
  nav_spacer(),
  
  # Combined tab - Overview of Stops and Touristic Transportation
  nav_panel("Overview",
            fluidPage(
              # Title for Tram and Train Stations
              actionLink("tram_title", 
                         value_box(
                           title = NULL,
                           value = "Overview of Melbourne Tram and Train Stations",
                           theme = "bg-gradient-cyan-green",
                           showcase = bsicons::bs_icon("map"),
                           showcase_layout = "top right"
                         )),
              hr(),
              h5(strong("Select Stop Type, Map View, and Zoom to explore stations on the map."),
                 style = "font-size:16px;"),
              
              # Value boxes for Tram, Train, and Bus Stops
              layout_columns(
                actionLink("tram_link",
                           value_box(
                             title = "Total Tram Stops",
                             value = nrow(tram_data),
                             theme = "bg-gradient-cyan-green",
                             showcase = bsicons::bs_icon("train-lightrail-front"),
                             showcase_layout = "top right"
                           )),
                actionLink("train_link",
                           value_box(
                             title = "Total Train Stations",
                             value = nrow(train_data),
                             theme = "bg-gradient-teal-blue",
                             showcase = bsicons::bs_icon("train-front"),
                             showcase_layout = "top right"
                           ))
              ),
              hr(),
              
              # Filter options and map for Transportation
              sidebarLayout(
                sidebarPanel(
                  radioButtons("stop_type", 
                               label = tags$p(fa("filter", fill = "#244f76"), 
                                              "Select Stop Type"),
                               choices = list("All Stops" = "All Stops", 
                                              "Tram Stops" = "Tram Stops", 
                                              "Train Stations" = "Train Stations"),
                               selected = "All Stops"),
                  # Conditional inputs for tram, train
                  conditionalPanel(
                    condition = "input.stop_type == 'Tram Stops'",
                    pickerInput(
                      inputId = "tram_number",
                      label = "Select Tram Number:",
                      choices = tram_numbers,
                      selected = tram_numbers,
                      multiple = TRUE,
                      options = list(`actions-box` = TRUE)
                    )
                  ),
                  conditionalPanel(
                    condition = "input.stop_type == 'Train Stations'",
                    pickerInput(
                      inputId = "train_lines",
                      label = "Select Train Line:",
                      choices = train_lines,
                      selected = train_lines,
                      multiple = TRUE,
                      options = list(`actions-box` = TRUE)
                    )
                  ),
                  sliderInput("zoom_level", "Zoom Level:", 
                              min = 10, max = 16, value = 12, step = 1)
                ),
                mainPanel(
                  leafletOutput("station_map", height = "600px")
                )
              ),
              hr(),
              
              # Touristic Transportation Section
              actionLink("touristic_title", 
                         value_box(
                           title = NULL,
                           value = "Overview of Touristic Transportation",
                           theme = "bg-gradient-purple-cyan",
                           showcase = bsicons::bs_icon("bus-front"),
                           showcase_layout = "top right"
                         )),
              hr(),
              h5(strong("Select Stop Type and Zoom to explore touristic transportation on the map."),
                 style = "font-size:16px;"),
              
              # Value boxes for touristic stops
              layout_columns(
                actionLink("visitor_shuttle_link",
                           value_box(
                             title = "Total Visitor Shuttle Stops",
                             value = nrow(shuttle_data),
                             theme = "bg-gradient-purple-blue",
                             showcase = bsicons::bs_icon("bus-front"),
                             showcase_layout = "top right"
                           )),
                actionLink("skybus_link",
                           value_box(
                             title = "Total SkyBus Stops",
                             value = nrow(skybus_data),
                             theme = "bg-gradient-purple-pink",
                             showcase = bsicons::bs_icon("bus-front"),
                             showcase_layout = "top right"
                           )),
                actionLink("citytram_link",
                           value_box(
                             title = "Total City Circle Tram Stops",
                             value = nrow(citytram_data),
                             theme = "bg-gradient-cyan-pink",
                             showcase = bsicons::bs_icon("train-lightrail-front"),
                             showcase_layout = "top right"
                           ))
              ),
              hr(),
              
              # Map for touristic transportation
              sidebarLayout(
                position = "right",
                sidebarPanel(
                  radioButtons("touristic_stop_type", 
                               label = tags$p(fa("filter", fill = "#244f76"), 
                                              "Select Touristic Stop Type"),
                               choices = touristic_choiceVec,
                               selected = "All Touristic Stops")
                ),
                mainPanel(
                  leafletOutput("touristic_map", height = "600px")
                )
              ),
              hr(),
              h5('Data Source: Melbourne Touristic Transport', 
                 style = "font-size:12px;")
            )
  )
)


##################################### Shiny server #####################################
server <- shinyServer(function(input, output, session) {
  
  ##################################### Transportation map #####################################
  output$station_map <- renderLeaflet({
    # 선택한 정류장 타입에 따른 필터링
    filtered_data <- switch(input$stop_type,
                            "Tram Stops" = {
                              tram_filtered <- tram_data %>%
                                select(stop_id, latitude, longitude, stop_name, ticketzone, routeussp)
                              if (!is.null(input$tram_number)) {
                                tram_filtered <- tram_filtered %>%
                                  filter(routeussp %in% input$tram_number)
                              }
                              tram_filtered
                            },
                            "Train Stations" = {
                              train_filtered <- train_data %>%
                                select(stop_id, latitude, longitude, stop_name, ticketzone, routeussp)
                              if (!is.null(input$train_lines)) {
                                train_filtered <- train_filtered %>%
                                  filter(routeussp %in% input$train_lines)
                              }
                              train_filtered
                            },
                            "All Stops" = {
                              tram_filtered <- tram_data %>%
                                select(stop_id, latitude, longitude, stop_name, ticketzone, routeussp)
                              if (!is.null(input$tram_number)) {
                                tram_filtered <- tram_filtered %>%
                                  filter(routeussp %in% input$tram_number)
                              }
                              combined_data <- rbind(
                                tram_filtered,
                                train_data %>%
                                  select(stop_id, latitude, longitude, stop_name, ticketzone, routeussp)
                              )
                              combined_data
                            }
    )
    
    # 멜버른 구역을 지도에 추가 및 트램, 기차역, 버스 정류장 마커 표시
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = 144.9631, lat = -37.8136, zoom = input$zoom_level) %>%
      addCircles(
        data = filtered_data,
        lat = ~latitude, lng = ~longitude,
        popup = ~paste("Stop Name: ", stop_name),
        color = ~ifelse(input$stop_type == "Tram Stops", "royalblue", 
                        ifelse(input$stop_type == "Train Stations", "green", "orchid")),  
        radius = 50
      )
  })
  
  ##################################### Touristic map #####################################
  output$touristic_map <- renderLeaflet({
    # 각 투어리스틱 정류장 데이터 준비
    shuttle_data_mod <- shuttle_data %>%
      mutate(routeussp = NA) %>% 
      select(stop_id, stop_name, latitude, longitude, routeussp)
    
    skybus_data_mod <- skybus_data %>%
      select(stop_id, stop_name, latitude, longitude, routeussp)
    
    citytram_data_mod <- citytram_data %>%
      mutate(stop_id = row_number(), routeussp = NA) %>%
      select(stop_id, stop_name, latitude, longitude, routeussp)
    
    # 선택된 투어리스틱 정류장 타입에 따라 데이터 필터링
    tour_filtered_data <- switch(input$touristic_stop_type,
                                 "Visitor Shuttle" = shuttle_data_mod,
                                 "SkyBus" = skybus_data_mod,
                                 "City Circle Tram" = citytram_data_mod,
                                 "All Touristic Stops" = bind_rows(shuttle_data_mod, skybus_data_mod, citytram_data_mod)
    )
    
    # 지도에 데이터 추가 및 마커 표시
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      setView(lng = 144.9631, lat = -37.8136, zoom = 15) %>%
      addCircles(
        data = tour_filtered_data,
        lat = ~latitude, lng = ~longitude,
        popup = ~paste("Stop Name: ", stop_name),
        color = ~ifelse(input$touristic_stop_type == "Visitor Shuttle", "green", 
                  ifelse(input$touristic_stop_type == "SkyBus", "darkolivegreen",
                  ifelse(input$touristic_stop_type == "City Circle Tram", "royalblue", "violet"))),
        radius = 50
      )
  })
  
  
  ##################################### Observe link click event #####################################
  
  observeEvent(input$tram_link, {
    updateRadioButtons(session, "stop_type", selected = "Tram Stops")
  })
  
  observeEvent(input$train_link, {
    updateRadioButtons(session, "stop_type", selected = "Train Stations")
  })
  
  observeEvent(input$bus_link, {
    updateRadioButtons(session, "stop_type", selected = "Bus Stops")
  })
  
  observeEvent(input$tram_title, {
    updateRadioButtons(session, "stop_type", selected = "All Stops")
  })
  
  # Observe link click events for touristic value boxes
  observeEvent(input$visitor_shuttle_link, {
    updateRadioButtons(session, "touristic_stop_type", selected = "Visitor Shuttle")
  })
  
  observeEvent(input$skybus_link, {
    updateRadioButtons(session, "touristic_stop_type", selected = "SkyBus")
  })
  
  observeEvent(input$citytram_link, {
    updateRadioButtons(session, "touristic_stop_type", selected = "City Circle Tram")
  })
  
  observeEvent(input$touristic_title, {
    updateRadioButtons(session, "touristic_stop_type", selected = "All Touristic Stops")
  })
})


##################################### Run Shiny #####################################

shinyApp(ui, server)

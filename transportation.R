##################
# USER INTERFACE #
##################

source('tableau-in-shiny-v1.2.R')

###### Transportation tab UI ######
transportation_tab <- nav_panel(
  title="Transportation",
  
  # 제목과 스타일링 추가
  h2("Transportation in Melbourne", style = "text-align: center; font-size: 2.5em; font-weight: bold; margin-bottom: 20px;"),
  
  # 소개 문구 추가
  p(
    "Explore Melbourne's Transport System. Convenient, Efficient, Accessible!",
    style = "text-align: center; font-size: 1.5em; font-weight: bold; color: #555; margin-bottom: 15px;"
  ),
  
  p(
    "Melbourne boasts the world’s largest tram network, with over 250 km of tracks.",
    style = "text-align: center; font-size: 1.3em; color: #777; line-height: 1.7; margin-bottom: 30px;"
  ),
  
  fluidPage(
    
    # 추가하려는 Tram System Length 차트
    h3("Tram System Length by City", style = "text-align: center;"),
    highchartOutput("tram_length_bar_chart", height = "600px"),  # 차트 추가
    hr(),
    
    p(
      "Flinders Street Station", br(),
      "Opened in 1854, this station holds over 160 years of history.", br(),
      "The building is designed in Baroque style, with its distinctive green dome and clock tower serving as Melbourne’s most recognizable landmarks.", br(),
      "Flinders Street Station is a vital part of Melbourne’s transport system and cultural heritage.", br(),
      style = "text-align: center; font-size: 1.3em; color: #777; line-height: 1.7; margin-bottom: 30px;"
    ),
    
    p(
      "Melbourne Central Station", br(), 
      "Melbourne Central’s Coop's Shot Tower was originally used to manufacture lead shot in the 19th century, representing Melbourne’s industrial past.", br(),
      "The clock tower at Melbourne Central chimes every hour, accompanied by an animated show featuring mechanical figurines.", br(),
      "The building is designed in Baroque style, with its distinctive green dome and clock tower serving as Melbourne’s most recognizable landmarks.", br(),
      style = "text-align: center; font-size: 1.3em; color: #777; line-height: 1.7; margin-bottom: 30px;"
    ),
    
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
    
    p(
      "The Melbourne City Tour Bus", br(), 
      "It offers a convenient sightseeing option, making it the best way to explore various attractions across Melbourne in one go.", br(),
      "With the Hop-On Hop-Off service, you can enjoy flexible touring and listen to audio guides that provide information about each landmark, allowing you to fully experience the charm of Melbourne.", br(),
      style = "text-align: center; font-size: 1.3em; color: #777; line-height: 1.7; margin-bottom: 30px;"
    ),
    
    p(
      "Route 35 Tram", br(), 
      "This free tourist tram circles the city, offering the most convenient and attractive way to visit Melbourne’s major attractions. ", br(),
      "WWith its vintage tramcars, audio commentary, and flexible hop-on hop-off service, anyone visiting Melbourne can easily experience the city’s rich history and culture through this tram ride.", br(),
      style = "text-align: center; font-size: 1.3em; color: #777; line-height: 1.7; margin-bottom: 30px;"
    ),
    
    # Touristic Transportation Section
    actionLink("touristic_title", 
               value_box(
                 title = NULL,
                 value = "Overview of Touristic Transportation",
                 theme = "bg-gradient-purple-cyan",
                 showcase = bsicons::bs_icon("person-arms-up"),
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
                   showcase = bsicons::bs_icon("airplane"),
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
  ),
)



################
# SHINY SERVER #
################

transportation_tab_server <- function(input, output, session) {
  # Home 탭의 서버 로직
  
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
    shuttle_data_mod <- shuttle_data %>%
      mutate(routeussp = NA) %>% 
      select(stop_id, stop_name, latitude, longitude, routeussp)
    
    skybus_data_mod <- skybus_data %>%
      select(stop_id, stop_name, latitude, longitude, routeussp)
    
    citytram_data_mod <- citytram_data %>%
      mutate(stop_id = row_number(), routeussp = NA) %>%
      select(stop_id, stop_name, latitude, longitude, routeussp)
    
    tour_filtered_data <- switch(input$touristic_stop_type,
                                 "Visitor Shuttle" = shuttle_data_mod,
                                 "SkyBus" = skybus_data_mod,
                                 "City Circle Tram" = citytram_data_mod,
                                 "All Touristic Stops" = bind_rows(shuttle_data_mod, skybus_data_mod, citytram_data_mod)
    )
    
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
  
  ##################################### Tram length chart #####################################  
  # Highchart 출력
  output$tram_length_bar_chart <- renderHighchart({
    
    # 데이터 준비 (필요에 따라 데이터 정렬)
    data_prepared <- tram_length_data %>%
      select(city, length, country) %>%
      arrange(desc(length))  # 길이를 기준으로 내림차순 정렬
    
    # 각 나라별 색상을 지정
    country_colors <- c(
      "Australia" = "#CFBAF0",
      "Russia" = "#90DBF4",
      "Germany" = "#F1C0E8",
      "Italy" = "#FDE4CF",
      "Poland" = "#B9FBC0",
      "Austria" = "#98F5E1",
      "Hungary" = "#FFCFD2",
      "US" = "#FBF8CC"
    )
    
    # 데이터 리스트 변환
    data_list <- purrr::pmap(list(data_prepared$city, data_prepared$length, data_prepared$country), function(city, length, country) {
      list(name = city, y = length, country = country, color = country_colors[[country]])
    })
    
    # highchart 객체 생성
    highchart() %>%
      hc_chart(type = "bar") %>%
      hc_title(text = "Tram System Length by City", align = "left") %>%
      hc_subtitle(text = 'Source: https://rail.nridigital.com/future_rail_sep23/10_largest_tram_networks', align = 'left') %>%
      
      # X축 설정 (city를 카테고리로 사용)
      hc_xAxis(categories = data_prepared$city,
               title = list(text = NULL),
               gridLineWidth = 1,  # 그리드 라인 설정
               lineWidth = 0) %>%  # X축 라인 설정
      
      # Y축 설정 (length를 y축 값으로 사용)
      hc_yAxis(min = 0,
               title = list(text = 'Length (km)', align = 'high'),
               labels = list(overflow = 'justify'),
               gridLineWidth = 0) %>%
      
      # 툴팁 설정
      hc_tooltip(pointFormat = 'Country: <b>{point.country}</b>') %>%
      
      
      # 바 차트 옵션 설정
      hc_plotOptions(bar = list(
        borderRadius = '3%',
        dataLabels = list(
          enabled = TRUE
        ),
        groupPadding = 0.1  # 바 간격 설정
      )) %>%
      
      
      # 크레딧 비활성화
      hc_credits(enabled = FALSE) %>%
      
      # 시리즈 데이터 설정 (도시별 길이 데이터)
      hc_add_series(name = "Tram System Length",
                    data = data_list,
                    colorByPoint = TRUE)  # 각 바의 색상 변경
  })
  
  observeEvent(input$tram_link, {
    updateRadioButtons(session, "stop_type", selected = "Tram Stops")
  })
  
  observeEvent(input$train_link, {
    updateRadioButtons(session, "stop_type", selected = "Train Stations")
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
}
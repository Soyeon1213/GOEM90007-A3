##################
# USER INTERFACE #
##################

source('tableau-in-shiny-v1.2.R')

scrollToTopJS <- "
shinyjs.scrollToTop = function() {
  window.scrollTo(0, 0);
}
"
###### Home tab UI ######
home_tab <- nav_panel(
  title = "Home",
  
  tags$div(
    style = "
    background-image: url('https://upload.wikimedia.org/wikipedia/commons/7/74/Melbourne_skyline_sor.jpg');
    background-attachment: fixed;
    background-size: cover;
    background-position: center;
    height: 100vh;
    color: white;
    text-align: center;
    position: relative;
  ",
    
    tags$div(
      style = "
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        font-family: 'Avenir', sans-serif;
      ",
      
      # Main Welcome Text
      h1("Welcome to Melbourne!", style = "font-size: 4em; font-weight: bold; color: white;"),
      
      # Sub-Text
      p("Discover the best places to visit and things to do in the city.", style = "font-size: 1.5em; color: white;")
    )
  ),
  
  fluidRow(
    column(2), 
    column(8, align = "left", 
           h2("Welcome"),
           HTML("
             <p><strong>Melbourne is Australia's mecca for all things trendy and tasty. With exquisite dining, exhilarating sport, and abundant art experiences, there are plenty of brilliant things to do in Melbourne.</strong></p>
             <p>A perfect blend of rich cultural history and new age trends is waiting for you in Melbourne. As the sun goes down, the city comes to life with a vibrant dining scene as well as events and exhibitions. Explore its bustling laneways, trendy neighbourhoods, and sophisticated foodie scene to get a taste of what Melbourne is all about.</p>
             <h3>Getting to Melbourne</h3>
             <p>Getting to Melbourne is easy with flights arriving directly at two airports:</p>
             <ul>
               <li>Melbourne Airport at Tullamarine (MEL) is 22km (14mi) from the city and services international and domestic arrivals.</li>
               <li>Avalon Airport (AVV) is 55km (34mi) from the city and services international and domestic flights.</li>
             </ul>
             <p>Hire cars, taxis, rideshares, and a shuttle service are available from both airports. Getting around is just as easy as finding a great cup of coffee in Melbourne. The city offers clean, reliable, and affordable public transport services. There is even a free City Circle tram line with historical commentary.</p>
             <h3>When to visit:</h3>
             <p>Despite having four distinct seasons, Melbourne's weather is known for being a bit unpredictable. Summers are generally warm and winters cold, but just ask a local and they’ll tell you that it’s not uncommon to experience all four seasons in a single day. So whenever you decide to visit, be sure to pack layers and carry an umbrella in your day bag.</p>
             <ul>
               <li><strong>High season:</strong> Spring and summer (November to February)</li>
               <li><strong>Low season:</strong> Winter (June to August)</li>
               <li><strong>Don’t miss:</strong> Melbourne’s world-class festivals and events.</li>
             </ul>
           ")
    ),
    column(2)
  ),
  
  fluidRow(
    column(2), 
    column(8, align = "left", 
           h2("Melbourne's Seasonal Weather", style = "font-size: 2.5em; font-weight: bold;"),
           p("Explore Melbourne's average temperature, rainfall, and rainy days throughout the year.",
             style = "font-size: 1.5em;")
    ),
    column(2)
  ),
  
  gt_output('weather_table'),
  
  br(), br(),
  
  # 차트 추가
  fluidRow(
    column(12, 
           div(class = "chart-container",
               highchartOutput("bar_race_chart", height = "600px"),  # 차트
               actionButton("play_pause_button", label = icon("play"), class = "btn-lg")  # 버튼에 아이콘 추가
           )
    )
  ),
  
  br(),
  
  # 슬라이더 추가
  sliderInput("year_slider", "Select Year:",
              min = min(years), max = max(years), 
              value = min(years), step = 1),
  
  br(), br(),
  
  fluidRow(
    column(3,
           actionButton("btn1", "Transportation", class = "btn-primary", style = "width: 100%;")
    ),
    column(3,
           actionButton("btn2", "Restaurants", class = "btn-primary", style = "width: 100%;")
    ),
    column(3,
           actionButton("btn3", "Attractions", class = "btn-primary", style = "width: 100%;")
    ),
    column(3,
           actionButton("btn4", "Accomodation", class = "btn-primary", style = "width: 100%;")
    )
  ),
  
  br(), br()
)




################
# SHINY SERVER #
################

home_tab_server <- function(input, output, session) {
  # Home 탭의 서버 로직
  
  # Home 화면 탭 이동 버튼 처리
  observeEvent(input$btn1, {
    updateTabsetPanel(session, "navbar", selected = "Transportation")
    js$scrollToTop()  # 스크롤 상단 이동
  })
  
  observeEvent(input$btn2, {
    updateTabsetPanel(session, "navbar", selected = "Restaurants")
    js$scrollToTop()  # 스크롤 상단 이동
  })
  
  observeEvent(input$btn3, {
    updateTabsetPanel(session, "navbar", selected = "Attractions")
    js$scrollToTop()  # 스크롤 상단 이동
  })
  
  observeEvent(input$btn4, {
    updateTabsetPanel(session, "navbar", selected = "Accomodation")
    js$scrollToTop()  # 스크롤 상단 이동
  })
  
  output$melbourne_intro <- renderText({
    # Assuming your text file is in the www folder
    readLines("data/melbourne_intro.txt")
  })
  
  output$weather_table <- render_gt({
    gt(transposed_data) %>%
      tab_header(
        title = "Seasonal Weather in Melbourne"
      ) %>%
      
      # Metric 컬럼 이름을 빈 문자열로 변경 (즉, 'Metric' 글자만 사라짐)
      cols_label(
        Metric = ""
      ) %>%
      
      # Apply custom labels for the values in the 'Metric' column
      text_transform(
        locations = cells_body(columns = "Metric"),
        fn = function(x) {
          ifelse(x == "MaximumTemp", "Maximum Temp (ºC)",
                 ifelse(x == "MinimumTemp", "Minimum Temp (ºC)",
                        ifelse(x == "AvgRainfall", "Avg Rainfall (mm)", 
                               ifelse(x == "AvgRainydays", "Avg Rainy Days", x))))
        }
      ) %>%
      
      # Format the numeric columns (for temperatures with 1 decimal place)
      fmt_number(
        columns = c("Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep",         "Oct", "Nov"),
        rows = Metric %in% c("MaximumTemp", "MinimumTemp"),
        decimals = 1
      ) %>%
      
      # Format AvgRainfall and AvgRainydays as integers
      fmt_number(
        columns = c("Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov"),
        rows = Metric %in% c("AvgRainfall", "AvgRainydays"),
        decimals = 0
      ) %>%
      
      # Apply color to Maximum Temp
      data_color(
        columns = c("Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov"),
        rows = Metric == "MaximumTemp",
        fn = scales::col_numeric(
          palette = c("peachpuff", "orangered"),
          domain = range(transposed_data %>% filter(Metric == "MaximumTemp") %>% select(-Metric), na.rm = TRUE)
        )
      ) %>%
      
      # Apply color to Minimum Temp
      data_color(
        columns = c("Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov"),
        rows = Metric == "MinimumTemp",
        fn = scales::col_numeric(
          palette = c("cornflowerblue", "lightcyan"),
          domain = range(transposed_data %>% filter(Metric == "MinimumTemp") %>% select(-Metric), na.rm = TRUE)
        )
      ) %>%
      
      # 숫자 데이터 가운데 정렬 적용
      tab_style(
        style = cell_text(align = "center"),  # 텍스트 가운데 정렬
        locations = cells_body(
          columns = c("Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov")
        )
      ) %>%
      
      # Apply text style
      tab_style(
        style = list(
          cell_text(color = "black")
        ),
        locations = cells_body(
          columns = c("Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov")
        )
      )
  })
  ##################################### Overview of Tourists number #####################################
  
  # Reactive value for the play/pause state
  playing <- reactiveVal(FALSE)
  
  # Function to move to the next year after animation is complete
  nextStep <- function() {
    if (input$year_slider < max(years)) {
      updateSliderInput(session, "year_slider", value = input$year_slider + 1)
    } else {
      playing(FALSE)  # Stop when it reaches the last year
    }
  }
  # 고정된 색상을 지정할 주요 국가 목록과 색상 팔레트
  fixed_countries <- c("Japan", "New Zealand", "United States of America",
                       "UK, CIs & IOM", "Singapore", "Germany", "Hong Kong",
                       "Canada", "Malaysia", "India", "Korea, South")
  
  fixed_colors <- c(
    "New Zealand" = "#feb1a9", 
    "China" = "#fed2bb",
    "United States of America" = "#fef2cd",
    "UK, CIs & IOM" = "#e7f2c3", 
    "India" = "#cff2b8",
    "Japan" = "#bbe5ca",
    "Singapore" = "#a6d8db",
    "Korea, South" = "#b2baea",
    "Indonesia" = "#bd9cf9",
    "Hong Kong" = "#b8abf2",
    "Germany" = "#91c2eb",
    "Canada" = "#91c2eb",
    "Malaysia" = "#ffccd5",
    "Taiwan" = "#ffccd5"
  )
  
  # 국가별 색상을 고정하기 위한 국가 목록
  countries <- unique(tourist_data %>% select(-Year) %>% names())
  
  # 고정된 국가 외의 국가들에 대해 색상을 생성하는 함수 (리스트로 변환)
  custom_colors <- reactive({
    # 고정된 국가들에 대한 색상 매핑
    dynamic_countries <- setdiff(countries, names(fixed_colors))  # 고정되지 않은 국가들
    dynamic_palette <- colorRampPalette(c("#4CAF50", "#FFC107", "#F44336", "#2196F3"))(length(dynamic_countries))
    
    # 고정된 국가와 동적으로 생성된 국가 색상을 결합
    color_palette_list <- c(fixed_colors, setNames(dynamic_palette, dynamic_countries))
    return(color_palette_list)
  })
  
  # 데이터 준비
  data_prepared <- reactive({
    get_data_for_year(input$year_slider)
  })
  
  # 전체 방문자 수 계산
  total_visitors <- reactive({
    total_data <- tourist_data %>% filter(Year == input$year_slider)
    total_sum <- total_data %>% select(-Year) %>% rowSums(na.rm = TRUE)  # Year를 제외하고 모든 열의 합계
    return(total_sum)
  })
  
  max_visitors <- reactive({
    max(tourist_data %>% select(-Year) %>% unlist(use.names = FALSE), na.rm = TRUE)
  })
  
  # Highchart 객체 생성 (반응형 처리)
  output$bar_race_chart <- renderHighchart({
    hc <- highchart() %>%
      hc_chart(type = "bar") %>%
      
      # 차트 제목과 서브 타이틀
      hc_title(text = "Top Tourist Destinations Over Time", align = "left",
               style = list(fontSize = "24px", color = "#333333")) %>%
      hc_subtitle(text = "Source: Australian Bureau of Statistics", align = "left",
                  style = list(fontSize = "14px", color = "#666666")) %>%
      
      # X축 설정 (Country 카테고리)
      hc_xAxis(categories = data_prepared()$Country,
               title = list(text = NULL),
               gridLineWidth = 0, lineWidth = 0,
               labels = list(style = list(fontSize = "14px", color = "#444444"))) %>%
      
      # Y축 설정 (Value)
      hc_yAxis(min = 0, max = max_visitors(),
               title = list(text = "Number of Tourists", align = 'high',
                            style = list(fontSize = "16px", color = "#444444")),
               labels = list(style = list(fontSize = "14px", color = "#444444")),
               gridLineWidth = 1) %>%
      
      # 툴팁 설정 (단위를 천 단위 쉼표로 표시)
      hc_tooltip(pointFormat = 'Country: <b>{point.name}</b><br>Tourists: <b>{point.y:,.0f}</b>',
                 style = list(fontSize = "14px")) %>%
      
      # 바 차트 옵션 설정 (숫자를 차트 옆에 표시, 천단위 쉼표 추가)
      hc_plotOptions(bar = list(
        dataLabels = list(
          enabled = TRUE,
          format = '{point.y:,.0f}',  # 천 단위 쉼표를 표시
          style = list(fontSize = "12px", color = "#FFFFFF", textOutline = "none"),
          align = "right",  # 바 오른쪽에 숫자 배치
          inside = FALSE),  # 바 내부에 배치
        grouping = FALSE,
        borderRadius = 8,  # 바 모서리 둥글게
        pointPadding = 0.1,  # 바 간격
        groupPadding = 0.05,  # 그룹 간격
        colorByPoint = TRUE,  # 각 바의 색상을 다르게 적용
        animation = list(
          duration = 1  # 애니메이션 시간을 2초로 설정
        )
      )) %>%
      
      # 시리즈 데이터 추가 (각 국가별 색상 지정)
      hc_add_series(name = paste("Year", input$year_slider),
                    data = purrr::map2(data_prepared()$Country, data_prepared()$Value,
                                       ~list(name = .x, y = .y, color = custom_colors()[[.x]])))  # custom_colors() 호출
    
    # 레전드 추가
    hc <- hc %>%
      hc_legend(enabled = TRUE,
                layout = "horizontal",
                align = "center",
                verticalAlign = "top",
                title = list(
                  text = paste("Total (Country of stay/residence):",
                               formatC(total_visitors(), format = "f", big.mark = ",", digits = 0)  # 모든 국가의 방문자 수 합산
                  )),
                itemStyle = list(fontSize = "16px", fontWeight = "bold", color = "#000000"))
    
    # 크레딧 비활성화
    hc <- hc %>%
      hc_credits(enabled = FALSE) %>%
      hc_size(height = 600)  # 차트 크기 설정
    
    return(hc)
  })
  
  # Reactive value for the play/pause state
  playing <- reactiveVal(FALSE)
  
  # Function to move to the next year after animation is complete
  nextStep <- function() {
    if (input$year_slider < max(years)) {
      updateSliderInput(session, "year_slider", value = input$year_slider + 1)
    } else {
      playing(FALSE)  # Stop when it reaches the last year
    }
  }
  
  # 차트를 자연스럽게 업데이트하기 위해 highchartProxy 사용
  observeEvent(input$year_slider, {
    data_prepared <- get_data_for_year(input$year_slider)
    
    # 차트 시리즈만 업데이트 (리렌더링 방지)
    highchartProxy("bar_race_chart") %>%
      hcpxy_update_series(
        id = 0,  # 시리즈가 하나일 경우 id = 0 사용
        data = data_prepared$Value,  # 데이터만 업데이트
        name = paste("Year", input$year_slider)
      ) %>%
      hcpxy_update(
        list(
          xAxis = list(categories = data_prepared$Country)
        )
      )
  })
  
  # 애니메이션이 완료된 후에만 자동으로 차트 갱신
  observeEvent(input$animationComplete, {
    if (playing()) {
      nextStep()  # 애니메이션이 끝난 후에만 다음 연도로 이동
    }
  })
  
  # 버튼의 아이콘을 Play/Pause로 전환
  observeEvent(input$play_pause_button, {
    if (playing()) {
      updateActionButton(session, "play_pause_button",
                         label = HTML(as.character(icon("play"))))  # Play 버튼으로 전환
      playing(FALSE)  # playing 상태를 FALSE로 전환
    } else {
      updateActionButton(session, "play_pause_button",
                         label = HTML(as.character(icon("pause"))))  # Pause 버튼으로 전환
      playing(TRUE)  # playing 상태를 TRUE로 전환
      nextStep()  # 바로 다음 연도로 이동
    }
  })
  
  # 자동 업데이트를 위한 observe 함수
  observe({
    if (playing()) {
      invalidateLater(0.7, session)  # 1.5초마다 다음 연도로 이동
      nextStep()  # playing 상태가 TRUE일 때만 실행
    }
  })
}
library(shiny)
library(shinythemes)
library(shinyjs)
library(readr)
library(gt)
library(dplyr)
library(tidyr)

source('tableau-in-shiny-v1.2.R')

##################
#      DATA      #
##################

data <- read_csv("data/melbourne_weather.csv", show_col_types = FALSE)

transposed_data <- data %>%
  pivot_longer(cols = -Month, names_to = "Metric", values_to = "Value") %>%
  pivot_wider(names_from = Month, values_from = Value)



##################
# USER INTERFACE #
##################

home_tab <- tabPanel(
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
  
  fluidRow(
    column(3,
           actionButton("btn1", "Restaurants", class = "btn-primary", style = "width: 100%;")
    ),
    column(3,
           actionButton("btn2", "Attractions", class = "btn-primary", style = "width: 100%;")
    ),
    column(3,
           actionButton("btn3", "Transportation", class = "btn-primary", style = "width: 100%;")
    ),
    column(3,
           actionButton("btn4", "Accomodation", class = "btn-primary", style = "width: 100%;")
    )
  ),
  
  br(), br()
)

transportation_tab <- tabPanel(
  title="Transportation"
)

restaurant_tab <- tabPanel(
  title = "Restaurants",
  
  # 제목과 스타일링 추가
  h2("Restaurants in Melbourne", style = "text-align: center; font-size: 2.5em; font-weight: bold; margin-bottom: 20px;"),
  
  # 소개 문구 추가
  p(
    "Welcome to Melbourne's culinary paradise, where a vibrant mix of cultures meets on the dining table!",
    style = "text-align: center; font-size: 1.5em; font-weight: bold; color: #555; margin-bottom: 15px;"
  ),
  
  p(
    "As one of the world’s most diverse cities, Melbourne offers an endless variety of international cuisines. ",
    "Here, you’ll experience flavors from every corner of the globe, reflecting the city’s rich immigrant history.",
    "Melbourne is truly a 'city of gastronomy', home to world-renowned food festivals and some of the finest restaurants.",
    "No matter what you’re craving, this city is sure to satisfy any taste bud.",
    style = "text-align: justify; font-size: 1.3em; color: #777; line-height: 1.7; margin-bottom: 30px;"
  ),
  
  p(
    "Ready to embark on a food journey? Explore the map below to discover the best places to eat in Melbourne!",
    style = "text-align: center; font-size: 1.4em; font-weight: bold; color: #555; margin-bottom: 30px;"
  ),
  
  # 지도 섹션의 가운데 정렬 및 고정된 크기 설정
  div(
    style = "text-align: center; width: 100%; margin-bottom: 50px;",  # 지도의 가운데 정렬
    div(
      style = "display: inline-block; width: 800px; height: 600px; overflow: hidden;",
      tableauPublicViz(
        id = "RestaurantMap",
        url = "https://public.tableau.com/views/RestaurantMap_17295190169160/Sheet1?:language=ko-KR&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link"
      )
    )
  ),
  
  # 제목 및 설명 추가 (레스토랑 정보 위에)
  h3("Top 5 Ranked Restaurants in Melbourne", style = "text-align: center; font-weight: bold; margin-top: 20px;"),
  p("These restaurants have received 5-star ratings from TripAdvisor.", style = "text-align: center; font-size: 1.1em; color: #888; margin-bottom: 40px;"),
  
  # 지도가 끝난 후 간격 추가
  br(), br(),
  
  # 레스토랑 정보 섹션 (지도 아래에 추가)
  div(
    style = "padding-top: 50px;",  # 지도와 레스토랑 사이에 간격 추가
    fluidRow(
      # 레스토랑 1
      column(4, align = "center",
             img(src = "ginger_olive.jpg", height = "150px", style = "margin-bottom: 15px;"),
             h4("Ginger Olive Restaurant and Grill"),
             p("U 2 38 Manchester Lane, Melbourne, Victoria 3000"),
             a("Website Link", href = "https://gingerolive.com.au/", target = "_blank")
      ),
      # 레스토랑 2
      column(4, align = "center",
             img(src = "hardware_club.jpg", height = "150px", style = "margin-bottom: 15px;"),
             h4("The Hardware Club"),
             p("43 Hardware Lane, Melbourne, Victoria 3000"),
             a("Website Link", href = "https://www.thehardwareclub.com/", target = "_blank")
      ),
      # 레스토랑 3
      column(4,              align = "center",
             img(src = "ten_square.jpg", height = "150px", style = "margin-bottom: 15px;"),
             h4("Ten Square Café"),
             p("120 Hardware St, Melbourne, Victoria 3000"),
             a("Website Link", href = "https://www.tensquarecafe.com.au/", target = "_blank")
      )
    ),
    
    fluidRow(
      # 레스토랑 4
      column(6, align = "center",
             img(src = "caterinas.jpg", height = "150px", style = "margin-bottom: 15px;"),
             h4("Caterina's Cucina E Bar"),
             p("221 Queen St, Melbourne, Victoria 3000"),
             a("Website Link", href = "https://www.caterinas.com.au/", target = "_blank")
      ),
      # 레스토랑 5
      column(6, align = "center",
             img(src = "tokui_sushi.jpg", height = "150px", style = "margin-bottom: 15px;"),
             h4("Tokui Sushi"),
             p("260 Lonsdale St, Melbourne, Victoria 3000"),
             a("Google Link", href = "https://g.co/kgs/fWawkKC", target = "_blank")
      )
    )
  )
)


attraction_tab <- tabPanel(
  title = "Attractions",
  h2("Explore Melbourne's Top Attractions", 
     style = "text-align: center; margin-bottom: 20px;"),
  
  p("Discover must-visit places across the city with our interactive map and ranking of top attractions.",
    style = "font-size: 1.2em; text-align: center; margin-bottom: 30px;"),
  
  div(
    style = "padding-bottom: 50px;",  # Add space between map and title
    tableauPublicViz(
      id = "AttractionMap",
      url = "https://public.tableau.com/views/AttractionMap/Sheet1?:language=en-GB&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link",
      width = "100%", 
      height = "600px"
    )
  ),
  
  h3("Top 10 Most Popular Attractions in Melbourne",
     style = "text-align: center; margin-top: 30px; margin-bottom: 20px;"),
  
  div(
    style = "padding-bottom: 50px;",  # Add bottom padding for better spacing
    tableauPublicViz(
      id = "TopAttractionChart",
      url = "https://public.tableau.com/shared/CR99P4C96?:display_count=n&:origin=viz_share_link",
      width = "100%", 
      height = "700px"
    )
  ),
  
  tags$div(
    style = "text-align: center; margin-top: 50px; margin-bottom: 50px;",
    h3("Tours"),
    
    # Container for tour cards
    tags$div(
      style = "display: flex; justify-content: center; gap: 20px; max-width: 1200px; margin: auto;",
      
      # First Tour Card
      tags$div(
        style = "width: 30%; text-align: center;",
        tags$img(src = "https://img1.wsimg.com/isteam/ip/58b25b38-2727-4821-bcc1-aa45e268de8c/melbourne%20path%20jpg.jpg/:/rs=w:365,h:365,cg:true,m/cr=w:365,h:365", style = "width: 100%; height: auto;"),
        tags$h4("Melbourne / Narrm"),
        tags$p("A perfect introduction to the city. This tour will teach you a lot about Melbourne, for visitors and locals alike..."),
        tags$button("BOOK NOW", onclick = "window.open('https://www.trybooking.com/events/landing/1191875?');", style = "padding: 10px; font-size: 16px;")
      ),
      
      # Second Tour Card
      tags$div(
        style = "width: 30%; text-align: center;",
        tags$img(src = "https://img1.wsimg.com/isteam/ip/58b25b38-2727-4821-bcc1-aa45e268de8c/docklandspath.png/:/cr=t:0%25,l:7.05%25,w:85.9%25,h:99.99%25/rs=w:365,h:365,cg:true,m", style = "width: 100%; height: auto;"),
        tags$h4("Docklands"),
        tags$p("A neighbourhood of luck and squandered opportunities. This tour will showcase some of the surprisingly..."),
        tags$button("COMING SOON", disabled = TRUE, style = "padding: 10px; font-size: 16px;")
      ),
      
      # Third Tour Card
      tags$div(
        style = "width: 30%; text-align: center;",
        tags$img(src = "https://img1.wsimg.com/isteam/ip/58b25b38-2727-4821-bcc1-aa45e268de8c/20210210_164725.png/:/rs=w:365,h:365,cg:true,m/cr=w:365,h:365", style = "width: 100%; height: auto;"),
        tags$h4("Brunswick / Bulleke-Bek"),
        tags$p("Tour the cultural inner-city neighbourhood. This tour will teach you about colonization, communist gatherings..."),
        tags$button("COMING SOON", disabled = TRUE, style = "padding: 10px; font-size: 16px;")
      )
    )
  )
)

accomodation_tab <- tabPanel(
  title="Accomodation",
  h2("Accomodation in Melbourne"),
  tableauPublicViz(
    id="AccomodationMap",
    url="https://public.tableau.com/views/Airbnb_17295563103790/Sheet1?:language=en-GB&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link",
    height="600px"
  )
)

# reference to text copied and pasted from other websites, can be deleted if unnecessary
footer <- tags$div(
  style = "text-align: center; padding: 20px; background-color: #f1f1f1; position: relative; bottom: 0; width: 100%; margin-top: 50px;",
  
  tags$p("References:"),
  tags$a(href = "https://www.australia.com/en/places/melbourne-and-surrounds/guide-to-melbourne.html#tabs-0c2df5cea2-item-405b2b8f98-tab", "Guide to Melbourne - Australia.com", target = "_blank"),
  tags$br(),
  tags$a(href = "https://localguidetomelbourne.com/tours", "Local Guide to Melbourne - Tours", target = "_blank")
)

ui <- navbarPage(
  id = "navbar",  # 'id' 속성 추가
  theme = shinytheme("paper"), # other themes: cerulean, cosmo, lumen, flatly
  header=setUpTableauInShiny(),
  title = "Melbourne City Guide",
  
  home_tab,
  transportation_tab,
  restaurant_tab,
  attraction_tab,
  accomodation_tab,
  
  footer
)


################
# SHINY SERVER #
################

server <- function(input, output, session) {
  
  # Home 화면 탭 이동 버튼 처리
  observeEvent(input$btn1, {
    updateTabsetPanel(session, "navbar", selected = "Restaurants")
  })
  
  observeEvent(input$btn2, {
    updateTabsetPanel(session, "navbar", selected = "Attractions")
  })
  
  observeEvent(input$btn3, {
    updateTabsetPanel(session, "navbar", selected = "Transportation")
  })
  
  observeEvent(input$btn4, {
    updateTabsetPanel(session, "navbar", selected = "Accomodation")
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
}


#############
# RUN SHINY #
#############

shinyApp(ui, server, options=list(launch.browser=TRUE))

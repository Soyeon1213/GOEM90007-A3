##################
# USER INTERFACE #
##################

source('tableau-in-shiny-v1.2.R')

###### Restaurant tab UI ######  
restaurant_tab <- nav_panel(
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
  
  # 클릭된 레스토랑 정보 테이블 섹션 (위쪽에 타이틀 추가)
  div(
    h3("Selected Restaurant Information", style = "text-align: center; font-weight: bold; margin-bottom: 20px;"),
    gt_output("restaurant_info")
  ),
  
  # 제목 및 설명 추가 (레스토랑 정보 위에)
  h3("Top 5 Ranked Restaurants in Melbourne", style = "text-align: center; font-weight: bold; margin-top: 20px;"),
  p("These restaurants have received 5-star ratings from TripAdvisor.", style = "text-align: center; font-size: 1.1em; color: #888; margin-bottom: 40px;"),
  
  # 지도가 끝난 후 간격 추가
  br(), br(), br(), br(),
  
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



################
# SHINY SERVER #
################

restaurant_tab_server <- function(input, output, session) {
  # Home 탭의 서버 로직
  
  ##################################### Restauran tab link click event #####################################
  observeEvent(input$RestaurantMap_mark_selection_changed, {
    
    # 선택된 값이 없으면 빈 테이블 출력
    if (length(input$RestaurantMap_mark_selection_changed) == 0) {
      restaurant_table <- data.frame(Info = c("Name:", "Address:", "Rating:", "Price Level:"),
                                     Value = c("", "", "", ""))
      output$restaurant_info <- render_gt({
        gt(restaurant_table) %>%
          tab_options(
            table.width = pct(60),  # 표의 너비 고정
            table.font.size = 14,   # 폰트 크기 조정
            data_row.padding = px(10),  # 행 패딩 조정
            heading.align = "left",    # 헤더 정렬
            column_labels.hidden = TRUE
          ) %>%
          cols_label(Info = "", Value = "")  # 첫 번째 행의 레이블 제거
      })
      return()  # 이 시점에서 종료
    }
    
    selected_restaurant <- input$RestaurantMap_mark_selection_changed
    selected_name <- selected_restaurant$`Trading name`
    
    # 선택된 레스토랑 데이터 필터링
    selected_info <- restaurant_data %>%
      filter(`Trading name` == selected_name) %>%
      select(`Trading name`, `Business address`, rating, priceLevel, `Industry Category`)
    
    # 데이터를 표 형식으로 구성
    if (nrow(selected_info) > 0) {
      restaurant_table <- data.frame(
        Info = c("Name:", "Address:", "Rating:", "Price Level:"),
        Value = c(selected_info$`Trading name`, selected_info$`Business address`, selected_info$rating, selected_info$priceLevel),
        Category = selected_info$`Industry Category`  # 카테고리 추가
      )
    } else {
      restaurant_table <- data.frame(Info = c("Name:", "Address:", "Rating:", "Price Level:"),
                                     Value = c("", "", "", ""),
                                     Category = "")
    }
    
    # 카테고리별로 전체 표의 색상을 변경하여 출력
    output$restaurant_info <- render_gt({
      gt(restaurant_table) %>%
        tab_options(
          table.width = pct(60),
          table.font.size = 14,
          data_row.padding = px(10),
          heading.align = "left",
          column_labels.hidden = TRUE
        ) %>%
        # 테이블 전체 배경색을 카테고리에 맞게 지정
        tab_style(
          style = list(cell_fill(color = case_when(
            restaurant_table$Category[1] == "Cafes and Restaurants" ~ "mistyrose",
            restaurant_table$Category[1] == "Pubs, Taverns and Bars" ~ "peachpuff",
            restaurant_table$Category[1] == "Takeaway Food Services" ~ "thistle",
            restaurant_table$Category[1] == "Bakery" ~ "lemonchiffon",
            restaurant_table$Category[1] == "Convenience Store" ~ "honeydew",
            restaurant_table$Category[1] == "Supermarket and Grocery Stores" ~ "azure",
            restaurant_table$Category[1] == "Others" ~ "gainsboro"
          ))),
          locations = cells_body(columns = everything())
        ) %>%
        cols_hide(columns = "Category") %>%  # Category 컬럼을 숨김
        cols_label(Info = "", Value = "")  # Info와 Value 레이블 제거
    })
  })
  
  # 기본적으로 빈 테이블을 출력
  output$restaurant_info <- render_gt({
    gt(data.frame(Info = c("Name:", "Address:", "Rating:", "Price Level:"),
                  Value = c("", "", "", ""))) %>%
      tab_options(
        table.width = pct(60),
        table.font.size = 14,
        data_row.padding = px(10),
        heading.align = "left",
        column_labels.hidden = TRUE
      ) %>%
      cols_label(Info = "", Value = "")  # Info와 Value 레이블 제거
  })
}
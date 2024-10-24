library(shiny)
library(shinythemes)
library(shinyjs)
library(readr)
library(gt)
library(dplyr)
library(tidyr)
library(bslib)
library(highcharter)
library(fontawesome)
library(shinyWidgets)
library(jsonlite)
library(leaflet)
library(geojsonio)
library(sf)

source('tableau-in-shiny-v1.2.R')

# 소스 파일들 불러오기
source("data.R")        # 데이터를 불러오는 파일
source("home.R")         # Home 탭 UI 및 서버
source("transportation.R") # Transportation 탭 UI 및 서버
source("restaurant.R")   # Restaurants 탭 UI 및 서버
source("attraction.R")   # Attraction 탭 UI 및 서버
source("accomodation.R") # Accomodation 탭 UI 및 서버

ui <- page_navbar(
  id = "navbar",
  theme = bs_theme(
    bootswatch = "yeti"
    #navbar_bg = "#d3d3d3"
  ),
  header = tagList(
    setUpTableauInShiny(),
    # shinyjs를 사용하기 위한 태그 추가
    useShinyjs(),
    extendShinyjs(text = scrollToTopJS, functions = c("scrollToTop"))
  ),
  title = "Melbourne City Guide",
  
  home_tab,
  transportation_tab,
  restaurant_tab,
  attraction_tab,
  accomodation_tab,
  
  
  # shinyjs를 사용하기 위한 태그 추가
  useShinyjs(),
  extendShinyjs(text = scrollToTopJS, functions = c("scrollToTop"))
)

# 서버 설정
server <- function(input, output, session) {
  
  # 각 탭의 서버 함수 호출
  home_tab_server(input, output, session)
  transportation_tab_server(input, output, session)
  restaurant_tab_server(input, output, session)
  attraction_tab_server(input, output, session)
  accomodation_tab_server(input, output, session)
}

# 앱 실행
shinyApp(ui, server, options=list(launch.browser=TRUE))
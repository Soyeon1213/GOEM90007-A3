##################
# USER INTERFACE #
##################

source('tableau-in-shiny-v1.2.R')

###### Attraction tab UI ######  
attraction_tab <- nav_panel(
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


################
# SHINY SERVER #
################

attraction_tab_server <- function(input, output, session) {
  # Home 탭의 서버 로직
}
library(shiny)
library(shinythemes)
library(shinyjs)

source('tableau-in-shiny-v1.2.R')

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
  )
)

transportation_tab <- tabPanel(
  title="Transportation"
)

restaurant_tab <- tabPanel(
  title="Restaurants",
  h2("Restaurants in Melbourne"),
  tableauPublicViz(
    id="RestaurantMap",
    url="https://public.tableau.com/views/RestaurantMap_17295190169160/Sheet1?:language=ko-KR&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link",
    width = "100%", 
    height = "600px"
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

server <- function(input, output, session) {
  output$melbourne_intro <- renderText({
    # Assuming your text file is in the www folder
    readLines("data/melbourne_intro.txt")
  })
}

# Run the application
shinyApp(ui, server, options=list(launch.browser=TRUE))


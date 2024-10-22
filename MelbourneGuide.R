library(shiny)
library(shinythemes)
library(shinyjs)

source('tableau-in-shiny-v1.2.R')

home_tab <- tabPanel(
  title = "Home",
  
  # Full-width background with text overlay
  tags$div(
    style = "
      background-image: url('https://upload.wikimedia.org/wikipedia/commons/7/74/Melbourne_skyline_sor.jpg');
      background-size: cover;
      background-position: center;
      height: 100vh;
      color: white;
      text-align: center;
      position: relative;
    ",
    
    # Text Overlay
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

  # Additional Welcome Text
  fluidRow(
    column(2), # Empty column for padding on the left
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
    column(2) # Empty column for padding on the right
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
    url="https://public.tableau.com/views/RestaurantMap_17295190169160/Sheet1?:language=ko-KR&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link"
  )
)

attraction_tab <- tabPanel(
  title="Attractions",
  h2("Attractions in Melbourne"),
  tableauPublicViz(
    id="AttractionMap",
    url="https://public.tableau.com/views/AttractionMap/Sheet1?:language=en-GB&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link",
    width = "100%",
    height = "600px"
  ),
  
  h3("Check out must-see sights and activities in Melbourne City"),
  tableauPublicViz(
    id="TopAttractionChart",
    url="https://public.tableau.com/shared/CR99P4C96?:display_count=n&:origin=viz_share_link",
    width = "50%", 
    height = "600px" 
    )
)

accomodation_tab <- tabPanel(
  title="Accomodation",
  h2("Accomodation in Melbourne"),
  tableauPublicViz(
    id="AccomodationMap",
    url="https://public.tableau.com/views/Airbnb_17295563103790/Sheet1?:language=en-GB&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link",
    height="500px"
  )
  
)

ui <- navbarPage(
  theme = shinytheme("paper"), # other themes: cerulean, cosmo, lumen, flatly
  header=setUpTableauInShiny(),
  title = "Melbourne City Guide",
  
  home_tab,
  transportation_tab,
  restaurant_tab,
  attraction_tab,
  accomodation_tab
  
)

# Server logic
server <- function(input, output, session) {
  output$melbourne_intro <- renderText({
    # Assuming your text file is in the www folder
    readLines("data/melbourne_intro.txt")
  })
}

# Run the application
shinyApp(ui, server, options=list(launch.browser=TRUE))


library(shiny)
library(shinyjs)

# Load your Airbnb data from the CSV file
airbnb_data <- read.csv("data/top-rated_rentals.csv")

ui <- fluidPage(
  useShinyjs(),
  
  # Title
  h2("Top Rated Airbnb Listings"),
  
  # Create a fluid row for the cards
  fluidRow(
    lapply(1:nrow(airbnb_data), function(i) {
      column(3,  # Each card takes up 3 columns (4 cards in a row)
             div(class = "card",
                 style = "margin: 1px; padding: 2px; border-radius: 0px; height: 450px; display: flex; flex-direction: column;",
                 h4(airbnb_data$title[i]),
                 img(src = airbnb_data$img_url[i], style = "width: 100%; height: 200px; object-fit: cover; border-radius: 5px;"),
                 
                 h5(airbnb_data$name[i]),
                 p(paste("Score:", airbnb_data$score[i])),
                 div(style = "flex-grow: 1; overflow: hidden; text-overflow: ellipsis; display: -webkit-box; -webkit-box-orient: vertical; -webkit-line-clamp: 4;", 
                     airbnb_data$summary[i]),  # Allow summary to grow and fill space
                 actionButton(paste0("book_now_", i), "Book Now", 
                              onclick = sprintf("window.open('%s', '_blank')", airbnb_data$book_url[i]), 
                              style = "margin-top: 10px;")  # Add Book Now button
                 
             )
      )
    })
  )
)

server <- function(input, output, session) {
  # No server logic needed for this static display
}

shinyApp(ui, server, options = list(launch.browser = TRUE))


library(shiny)
library(shinyjs)
library(DT)

ui <- fluidPage(
  useShinyjs(),
  
  # Main container for the hotel section
  tags$div(
    style = "text-align: center; width: 100%; margin-bottom: 50px;",  
    h3("Unique Stay Experience"),
    
    # Vertical layout for the Tableau visualizations and hotel info
    div(
      style = "display: flex; flex-direction: column; align-items: center; gap: 20px; margin-top: 20px;",
      
      # First Tableau visualization (top)
      div(
        style = "width: 100%; max-width: 800px; height: 400px; overflow: hidden;",
        tags$div(
          style = "height: 100%;",
          h4("Tableau Visualization 1"),
          tableauPublicViz("tableau_viz", "https://public.tableau.com/shared/CGWYWKTR9?:display_count=n&:origin=viz_share_link")
        )
      ),
      
      # Second Tableau visualization for nearby attractions (middle)
      div(
        style = "width: 100%; max-width: 800px; height: 300px; overflow: hidden;",
        tags$div(
          style = "height: 100%;",
          h4("Nearby Attractions"),
          tableauPublicViz("NearbyAttractions", "https://public.tableau.com/views/Airbnb_17295563103790/Sheet8?:language=en-US&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link", height = "100%", width = "100%")
        )
      ),
      
      # Hotel information table (bottom)
      div(
        id = "hotelInfo",
        style = "width: 100%; max-width: 800px; height: 300px; overflow-y: auto; border: 1px solid #ccc; padding: 10px;",
        tags$div(
          style = "height: 100%;",
          h4("Hotel Information"),
          DTOutput("hotelTable"),
          uiOutput("bookingButton")
        )
      )
    )
  )
)

server <- function(input, output, session) {
  # Server logic here
}

shinyApp(ui, server, options = list(launch.browser = TRUE))
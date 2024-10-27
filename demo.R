library(shiny)
library(shinyjs)
library(ggplot2)
if(!require("DT")) install.packages("DT")


# Load your hotel data
hotel_data <- read.csv("data/hotel.csv")

# Source the tableau-in-shiny library
source("tableau-in-shiny-v1.2.R")

ui <- fluidPage(
  useShinyjs(),
  setUpTableauInShiny(),
  
  # Tableau visualization with fixed size
  tags$div(
    style = "height: 500px; overflow: hidden;",  # Fixed height and hide overflow
    tableauPublicViz("tableau_viz", "https://public.tableau.com/shared/CGWYWKTR9?:display_count=n&:origin=viz_share_link", height = "100%", width = "100%")
  ),
  
  # Title for the table
  h3("Unique Stay Experience"),
  
  # Output for the hotel information wrapped in a div with fixed size
  div(id = "hotelInfo",
      style = "height: 300px; width: 100%; overflow-y: auto; border: 1px solid #ccc; padding: 10px; margin-top: 10px;",
      DTOutput("hotelTable"),
      uiOutput("bookingButton")
  )
)

server <- function(input, output, session) {
  
  # Observe the mark selection changed event
  observeEvent(input$tableau_viz_mark_selection_changed, {
    selected_hotel <- input$tableau_viz_mark_selection_changed
    
    # Check if selected_hotel is not NULL and has data
    if (!is.null(selected_hotel) && nrow(selected_hotel) > 0) {
      hotel_name <- selected_hotel$Name[1]  # Use the correct column name
      
      # Filter the hotel data for the selected hotel
      selected_data <- hotel_data[hotel_data$name == hotel_name, ]
      
      # Check if selected_data is not empty
      if (nrow(selected_data) > 0) {
        # Calculate the average of the specified columns
        avg_score <- mean(c(selected_data$Location, selected_data$Cleanliness, selected_data$Service, selected_data$Value), na.rm = TRUE)
        
        # Prepare data for the output data frame
        output_data <- data.frame(
          `Overall Score` = avg_score,
          Pool = ifelse(selected_data$Pool == 1, "Yes", "No"),
          `Bar...lounge` = ifelse(selected_data$`Bar...lounge` == 1, "Yes", "No"),  # Adjusted to match the CSV header
          Gym = ifelse(selected_data$Gym == 1, "Yes", "No"),
          Link = sprintf('<a href="%s" target="_blank">Book Now</a>', selected_data$website)  # Create a clickable link
        )
        
        # Rename columns to have spaces instead of dots
        colnames(output_data) <- c("Overall Score", "Pool", "Bar / Lounge", "Gym", "Link")
        
        # Render the table
        output$hotelTable <- renderDT({
          datatable(output_data, options = list(dom = 't', paging = FALSE), rownames = FALSE, escape = FALSE)  # Set escape = FALSE to allow HTML rendering
        })
      } else {
        # Handle case where no data is found for the selected hotel
        output$hotelTable <- renderDT(NULL)  # Clear the table
      }
    } else {
      # Handle case where no hotel is selected
      output$hotelTable <- renderDT(NULL)  # Clear the table
    }
  })
}


shinyApp(ui, server, options = list(launch.browser = TRUE))
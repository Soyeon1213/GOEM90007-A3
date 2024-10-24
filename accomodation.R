##################
# USER INTERFACE #
##################

source('tableau-in-shiny-v1.2.R')

###### Accomodation tab UI ######  
accomodation_tab <- nav_panel(
  title="Accomodation",
  h2("Accomodation in Melbourne"),
  tableauPublicViz(
    id="AccomodationMap",
    url="https://public.tableau.com/views/Airbnb_17295563103790/Sheet1?:language=en-GB&publish=yes&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link",
    height="600px"
  )
)


################
# SHINY SERVER #
################

accomodation_tab_server <- function(input, output, session) {
  # Home 탭의 서버 로직
}
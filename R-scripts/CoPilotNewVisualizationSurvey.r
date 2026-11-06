###Shiny Survey

# Install released version from CRAN
if (!requireNamespace("shiny", quietly = TRUE)) {
  install.packages("shiny")
}

if (!requireNamespace("shinysurveys", quietly = TRUE)) {
  if (!requireNamespace("devtools", quietly = TRUE)) {
    install.packages("devtools")  # Install devtools if not already installed
  }
  devtools::install_github("jdtrat/shinysurveys")
}

if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
if (!requireNamespace("shinyapp", quietly = TRUE)) {
  install.packages("shinyapp")
}
if (!requireNamespace("Microsoft365R", quietly = TRUE)) {
  install.packages("Microsoft365R")
}

# Load package
library(shinysurveys)
library(dplyr)
library(shiny)
library(Microsoft365R)
library(shinyWidgets)

##First we are going to make the students take a survey to determine whether or not Copilot can assist them in making a new graphic

df_newgraphic <- data.frame(question = c("What is your participant ID located in the top left corner?","For the above plot, did you ask CoPilot to create a visualization of the data?","For the above plot, did you ask CoPilot to create a visualization of the data?", "Do you feel the new graphic was effective?","Do you feel the new graphic was effective?", "Is this new plot/graphic something you have seen before?","Is this new plot/graphic something you have seen before?", "Describe the new visualization Copilot created for you.", "Will you use this visualization?","Will you use this visualization?", "Did you ask if CoPilot could improve the original visualization?","Did you ask if CoPilot could improve the original visualization?","If Copilot gave you suggestions on the original visualization describe any enhancements to the graph that you felt CoPilot offered that was helpful."),
                            option = c("000","Yes","No","Yes", "No", "Yes", "No", "The new visualization was a barplot", "Yes", "No", "Yes", "No", "They colors were more supportive of my findings"),
                            input_type = c("text","y/n", "y/n","y/n", "y/n","y/n", "y/n","text","y/n", "y/n","y/n", "y/n","text"),
                            input_id = c("participant_id","create_plot","create_plot", "effective_plot","effective_plot","new_plot","new_plot","plot_description",
                                         "use_plot","use_plot","improve_plot","improve_plot", "enhancement_description"),
                            dependence = rep(NA, 13),
                            dependence_value = rep(NA, 13),
                            required = rep(F, 13))
ui <- shiny::fluidPage(
  textOutput("subject_id_display"),
  shinysurveys::surveyOutput(df = df_newgraphic,
                             survey_title = "Creation of New Data Visualizations with Github CoPilot",
                             survey_description = "Make sure to record your survey ID, as you will need it in other surveys. Refer to the website to follow the tutorial of creating a new visualization with GitHub CoPilot"),
panel(
    progressBar(
      id = "progress", value = 0, total = 100,
      display_pct = TRUE, title = "Waiting for submission"
    )
  )
)
server <- function(input, output, session) {
  subject_id <- sample(1:1e6, 1)
  
   output$subject_id_display <- shiny::renderText(
    paste("Your participant ID:", subject_id)
  )
  renderSurvey()

   set_progress <- function(value, title) {
    updateProgressBar(session = session, id = "progress",
                      value = value, total = 100, title = title)
  }
  observeEvent(input$submit, {
    
    set_progress(25, "Connecting to the Wise Lab Team drive...")
    response_data <- shinysurveys::getSurveyData()
    response_data$subject_id <- subject_id 
    team <- get_team("Wise Lab Team")
    drv <- team$get_drive()
    general_folder <- drv$get_item("General")
    ai_github_folder <- general_folder$get_item("AI GitHub")
    rds_file <- ai_github_folder$get_item("spring2024survey.rds")
    
    # load file
    set_progress(50, "Loading the results file...")
    dataoutput <- rds_file$load_rds()
    dataout2 <- rbind(dataoutput, response_data)
    
    # Save results
    set_progress(75, "Saving results...")
    ai_github_folder$save_rds(object = dataout2, file = "spring2024survey.rds")
    print(response_data)
    
    set_progress(100, "Survey complete.")
    showModal(modalDialog(
      title = "Congrats, you completed your first Lab CoPilot survey!",
      "Please Continue in the website with the Github coPilot Work Through Tutorial to move onto the current visualization survey.",
      footer = actionButton("complete_survey", "Complete")
    )) 
  })
  # Close the app when the "Complete" button is clicked 
  observeEvent(input$complete_survey, { 
    stopApp() # Stops the Shiny app 
  })
}

# Run the Shiny app
run_survey <- function() {
  shiny::runApp(list(ui = ui, server = server))
}

###Shiny Survey

# Install released version from CRAN
if (!requireNamespace("shinysurveys", quietly = TRUE)) {
  install.packages("shinysurveys")
}
devtools::install_github("jdtrat/shinysurveys")
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}
if (!requireNamespace("shinyapp", quietly = TRUE)) {
  install.packages("shinyapp")
}
if (!requireNamespace("Microsoft365R", quietly = TRUE)) {
  install.packages("Microsoft365R")
}
if (!requireNamespace("shinysurveys", quietly = TRUE)) {
  if (!requireNamespace("devtools", quietly = TRUE)) {
    install.packages("devtools")  # Install devtools if not already installed
  }
  devtools::install_github("jdtrat/shinysurveys")
}

# Load package
library(shinysurveys)
library(dplyr)
library(shiny)
library(Microsoft365R)

##First we are going to make the students take a survey to determine whether or not Copilot can assist them in making a new graphic

df_newgraphic <- data.frame(question = c("For the above plot, did you ask CoPilot to create a visualization of the data?","For the above plot, did you ask CoPilot to create a visualization of the data?", "Do you feel the new graphic was effective?","Do you feel the new graphic was effective?", "Is this new plot/graphic something you have seen before?","Is this new plot/graphic something you have seen before?", "Describe the new visualization Copilot created for you.", "Will you use this visualization?","Will you use this visualization?", "Did you ask if CoPilot could improve the original visualization?","Did you ask if CoPilot could improve the original visualization?","If Copilot gave you suggestions on the original visualization describe any enhancements to the graph that you felt CoPilot offered that was helpful."),
                            option = c("Yes","No","Yes", "No", "Yes", "No", "The new visualization was a barplot", "Yes", "No", "Yes", "No", "They colors were more supportive of my findings"),
                            input_type = c("y/n", "y/n","y/n", "y/n","y/n", "y/n","text","y/n", "y/n","y/n", "y/n","text"),
                            input_id = c("create_plot","create_plot", "effective_plot","effective_plot","new_plot","new_plot","plot_description",
                                         "use_plot","use_plot","improve_plot","improve_plot", "enhancement_description"),
                            dependence = rep(NA, 12),
                            dependence_value = rep(NA, 12),
                            required = rep(F, 12))
ui <- shiny::fluidPage(
  shinysurveys::surveyOutput(df = df_newgraphic,
                             survey_title = "Creation of New Data Visualizations with Github CoPilot",
                             survey_description = "Refer to the website to follow the tutorial of creating a new visualization with GitHub CoPilot")
)

server <- function(input, output, session) {
  subject_id <- sample(1:1e6, 1)
  renderSurvey()
  
  observeEvent(input$submit, {
    showModal(modalDialog(
      title = "Congrats, you completed your first Lab CoPilot survey!",
      "Please Continue in the website with the Github coPilot Work Through Tutorial to move onto the current visualization survey.",
      footer = actionButton("complete_survey", "Complete")
    )) 
    response_data <- getSurveyData() 
    response_data$subject_id <- subject_id 
    team <- get_team("Wise Lab Team")
    drv <- team$get_drive()
    items <- drv$list_files()
    general_folder <- drv$get_item("General")
    ai_github_folder <- general_folder$get_item("AI GitHub")
    rds_file <- ai_github_folder$get_item("spring2024survey.rds")
    dataoutput <- rds_file$load_rds()
    dataout2 <- rbind(dataoutput, response_data)
    ai_github_folder$save_rds(
      object = dataout2, 
      file = "spring2024survey.rds"
    )
    print(response_data)
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

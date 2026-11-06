##Now we are going to create a survey for the end of year survey
  df_time <- data.frame(question = c("What is your participant ID?","Overall, rate your experience using Copilot on a scale of 1-5, 5 being extremely helpful and 1 being no help at all.","Did you feel that Copilot helped you in understanding errors?", "Did you feel that Copilot helped you in understanding errors?","If you think Copilot assisted you in understanding errors, can you give an example of what kind of error/errors it helped you understand?", "Do you feel that Copilot provided you with new helpful information that could improve your code, graphs, or efficiency?","Do you feel that Copilot provided you with new helpful information that could improve your code, graphs, or efficiency?", "Did you ever ask Copilot to restructure your dataframe?","Did you ever ask Copilot to restructure your dataframe?",  "If you asked Copilot to restructure your data frame, did you feel it taught you an efficient way to do it?", "If you asked Copilot to restructure your data frame, did you feel it taught you an efficient way to do it?", "If yes, describe the new efficiencies Copilot taught you", "How many hours per week do you think you used Copilot this year?"),
                        option = c("000","0","Yes","No", "Errors for printing plots in a loop", "Yes", "No","Yes", "No","Yes", "No", "It introduced tidyr pivot", "0"),
                        input_type = c("text","numeric", "y/n","y/n", "text", "y/n", "y/n", "y/n", "y/n", "y/n","y/n", "text", "numeric"),
                        input_id = c("participant_id","helpful_AI","understand_improve", "understand_improve", "improve_example", "code_efficiency","code_efficiency",
                                     "restructure_data","restructure_data","restructure_efficient","restructure_efficient", "restructure_example","time_spent"),
                        dependence = rep(NA, 13),
                        dependence_value = rep(NA, 13),
                        required = rep(F, 13))
uiii <- shiny::fluidPage(
  shinysurveys::surveyOutput(df = df_time,
                             survey_title = "End of Year Survey on Copilot Usage",
                             survey_description = "Thank you for participating in our research project on AI usage in undergraduate research, please take the following survey on your usage of CoPilot"),
   panel(
    progressBar(
      id = "progress", value = 0, total = 100,
      display_pct = TRUE, title = "Waiting for submission"
    )
  )
)

server <- function(input, output, session) {
  
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
    
    set_progress(100, "Survey Complete.")
    showModal(modalDialog(
      title = "Thank you again for participating in our research, we greatly appreciate it",
      "Thank you for being an active participant of research on Salve Regina Universities campus.",
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
  shiny::runApp(list(ui = uiii, server = server))
}

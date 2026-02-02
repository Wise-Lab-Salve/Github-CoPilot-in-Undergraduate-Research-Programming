# Load package

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

##Now we are going to create a survey for improving computational times using Copilot
df_time <- data.frame(question = c("Were you successfully able to use the command system.time ?","Were you successfully able to use the command system.time ?", "How long did the system.time command tell you it took to run your code (in seconds)?","Copy your code into copilot and ask the copilot if it can improve your code to make it run quicker than the time you got in question #2. Did copilot provide you with changes in your code?", "Copy your code into copilot and ask the copilot if it can improve your code to make it run quicker than the time you got in question #2. Did copilot provide you with changes in your code?","Run the code that the Copilot provided with you in R using the system.time command. How much time did it take for the copilot edited code to run (in seconds)?","Was the output of the code that copilot provided you identical to the original?", "Was the output of the code that copilot provided you identical to the original?","Do you feel copilots adjustments to your code made your code run significantly quicker?", "Do you feel copilots adjustments to your code made your code run significantly quicker?","Would you use these adjustments again to speed up the process of running a code you will run in the future?", "Would you use these adjustments again to speed up the process of running a code you will run in the future?"),
                      option = c("Yes","No","0", "Yes", "No", "0", "Yes", "No", "Yes", "NO", "Yes", "No"),
                      input_type = c("y/n", "y/n","numeric", "y/n","y/n", "numeric","y/n","y/n", "y/n","y/n", "y/n","y/n"),
                      input_id = c("sucess_time","sucess_time", "actual_time","improve_time","improve_time","edited_code",
                                   "identical_code","identical_code","quicker_time","quicker_time", "future_use","future_use"),
                      dependence = rep(NA, 12),
                      dependence_value = rep(NA, 12),
                      required = rep(F, 12))
uiii <- shiny::fluidPage(
  shinysurveys::surveyOutput(df = df_time,
                             survey_title = "Improving Computational Time Using Copilot",
                             survey_description = "To determine if Copilot can help improve the computational time for your code,  you will use the function system.time in R. To use this command, insert your code as follows: system.time({your code}). Don't forget the brackets!")
)

server <- function(input, output, session) {
  subject_id <- sample(1:1e6, 1)
  renderSurvey()
  observeEvent(input$submit, {
    showModal(modalDialog(
      title = "Congrats, you completed your third Lab coPilot survey!",
      "Thank you for participating in this survey!.",
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
  shiny::runApp(list(ui = uiii, server = server))
}

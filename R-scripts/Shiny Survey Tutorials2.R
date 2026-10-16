
# Install packages if needed

if (!requireNamespace("shiny", quietly = TRUE)) {
  install.packages("shiny")
}

if (!requireNamespace("shinysurveys", quietly = TRUE)) {
  if (!requireNamespace("devtools", quietly = TRUE)) {
    install.packages("devtools")
  }
  devtools::install_github("jdtrat/shinysurveys")
}

if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}

if (!requireNamespace("Microsoft365R", quietly = TRUE)) {
  install.packages("Microsoft365R")
}

if (!requireNamespace("uuid", quietly = TRUE)) {
  install.packages("uuid")
}


# 2. Load packages

library(shiny)
library(shinysurveys)
library(dplyr)
library(Microsoft365R)
library(uuid)


# 3. Create survey questions

df_currentgraphic <- data.frame(
  
  question = c(
    "For your current visualization did you ask CoPilot to give you new color suggestions?",
    "For your current visualization did you ask CoPilot to give you new color suggestions?",
    "Could Copilot provide you with color suggestions that are easy for colorblind indivduals to distinguish?",
    "Could Copilot provide you with color suggestions that are easy for colorblind indivduals to distinguish?",
    "Could CoPilot provide you with color suggestions that effectively communicate how the audience should understand the data?",
    "Could CoPilot provide you with color suggestions that effectively communicate how the audience should understand the data?",
    "Have you ever tried plotting multiple graphs before?",
    "Have you ever tried plotting multiple graphs before?",
    "Did the CoPilot help you better understand how to plot multiple graphs simultaneously?",
    "Did the CoPilot help you better understand how to plot multiple graphs simultaneously?",
    "If Copilot helped you plot multiple graphs, did you feel it was helpful in displaying your data to the audience?",
    "If Copilot helped you plot multiple graphs, did you feel it was helpful in displaying your data to the audience?",
    "For your current visualization, did you ask the Copilot to improve your axes titles?",
    "For your current visualization, did you ask the Copilot to improve your axes titles?",
    "Do you feel the Copilot provided you with descriptive titles that correlate to your data?",
    "Do you feel the Copilot provided you with descriptive titles that correlate to your data?",
    "Did you ask the Copilot to adjust your axes to better display the data?",
    "Did you ask the Copilot to adjust your axes to better display the data?",
    "Do you feel Copilot was helpful in providing you information on how to adjust your axis to better display your data?",
    "Do you feel Copilot was helpful in providing you information on how to adjust your axis to better display your data?",
    "Did you ask the copilot to reposition or remove your axes labels?",
    "Did you ask the copilot to reposition or remove your axes labels?",
    "Do you feel Copilot was helpful in improving the readability of your axes labels?",
    "Do you feel Copilot was helpful in improving the readability of your axes labels?",
    "Did you ask Copilot to add or remove axes ticks?",
    "Did you ask Copilot to add or remove axes ticks?",
    "Did you ask the Copilot to add a legend to your graph?",
    "Did you ask the Copilot to add a legend to your graph?",
    "Did you previously know the code for adding a legend to your graph?",
    "Did you previously know the code for adding a legend to your graph?",
    "Did you ask copilot to move your legend",
    "Did you ask copilot to move your legend",
    "Is the location of the legend more ideal for the reader?",
    "Is the location of the legend more ideal for the reader?",
    "Did the Copilot ask you to improve a current legend?",
    "Did the Copilot ask you to improve a current legend?",
    "Please describe how copilot improved the legend.",
    "Do you think these adjustments helped you learn how to better display your data?",
    "Do you think these adjustments helped you learn how to better display your data?",
    "Will you use any of this code again?",
    "Will you use any of this code again?"
  ),
  
  option = c(
    "Yes", "No", "Yes", "No", "Yes", "No",
    "Yes", "No", "Yes", "No", "Yes", "No",
    "Yes", "No", "Yes", "No", "Yes", "No",
    "Yes", "No", "Yes", "No", "Yes", "No",
    "Yes", "No", "Yes", "No", "Yes", "No",
    "Yes", "No", "Yes", "No", "Yes", "No",
    "I learned how to move the legend",
    "Yes", "No", "Yes", "No"
  ),
  
  input_type = c(
    rep("y/n", 36),
    "text",
    rep("y/n", 4)
  ),
  
  input_id = c(
    "color_plot", "color_plot",
    "colorblind_plot", "colorblind_plot",
    "colorsuggestion_plot", "colorsuggestion_plot",
    "multiple_plot", "multiple_plot",
    "simultaneous_plot", "simultaneous_plot",
    "helpful_plot", "helpful_plot",
    "improve_axestitles", "improve_axestitles",
    "descriptive_titles", "descriptive_titles",
    "adjust_axes", "adjust_axes",
    "display_axes", "display_axes",
    "reposition_axes", "reposition_axes",
    "readability_axes", "readability_axes",
    "tick_plots", "tick_plots",
    "add_legend", "add_legend",
    "code_legend", "code_legend",
    "move_legend", "move_legend",
    "ideal_legend", "ideal_legend",
    "current_legend", "current_legend",
    "improved_legend",
    "display_data", "display_data",
    "use_again", "use_again"
  ),
  
  dependence = rep(NA, 41),
  dependence_value = rep(NA, 41),
  required = rep(FALSE, 41)
)



# 4. Create survey UI

uii <- shiny::fluidPage(
  
  shinysurveys::surveyOutput(
    df = df_currentgraphic,
    survey_title = "Improving a Current Plot Using CoPilot",
    survey_description = paste(
      "Move on to the next section of the website",
      "to follow the current visualization tutorial."
    )
  )
)


# 5. Server

server <- function(input, output, session) {
  
  # Generate a unique anonymous subject ID
  subject_id <- uuid::UUIDgenerate()
  
  # Render survey
  renderSurvey()
  observeEvent(input$submit, {
    response_data <- getSurveyData()
    response_data$subject_id <- subject_id
    
    # Save responses to Microsoft 365
    tryCatch({
      team <- get_team("Wise Lab Team")
      drv <- team$get_drive()
      general_folder <- drv$get_item("General")
      ai_github_folder <- general_folder$get_item("AI GitHub")
      
      # Load existing survey data
      rds_file <- ai_github_folder$get_item(
        "spring2024survey.rds"
      )
      
      dataoutput <- rds_file$load_rds()
      dataout2 <- dplyr::bind_rows(
        dataoutput,
        response_data
      )
      ai_github_folder$save_rds(
        object = dataout2,
        file = "spring2024survey.rds"
      )
  
      print(response_data)
      
      # Show completion message after saving succeeds
      showModal(
        modalDialog(
          title = "Survey Submitted Successfully!",
          paste(
            "Thank you for completing the second lab survey.",
            "Please continue to the Improving Computational",
            "Time Using Copilot Survey."
          ),
          footer = actionButton(
            "complete_survey",
            "Complete"
          ),
          easyClose = FALSE
        )
      )
      
    }, error = function(e) {
      
      # Display an error if saving fails
      showModal(
        modalDialog(
          title = "Submission Error",
          paste(
            "Your responses could not be saved.",
            "Please contact the researcher.",
            "Error:",
            conditionMessage(e)
          ),
          easyClose = FALSE
        )
      )
      
    })
    
  }, once = TRUE)
  
  
  # Stop the Shiny app when Complete is clicked
  observeEvent(input$complete_survey, {
    
    message("Complete button clicked!")
    
    stopApp()
    
  }, once = TRUE)
  
}



# 6. Run survey


run_survey <- function() {
  
  shiny::runApp(
    list(
      ui = uii,
      server = server
    )
  )
  
}

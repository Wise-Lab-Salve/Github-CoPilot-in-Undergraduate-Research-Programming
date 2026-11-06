##Set environment
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



##Now we are going to create a survey for a current visualization
df_currentgraphic <- data.frame(question = c("What is your participant ID?","For your current visualization did you ask CoPilot to give you new color suggestions?","For your current visualization did you ask CoPilot to give you new color suggestions?","Could Copilot provide you with color suggestions that are easy for colorblind indivduals to distinguish?","Could Copilot provide you with color suggestions that are easy for colorblind indivduals to distinguish?","Could CoPilot provide you with color suggestions that effectively communicate how the audience should understand the data?","Could CoPilot provide you with color suggestions that effectively communicate how the audience should understand the data?","Have you ever tried plotting multiple graphs before?","Have you ever tried plotting multiple graphs before?","Did the CoPilot help you better understand how to plot multiple graphs simultaneously?","Did the CoPilot help you better understand how to plot multiple graphs simultaneously?","If Copilot helped you plot multiple graphs, did you feel it was helpful in displaying your data to the audience?","If Copilot helped you plot multiple graphs, did you feel it was helpful in displaying your data to the audience?","For your current visualization, did you ask the Copilot to improve your axes titles?","For your current visualization, did you ask the Copilot to improve your axes titles?","Do you feel the Copilot provided you with descriptive titles that correlate to your data?","Do you feel the Copilot provided you with descriptive titles that correlate to your data?","Did you ask the Copilot to adjust your axes to better display the data?","Did you ask the Copilot to adjust your axes to better display the data?","Do you feel Copilot was helpful in providing you information on how to adjust your axis to better display your data?", "Do you feel Copilot was helpful in providing you information on how to adjust your axis to better display your data?", "Did you ask the copilot to reposition or remove your axes labels?","Did you ask the copilot to reposition or remove your axes labels?","Do you feel Copilot was helpful in improving the readability of your axes labels?","Do you feel Copilot was helpful in improving the readability of your axes labels?","Did you ask Copilot to add or remove axes ticks?","Did you ask Copilot to add or remove axes ticks?","Did you ask the Copilot to add a legend to your graph?","Did you ask the Copilot to add a legend to your graph?","Did you previously know the code for adding a legend to your graph?","Did you previously know the code for adding a legend to your graph?","Did you ask copilot to move your legend","Did you ask copilot to move your legend","Is the location of the legend more ideal for the reader?","Is the location of the legend more ideal for the reader?","Did you ask the Copilot to improve a current legend?","Did you ask the Copilot to improve a current legend?","Please describe how copilot improved the legend.","Do you think these adjustments helped you learn how to better display your data?","Do you think these adjustments helped you learn how to better display your data?","Will you use any of this code again?","Will you use any of this code again?"),
                                option = c("000","Yes","No","Yes", "No", "Yes", "No", "Yes","No","Yes", "No", "Yes", "No","Yes","No","Yes","No","Yes","No","Yes","No","Yes","No","Yes","No","Yes","No","Yes","No","Yes","No","Yes","No","Yes","No","Yes","No","I learned how to move the legend","Yes","No","Yes","No"),
                                input_type = c("text","y/n","y/n","y/n","y/n","y/n","y/n","y/n","y/n", "y/n","y/n","y/n","y/n", "y/n","y/n", "y/n","y/n","y/n","y/n","y/n","y/n","y/n","y/n","y/n","y/n", "y/n","y/n","y/n","y/n","y/n","y/n", "y/n","y/n", "y/n","y/n", "y/n","y/n","text","y/n","y/n","y/n","y/n"),
                                input_id = c("participant_id","color_plot","color_plot","colorblind_plot","colorblind_plot","colorsuggestion_plot","colorsuggestion_plot","multiple_plot","multiple_plot","simultaneous_plot",
                                             "simultaneous_plot","helpful_plot","helpful_plot","improve_axestitles", "improve_axestitles","descriptive_titles","descriptive_titles","adjust_axes","adjust_axes","display_axes","display_axes","reposition_axes","reposition_axes","readability_axes","readability_axes","tick_plots","tick_plots","add_legend","add_legend","code_legend","code_legend","move_legend","move_legend","ideal_legend","ideal_legend","current_legend","current_legend","improved_legend","display_data","display_data","use_again","use_again"),
                                dependence = rep(NA, 42),
                                dependence_value = rep(NA, 42),
                                required = rep(F, 42))
uii <- shiny::fluidPage(
  shinysurveys::surveyOutput(df = df_currentgraphic,
                             survey_title = "Improving a Current Plot Using CoPilot",
                             survey_description = "Move on to the next section of the website to follow the current visualization tutorial"),
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
    
    set_progress(100, "Survey complete.")
      showModal(modalDialog(
      title = "Congrats, you completed your second Lab coPilot survey!",
      "Please Continue by taking the Improving Computational Time Using Copilot Survey.",
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
  shiny::runApp(list(ui = uii, server = server))
}



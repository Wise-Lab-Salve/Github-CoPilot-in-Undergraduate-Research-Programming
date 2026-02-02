# Creating a New Data Visualization with Assistance from github coPilot

In this activity, you’ll use your own previously written code to explore how GitHub Copilot can assist in creating a completely new method of visualizing or plotting your data.

1) Please select a current data visualization or plot that you have developed during your research program. You’ll use the code for this plot as the basis for generating a new or improved version with Copilot’s help. 

2) If you have a script file (e.g., .py, .R, or .ipynb), drag and drop it into the center panel of Visual Studio Code. You can now copy sections of your code into the VS Code coPilot chat box to generate help or assistance. 

3) Copy the section of your code that generates the plot into the Copilot chat box. Ask Copilot to help you create a novel visualization based on your original.

After reviewing Copilot’s suggestions, navigate to our github host
https://github.com/jfwise/IntrotoGithub
Download the files in DownloadScripts folder
The files should be saved in your Downloads folder (or wherever your browser saves downloaded files).

Open R or RStudio and check your current working directory. Run the following command:

```r
getwd()
```
This will show the folder where R is currently looking for files. For example: "/Users/yourname/Documents"

Move the downloaded script.R file from your Downloads folder to the working directory shown in the previous step.

Now when you run the command source() throughout the tutorial you should be able to see our quizzes.

Run the code below to complete a short survey about your experience and the outcome. You may get a request from Salve to use AzureR, please enter your Salve user name. 

```r
# Source the R script containing the survey
source("CoPilotNewVisualizationSurvey.r")

# Run the survey
run_survey()
```

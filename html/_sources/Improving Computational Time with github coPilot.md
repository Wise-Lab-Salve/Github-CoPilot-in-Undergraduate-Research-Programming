# Improving Computational Time with Assistance from github coPilot

In this activity, you’ll use your own previously written code to explore how GitHub coPilot can assist in attempting to speed up the time it takes to run the code (computational time).

1) Ideally select a loop or function that you have developed during your research program that takes noticeable time to run. You’ll use the code for this as the basis for implementing system.time() in R or time module in python to determine the length it takes for your system to run the code. 

2) If you have a script file (e.g., .py, .R, or .ipynb), drag and drop it into the center panel of Visual Studio Code. You can now copy sections of your code into the VS Code coPilot chat box to generate help or assistance.


3) After selecting your code that has intensive computational time, place your code block within the function for your programming language and run the code

In R: 
system.time({
  "Your code block here"
})

In Python:

import time

start_time = time.time()

"Your code block here"

end_time = time.time()
print(f"Execution time: {end_time - start_time:.4f} seconds")

5) Copy the section of code and ask coPilot to help optimize the function or loop to reduce computational time.

After reviewing Copilot’s suggestions and comparing the computational time suggested improvements, click the link below to complete a short survey about your experience and the outcome.


```r
# Source the R script containing the survey
source("CoPilotComputationalTimeSurvey.R")

# Run the survey
run_survey()
```

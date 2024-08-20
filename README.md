# Description

This repository demonstrates a modelling project in R which exhibits modularity and reusability. This was described during a presentation on 7 August 2024 and was recorded. The [slides](Slides.pdf) describing this code can be found in this repository also.

The top-level script you would use is [runExperiments.R](runExperiments.R) which pulls in the other scripts. Each analysis (including verification and validation) could be in its own run\* script. This decoupling allows you to free up your mind while coding so you can focus more on higher level questions relating to the actual modelling. It also prevents you from having to save the same problem over and over (eg, plotting model outputs such as population, cases, deaths, etc but also re-verifying your model when you make changes. You can just re-run your runVerification.R script).

Here is a brief description of the code files in this repository:

-   [packages.R](packages.R) - Loads all necessary packages for the project in one place.
-   [model.R](model.R) - The actual model rates function which should be passed to `ode(func=)`.
-   [runModel.R](runModel.R) - Functions to run the model and get outputs in a useful format. Includes functions to get parameters and initial conditions.
-   [plots.R](plots.R) - Functions for any plots of model outputs which are useful for this project.
-   [runExperiments.R](runExperiments.R) - The top-level script which runs the model and plots the outputs for some set of experiments.

Note that most of these files just expose functions. Only the runExperiments script actually runs anything. This is a good way to keep your code modular and reusable.

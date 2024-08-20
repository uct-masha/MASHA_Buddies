source("packages.R")
source("plots.R")
source("model.R")
source("runModel.R")

# Load the data
tbCases <- readxl::read_excel("dataCases.xlsx") |>
  select(Time, Cases)

# Run the model
mo <- runModel(startyear = 1998, numyears = 2) |>
  # Throw away the warmup 1998-2000
  filter(Year>=2000)

mo <- runModel(startyear = 1998, numyears = 2) |>
  # Throw away the warmup 1998-2000
  filter(Year>=2000)

plotPop(mo)



plotHumanCompartments(mo)



plotTreatment(mo, tbCases)


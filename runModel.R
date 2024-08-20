modelParameters <- function(isScenHSS=F, isScenOther=F, beta) {
  result <- read_excel("modelInputs.xlsx", "Parameters") |> 
    pull(Value, name=Parameter) |>
    as.list()
  # Include calibration parameter
  result$beta <- beta
  # Include scenarios
  result$isScenHSS <- isScenHSS
  result$isScenOther <- isScenOther
  result
}

modelICS <- function() {
  read_excel("modelInputs.xlsx", "InitialConditions") |>
    pull(InitialValue, name=Compartment)
}

postproc <- function(hm, startyear) {
  # Given a raw model output, post-process it to a useful tibble
  hm |>
    as.data.frame() |>
    as_tibble() |>
    filter(time!=last(time)) |>
    mutate(P = S+E+A+C+Ctp+Ctc+Cto+Sev+Tp+Tc+To+H+R,
           Inc = c(0, diff(CInc)),
           Trt = c(0, diff(Ctrt))) |>
    pivot_longer(names_to = "variable", cols = !time) |>
    # Aggregate to annual values
    mutate(Year=floor(time)) |>
    summarise(valueMean=mean(value),valueSum=sum(value), .by=c(variable,Year)) |>
    mutate(value=if_else(variable%in%c("Inc","Trt"),valueSum,valueMean)) |>
    select(variable, Year, value)
}

runModel <- function(startyear, numyears, beta) {
  # the model is in days
  times <- seq(0, numyears*365, by=1)
  hm <- ode(times=times,
            y=modelICS(),
            func=seirs,
            parms=modelParameters(beta=beta))
  # convert time to years
  hm[,"time"] <- hm[,"time"]/365+startyear
  # post processing of the model
  postproc(hm, startyear)
}
#Population check
plotPop <- function(mo) {
  mo |>
    filter(variable %in% c("P")) |> 
    ggplot() +
    geom_line(aes(x = Year, y=value))+
    theme_minimal() +
    labs(title = "Population", y =("population"))
}

plotHumanCompartments <- function(mo) {
  # df1 %>% 
  #   pull(variable) %>% 
  #   unique() %>% 
  #   dput()  # TIMESAVER :-)
  
  humComps <- c("S", "E", "A",
                "C", "Ctp", "Ctc", "Cto",
                "Sev",
                "Tp", "Tc", "To",
                "H", "R")
  mo |>
    filter(variable %in% humComps) %>% 
    ggplot() +
    geom_line(aes(x = Year, y=value, colour = as_factor(variable))) +
    theme_minimal() +
    labs(title = "Human Compartments", y ="Population (annual mean)", colour="Compartment")
}

# General Plot
plotTreatment <- function(mo, tbCases) {
  mo |>
    filter(variable=="Trt") |>
    ggplot() +
    geom_col(aes(x=Year, y=value), alpha=0.5) +
    geom_point(data=tbCases, mapping = aes(x=Time, y=Cases), colour="red", shape=18, size=2) +
    theme_minimal() +
    labs(title="Treatment", y="People Treated", x="Year",
         caption="Red dots are observed data, bars are modelled estimates.") +
    theme(legend.position="none")
}

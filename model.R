# Define dynamic Human-static Vector model ####

# Definitions ####
# S: Susceptible 
# E: Exposed 
# A: Asymptomatic infections
# C: Clinical infections that will never be treated 
# Ctp: Clinical infections destined to be treated in the PUBLIC sector
# Ctc: Clinical infections destined to be treated by CHW
# Cto: Clinical infections destined to be treated in Other avenues (not public/chw)
# Sev: Severe untreated infections
# Tp: Clinical infections under treatment in the PUBLIC sector 
# Tc: Clinical infections under treatment with CHW
# To: Clinical infections under treatment in Other avenues (not public/chw)
# H: Severe infections under treatment in HOSPITAL
# R: Removed (temporarily immune)

seirs <- function(t, x, parms)  {
  with(as.list(c(parms, x)), {
    P = S+E+A+C+Ctp+Ctc+Cto+Sev+Tp+Tc+To+H+R
    m = M/P
    Infectious = C+Ctp+Ctc+Cto+Sev+zeta_a*A+zeta_t*(Tp+Tc+To) #Infectious contribution to the population
    lambda = (a^2*b*c*m*Infectious/P)/(a*c*Infectious/P+mu_m)*(gamma_m/(gamma_m+mu_m))
    if (isScenHSS) {
      # Better health system strengthening in public sector and community
      # 13% more likely to receive treatment and 2% more likely to get tested:
      ptreatp <- min(1, 1.13*ptreatp)
      ptestp <- min(1, 1.02*ptestp)
      ptreatc <- min(1, 1.13*ptreatc)
      ptestc <- min(1, 1.02*ptestc)
    }
    if (isScenOther) {
      # TODO: Implement this
    }
    ptrt_p = pseekp*ptestp*psensp*ptreatp
    ptrt_c = pseekc*ptestc*psensc*ptreatc
    ptrt_o = pseeko*ptesto*psenso*ptreato
    ptrt = ptrt_p+ptrt_c+ptrt_o
    
    dS = mu_h*P -lambda*S + rho*R - mu_h*S
    dE = lambda*S - (gamma_h + mu_h)*E
    dA = pa*gamma_h*E + omega*C - (delta + mu_h)*A
    dC = (1-pa)*(1-ptrt)*gamma_h*E +  epsilon*Sev - (omega + nu + mu_h)*C
    dCtp = (1-pa)*ptrt_p*gamma_h*E - (taup+ mu_h)*Ctp
    dCtc = (1-pa)*ptrt_c*gamma_h*E - (tauc+ mu_h)*Ctc
    dCto = (1-pa)*ptrt_o*gamma_h*E - (tauo+ mu_h)*Cto
    dSev = nu*C - (epsilon + tau_sev + mu_sev1 + mu_h)*Sev
    dTp = taup*Ctp - (r_p+mu_h)*Tp
    dTc = tauc*Ctc - (r_c+mu_h)*Tc
    dTo = tauo*Cto - (r_o+mu_h)*To
    dH = tau_sev*Sev - (r_sev+ mu_sev2 + mu_h)*H
    dR = r_p*Tp+r_c*Tc+r_o*To + r_sev*H + delta*A  - (rho + mu_h)*R
    
    #Counters
    dCInc = lambda*S
    dCtrt = taup*Ctp + tauc*Ctc + tauo*Cto + tau_sev*Sev
    dCtrt_cnt = taup*Ctp + tauc*Ctc + tau_sev*Sev
    
    output <- c(dS, dE, dA, dC,dCtp, dCtc, dCto, dSev, dTp, dTc, dTo, dH, dR, dCInc, dCtrt, dCtrt_cnt)
    list(output)
  })
}
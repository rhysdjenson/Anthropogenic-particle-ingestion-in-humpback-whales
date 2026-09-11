library (TruncatedNormal)
library(boot)

#### This model converts the number of AP per gram of feces (dry) to the number of AP per gram prey (wet). 
#### This value is multiplied by estimated mass of food ingested daily.
#### For whale eating 30% juvenile herring and 70% krill **** Based on whole-genome sequencing.

set.seed(100)
# simulate dry weight percent of krill and herring
herringdw <- rnorm(1000, mean = 20, sd = 2.4)
krilldw <- rnorm(10000, mean = 18.97, sd = 1.42)
# weighted sampling (70% krill, 30% herring)
combined <- c(
  sample(krilldw, size = 70, replace = TRUE),
  sample(herringdw, size = 30, replace = TRUE)
)
mean.dwprey <- mean(combined)
sd.dwprey   <- sd(combined)

# Manganese values (ppm) for freeze-dried feces and prey.
FecalMn_Avg <- 32.54
FecalMn_SD <- 2.79894996
KrillMn_Avg <- 5.19
KrillMn_SD <- 1.466162213
HerringMn_Avg <- 1.61

#Weighted average (70% krill, 30% herring) for manganese values between both prey types: 
#Total mean
totalpreyMn_Avg <- 0.7 * KrillMn_Avg + 0.3 * HerringMn_Avg
# total variance
totalpreyMn_Var <- 0.7*(KrillMn_SD^2 + (KrillMn_Avg - totalpreyMn_Avg)^2) +
  0.3*(0 + (HerringMn_Avg - totalpreyMn_Avg)^2)
#Total SD
totalpreyMn_SD <- sqrt(totalpreyMn_Var)

# Mean and SD for the ratio of feces to prey (d.w.)
ratio_with_error <- function(mean_x, sd_x, mean_y, sd_y) {
  mean_z <- mean_x / mean_y
  rel_error <- sqrt(
    (sd_x / mean_x)^2 +
      (sd_y / mean_y)^2
  )
  sd_z <- mean_z * rel_error
  
  list(mean = mean_z, sd = sd_z)
}
result<-ratio_with_error(totalpreyMn_Avg, totalpreyMn_SD,FecalMn_Avg, FecalMn_SD)
dryratio_fecesprey_avg<-result$mean 
dryratio_fecesprey_sd<-result$sd 

# Conversion ratio (equation 3)
fecalAPdry <- rtnorm(1000, mu=25.11, sd=17.32165, lb=10, ub=75)
PreyFecesRatio <- rtnorm(1000, mu=dryratio_fecesprey_avg, sd=dryratio_fecesprey_sd, lb=0, ub=Inf)
APpergrampreywet<-(fecalAPdry*PreyFecesRatio)*(rnorm(1000, mean = mean.dwprey, sd = sd.dwprey)/100)
mean(APpergrampreywet)

# Next, estimate consumption. Formula From Witteveen et al., 2006
m<-30000
K <- 0.88*0.3 + 0.74*0.7 
E<- 192*(m^0.75)
I <- (E/K)*(1/1000)
r <- I*1000

((r/1000)/m)*100 # Whales feeding on 70% euphausids and 30% herring eat 1.87% bw per day


APingestedperday<-r*APpergrampreywet
mean(APingestedperday)
median(APingestedperday)
hist(APingestedperday)
quantile.95APingestedperday<-quantile(APingestedperday, probs = c(0.05, 0.95))


#Bootstrap resampling (n = 1000) to calculate 95% CI 

boot_mean <- function(data, i) mean(data[i], na.rm = TRUE)
boot_res <- boot(APingestedperday, boot_mean, R = 1000)
bootresult<-boot.ci(boot_res, type = "perc")
conf<-bootresult$percent
ci_lower <- conf[1, ncol(conf)-1]
ci_upper <- conf[1, ncol(conf)]

# 30,000 kg HB feeding on 70% krill and 30% herring may ingest mean 435709.7 AP a day (95% CI, 417826.1 - 455033).

# Mass ingested estimate
# Average AP isolated was 1001.5 μm long and 50.6 μm wide
# Microfibers ~ cylindrical volume
# Density of cellulose = 1.5 g/cm³
# Based on AP density and volume, average particle mass is 0.00000302 g

meanmassingested<-(3.02*10^-6)*mean(APingestedperday) # mean = 1.32 g/day
(3.02*10^-6)*ci_lower #5% = 1.26   g/day
(3.02*10^-6)*ci_upper #95% =  1.37 g/day

# ~ mean 1.315843 grams of APs per day (95CI:1.261835 - 1.3742)

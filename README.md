# README 

**Purpose:**
R code used to estimate daily anthropogenic particle (AP) ingestion by humpback whales from fecal AP concentrations and prey consumption.

**Key analyses:**

* Simulates prey dry-weight composition for a diet of 70% krill and 30% herring.
* Estimates the feces-to-prey dry-weight conversion ratio using manganese concentrations.
* Converts AP concentrations in dry feces to APs per gram of wet prey.
* Estimates daily prey consumption using whale body mass and energetic requirements.
* Estimates daily AP ingestion and associated 95% confidence intervals using bootstrap resampling.
* Converts AP count to estimated AP mass (g/day) using particle dimensions and cellulose density.

**Main assumptions:**

* Whale body mass = 30,000 kg.
* Diet composition = 70% krill and 30% herring.
* AP concentration is simulated using a truncated normal distribution.
* Mean AP mass = 3.02 × 10⁻⁶ g per particle.

**Software:**
R; packages `TruncatedNormal` and `boot`.

**Key output:**
Estimated mean AP ingestion count = **~435,710 AP/day** (95% CI: **417,826 - 455,033 AP/day**). 
Estimated mean AP ingestion mass = **~1.32 g/day** (95% CI: **1.26–1.37 g/day**).

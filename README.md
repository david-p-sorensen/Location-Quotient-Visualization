# [Location Quotient Visualization](https://david-p-sorensen.shinyapps.io/location-quotient-visualization/)

## Project Overview
### Background

A location quotient (LQ) is a fundamental analytical tool in economic geography that measures the relative concentration of industries across different geographical areas. By comparing local industry concentrations to national averages, LQs help identify regional specializations and industrial clusters. This metric is particularly valuable because it normalizes for both the size of the local economy and the size of the industry nationally, enabling meaningful comparisons across regions of different sizes.

The interpretation of LQs is straightforward:
- An LQ of 1.0 indicates that the local area has the same proportion of employment in an industry as the nation
- An LQ greater than 1.0 suggests a higher concentration locally than the national average
- An LQ less than 1.0 indicates a lower concentration locally than the national average

The formula for calculating location quotients consists of two primary components that are then divided:

**Local Concentration** = (Local Industry Employment) / (Local Total Employment)  
**National Concentration** = (National Industry Employment) / (National Total Employment)  
**Location Quotient** = Local Concentration / National Concentration

For example, consider Detroit's manufacturing industry:
```
                (Detroit Manufacturing Jobs)
                ---------------------------
                (Total Detroit Jobs)
LQ = --------------------------------------------
                (US Manufacturing Jobs)
                ----------------------
                (Total US Jobs)
```

Using hypothetical numbers, if Detroit has 100,000 manufacturing jobs out of 500,000 total jobs (20% local concentration), while nationally there are 12 million manufacturing jobs out of 150 million total jobs (8% national concentration), Detroit's manufacturing LQ would be:

```
LQ = (20% / 8%) = 2.5
```

This LQ of 2.5 indicates that manufacturing employment is two and a half times more concentrated in Detroit than it is nationally. Such a high LQ might suggest the presence of a manufacturing cluster, specialized workforce, or historical industrial development in the region.

Through this normalized comparison, location quotients provide a standardized way to:
1. Identify regional industrial specializations
2. Compare industry concentrations across different geographic areas
3. Track changes in regional industrial composition over time
4. Understand relative strengths and weaknesses in regional economies
### Motivation

This project reimagines the Bureau of Labor Statistics' [Location Quotient Visualization](https://data.bls.gov/maps/cew/US), which maps industry concentration across all 50 states. While the BLS collects their data through comprehensive employer surveys and administrative records, this project takes an alternative approach by using LinkedIn job postings as a proxy for industry employment.

The core hypothesis is that job postings on LinkedIn can indicate industry employment patterns across regions. This approach has key statistical advantages:

1. **Industry Platform Bias**: Different industries use LinkedIn at different rates
   - Location quotients compare local-to-national ratios, which automatically cancels out any industry-specific LinkedIn usage bias
   - For example, even if tech companies post 80% of their jobs on LinkedIn while manufacturing posts only 20%, this affects all states equally and doesn't distort relative concentrations

2. **Geographic Platform Bias**: LinkedIn adoption varies by state
   - Each state's industry concentration is normalized by its total job postings, eliminating state-level variations in LinkedIn usage
   - For example, if California posts 50% of all jobs on LinkedIn while Montana posts only 10%, this difference disappears when calculating the proportion of jobs within each state

This method shows how alternative data sources can effectively approximate traditional economic metrics while maintaining statistical validity through location quotients' self-normalizing properties.
### Live Application
The application is hosted at https://david-p-sorensen.shinyapps.io/location-quotient-visualization Mirroring the functionality of the BLS Location Quotient Mapper, this interactive visualization displays industry concentration heat maps across U.S. Users can select from 11 major industry sectors and observe how employment is distributed geographically through an intuitive color-coded interface. Hovering over states reveals detailed metrics including local and national concentration ratios, total employment figures, and precise location quotient calculations.

## Data Acquisition & Preprocessing
### Data Collection
I originally wanted to webscrape the job postings from a job board myself, however I quickly learned the difficulties and potential legal issues with this, so I reluctantly used a dataset somebody else curated from [kaggle](https://www.kaggle.com/datasets/arshkon/linkedin-job-postings/data). This dataset contains data on over 124,000 job postings and spans from 2023 to 2024.

### Data Processing & Classification
The project uses OpenAI's GPT-3.5 Turbo to classify LinkedIn job postings by industry and ownership. I based classifications solely on job titles and company names after filtering out:

- Remote jobs
- Jobs with only "United States" as location
- Jobs located in D.C. and other non-state areas
- "Public Administration" industry jobs (to match BLS visualization)

The classification process categorized each posting into:

- 11 major industry sectors aligned with BLS classifications
- 4 ownership types: federal, state, local, and private

This approach allows for standardized comparison with official BLS data while accommodating the limitations of LinkedIn job posting information.

### Data Transformation
The raw job posting data underwent several transformation steps:

1. **Job Location Assignment:**
    - Used provided FIPS codes to assign jobs to their respective states
    - For jobs with missing FIPS codes, employed GPT-3.5 Turbo to determine state location
    - Manually assigned remaining unclassified locations using Excel filtering

2. **State-level Aggregation:**
    - Compiled job counts by industry and ownership type for each state
3. **Concentration Calculations:**
    - Computed local concentration ratios within each state
    - Established national concentration benchmarks
    - Calculated location quotients to compare state vs. national distributions
  
This process ensured accurate geographic representation of all job postings before performing comparative analysis.

## Data Visualization
### Technical Implementation
The visualization is built using:
- R Shiny for the web application framework
- Plotly for interactive choropleth mapping
- Custom CSS for styling and layout
- Dynamic tooltips for detailed state metrics

### Design Decisions
- Implemented a blue-to-orange color gradient matching BLS conventions
- Created an intuitive dropdown for industry selection
- Added interactive hover effects showing detailed state metrics
- Included industry-specific thresholds for color scaling

## Deployment
### Technology Stack
The application uses the following key components:
```r
library(shiny)
library(plotly)
library(dplyr)
library(readxl)
```

### Hosting
- Deployed on shinyapps.io free tier
- Configured for optimal performance within platform constraints
- Handles multiple concurrent users

## Limitations & Future Work
### Current Limitations
- LinkedIn data may not perfectly represent all industry employment
- Limited to 13 major industry sectors
- Some states have sparse data in certain industries
- Free tier hosting limits on shinyapps.io (25 active hours/month)

### Future Improvements
- Expand to more granular industry classifications
- Add time-series analysis capabilities
- Implement ownership type filtering
- Add comparative analysis tools
- Enhance mobile responsiveness

## Technical Details
### Local Setup
1. Clone the repository
2. Install required R packages:
```r
install.packages(c("shiny", "plotly", "dplyr", "readxl"))
```
3. Set up your openai API key if rerunning classifications
4. Run the Shiny application:
```r
shiny::runApp()
```

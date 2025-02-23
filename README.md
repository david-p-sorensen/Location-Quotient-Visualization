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

The core hypothesis is that the distribution of job postings on LinkedIn can serve as an indicator of industry employment patterns across different regions. This methodology introduces some interesting statistical properties:

1. **Industry Platform Bias**: Different industries may have varying levels of presence on LinkedIn
   - However, since location quotients compare local-to-national ratios, any industry-level bias in LinkedIn usage is normalized out of the final calculation
   - For example, if tech companies post 80% of their jobs on LinkedIn while manufacturing posts only 20%, this bias affects all states equally and doesn't impact the relative concentrations

2. **Geographic Platform Bias**: Different states may have varying levels of LinkedIn adoption
   - Similarly, since each state's industry concentration is normalized by its total job postings, state-level variations in LinkedIn usage don't affect the final location quotients
   - If California posts 50% of all jobs on LinkedIn while Montana posts only 10%, this bias is eliminated when calculating the proportion of jobs within each state

This approach demonstrates how alternative data sources can be used to approximate traditional economic metrics, while maintaining statistical validity through the self-normalizing properties of location quotients.
### Live Application
The application is hosted at https://david-p-sorensen.shinyapps.io/location-quotient-visualization Mirroring the functionality of the BLS Location Quotient Mapper, this interactive visualization displays industry concentration heat maps across U.S. Users can select from 13 major industry sectors and observe how employment is distributed geographically through an intuitive color-coded interface. Hovering over states reveals detailed metrics including local and national concentration ratios, total employment figures, and precise location quotient calculations.

## Data Collection
### Data Sources
I originally wanted to webscrape the job postings from a job board myself, however I quickly learned the difficulties and potential legal issues with this, so I reluctantly used a dataset somebody else curated from [kaggle](https://www.kaggle.com/datasets/arshkon/linkedin-job-postings/data). This dataset contains data on over 124,000 job postings and spans from 2023 to 2024.

### API Implementation
The project leverages the OpenAI API (GPT-3.5 Turbo) to classify job postings into standardized industry categories and ownership types. Each job posting's description and title were processed to categorize it into:

- 13 major industry sectors aligned with BLS classifications
- 4 ownership categories (federal, state, local, and private)

## Data Processing & Cleaning
### Classification Methodology
The classification process involved two main components:

1. **Industry Classification**
   - Jobs were categorized into 13 major sectors including Manufacturing, Construction, Information, etc.
   - Used GPT-3.5 Turbo to analyze job descriptions and titles
   - Aligned classifications with standard BLS industry categories

2. **Ownership Classification**
   - Each job was categorized as federal, state, local, or private sector
   - Classification based on employer information and job descriptions
   - Multiple validation passes to ensure accuracy

### Data Transformation
The raw job posting data was transformed through several steps:

1. State-level aggregation of job counts by industry and ownership
2. Calculation of employment concentrations:
   - Local concentration ratios for each state
   - National concentration benchmarks
   - Location quotient computations
3. Data validation and outlier detection

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

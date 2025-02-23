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
- OpenAI API (GPT-3.5 Turbo) for classification
- Process for collecting and storing responses

## Data Processing & Cleaning
### Classification Methodology
- Industry classification approach
- Government ownership classification (federal, state, local, private)
- Handling edge cases

### Data Transformation
- Aggregation methods
- Calculation of employment metrics
- State-level consolidation

## Data Analysis
### Location Quotient Calculation
[Explain the LQ formula and its significance]

### Methodology
- State-level aggregation process
- Industry concentration calculations
- Statistical considerations

### Key Findings
[Any interesting patterns or insights discovered]

## Data Visualization
### Technical Implementation
- R Shiny framework
- Plotly for mapping
- Interactive features

### Design Decisions
- Color scheme selection
- UI/UX considerations
- Interactive elements

## Deployment
### Technology Stack
- R Shiny
- Additional libraries/dependencies

### Hosting
- Deployment platform (shinyapps.io)
- Configuration details

## Limitations & Future Work
### Current Limitations
- Data coverage
- Processing constraints
- [Other limitations]

### Future Improvements
- Additional features
- Potential enhancements
- [Future work ideas]

## Technical Details
### Dependencies
```r
[List of required R packages]
```

### Local Setup
1. Clone the repository
2. Install required packages
3. [Additional setup steps]

### Usage Instructions
[How to use the application, including any filtering or interactive features]

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
[Explain why you chose this project and what problem it solves]

### Live Application
The application is hosted at [insert URL]. This visualization allows users to explore industry concentration across different states using an interactive map interface.

## Data Collection
### Data Sources
- LinkedIn job postings data
- [Any other data sources]

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

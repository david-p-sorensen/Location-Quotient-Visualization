# 🔗 [**Click here to view the interactive visualization**](https://david-p-sorensen.shinyapps.io/location-quotient-visualization/) 🔗

### Reimagining Regional Economic Analysis: A Location Quotient Visualization With Alternative Data Sources

___

### Introduction

Economic geography provides critical insights into how industries cluster across regions, revealing patterns that shape both local prosperity and national competitiveness. Understanding these spatial distributions helps policymakers identify regional strengths, economists analyze labor markets, and businesses make strategic location decisions. This project develops an innovative approach to measuring and visualizing industrial concentration across the United States by leveraging LinkedIn job posting data as an alternative to traditional government surveys.

The centerpiece of this analysis is the **location quotient (LQ)**, a fundamental metric in regional economics that measures the relative concentration of industries across different geographical areas. By comparing local industry concentrations to national averages, location quotients reveal regional specializations and industrial clusters while normalizing for differences in regional economic size. This normalization enables meaningful comparisons between states as diverse as California and Wyoming, making it an essential tool for economic analysis.

### Theoretical Foundation and Methodology

A location quotient represents the ratio of an industry's local share of employment to its national share. Mathematically, it compares two proportions:

```
        (Local Industry Employment / Local Total Employment)
LQ = ──────────────────────────────────────────────────────────
     (National Industry Employment / National Total Employment)
```

The interpretation of location quotients follows a straightforward framework:

- **LQ = 1.0** — the local area mirrors the national proportion of employment in that industry
- **LQ > 1.0** — regional specialization, with the magnitude indicating the degree of concentration
- **LQ < 1.0** — underrepresentation relative to the national average

#### Illustrative Example: New York's Financial Sector

To illustrate this concept using the application, consider New York's financial activities sector. The visualization reveals that New York employs 837 workers in financial activities out of 7,027 total jobs captured in the dataset (11.91% local concentration). Nationally, the financial sector represents 6,566 jobs out of 106,054 total positions (6.19% concentration). This yields a location quotient of:

```
LQ = 11.91% / 6.19% = 1.92
```

This result confirms New York's well-documented status as a financial hub with nearly double the national concentration of financial employment.

### Data Innovation and Statistical Validity

This project reimagines the Bureau of Labor Statistics' traditional [Location Quotient Mapper](https://data.bls.gov/maps/cew/US) by substituting comprehensive employer surveys with publicly available LinkedIn job posting data. While the BLS collects data through mandatory employer reporting and administrative records, this alternative approach demonstrates how modern digital platforms can serve as valuable proxies for economic indicators.

The validity of using LinkedIn data for location quotient analysis rests on two critical statistical properties that address potential biases:

#### 1. Industry-Specific Platform Bias Cancels Out

The fact that technology companies might post 80% of openings on LinkedIn while manufacturing firms post only 20% affects all states equally. Since location quotients compare ratios rather than absolute values, this systematic bias cancels out mathematically. The relative concentration of tech jobs in California versus Montana remains accurate regardless of the technology industry's overall LinkedIn usage rate.

#### 2. Geographic Variations Are Neutralized

Geographic variations in LinkedIn adoption are neutralized through the location quotient's normalization process. Each state's industry concentration is calculated as a proportion of its total job postings, automatically adjusting for state-level differences in platform usage. Whether California posts significantly more jobs on LinkedIn than rural states becomes irrelevant when examining the proportion of jobs within each state's economy.

### Implementation and Technical Architecture

#### Data Acquisition

The data acquisition process began with a curated [dataset of over 124,000 LinkedIn job postings](https://www.kaggle.com/datasets/arshkon/linkedin-job-postings/data) spanning 2023–2024, obtained from Kaggle to avoid the technical and legal complexities of direct web scraping.

#### Data Preprocessing

The preprocessing pipeline filtered out:

- Remote positions
- Jobs listed only as "United States" without specific state locations
- Positions in D.C. and other non-state territories
- Public administration roles (to maintain consistency with BLS classifications)

#### AI-Powered Classification

The most innovative aspect of the data processing involved using **OpenAI's GPT-3.5 Turbo** model for automated industry classification. Each job posting was categorized into one of eleven major industry sectors aligned with BLS standards, based solely on job titles and company names. This natural language processing approach enabled rapid classification of thousands of postings while maintaining consistency with established industry taxonomies. The model also determined ownership types — federal, state, local, or private — providing additional analytical dimensions.

#### Geographic Assignment

Geographic assignment presented unique challenges that required a multi-tiered approach:

1. **Primary determination** — used provided FIPS codes where available
2. **GPT-assisted identification** — for ambiguous cases without FIPS codes
3. **Manual review** — for the remaining unclassified positions

This hybrid methodology balanced automation efficiency with accuracy requirements, ensuring complete geographic coverage of the dataset.

#### State-Level Aggregation and Calculations

After classification and geographic assignment, the pipeline:

1. Compiled job counts by industry and ownership type for each state
2. Computed local concentration ratios within each state
3. Established national concentration benchmarks
4. Calculated location quotients to compare state vs. national distributions

#### Visualization Layer

The visualization layer employs **R Shiny** for the web application framework, creating an interactive platform that mirrors the functionality of the official BLS tool. **Plotly** generates responsive choropleth maps with dynamic color scaling that adjusts to industry-specific concentration ranges. Custom CSS styling ensures professional presentation while maintaining intuitive navigation through dropdown menus for industry selection. Interactive tooltips reveal detailed metrics on hover, including local and national employment figures, concentration ratios, and calculated location quotients.

Design decisions include:

- A blue-to-orange color gradient matching BLS conventions
- An intuitive dropdown for industry selection
- Interactive hover effects displaying detailed state metrics
- Industry-specific thresholds for color scaling

### Economic Insights and Policy Implications

The application reveals fascinating patterns in America's economic geography that align with both historical development and contemporary trends. Traditional manufacturing strongholds in the Midwest maintain elevated location quotients despite decades of deindustrialization, suggesting persistent industrial infrastructure and specialized workforce skills. Technology sector concentration along the coasts reflects the agglomeration economies that characterize knowledge industries, where proximity to talent, capital, and peer firms creates self-reinforcing clusters.

These patterns have profound implications for economic development policy. Regions with high location quotients in growing industries may benefit from policies that reinforce existing strengths, while areas seeking economic diversification might target industries with moderate quotients that could expand with appropriate support. The visualization enables policymakers to identify potential cluster development opportunities where nascent concentrations might grow into competitive advantages with strategic investment.

The methodology also demonstrates the potential for alternative data sources in economic analysis. As traditional data collection becomes increasingly expensive and time-consuming, digital platforms offer real-time insights into economic activity. While not replacing official statistics, these alternative sources can provide timely indicators between census periods and reveal emerging trends before they appear in conventional data.

### Limitations and Future Directions

#### Current Limitations

Several limitations merit consideration when interpreting results:

- **User-base skew** — LinkedIn's user base skews toward white-collar professions and technology-literate workers, potentially underrepresenting manufacturing, agriculture, and service sectors
- **Temporal coverage** — the dataset spans only recent years, preventing longitudinal analysis of structural economic changes
- **Demand vs. employment** — job postings represent labor demand rather than actual employment, though the two generally correlate strongly
- **Sparse data** — some states have limited posting volume in certain industries
- **Hosting constraints** — the shinyapps.io free tier limits the application to 25 active hours per month

#### Future Improvements

Future enhancements could address these limitations while expanding analytical capabilities:

- **Multi-platform integration** — incorporating multiple job platforms would improve sectoral coverage and reduce platform-specific bias
- **Time-series analysis** — enabling tracking of industrial evolution and identification of emerging clusters
- **Granular industry classifications** — revealing specialized niches within broader sector categories
- **Ownership type filtering** — surfacing the federal/state/local/private distinctions already captured in the data
- **Comparative analysis tools** — supporting side-by-side state or industry comparisons
- **Enhanced mobile responsiveness** — improving the experience on smaller screens
- **Cross-indicator integration** — combining LQ data with wage data, patent filings, or venture capital investments to provide multidimensional views of regional economic vitality

### Conclusion

This project demonstrates how innovative data sources and modern analytical techniques can democratize economic analysis while maintaining statistical rigor. By leveraging publicly available LinkedIn data and automated classification methods, the application provides insights traditionally reserved for those with access to expensive government datasets. The location quotient methodology's inherent normalization properties ensure that platform-specific biases do not compromise analytical validity.

The convergence of economic theory, data science, and web development showcased here represents the future of applied economics. As digital platforms generate ever-richer data about economic activity, economists must develop creative approaches to harness these resources while understanding their limitations. This project contributes to that evolution by proving that alternative data sources, properly analyzed, can yield insights comparable to traditional methods while offering advantages in timeliness, cost, and accessibility.

### Technical Appendix

#### Key Technologies

- **R Shiny** — web application framework
- **Plotly** — interactive choropleth mapping
- **dplyr** — data manipulation
- **readxl** — data ingestion
- **OpenAI GPT-3.5 Turbo** — industry and ownership classification
- **Custom CSS** — styling and layout

#### Data Source

LinkedIn job postings — 124,000+ records spanning 2023–2024 ([Kaggle dataset](https://www.kaggle.com/datasets/arshkon/linkedin-job-postings/data))

#### Deployment

Hosted on the [Shinyapps.io](https://www.shinyapps.io/) cloud platform, configured for optimal performance within free-tier constraints and capable of handling multiple concurrent users.

#### Local Setup

1. Clone the repository
2. Install required R packages:
   ```r
   install.packages(c("shiny", "plotly", "dplyr", "readxl"))
   ```
3. Set up your OpenAI API key if rerunning classifications
4. Run the Shiny application:
   ```r
   shiny::runApp()
   ```

#### Repository

[github.com/david-p-sorensen/Location-Quotient-Visualization](https://github.com/david-p-sorensen/Location-Quotient-Visualization)

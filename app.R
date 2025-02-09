library(shiny)
library(plotly)
library(dplyr)
library(readxl)

rgb_to_hex <- function(r, g, b) {
  sprintf('#%02X%02X%02X', r, g, b)
}

custom_colors <- c(
  rgb_to_hex(50, 102, 180),
  rgb_to_hex(75, 128, 205),
  rgb_to_hex(99, 153, 220),
  rgb_to_hex(144, 185, 229),
  rgb_to_hex(190, 213, 242),
  rgb_to_hex(254, 227, 145),
  rgb_to_hex(254, 196, 79),
  rgb_to_hex(254, 153, 41),
  rgb_to_hex(236, 112, 20),
  rgb_to_hex(197, 92, 16)
)

industry_thresholds <- list(
  "All Industries" = c(1.01,1),
  "Goods-Producing" = c(2.19, 1.96, 1.45, 1.30, 1.21, 1.12, 1.04, 0.90, 0.81, 0.61, 0.18),
  "Natural Resources and Mining" = c(33.39, 3.92, 2.12, 1.23, 0.81, 0.64, 0.47, 0.27, 0.19, 0.00),
  "Construction" = c(2.51, 1.75, 1.57, 1.35, 1.17, 1.05, 0.96, 0.82, 0.64, 0.54, 0.42),
  "Manufacturing" = c(2.68, 1.88, 1.57, 1.38, 1.21, 1.03, 0.82, 0.71, 0.65, 0.49, 0.03),
  "Service-Providing" = c(1.10, 1.05, 1.02, 1.01, 1.00, 0.99, 0.98, 0.96, 0.95, 0.89, 0.86),
  "Trade, Transportation, and Utilities" = c(1.92, 1.70, 1.47, 1.40, 1.15, 1.06, 1.04, 0.99, 0.94, 0.84, 0.72),
  "Information" = c(1.82, 1.23, 0.97, 0.79, 0.75, 0.69, 0.54, 0.46, 0.38, 0.28, 0.13),
  "Financial Activities" = c(2.81, 1.26, 1.18, 1.09, 0.93, 0.88, 0.77, 0.65, 0.56, 0.52, 0.19),
  "Professional and Business Services" = c(1.25, 1.13, 1.01, 0.98, 0.91, 0.82, 0.81, 0.68, 0.59, 0.49, 0.23),
  "Education and Health Services" = c(2.35, 1.43, 1.29, 1.19, 1.10, 1.06, 0.99, 0.91, 0.87, 0.84, 0.73),
  "Leisure and Hospitality" = c(6.64, 1.67, 1.21, 1.02, 0.92, 0.86, 0.78, 0.72, 0.65, 0.59, 0.00),
  "Other Services" = c(2.75, 1.78, 1.30, 1.14, 1.08, 1.01, 0.94, 0.92, 0.79, 0.62, 0.00)
)

location_data <- read_excel("data/LQ_Dataset.xlsx") %>%
  mutate(across(c(LQ, State_Jobs, State_Total_Jobs, US_Jobs), as.numeric))

US_TOTAL_JOBS <- 106054

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
       .legend-box {
           position: absolute;
           top: 10px;
           right: 10px;
           background: white;
           padding: 10px;
           border: 1px solid #ccc;
           border-radius: 5px;
           z-index: 1000;
       }
       .legend-item {
           display: flex;
           align-items: center;
           margin: 5px 0;
       }
       .color-box {
           width: 20px;
           height: 20px;
           margin-right: 10px;
       }
   ")),
    tags$script(HTML("
     $(document).ready(function() {
       function setupPlotlyHover() {
         $('#usMap').on('plotly_hover', function(event, data) {
           Shiny.setInputValue('hovered_state', data.points[0].location);
         }).on('plotly_unhover', function() {
           Shiny.setInputValue('hovered_state', null);
         });
       }
       setTimeout(setupPlotlyHover, 500);
     });
   "))
  ),
  
  titlePanel(
    HTML('<span style="font-size: 24px;">Location Quotient Visualization | <a href="https://github.com/david-p-sorensen/Location-Quotient-Visualization">GitHub Repository</a></span>')
  ),
  
  fluidRow(
    column(3,
           selectInput("industry", "Select Industry",
                       choices = list(
                         "All Industries" = "All Industries",
                         "Goods-Producing" = "Goods-Producing",
                         "\u00A0\u00A0\u00A0\u00A0Natural Resources and Mining" = "Natural Resources and Mining",
                         "\u00A0\u00A0\u00A0\u00A0Construction" = "Construction",
                         "\u00A0\u00A0\u00A0\u00A0Manufacturing" = "Manufacturing",
                         "Service-Providing" = "Service-Providing",
                         "\u00A0\u00A0\u00A0\u00A0Trade, Transportation, and Utilities" = "Trade, Transportation, and Utilities",
                         "\u00A0\u00A0\u00A0\u00A0Information" = "Information",
                         "\u00A0\u00A0\u00A0\u00A0Financial Activities" = "Financial Activities",
                         "\u00A0\u00A0\u00A0\u00A0Professional and Business Services" = "Professional and Business Services",
                         "\u00A0\u00A0\u00A0\u00A0Education and Health Services" = "Education and Health Services",
                         "\u00A0\u00A0\u00A0\u00A0Leisure and Hospitality" = "Leisure and Hospitality",
                         "Other Services" = "Other Services"
                       ),
                       selected = "Goods-Producing"),
           uiOutput("state_details")
    ),
    column(9,
           div(class = "legend-box",
               h4("Color Thresholds", style = "font-size: 13px; font-weight: bold;"),
               uiOutput("color_thresholds")
           ),
           plotlyOutput("usMap", height = "600px")
    )
  )
)

server <- function(input, output, session) {
  us_states_map <- reactive({
    filtered_data <- location_data %>%
      filter(Industry == input$industry,
             Ownership == "All Ownerships",
             State != "DC")
    
    if (input$industry == "All Industries") {
      return(filtered_data %>%
               mutate(state = State,
                      state_name = State_Name,
                      z_value = 1,
                      color_category = 1))
    }
    
    if (any(filtered_data$LQ == 0)) {
      non_zero_breaks <- quantile(filtered_data$LQ[filtered_data$LQ != 0],
                                  probs = seq(0, 1, by = 0.1),
                                  na.rm = TRUE)
      return(filtered_data %>%
               mutate(state = State,
                      state_name = State_Name,
                      color_category = if_else(LQ == 0, "1",
                                               as.character(cut(LQ,
                                                                breaks = non_zero_breaks,
                                                                labels = 1:10,
                                                                include.lowest = TRUE)))))
    }
    
    quantile_breaks <- quantile(filtered_data$LQ, 
                                probs = seq(0, 1, by = 0.1),
                                na.rm = TRUE)
    
    # Add print statement for breaks
    print("Quintile Breaks:")
    # Add print statement for breaks
    print(paste("Quintile Breaks:", 
                paste(sprintf("%.2f", rev(quantile_breaks)), collapse = ", ")))
    
    filtered_data %>%
      mutate(state = State,
             state_name = State_Name,
             color_category = cut(LQ, 
                                  breaks = quantile_breaks,
                                  labels = c(1:10),
                                  include.lowest = TRUE))
  })
  
  output$usMap <- renderPlotly({
    lq_data <- us_states_map()
    
    colorscale <- if(input$industry == "All Industries") {
      list(list(0, rgb_to_hex(50, 102, 180)),
           list(1, rgb_to_hex(50, 102, 180)))
    } else {
      list(list(0, custom_colors[10]),
           list(0.1111, custom_colors[9]),
           list(0.2222, custom_colors[8]),
           list(0.3333, custom_colors[7]),
           list(0.4444, custom_colors[6]),
           list(0.5555, custom_colors[5]),
           list(0.6666, custom_colors[4]),
           list(0.7777, custom_colors[3]),
           list(0.8888, custom_colors[2]),
           list(1, custom_colors[1]))
    }
    
    plot_ly(
      data = lq_data,
      type = "choropleth",
      locations = ~state,
      z = ~as.numeric(color_category),
      locationmode = "USA-states",
      marker = list(line = list(color = "white", width = 1)),
      colorscale = colorscale,
      showscale = FALSE,
      text = ~paste0(state_name, ": ", sprintf("%.2f", LQ)),
      hoverinfo = "text"
    ) %>%
      config(displayModeBar = FALSE) %>%
      layout(
        title = paste(input$industry, "Location Quotient by State"),
        geo = list(
          scope = "usa",
          projection = list(type = "albers usa"),
          showlakes = FALSE,
          showframe = FALSE,
          lonaxis = list(range = c(-180, -60)),
          lataxis = list(range = c(20, 60))
        ),
        dragmode = FALSE,
        margin = list(r = 120)
      )
  })
  
  output$state_details <- renderUI({
    req(input$hovered_state)
    
    state_details <- location_data %>%
      filter(State == toupper(input$hovered_state),
             Industry == input$industry,
             Ownership == "All Ownerships")
    
    local_concentration <- (state_details$State_Jobs / state_details$State_Total_Jobs) * 100
    national_concentration <- (state_details$US_Jobs / US_TOTAL_JOBS) * 100
    
    div(
      style = "background-color: #f0f0f0; padding: 15px; border-radius: 5px; margin-top: 10px;",
      h4(paste(state_details$State_Name)),
      p(paste("Location Quotient:", round(state_details$LQ, 2))),
      p(paste("State Jobs in Industry:", format(state_details$State_Jobs, big.mark = ","))),
      p(paste("Total State Jobs:", format(state_details$State_Total_Jobs, big.mark = ","))),
      p(paste("Local Concentration:", sprintf("%.2f%%", local_concentration))),
      p(paste("U.S. Jobs in Industry:", format(state_details$US_Jobs, big.mark = ","))),
      p(paste("Total U.S. Jobs:", format(US_TOTAL_JOBS, big.mark = ","))),
      p(paste("National Concentration:", sprintf("%.2f%%", national_concentration)))
    )
  })
  output$color_thresholds <- renderUI({
    thresholds <- industry_thresholds[[input$industry]]
    lapply(1:(length(thresholds)-1), function(i) {
      div(class = "legend-item",
          div(class = "color-box",
              style = paste0("background:", custom_colors[i])),
          if(i==1 && length(thresholds)!=2){
            span(sprintf("%.2f to %.2f",
                         thresholds[i+1],
                         thresholds[i]))
          } else{
            span(sprintf("%.2f to %.2f",
                         thresholds[i+1],
                         thresholds[i] - 0.01))
          }
      )
    })
  })
}

shinyApp(ui, server)
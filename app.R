knitr::opts_chunk$set(echo = TRUE)

##Clones Repository to R
system("git clone  https://github.com/oystersdukebc/summer-2026-visualization-tool.git")

##Pulls in repository and sets it as the working directory

setwd("summer-2026-visualization-tool")
system("git pull origin main")  # or replace 'main' with the correct branch

##Setting the "Cleaned" folder as the working directory

setwd("Cleaned")

rm(list = ls())

library(shiny)
library(tidyverse)
library(lubridate)
library(plotly)
library(readxl)
library(shinyWidgets)

# time interval function
add_time_columns <- function(df){
  df %>%
    mutate(
      Year = year(DateTime),
      Month = month(DateTime),
      Day = day(DateTime),
      OverlayTime = update(DateTime, year = 2000)
    )
}

filter_time <- function(df, month_val, biweek_val){
  if(month_val != "full"){
    df <- df %>% filter(Month == as.numeric(month_val))
  }
  
  if(biweek_val == "1"){
    df <- df %>% filter(Day >= 1 & Day <= 15)
  }
  
  if(biweek_val == "2"){
    df <- df %>% filter(Day >= 16)
  }
  
  df
}

# load data
load_do <- function(file, farm){
  read_excel(file) %>%
    mutate(DateTime = ymd_hms(DateTime),
           Year = year(DateTime),
           DO = as.numeric(DomgL),
           Temp_C = as.numeric(Temp_C),
           Farm = farm)  %>%
    add_time_columns() %>%
    select(DateTime, OverlayTime, Year, Month, Day, Farm, DO, Temp_C)
}

load_ph <- function(file, farm){
  read_excel(file) %>%
    mutate(DateTime = ymd_hms(DateTime),
           Year = year(DateTime),
           pH = as.numeric(pH),
           Farm = farm) %>%
    add_time_columns() %>%
    select(DateTime, OverlayTime, Year, Month, Day, Farm, pH)
}

load_sal <- function(file, farm){
  read_excel(file) %>%
    mutate(DateTime = ymd_hms(DateTime),
           Salinity = as.numeric(Sal_ppt),
           Farm = farm) %>%
    add_time_columns() %>%
    select(DateTime, OverlayTime, Year, Month, Day, Farm, Salinity)
}

cmast_do   <- load_do("CMAST_DO_Cleaned.xlsx","CMAST")
cmast_ph   <- load_ph("CMAST_pH_Cleaned.xlsx","CMAST")
cmast_sal  <- load_sal("CMAST_Con_Cleaned.xlsx","CMAST")

stump_do   <- load_do("StumpSound_DO_Cleaned.xlsx","Stump Sound")
stump_ph   <- load_ph("StumpSound_pH_Cleaned.xlsx","Stump Sound")
stump_sal  <- load_sal("StumpSound_Con_Cleaned.xlsx","Stump Sound")

ward_do    <- load_do("WardCreek_DO_Cleaned.xlsx","Ward Creek")
ward_ph    <- load_ph("WardCreek_pH_Cleaned.xlsx","Ward Creek")
ward_sal   <- load_sal("WardCreek_Con_Cleaned.xlsx","Ward Creek")

duml_do    <- load_do("DUML_DO_Cleaned.xlsx","DUML")
duml_ph    <- load_ph("DUML_pH_Cleaned.xlsx","DUML")
duml_sal   <- load_sal("DUML_Con_Cleaned.xlsx","DUML")

nelson_do  <- load_do("Nelson_DO_Cleaned.xlsx","Nelson Bay")
nelson_ph  <- load_ph("Nelson_pH_Cleaned.xlsx","Nelson Bay")
nelson_sal <- load_sal("Nelson_Con_Cleaned.xlsx","Nelson Bay")

load_do_24 <- function(file, farm){
  read_excel(file) %>%
    mutate(
      DateTime = ymd_hms(DateTime),
      Farm = as.character(Farm),
      Location = as.character(Location),
    ) %>%
    filter(Farm == farm, Location == "Array") %>%
    mutate(
      Year = year(DateTime),
      DO = as.numeric(DomgL),
      Temp_C = as.numeric(Temp_C)
    ) %>%
    add_time_columns() %>%
    select(DateTime, OverlayTime, Farm, Year, Month, Day, DO, Temp_C)
}

load_ph_24 <- function(file, farm){
  read_excel(file) %>%
    mutate(
      DateTime = ymd_hms(DateTime),
      Farm = as.character(Farm),
      Location = as.character(Location)
    ) %>%
    filter(Farm == farm,
           Location == "Array" | Location == "Line1B") %>%
    mutate(
      Year = year(DateTime),
      pH = as.numeric(pH)
    ) %>%
    add_time_columns() %>%
    select(DateTime, OverlayTime, Farm, Year, Month, Day, pH)
}

load_sal_24 <- function(file, farm){
  read_excel(file) %>%
    mutate(
      DateTime = ymd_hms(DateTime),
      Farm = as.character(Farm),
      Location = as.character(Location)
    ) %>%
    filter(Farm == farm, Location == "Array") %>%
    mutate(
      Year = year(DateTime),
      Salinity = as.numeric(Sal_ppt)
    ) %>%
    add_time_columns() %>%
    select(DateTime, OverlayTime, Farm, Year, Month, Day, Salinity)
}

cmast_do_24  <- load_do_24("DOsensor_2024.xlsx", "CMAST")
cmast_ph_24  <- load_ph_24("pH_2024.xlsx", "CMAST")
cmast_sal_24 <- load_sal_24("Salinity_2024.xlsx", "CMAST")

duml_do_24  <- load_do_24("DOsensor_2024.xlsx", "DUML")
duml_ph_24  <- load_ph_24("pH_2024.xlsx", "DUML")
duml_sal_24 <- load_sal_24("Salinity_2024.xlsx", "DUML")

ysi_2025 <- read_excel("YSI.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         Temp_C = as.numeric(Temp_C),
         Salinity = as.numeric(Sal_ppt),
         pH = as.numeric(pH),
         DO = as.numeric(DomgL),
         Year = year(DateTime),
         Farm = as.character(Farm)) %>%
  add_time_columns() %>%
  select(DateTime, OverlayTime, Year, Month, Day, Farm, Temp_C, Salinity, pH, DO)

ysi_2024 <- read_excel("YSI_2024.xlsx") %>%
  mutate(DateTime = ymd_hms(DateTime),
         Temp_C = as.numeric(Temp_C),
         Salinity = as.numeric(Sal_ppt),
         pH = as.numeric(pH),
         DO = as.numeric(DomgL),
         Year = year(DateTime),
         Farm = as.character(Farm),
         Location = as.character(Location)) %>%
  filter(
    Farm %in% c("DUML", "CMAST"),
    (Farm == "DUML" & Location == "Array") |
      (Farm == "CMAST" & Location == "Line 1B")
  ) %>%
  add_time_columns() %>%
  select(DateTime, OverlayTime, Year, Month, Day, Farm, Temp_C, Salinity, pH, DO)

ysi <- bind_rows(ysi_2025, ysi_2024)

farm_list  <- c("CMAST","Stump Sound","Ward Creek","DUML","Nelson Bay")
param_list <- c("Temperature","Dissolved Oxygen","pH","Salinity")
year_list <- c("2024", "2025")
farm_2024 <- c("CMAST", "DUML")
farm_2025 <- c("CMAST", "Stump Sound", "Ward Creek", "DUML", "Nelson Bay")

colors <- c(
  
  # ===== 2024 =====
  "Temp CMAST 2024" = "#9ecae1",
  "DO CMAST 2024" = "#fcae91",
  "pH CMAST 2024" = "#a1d99b",
  "Salinity CMAST 2024" = "#fcbfd2",
  
  "Temp DUML 2024" = "#fb6a4a",
  "DO DUML 2024" = "#6baed6",
  "pH DUML 2024" = "#bcbddc",
  "Salinity DUML 2024" = "#d9d76e",
  
  
  # ===== 2025 =====
  "Temp CMAST 2025" = "#2171b5",
  "DO CMAST 2025" = "#cb181d",
  "pH CMAST 2025" = "#238b45",
  "Salinity CMAST 2025" = "#c51b8a",
  
  "Temp Stump 2025" = "#6a51a3",
  "DO Stump 2025" = "#bdbd00",
  "pH Stump 2025" = "#8c564b",
  "Salinity Stump 2025" = "#ff7f0e",
  
  "Temp Ward 2025" = "#17becf",
  "DO Ward 2025" = "#ff7f0e",
  "pH Ward 2025" = "#1b9e77",
  "Salinity Ward 2025" = "#984ea3",
  
  "Temp DUML 2025" = "#d62728",
  "DO DUML 2025" = "#1f77b4",
  "pH DUML 2025" = "#9467bd",
  "Salinity DUML 2025" = "#bcbd22",
  
  "Temp Nelson 2025" = "#2ca02c",
  "DO Nelson 2025" = "#17becf",
  "pH Nelson 2025" = "#EE554E",
  "Salinity Nelson 2025" = "#8c564b"
)

# UI
ui <- fluidPage(
  
  titlePanel("Environmental Data Visualization Tool"),
  
  tabsetPanel(
    id="month_tabs",
    type="tabs",
    tabPanel("Full Summer", value="full"),
    tabPanel("May", value="5"),
    tabPanel("June", value="6"),
    tabPanel("July", value="7"),
    tabPanel("August", value="8"),
    tabPanel("September", value="9")
  ),
  
  br(),
  
  sidebarLayout(
    sidebarPanel(
      
      conditionalPanel(
        condition = "input.month_tabs != 'full'",
        
        h4("Select Time Interval"),
        radioButtons("biweek",
                     NULL,
                     choices=c("Full Month"="full",
                               "First Biweek"="1",
                               "Second Biweek"="2"),
                     selected="full"),
        
        hr()
      ),

      h4("Select Years:"),
      checkboxGroupInput("year_select", NULL, year_list, selected = "2025"),
      
      helpText(
        style = "font-size: 12px; color: #666666; margin-top: -10px;",
        "2024 data is only available for DUML and CMAST. Select 2025 to view data from all five farms, or select both years to compare trends at DUML and CMAST."
      ),
      
      hr(),
      
      h4("Select Farms:"),
      checkboxGroupInput("farm_select",NULL,farm_list,selected=farm_list),
      
      hr(),
      
      h4("Select Parameters:"),
      checkboxGroupInput("param_select",NULL,param_list,selected=param_list),
      
      hr(),
      
      materialSwitch("show_ysi","Display YSI Data",value=FALSE),
      
      hr(),
      
      h4("Edit Plot Title:"),
      textInput("custom_title", NULL, ""),
    
    width = 3
    ),
    
    mainPanel(
      plotlyOutput("plot", height = "700px"),
      width = 9
    )
  )
)

# Server
server <- function(input, output, session){
  
  observeEvent(input$year_select, {
    
    years <- input$year_select
    
    available_farms <- if("2024" %in% years){
      farm_2024
    } else if("2025" %in% years){
      farm_2025
    } else {
      character(0)
    }
    
    current_selected <- input$farm_select
    new_selected <- intersect(current_selected, available_farms)
    
    if(length(new_selected) == 0){
      new_selected <- available_farms
    }
    
    updateCheckboxGroupInput(
      session,
      "farm_select",
      choices = available_farms,
      selected = new_selected
    )
  })
  
  observeEvent(input$month_tabs, {
    if(input$month_tabs == "full"){
      updateRadioButtons(session, "biweek", selected = "full")
    }
  })
  
  auto_title <- reactive({
    
    pretty_list <- function(x){
      
      if(length(x) == 1){
        x
        
      } else if(length(x) == 2){
        paste(x, collapse = " and ")
        
      } else {
        paste0(
          paste(x[-length(x)], collapse = ", "),
          ", and ",
          x[length(x)]
        )
      }
    }
    
    # PARAMETERS
    params <- if(length(input$param_select) == length(param_list)){
      "All Parameters"
    } else {
      pretty_list(input$param_select)
    }
    
    # FARMS
    farms <- if(setequal(input$farm_select, farm_2025)){
      "All Farms"
    } else if(setequal(input$farm_select, farm_2024)){
      "CMAST and DUML"
    } else {
      pretty_list(input$farm_select)
    }
    
    # TIME LABEL
    month_label <- switch(input$month_tabs,
                          "full" = "Full Summer",
                          "5" = "May",
                          "6" = "June",
                          "7" = "July",
                          "8" = "August",
                          "9" = "September")
    
    time_label <- if(input$month_tabs == "full"){
      
      "(Full Summer)"
      
    } else {
      
      biweek_label <- switch(input$biweek,
                             "full" = "",
                             "1" = " - First Biweek",
                             "2" = " - Second Biweek")
      
      paste0("(", month_label, biweek_label, ")")
    }
    
    paste0(
      params,
      " at ",
      farms,
      " ",
      time_label
    )
  })
  
  observeEvent(
    list(input$year_select, input$farm_select, input$param_select, input$month_tabs, input$biweek),
    {
      updateTextInput(session, "custom_title", value = auto_title())
    },
    ignoreInit = FALSE
  )
  
  output$plot <- renderPlotly({
    
    month_val  <- input$month_tabs
    biweek_val <- input$biweek
    years <- input$year_select
    
    p <- plot_ly()
    
    all_y_values <- c()
    
    add_trace_auto <- function(data, yvar, name, farm_name, color_key){
      
      data_filtered <- filter_time(data, month_val, biweek_val)
      
      if(nrow(data_filtered) > 0 && yvar %in% colnames(data_filtered)){
        
        all_y_values <<- c(all_y_values, data_filtered[[yvar]])
        
        trace_color <- unname(colors[color_key])
        
        farm_group <- farm_name
        
        trace_label <- if(length(years) > 1){
          paste(sub(" .*", "", name), gsub(".* ", "", color_key))
        } else {
          sub(" .*", "", name)
        }
        
        p <<- add_lines(
          p,
          data = data_filtered,
          x = ~OverlayTime,
          y = as.formula(paste0("~", yvar)),
          name = trace_label,
          legendgroup = farm_group,
          legendgrouptitle = list(text = farm_group),
          line = list(color = trace_color, width = 2)
        )
        
        # YSI
        if(input$show_ysi){
          
          ysi_filtered <- ysi %>%
            filter(
              Farm == gsub(" 2024| 2025", "", farm_name),
              Year %in% as.numeric(years)
            ) %>%
            filter_time(month_val, biweek_val)
          
          if(nrow(ysi_filtered) > 0 && yvar %in% colnames(ysi_filtered)){
            
            p <<- add_markers(
              p,
              data = ysi_filtered,
              x = ~OverlayTime,
              y = as.formula(paste0("~", yvar)),
              name = paste0(name, " (YSI)"),
              marker = list(
                symbol = "circle",
                size = 6,
                color = trace_color,
                line = list(
                  color = "black",
                  width = 1.5
                )
              ),
              showlegend = FALSE
            )
          }
        }
      }
    }
    
    farms  <- input$farm_select
    params <- input$param_select
    
    show_param <- function(pn) pn %in% params
    
    if("CMAST" %in% farms){
      if("2024" %in% years){
        if(show_param("Temperature")) add_trace_auto(cmast_do_24, "Temp_C", "Temp CMAST", "CMAST", "Temp CMAST 2024")
        if(show_param("Dissolved Oxygen")) add_trace_auto(cmast_do_24, "DO", "DO CMAST", "CMAST", "DO CMAST 2024")
        if(show_param("pH")) add_trace_auto(cmast_ph_24, "pH", "pH CMAST", "CMAST", "pH CMAST 2024")
        if(show_param("Salinity")) add_trace_auto(cmast_sal_24, "Salinity", "Salinity CMAST", "CMAST", "Salinity CMAST 2024")
      }
      
      if("2025" %in% years){
        if(show_param("Temperature")) add_trace_auto(cmast_do, "Temp_C", "Temp CMAST", "CMAST", "Temp CMAST 2025")
        if(show_param("Dissolved Oxygen")) add_trace_auto(cmast_do, "DO", "DO CMAST", "CMAST", "DO CMAST 2025")
        if(show_param("pH")) add_trace_auto(cmast_ph, "pH", "pH CMAST", "CMAST", "pH CMAST 2025")
        if(show_param("Salinity")) add_trace_auto(cmast_sal, "Salinity", "Salinity CMAST", "CMAST", "Salinity CMAST 2025")
      }
    }
    
    if("2025" %in% years && "Stump Sound" %in% farms){
      if(show_param("Temperature")) add_trace_auto(stump_do, "Temp_C", "Temp Stump", "Stump Sound", "Temp Stump 2025")
      if(show_param("Dissolved Oxygen")) add_trace_auto(stump_do, "DO", "DO Stump", "Stump Sound", "DO Stump 2025")
      if(show_param("pH")) add_trace_auto(stump_ph, "pH", "pH Stump", "Stump Sound", "pH Stump 2025")
      if(show_param("Salinity")) add_trace_auto(stump_sal, "Salinity", "Salinity Stump", "Stump Sound", "Salinity Stump 2025")
    }
    
    if("2025" %in% years && "Ward Creek" %in% farms){
      if(show_param("Temperature")) add_trace_auto(ward_do, "Temp_C", "Temp Ward", "Ward Creek", "Temp Ward 2025")
      if(show_param("Dissolved Oxygen")) add_trace_auto(ward_do, "DO", "DO Ward", "Ward Creek", "DO Ward 2025")
      if(show_param("pH")) add_trace_auto(ward_ph, "pH", "pH Ward", "Ward Creek", "pH Ward 2025")
      if(show_param("Salinity")) add_trace_auto(ward_sal, "Salinity", "Salinity Ward", "Ward Creek", "Salinity Ward 2025")
    }
    
    if("DUML" %in% farms){
      if("2024" %in% years){
        if(show_param("Temperature")) add_trace_auto(duml_do_24, "Temp_C", "Temp DUML", "DUML", "Temp DUML 2024")
        if(show_param("Dissolved Oxygen")) add_trace_auto(duml_do_24, "DO", "DO DUML", "DUML", "DO DUML 2024")
        if(show_param("pH")) add_trace_auto(duml_ph_24, "pH", "pH DUML", "DUML", "pH DUML 2024")
        if(show_param("Salinity")) add_trace_auto(duml_sal_24, "Salinity", "Salinity DUML", "DUML", "Salinity DUML 2024")
      }
      
      if("2025" %in% years){
        if(show_param("Temperature")) add_trace_auto(duml_do, "Temp_C", "Temp DUML", "DUML", "Temp DUML 2025")
        if(show_param("Dissolved Oxygen")) add_trace_auto(duml_do, "DO", "DO DUML", "DUML", "DO DUML 2025")
        if(show_param("pH")) add_trace_auto(duml_ph, "pH", "pH DUML", "DUML", "pH DUML 2025")
        if(show_param("Salinity")) add_trace_auto(duml_sal, "Salinity", "Salinity DUML", "DUML", "Salinity DUML 2025")
      }
    }
    
    if("2025" %in% years && "Nelson Bay" %in% farms){
      if(show_param("Temperature")) add_trace_auto(nelson_do, "Temp_C", "Temp Nelson", "Nelson Bay", "Temp Nelson 2025")
      if(show_param("Dissolved Oxygen")) add_trace_auto(nelson_do, "DO", "DO Nelson", "Nelson Bay", "DO Nelson 2025")
      if(show_param("pH")) add_trace_auto(nelson_ph, "pH", "pH Nelson", "Nelson Bay", "pH Nelson 2025")
      if(show_param("Salinity")) add_trace_auto(nelson_sal, "Salinity", "Salinity Nelson", "Nelson Bay", "Salinity Nelson 2025")
    }
    
    # interactive y-axis rescale
    y_range <- NULL
    if(length(all_y_values) > 0){
      y_range <- range(all_y_values, na.rm=TRUE)
    }
    
    p %>% layout(
      title = input$custom_title,
      xaxis = list(
        title = "Date & Time",
        tickformat = "%b %d\n%H:%M",
        hoverformat = "%b %d %H:%M"
      ),
      yaxis=list(title="Value", range=y_range),
      legend = list(
        orientation = "v",
        x = 1.02,
        y = 1,
        xanchor = "left",
        yanchor = "top",
        font = list(size = 11),
        itemsizing = "constant",
        tracegroupgap = 15
      )
    )
  })
}

shinyApp(ui, server)

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Sample plots"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            fileInput("file1", "Choose CSV File",
                      multiple = TRUE,
                      accept = c("text/csv",
                                 "text/comma-separated-values,text/plain",
                                 ".csv")),
            # Input: Checkbox if file has header ----
            checkboxInput("header", "Header", TRUE),
            
            # Input: Select separator ----
            radioButtons("sep", "Separator",
                         choices = c(Semicolon = ";",
                                     Comma = ",",
                                     Tab = "\t"),
                         selected = ","),
            tags$hr(),
            selectInput("dataset","Data:",
                        choices =list(iris = "iris",
                                      uploaded_file = "inFile"), selected=NULL),
            selectInput('xcol', 'Variable X:', ""),
            selectInput('ycol', 'Variable Y: ', "", selected = ""),
            selectInput("plot.type","Plot Type:",
                        list(boxplot = "boxplot", histogram = "histogram", bar = "bar")),
        
            checkboxInput("show.points", "show points", TRUE)
            ),
        mainPanel(
            h3(textOutput("caption")),
            uiOutput("plot")
        )
    )
))

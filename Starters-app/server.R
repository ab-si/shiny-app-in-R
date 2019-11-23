library(shiny)
library(ggplot2)
library(dplyr)

data("iris")

.theme<- theme(
    axis.line = element_line(colour = 'gray', size = .75),
    panel.background = element_blank(),
    plot.background = element_blank(),
    legend.position = "none"
)


options(shiny.maxRequestSize=30*1024^2)
# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    observe({
        if(!exists(input$dataset)) return()
        var.opts<-colnames(get(input$dataset))
        updateSelectInput(session, "xcol", choices = var.opts)
        updateSelectInput(session, "ycol", choices = var.opts)
    })
    
    output$caption<-renderText({
        switch(input$plot.type,
               "boxplot" 	= 	"Boxplot",
               "histogram" =	"Histogram",
               "bar" 		=	"Bar graph")
    })
    
    
    output$plot <- renderUI({
        plotOutput("p")
    })
    
    #get data object
    get_data<-reactive({
        
        if(!exists(input$dataset)) return() # if no upload
        
        check<-function(x){is.null(x) || x==""}
        if(check(input$dataset)) return()
        
        obj<-list(data=get(input$dataset),
                  xcol=input$xcol,
                  ycol=input$ycol
        )
        
        if(any(sapply(obj,check))) return()
        check<-function(obj){
            !all(c(obj$xcol,obj$ycol) %in% colnames(obj$data))
        }
        
        if(check(obj)) return()
        
        
        obj
        
    })
    
    #plotting function using ggplot2
    output$p <- renderPlot({
        
        plot.obj<-get_data()
        
        #conditions for plotting
        if(is.null(plot.obj)) return()
        
        if(plot.obj$xcol == "" | plot.obj$ycol =="") return()
        
        #plot types
        plot.type<-switch(input$plot.type,
                          "boxplot" 	= geom_boxplot(show.legend = FALSE),
                          "histogram" =	geom_histogram(alpha=0.5,position="identity",show.legend = FALSE),
                          "bar" 		=	geom_bar(position="dodge",show.legend = FALSE)
        )
        
        
        if(input$plot.type=="boxplot")	{
            p<-ggplot(plot.obj$data,
                      aes_string(
                          x 		= plot.obj$xcol,
                          y 		= plot.obj$ycol,
                          fill 	= plot.obj$xcol
                      )
            ) + plot.type
            
            if(input$show.points==TRUE)
            {
                p<-p+ geom_point(color='black',alpha=0.5, position = 'jitter')
            }
            
        } else {
            
            p<-ggplot(plot.obj$data,
                      aes_string(
                          x 		= plot.obj$xcol,
                          fill 	= plot.obj$ycol,
                          group 	= plot.obj$xcol
                      )
            ) + plot.type
        }
        
        p<-p+labs(
            fill 	= input$group,
            x 		= "",
            y 		= input$variable
        )  +
            .theme
        print(p)
    })
    
    # set uploaded file
    upload_data<-reactive({
        
        inFile <- input$file1
        
        if (is.null(inFile))
            return(NULL)
        
        #could also store in a reactiveValues
        read.csv(inFile$datapath,
                 header = input$header,
                 sep = input$sep)
    })
    
    observeEvent(input$file1,{
        inFile<<-upload_data()
    })
    

})

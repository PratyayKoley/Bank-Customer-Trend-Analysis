library(shiny); library(mongolite); library(ggplot2); library(DT)

ui <- fluidPage(
  titlePanel("Bank Customer Trend Analysis"),
  sidebarLayout(
    sidebarPanel(
      selectInput("segment", "Segment", choices = c("All", 1:4)),
      numericInput("prob_cut", "Churn Prob Threshold", 0.5, min = 0, max = 1, step=0.01),
      actionButton("refresh", "Refresh Data")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Churn Overview", plotOutput("churnPlot")),
        tabPanel("Table", DTOutput("tbl"))
      )
    )
  )
)

server <- function(input, output, session) {
  get_data <- reactiveVal(NULL)
  observeEvent(input$refresh, {
    m <- mongo(collection = "bank_insights", db = "bank_analytics", url = "mongodb://localhost:27017")
    df <- m$find(limit = 10000) # adjust
    get_data(df)
  })
  
  output$churnPlot <- renderPlot({
    df <- get_data()
    if (is.null(df)) return(NULL)
    df$segment <- as.factor(df$segment)
    ggplot(df, aes(x = segment, y = churn_prob)) + geom_boxplot() + ggtitle("Churn Probability by Segment")
  })
  
  output$tbl <- renderDT({
    df <- get_data()
    datatable(df)
  })
}

shinyApp(ui, server)
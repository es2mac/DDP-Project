
library(shiny)
library(markdown)

shinyUI(
    pageWithSidebar(
  
        # Application title
        headerPanel(div(align="center", "Metabolic Syndrome Risk Calculator"),
                    windowTitle = "Metabolic Syndrome Risk Calculator"),
        
        # Sidebar with a slider input for number of bins
        sidebarPanel(
            includeMarkdown("header.md"),
            checkboxInput("imperial", label="Use imperial units", value=F),
            conditionalPanel(
                condition="input.imperial==false",
                numericInput('waist', 'Waist circumference (cm)', 85,
                             min=60, max=110, step=1)
            ),
            conditionalPanel(
                condition="input.imperial==true",
                numericInput('waistin', 'Waist circumference (in)', 34,
                             min=25, max=45, step=0.5)
            ),
            numericInput('diasbp', 'Diastolic blood pressure (mmHg)', 80,
                         min=60, max=100, step=1),
            radioButtons('gender', 'Gender', c("Male", "Female")),
            actionButton("goButton", "Calculate"),
            
            includeMarkdown("footer.md")
        ),
    
        # Show a plot of the generated distribution
        mainPanel(
            h3(textOutput('score')),
            plotOutput("riskPlot"),
            includeMarkdown("instruction.md")
        )
    )
)

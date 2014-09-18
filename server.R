
library(shiny)

msp <- function(waist, diasbp, gender) {
  linear <- (-27.07 + 0.193 * waist + 0.109 * diasbp + 1.47 * (gender == "Female"))
  100 / (1 + exp(-linear))
}

shinyServer(
  function(input, output) {

    output$riskPlot <- renderPlot({
      input$goButton
      isolate({
        w <- ifelse(input$imperial, input$waistin * 2.54, input$waist)
        if (input$goButton == 0) {
            score = ""
        }
        else {
            score <- paste0(sprintf("%.1f", msp(w, input$diasbp, input$gender)),
                        "%")
        }
        output$score <- renderText(paste("Your score:", score))
        risk_levels <- outer(55:115, 59:105, function(x, y) msp(x, y, input$gender))
        rgb.palette <- colorRampPalette(c("green", "yellow", "orange", "red"), space = "rgb")
        filled.contour(55:115, 59:105, risk_levels,
                       plot.axes={axis(1); axis(2);
                                  points(w, input$diasbp);
                                  text(w, input$diasbp + 3, score, cex=2) },
                       plot.title={
                         title(xlab="Waist circumference (cm)", cex.lab=1.5,
                               ylab="Diastolic blood pressure (mmHg)")
                       },
                       key.title={
                         title("MetS\nProb.\n(%)")
                       },
                       col=rgb.palette(20))
      })
  
    })
      
  }
)

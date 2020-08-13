avPlots.invis <- function(MODEL, ...) {
  
  ff <- tempfile();
  png(filename = ff);
  OUT <- car::avPlots(MODEL, ...);
  dev.off()
  unlink(ff);
  OUT; }

ggAVPLOTS  <- function(MODEL, YLAB = NULL) {
  
  #Extract the information for AV plots
  AVPLOTS <- avPlots.invis(MODEL);
  K       <- length(AVPLOTS);
  
  #Create the added variable plots using ggplot
  GGPLOTS <- vector('list', K);
  for (i in 1:K) {
    DATA         <- data.frame(AVPLOTS[[i]]);
    GGPLOTS[[i]] <- ggplot2::ggplot(aes_string(x = colnames(DATA)[1], 
                                               y = colnames(DATA)[2]), 
                                    data = DATA) +
      geom_point(colour = 'blue') + 
      geom_smooth(method = 'lm', se = FALSE, 
                  color = 'red', formula = y ~ x, linetype = 'dashed') +
      xlab(paste0('Predictor Residual \n (', 
                  names(DATA)[1], ' | others)')) +
      ylab(paste0('Response Residual \n (',
                  ifelse(is.null(YLAB), 
                         paste0(names(DATA)[2], ' | others'), YLAB), ')')) +
      theme_minimal()   
    }
  
  #Return output object
  library(gridExtra)
  K     <- length(GGPLOTS)
  NCOL  <- ceiling(sqrt(K));
  AVPLOTS <- do.call("grid.arrange", c(GGPLOTS, ncol = NCOL, top = 'Added Variable Plots'))
  
  }
#' @title Line Map
#' @name linemap
#' @description Plot a line map.
#' @param x a data.frame, two first column must be longitude and latitude of
#' gridded data
#' @param var the name of the variable to plot
#' @param k expension factor
#' @param threshold threshold of the data to plot
#' @param col color for the lines areas
#' @param border color for the lines borders
#' @param lwd thickness of the lines
#' @param add if TRUE add the lines to the current plot
#' @export
#' @examples
#' library(linemap)
#' data("Occitanie")
#' opar <- par(mar=c(0,0,0,0), bg = "ivory2")
#' if(require(sf)){
#'   plot(st_geometry(regOcc), col="ivory1", border = NA)
#'   linemap(x = popOcc, var = "pop", k = 2.5, threshold = 50,
#'           col = "ivory1", border = "ivory4", lwd = 0.6, add = TRUE)
#' }else{
#'   linemap(x = popOcc, var = "pop", k = 2.5, threshold = 50,
#'           col = "ivory1", border = "ivory4", lwd = 0.6, add = FALSE)
#' }
#' par(opar)
linemap <- function(x, var, k = 2, threshold = 1, col = "white",
                    border = "black", lwd = 0.5, add = FALSE){
  x[is.na(x[var]),var] <- 0
  lat <- unique(x[,2])
  lon <- unique(x[,1])
  if(!add){
    graphics::plot(1:10, type = "n", axes = F, xlab = "", ylab="", asp = 1,
                   xlim = c(min(x[,1]), max(x[,1])),
                   ylim = c(min(x[,2]), max(x[,2])))
  }
  for (i in length(lat):1){
    ly <- x[x[,2]==lat[i],]
    ly[ly[var] < threshold, var] <- 0
    yVals <- ly[,2] + ly[,var] * k
    xVals <- ly[,1]
    yVals[is.na(yVals)] <- lat[i]
    yVals[1] <- lat[i] + min(ly[,var] * k)
    yVals[length(yVals)] <- yVals[1]
    graphics::polygon(xVals, yVals, border = NA, col = col)
    for(j in 1:(length(yVals) - 1)){
      if ((ly[j,var] > 0) | (ly[j+1,var] > 0)){
        graphics::segments(xVals[j], yVals[j], xVals[j+1], yVals[j+1],
                           col=border, lwd=lwd)
      }
    }
  }
}

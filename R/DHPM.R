DHPM <- function(os_laz,os_chm,cz = 0.5,r=3){
  extent <- extent(raster(os_chm))
  x_left <- extent[1]
  x_right <- extent[2]
  y_bottom <- extent[3]
  y_top <- extent[4]
  # Create a window using the extracted coordinates
  window <- owin(xrange = c(x_left, x_right), yrange = c(y_bottom, y_top))
  os_ppp <- ppp(x = os_laz@data$X, y = os_laz@data$Y,window = window, check = T)
  DHP<- raster(density(os_ppp,sigma=cz*r, eps=cz,edge=T))#, kernel = "quartic"
  return(DHP)
}

edge<- function(raster,nb=5,a=0.5,b=3){ 
  res <- res(raster)[1]
  n <- as.integer(nb/res) + 1
  AOC <- terrain(raster, opt = "aspect")
  SOA <- terrain(AOC, opt = "slope")

  reAOC <- terrain((maxValue(raster)-raster), opt = "aspect")
  reSOA <- terrain(reAOC, opt = "slope")

  AdSOA = ((SOA+reSOA) * 0.5 - abs(SOA-reSOA) * 0.5)
  AdSOA_fmean <- raster::focal(AdSOA, w = matrix(1,n,n), fun = mean, na.rm = TRUE,pad=TRUE)
  AdSOA_fsd <- raster::focal(AdSOA, w = matrix(1,n,n), fun = sd, na.rm = TRUE,pad=TRUE)
  

  r_fmean <- raster::focal(raster, w = matrix(1,n,n), fun = mean, na.rm = TRUE,pad=TRUE)
  ridge =as.integer(((raster - r_fmean)>0.5)* ((AdSOA - (AdSOA_fmean-AdSOA_fsd*a))>0))
  edge <- (1-ridge)*as.integer(((raster - r_fmean) < -0.5)* ((AdSOA - (AdSOA_fmean-AdSOA_fsd/b))>0))
  #w3 <- matrix(c(0,1,0,1,1,1,0,1,0), nr=3,nc=3)
  #edge <- raster::focal(edge, w = w3, fun = min, na.rm = TRUE,pad=TRUE)  
  edge[edge == 0] <- NA
  return(edge)
}
thin_edge<- function(edge,raster){ 
  polygons <- rasterToPolygons(edge)#, dissolve = TRUE
  buffer_polygons <- gBuffer(polygons, byid = F, joinStyle='ROUND',mitreLimit=5,width = 0.5)
  shrunken_polygons <- gBuffer(buffer_polygons, byid =F, width = -1)
  # Rasterize the polygons into the empty raster
  thin_edge <- rasterize(shrunken_polygons, raster, field = 1)
  return(thin_edge)
}

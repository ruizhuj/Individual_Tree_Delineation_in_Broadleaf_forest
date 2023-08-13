ttops_raster <- function(raster,geopnts){
  r <- raster(ncol=ncol(raster), nrow=nrow(raster))
  extent(r) <- extent(raster)
  crs(r) <- raster@crs
  ttops_r <- rasterize(as.data.frame(st_coordinates(geopnts))[,1:2], r,  field = geopnts$Z, fun=max, background=0)
  w3 <- matrix(c(0,1,0,1,1,1,0,1,0), nr=3,nc=3)
  ttops_r_fmax <- as.integer(raster::focal(ttops_r, w = w3, fun = max, na.rm = TRUE)>=2)
  #ttops_r_fmax <- raster::focal(ttops_r_fmax, w = matrix(1,3,3), fun = max, na.rm = TRUE)
  return(ttops_r_fmax)
}

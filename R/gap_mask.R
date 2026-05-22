gap_mask <- function(raster,nb,a=0.25,b=0.05){ # nb is the neighborhood range
  res <- res(raster)[1]
  n <- as.integer(nb/res) + 1
  r_fmean <- raster::focal(raster, w = matrix(1,n,n), fun = mean, na.rm = TRUE,pad=TRUE)
  r_fsd <- raster::focal(raster, w =  matrix(1,n,n), fun = sd, na.rm = TRUE,pad=TRUE)
  tr <- as.data.frame(raster)[,1]
  tr <- tr[!is.na(tr)]
  tr <- tr[tr>0]
  tr <- quantile(tr, b)
  mask = (raster - (r_fmean - r_fsd*a) <0) |(raster<tr)
  mask[is.na(mask[])] <- 0
  mask <- raster::focal(mask, w = matrix(1,3,3), fun = min, na.rm = TRUE,pad=TRUE)
  mask<- resample(mask, raster, method = 'bilinear')
  return(mask)
}

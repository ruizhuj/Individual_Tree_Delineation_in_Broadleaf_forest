smooth_ms <- function(raster,nb=3,a=0.25,b=0.95,c=1.5){ # nb is the neighborhood range
  res <- res(raster)[1]
  n <- as.integer(nb/res) + 1
  r_fmean <- raster::focal(raster, w = matrix(1,n,n), fun = mean, na.rm = TRUE,pad=TRUE)
  r_fsd <- raster::focal(raster, w =  matrix(1,n,n), fun = sd, na.rm = TRUE,pad=TRUE)
  tr <- as.data.frame(raster)[,1]
  tr <- tr[!is.na(tr)]
  tr <- tr[tr>0]
  tr <- quantile(tr, b)
 # print(tr)
  pits = ((raster - (r_fmean + r_fsd*a)) >= 0) * (raster>tr)
  pits[is.na(pits[])] <- 0
  pits <- raster::focal(pits, w = matrix(1,3,3), fun = max, na.rm = TRUE,pad=TRUE)
  pits<- resample(pits, raster, method = 'bilinear')

  S1= pits*(r_fmean-c*r_fsd) + (1-pits)*raster
  S1 = S1 * (S1>=0)
  smooth = raster::focal(S1, w = matrix(1,3,3), fun = mean, na.rm = TRUE,pad=TRUE)
  return(smooth)
}
reclass_laz <- function(laz,chm,HCBM,gap=gap_20m){
  chmf3max <- raster::focal(chm, w = matrix(1,3,3), fun = max, na.rm = TRUE,pad=TRUE)
  HCBM_gap <- gap * chmf3max + (1 - gap) * HCBM
  HCBM_gap[is.na(HCBM_gap[])] <- 0
  HCBM_gap[is.infinite(HCBM_gap[])] <- 0

  laz_rmCBM <- laz-HCBM_gap
  ms_laz <- filter_poi(laz_rmCBM,Z< -1 | Classification == 2)
  ms_laz@data$Z <- ms_laz@data$Zref
  rm(laz_rmCBM)
  ms_chm <- rasterize_canopy(ms_laz, 0.5, p2r())
  ms_schm= smooth_ms(ms_chm)

  ms_schm_fmax <- gap*chmf3max+(1-gap)*raster::focal((ms_schm+2), w = matrix(1,3,3), fun = max, na.rm = TRUE,pad=TRUE)
  ms_schm_fmax[is.na(ms_schm_fmax[])] <- 0
  ms_schm_fmax[is.infinite(ms_schm_fmax[])] <- 0

  laz_reclass <- laz-ms_schm_fmax
  ms_laz <- filter_poi(laz_reclass,Z< 1 & Z>=-15 & Classification != 2 & Zref <30)
  ms_laz@data$Classification <- 6
  os_laz <- filter_poi(laz_reclass,Z >=1 & Classification != 2)
  os_laz@data$Classification <- 15
  laz_reclass <- rbind(os_laz,ms_laz,filter_poi(laz_reclass,Classification == 2))
  laz_reclass@data$Z <- laz_reclass@data$Zref
  rm(ms_laz,os_laz)

  return(laz_reclass)
}

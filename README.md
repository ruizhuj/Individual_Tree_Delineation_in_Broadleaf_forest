# Individual_Tree_Delineation_in_Broadleaf_forest

This repository provides the code and documentation for the ITD method, crafted to delineate individual trees from Airborne LiDAR datasets. Our approach employs watershed segmentation built on top-edge-enhanced canopy height and density models, specifically tailored for broadleaf forests in Australia.

## Overview

The ITD method offers an advanced approach to segmenting tree crowns in broadleaf forests. [![image](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1fTZ-cptLAbT0UVkT0VfCUtkrBCiwBWiM?usp=sharing)

### Highlights:

1. **Reclassification of Vegetation Point Clouds**: Our method effectively segregates vegetation point clouds into under-/mid-storey and overstorey.
   ![Under-/Mid-storey and Overstorey Reclassification](imgs/las_reclassification.png)
   
2. **ITD Crown validation**: A comprehensive mapping of Tree crowns delineated using our method.
   ![ITD Crown validation](imgs/Plot1_field_validation.jpg)

3. **Crown width**: A strong linear relationship between the LiDAR-derived crown width and the crown widths measured in the field (R2 = 0.84).
   ![The relationship between field-measured crown with and crown width extracted from LiDAR](imgs/cw_plot.png)

### Workflow:

Our ITD workflow encapsulates the entire process from raw ALS data to final tree crown delineation, including the following steps
1. Create a 50cm resolution CHM.
2. Create  an HCBM from the HCB-HT relationship using field data (Figure 1).
3. Identify canopy gaps.
4. Filter out the under-/mid-storey points below the HCBM, retaining only overstorey LiDAR points.
5. Exclude points within canopy gaps.
6. Generate a densities of high points model (DHP) using overstorey crown points.
7. Pinpoint treetops and crown edges via targeted CHM×DHP raster layers.
8. Perform marker-control watershed delineation on a top-edge-enhanced CHM×DHP layer, calculated as:
(CHM×DHP) × (1.2 × treetops) + (CHM×DHP) × (1 - gaps) × (1 - edges) × (1 - treetops)
   
![Workflow Diagram](imgs/workflow2.jpg)

## Dependencies:

* lidR
* raster
* EBImage
* spatstat

## Getting Started

1. **Clone the Repository in R**:
   ```bash
   install.packages("git2r")
   # Replace the URL with the repository you want to clone
   repo_url <- "https://github.com/ruizhuj/Individual_Tree_Delineation_in_Broadleaf_forest"
   # Clone the repository
   git2r::clone(repo_url, local_path = "Individual_Tree_Delineation_in_Broadleaf_forest")
   ```

2. **Install Dependencies**:
   ```bash
   # Running under: Ubuntu 22.04.2 LTS
   system('sudo apt-get install libfftw3-dev')
   system('sudo apt-get install libfftw3-dev libfftw3-doc')
   install.packages("lidR")
   install.packages("rgdal")
   install.packages('rgeos')
   install.packages("future")
   install.packages('plyr')
   install.packages("spatstat")
   install.packages("BiocManager")
   BiocManager::install("fftwtools")
   BiocManager::install("EBImage")
   ```

3. **Run the ITD Method**:
   ```bash
   check https://github.com/ruizhuj/Individual_Tree_Delineation_in_Broadleaf_forest/blob/main/examples/top_edge_enhanced_watershed_ITD_AUS.ipynb
   ```

## Documentation

For a detailed understanding of our approach, algorithms, and results, please refer to [http://hdl.handle.net/11343/234019] [https://doi.org/10.3390/rs15010060].

## References:

```r
cite
#> Jiang, R. Using LiDAR for landscape-scale mapping of potential habitat for the critically endangered Leadbeater's Possum. Diss. Doctoral dissertation, The University of Melbourne, Australia, 2019. http://hdl.handle.net/11343/234019
#> Trouvé, Raphael, Ruizhu Jiang, Melissa Fedrigo, Matt D. White, Sabine Kasel, Patrick J. Baker, and Craig R. Nitschke. 2023. "Combining Environmental, Multispectral, and LiDAR Data Improves Forest Type Classification: A Case Study on Mapping Cool Temperate Rainforests and Mixed Forests" Remote Sensing 15, no. 1: 60. https://doi.org/10.3390/rs15010060
```    

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgements

---
<a href="https://safes.unimelb.edu.au/research">
  <img src="https://d2glwx35mhbfwf.cloudfront.net/v14.0.0/logo.svg" alt="image" height="200"/>
</a>

<a href="https://www.ari.vic.gov.au/about-us/about-ari">
  <img src="https://www.ari.vic.gov.au/__data/assets/image/0024/58623/ARI_logo_colour.jpg" alt="image" height="200"/>
</a>

---


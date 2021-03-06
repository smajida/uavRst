% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fa_crownseg.R
\name{chmseg_GWS}
\alias{chmseg_GWS}
\title{seeded region growing tree crown segmentation based on 'SAGA GIS'}
\usage{
chmseg_GWS(treepos = NULL, chm = NULL, minTreeAlt = 2,
  minTreeAltParam = "chmQ20", maxCrownArea = 100, leafsize = 256,
  normalize = 0, neighbour = 1, method = 0, thVarFeature = 1,
  thVarSpatial = 1, thSimilarity = 0.002,
  segmentationBands = c("chm"), majorityRadius = 3, giLinks = NULL)
}
\arguments{
\item{treepos}{raster* object}

\item{chm}{raster*. Canopy height model in \code{raster} format. Should be the same that was used to create the input for \code{treepos}.}

\item{minTreeAlt}{numeric. The minimum height value for a \code{chm} pixel is to be considered as part of a crown segment.
All \code{chm} pixels beneath this value will be masked out. Note that this value should be lower than the minimum
height of \code{treepos}.}

\item{minTreeAltParam}{character. code for the percentile that is used as tree height treshold. It is build using the key letters \code{chmQ} and adding the percentile i.e. "10". Default is \code{chmQ20}}

\item{maxCrownArea}{numeric. A single value of the maximum individual tree crown radius expected. Default 10.0 m.}

\item{leafsize}{integer. bin size of grey value sampling range from 1 to 256 see also: \href{http://www.saga-gis.org/saga_tool_doc/6.2.0/imagery_segmentation_3.html}{SAGA GIS Help}}

\item{normalize}{integer. logical switch if data will be normalized (1) see also: \href{http://www.saga-gis.org/saga_tool_doc/6.2.0/imagery_segmentation_3.html}{SAGA GIS Help}}

\item{neighbour}{integer. von Neumanns' neighborhood (0) or Moore's (1) see also: \href{http://www.saga-gis.org/saga_tool_doc/6.2.0/imagery_segmentation_3.html}{SAGA GIS Help}}

\item{method}{integer. growing algorithm for feature space and position (0) or feature space only (1), see also: \href{http://www.saga-gis.org/saga_tool_doc/6.2.0/imagery_segmentation_3.html}{SAGA GIS Help}}

\item{thVarFeature}{numeric. Variance in Position Space  see also: \href{http://www.saga-gis.org/saga_tool_doc/6.2.0/imagery_segmentation_3.html}{SAGA GIS Help}}

\item{thVarSpatial}{numeric. Variance in Feature Space  see also: \href{http://www.saga-gis.org/saga_tool_doc/6.2.0/imagery_segmentation_3.html}{SAGA GIS Help}}

\item{thSimilarity}{mumeric. Similarity Threshold see also: \href{http://www.saga-gis.org/saga_tool_doc/6.2.0/imagery_segmentation_3.html}{SAGA GIS Help}}

\item{segmentationBands}{character. a list of raster data that is used for the segmentation. The canopy height model \code{c("chm")} is mandantory. see also: \href{http://www.saga-gis.org/saga_tool_doc/6.2.0/imagery_segmentation_3.html}{SAGA GIS Help}}

\item{majorityRadius}{numeric. kernel size for the majority filter out spurious pixel}

\item{giLinks}{list. of GI tools cli paths}
}
\description{
Tree segmentation based on a CHM, basically returns a vector data set with the tree crown geometries and a bunch of corresponding indices. After the segementation itself, the results are hole filled and optionally, it can be filtered by a majority filter.
}
\examples{
## ## ##
##- required packages
require(uavRst)
require(link2GI)
##- linkages
##- create and check the links to the GI software
giLinks<-uavRst::linkAll()
if (giLinks$saga$exist & giLinks$otb$exist & giLinks$grass$exist) {

##- project folder
projRootDir<-tempdir()

##- create subfolders please mind that the pathes are exported as global variables
paths<-link2GI::initProj(projRootDir = projRootDir,
                         projFolders = c("data/","data/ref/","output/","run/","las/"),
                         global = TRUE,
                         path_prefix = "path_")
##- overide trailing backslash issue
 path_run<-ifelse(Sys.info()["sysname"]=="Windows", sub("/$", "",path_run),path_run)
 setwd(path_run)
 unlink(paste0(path_run,"*"), force = TRUE)

##- get the data
utils::download.file("https://github.com/gisma/gismaData/raw/master/uavRst/data/tutorial.zip",
                      paste0(path_run,"tutorial.zip"))
unzip(zipfile = paste0(path_run,"tutorial.zip"), exdir = path_run)

##- read chm data
chmR<- raster::raster(paste0(path_run,"chm_2.tif"))
tPos<- raster::raster(paste0(path_run,"treepos_2.tif"))

##- tree segmentation
crowns_GWS <- chmseg_GWS( treepos = tPos,
                      chm = chmR,
                      minTreeAlt = 3,
                      neighbour = 0,
                      thVarFeature = 1.,
                      thVarSpatial = 1.,
                      thSimilarity = 0.00001,
                      giLinks = giLinks )

##- visualize it
mapview::mapview(crowns_GWS,zcol="chmMEAN")
}
##+
}
\author{
Chris Reudenbach
}

library(sf) # needed for spatial analysis
# read multipolygon object
co_zcta <- sf::st_read("./data/co_zcta/Colorado_ZIP_Code_Tabulation_Areas_ZCTA.shp")
plot(st_geometry(co_zcta))
# read data frame
co_points <- read.csv("./data/usgs_data_series_520_clean.csv")
# convert to sf object
co_points <- sf::st_as_sf(co_points, coords = c("longitude", "latitude"))
# set crs of co_points to same crs as co_zcta
co_points <- sf::st_set_crs(co_points, sf::st_crs(co_zcta))

# plot geometry
plot(st_geometry(co_zcta))
# plot points on polygons
plot(st_geometry(co_points), add = TRUE, pch = 19, col = "orange", cex = 0.5)

# for point-level analysis
# determine the polygon of co_zcta each points is in
within  <- sf::st_within(co_points, co_zcta)
# double-check that each point is in at most 1 region
range(sapply(within, length))
# since the point should only intersect a single region, convert to number
within <- as.numeric(within)
# double-check that length(within) matches number of points
# add within column to co_points
length(within)
length(st_geometry(co_points))
# add within column to co_points data frame
co_points$within  <- sf::st_within(co_points, co_zcta)

# for regional level analysis
# count number of points in each region
# determine which points are in which polygon of co_zcta
region_count  <- sf::st_contains(co_zcta, co_points)
# convert list of points to count
region_count <- sapply(region_count, length)
# make sure number of regions matches number of counts
length(st_geometry(co_zcta))
length(region_count)
# add region_count to co_zcta
co_ztca$region_count <- region_count


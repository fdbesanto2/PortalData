source("../DataCleaningScripts/new_weather_data.R")
library(testthat)
context("checks new weather data")

data=new_met_data()
newdata = data[[1]]
newdata_cols = colnames(newdata)
weather = data[[2]]
weather_cols = colnames(weather)
stormsnew = data[[3]]
stormsnew_cols = colnames(stormsnew)
storms = data[[4]]
storms_cols = colnames(storms)

test_that("required column names in new weather df", {
  
  expect_identical(weather_cols, newdata_cols)
  expect_identical(storms_cols, stormsnew_cols)
})

test_that("Hour in 100:2400", {
  
  expect_true(all(newdata$hour %in% seq(from=100,to=2400,by=100)))
})

test_that("Air Temperature ok", {

  expect_true(all(newdata$airtemp > -30))
  expect_true(all(newdata$airtemp <= 100))
})

test_that("Relative humidity ok", {

  expect_true(all(newdata$RH > 0))
  expect_true(all(newdata$RH < 100))
})

test_that("battery status ok", {
  
  expect_true(all(newdata$battV > 9))
  expect_true(all(storms$battV > 9))
})

test_that("Precipitation ok", {
  
  expect_true(all(newdata$precipitation >= 0))
  expect_true(all(newdata$precipitation < 100))
  expect_true(all(stormsnew$Rain_mm_Tot >= 0))
  expect_true(all(stormsnew$Rain_mm_Tot < 10))
})

test_that("Precipitation in multiples of 0.254", {
  
  expect_true(sum(newdata$precipitation%%0.254)==0)
  expect_true(sum(stormsnew$Rain_mm_Tot%%0.254)==0)
})


test_that("start of new data lines up with end of existing data", {
  
  expect_identical(tail(weather$timestamp,n=1)+3600,newdata$timestamp[1])
})

test_that("no hours missing", {
  
  expect_true(sum(diff(newdata$timestamp)!=1)==0)
})

test_that("no identical rows in newdata and weather", {
  
  expect_true(sum(duplicated(dplyr::bind_rows(weather,newdata)))==0)
})

test_that("no identical rows in new storm data and storms", {
  
  expect_true(sum(duplicated(dplyr::bind_rows(storms,stormsnew)))==0)
})



# Here's and example of a merge conflict.
library(tidyverse)
library(NHANES)


# R basics ----------------------------------------------------------------

weight_kilos <- 100
weight_kilos
weight_kilos <- 20
weight_kilos <- 100
weight_kilos

colnames(airquality)

str(airquality)
summary(airquality)

# testing styling with "2+2" (notice lack of spaces)
# highlight code -> "code" -> reformat code
2 + 2
# command + shift + p -> style active
2 + 2

# This will be used for testing out Git

# Looking at data ---------------------------------------------------------

glimpse(NHANES)
# glimpse(LIBRARY) gives a glimpse at the data
# int = integer
# fct = factor
# dbl = number with decimals
# data object is always first: all functions have arguments (settings you give it)

select(NHANES, Age)
# select without assigning: we're just showing it on the screen (console)

select(NHANES, Age, Weight)
# showing multiple columns from the dataset separated by a comma (,)

select(NHANES, -Age, -HeadCirc)
# select and exclude by using a minus (-) befor the column you want to exclude

colnames(NHANES)
# colnames (LIBRARY/DATASET): checks the headings of columns

select(NHANES, starts_with("BP"))
# remember citation marks around text!
# other commands: ends_with ("TEXT"), contains("")

select(NHANES, contains("Day"), -contains("Phys"))
# can be combained with exclude (-) and multiple (,)

# create new object
nhanes_small <- select(
  NHANES,
  Age,
  Gender,
  BMI,
  Diabetes,
  PhysActive,
  BPSysAve,
  BPDiaAve,
  Education
)
# check that new object contains what you want it to: name of object and command + enter
nhanes_small

# style code: command + shift + p: style


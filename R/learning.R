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


# Fixing variable names ---------------------------------------------------

# first object = dataset, rename to snakecase (without parentheses! Give it an object, not action (?))
nhanes_small <- rename_with(
  nhanes_small,
  snakecase::to_snake_case
)

# check dataset
nhanes_small

# look at the dataset in Environment! Shows the whole table

# rename one variable: new name first, old name last!
nhanes_small <- rename(
  nhanes_small,
  sex = gender
)


# Piping of NHANES --------------------------------------------------------

# traditional look
colnames(nhanes_small)

# piping (shortcut command + shift + M), places data in first position
nhanes_small %>%
  colnames()

# rename with pipe
nhanes_small %>%
  select(phys_active) %>%
  rename(physically_active = phys_active)

# exercise 7.8 on course web page
nhanes_small %>%
  select(bp_sys_ave, education)

nhanes_small %>%
  rename(
    bp_sys = bp_sys_ave,
    bp_dia = bp_dia_ave
  )

# Re-write this piece of code using the “pipe” operator:
# select(nhanes_small, bmi, contains("age"))
# contains has to be within "select"!
nhanes_small %>%
  select(bmi, contains("age"))

# rewrite:
# blood_pressure <- select(nhanes_small, starts_with("bp_"))
# rename(blood_pressure, bp_systolic = bp_sys)
nhanes_small %>%
  select(starts_with("bp_")) %>%
  rename(bp_systolic = bp_sys_ave)
# OBS! Typo in the task: since the code hasn't saved nhanes_small as a new object, you need to write bp_sys_ave and NOT bp_sys as in the original task code!


# Filtering rows ----------------------------------------------------------

# Table 7.1 on course home page is a good summary of logic commands for filtering
# Be careful of OR and AND!

# "filter" uses logic to keep rows that are true and drops those that are false
# Be careful with your logic use! doublecheck with somebody else so you don't make mistakes

# == translates to "is equal to"
nhanes_small %>%
  filter(phys_active == "No")

# != excludes, "is not equal to…"
nhanes_small %>%
  filter(phys_active != "No")

# >= "greater or equal to"
nhanes_small %>%
  filter(bmi >= 25)

# add logic commands!
# comma (",") = "&" in filtering!
nhanes_small %>%
  filter(bmi >= 25 &
    phys_active == "No")

# "comma (",") = "&" in filtering!"or = |
nhanes_small %>%
  filter(bmi == 25 |
    phys_active == "No")
# Be careful around using "or"!


# Arranging rows ----------------------------------------------------------

# Look into arranging stuff (commands etc.)
nhanes_small %>%
  arrange(desc(age), bmi)


# Mutating columns --------------------------------------------------------

# Mutate adds things sequentially, you don't have to do several separate commands but can put all in one brackets
# Remember: new thing = old thing!
nhanes_update <- nhanes_small %>%
  mutate(
    age_months = age * 12,
    logged_bmi = log(bmi),
    age_weeks = age_months * 4,
    old = if_else(
      age >= 35,
      "old",
      "young"
    )
  )


# Exercise 7.12 -----------------------------------------------------------

# 1. BMI between 20 and 40 with diabetes
# nhanes_small %>%
# Format should follow: variable >= number or character
#    filter(___ >= ___ & ___ <= ___ & ___ == ___)

# Pipe the data into mutate function and:
# nhanes_modified <- nhanes_small %>% # Specifying dataset
#    mutate(
# 2. Calculate mean arterial pressure
#        ___ = ___,
# 3. Create young_child variable using a condition
#        ___ = if_else(___, "Yes", "No")
#    )

# nhanes_modified

# filter data from existing dataset using columns and logic functions
nhanes_small %>%
  filter(bmi >= 20 & bmi <= 40 & diabetes == "Yes")

# pipe data into mutate
nhanes_modified <- nhanes_small %>% # specifying new dataset
  mutate(
    # calculate mean arterial pressure
    mean_arterial_pressure = ((2 * bp_dia_ave) + bp_sys_ave) / 3,
    # create new variable "young child" using if_else
    young_child = if_else(
      age <= 6,
      "young child",
      "old child"
    )
  )
nhanes_modified


# Split-apply-combine -----------------------------------------------------

# Summarize: answer NA because lack of missing values
nhanes_small %>%
  summarize(
    max_bmi = max(bmi)
  )
# Summarize: fix NA by excluding NA from dataset (?) CHECK UNDERSTANDING
nhanes_small %>%
  summarize(
    max_bmi = max(bmi, na.rm = TRUE)
  )

# Summarize: add min BMI
nhanes_small %>%
  summarize(
    max_bmi = max(bmi,
      na.rm = TRUE
    ),
    min_bmi = min(bmi,
      na.rm = TRUE
    )
  )

# Group_by
nhanes_small %>%
  group_by(diabetes) %>%
  summarize(
    max_bmi = max(bmi,
      na.rm = TRUE
    ),
    min_bmi = min(bmi,
      na.rm = TRUE
    )
  )

# Filter out NA: ! means "keep anything that's not missing in this column"
# Adding mean BMI
nhanes_small %>%
  filter(!is.na(diabetes)) %>%
  group_by(diabetes) %>%
  summarize(
    max_bmi = max(bmi,
      na.rm = TRUE
    ),
    min_bmi = min(bmi,
      na.rm = TRUE
    ),
    mean_bmi = mean(bmi,
      na.rm = TRUE
    )
  )

# Adding physically active to grouping
# Filter out NA from phys_active
nhanes_small %>%
  filter(!is.na(diabetes), !is.na(phys_active)) %>%
  group_by(
    diabetes,
    phys_active
  ) %>%
  summarize(
    max_bmi = max(bmi,
      na.rm = TRUE
    ),
    min_bmi = min(bmi,
      na.rm = TRUE
    ),
    mean_bmi = mean(bmi,
      na.rm = TRUE
    )
  )

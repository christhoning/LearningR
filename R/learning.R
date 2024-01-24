# Loading Packages --------------------------------------------------------
library(tidyverse)
library(NHANES)

glimpse(NHANES)
str(NHANES)


# Select Specific Columns  ------------------------------------------------

# Subselect columns
select(NHANES, Age, Weight, BMI)

# Remove columns
select(NHANES, -HeadCirc)

# Select columns that start with a specific prefix-
select(NHANES, starts_with("BP"))

# Select columns that end with a specific -suffix
select(NHANES, ends_with("Day"))

# Select columns that contains something specific
select(NHANES, contains("Age"))


# Renaming All Columns  ---------------------------------------------------

# Rename to snake_case
# without brackets to prevent the function to work right away, but instead do the function to each column separately
rename_with(NHANES, snakecase::to_snake_case)

# Save into object
NHANES_small <- rename_with(NHANES, snakecase::to_snake_case)


# Renaming Specific Columns -----------------------------------------------

NHANES_small <- rename(NHANES_small, sex = gender)
NHANES_small
View(NHANES_small)


# Chaining the Function with the Pipe -------------------------------------

colnames(NHANES_small)

# Using pipe
NHANES_small %>%
  colnames()

# Combining multiple functions into one command
NHANES_small %>%
  select(phys_active) %>%
  rename(physically_active = phys_active)

# Assigning
NHANES_phys <- NHANES_small %>%
  select(phys_active) %>%
  rename(physically_active = phys_active)



# Exercise 7.8 ------------------------------------------------------------

# Copy and paste the code below into the script file.
# Replace the ___ in the select() function, with the columns bp_sys_ave, and education.
NHANES_small %>%
  select(bp_sys_ave, education)

# Copy and paste the code below and fill out the blanks.
# Rename the bp_ variables so they don’t end in _ave, so they look like bp_sys and bp_dia.
# Tip: Recall that renaming is in the form new = old.
NHANES_small %>%
  rename(
    bp_sys = bp_sys_ave,
    bp_dia = bp_dia_ave
  )

# Re-write this piece of code using the “pipe” operator:
select(nhanes_small, bmi, contains("age"))

NHANES_small %>%
  select(bmi, contains("age"))

# Read through (in your head) the code below.
# How intuitive is it to read?
# Now, re-write this code so that you don’t need to create the temporary blood_pressure object by using the pipe, then re-read the revised version.
# Which do you feel is easier to “read”?

blood_pressure <- select(nhanes_small, starts_with("bp_"))
rename(blood_pressure, bp_systolic = bp_sys_ave)

NHANES_small %>%
  select(starts_with("bp_")) %>%
  rename(bp_systolic = bp_sys_ave)



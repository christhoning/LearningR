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


# Filtering Data by Row  --------------------------------------------------

filter(NHANES_small, phys_active == "No")

# Filter with "equal to"
NHANES_small %>%
  filter(phys_active == "No")

# Filter with "not equal to"
NHANES_small %>%
  filter(phys_active != "No")

NHANES_small %>%
  filter(bmi == 25)

# Filter with "greater than or equal to"
NHANES_small %>%
  filter(bmi >= 25)

# Filter with "and"
TRUE & TRUE
TRUE & FALSE
FALSE & FALSE

# Filter with "or"
TRUE | TRUE
TRUE | FALSE
FALSE | FALSE

# BE very careful when using logical operators
# ALWAYS verify filtering after using logical operators
# with large datasets, the select function can be used to verify (by only showing the columns used in the filtering)

# Example "and"
NHANES_small %>%
  filter(bmi == 25 & phys_active == "No") %>%
  select(bmi, phys_active)

# Example "or"
NHANES_small %>%
  filter(bmi == 25 | phys_active == "No") %>%
  select(bmi, phys_active)


# Arranging the rows  -----------------------------------------------------

# Arranging by age
# Numerical value, therefore arranging by ascending number
NHANES_small %>%
  arrange(age)

# Arranging by
# Character value, therefor arranging by ascending letters
NHANES_small %>%
  arrange(education) %>%
  select(education)

# Arrange age by descending
NHANES_small %>%
  arrange(desc(age)) %>%
  select(age)

# Arrange by multiple factors/values
NHANES_small %>%
  arrange(age, education)


# Transform or Add Columns  -----------------------------------------------

NHANES_small %>%
  mutate(age = age * 12)

NHANES_small %>%
  mutate(
    age = age * 12,
    logged_bmi = log(bmi)
  ) %>%
  select(age, logged_bmi)

# Create a new column using if_else
# if_else has 3 arguments, 1. condition, 2. what to write is condition is true, 3. what to write if the condition is false
NHANES_small %>%
  mutate(
    old = if_else(age >= 30, "Yes", "No")
  ) %>%
  select(old)



# Exercise 7.12  ----------------------------------------------------------

# Filter nhanes_small so only those participants with a BMI of more than or equal to 20 and less than or equal to 40, and keep those who have diabetes.

# Create a new variable called mean_arterial_pressure by applying the formula:
    # (DBP = bp_dia_ave and SBP = bp_sys_ave) to calculate Mean Arterial Pressure.
    # Hint: In R, use + to add, * to multiply, and / to divide.

# Create a new variable called young_child for cases where age is less than 6 years.

# Finally, add and commit these changes to the Git history with the RStudio Git Interface.

# Push to GitHub to synchronize with your GitHub repository.


# 1. BMI between 20 and 40 with diabetes
NHANES_small %>%
  # Format should follow: variable >= number or character
  filter(bmi >= 20 & bmi <= 40 & diabetes == "Yes")

# Pipe the data into mutate function and:
nhanes_modified <- NHANES_small %>% # Specifying dataset
  mutate(
    # 2. Calculate mean arterial pressure
    mean_arterial_pressure = ((2 * bp_dia_ave) + bp_sys_ave) / 3,
    # 3. Create young_child variable using a condition
    young_child = if_else(age < 6, "Yes", "No")
  )

nhanes_modified


# Calculating Summary Statistics ------------------------------------------

# getting the maximum bmi
NHANES_small %>%
    summarise(max_bmi = max(bmi))

# exclude NA values
NHANES_small %>%
    summarise(max_bmi = max(bmi, na.rm = TRUE),
              min_bmi = min(bmi, na.rm = TRUE))

result <- NHANES_small %>%
    summarise(max_bmi = max(bmi, na.rm = TRUE),
              min_bmi = min(bmi, na.rm = TRUE))


# Summary Statistics by a Group -------------------------------------------

NHANES_small %>%
    group_by(diabetes) %>%
    summarise(mean_age = mean(age, na.rm = TRUE),
              mean_bmi = mean(bmi, na.rm = TRUE))

# Filter out NA's
NHANES_small %>%
    filter(!is.na(diabetes)) %>%
    group_by(diabetes) %>%
    summarise(mean_age = mean(age, na.rm = TRUE),
              mean_bmi = mean(bmi, na.rm = TRUE))

# Group by multiple factors
NHANES_small %>%
    filter(!is.na(diabetes)) %>%
    group_by(diabetes, phys_active) %>%
    summarise(mean_age = mean(age, na.rm = TRUE),
              mean_bmi = mean(bmi, na.rm = TRUE)) %>%
    ungroup()


# Saving Dataset as a File ------------------------------------------------

readr::write_csv(NHANES_small,
                here::here("data/NHANES_small.csv"))

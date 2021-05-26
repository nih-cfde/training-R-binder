# This script file contains code and comments for follow along for the Intro to R CFDE workshop in June 2021

# Instructor to discuss the RStudio IDE panes

# Load libraries
library(dplyr)
library(readr)
library(ggplot2)

# Read data file
experiment_info <- read_tsv(file = 'https://osf.io/pzs7g/download/')

## how big is the data set ?
dim(experiment_info)
#
# examine the first 6 rows across all columns of the data
head(experiment_info)

# Instructor Switch
# Instructor to discuss data types in R

## what type of data structure is this ?
class(experiment_info) 

# Instructor to discuss data structures in R

# Create a vector 
a260_vector <- experiment_info$A260

## confirm the data structure
class(a260_vector)

## get the data type of the vector
typeof(a260_vector)

# Access elements in a vector

## obtain the fifth element in the vector
a260_vector[5]

## subset the fifth and tenth element
a260_vector[c(5,10)]

## subset the fifth through tenth elements
a260_vector[c(5:10)]

# Exercise 1
## Generate a vector containing the yeast strain.

# Create a matrix

## create a matrix by subsetting the data frame by selecting the appropriate columns by column names
yeast_strain_matrix <- data.matrix(experiment_info[,c(`Nucleic Acid Conc.`,
                                                      `260/280`,
                                                      `Total RNA`)])

## view the data
head(yeast_strain_matrix)

## confirm data type
class(yeast_strain_matrix)

# Data Wrangling with dplyr

## clean experimental data with select
experiment_info_cleaned <- select(experiment_info,                                                                           Sample, 
                                  Yeast Strain, 
                                  Nucleic Acid Conc., 
                                  Unit, 
                                  A260, 
                                  A280,
                                  260/280,
                                  Total RNA,
                                  X9)
## remember, since R cannot parse spaces in column names, we need to enclose them in back commas to indicate that these words belong together.

experiment_info_cleaned <- select(experiment_info,                                                                            Sample, 
                                  `Yeast Strain`, 
                                  `Nucleic Acid Conc.`, 
                                  Unit, 
                                  A260, 
                                  A280,
                                  260/280,
                                  `Total RNA`,
                                  X9)

## as a general rule, it is best to avoid column names that start with a number; we can use back commas for this column name.

experiment_info_cleaned <- select(experiment_info,                                                                            Sample, 
                                  `Yeast Strain`, 
                                  `Nucleic Acid Conc.`, 
                                  Unit, 
                                  A260, 
                                  A280,
                                  `260/280`,
                                  `Total RNA`,
                                  X9)

## check the dimensions of the subsetted dataframe
dim(experiment_info_cleaned)

# Exercise 2
## Select the columns Sample, Yeast Strain, A260 and A280 and assign that to a new object called experiment_data.

# Instructor to discuss conditional subsetting and filter()

filter(experiment_info_cleaned, `Nucleic Acid Conc.` > 1500)
filter(experiment_info_cleaned, `260/280` >= 2.1 & `Nucleic Acid Conc.` > 1500)

# Exercise 3
## Create a new object called wt_high_conc that contains data from WT strains and contain nucleic acid concentration of more than 1500 ng/uL.

# Pipes
## enables applying multiple actions/verbs at once

experiment_info_wt <- experiment_info_cleaned %>% 
                      filter(`Yeast Strain` == 'WT' & 
                               `Nucleic Acid Conc.` > 1500) %>% 
                      select(Sample,
                             `Yeast Strain`,
                             A260, 
                             A280)

# mutate()
## useful for creating new columns
experiment_info_wnewcolumn <- mutate(experiment_info_cleaned, 
                                     conc_ug_uL = `Nucleic Acid Conc.`/1000) 

# Exercise 4 (Bonus)
## Create a new table called library_start that includes the columns sample, yeast strain and two new columns called RNA_100 with the calculation of microliters to have 100ng of RNA and another column called water that says how many microliters of water we need to add to that to reach 50uL.

# Split-apply-combine
## concept where we split data by groups, analyze and combine the results

## group_by() takes as argument the column name/s that contain categorical variables that can used to group the data 
## summarize() creates summary statistics
experiment_info_cleaned %>% 
  group_by(`Yeast Strain`) %>% 
  summarize(mean_concentration = mean(`Nucleic Acid Conc.`))

## summarize using more than one column
experiment_info_cleaned %>% 
  group_by(`Yeast Strain`) %>% 
  summarize(mean_concentration = mean(`Nucleic Acid Conc.`),
            mean_total_RNA = mean(`Total RNA`))

# arrange() to sort results
## arrange new table in ascending mean concentrations
experiment_info_cleaned %>% 
  group_by(`Yeast Strain`) %>% 
  summarize(mean_concentration = mean(`Nucleic Acid Conc.`),
            mean_total_RNA = mean(`Total RNA`)) %>% 
  arrange(mean_concentration) 

## arrange new table in descending mean concentrations 
experiment_info_cleaned %>% 
  group_by(`Yeast Strain`) %>% 
  summarize(mean_concentration = mean(`Nucleic Acid Conc.`),
            mean_total_RNA = mean(`Total RNA`)) %>% 
  arrange(desc(mean_concentration)) 

# count() to get the number of categorical values
experiment_info_cleaned %>% 
  count(`Yeast Strain`)

# Exercise 5 (Bonus)
## Calculate the mean value for A260/A280 for each of the yeast strains. Can these sample be used for downstream analysis ?

# Instructor Switch
# Plotting with ggplot

## current column names
colnames(experiment_info_cleaned)

## new names specified with a vector
colnames(experiment_info_cleaned) <- c('Sample',
                                       'Yeast_strain',
                                       'Nucleic_Acid_Conc.',
                                       'ng/ul', 
                                       'A260',
                                       'A280', 
                                       'A260_280',
                                       'Total_RNA',
                                       'ugm')

## ggplot syntax
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=Total_RNA, 
                   y=Nucleic_Acid_Conc.)) 

## making a scatter plot
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=Total_RNA, 
                   y=Nucleic_Acid_Conc.)) +
  geom_point() +
  ggtitle('Scatter plot')

## making points transparent and changing size
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=Total_RNA,
                   y=Nucleic_Acid_Conc.)) +
  geom_point(alpha=0.6, 
             size=4) +
  ggtitle('Scatter with transparent points')

## color by strain and size by A260/A280 ratio
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=Total_RNA, 
                   y=Nucleic_Acid_Conc., 
                   fill=Yeast_strain,
                   size=A260_280)) +
  geom_point(alpha=0.6, 
             pch=21, 
             col='white') +
  ggtitle('Scatter: color by strain \n and size by 260/280 ratio')

## check number of strains
unique(experiment_info_cleaned$Yeast_strain)

## boxplot by strain
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=Yeast_strain, 
                   y=Total_RNA)) +
  geom_boxplot() +
  ggtitle('Boxplot')

## boxplot with points
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=Yeast_strain,
                   y=Total_RNA)) +
  geom_point(alpha=0.6) +
  geom_boxplot() +
  ggtitle('Boxplot with points')

# Exercise 6
## What happens if you reverse the order of the `geom_point()` and `geom_boxplot()` functions for the boxplot code above?

# Exercise 7
## What happens if you use `geom_jitter()` instead of `geom_point()`?
## Reference: https://ggplot2.tidyverse.org/reference/geom_jitter.html

# More plot modifications

## modify axis label text with xlab() and ylab()
## split the plots by categorical variable using facet_wrap() or facet_grid()
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=Total_RNA, 
                   y=Nucleic_Acid_Conc.,
                   col=Yeast_strain)) +
  geom_point() +
  facet_wrap(~Yeast_strain) +
  xlab('Total RNA (ugm)') +
  ylab('Nucleic Acid Conc. (ng/ul)') +
  ggtitle('Facet scatter plot')

# Exercise 8
##  Try making a histogram (`geom_histogram()`) and a density plot (`geom_density()`) of the `A260_280` ratio values.

# Save plots
## use ggsave and specify image resolution, dimensions and type
myplot <- ggplot(data=experiment_info_cleaned, 
                 mapping=aes(x=A260_280, 
                             fill=Yeast_strain))+
  geom_density(alpha=0.6) +
  facet_grid(Yeast_strain~.) +
  scale_fill_manual(values = c("cornflowerblue", 
                               "goldenrod2")) +
  theme_bw() +
  ggtitle('Density plot')

## view the plot
myplot

## save the plot
ggsave(filename='mydensityplot.jpg', 
       plot=myplot, 
       height=4, 
       width=4, 
       units='in', 
       dpi=600)

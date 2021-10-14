# This script file contains code and comments for follow along for the Intro to R CFDE workshop in October 2021

# Instructor to discuss the RStudio IDE panes

# Load libraries
## note loading libraries is important to ensure commands used in the following script work without errors. You may notice error like "could not find function <name of the function>
library(dplyr)
library(readr)
library(ggplot2)

# Read data file

experiment_info <- read.delim(file = '~/sample_details.tsv', 
                              check.names=FALSE)

## how big is the data set ?
dim(experiment_info)

## Check the column names
colnames(experiment_info)

# examine the first 6 rows across all columns of the data
head(experiment_info)

## Toggle to notes!

# Data Wrangling with dplyr

## If you missed the first step, remember to load the dplyr package
library(dplyr)

## Let’s create a subset of data without those empty columns using the select function.
experiment_info_cleaned <- select(experiment_info,                                   
                                  Sample, 
                                  Yeast Strain, 
                                  Nucleic Acid Conc., 
                                  Unit, 
                                  A260, 
                                  A280,
                                  260/280,
                                  Total RNA,
                                  X9)

## remember, since R cannot parse spaces in column names, we need to enclose them in backticks to indicate that these words belong together.

experiment_info_cleaned <- select(experiment_info,                                                                  
                                  Sample, 
                                  `Yeast Strain`, 
                                  `Nucleic Acid Conc.`, 
                                  Unit, 
                                  A260, 
                                  A280,
                                  260/280,
                                  `Total RNA`,
                                  X9)

## as a general rule, it is best to avoid column names that start with a number; we can use backticks for this column name.

experiment_info_cleaned <- select(experiment_info,                                                                            
                                  Sample, 
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

## current column names
colnames(experiment_info_cleaned)

## new names specified with a vector
colnames(experiment_info_cleaned) <- c('Sample',
                                       'Yeast_Strain',
                                       'Nucleic_Acid_Conc.',
                                       'ng/ul', 
                                       'A260',
                                       'A280', 
                                       'A260_280',
                                       'Total_RNA',
                                       'ugm')

# Exercise 1
## Select the columns Sample, Yeast Strain, A260 and A280 and assign them to a new object called “experiment_data”.

# Instructor to discuss conditional subsetting and filter()

filter(experiment_info_cleaned, 
       Nucleic_Acid_Conc. > 1500)

filter(experiment_info_cleaned, 
       A260_280 >= 2.1 & 
         Nucleic_Acid_Conc. > 1500)

# mutate()
## useful for creating new columns
experiment_info_wnewcolumn <- mutate(experiment_info_cleaned, 
                                     conc_ug_uL=Nucleic_Acid_Conc./1000) 


# Pipes
## enables applying multiple actions/verbs at once

experiment_info_wt <- experiment_info_cleaned %>% 
                      filter(Yeast_Strain == 'WT' & 
                               Nucleic_Acid_Conc. > 1500) %>% 
                      select(Sample,
                             Yeast_Strain,
                             A260, 
                             A280)

# Exercise 2 
## Create a new data table called exp_info_wrangled and only keep the samples that have 260/280 ratio values < 2.15. 
## Add a new column called total_RNA_in_nano_grams that has total RNA in nano grams. Include the columns sample, 
## yeast strain and 260/280 and Total_RNA_in_nano_grams


# Instructor Switch !

# Plotting with ggplot

## If you missed the first step, remember to load the ggplot2 package
library(ggplot2)

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
                   fill=Yeast_Strain,
                   size=A260_280)) +
  geom_point(alpha=0.6, 
             pch=21, 
             col='white') +
  ggtitle('Scatter: color by strain \n and size by 260/280 ratio')

## check number of strains
unique(experiment_info_cleaned$Yeast_Strain)

## boxplot by strain
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=Yeast_Strain, 
                   y=Total_RNA)) +
  geom_boxplot() +
  ggtitle('Boxplot')

## boxplot with points
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=Yeast_Strain,
                   y=Total_RNA)) +
  geom_point(alpha=0.6) +
  geom_boxplot() +
  ggtitle('Boxplot with points')

# Exercise 3
## What happens if you reverse the order of the `geom_point()` and `geom_boxplot()` functions for the boxplot code above?

# Exercise 4
## What happens if you use `geom_jitter()` instead of `geom_point()`?
## Reference: https://ggplot2.tidyverse.org/reference/geom_jitter.html

# More plot modifications

## modify axis label text with xlab() and ylab()
## split the plots by categorical variable using facet_wrap() or facet_grid()
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=Total_RNA, 
                   y=Nucleic_Acid_Conc.,
                   col=Yeast_Strain)) +
  geom_point() +
  facet_wrap(~Yeast_Strain) +
  xlab('Total RNA (ugm)') +
  ylab('Nucleic Acid Conc. (ng/ul)') +
  ggtitle('Facet scatter plot')

# Exercise 5
##  Try making a histogram (`geom_histogram()`) and a density plot (`geom_density()`) of the `A260_280` ratio values.

# Save plots
## use ggsave and specify image resolution, dimensions and type
myplot <- ggplot(data=experiment_info_cleaned, 
                 mapping=aes(x=A260_280, 
                             fill=Yeast_Strain))+
  geom_density(alpha=0.6) +
  facet_grid(Yeast_Strain~.) +
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

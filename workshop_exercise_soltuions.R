# Solutions to workshop exercises

# Exercise 1

yeast_strain_vector <- experiment_info$Yeast Strain

## the above code with result in error because R cannot parse spaces in column name. We need to add back command around the name of the column.

yeast_strain_vector <- experiment_info$`Yeast Strain`

# Alternatively, you could also use the index of the column:

## dataframe[row number, column number]
## subset based on column index
yeast_strain_vector <- experiment_info[,1]

# Exercise 2
## create new object
experiment_data <-  select(experiment_info_cleaned, 
                           Sample, 
                           `Yeast Strain`,
                           A260, 
                           A280)
## check the data
head(experiment_data)

# Exercise 3
## create new object
wt_high_conc<- filter(experiment_info_cleaned, 
                      `Yeast Strain` == 'WT' & 
                        `Nucleic Acid Conc.` > 1500)

## check the data
head(wt_high_conc)

# Exercise 4
## create data object
library_start <- experiment_info %>% 
  mutate(RNA_100 = 100/ `Nucleic Acid Conc.`,
         water = 50 - RNA_100) %>% 
  select(Sample,
         `Yeast Strain`,
         RNA_100, 
         water) 

## check the data
head(library_start)

# Exercise 5
## calculate mean values
experiment_info_cleaned %>% 
  group_by(`Yeast Strain`) %>% 
  summarize(mean_ratio = mean(`260/280`))

# Exercise 6
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=Yeast_strain, 
                   y=Total_RNA)) +
  geom_boxplot() +
  geom_point(alpha=0.6) +
  ggtitle('Boxplot with points reversed')

## In the original code, the points are plotted first, then the boxplot. If we reverse the order, the points will be plotted on top of the boxplot.

# Exercise 7
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=Yeast_strain, y=Total_RNA)) +
  geom_jitter(alpha=0.6) +
  geom_boxplot() +
  ggtitle('Boxplot with points')

## `geom_jitter()` 'jitters' the points so they are not overlapping as much.

# Exercise 8
## basic histogram code
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=A260_280))+
  geom_histogram(bins=20) +
  ggtitle('Histogram')

## you may need to modify the bin size

## modify the histogram by plotting by strain type
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=A260_280, 
                   fill=Yeast_strain))+
  geom_histogram(bins=20, 
                 col='black') +
  ggtitle('Histogram by strain')

## facet the histogram plot by strain
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=A260_280, 
                   fill=Yeast_strain))+
  geom_histogram(bins=20, 
                 col='black') +
  facet_grid(Yeast_strain~.) + #this sets whether the facet is horizontal or vertical. here, we will get 2 rows of histograms by yeast strain
  ggtitle('Facet histogram')

## adding custom color to histogram plot
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=A260_280,
                   fill=Yeast_strain))+
  geom_histogram(bins=20, 
                 col='black') +
  facet_grid(Yeast_strain~.) +
  scale_fill_manual(values = c("cornflowerblue", 
                               "goldenrod2")) + # Add blue and yellow colors that are more colorblind friendly for plotting
  ggtitle('Histogram with custom colors')

## color palettes reference: https://www.datanovia.com/en/blog/ggplot-colors-best-tricks-you-will-love/

## create density plot and change background
ggplot(data=experiment_info_cleaned, 
       mapping=aes(x=A260_280, 
                   fill=Yeast_strain))+
  geom_density(alpha=0.6) +
  facet_grid(Yeast_strain~.) +
  scale_fill_manual(values = c("cornflowerblue", 
                               "goldenrod2")) +
  theme_bw() +
  ggtitle('Density plot')

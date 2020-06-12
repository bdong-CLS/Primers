# Keyboard Shortcuts ------------------------------------------------------

# a menu with keyboard shortcuts: alt + shift + K 
# insert new section: ctrl + shift + r
# adding comment: ctrl + shift + c
# adding pipe operator: ctrl + shift + m
# adding assignment operator : alt + -
# restart R session : ctrl + shift + F10





# Installing packages -----------------------------------------------------

install.packages(c("ggplots", "forecast"))
install.packages("ggrepel")
install.packages("gapminder")
install.packages("maps")
install.packages("mapproj")
install.packages("hexbin")
install.packages("ggthemes")
install.packages("pryr")



# Loading libraries -------------------------------------------------------
library(tidyverse)
library(babynames)
library(ggrepel)
library(gapminder)

library(maps)
library(mapproj)
library(hexbin)
library(ggthemes)
library(viridis)
library(nycflights13)
library(pryr)






# Data Visualization Basics -----------------------------------------------
mpg

?ggplot


mpg%>%
  ggplot(aes(x = displ, y = hwy)) +
  geom_point()
  

ggplot(data = mpg) + 
  geom_boxplot(aes(class, hwy))


mpg%>%
  ggplot(aes(x = class, y = drv)) +
  geom_count()


mpg%>%
  ggplot(aes(x = displ, y = hwy, color = class)) +
  geom_point()


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color=class, size=class, shape = class))


# ggplot2 mapped the color of each point to TRUE or FALSE based on whther the point's `displ` value was less than five
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))



# make all of the points in the plot red
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "red")



# Setting works for every aesthetic in ggplot2. 
# If you want to manually set the aesthetic to a value in the visual space, 
# set the aesthetic outside of aes().

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "red", shape = 2, alpha = 0.5)



# If you want to map the aesthetic to a variable in the data space, map the aesthetic inside aes()

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class, shape = fl, alpha = displ))








# Programming basics ------------------------------------------------------

# see the code chunk of a function--not include parentheses 
sqrt
lm
cor


# see arguments of a function
args(lm)


# You can choose almost any name you like for an object, 
# as long as the name does not begin with a number or a special character 


# create a vector
c()
vec <- c(1:25)

# extract any element of a vector by placing a pair of brackets behind the vector
vec[10]

# use [] to extract multiple elements of a vector
vec[c(1,10,25)]


# If the elements of your vector have names, you can extract them by name
vec2 <- c(alpha = 1, beta = 2, gamma = 3)
vec2["gamma"]


# Vectorised operations
c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10) + c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)


# vector recycling
1 + c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)


# check type of vectors--one data type in a singel vector
typeof(vec2)



# list -- vectors of multiple data types 

a_list <- list(
  numbers = 1:100,
  strings = "apple",
  logicals = TRUE)

a_list$numbers[c(39,40)]


b_list <- list(1:100, "apple", TRUE)

b_list[2]
b_list[-1]

b_list[[1]][c(39,40)]



things <- list(number = 1001, logical = TRUE, string = "stories")

things[1]
things[[1]]





# create a data frame

nums <- c(1, 2, 3, 4)
logs <- c(TRUE, TRUE, FALSE, TRUE)
strs <- c("apple", "banana", "carrot", "duck")
df <- data.frame(numbers = nums, logicals = logs, strings = strs)

df$strings
df["strings"]





# Working with Tibbles: an enhanced type of data frame ----------------------------------------------------

babynames


# To see the entire tibble
view(babynames)


# check whether or not an object is a tibble
is_tibble(df)




# select() extracts columns of a data frame and returns the columns as a new data frame

babynames %>% 
  select(-prop)


select(babynames, one_of(c("sex", "name")))

select(babynames, contains("n"))




# filter() extracts rows from a data frame and returns them as a new data frame

babynames %>%
  filter(name == "Terry")

babynames %>%
  filter(prop >= 0.08)

babynames %>%
  filter(is.na(name))



# &	  Are both A and B true?	  A & B
# | 	Are one or both of A and B true?	  A | B
# !	  Is A not true?	!A
# xor()	  Is one and only one of A and B true?	  xor(A, B)
# %in%	  Is x in the set of a, b, and c?	  x %in% c(a, b, c)
# any()	  Are any of A, B, or C true? 	any(A, B, C)
# all()	  Are all of A, B, or C true?	  all(A, B, C)


filter(babynames, name %in% c("Acura", "Lexus", "Yugo"))

filter(babynames, n %in% c(40000:50000))



# arrange() returns all of the rows of a data frame reordered by the values of a column

babynames %>%
  arrange(n, desc(year))


babynames %>%
  arrange(desc(prop))



babynames %>%
  filter(sex == "M", year == 2017) %>%
  select(name, n, year, sex) %>%
  arrange(desc(n))



babynames %>%
  filter(name == "Derek", sex == "M") %>%
  ggplot(aes(year, prop)) +
  geom_smooth() +
  geom_point()




# Derive Information with dplyr -------------------------------------------

babynames %>% 
  filter(name == "Derek", sex == "M") %>% 
  summarize(total = sum(n))


# summarise() takes a data frame and uses it to calculate a new data frame of summary statistics.

babynames %>% 
  filter(name == "Derek", sex == "M") %>% 
  summarize(total = sum(n), max = max(n), min = min(n), median = median(n), zzz=sum(!is.na(n)))



babynames %>%
  summarize(n = n(), distinct = n_distinct(name))




# group_by() takes a data frame and then the names of one or more columns in the data frame. 
# It returns a copy of the data frame that has been “grouped” into sets of rows that
# share identical combinations of values in the specified columns.

babynames %>%
  group_by(year, sex, name) %>% 
  summarise(total = sum(n))


babynames %>%
  group_by(year, sex, name) %>% 
  summarize(total = sum(n)) %>% 
  summarize (total = sum(total)) %>% 
  summarize (total = sum(total)) 


babynames %>% 
  group_by(name, sex) %>% 
  summarize(total=sum(n)) %>%
  arrange(desc(total))



babynames %>%
  group_by(year) %>%
  summarise (total= sum(n)) %>%
  ggplot(aes(year, total)) +
  geom_line()



# mutate() uses a data frame to compute new variables--vectorized functions

babynames %>%
  mutate(percent = round(prop * 100, 2))


# summarise() expects summary functions, which take vectors of input and return single values. 
# mutate() expects vectorized functions, which take vectors of input and return vectors of values.

babynames %>%
  mutate(rank = min_rank(desc(prop))) %>%
  arrange(rank)


babynames %>% 
  group_by(year, sex) %>% 
  mutate(rank = min_rank(desc(prop))) %>%
  group_by(name, sex) %>%
  summarize(zzz = median(rank)) %>%
  arrange(zzz) %>% 
  print(n=500)



# How many distinct boys names acheived a rank of Number 1 in any year?

babynames %>% 
  group_by(year, sex) %>% 
  mutate(rank = min_rank(desc(prop))) %>%
  filter(sex == "M", rank == 1) %>%
  ungroup() %>%
  summarize(score = n_distinct(name))



number_ones <- c("John","Robert","James","Michael","David","Jacob","Noah","Liam") 

babynames %>% 
  filter(name %in% number_ones, sex == "M") %>% 
  ggplot(aes(year, prop, color = name)) +
  geom_line()


babynames %>% 
  group_by(sex, year) %>% 
  summarize (score = n_distinct(name))%>%
  ggplot(aes(year, score, color = sex)) +
  geom_line()



babynames %>% 
  group_by(sex, year) %>% 
  summarize (score = sum(n))%>%
  ggplot(aes(year, score, color = sex)) +
  geom_line()


babynames %>% 
  group_by(sex, year) %>% 
  summarize (score = sum(n))%>%
  ggplot(aes(year, score, color = sex)) +
  geom_line()


babynames %>% 
  group_by(sex, year) %>% 
  summarize (score = sum(n)/n_distinct(name))%>%
  ggplot(aes(year, score, color = sex)) +
  geom_line()







# Exploratory Data Analysis -----------------------------------------------
# 
# 1. What type of variation occurs within my variables?
# 2. What type of covariation occurs between my variables?


mpg %>% 
  ggplot(aes(x=class)) +
  geom_bar()
        
faithful %>%
  ggplot(aes(eruptions)) +
  geom_bar(binwidth = 0.25)

faithful %>%
  ggplot(aes(eruptions)) +
  geom_histogram()


# two categorical variables

diamonds %>% 
  group_by(color, cut) %>% 
  summarize (score=n()) %>%
  ungroup() %>%
  ggplot(aes(color, cut, fill = score))+
  geom_tile()


diamonds %>% 
  group_by(color, cut) %>% 
  ggplot(aes(color, cut))+
  geom_count()



# one continuous and one categorical variable

mpg %>%
  ggplot(aes(x = reorder(class, hwy, FUN= median), y=hwy))+
  geom_boxplot() 



# two continuous variables

faithful %>%
  ggplot(aes(eruptions, waiting)) +
  geom_point()


faithful %>%
  ggplot(aes(eruptions, waiting)) +
  geom_smooth()






# Bar Charts --------------------------------------------------------------

# map the heights of the bars not to counts, but to a variable in the data set

pressure %>%
  ggplot(aes(temperature, pressure))+
  geom_col()

ggplot(data = diamonds) +
  geom_bar(aes(x = cut, fill = cut), width = 0.8)


ggplot(data = diamonds) +
  geom_bar(aes(x = cut, fill = clarity))

ggplot(data = diamonds) +
  geom_bar(aes(x = cut, fill = clarity), position = "dodge")

ggplot(data = diamonds) +
  geom_bar(aes(x = cut, fill = clarity), position = "fill")


# facet_grid() will split the plot into facets vertically by the values of the first variable: 
# each facet will contain the observations that have a common value of the variable.
# facet_grid() will split the plot horizontally by values of the second variable.

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = color)) +
  facet_grid(. ~ cut)




# facet_wrap() wraps the single row of subplots that you would get with facet_grid() into multiple rows.

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = color, fill = cut)) +
  facet_wrap(. ~ cut)


ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = color, fill = cut)) +
  facet_wrap(. ~ cut, scales = "free_y")




# Histograms --------------------------------------------------------------


ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = .1)


ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), bins = 20)



ggplot(data = diamonds) +
  geom_freqpoly(mapping = aes(x = price, color = cut), binwidth = 1000, boundary = 0)




# Densities makes it easy to compare the distributions of sub-groups. 
# When you plot multiple sub-groups, each density curve will contain the same area under its curve
 
ggplot(data = diamonds) +
  geom_density(mapping = aes(x = price, color = cut))




# geom_dotplot() represents each observation with a dot and then stacks dots within bins to create the semblance of a histogram.

ggplot(data = mpg) +
  geom_dotplot(aes( displ), dotsize = 0.5, stackdir = "center", stackratio = 1.2)





# Boxplots and Counts -----------------------------------------------------

ggplot(data = diamonds) +
  geom_boxplot(aes(x = cut, y = price), outlier.shape  = 2, 
               outlier.fill = "white", outlier.stroke = 0.2, outlier.alpha = 1)


# cut_interval() which makes n groups with equal range
# cut_number() which makes n groups with (approximately) equal numbers of observations
# cut_width() which makes groups with width width


ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = carat, y = price, group = cut_width(carat, width = 0.2))) 



ggplot(data = mpg) +
  geom_dotplot(mapping = aes(x = class, y = hwy), binaxis = "y", 
               dotsize = 0.5, binwidth = 1, stackdir = "center")


ggplot(data = mpg) +
  geom_violin(mapping = aes(x = class, y = hwy), draw_quantiles = c(0.25, 0.5, 0.75))



ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = clarity))

diamonds %>% 
  count(cut, clarity)

# heat map

diamonds %>% 
  count(cut, clarity) %>%
  ggplot(aes(cut, clarity, fill = n))+
  geom_tile()





# Scatterplots ------------------------------------------------------------

# geom_text() and geom_label() create scatterplots that use words instead of points to display data


mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty = mean(cty), mean_hwy = mean(hwy)) %>% 
  ggplot() +
  geom_text(mapping = aes(x = mean_cty, y = mean_hwy, label = class))


mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty = mean(cty), mean_hwy = mean(hwy)) %>% 
  ggplot(aes(x = mean_cty, y = mean_hwy)) +
  geom_smooth(method = "glm") +
  geom_point()
  


mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty = mean(cty), mean_hwy = mean(hwy)) %>% 
  ggplot(aes(x = mean_cty, y = mean_hwy)) +
  geom_smooth(method = "glm") +
  geom_point() +
  geom_label_repel(aes(label = class))


ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(mapping = aes(color = class), se = FALSE)


# Global vs. Local data

mpg2 <- filter(mpg, class == "2seater")
mpg%>%
  ggplot(aes(displ, hwy)) +
  geom_point() +
  geom_point(data = mpg2, color = "Red")



# last_plot() returns the most recent plot call, which makes it easy to build up a plot one layer at a tim

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point()

last_plot() +
  geom_smooth(color = "maroon")




(plot1 <- mpg %>% 
  group_by(class) %>% 
  summarise(mean_cty = mean(cty), mean_hwy = mean(hwy)) %>% 
  ggplot(aes(x = mean_cty, y = mean_hwy)) +
  geom_smooth(method = "lm") +
  geom_point() +
  geom_label_repel(aes(label = class)))





# geom_rug() displays the one dimensional marginal distributions of each variable in the scatterplot

ggplot(data = faithful, aes(x = waiting, y = eruptions)) +
  geom_point() +
  geom_rug()


# geom_jitter() plots a scatterplot and then adds a small amount of random noise to each point in the plot

mpg %>%
  ggplot(aes(class, hwy)) +
  geom_jitter(width = 0.5, height = 0.5)




# coord_cartesian() - (the default) Cartesian coordinates
# coord_fixed() - Cartesian coordinates that maintain a fixed aspect ratio as the plot window is resized
# coord_flip() - Cartesian coordinates with x and y axes flipped
# coord_map() and coord_quickmap() - cartographic projections for plotting maps
# coord_polar() - polar coordinates
# coord_trans() - transformed Cartesian coordinates


ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut), width = 1) +
  coord_polar()


ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price)) +
  coord_trans(x = "log", y = "log")




# Line Plots and Maps --------------------------------------------------------------


# Like scatterplots, line graphs display the relationship between two continuous variables. 
# However, unlike scatterplots, line graphs expect the variables to have a functional relationship, 
# where each value of x is associated with only one value of y.

gapminder %>%
  filter (country %in% c("China", "Zimbabwe", "Japan", "Vietnam")) %>%
  ggplot (aes(year, gdpPercap)) +
  geom_line(aes(linetype = country, color = country))


# geom_step() draws a line chart in a stepwise fashion.
gapminder %>%
  filter (country %in% c("China", "Zimbabwe", "Japan", "Vietnam")) %>%
  ggplot (aes(year, gdpPercap)) +
  geom_step(aes(linetype = country, color = country))

# geom_area() is similar to a line graph, but it fills in the area under the line

gapminder %>%
  filter (country %in% c("China", "Zimbabwe", "Japan", "Vietnam")) %>%
  ggplot (aes(year, lifeExp)) +
  geom_area(aes(fill = country))



gapminder %>%
  filter (country %in% c("China", "Zimbabwe", "Japan", "Vietnam")) %>%
  ggplot (aes(year, lifeExp)) +
  geom_area(aes(fill = country), position = "identity", alpha = 0.5)


# geom_path() connects the points in the order that they appear in the data set

us <- map_data("state")

tx <- map_data("state", region = "Texas")

ggplot(tx) +
  geom_path(mapping = aes(x = long, y = lat))


# geom_polygon() extends geom_path() one step further: 
# it connects the last point to the first and then colors the interior region with a fill

ggplot(tx) +
  geom_polygon(aes(x = long, y = lat, fill = "Red"))

ggplot(us) +
  geom_polygon(aes(x = long, y = lat, group = group))



(USArrests2 <- USArrests %>% 
  rownames_to_column("region") %>% 
  mutate(region = tolower(region)))


ggplot(USArrests2) +
  geom_map(aes(map_id = region, fill = Murder), map = us) +
  expand_limits(x = us$long, y = us$lat) +
  coord_map(projection = "sinusoidal")




# Overplotting ------------------------------------------------------------

# Overplotting usually occurs for two different reasons:
#   
# 1. The data points have been rounded to a “grid” of common values
# 2. The dataset is so large that it cannot be plotted without points overlapping each other


diamonds %>%
  ggplot(aes(carat, price)) +
  geom_bin2d(bins = c(100, 50))

diamonds %>%
  ggplot(aes(carat, price)) +
  geom_hex()


diamonds %>%
  ggplot(aes(carat, price)) +
  geom_density2d() +
  expand_limits(x = diamonds$carat, y = diamonds$price)


diamonds %>%
  ggplot(aes(carat, price)) +
  geom_point(alpha = 0.1) +
  geom_density2d() 
  





# Customize Plots ---------------------------------------------------------

p <- diamonds %>%
  ggplot(aes(cut, price)) +
  geom_boxplot()

# clipping
p + ylim(0, 7500)


# zoom without clipping 
p + coord_flip(ylim = c(0, 7500))

p + coord_cartesian(ylim = c(0, 7500))


# titles
p + labs (title = "the title appears here", 
          subtitle = "the subtitle appears here", 
          caption = "captions at the bottom")


p1 <- ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
      geom_smooth(mapping = aes(color = cut), se = FALSE) + 
      labs(title = "Title",
       subtitle = "Subtitle",
       caption = "Caption")

# annotate

p1 + annotate("text", x = 3.5, y = 7500, label = "Comments")



# themes--the ggthemes package

p1 + theme_dark()

p1 + theme_stata()

p1 <- p1 + theme_bw()

p1 + scale_color_grey()

p1 +
  scale_x_log10() + 
  scale_y_log10()

RColorBrewer::display.brewer.all()


p1 + scale_color_brewer(palette = "Greens")   # scale_color_brewer() works with discrete variables


# Continuous colors: scale_color_distiller()

(p_cont <- ggplot(data = mpg) + 
  geom_jitter(mapping = aes(x = displ, y = hwy, color = hwy)) +
  theme_bw())

p_cont + scale_color_distiller(palette = "Accent")

p_cont + scale_color_viridis()
p_cont + scale_color_viridis(option = "A")



# legends 

# position of the legend within the graph
# the “type” of the legend, or whether a legend appears at all
# the title and labels in the legend


# theme() vs. themes

ggplot(data = mpg) + 
  geom_jitter(mapping = aes(x = displ, y = hwy, color = hwy)) +
  theme_bw() +
  theme(legend.position = "bottom")

p1 + scale_color_brewer(name = "Cut Grade", labels = c("Very Bad", "Bad", "Mediocre", "Nice", "Very Nice"))
p1 + scale_color_discrete(name = "Cut Grade", labels = c("Very Bad", "Bad", "Mediocre", "Nice", "Very Nice"))


p_cont + scale_color_continuous(name = "Highway MPG") + theme(legend.position = "top")


# Axis labels 
p1 + scale_x_continuous(name = "Carat Size", labels = c("Zero", "One", "Two", "Three", "Four", "Five"))


# Quiz

diamonds %>%
  ggplot(aes(x = carat, y = price)) +
  geom_point() +
  geom_smooth(aes(color = cut), se = FALSE) +
  theme_light() +
  labs (title = "Ideal cut diamonds command the best price for every carat size", 
  subtitle = "Lines show GAM estimate of mean values for each level of cut", 
  caption = "Data provided by Hadley Wickham")  + 
  scale_color_brewer(name = "Cut Rating", palette = "Greens") +
  scale_x_log10(name = "Log Carat Size") + 
  scale_y_log10(name = "Log Price Size")

###

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_point() + 
  geom_smooth(mapping = aes(color = cut), se = FALSE) +  
  labs(title = "Ideal cut diamonds command the best price for every carat size",
       subtitle = "Lines show GAM estimate of mean values for each level of cut",
       caption = "Data provided by Hadley Wickham",
       x = "Log Carat Size",
       y = "Log Price Size",
       color = "Cut Rating") +
  scale_x_log10() +
  scale_y_log10() +
  scale_color_brewer(palette = "Greens") +
  theme_light()





# Reshape Data ------------------------------------------------------------

# tidy data: 
# Each variable is in its own column
# Each observation is in its own row
# Each value is in its own cell


# use the gather() function in the tidyr package to convert wide data to long data
# ask R to convert each new column to an appropriate data type by adding convert = TRUE to the gather() call.



babynames %>%
  group_by(year, sex) %>% 
  summarise(total = sum(n)) %>%
  spread(sex, total) %>%
  mutate(ratio = M / F) %>%
  ggplot(aes(year, ratio)) + 
  geom_line()







# Seperate and Unite Columns ----------------------------------------------

# separate() - which separates a column of cells into multiple columns
# unite() - which combines multiple columns of cells into a single column

separate(hurricanes, col = date, into = c("year","month","day"), sep = "-")
# By default separate() will separate values at the location of any non-alphanumeric character, like -, ,, /, etc


separate(hurricanes, col = date, into = c("year","month","day"), sep = 2)


# If you add remove = FALSE to your separate() call, R will retain the original column in the results.
hurricanes %>% 
  separate(col = date, into = c("year","month","day"), convert = TRUE, remove = FALSE)


# unite() uses multiple input columns to create a single output column
hurricanes %>%
  separate(date, c("year", "month", "day"), sep = "-") %>%
  unite(col = "date", month, day, year, sep = ":")



who %>% 
  select(-iso2, -iso3) %>%
  gather(key = "codes", value = "n", 3:58) %>%
  separate(col = codes, into = c("new","type","sexage"), sep = "_") %>%
  separate(col = sexage, into = c("sex","age"), sep = 1) %>%
  select(-new) %>%
  drop_na(n)         # drop_na() will drop every row that contains an NA in one or more of the listed columns.






# Join Data Sets ----------------------------------------------------------
# 
# left_join(), right_join(), full_join(), and inner_join() - which augment a copy of one data frame with information from a second
# semi_join() and anti_join() - which filter the contents of one data frame against the contents of a second
# bind_rows(), bind_cols(), and set operations - which combine data sets in more simple ways


# mutating joins 

flights %>%
  drop_na(arr_delay) %>%
  group_by(carrier) %>%
  mutate(avg_delay = mean (arr_delay)) %>%
  arrange(desc(avg_delay)) %>%
  left_join(airlines, by = "carrier") %>%
  select (year, month, day, carrier, name, avg_delay, everything())   # reorder column names
  


# left_join() function returns a copy of a data set that is augmented with information from a second data set. 
# It retains all of the rows of the first data set, and only adds rows from the second data set that match rows in the first.


# right_join() does the opposite of left_join(); 
# it retains every row from the second data set and only adds rows from the first data set that have a match in the second data set


# full_join() retains every row from each data sets
# This is the only join that does not lose any information from the original data sets


# inner_join() only retains rows that appear in both data sets 



# Matching column names

flights %>% 
  drop_na(arr_delay) %>%
  group_by(dest) %>%
  summarise(avg_delay = mean(arr_delay)) %>%
  arrange(desc(avg_delay)) %>% 
  left_join(airports, by = c("dest" = "faa")) %>% 
  select(name, avg_delay) %>%
  print(n = 100)






# filtering joins
#
# do not add new data to a data set
# filter the rows of a data set based on whether or not the rows match rows in a second data set


# distinct() returns the distinct values of a column.
flights %>% distinct(dest)



flights %>% 
  distinct(dest) %>% 
  left_join(airports, by = c("dest" = "faa"))


# semi_join() as filter

criteria <- tribble(
  ~month, ~carrier,
  1,     "B6", # B6 = JetBlue
  2,     "WN"  # WN = Southwest
)


flights %>% 
  semi_join(criteria, by = c("month", "carrier"))





# Binds and set operations 

# bind_cols() cannot tell whether the rows are in the correct order or not
# bind_rows() = append in Stata 


bands <- list(df1 = band, 
              df2 = band2)

bands %>% bind_rows(.id = "origin")




# union() returns every row that appears in either data set, but it removes duplicate copies of the rows
# intersect() returns only the rows that appear in both data sets.
# setdiff() returns all of the rows that appear in the first data set but not the second











# Iteration ---------------------------------------------------------------

# Non-recursive vectors:
# Each element of a non-recursive vector is a single value, and all of the values in a non-recursive vector are the same type


# Recursive vectors or lists:
# individual elements can be anything, even other vectors, even other recursive vectors




# extract each element of a list with the [[i]] bracket syntax

chars <- c("a", "b", "c")
list2 <- list(1, chars)

list2[[2]]



# map() for iteration 

list1 <- list(1, 2, 3, 4, 5)

list1 %>% 
  map(log, base=2) %>% 
  map(round, digits = 3)




# map_dbl() works exactly like map(), except it returns its results in a numeric vector
# 
# map()	list
# map_chr()	character vector
# map_dbl()	double (numeric) vector
# map_dfc()	data frame (output column binded)
# map_dfr()	data frame (output row binded)
# map_int()	integer vector
# map_lgl()	logical vector
# walk()	returns the input invisibly (used to trigger side effects)

strings <- list("Mary", "John", "Jill")
map_chr(strings, str_sub, start = 1, end = 2)





str(ldeaths)
x <- list("1974" = c("Jan" = 3035, "Feb" = 2552, "Mar"=2704,  "Apr"=2554))


# turn a vector into a data frame

y <- as_tibble(x)

# Even though R displays simple vectors as if they were row vectors, 
# R thinks of every vector as a column vector, even if that vector has names.

t(y) # transpose 


# summarise_all() will apply each function to every column and return the results as a summary table

ldeaths %>% 
  map(t) %>% 
  map_dfr(as_tibble) %>% 
  summarise_all(sum)


# pluck() extracts an element from a list, by name or by position.


list1 <- list(
  numbers = 1:3,
  letters = c("a", "b", "c"),
  logicals = c(TRUE, FALSE)
)

pluck(list1, 1)         # list1 %>% pluck(1)
pluck(list1, "numbers") # list1 %>% pluck("numbers")


us %>% pluck("lifeExp")
# pluck() does the same thing as us$lifeExp and us[["lifeExp"]], 
# but pluck() is easier to read (and easier to pass to map()).





# last() returns the last element of a vector
# first() returns the first element of a vector
last(lifeExp) - first(lifeExp)





# When map() receives a character string instead of a function, 
# map() will return the element of each sub-list whose name matches the character string
# 

params <- list(
  "norm1" = list("mu" = 0, "sd" = 1),
  "norm2" = list("mu" = 1, "sd" = 1),
  "norm3" = list("mu" = 2, "scale" = 1)
)
map(params, "mu")     # params %>% map("mu")
map(params, 1)        # params %>% map(1)



# Expressions with map()

params %>% 
  map(~rnorm(5, mean = pluck(.x, 1), sd = pluck(.x, 2)))


gap_list %>%
  map("lifeExp") %>%
  map_dbl(~ last(.x) - first(.x))



# enframe() turns a named vector into a data frame with two columns: name and value.

named_vec <- c(uno = 1, dos = 2, tres = 3)
enframe(named_vec)

enframe(x)



# top_n() returns the n rows that have the highest value of a weighting variable.

top_n(mtcars, n = 5, wt = mpg)   # top_n() retrieves but does not sort
top_n(mtcars, n = 5, wt = desc(mpg))



gap_list %>%
  map("lifeExp") %>%
  map_dbl(~ last(.x) - first(.x)) %>%
  enframe() %>%
  top_n(n=5, wt = value)



gap_dfs %>%
  map(~ lm(lifeExp ~ year + gdpPercap, data = .x))






# multiple vectors

map2(model1, model2, anova)

map2(model1, model2, anova, test = "Chisq")   # pass extra arguments to the function as extra arguments to map2()




model1 %>%     
  map2_dbl(model2, ~ pluck(coef(.y), "year") - pluck(coef(.x), "year")) %>%         # iteration of TWO 
  round(digits = 2) %>%
  enframe() %>%
  arrange(desc(value))



# iteration of THREE OR MORE

long_numbers <- list(pi, exp(1), sqrt(2))
digits <- list(2, 3, 4)
pmap(list(x = long_numbers, digits = digits), round)  



pmap(list(model1, model2, model3), anova)



pmap(
  list(model1, model2, model3),
  ~ c(
    m1 = pluck(coef(..1), "year"),
    m2 = pluck(coef(..2), "year"),
    m3 = pluck(coef(..3), "year")
  )
)





# pmap() and data frames

(parameters <- data.frame(
  n = c(3, 2, 1),
  mean = c(0, 1, 10),
  sd = c(1, 2, 100)
))

parameters %>% pmap(rnorm)






# invoke_map() function is designed to iterate over a vector of functions followed by a vector of arguments


functions <- list(rnorm, rlnorm, rcauchy)
n <- c(1, 2, 3)

invoke_map(functions, n)     # functions %>% invoke_map(n)


# Multiple arguments

args <- list(norm = c(3, mean = 0, sd = 1), 
             lnorm = c(2, meanlog = 1, sdlog = 2),
             cauchy = c(1, location = 10, scale = 100))

invoke_map(functions, args)



# List Columns: When a column vector contains a list, we call the column a list column

(df <- list(
  name = c("John", "Mary", "Mike"),
  age = c(20, 21, 22),
  height = c(69, 64, 72)
))
class(df)


df1 <- as_tibble(df)

df2 <- as.data.frame(df)


#  data frames are a type of list. Tibbles are a type of data frame.
# 
# List columns are very useful because you can put anything into a list, 
# which means that you can put anything into a list column, 
# even things that you might not normally think to put in a data frame



gapminder %>% 
  group_by(country) %>%
  nest() %>%
  pluck("data")%>%
  pluck(1)


# nest() and unnest() do not modify the original data frame. 
# They return a modified copy of the original data frame




gap_final <- gapminder %>% 
  group_by(country) %>%
  nest() %>%
  mutate(models = map(data, ~lm(lifeExp ~ year, data = .x))) %>%
  mutate(coefficient = map_dbl(models, ~ coef(.x) %>% pluck("year"))) %>%
  mutate(r_squared = map_dbl(models, ~ summary(.x) %>% pluck("r.squared")))

# Once you place all of your output into a single table, 
# it is easy to arrange, filter, summarise, mutate, and select from your results.
   


# each of these pieces of code would extract the first model

gap_final %>% 
  pluck("models") %>% 
  pluck(1)

gap_final[[1, 3]]

gap_final$models[[1]]





# Functions ---------------------------------------------------------------

# A function is simply a piece of code that is packaged in a way that makes it easy to reuse
# 
# Every R function has three parts:
#   
# 1. A body of code
# 2. A set of formal arguments
# 3. An environment (where the function will look up the values of the objects within it)


body(xor)
formals(xor)
environment(xor)
environment(filter)
xor


# Most R functions call other R functions in their code body, but primitives do not
# Instead primitives call internally implemented algorithms that are written in a lower level programming language
# (i.e. a more primitive programming language) like C, C++, or FORTRAN



# The best practice is to explicitly write out each argument name followed by an equals sign and then a value. 
# If you leave out the argument names, R will match your values to arguments in the order that they are listed.
# 
# What happens in a function stays in the function






foo <- function(a, b) {
  a + b
}
foo(1,10)



# default values 
foo <- function(a, b=5) {
  a + b
}
foo(1)









# Use the four step workflow whenever you need to write a function:
#   
# 1. Create a real R object (or set of objects) to use with your function
# 2. Write code that works with the real object(s)
# 3. Wrap the code in function()
# 4. Assign the names of your real objects as argument names to the function


x <- c(100, 100, 100, 100, 100, 100, 100, 80, 100, 90)  # step 1

z <- (sum(x)-min(x))/9  # step 2

grade <- function(x) {
  (sum(x)-min(x))/9     # step 3/4
}

grade(x = c(100, 90, 90, 90, 90, 90, 90, 90, 90, 80))   




# turn a pipe into a function

c(1,4,25) %>% 
  sqrt() %>% 
  sum()


test_pipe <- . %>% 
  sqrt() %>% 
  sum()

test_pipe(c(1,4,16))




a <- c(5, 6, 7, 8, 9)

sqrt(sum(a^2))

l2 <- function(a) {
  sqrt(sum(a^2))
}

l2( a = c(1,2,3))




# environments and scoping 

globalenv()

ls.str(globalenv())   # display the contents of an R environment

parent.env(globalenv())

parenvs(globalenv(), all = TRUE)

parenvs(e = environment(), all = TRUE)


# get around package masking with the ::

lubridate::date
base::date


# 1. Overwriting happens when you assign a new value to a name that already exists in the active environment, replacing the old value.
# 
# 2. Masking happens when you create an object that has the same name as an object further down the search path, hiding the object.




# When you call a function, R executes the code that is saved in the body of the function. To execute that code safely:
#   
# 1. R creates a fresh environment to run the code in. I’ll call this environment the execution environment.
# 
# 2. R sets the parent of the execution environment to the function’s enclosing environment, 
# which is the environment where the function was first defined. 
# This ensures that the function will use the same, predictable search path each time that it runs.
# 
# 3. When R finishes running the function, R returns the result to the calling environment, 
# which is the environment that was active when the function was called. 
# R also makes the calling environment the active environment again, 
# which removes the execution environment from the search path.




# Control Flow ------------------------------------------------------------

# Control flow refers to the order in which a function executes the statements in its body of code


clean <- function(x) {
  if (x == -99) x <- NA
  x
}

clean(-99)
clean(11)

###

clean2 <- function(x) {
  if (x == -99) "NA" 
  else x
}

clean2(-99)
clean2(11)

###

clean3 <- function(x) {
  if (x == -99) {
    NA
  } else {
    x <- x^2
    x
  }
}


clean3(-99)
clean3(11)


###

clean4 <- function(x) {
  if (x == -99) NA
  else if (x == ".") NA
  else if (x == "NaN") NA
  else x
}


clean4("NaN")
clean4(-99)
clean4(11)



# return()

clean <- function(x) {
  if (x == -99) return(NA) 
  if (x == ".") return(NA)
  if (x == "NaN") return(NA)
  x
}


# stop() behaves like return(), but instead of returning a value, stop() returns an error, complete with a custom error message


# stopifnot():  the first argument of stopifnot() should always be a logical condition, 
# the inverse of the condition it replaces in an if + stop() statement

clean <- function(x) {
  stopifnot(!is.null(x))
  if (x == -99) return(NA)
  if (x == ".") return(NA)
  if (x == "NaN") return(NA)
  x
}


# defensive programming with stopifnot()

clean <- function(x) {
  stopifnot(!is.null(x), is.numeric(x), length(x) == 1)     # right conditions in the parentheses 
  
  if (x == -99) return(NA)
  x
}



# As R operators, both & and | are vectorized which means that you can use them with vectors
x <- c(-99, 0 , 1)
x == -99
x == 1
x == 55
x == -99 | x == 1



# if conditions are NOT vectorized. 
# if expects the logical test contained within its parentheses to return a single TRUE or FALSE.
# If the condition returns a vector of TRUE or FALSEs, if will use the first value and show a warning message

if (x == 99 | x == -99) NA else "zzz"

if (x == -99 | x == 99) NA else "zzz"

if (x == 0 | x == 1) NA else "zzz"

if (x == 0) NA else "zzz"



# If you give && or || vectors, they will compare only the first elements of the vectors—
# and they will not return a warning message


x == -99 | x == "."
x ==  0  || x == 99




# unlike if() and else(), ifelse() is vectorized
x <- c(-99, 0 , 1)
ifelse(x == -99, NA, 1)

if_else(x == -99, NA, 1)  # error
if_else(x == -99, NA, TRUE)


# types of NA
typeof(NA)

x <- c(-99, 0, 1)
if_else(x == -99, NA_real_, x)





# case_when() -> vectorized "else if" 

foo <- function(x) {
  if (x > 2) "a"
  else if (x < 2) "b"
  else if (x == 1) "c"
  else "d"
}


foo2 <- function(x) {
  case_when(
    x > 2  ~ "a",
    x < 2  ~ "b",
    x == 1 ~ "c",
    TRUE   ~ "d"
  )
}


x <- c(3, 2, 1)
foo(x)
foo2(x)
# Like if_else(), case_when() expects each case to return the same type of output.



# loops > repeat, while, for

repeat {
  print("Hello")
}

# repeat + break

n <- 1
repeat {
  print(c("Hello", n))
  if (n == 5) break
  n <- n + 1
}



count_down <- function(x) {
  n <- x
  repeat {
    print(n)
    if (n == 1) break
    n <- n - 1
  }
}
count_down(8)


# repeat + return in a function 

count_down2 <- function(x) {
  n <- x
  repeat {
    print(n)
    if (n == 1) return("Boom!!!")
    n <- n - 1
  }
}

count_down2 (10)



is_prime <-  function(x) {
  n <- 2
  repeat {
  if (n == x) return(TRUE)
  if (x %% n == 0) return(FALSE)
  n <-  n + 1
  }
}

is_prime(89)



# while

n <- 1
while (n <= 10) {
  print(n)
  n <- n + 1
}


is_prime <-  function(x) {
  n <- 2
  while (n < x) {
    if (x %% n == 0) return(FALSE)
    n <-  n + 1
  } 
  TRUE
}  

is_prime(79)





# for

for (n in c(1, 2, 3, 4, 5)) {
  print(n * 10)
}


for (person in c("Betty", "Veronica", "Archie")) {
  greeting <- paste("Hello", person)
  print(greeting)
}


is_prime <- function (x) {
  for (n in seq (2, x - 1)) {
    if (x %% n == 0) return(FALSE)
  } 
  TRUE
}

is_prime(79)


# for + next -> move to the next iteration without executing the rest of the loop 

n <- 1
while (n < 5) {
  print(n)
  next
  n <- n + 1
}



# When to use loops in R
# 
# loops should not appear as frequently in your R code because R is an extremely vectorized language -> 
# vectorization, recursion, map 

# recursion 
is_prime <- function(x, n = 2) {
  if (n == x) return(TRUE)
  else if (x %% n == 0) return(FALSE)
  else is_prime(x, n = n + 1)
}
is_prime(79)






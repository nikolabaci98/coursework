
########################################
# load libraries
########################################

# load some packages that we'll need
library(tidyverse)
library(lubridate)
library(scales)

# be picky about white backgrounds on our plots
theme_set(theme_bw())

# load RData file output by load_trips.R
load('trips.RData')

trips %>%
  View

########################################
# plot trip data
########################################

# plot the distribution of trip times across all rides (compare a histogram vs. a density plot)
trip_dist_plot <- filter(trips, tripduration <= 4000) %>%
                    ggplot(mapping = aes(x = tripduration / 60))

trip_dist_plot+
  geom_histogram(bins = 100)

trip_dist_plot +
  geom_density()

# plot the distribution of trip times by rider type indicated using color and fill (compare a histogram vs. a density plot)
trip_dist_plot+
  geom_histogram(mapping = aes(fill = usertype))+
  facet_wrap(~ usertype)

trip_dist_plot+
  geom_density(mapping = aes(fill = usertype))+
  facet_wrap(~ usertype)

# plot the total number of trips on each day in the dataset
group_by(trips, ymd) %>%
  ggplot() +
  geom_histogram(mapping = aes(x = ymd), bins = 366) +
  coord_flip()

group_by(trips, ymd) %>%
  ggplot() +
  geom_histogram(mapping = aes(x = ymd), bins = 366)

group_by(trips, ymd) %>%
  summarize(count = n()) %>%
  ggplot() +
  geom_line(mapping = aes(x = ymd, y = count))
  
# plot the total number of trips (on the y axis) by age (on the x axis) and gender (indicated with color)
filter(trips, gender != "Unknown") %>%
  ggplot(aes(x = birth_year, color = gender, fill = gender)) +
  geom_histogram()+
  facet_wrap(~ gender)

# plot the ratio of male to female trips (on the y axis) by age (on the x axis)
# hint: use the spread() function to reshape things to make it easier to compute this ratio
# (you can skip this and come back to it tomorrow if we haven't covered spread() yet)

trips %>%
  mutate(age = 2014 - birth_year) %>%
  group_by(gender, age) %>%
  summarize(count = n()) %>%
  pivot_wider(names_from = gender, values_from = count) %>%
  select(-Unknown) %>% 
  mutate(ratio = Male / Female) %>%
  ggplot() +
  geom_jitter(mapping = aes(x = age, y = ratio, size = Female+Male))+
  xlim(c(15,65)) +
  ylab("Male to Femail Ratio")
  


  
########################################
# plot weather data
########################################

weather %>% View()

# plot the minimum temperature (on the y axis) over each day (on the x axis)
weather %>% 
  ggplot() +
  geom_line(mapping = aes(x = ymd, y = tmin))

# plot the minimum temperature and maximum temperature (on the y axis, with different colors) over each day (on the x axis)
# hint: try using the gather() function for this to reshape things before plotting
# (you can skip this and come back to it tomorrow if we haven't covered reshaping data yet)
weather %>% 
  ggplot() +
  geom_line(mapping = aes(x = ymd, y = tmin), color = "blue") +
  geom_line(mapping = aes(x = ymd, y = tmax), color = "red") +
  xlab("Day of the year") +
  ylab("min/max")

########################################
# plot trip and weather data
########################################

# join trips and weather

trips_with_weather <- inner_join(trips, weather, by="ymd")
trips_with_weather %>% View()


# plot the number of trips as a function of the minimum temperature, where each point represents a day
# you'll need to summarize the trips and join to the weather data to do this

trips_count <- trips %>%
                group_by(ymd) %>%
                summarize(trip_per_day_count = n())

trips_count_with_weather <- inner_join(trips_count, weather, by="ymd")

trips_count_with_weather %>%
  ggplot() +
  geom_point(mapping = aes(x = ymd, y = trip_per_day_count, alpha = trip_per_day_count))

# repeat this, splitting results by whether there was substantial precipitation or not
# you'll need to decide what constitutes "substantial precipitation" and create a new T/F column to indicate this


# observe the data to get a good idea of the "substantial precipitation"
summary(weather)
filter(weather, prcp > 0.3) %>%
  ggplot()+
  geom_line(mapping = aes(x = ymd, y = prcp))

trips_count_with_weather_2 <- mutate(trips_count_with_weather, sub_prcp = (prcp >= 0.3))

trips_count_with_weather_2 %>%
  ggplot() +
  geom_point(mapping = aes(x = ymd, y = trip_per_day_count, alpha = trip_per_day_count, color = sub_prcp))

# add a smoothed fit on top of the previous plot, using geom_smooth
trips_count_with_weather_2 %>%
  ggplot(mapping = aes(x = ymd, y = trip_per_day_count, color = sub_prcp)) +
  geom_point(mapping = aes(alpha = trip_per_day_count)) +
  geom_smooth()

# compute the average number of trips and standard deviation in number of trips by hour of the day
# hint: use the hour() function from the lubridate package
?lubridate
trips_with_hour <- trips
trips_with_hour <- mutate(trips_with_hour, date = ymd_hms(starttime))
trips_with_hour <- mutate(trips_with_hour, hour = hour(date))

trips_by_hour_of_day <- trips_with_hour %>%
  group_by(ymd, hour) %>%
  summarize(count = n()) %>%
  group_by(hour) %>%
  summarize(ymd = ymd, avg = mean(count), std = sd(count)) 



#tt <- t %>%
  #group_by(ymd, hour) %>%
  #summarize(count = n()) %>%
  #pivot_wider(names_from = hour, values_from = count)

#tt %>%
  #group_by(ymd) %>%
  #summarize(avg = mean(tt$`0`)) %>%
  #View()


# plot the above
trips_by_hour_of_day %>%
  ggplot() +
  geom_point(mapping = aes(x = hour, y = avg), color = "orange") +
  geom_point(mapping = aes(x = hour, y = std), color = "green") +
  geom_line(mapping = aes(x = hour, y = avg), color = "orange") +
  geom_line(mapping = aes(x = hour, y = std), color = "green") 
  

# repeat this, but now split the results by day of the week (Monday, Tuesday, ...) or weekday vs. weekend days
# hint: use the wday() function from the lubridate package

trips_with_day_of_week <- trips 
trips_with_day_of_week <- mutate(trips_with_day_of_week, day_of_week = wday(ymd))
trips_with_day_of_week <- mutate(trips_with_day_of_week, day_of_week=factor(day_of_week, levels=c(1,2,3,4,5,6,7), 
                                      labels=c("Sunday", "Monday","Tuesday","Wednesday", "Thursday", "Friday", "Saturday")))

trips_on_each_day <- trips_with_day_of_week %>%
        group_by(ymd, day_of_week) %>%
        summarize(count = n()) %>%
        group_by(day_of_week) %>%
        summarize(avg = mean(count), std = sd(count))

trips_on_each_day %>%
  ggplot() +
  geom_point(mapping = aes(x = day_of_week, y = avg), color = "orange") +
  geom_point(mapping = aes(x = day_of_week, y = std), color = "green") +
  geom_line(mapping = aes(x = day_of_week, y = avg, group = 1), color = "orange") +
  geom_line(mapping = aes(x = day_of_week, y = std, group = 1), color = "green")

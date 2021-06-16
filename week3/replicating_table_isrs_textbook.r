library(tidyverse)
library(ggplot2)
library(ISLR)

data <- read.delim("body.dat.txt", header = FALSE, sep = "")

View(data)

data %>%
#filter(data, V29 > 50) %>%
  ggplot()+
  geom_jitter(mapping = aes(x = V24, y = V23))+
  scale_x_continuous(breaks = seq(150, 240, 25), lim = c(150, 200)) +
  scale_y_continuous(breaks = seq(40, 120, 20), lim = c(40, 120)) +
  xlab("Height")+
  ylab("Weight")

data <- data.frame(data)

model <- lm(V23~V24, data = data)

summary(model)


#-------------------------------------------------------------------------#

babies <- read.delim("babyweights.txt", header = TRUE, sep = "")
View(babies)

babies %>%
  ggplot() +
  geom_point(mapping = aes(x = smoke, y = weight))

babies %>%
  ggplot() +
  geom_histogram(mapping = aes(x = weight))+
  facet_wrap(~smoke)

smoke <- filter(babies, smoke == 1, !is.na(weight))
mean(smoke$weight)
smoke <- mutate(smoke, avg = mean(smoke$weight))

non_smoker <- filter(babies, smoke == 0, !is.na(weight))
sd(non_smoker$weight)
mean(non_smoker$weight)


ggplot(data = non_smoker, aes(x = weight)) +
  geom_histogram()

ggplot(data = smoker, aes(x = weight)) +
  geom_histogram()

ggplot(data = babies, aes(x = weight)) +
  geom_histogram()+
  facet_wrap(~smoke)
#-------------------------------------------------------------------------#

smoke_model <- lm(data = babies, weight~smoke)
smoke_model
summary(smoke_model)

#--------------------------------------------------------------------------#  

parity_model <- lm(data = babies, weight~parity)
parity_model
summary(parity_model)

#--------------------------------------------------------------------------#

bwt_model <- lm(data = babies, bwt~gestation+parity+age+height+weight+smoke)
bwt_model
summary(bwt_model)
















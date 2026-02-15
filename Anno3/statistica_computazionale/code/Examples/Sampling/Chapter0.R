### Recap of: R
# Basic operations
a <- 5
b=6
# scalar (it's just a number)
# a is a scalar
str(a)
c <- "Computational"
# special type of value
a <- 1
b <- TRUE
# TRUE is a boolean value
a-b
a+b
a*b
a^b
b <- -3
sqrt(a)
sqrt(b)
sin(b)
cos(b)
# Checking a condition
a>b
a>=b
a<b
a<=b
a==b
c=="Computational"

# There are different special 'values' in R
# For example, TRUE = 1 boolean
# NA -> Not Available, most of the time stands for MISSING
# NaN -> Not Assigned: I did some math atrocities like dividing by zero or the ratio of +-Inf

# Elements, vectors, arrays, data.frames
# Vector: is a sequence of elements OF THE SAME TYPE
vec1 <- c(3,5,-7,a+b,5^2)
vec2 <- c(38, c)
vec3 <- c(TRUE, -50, sin(7))
vec4 <- c(TRUE,TRUE,FALSE)
vec5 <- seq(-5,10,by=2)
vec6 <- seq(-5,10,length.out = 20)
### length(x) is the length of the vector object "x"
### (not a mathematical length)
vec5[11]
# Matrix: is a collection of elements OF THE SAME TYPE
# but in two dimensions: ROW and COLUMNS
# cbind(): column bind, bind together different columns
A <- cbind(x=c(3,5,10),y=c(6,9,17))
B <- matrix(seq(2,9,length.out=8))
A[5] # you get an answer but it's not the right approach
A[2,]
A[,1] 
A[-3,]
A[c(1,2),]
A[-c(1,2),]

# Array, an object of dimension "d"
pluto <- array(seq(1,8),c(2,2,2))
# all the elements of the array have to be of the same type
pluto[2,1,1]

# data.frames
# is a 2dimensional structure with one big advantage
# each column can be of any type
data(iris)

# you can select items in the data.frame both with []
iris[1:10,1:2]
iris$Sepal.Length


# Functions, if, loop
# if
dimension <- dim(pluto)
len <- length(dimension)
if(len>2) print("Array")

if(length(dim(pluto))>2) print("Array")

if(length(dim(pluto))>2) print("Array") else print("Not Array")

if(length(dim(A))>2) print("Array") else print("Not Array")

# how to build more complex conditions
# logical operators
# OR: it's translated in R with the symbol "|"
# AND: it's translated in R with the symbol "&"

cond <- (length(dim(pluto))>2) & (dim(pluto)[1]>=5)
if(cond==TRUE) print("Ok!") else print("Not ok!")

# loop: for() repeat instruction(s) a certain amount of time
for(i in 1:10){
  print(i^2)
}

# how to define a function
# name for a function <- function(input1, arg1,arg2...){}
rad.sq <- function(x){
  return(x^0.5)
}

# z test Normal test for 1 mean
# CHECK FOR ANY MISTAKE
# And add the computation of the observed p-value
z.test <- function(x, mu0=0, popvar){
  n <- length(x)
  z.score=(mean(x)-mu0)/(sqrt(popvar/n))
  p.value <- 
  return(list(z.score=z.score, p.value=p.value))
}


# tidyverse
# dplyr/tidyverse
library(tidyverse)
# or require(tidyverse)

### Pipe operator %>% 
##  macOS: CMD+Shift+M
##  Windows: CTRL+Shift+M
## Just like a pipe:
## (input) flows to (output)

## Main commands from dplyr:
## filter(), select(), arrange(), distinct(), mutate(), summarise(), sample_n()
data("iris")
str(iris)
# or
iris[iris$Species=="setosa",]
iris[iris[,5]=="setosa",]
iris %>% filter(Species=="setosa") %>% filter(Sepal.Length<5.0)

temp <- iris %>% filter(Species=="setosa")
temp %>% filter(Sepal.Length<5.0)
rm(temp)

iris %>% filter(Species=="setosa", Sepal.Length>5)
# filter() works on the rows of the dataset
# filering them based on one or more conditions 

## summarise() produces stat summaries (default or user-specified)

iris %>% summarise(sum(Sepal.Length), mean(Sepal.Length), sd(Sepal.Length),
                   n(), var(Sepal.Length),
                   min(Sepal.Length), max(Sepal.Length), IQR(Sepal.Length),
                   median(Sepal.Length), quantile(Sepal.Length,0.95))

iris %>% summarise(Somma=sum(Sepal.Length), Media=mean(Sepal.Length), Dev.Std=sd(Sepal.Length),
                   Sample.Size=n(), Varianza=var(Sepal.Length),
                   Minimo=min(Sepal.Length), Massimo=max(Sepal.Length), IQR=IQR(Sepal.Length),
                   Mediana=median(Sepal.Length))

## you can group data before applying other instructions 
iris %>% group_by(Species) %>% summarise(mean(Sepal.Length))


## There is much more to know about tidyverse!
## If you're curious, here is a beginner's cheat sheet:
# http://users.encs.concordia.ca/~gregb/home/PDF/R-Tidyverse-Cheat-Sheet.pdf
## and feel free to send me an e-mail for more details.
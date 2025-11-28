### Size of a Lake

require(reshape2)
# Empty field
# field size = 12x12=144
field <- matrix(0, 12, 12)

# let's build a lake!
field[2, c(3:5)] <- 1
field[3, c(2:7)] <- 1
field[4, c(1:7)] <- 1
field[5, c(2:9)] <- 1
field[6, c(3:9)] <- 1
field[7, c(4:8)] <- 1
field[8, c(5:7)] <- 1

# Plot the initial lake shape
field.plot <- melt(field)
plot(field.plot$Var1,
     field.plot$Var2,
     col=field.plot$value,
     cex=1.5,
     pch=16)

## Now, we launch some cannonballs and see if we hit
N <- 200 #number of shots
shots <- matrix(0, N, 2)
hit.or.miss <- rep(0, N)

for(i in 1:N) {
  # Select a random x (row) and y (column) coordinate
  shots[i,] <- c(sample(1:12, 1, replace=T), sample(1:12, 1, replace=T))
  
  # Check if the shot hit the lake (value == 1)
  hit.or.miss[i] <- (field[shots[i,1], shots[i,2]] == 1)
}

# Total number of hits
sum(hit.or.miss)

# Proportion of hits (percentage of "lake"). bits / N
mean(hit.or.miss)

## Size of the lake
# Estimate the lake size by multiplying the proportion by the total area
mean(hit.or.miss)*144 # Total area = 12*12 = 144

# Round the estimate to the nearest integer
round(mean(hit.or.miss)*144, 0) # Rounded estimate 

# Calculate the REAL size of the lake (for comparison)
sum(field) # Real size of the lake


## How does the quality 'change' when we throw more cannonballs 
# Define a "Hit-Or-Miss" (HOM) function
HOM <- function(N, field) {
  shots <- matrix(0, N, 2)
  hit.or.miss <- rep(0, N)
  
  for(i in 1:N) {
    # Fire a shot at random coordinates (generalized for any field size)
    shots[i,] <- c(sample(1:dim(field)[1], 1, replace=T), sample(1:dim(field)[2], 1, replace=T))
                   
    hit.or.miss[i] <- (field[shots[i,1], shots[i,2]] == 1)
  }
  
  # Calculate the total area (e.g., 12*12 = 144)
  total_area <- prod(dim(field))
  
  # Return the rounded estimate of the lake size
  return(round(mean(hit.or.miss) * total_area, 0))
}

## Let's visualize the changes with respect to this number
N.shots <- 500
plot.estimate <- rep(0, N.shots)
# Create a vector of integers from 1 to 500
NN <- seq(1, N.shots, length.out=N.shots) # This is simply 1:N.shots

# Run the simulation for N=1, N=2, N=3, ..., N=500
for(i in 1:N.shots) {
  plot.estimate[i] <- HOM(NN[i], field)
}

# Create the plot showing the estimate (y-axis) vs. number of shots (x-axis)
plot(NN, plot.estimate,
     cex=0.2,       # Point size (very small)
     pch=16,        # Point shape (solid circle)
     type="b")      # Plot type: "b" for "both" (points and lines)

# Add a horizontal red line (col=2) showing the true lake size
abline(h=sum(field), col=2, lwd=2)


### Built-in Random generation
# Generate 3 random numbers from a Gamma distribution
rgamma(3, 2.5, 4.5)

# Plot the density function of a Gamma distribution
curve(dgamma(x, 2.5, 8), from=0, to=4)

### Built-in Random generation
rgamma(3, 2.5, 4.5)
curve(dgamma(x, 2.5, 8), from=0, to=4)

#UNIFORM SIMULATION
runif(100, 2, 5)

Nsim=10^4
x=runif(Nsim)
x1=x[-Nsim]
x2=x[-1]
par(mfrow=c(1, 3))
hist(x,freq=F)
plot(x1, x2)
acf(x)
par(mfrow=c(1, 1))

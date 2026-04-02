
using Plots
using Dates

# Define the function y = mx + b
m = 2    # slope
b = 3    # y-intercept
f(x) = m * x + b

# Generate x values
x_values = -10:0.1:10

# Compute y values
y_values = f.(x_values)

# Plot the function
plot(x_values, y_values,
     label=y = x + ,
     xlabel=x,
     ylabel=y,
     title="Linear Function: y = mx + b - $(Dates.now())",
     linewidth=2,
     legend=:topleft)


# Save this as plot_10x10.jl

using Plots
using Dates

# Create a 10x10 matrix of random values for the plot
data = rand(10, 10)

# Create a heatmap plot
p = heatmap(data,
            title="10x10 Heatmap - $(Dates.now())",
            xlabel="X Axis",
            ylabel="Y Axis",
            color=:viridis,
            size=(600, 400))

# Save the plot to a file
savefig(p, "10x10_plot.png")

println("Plot saved as 10x10_plot.png")

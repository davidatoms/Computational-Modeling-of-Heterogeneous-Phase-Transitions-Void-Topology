
# Save this as labeled_corners_10x10x10.jl

using Plots
using Dates

# Define the 8 corners of the cube
x = [1, 10, 1, 10, 1, 10, 1, 10]
y = [1, 1, 10, 10, 1, 1, 10, 10]
z = [1, 1, 1, 1, 10, 10, 10, 10]
labels = [1, 2, 3, 4, 5, 6, 7, 8]

# Plot only the corners as scatter points
p = scatter(x, y, z,
            markersize = 5,
            markercolor = :blue,
            xlims = (0, 11),
            ylims = (0, 11),
            zlims = (0, 11),
            xlabel = "X Axis",
            ylabel = "Y Axis",
            zlabel = "Z Axis",
            title = "Labeled Corners of 10x10x10 Cube - $(Dates.now())",
            legend = false,
            size = (800, 600),
            camera = (30, 30)
)

# Annotate each corner
annotate!([(x[i], y[i], z[i], text(labels[i], 12, :black)) for i in 1:8])

# Save the plot to a file
savefig(p, labeled_corners_10x10x10.png)

println(Labeled corners saved as labeled_corners_10x10x10.png)


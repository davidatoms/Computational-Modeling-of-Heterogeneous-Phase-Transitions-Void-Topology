
# Save this as subvoxels_10x10x10.jl

using Plots
using Dates

# Generate all 0.1-spaced coordinates
step = 0.1
x = [i for i in 0.05:step:10, _ in 0.05:step:10, __ in 0.05:step:10]
y = [j for _ in 0.05:step:10, j in 0.05:step:10, __ in 0.05:step:10]
z = [k for _ in 0.05:step:10, __ in 0.05:step:10, k in 0.05:step:10]
x = vec(x)
y = vec(y)
z = vec(z)

# Plot all sub-voxels as tiny, semi-transparent# Plot
timestamp = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM-SS")

scatter(x, y, z,
        markersize = 1,
        markercolor = :blue,
        markeralpha = 0.1,  # Transparency
        xlims = (0, 10),
        ylims = (0, 10),
        zlims = (0, 10),
        xlabel = "X Axis",
        ylabel = "Y Axis",
        zlabel = "Z Axis",
        title = "0.1x0.1x0.1 Sub-Voxels in 10x10x10 Cube - $(timestamp)",
        legend = false,
        size = (800, 600),
        camera = (30, 30)
)

# Save the plot
savefig("plots/subvoxels_10x10x10_$(timestamp).png")

println("Saved plot to plots/subvoxels_10x10x10_$(timestamp).png")

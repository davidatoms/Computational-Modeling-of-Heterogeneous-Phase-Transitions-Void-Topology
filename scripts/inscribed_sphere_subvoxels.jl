
using Plots
using Dates
gr()  # Use the GR backend (default for Plots)

# Generate all 0.1-spaced coordinates
step = 0.1
x = [i for i in 0.05:step:10, _ in 0.05:step:10, __ in 0.05:step:10]
y = [j for _ in 0.05:step:10, j in 0.05:step:10, __ in 0.05:step:10]
z = [k for _ in 0.05:step:10, __ in 0.05:step:10, k in 0.05:step:10]
x = vec(x)
y = vec(y)
z = vec(z)

# Center of the cube and sphere radius
center = 5.0
radius = 4.5

# Calculate distance of each point from the center
distances = sqrt.((x .- center).^2 + (y .- center).^2 + (z .- center).^2)

# Color points: white if close to the sphere's surface, blue otherwise
colors = [abs(d - radius) < 0.1 ? :white : :blue for d in distances]
alphas = [abs(d - radius) < 0.1 ? 0.8 : 0.05 for d in distances]

# Plot
timestamp = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM-SS")

scatter(x, y, z,
        markersize = 1,
        markercolor = colors,
        markeralpha = alphas,
        xlims = (0, 10),
        ylims = (0, 10),
        zlims = (0, 10),
        xlabel = "X Axis",
        ylabel = "Y Axis",
        zlabel = "Z Axis",
        title = "Inscribed Sphere in 10×10×10 Cube - $(timestamp)",
        legend = false,
        size = (800, 600),
        camera = (30, 30)
)

# Save the plot
savefig("plots/inscribed_sphere_10x10x10_$(timestamp).png")
println("Saved plot as plots/inscribed_sphere_10x10x10_$(timestamp).png")

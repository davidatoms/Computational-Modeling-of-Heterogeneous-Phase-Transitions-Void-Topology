using Plots
using Dates
using LinearAlgebra
using Random

# Set random seed for reproducibility
Random.seed!(42)

# Define the grid
step = 1.0 # Coarser grid for vector field visibility
range_val = 0.05:step:10.0
x = [i for i in range_val, _ in range_val, __ in range_val]
y = [j for _ in range_val, j in range_val, __ in range_val]
z = [k for _ in range_val, __ in range_val, k in range_val]

x = vec(x)
y = vec(y)
z = vec(z)

# Sphere parameters
center = 5.0
radius = 4.5

# Calculate distances
distances = sqrt.((x .- center).^2 .+ (y .- center).^2 .+ (z .- center).^2)

# Define Vector Field (3D Time)
# Logic:
# - Inside Sphere: Random "chaotic" time flow (representing the atom's internal time)
# - Outside Sphere: Zero (constrained)

u = zeros(length(x)) # x-component of vector
v = zeros(length(y)) # y-component of vector
w = zeros(length(z)) # z-component of vector

for i in 1:length(distances)
    if distances[i] <= radius
        # Inside the sphere: Random direction
        # We can make it more interesting later (e.g., rotational)
        u[i] = randn()
        v[i] = randn()
        w[i] = randn()
        
        # Normalize to keep arrows consistent length
        mag = sqrt(u[i]^2 + v[i]^2 + w[i]^2)
        u[i] /= mag
        v[i] /= mag
        w[i] /= mag
    else
        # Outside: Zero
        u[i] = 0.0
        v[i] = 0.0
        w[i] = 0.0
    end
end

# Visualization
println("Generating plot...")

timestamp = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM-SS")

# We use a downsampling for the plot if needed, but with step=1.0 it should be fine (~1000 points)
# Plots.jl quiver expects arrows to be passed as a tuple of vectors to the `quiver` argument.
# Note: quiver draws arrows *from* x,y,z *to* x+u,y+v,z+w. 
# We shorten them slightly for visual clarity.
scale = 0.6
quiver(x, y, z, 
    quiver=(u .* scale, v .* scale, w .* scale),
    color = :blue,
    xlims = (0, 10),
    ylims = (0, 10),
    zlims = (0, 10),
    xlabel = "X",
    ylabel = "Y",
    zlabel = "Z",
    title = "3D Time Vector Field (Constrained) - $(timestamp)",
    camera = (30, 30),
    size = (800, 600)
)

# Draw a wireframe sphere for context
# (Simple way: just scatter points on the surface lightly)
phi = 0:0.2:2pi
theta = 0:0.2:pi
xs_surf = [center + radius * sin(t) * cos(p) for t in theta, p in phi]
ys_surf = [center + radius * sin(t) * sin(p) for t in theta, p in phi]
zs_surf = [center + radius * cos(t) for t in theta, p in phi]
surface!(xs_surf, ys_surf, zs_surf, color=:grey, alpha=0.1, shading=false)

savefig("plots/time_vector_field.png")
println("Saved to plots/time_vector_field.png")

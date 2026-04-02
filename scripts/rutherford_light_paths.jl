using Plots
using Dates
using LinearAlgebra
using Random

Random.seed!(42)

# Parameters
center = 5.0
sphere_radius = 4.5
num_rays = 200
step_size = 0.05

# Void Parameters (Same as Inverted Density)
num_voids = 40
min_void_radius = 0.5
max_void_radius = 1.0

# Generate Void Centers
voids = []
for _ in 1:num_voids
    p = rand(3) .* 10.0
    if norm(p .- center) < (sphere_radius - max_void_radius)
        r = min_void_radius + rand() * (max_void_radius - min_void_radius)
        push!(voids, (p, r))
    end
end

# Check if a point is inside any void
function is_in_void(p, voids)
    for (void_center, void_r) in voids
        if norm(p .- void_center) < void_r
            return true
        end
    end
    return false
end

# Generate Light Rays
# Starting from X=0 plane, moving in +X direction
ray_points_x = Float64[]
ray_points_y = Float64[]
ray_points_z = Float64[]

for _ in 1:num_rays
    # Random start point on the YZ plane at X=0
    # Constrain to circle to ensure they hit the sphere area
    start_y = 5.0 + (rand() - 0.5) * 8.0
    start_z = 5.0 + (rand() - 0.5) * 8.0
    start_p = [0.0, start_y, start_z]
    
    # Direction: Mostly +X, but maybe slight spread? Let's keep straight beams for now.
    dir = [1.0, 0.0, 0.0]
    
    # Trace Ray
    current_p = copy(start_p)
    while current_p[1] < 10.0
        # Check if inside void
        if is_in_void(current_p, voids)
            push!(ray_points_x, current_p[1])
            push!(ray_points_y, current_p[2])
            push!(ray_points_z, current_p[3])
        end
        
        # Move forward
        current_p .+= dir .* step_size
    end
end

# Draw Voids (Optional: Draw them faintly to see where they are)
# Ideally we just show the light. But let's add faint circles for context.

timestamp = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM-SS")

println("Generating plot...")

# 1. Plot the Light
p = scatter(ray_points_x, ray_points_y, ray_points_z,
    markercolor = :red,
    markersize = 1.5,
    markeralpha = 0.6,
    xlims = (0, 10),
    ylims = (0, 10),
    zlims = (0, 10),
    xlabel = "X Axis",
    ylabel = "Y Axis",
    zlabel = "Z Axis",
    title = "Rutherford Light Paths (Red = Light in Voids) - $(timestamp)",
    label = "Light",
    camera = (30, 30),
    size = (800, 600)
)

# 2. (Optional) Visualize the Dense Matter boundary faintly?
# This might clutter it. Let's stick to just the light first as requested.
# "Light travels through the empty points which should be the internal dots"

savefig("plots/rutherford_light_paths_$(timestamp).png")
println("Saved plots/rutherford_light_paths_$(timestamp).png")

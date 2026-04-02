using Plots
using Dates
using LinearAlgebra
using Random

Random.seed!(42)

# Parameters
center = 5.0
sphere_radius = 4.5
num_background_points = 50000

# Void Parameters (Zero Energy Spots)
num_voids = 30
min_void_radius = 0.4
max_void_radius = 0.8

# Generate Void Centers
voids = []
for _ in 1:num_voids
    # Random position inside sphere (padding constraints so they aren't all on edge)
    p = rand(3) .* 10.0
    if norm(p .- center) < (sphere_radius - max_void_radius)
        r = min_void_radius + rand() * (max_void_radius - min_void_radius)
        push!(voids, (p, r))
    end
end

# Generate Dense Background (The Matter)
points_x = Float64[]
points_y = Float64[]
points_z = Float64[]

attempts = 0
while length(points_x) < num_background_points && attempts < num_background_points * 10
    global attempts += 1
    p = rand(3) .* 10.0
    
    # Check 1: Must be inside the main sphere
    if norm(p .- center) > sphere_radius
        continue
    end
    
    # Check 2: Must be OUTSIDE all voids (The "Swiss Cheese" logic)
    in_void = false
    for (void_center, void_r) in voids
        if norm(p .- void_center) < void_r
            in_void = true
            break
        end
    end
    
    if !in_void
        push!(points_x, p[1])
        push!(points_y, p[2])
        push!(points_z, p[3])
    end
end

timestamp = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM-SS")

scatter(points_x, points_y, points_z,
    markercolor = :blue,
    markersize = 1.5,
    markeralpha = 0.3, # Transparency helps see the depth of holes
    xlims = (0, 10),
    ylims = (0, 10),
    zlims = (0, 10),
    xlabel = "X Axis",
    ylabel = "Y Axis",
    zlabel = "Z Axis",
    title = "Inverted Density: Dense Matter with Voids - $(timestamp)",
    legend = false,
    camera = (30, 30),
    size = (800, 600)
)

savefig("plots/inverted_density_$(timestamp).png")
println("Saved plots/inverted_density_$(timestamp).png")

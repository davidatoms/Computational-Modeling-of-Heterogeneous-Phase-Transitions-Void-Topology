using Plots
using Dates
using LinearAlgebra
using Random

Random.seed!(42)

# Parameters
center = 5.0
max_radius = 5.0 # to edge of box roughly
num_points_base = 5000

# Generate points with varying density based on distance from core
# Layer 1: Core (0 - 1.5) - High Density
# Layer 2: Mid (1.5 - 3.5) - Medium Density
# Layer 3: Outer (3.5 - 5.0) - Low Density ("Light Paths")

points_x = Float64[]
points_y = Float64[]
points_z = Float64[]
colors = Symbol[]

# Simple rejection sampling or just generation per shell
for _ in 1:20000
    p = rand(3) .* 10.0
    dist = norm(p .- center)
    
    keep = false
    color = :grey
    
    if dist < 1.5
        # Core: Keep 80% (High Density)
        if rand() < 0.8
            keep = true
            color = :red
        end
    elseif dist < 3.5
        # Mid: Keep 20% (Medium Density)
        if rand() < 0.2
            keep = true
            color = :blue
        end
    elseif dist < 5.0
        # Outer: Keep 5% (Low Density - Light Paths visible)
        if rand() < 0.05
            keep = true
            color = :cyan
        end
    end
    
    if keep
        push!(points_x, p[1])
        push!(points_y, p[2])
        push!(points_z, p[3])
        push!(colors, color)
    end
end

timestamp = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM-SS")

scatter(points_x, points_y, points_z,
    markercolor = colors,
    markersize = 2,
    markeralpha = 0.6,
    xlims = (0, 10),
    ylims = (0, 10),
    zlims = (0, 10),
    xlabel = "X Axis",
    ylabel = "Y Axis",
    zlabel = "Z Axis",
    title = "Particle Density Layers (Core to Outer) - $(timestamp)",
    legend = false,
    camera = (30, 30),
    size = (800, 600)
)

savefig("plots/particle_density_core_$(timestamp).png")
println("Saved plots/particle_density_core_$(timestamp).png")

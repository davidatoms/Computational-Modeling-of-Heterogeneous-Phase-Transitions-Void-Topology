using Plots
using Dates
using LinearAlgebra
using Random

Random.seed!(42)

# Parameters
center = 5.0
sphere_radius = 4.5

# Void Parameters (Same as Inverted Density)
num_voids = 30
min_void_radius = 0.4
max_void_radius = 0.8

# Generate Void Centers
voids = []
for _ in 1:num_voids
    p = rand(3) .* 10.0
    if norm(p .- center) < (sphere_radius - max_void_radius)
        r = min_void_radius + rand() * (max_void_radius - min_void_radius)
        push!(voids, (p, r))
    end
end

println("Generated $(length(voids)) voids.")

# Generate specific timestamp for this run
timestamp = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM-SS")

# Plot Setup
p = plot(
    xlims = (0, 10),
    ylims = (0, 10),
    zlims = (0, 10),
    xlabel = "X Axis",
    ylabel = "Y Axis",
    zlabel = "Z Axis",
    title = "Void Network Connectivity - $(timestamp)",
    legend = false,
    camera = (30, 30),
    size = (800, 600)
)

# Draw Lines Between ALL Pairs of Voids
# (Fully Connected Graph)
for i in 1:length(voids)
    for j in (i+1):length(voids)
        p1 = voids[i][1]
        p2 = voids[j][1]
        
        # Plot line segment
        plot!(p, [p1[1], p2[1]], [p1[2], p2[2]], [p1[3], p2[3]],
              color = :red,
              alpha = 0.3, # Semi-transparent to avoid clutter
              linewidth = 0.5)
    end
end

# Draw Void Centers (Nodes)
vx = [v[1][1] for v in voids]
vy = [v[1][2] for v in voids]
vz = [v[1][3] for v in voids]

scatter!(p, vx, vy, vz,
    markercolor = :black,
    markersize = 4,
    markeralpha = 1.0,
    label = "Voids"
)

savefig("plots/void_network_$(timestamp).png")
println("Saved plots/void_network_$(timestamp).png")

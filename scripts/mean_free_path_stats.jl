using Plots
using Dates
using LinearAlgebra
using Random
using Statistics

Random.seed!(42)

# ==========================================
# 1. Setup Voids (Same as Previous Scripts)
# ==========================================
center = 5.0
sphere_radius = 4.5

# Void Parameters
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

# ==========================================
# 2. Simulation Parameters
# ==========================================
num_rays = 10000
# Ray Setup: Beam from X=0 plane, moving in +X direction
beam_radius = 4.0 # Slightly smaller than sphere to ensure we hit the bulk

segment_lengths = Float64[]

# Function to get intersection of Ray (O, D) with Sphere (C, R)
# Returns (t_entry, t_exit) or nothing
function intersect_sphere(O, D, C, R)
    OC = O .- C
    # quadratic equation at^2 + bt + c = 0
    # a = dot(D, D) # Should be 1.0 if normalized
    b = 2.0 * dot(OC, D)
    c = dot(OC, OC) - R^2
    
    discriminant = b^2 - 4*c
    if discriminant < 0
        return nothing
    else
        sqrt_disc = sqrt(discriminant)
        t1 = (-b - sqrt_disc) / 2.0
        t2 = (-b + sqrt_disc) / 2.0
        return (min(t1, t2), max(t1, t2))
    end
end

println("Simulating $num_rays rays...")

for _ in 1:num_rays
    # Random start point on YZ plane
    # Rejection sampling for circular beam profile
    ry, rz = 0.0, 0.0
    while true
        ry = (rand() - 0.5) * 2 * beam_radius
        rz = (rand() - 0.5) * 2 * beam_radius
        if ry^2 + rz^2 <= beam_radius^2
            break
        end
    end
    
    start_p = [0.0, center + ry, center + rz]
    direction = [1.0, 0.0, 0.0]
    
    # Check intersection with ALL voids
    # A single ray might pass through multiple voids.
    # We collect ALL "chord lengths" (entry to exit distances)
    
    for (v_center, v_radius) in voids
        result = intersect_sphere(start_p, direction, v_center, v_radius)
        if result !== nothing
            t1, t2 = result
            # Check if intersection is within the box bounds roughly (t > 0)
            if t2 > 0
                # Segment length inside this void
                len = t2 - t1
                push!(segment_lengths, len)
            end
        end
    end
end

# ==========================================
# 3. Statistics & Visualization
# ==========================================
if isempty(segment_lengths)
    println("No intersections found. Check parameters.")
else
    mean_path = mean(segment_lengths)
    std_path = std(segment_lengths)
    max_path = maximum(segment_lengths)
    total_segments = length(segment_lengths)
    
    println("Total Void Segments Traversed: $total_segments")
    println("Mean Free Path (Avg Chord): $(round(mean_path, digits=4))")
    println("Std Dev: $(round(std_path, digits=4))")
    println("Max Path: $(round(max_path, digits=4))")

    # Timestamp
    timestamp = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM-SS")

    # Plot Histogram
    histogram(segment_lengths,
        bins = 50,
        color = :red,
        alpha = 0.6,
        label = "Chord Lengths",
        xlabel = "Path Length inside Void",
        ylabel = "Frequency",
        title = "Void Transparency Statistics (Beam X-Axis) - $(timestamp)",
        legend = :topright,
        size = (800, 600)
    )
    
    # Add vertical line for mean
    vline!([mean_path], color=:black, linewidth=3, label="Mean: $(round(mean_path, digits=2))")

    outfile = "plots/mean_free_path_histogram_$(timestamp).png"
    savefig(outfile)
    println("Saved plot to $outfile")
end

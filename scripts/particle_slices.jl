using Plots
using Dates
using LinearAlgebra
using Random

Random.seed!(42)

# Parameters
center = 5.0
radius = 4.5
num_points = 50000 # Dense cloud to make slice visible

# Generate dense particle cloud inside the sphere
# (Simulating the "Flow" or "Medium")
points = []
for _ in 1:num_points
    p = rand(3) .* 10.0
    if norm(p .- center) <= radius
        push!(points, p)
    end
end

px = [p[1] for p in points]
py = [p[2] for p in points]
pz = [p[3] for p in points]

# Create Slices for Z = 1 to 9
# We take a thin slice +/- epsilon
epsilon = 0.1

println("Generating slices...")

timestamp = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM-SS")

anim = @animate for z_val in 1:9
    # Filter points within the slice
    # Logic: |z - z_val| < epsilon
    indices = findall(z -> abs(z - z_val) < epsilon, pz)
    
    slice_x = px[indices]
    slice_y = py[indices]
    
    scatter(slice_x, slice_y,
        xlims = (0, 10),
        ylims = (0, 10),
        markersize = 2,
        color = :black,
        legend = false,
        aspect_ratio = :equal,
        title = "Slice at Z = $z_val (Light Paths) - $(timestamp)",
        xlabel = "X",
        ylabel = "Y"
    )
    # The "empty" white space represents where NO particles are => Light paths?
    # Or should we inverse it? Assuming emptiness = white background.
end

# Save as both individual frames (optional) and GIF
gif(anim, "plots/particle_slices_scan_$(timestamp).gif", fps = 2)
println("Saved plots/particle_slices_scan_$(timestamp).gif")

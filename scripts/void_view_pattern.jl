using Plots
using Dates
using LinearAlgebra
using Random

Random.seed!(42)

# ==========================================
# 1. Setup Voids (Deterministically)
# ==========================================
center = 5.0
sphere_radius = 4.5
num_voids = 30
min_void_radius = 0.4
max_void_radius = 0.8

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
# 2. View from the "Central" Void
# ==========================================
# Find the void closest to the center (5,5,5)
dists = [norm(v[1] .- center) for v in voids]
center_idx = argmin(dists)
observer_pos = voids[center_idx][1]
println("Observer Void at: $observer_pos")

# Project neighbors onto the "Sky" (Unit Sphere)
# We calculate the vector (Neighbor - Observer) and normalize it.
theta_vals = Float64[] # Azimuth
phi_vals = Float64[]   # Elevation

sky_x = Float64[]
sky_y = Float64[]
sky_z = Float64[]

for i in 1:length(voids)
    if i == center_idx
        continue
    end
    
    vec = voids[i][1] .- observer_pos
    dir = normalize(vec)
    
    push!(sky_x, dir[1])
    push!(sky_y, dir[2])
    push!(sky_z, dir[3])
end

# ==========================================
# 3. Visualization (The Sky Map)
# ==========================================
timestamp = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM-SS")

# Plot 1: 3D Unit Sphere with Points
p1 = scatter(sky_x, sky_y, sky_z,
    markercolor = :red,
    markersize = 5,
    xlims = (-1,1), ylims=(-1,1), zlims=(-1,1),
    xlabel = "X", ylabel = "Y", zlabel = "Z",
    title = "Void Sky Map (View from Center) - $(timestamp)",
    label = "Neighbor Voids",
    camera = (30, 30),
    aspect_ratio = :equal,
    size = (600, 600)
)

# Draw generic wireframe sphere for reference - Simplified to just lines or removed if causing issues
# Let's try removing the surface! call to see if it fixes the GR backend error.
# n = 20
# u = range(0, 2pi, length=n)
# v = range(0, pi, length=n)
# sx = cos.(u) * sin.(v)'
# sy = sin.(u) * sin.(v)'
# sz = repeat(cos.(v)', n, 1)
# surface!(p1, sx, sy, sz, color=:grey, alpha=0.1)

savefig(p1, "plots/void_view_pattern_$(timestamp).png")
println("Saved plots/void_view_pattern_$(timestamp).png")

# Optional: Output statistics on angular separation?
# Simple sanity check for symmetry.
println("Sky Map Generated. Check visual for symmetries (Tetrahedron/Icosahedron).")

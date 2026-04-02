using Plots
using Dates
using LinearAlgebra

# Parameters
iterations = 5
initial_side_length = 2.0
center = [0.0, 0.0, 0.0]

# Function to draw a wireframe cube
function get_cube_wireframe(side_length, center)
    r = side_length / 2.0
    cx, cy, cz = center

    # Define corners
    # Bottom square
    x = [cx - r, cx + r, cx + r, cx - r, cx - r, NaN, cx - r, cx + r, cx + r, cx - r, cx - r]
    y = [cy - r, cy - r, cy + r, cy + r, cy - r, NaN, cy - r, cy - r, cy + r, cy + r, cy - r]
    z = [cz - r, cz - r, cz - r, cz - r, cz - r, NaN, cz + r, cz + r, cz + r, cz + r, cz + r]

    # Vertical lines connecting top and bottom
    append!(x, [NaN, cx + r, cx + r, NaN, cx + r, cx + r, NaN, cx - r, cx - r])
    append!(y, [NaN, cy - r, cy - r, NaN, cy + r, cy + r, NaN, cy + r, cy + r])
    append!(z, [NaN, cz - r, cz + r, NaN, cz - r, cz + r, NaN, cz - r, cz + r])

    return x, y, z
end

# Function to get sphere surface points
function get_sphere_surface(radius, center)
    n = 30
    u = range(0, 2pi, length=n)
    v = range(0, pi, length=n)

    x = radius * cos.(u) * sin.(v)' .+ center[1]
    y = radius * sin.(u) * sin.(v)' .+ center[2]
    z = radius * repeat(cos.(v)', n, 1) .+ center[3]
    return x, y, z
end

# Initialize Plot
timestamp = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM-SS")

p = plot(
    xlabel="X", ylabel="Y", zlabel="Z",
    title="Expanding Spheres & Cubes (Iter: $iterations) - $(timestamp)",
    legend=false,
    aspect_ratio=:equal,
    camera=(30, 30),
    size=(800, 600)
)

current_side = initial_side_length

println("Generating Geometry...")

for i in 1:iterations
    println("Iteration $i: Side Length = $current_side")

    # 1. Draw Cube
    cx, cy, cz = get_cube_wireframe(current_side, center)
    plot!(p, cx, cy, cz, color=:blue, label="Cube $i")

    # 2. Inscribed Sphere Radius = Side / 2
    r_inscribed = current_side / 2.0

    # 3. Draw Sphere
    sx, sy, sz = get_sphere_surface(r_inscribed, center)
    surface!(p, sx, sy, sz, color=:red, alpha=0.1)

    # 4. Calculate Next Radius (Hypotenuse from center to corner)
    # Distance to corner = sqrt((L/2)^2 + (L/2)^2 + (L/2)^2) = L/2 * sqrt(3)
    hypotenuse = sqrt((current_side / 2)^2 * 3)

    # 5. New Inscribed Radius is this Hypotenuse
    # So New Side Length = 2 * Hypotenuse
    global current_side = 2 * hypotenuse
end

plots_dir = normpath(joinpath(@__DIR__, "..", "plots"))
mkpath(plots_dir)
output_file = joinpath(plots_dir, "expanding_spheres_$(timestamp).png")

savefig(output_file)
println("Saved $(output_file)")

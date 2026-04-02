using Plots
using Dates
using LinearAlgebra
using Random

# Set random seed
Random.seed!(42)

# Parameters
center = 5.0
radius = 4.5
num_particles = 100
dt = 0.1
steps = 100

# Initialize random particles INSIDE the sphere
particles = []
while length(particles) < num_particles
    # Random point in 10x10x10 box
    p = rand(3) .* 10.0
    # Check if inside sphere
    if norm(p .- center) < radius
        push!(particles, p)
    end
end

# Extract coords for plotting
function get_coords(parts)
    px = [p[1] for p in parts]
    py = [p[2] for p in parts]
    pz = [p[3] for p in parts]
    return px, py, pz
end

# Vector Field Function (Continuous version of the discrete one)
function time_field(p, center, radius)
    dist = norm(p .- center)
    if dist > radius
        return [0.0, 0.0, 0.0] # No time outside
    else
        # "Chaotic" flow: depends on position in a complex way
        # Using sin/cos to make it smooth but swirling
        tx = sin(p[2])*cos(p[3])
        ty = sin(p[3])*cos(p[1])
        tz = sin(p[1])*cos(p[2])
        return [tx, ty, tz]
    end
end

# Animation Loop
anim = @animate for t in 1:steps
    global particles
    
    # Update particle positions
    new_particles = []
    for p in particles
        v = time_field(p, center, radius)
        new_p = p .+ v .* dt
        
        # Constraint check: If it hits the boundary, bounce or stop?
        # Let's make them 'slide' along the surface or just stop for now if they exit
        if norm(new_p .- center) > radius
            # Simple bounce back (reflect velocity) - or just clamp to surface
            # Clamping to surface:
            dir = normalize(new_p .- center)
            new_p = center .+ dir .* (radius - 0.01)
        end
        push!(new_particles, new_p)
    end
    particles = new_particles
    
    px, py, pz = get_coords(particles)
    
    scatter(px, py, pz,
        xlims=(0,10), ylims=(0,10), zlims=(0,10),
        title="3D Time Flow (Step $t) - $(timestamp)",
        markersize=3,
        color=:red,
        legend=false,
        camera=(30, 30), # Rotate graphical camera for effect?
        alpha=0.6,
        size=(800, 600)
    )
    
    # Optional: Add wireframe sphere 
    # (Leaving out for speed/clarity here, can add if requested)
end

gif(anim, "plots/particle_flow_$(timestamp).gif", fps = 15)
println("Saved plots/particle_flow_$(timestamp).gif")

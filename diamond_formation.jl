using Plots
using Dates
using LinearAlgebra
using Random
using Statistics

Random.seed!(42)

# ==========================================
# 1. Simulation Parameters
# ==========================================
num_voids = 27 # 3x3x3 for a perfect cube lattice target
box_size = 6.0
iterations = 200
start_temp = 2.0
end_temp = 0.01

# "Pressure" here acts as a force driving them towards the center/compaction
pressure_strength = 0.05

# Initialize Random Voids (Coal State)
# Restrict to a slightly larger box initially to show compaction
voids = [rand(3) .* 8.0 .- 4.0 for _ in 1:num_voids] 
# Center roughly around 0,0,0

# ==========================================
# 2. Energy Function (The "Hamiltonian")
# ==========================================
# We want to minimize Energy.
# Energy = Repulsion (don't overlap) + Attraction (Pressure/Compaction) + Lattice alignment?
# Actually, simple packing often yields lattices.
# Let's use a Lennard-Jones-like potential tailored for "Hard Spheres" + "Pressure"

function calculate_energy(positions, pressure)
    total_energy = 0.0
    ideal_dist = 2.0 # Target spacing for our lattice
    
    # Pairwise interactions (Repulsion/Attraction)
    for i in 1:length(positions)
        # Pressure Term: Energy increases with distance from center (Simulates external pressure box)
        dist_to_center = norm(positions[i])
        total_energy += pressure * dist_to_center^2
        
        for j in (i+1):length(positions)
            r = norm(positions[i] .- positions[j])
            
            # Repulsion if too close (Hard sphere-ish)
            if r < ideal_dist * 0.8
                total_energy += 100.0 * (ideal_dist*0.8 - r)^2
            end
            
            # Attraction / Regularizer to encourage neighbors?
            # Actually, standard pressure + hard sphere usually crystallizes.
            # Let's add a slight "spring" to ideal distance to encourage regularity
            # but getting perfect diamond structure specifically might require specific potentials.
            # For this "Toy Model", we just want "Ordered Packing".
            if r < ideal_dist * 1.5
                 # Weak spring to ideal distance
                 total_energy += 2.0 * (r - ideal_dist)^2
            end
        end
    end
    return total_energy
end

# ==========================================
# 3. Simulated Annealing Loop
# ==========================================
println("Starting Diamond Genesis Simulation...")
println("Initial State: Coal (Random)")

anim = @animate for iter in 1:iterations
    # 1. Calculate Current Temperature (Cooling Schedule)
    temp = start_temp * (end_temp / start_temp)^((iter-1)/(iterations-1))
    
    # 2. Perturb System (Try to move a random void)
    # Perform multiple sub-steps per frame for smoother convergence
    for _ in 1:50
        idx = rand(1:num_voids)
        old_pos = voids[idx]
        
        # Random move scaled by Temperature
        move = (rand(3) .- 0.5) .* temp
        new_pos = old_pos .+ move
        
        # Calculate Energy Change
        # Optimization: Only calc delta for the moved particle? 
        # For simplicity in this script, calc full difference (num_voids is small)
        temp_voids = copy(voids)
        temp_voids[idx] = new_pos
        
        E_old = calculate_energy(voids, pressure_strength)
        E_new = calculate_energy(temp_voids, pressure_strength)
        dE = E_new - E_old
        
        # Metropolis Criterion
        points = false
        if dE < 0
            point = true # Always accept lower energy
        elseif rand() < exp(-dE / temp)
            point = true # Sometimes accept higher energy (Thermal fluctuation)
        else
            point = false
        end
        
        if point
            voids[idx] = new_pos
        end
    end
    
    # 3. Visualization Frame
    vx = [v[1] for v in voids]
    vy = [v[2] for v in voids]
    vz = [v[3] for v in voids]
    
    # Calculate "Order Parameter" (simple variance of nearest neighbor distances?)
    # Just show Temp/Pressure in title
    
    scatter(vx, vy, vz,
        xlims=(-5,5), ylims=(-5,5), zlims=(-5,5),
        markercolor = :cyan,
        markersize = 6,
        xlabel = "X", ylabel = "Y", zlabel = "Z",
        title = "Diamond Genesis: T=$(round(temp, digits=3))",
        label = "Carbon Voids",
        camera = (30 + iter/2, 30),
        size = (600, 600),
        alpha = 0.8
    )
end

timestamp = Dates.format(Dates.now(), "yyyy-mm-dd_HH-MM-SS")
gif(anim, "plots/diamond_formation_$(timestamp).gif", fps = 15)
println("Saved plots/diamond_formation_$(timestamp).gif")

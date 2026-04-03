# Analysis of `diamond_formation.jl`: Diamond Genesis Simulation

`diamond_formation.jl` is a Julia simulation that models the physical transition of carbon atoms from a disordered state (coal) into an ordered crystalline structure (diamond) using **Simulated Annealing**.

## 1. Physical Conceptualization
The script treats carbon atoms as "voids" or particles in a 3D box. The goal is to find the ground state—the configuration with the lowest possible energy—which, in nature, corresponds to a highly symmetric diamond lattice.

### The Problem Space
- **Initial State**: "Coal" – 27 particles (representing a 3x3x3 target cube) randomly scattered in a 3D space (`rand(3) .* 8.0 .- 4.0`).
- **Target State**: "Diamond" – A highly packed, ordered arrangement of these particles.

---

## 2. The Hamiltonian (Energy Function)
The core of the simulation is the `calculate_energy` function, which determines how "happy" the system is. It uses three distinct physical forces:

### A. External Pressure (Compaction)
```julia
dist_to_center = norm(positions[i])
total_energy += pressure * dist_to_center^2
```
This term simulates a gravitational or mechanical pressure pulling all particles toward the origin (0,0,0). Without this, the particles would simply drift apart.

### B. Pauli-like Repulsion (Hard Spheres)
```julia
if r < ideal_dist * 0.8
    total_energy += 100.0 * (ideal_dist*0.8 - r)^2
end
```
To prevent particles from collapsing into a single point, a strong quadratic penalty is applied if they get too close. This mimics the electronic repulsion between atoms.

### C. Lattice Alignment (Spring Potential)
```julia
if r < ideal_dist * 1.5
    total_energy += 2.0 * (r - ideal_dist)^2
end
```
This "spring" force encourages neighbors to maintain a specific `ideal_dist`. This is the key driver of geometry; it rewards particles for forming regular, repeating patterns.

---

## 3. Methodology: Simulated Annealing
The script employs a **Metropolis-Hastings algorithm** across 200 iterations to "cool" the system.

1.  **Cooling Schedule**: The `temp` (temperature) starts high (allowing particles to move wildly) and exponentially decays to near zero.
2.  **Perturbation**: In each frame, 50 random moves are attempted for various particles.
3.  **Metropolis Criterion**:
    - If a move **lowers** the energy, it is **accepted**.
    - If a move **increases** the energy, it is **sometimes accepted** based on the current temperature ($P = \exp(-dE / T)$).

> [!NOTE]
> This "thermal fluctuation" allows the system to escape local minima (messy clumps) to find the global minimum (the perfect lattice).

---

## 4. Output and Visualization
The simulation produces a dynamic 3D scatter plot animation saved as a GIF:
- **Visuals**: Particles start as a chaotic cloud (cyan) and gradually consolidate into a tight, ordered cluster.
- **Camera**: The viewpoint rotates (`camera = (30 + iter/2, 30)`) to provide a full 3D perspective of the formation process.
- **Feedback**: The title tracks the current temperature ($T$), showing the "freezing" of the system into its final crystal form.

---

## Summary of Parameters
| Parameter | Value | Description |
| :--- | :--- | :--- |
| `num_voids` | 27 | Number of carbon particles (3x3x3). |
| `iterations` | 200 | Length of the cooling process. |
| `ideal_dist` | 2.0 | Targeted bonding distance between atoms. |
| `pressure_strength` | 0.05 | Force driving the compaction. |

This script serves as a high-level "toy model" for understanding how macroscopic order emerges from microscopic interactions under extreme pressure.

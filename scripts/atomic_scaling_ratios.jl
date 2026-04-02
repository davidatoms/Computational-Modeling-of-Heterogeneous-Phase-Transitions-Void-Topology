using Printf

# ==========================================
# 1. Real World Physical Architecture
# ==========================================
# approximate values in SI units (meters)
const a0 = 5.29177e-11   # Bohr radius (Hydrogen atom radius)
const rp = 8.414e-16     # Proton radius (Charge radius)
const re = 2.8179e-15    # Classical electron radius
const lp = 1.6162e-35    # Planck length

# Fundamental Constants
const alpha = 7.29735e-3 # Fine structure constant (~1/137.036)

println("=== 1. Real World Physical Ratios ===")
@printf("  Proton / Atom (Size):       %.2e (Nucleus is tiny!)\n", rp / a0)
@printf("  Electron / Atom (Size):     %.2e\n", re / a0)
@printf("  Fine Structure (alpha):     %.5f (1/137)\n", alpha)
@printf("  sqrt(alpha):                %.5f\n", sqrt(alpha))

# ==========================================
# 2. Toy Model Architecture
# ==========================================
# Values derived from our generation scripts
const R_sys = 4.5          # System Radius (Constraint Sphere)
const R_void_avg = 0.6     # Approximate avg radius of generated voids (0.4 to 0.8 range)
const MeanFreePath = 0.76  # Derived from simulation
const L_expansion = sqrt(3) # Expansion factor

println("\n=== 2. Toy Model Geometric Ratios ===")
# Ratio 1: Void Size vs System Size
const ratio_void_sys = R_void_avg / R_sys
@printf("  Void / System (Size):       %.4f\n", ratio_void_sys)

# Ratio 2: Vacuum Transparency vs System
const ratio_mfp_sys = MeanFreePath / R_sys
@printf("  Mean Free Path / System:    %.4f\n", ratio_mfp_sys)

# Ratio 3: Inverse of Expansion
const inv_expansion = 1 / L_expansion
@printf("  1 / Expansion (1/sqrt(3)):  %.4f\n", inv_expansion)

# ==========================================
# 3. Hypothesis Testing
# ==========================================
println("\n=== 3. Comparison & Hypothesis ===")

# Hypothesis A: Voids are Nuclei?
# Real: 1.6e-5
# Toy:  0.133
# Result: Voids are WAY too big to be nuclei in an atom model.
@printf("  Hypothesis A (Atom Model):  Mismatch. Toy Voids are ~%d times larger than protons rel. to atom.\n", round(ratio_void_sys / (rp/a0)))

# Hypothesis B: Fine Structure Connection?
# Alpha = 0.007
# Toy = 0.133
# Maybe Toy ~ sqrt(alpha)? sqrt(0.007) = 0.085. Close-ish to 0.133? No, factor of 1.5 off.
diff_sqrt_alpha = abs(ratio_void_sys - sqrt(alpha))
@printf("  Hypothesis B (Alpha):       No direct match. (Toy %.3f vs sqrt(alpha) %.3f)\n", ratio_void_sys, sqrt(alpha))

# Hypothesis C: Strong Interaction / Packing?
# In a Nucleus, nucleons are packed densely.
# Ratio of nucleon radius to nucleus radius for e.g. Carbon-12?
# R_nucleus ~ r0 * A^(1/3). A=12 -> 1.2fm * 2.29 = 2.75fm.
# Nucleon radius ~ 0.84fm.
# Ratio ~ 0.84 / 2.75 = 0.30.
# Our Toy Ratio is 0.133.
# This is closer! 
@printf("  Hypothesis C (Nucleus Model): Plausible.\n")
@printf("    In a physical nucleus, geometry is packed. Ratio of nucleon/nucleus ~0.3.\n")
@printf("    Our Toy Ratio (0.13) represents a 'looser' packing than a nucleus, or a larger system.\n")

println("\nConclusion:")
println("The Toy Model geometry does NOT resemble an electronic atom (mostly empty space).")
println("It resembles a DENSE LIQUID or NUCLEAR MATTER (packed bubbles),")
println("where the 'voids' take up a significant fraction of the volume.")

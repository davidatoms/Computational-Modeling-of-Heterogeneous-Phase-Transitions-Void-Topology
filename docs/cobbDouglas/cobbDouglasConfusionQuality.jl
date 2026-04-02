using Distributions, Plots

# Quality parameters
q_high = 1.3   # High-quality multiplier
q_low = 0.5    # Low-quality multiplier
c_rework = 1.0 # Cost of rework (time, audits)
c_missed = 0.8 # Opportunity cost of not automating

# Confusion matrix probabilities
TP = 0.6; FP = 0.2; FN = 0.1; TN = 0.1

# Calculate A for the firm
A_firm = TP * q_high + FP * (q_low - c_rework) - FN * c_missed

# Spillover: Other firms' productivity depends on the adopting firm's quality
spillover_positive = 0.2 * (A_firm > 0.8 ? 0.1 : 0)  # Only if A_firm is high
spillover_negative = -0.1 * (FP > 0.1 ? 0.2 : 0)     # If FP is high
A_rest = 1.0 + spillover_positive + spillover_negative

# Production
K_firm = 100; L_firm = 50; α = 0.3; β = 0.7
Y_firm = A_firm * K_firm^α * L_firm^β

K_rest = 500; L_rest = 300
Y_rest = A_rest * K_rest^α * L_rest^β

# Total output
Y_total = Y_firm + Y_rest
println("Firm's quality-adjusted A: ", A_firm)
println("Rest of economy's A: ", A_rest)
println("Total output: ", Y_total)

# Plot the impact of FP (low quality) on A_firm
FP_range = 0:0.05:0.4
A_firm_values = [ (0.8 - fp) * q_high + fp * (q_low - c_rework) - 0.1 * c_missed for fp in FP_range ]
plot(FP_range, A_firm_values,
     xlabel="False Positive Rate (FP)",
     ylabel="Firm's A (Quality-Adjusted)",
     title="Impact of Low Quality on Productivity",
     label="A_firm vs. FP")

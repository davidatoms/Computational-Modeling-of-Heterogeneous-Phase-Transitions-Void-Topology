using Distributions, Statistics

# Probabilities for the confusion matrix
TP = 0.2  # True positive rate
FP = 0.3  # False positive rate
FN = 0.1  # False negative rate
TN = 0.4  # True negative rate

# Value and costs
value_TP = 1.0   # Value created by a successful match
cost_FP = 0.5    # Cost of a failed match
cost_FN = 0.3    # Opportunity cost of a missed match

# Effective A for one trial
A_trial() = rand() < TP ? value_TP :
            rand() < FP ? -cost_FP :
            rand() < FN ? -cost_FN : 0.0

# Simulate many trials
n_trials = 1000
A_values = [A_trial() for _ in 1:n_trials]
Y = A_values .* (K^α * L^β)  # K, L, α, β as before

# Analyze results
mean_A = mean(A_values)
mean_Y = mean(Y)
println("Effective A: ", mean_A)
println("Expected Output: ", mean_Y)

# Plot distribution of A
using Plots
histogram(A_values, bins=20, xlabel="A (Productivity Outcome)", ylabel="Frequency", title="Distribution of A (Confusion Matrix)")
vline!([mean_A], label="Mean A", linestyle=:dash)

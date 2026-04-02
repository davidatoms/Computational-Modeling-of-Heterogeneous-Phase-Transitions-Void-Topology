using DataFrames, Plots

# Input parameters for 1,000 units
params = (
    with_AI = (
        labor_cost_per_unit = 8,
        AI_cost_per_unit = 1,
        defects = (low=30, medium=40, high=15),
        rework_cases = 50,
        defect_costs = (low=10, medium=50, high=200),
        rework_cost_per_case = 100,
        rework_time_per_case = 2,
        labor_rate = 25
    ),
    without_AI = (
        labor_cost_per_unit = 10,
        AI_cost_per_unit = 0,
        defects = (low=20, medium=30, high=10),
        rework_cases = 17,
        defect_costs = (low=10, medium=50, high=200),
        rework_cost_per_case = 100,
        rework_time_per_case = 2,
        labor_rate = 25
    ),
    units = 1000
)

# Calculate direct costs
direct_cost(params, scenario) = params[scenario].labor_cost_per_unit * params.units + params[scenario].AI_cost_per_unit * params.units

# Calculate defect costs
defect_cost(params, scenario) = params[scenario].defects.low * params[scenario].defect_costs.low +
                                params[scenario].defects.medium * params[scenario].defect_costs.medium +
                                params[scenario].defects.high * params[scenario].defect_costs.high

# Calculate rework costs
rework_cost(params, scenario) = params[scenario].rework_cases * params[scenario].rework_time_per_case * params[scenario].labor_rate +
                                params[scenario].rework_cases * params[scenario].rework_cost_per_case

# Calculate total cost
total_cost(params, scenario) = direct_cost(params, scenario) + defect_cost(params, scenario) + rework_cost(params, scenario)

# Compute costs
direct_AI = direct_cost(params, :with_AI)
direct_manual = direct_cost(params, :without_AI)

defect_AI = defect_cost(params, :with_AI)
defect_manual = defect_cost(params, :without_AI)

rework_AI = rework_cost(params, :with_AI)
rework_manual = rework_cost(params, :without_AI)

total_AI = total_cost(params, :with_AI)
total_manual = total_cost(params, :without_AI)

# Print results
println("Cost Comparison for $(params.units) Units:")
println("----------------------------------------")
println("Direct Costs: With AI = \$$direct_AI, Without AI = \$$direct_manual")
println("Defect Costs: With AI = \$$defect_AI, Without AI = \$$defect_manual")
println("Rework Costs: With AI = \$$rework_AI, Without AI = \$$rework_manual")
println("Total Costs: With AI = \$$total_AI, Without AI = \$$total_manual")
println("Net Difference: \$$(total_AI - total_manual) (AI is \$$(total_AI - total_manual) more expensive)")

# Plot results
cost_data = DataFrame(
    Scenario = ["With AI", "Without AI"],
    Direct = [direct_AI, direct_manual],
    Defects = [defect_AI, defect_manual],
    Rework = [rework_AI, rework_manual],
    Total = [total_AI, total_manual]
)

bar(cost_data.Scenario, Matrix(cost_data[:, 2:end]),
    label=["Direct Costs" "Defect Costs" "Rework Costs" "Total Costs"],
    title="Cost Comparison: AI vs. Manual",
    ylabel="Cost (\$)",
    bar_width=0.7,
    legend=:topleft)

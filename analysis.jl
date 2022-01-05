# Run run_comparison.jl first to get comparison.csv
using Colors, Plots, CSV, DataFrames, Statistics

data = CSV.read("comparison.csv", DataFrame)
sort!(data, [:method, :problem, :verbose])

methods = sort(unique(data.method))
problems = sort(unique(data.problem))

colors = [
  HSL(x, 1.0, 0.5) for x in range(0, 360, length=length(methods) + 1)
][1:end-1]

δ = 0.4 / length(methods)
x = collect(1:length(problems)) .- δ * length(methods) / 2

isdir("plots") || mkdir("plots")
# Benchmark plot: Average time over problem
for vb in [false, true]
  plt = plot(yaxis=:log)
  plt_rel = plot()
  best_μ = fill(Inf, length(problems))
  for (i, mtd) in enumerate(methods)
    I = findall(data.method .== mtd .&& data.verbose .== vb)
    M = Matrix(data[I,4:end])
    # scatter!(M, c=colors[i], opacity=0.3, lab="")
    μ = mean(M, dims=2)[:]
    best_μ .= min.(best_μ, μ)
    scatter!(plt, x .+ δ * i, μ, c=colors[i], lab=mtd, opacity=0.8)
  end
  for (i, mtd) in enumerate(methods)
    I = findall(data.method .== mtd .&& data.verbose .== vb)
    M = Matrix(data[I,4:end])
    # scatter!(M, c=colors[i], opacity=0.3, lab="")
    μ = mean(M, dims=2)[:]
    scatter!(plt_rel, x .+ δ * i, μ ./ best_μ, c=colors[i], lab=mtd, opacity=0.8)
  end
  xticks!(plt, 1:length(problems), problems)
  xticks!(plt_rel, 1:length(problems), problems)
  png(plt, "plots/comparison-v$vb")
  png(plt_rel, "plots/rel-comparison-v$vb")
end
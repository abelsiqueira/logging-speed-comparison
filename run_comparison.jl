using CSV, DataFrames, CUTEst, Logging
include("strategies.jl")

# Create files with different strategies
template = read("method.jl.template", String)
methods = []
isdir("generated") || mkdir("generated")
for (key, strat) in strategies
  filename = "generated/method_$key.jl"
  mtd = "method_$key"
  push!(methods, mtd)
  open(filename, "w") do io
    println(
      io,
      replace(
        template,
        "%%PKGS%%" => strat[:pkgs],
        "%%METHODNAME%%" => mtd,
        "%%INITIAL%%" => strat[:initial],
        "%%LOG%%" => strat[:log],
      ),
    )
  end
  include(filename)
end

# Test that created files work
nlp = CUTEstModel("CUBE")
try
  for mtd in methods, v in [0, 1]
    reset!(nlp)
    @info "Testing $mtd"
    foo = eval(Symbol(mtd))
    iter, x, fx, status, Δt = foo(nlp; verbose = v, max_eval = 10)
    @info "iter = $iter, fx = $fx, status = $status, Δt = $Δt"
  end
catch ex
  @error "Not working"
  rethrow(ex)
finally
  finalize(nlp)
end


# Problem selection
problems = ["CUBE", "ROSENBR", "HILBERTB", "ARGLINC", "BROWNAL", "GENROSE", "PENALTY1", "SBRYBND"]

# Run and collect
tries = 50
data = DataFrame(
  "method" => String[],
  "problem" => String[],
  "verbose" => Bool[],
  ["col$i" => Float64[] for i = 1:tries]...,
)

for mtd in methods, p in problems, v in [0, 1]
  times = []
  @info "Problem $p"
  nlp = CUTEstModel(p)
  try
    for t = 1:tries
      reset!(nlp)
      foo = eval(Symbol(mtd))
      logger = v > 0 ? ConsoleLogger() : NullLogger()
      iter, x, fx, status, Δt = with_logger(logger) do
        foo(nlp; verbose = v)
      end
      push!(times, Δt)
    end
  catch ex
    rethrow(ex)
  finally
    finalize(nlp)
  end
  push!(data, [mtd; p; v; times])
end

data |> CSV.write("comparison.csv")
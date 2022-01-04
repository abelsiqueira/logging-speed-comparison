strategies = Dict(
  "krylov" => (
    description = "Current Krylov.jl strategy",
    pkgs = "using Printf",
    log = "verbose > 0 && @printf(\"%04d %+9.1e %8.1e\\n\", iter, fx, slope)",
  ),
  "logging_no_check" => (
    description = "Logging without checking for the verbose value",
    pkgs = "using Printf",
    log = "@info @sprintf(\"%04d %+9.1e %8.1e\\n\", iter, fx, slope)",
  ),
  "logging_w_check" => (
    description = "Logging checking for the verbose value",
    pkgs = "using Printf",
    log = "verbose > 0 && @info @sprintf(\"%04d %+9.1e %8.1e\\n\", iter, fx, slope)",
  ),
)
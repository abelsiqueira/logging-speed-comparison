strategies = Dict(
  "krylov" => (
    description = "Current Krylov.jl strategy",
    pkgs = "using Printf",
    initial = "",
    log = "verbose > 0 && @printf(\"%04d %+9.1e %8.1e\\n\", iter, fx, slope)",
  ),
  "logging_no_check" => (
    description = "Logging without checking for the verbose value",
    pkgs = "using Printf",
    initial = "",
    log = "@info @sprintf(\"%04d %+9.1e %8.1e\\n\", iter, fx, slope)",
  ),
  "logging_w_check" => (
    description = "Logging checking for the verbose value",
    pkgs = "using Printf",
    initial = "",
    log = "verbose > 0 && @info @sprintf(\"%04d %+9.1e %8.1e\\n\", iter, fx, slope)",
  ),
  "formatter" => (
    description = "Package Formatting instead of Printf",
    pkgs = "using Formatting",
    initial = """
      fmts = generate_formatter.([\"%04d\", \"%+9.1e\", \"%8.1e\"])\n
      fmtter(k, fx, ngx) = fmts[1](k) * " " * fmts[2](fx) * " " * fmts[3](ngx)
    """,
    log = "verbose > 0 && @info fmtter(iter, fx, slope)"
  ),
  "ccall" => (
    description = "Using ccall directly",
    pkgs = "",
    initial = "fmt = \"%04d %+9.1e %8.1e\\n\"",
    log = "verbose > 0 && ccall(:printf, Cint, (Cstring, Cint, Cdouble, Cdouble), fmt, iter, fx, slope)",
  ),
)
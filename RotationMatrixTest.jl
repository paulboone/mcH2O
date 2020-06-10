using DataFrames
using CSV
using LinearAlgebra
using Plots


function rotation_matrix(;scale::Float64=1.0)
    θ = 2π * scale * (rand() - 0.5)
    ϕ = 2π * rand()
    z = rand() * scale

    V = [cos(ϕ) * √z, sin(ϕ) * √z, √(1.0 - z)]
    r = [-cos(θ) -sin(θ) 0.0; sin(θ) -cos(θ) 0.0; 0.0 0.0 1.0]

    M = (2 * V * transpose(V) - Matrix{Float64}(I, 3, 3)) * r
    return M
end

plotly()

function output_fig(scale; v=[1.0; 0.0; 0.0], fn="rm.html", num=100)
    df = DataFrame(:x => [], :y => [], :z => [])
    for i = 1:num
        push!(df, rotation_matrix(scale=scale) * v)
    end
    scatter(df.x, df.y, df.z, markersize=2, 
            xlims=(-1.0, 1.0), ylims=(-1.0, 1.0), zlims=(-1.0, 1.0), 
            xlabel="x", ylabel="y", zlabel="z")
    scatter!([-1,1,0,0,0,0], [0,0,-1,1,0,0], [0,0,0,0,-1,1], color="black", markersize = 2)
    scatter!(tuple(v...), color="black", markersize = 10)

    savefig(fn)
end
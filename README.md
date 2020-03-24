



## trial histogram

- use PorousMaterials.jl branch "trials-only"
- 



## view adsorbates

run split_xyz.py on gcmc_* concatenated xyz file
open in iraspa and layer on top of zif-8

## Plot E by mc move

```julia
mp = include("egraph-plotsjl.jl")
savefig(mp, "e_batch.png")
```

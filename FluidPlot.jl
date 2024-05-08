function flood(f::Array;shift=(0.,0.),cfill=:RdBu_11,clims=(),levels=10,kv...)
    if length(clims)==2
        @assert clims[1]<clims[2]
        @. f=min(clims[2],max(clims[1],f))
    else
        clims = (minimum(f),maximum(f))
    end
    Plots.contourf(axes(f,1).+shift[1],axes(f,2).+shift[2],f',
        linewidth=0, levels=levels, color=cfill, clims = clims, 
        aspect_ratio=:equal; kv...)
end

# addbody(x,y;c=:black) = Plots.plot!(Shape(x,y), c=c, legend=false)
# function body_plot!(sim;levels=[0],lines=:black,R=inside(sim.flow.p))
#     WaterLily.measure_sdf!(sim.flow.σ,sim.body,WaterLily.time(sim))
#     contour!(sim.flow.σ[R]'|>Array;levels,lines)
# end

# function sim_gif!(sim;duration=1,step=0.1,verbose=true,R=inside(sim.flow.p),
#                     remeasure=false,plotbody=false,kv...)
#     t₀ = round(sim_time(sim))
#     @time @gif for tᵢ in range(t₀,t₀+duration;step)
#         sim_step!(sim,tᵢ;remeasure)
#         @inside sim.flow.σ[I] = WaterLily.curl(3,I,sim.flow.u)*sim.L/sim.U
#         flood(sim.flow.σ[R]|>Array; kv...)
#         plotbody && body_plot!(sim)
#         verbose && println("tU/L=",round(tᵢ,digits=4),
#             ", Δt=",round(sim.flow.Δt[end],digits=3))
#     end
# end
# using GLMakie
# GLMakie.activate!()
# function makie_video!(makie_plot,sim,dat,obs_update!;remeasure=false,name="file.mp4",duration=1,step=0.1,framerate=30,compression=20)
#     # Set up viz data and figure
#     obs = obs_update!(dat,sim) |> Observable;
#     f = makie_plot(obs)
    
#     # Run simulation and update figure data
#     t₀ = round(sim_time(sim))
#     t = range(t₀,t₀+duration;step)
#     record(f, name, t; framerate, compression) do tᵢ
#         sim_step!(sim,tᵢ;remeasure)
#         obs[] = obs_update!(dat,sim)
#         println("simulation ",round(Int,(tᵢ-t₀)/duration*100),"% complete")
#     end
#     return f
# end

# using Meshing, GeometryBasics
# function body_mesh(sim,t=0)
#     a = sim.flow.σ; R = inside(a)
#     WaterLily.measure_sdf!(a,sim.body,t)
#     normal_mesh(GeometryBasics.Mesh(a[R]|>Array,MarchingCubes(),origin=Vec(0,0,0),widths=size(R)))
# end;
# function flow_λ₂!(dat,sim)
#     a = sim.flow.σ
#     @inside a[I] = max(0,log10(-min(-1e-6,WaterLily.λ₂(I,sim.flow.u)*(sim.L/sim.U)^2))+.25)
#     copyto!(dat,a[inside(a)])                  # copy to CPU
# end
# function flow_λ₂(sim)
#     dat = sim.flow.σ[inside(sim.flow.σ)] |> Array
#     flow_λ₂!(dat,sim)
#     dat
# end
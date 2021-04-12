using Pkg


using CSV, JuMP, Ipopt, Plots, DataFrames

println("Inicializando")


path = "C:\\Users\\rafae\\Downloads"

tabela_ons = CSV.read(joinpath(path, "serie_carga_ons.csv"))


y = tabela_ons[:,4]
T = size(y,1)-4737
x = Vector{Int64}(undef, T)

y2= Vector{Int64}(undef, T)

for t=1:T
    y2[t]=y[t]
end

for t=1:T
    x[t]=t
end



## Questão 1 e Questão 2 ###############################

##modeloLinear

#=

plot(x,y2)

serieL = Model(Ipopt.Optimizer)

@variable(serieL, theta[1:T])
@variable(serieL, delta[1:T])
@variable(serieL, tau[1:T])


@constraint(serieL,  [t=1:T], theta[t] >= y[t]-tau[t] )
@constraint(serieL,  [t=1:T], theta[t] >= -(y[t]-tau[t]) )
@constraint(serieL,  [t=2:T-1], delta[t] >= tau[t+1]-2*tau[t]+tau[t-1] )
@constraint(serieL,  [t=2:T-1], delta[t] >= -(tau[t+1]-2*tau[t]+tau[t-1]) )

lambda=500
@objective(serieL, Min, sum( theta[t] for t = 1:T ) + lambda*sum( delta[t] for t = 2:T-1)   )

optimize!(serieL)
termination_status(serieL)
objective_value(serieL)

a=JuMP.value.(theta)
b=JuMP.value.(delta)
c=JuMP.value.(tau)

##println("theta")
##println("",a)
##println("delta")
##println("",b)
##println("tau")
##println("",c)

plot!(x,c)

=#

##################### modelo nao linear


#=

plot(x,y2)




serie = Model(Ipopt.Optimizer)

@variable(serie, tau[1:T])

lambda=1000000
@objective(serie, Min, sum( (y[t]-tau[t])^2 for t = 1:T ) + lambda*sum( ( (tau[t+1]-tau[t])-(tau[t]-tau[t-1]) )^2 for t = 2:T-1  ) )

optimize!(serie)
termination_status(serie)
objective_value(serie)

c2=JuMP.value.(tau)

##println("",c)

plot!(x,c2)

println("fim de q1 e q2")


=#

## Questão 3 ####################################################################################################


tabela2 = CSV.read(joinpath(path, "serie_carga_ons.csv"))

y = tabela2[:,4]
T=size(y,1)-8437

x = Vector{Int64}(undef, T)

y2= Array{Float64}(undef, T)
##coloquei float pois dava erro com a funcao rand antes
y3= Array{Float64}(undef, T)

for t=1:T
    y2[t]=y[t]  #original
    y3[t]=rand(-8000:8000)
    y3[t]=y2[t]+y3[t]  #ruido
end

for t=1:T
    x[t]=t
end



plot(x,y2)
plot!(x,y3)

serie2 = Model(Ipopt.Optimizer)

@variable(serie2, theta[1:T])
@variable(serie2, delta[1:T])
@variable(serie2, tau[1:T])


@constraint(serie2,  [t=1:T], theta[t] >= y3[t]-tau[t] )
@constraint(serie2,  [t=1:T], theta[t] >= -(y3[t]-tau[t]) )
@constraint(serie2,  [t=2:T-1], delta[t] >= tau[t+1]-2*tau[t]+tau[t-1] )
@constraint(serie2,  [t=2:T-1], delta[t] >= -(tau[t+1]-2*tau[t]+tau[t-1]) )

lambda=1 ##mais pratico mudar aqui
@objective(serie2, Min, sum( theta[t] for t = 1:T ) + lambda*sum( delta[t] for t = 2:T-1)   )

##@objective(serie2, Min, sum( (y[t]-tau[t])^2 for t = 1:T ) + lambda*sum( ( (tau[t+1]-tau[t])-(tau[t]-tau[t-1]) )^2 for t = 2:T-1  ) )

optimize!(serie2)
termination_status(serie2)
objective_value(serie2)

a=JuMP.value.(theta)
b=JuMP.value.(delta)
c3=JuMP.value.(tau)

##println("",a)
##println("",b)
##println("",c3)


plot!(x,c3)

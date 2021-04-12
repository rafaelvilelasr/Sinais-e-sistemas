using Pkg


using JuMP, Ipopt, Plots, DataFrames, Clp

println("Inicializando")



## Questão 2



modelo2 = Model(Ipopt.Optimizer)

deficit=5000


@variable(modelo2, g1)
@variable(modelo2, g2)
@variable(modelo2, g3)
@variable(modelo2, f12)
@variable(modelo2, f13)
@variable(modelo2, f23)
@variable(modelo2, r)

G1=5
G2=20
G3=12
F12= 20
F13= 20
F23= 5

c1=100
c2=150
c3=200

@constraint(modelo2,  g1 +f12 -f13 >= 0)
@constraint(modelo2,  -g1 -f12 +f13 >= 0)
@constraint(modelo2,  g2 -f12 -f23 >= 0)
@constraint(modelo2,  -g2 +f12 +f23 >= 0)
@constraint(modelo2,   f13+f23+r+g3 >=15)
@constraint(modelo2,   -f13-f23-r-g3 >=-15)
@constraint(modelo2, -F12<= f12 <= F12)
@constraint(modelo2, -F13<= f13 <= F13)
@constraint(modelo2, -F23<= f23 <= F23)
@constraint(modelo2,  0<= g1 <= G1)
@constraint(modelo2,  0<= g2 <= G2)
@constraint(modelo2,  0<= g3 <= G3)


@objective(modelo2, Min,  c1*g1 + c2*g2 + c3*g3 + deficit*r )

optimize!(modelo2)
termination_status(modelo2)
objective_value(modelo2)

a=JuMP.value.(g1)
b=JuMP.value.(g2)
c=JuMP.value.(g3)
d=JuMP.value.(f12)
e=JuMP.value.(f13)
f=JuMP.value.(f23)

println("g1")
println("",a)
println("g2")
println("",b)
println("g3")
println("",c)
println("f12")
println("",d)
println("f13")
println("",e)
println("f23")
println("",f)
#=

# cont1
@constraint(modelo2,  g1 -f13 >= 0)
@constraint(modelo2,  -g1 +f13 >= 0)
@constraint(modelo2,  g2  -f23 >= 0)
@constraint(modelo2,  -g2  +f23 >= 0)
@constraint(modelo2,  g3 -f13 -f23 >= 0 )
@constraint(modelo2,  -g3 +f13 +f23 >= 0 )
@constraint(modelo2,   f13+f23+r+g3 >=15)
@constraint(modelo2,  - f13-f23- r-g3 >=-15)
@constraint(modelo2, -F13<= f13 <= F13)
@constraint(modelo2, -F23<= f23 <= F23)
@constraint(modelo2,  0<= g1 <= G1)
@constraint(modelo2,  0<= g2 <= G2)
@constraint(modelo2,  0<= g3 <= G3)

optimize!(modelo2)
termination_status(modelo2)
objective_value(modelo2)

a=JuMP.value.(g1)
b=JuMP.value.(g2)
c=JuMP.value.(g3)
e=JuMP.value.(f13)
f=JuMP.value.(f23)

println("g1")
println("",a)
println("g2")
println("",b)
println("g3")
println("",c)
println("f13")
println("",e)
println("f23")
println("",f)

#cont2

@constraint(modelo2,  g1 -f12  >= 0)
@constraint(modelo2,  -g1 +f12  >= 0)
@constraint(modelo2,  g2 -f12 -f23 >= 0)
@constraint(modelo2,  -g2 +f12 +f23 >= 0)
@constraint(modelo2,  g3  -f23 >= 0 )
@constraint(modelo2,  -g3 +f23 >= 0 )
@constraint(modelo2,   f23+r+g3 >=15)
@constraint(modelo2,   -f23-r -g3>=-15)
@constraint(modelo2, -F12<= f12 <= F12)
@constraint(modelo2, -F23<= f23 <= F23)
@constraint(modelo2,  0<= g1 <= G1)
@constraint(modelo2,  0<= g2 <= G2)
@constraint(modelo2,  0<= g3 <= G3)

optimize!(modelo2)
termination_status(modelo2)
objective_value(modelo2)

a=JuMP.value.(g1)
b=JuMP.value.(g2)
c=JuMP.value.(g3)
d=JuMP.value.(f12)
f=JuMP.value.(f23)

println("g1")
println("",a)
println("g2")
println("",b)
println("g3")
println("",c)
println("f12")
println("",d)
println("f23")
println("",f)

#cont3

@constraint(modelo2,  g1 -f12 -f13 >= 0)
@constraint(modelo2,  -g1 +f12 +f13 >= 0)
@constraint(modelo2,  g2 -f12 >= 0)
@constraint(modelo2,  -g2 +f12 >= 0)
@constraint(modelo2,  g3 -f13 >= 0 )
@constraint(modelo2,  -g3 +f13 >= 0 )
@constraint(modelo2,   f13+r +g3>=15)
@constraint(modelo2,   -f13-r -g3>=-15)
@constraint(modelo2, -F12<= f12 <= F12)
@constraint(modelo2, -F13<= f13 <= F13)
@constraint(modelo2,  0<= g1 <= G1)
@constraint(modelo2,  0<= g2 <= G2)
@constraint(modelo2,  0<= g3 <= G3)

optimize!(modelo2)
termination_status(modelo2)
objective_value(modelo2)

a=JuMP.value.(g1)
b=JuMP.value.(g2)
c=JuMP.value.(g3)
d=JuMP.value.(f12)
e=JuMP.value.(f13)

println("g1")
println("",a)
println("g2")
println("",b)
println("g3")
println("",c)
println("f12")
println("",d)
println("f13")
println("",e)




## Questão 3


modelo3 = Model(Ipopt.Optimizer)

n=10
c1def=50
c2def=100
Gbat=8
X=1000

G[i]=22-2*i
C[i]=2*i
D[t]=60*(1+sin(t/12))

@variable(modelo3, g[i])
@variable(modelo3, c[i])
@variable(modelo3, d[i] )
@variable(modelo3, gbat[i])
@variable(modelo3, r[i])


Rup=i
Rdown=i

@constraint(modelo3,  r[i] >= d[t]-g[t]  )
@constraint(modelo3,  g[i] <= g[i+1]+ Rup  )
@constraint(modelo3, g[i+1]- Rdown  <=  g[i] )
@constraint(modelo3,   g[i] +r[i] >= d[i])
@constraint(modelo3,   -g[i] -r[i] >= -d[i])
@constraint(modelo3,  0<= g[i] <= G[i])
@constraint(modelo3, 0 <= r[i] <= Rup )
@constraint(modelo3, 0 >= r[i] >= Rdown)

if r[i]<0.05*d[i]
    cdef = c1def
if r[i]>0.05*d[i]
    cdef = c2def


@objective(modelo3, Min,  sum( (g[i]*c[i])+(r[i]*cdef) ) for i=1:3)

optimize!(modelo3)
termination_status(modelo3)
objective_value(modelo3)

a=JuMP.value.(g[i])
b=JuMP.value.(c[i])
c=JuMP.value.(r[i])

#com bat


@constraint(modelo3,  gbat[i+1] >= gbat[i]+d[t]-g[t] )
@constraint(modelo3,  r[i] >= d[t]-g[t]  )
@constraint(modelo3,  g[i] <= g[i+1]+ Rup  )
@constraint(modelo3, g[i+1]- Rdown  <=  g[i] )
@constraint(modelo3,   g[i]+ gbat[i] +r >= d[i])
@constraint(modelo3,   -g[i]- gbat[i] -r >= -d[i])
@constraint(modelo3,  0<= g[i] <= G[i])
@constraint(modelo3, 0 <= r[i] <= Rup )
@constraint(modelo3, 0 >= r[i] >= Rdown)
@constraint(modelo3, 0 <= gbat <= Gbat )

if r[i]<0.05*d[i]
    cdef = c1def
if r[i]>0.05*d[i]
    cdef = c2def


@objective(modelo3, Min,  sum( (g[i]*c[i])+(r[i]*cdef) ) +X for i=1:3)

optimize!(modelo3)
termination_status(modelo3)
objective_value(modelo3)

a=JuMP.value.(g[i])
b=JuMP.value.(c[i])
c=JuMP.value.(r[i])
d=JuMP.value.(gbat[i])

=#

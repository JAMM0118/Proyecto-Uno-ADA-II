numeroAcciones= 3000
precioAcciones=100

ofertantes=[
    (150, 1000,2000),
    (177, 1000,2000),
    (200,500,2000),
    (50,500,2000)
]

def ordenOfertantes(ofertantes):
    return sorted(ofertantes,key=lambda x: x[0],reverse=True)

ofertantes=ordenOfertantes(ofertantes)

def vr(x):
    precioTotal=sum(o[0]*x[i] for i,o in enumerate(ofertantes))
    return precioTotal

def algoritmoVoraz(numeroAcciones,ofertantes,vr):
    x=[0]*len(ofertantes)
    mejorX=[0,1]
    valorMaximo=vr(x)
    for j in range(len(ofertantes)):
        for i in range(numeroAcciones):
            if ofertantes[j][1] <= i and ofertantes[j][2] >= i and sum(x)<numeroAcciones and ofertantes[j][0]>=precioAcciones:
                x[j]=i
                valorTemp=vr(x)
                if valorTemp > valorMaximo:
                    mejorX=x[:]
                    valorMaximo=valorTemp
                
    if sum(mejorX)<numeroAcciones:
        accionesGobierno=numeroAcciones-sum(mejorX)
    else:
        accionesGobierno=0
    return mejorX,valorMaximo,accionesGobierno
mejorX, valorMaximo,accionesGobierno = algoritmoVoraz(numeroAcciones, ofertantes, vr)

if accionesGobierno!=0: valorMaximo+=precioAcciones*accionesGobierno

print(f"Mejor combinacion de ofertas: {mejorX}")
print(f"valorMaximo: {valorMaximo}")
print(f"Acciones compradas por el gobierno: {accionesGobierno}")


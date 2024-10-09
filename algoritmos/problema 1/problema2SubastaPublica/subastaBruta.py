#Parametros iniciales
numeroAcciones= 10
precioAcciones=100

ofertantes=[
    (120, 2,5),
    (110, 3,4),
    (200,5,6)
]

#Funcion que calcula el valor recibido dado una asignacion de acciones
def vr(x):
    precioTotal=sum(o[0]*x[i] for i,o in enumerate(ofertantes))
    return precioTotal

def algoritmoBruto(numeroAcciones, ofertantes, vr):
    listaAcciones=[0]*len(ofertantes) 
    mejorCombinacion = listaAcciones
    valorMaximo = vr(listaAcciones)
    
    def combinaciones(j):
        nonlocal mejorCombinacion, valorMaximo

        if j == len(ofertantes):
            if sum(listaAcciones) <= numeroAcciones:
                valorTemp = vr(listaAcciones)
                if valorTemp > valorMaximo:
                    mejorCombinacion = listaAcciones[:] 
                    valorMaximo = valorTemp
            return

        for i in range(ofertantes[j][1], ofertantes[j][2] + 1):
            if sum(listaAcciones) + 1 <= numeroAcciones:
                listaAcciones[j] = i  
                combinaciones(j + 1)  
                
        listaAcciones[j] = 0
        
    combinaciones(0)
    if sum(mejorCombinacion)<numeroAcciones:
        accionesGobierno=numeroAcciones-sum(mejorCombinacion)
    else:
        accionesGobierno=0
    return mejorCombinacion, valorMaximo,accionesGobierno

mejorX, valorMaximo,accionesGobierno = algoritmoBruto(numeroAcciones, ofertantes, vr)
if accionesGobierno!=0: valorMaximo+=precioAcciones*accionesGobierno

print(f"Combinación óptima: {mejorX}")
print(f"valorMaximo: {valorMaximo}")
print(f"Acciones compradas por el gobierno: {accionesGobierno}")
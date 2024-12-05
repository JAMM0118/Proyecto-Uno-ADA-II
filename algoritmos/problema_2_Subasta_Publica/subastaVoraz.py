"""
Problema de la subasta publica

Juan Miguel Posso Alvarado
3/10/2024

version final
26/11/2024

Algortimo voraz
"""

def algoritmoVoraz(numeroAcciones,ofertantes,precioAcciones):

    def vr(x):
        precioTotal=sum(o[0]*x[i] for i,o in enumerate(ofertantes))
        return precioTotal

    def ordenOfertantes(ofertantes):
        intercambios = []
        for i in range(len(ofertantes)):
            for j in range(0, len(ofertantes) - i - 1):
                if ofertantes[j][0] < ofertantes[j + 1][0]:
                    intercambios.append((j, j + 1))
                    ofertantes[j], ofertantes[j + 1] = ofertantes[j + 1], ofertantes[j]
        return ofertantes, intercambios

    ofertantesOrdenados,intercambios=ordenOfertantes(ofertantes)

    allCombinaciones = []

    x=[0]*len(ofertantesOrdenados)
    mejorX=[0,1]
    valorMaximo=vr(x)
    for j in range(len(ofertantesOrdenados)):
        for i in range(numeroAcciones):
            if ofertantesOrdenados[j][1] <= i and ofertantesOrdenados[j][2] >= i and sum(x)<numeroAcciones and ofertantesOrdenados[j][0]>=precioAcciones:
                x[j]=i
                if sum(x)>numeroAcciones:
                    x[j]=0
                allCombinaciones.append(x[:])
                valorTemp=vr(x)
                if valorTemp > valorMaximo:
                    mejorX=x[:]
                    valorMaximo=valorTemp
    
    
    for j1, j2 in reversed(intercambios):
        mejorX[j1], mejorX[j2] = mejorX[j2], mejorX[j1]
                
    if sum(mejorX)<numeroAcciones:
        accionesGobierno=numeroAcciones-sum(mejorX)
    else:
        accionesGobierno=0
    if accionesGobierno!=0: valorMaximo+=precioAcciones*accionesGobierno
    return mejorX,valorMaximo,accionesGobierno,allCombinaciones


if __name__ == "__main__":

    numeroAcciones = 1000
    precioAcciones = 100
    ofertantes = [
        (500, 100, 600), 
        (450, 400, 800)
    ]
    mejorX, valorMaximo,accionesGobierno,allCombinaciones = algoritmoVoraz(numeroAcciones, ofertantes,precioAcciones)
    
    print(f"Combinación óptima en su orden original: {mejorX}")
    #print(f"valorMaximo: {valorMaximo}")
    #print(f"Acciones compradas por el gobierno: {accionesGobierno}")
    #print(f"Combinaciones: {allCombinaciones}")

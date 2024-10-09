ofertantes = [
    (120, 2, 3), 
    (110, 3, 4)
    ]
numeroAcciones = 10
precioAcciones=100


def algoritmoDinamicoConAsignaciones(numeroAcciones, ofertantes,precioAcciones):
    n = len(ofertantes) 
    matrizAcciones = [[0] * (numeroAcciones + 1) for _ in range(n + 1)]
    decisiones = [[0] * (numeroAcciones + 1) for _ in range(n + 1)]

    for i in range(1, n + 1): 
        precio, min_acciones, max_acciones = ofertantes[i - 1] 
        if precio < precioAcciones:
            continue 
        for j in range(numeroAcciones + 1): 
            matrizAcciones[i][j] = matrizAcciones[i - 1][j] 
            decisiones[i][j] = 0 

            for x in range(min_acciones, min(max_acciones, j) + 1):
                if matrizAcciones[i][j] < matrizAcciones[i - 1][j - x] + x * precio:
                    matrizAcciones[i][j] = matrizAcciones[i - 1][j - x] + x * precio
                    decisiones[i][j] = x 

    mejorX = [0] * n 
    acciones_restantes = numeroAcciones 

    for i in range(n, 0, -1): 
        mejorX[i - 1] = decisiones[i][acciones_restantes]  
        acciones_restantes -= mejorX[i - 1]  
    if sum(mejorX)<numeroAcciones:
        accionesGobierno=numeroAcciones-sum(mejorX)
    else:
        accionesGobierno=0

    return mejorX, matrizAcciones[n][numeroAcciones],accionesGobierno


mejorX, valorMaximo,accionesGobierno = algoritmoDinamicoConAsignaciones(numeroAcciones, ofertantes,precioAcciones)
if accionesGobierno!=0: valorMaximo+=precioAcciones*accionesGobierno

print(f"Mejor combinación: {mejorX}")
print(f"Valor máximo: {valorMaximo}")
print(f"Valor acciones gobierno: {accionesGobierno}")
def algoritmoDinamico(numeroAcciones, ofertantes,precioAcciones):
    accionesGobierno=0
    n = len(ofertantes) 
    matrizAcciones = [[0] * (numeroAcciones + 1) for _ in range(n + 1)]
    decisiones = [[0] * (numeroAcciones + 1) for _ in range(n + 1)]

    pasos = []

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
        pasos.append({
            "matrizAcciones": [row[:] for row in matrizAcciones],
            "decisiones": [row[:] for row in decisiones],
            "oferente": i,
            "acciones_disponibles": j
        })

    mejorX = [0] * n  
    acciones_restantes = numeroAcciones 

    reconstruccion = []

    for i in range(n, 0, -1): 
        mejorX[i - 1] = decisiones[i][acciones_restantes] 
        acciones_restantes -= mejorX[i - 1] 
        
        reconstruccion.append({
            "oferente": i,
            "acciones_asignadas": mejorX[i - 1],
            "acciones_restantes": acciones_restantes,
            "combinacion_parcial": mejorX[:]
        })

    if sum(mejorX)<numeroAcciones:
        accionesGobierno=numeroAcciones-sum(mejorX)
    else:
        accionesGobierno=0

    valorMaximo = matrizAcciones[n][numeroAcciones]
    if accionesGobierno!=0: valorMaximo+=precioAcciones*accionesGobierno

    combinaciones_parciales=[]


    for idx, paso in enumerate(reconstruccion):
        combinaciones_parciales.append(paso['combinacion_parcial'])

    return mejorX, matrizAcciones[n][numeroAcciones],accionesGobierno,combinaciones_parciales


if __name__ == "__main__":
    numeroAcciones = 1000
    precioAcciones = 100
    ofertantes = [
        (500, 100, 600), 
        (450, 400, 800)
    ]
    mejorX, valorMaximo,accionesGobierno,allCombinaciones = algoritmoDinamico(numeroAcciones, ofertantes,precioAcciones)
    
    print(f"Combinación óptima: {mejorX}")
    print(f"valorMaximo: {valorMaximo}")
    #print(f"Acciones compradas por el gobierno: {accionesGobierno}")
    #print(f"Combinaciones parciales: {allCombinaciones}")

    

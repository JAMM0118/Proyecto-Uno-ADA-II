def algoritmoProgramacionDinamica(cadena_original, cadena_objetivo,cost_advance, cost_delete , cost_insert, cost_replace, cost_kill):
    n = len(cadena_original)
    m = len(cadena_objetivo)
    
    matrizCostos = [[0] * (m + 1) for _ in range(n + 1)]
    operaciones = [[[] for _ in range(m + 1)] for _ in range(n + 1)]
    formaciones = [["" for _ in range(m + 1)] for _ in range(n + 1)] 
    conteo_operaciones = {"advance": 0, "delete": 0, "insert": 0, "replace": 0, "kill": 0}
    
    for i in range(1, n + 1):
        matrizCostos[i][0] = i * cost_delete
        operaciones[i][0] = operaciones[i-1][0] + [f"delete {cadena_original[i-1]} at position {i-1}"]
        formaciones[i][0] = formaciones[i-1][0]  
        
    for j in range(1, m + 1):
        matrizCostos[0][j] = j * cost_insert
        operaciones[0][j] = operaciones[0][j-1] + [f"insert {cadena_objetivo[j-1]} at position {j-1}"]
        formaciones[0][j] = formaciones[0][j-1] + cadena_objetivo[j-1] 
        
    for i in range(1, n + 1):
        for j in range(1, m + 1):
            if cadena_original[i-1] == cadena_objetivo[j-1]:
                matrizCostos[i][j] = matrizCostos[i-1][j-1] + cost_advance
                operaciones[i][j] = operaciones[i-1][j-1] + [f"advance at position {i-1}"]
                formaciones[i][j] = formaciones[i-1][j-1] + cadena_original[i-1]
            else:
                reemplazar = matrizCostos[i-1][j-1] + cost_replace
                borrar = matrizCostos[i-1][j] + cost_delete
                insertar = matrizCostos[i][j-1] + cost_insert

                if reemplazar <= borrar and reemplazar <= insertar:
                    matrizCostos[i][j] = reemplazar
                    operaciones[i][j] = operaciones[i-1][j-1] + [f"replace {cadena_original[i-1]} with {cadena_objetivo[j-1]} at position {i-1}"]
                    formaciones[i][j] = formaciones[i-1][j-1] + cadena_objetivo[j-1]
                elif borrar < reemplazar and borrar <= insertar:
                    matrizCostos[i][j] = borrar
                    operaciones[i][j] = operaciones[i-1][j] + [f"delete {cadena_original[i-1]} at position {i-1}"]
                    formaciones[i][j] = formaciones[i-1][j]
                else:
                    matrizCostos[i][j] = insertar
                    operaciones[i][j] = operaciones[i][j-1] + [f"insert {cadena_objetivo[j-1]} at position {j-1}"]
                    formaciones[i][j] = formaciones[i][j-1] + cadena_objetivo[j-1]

    killIsUsed = True
    for i in range(1, n + 1):
        if i <= n and matrizCostos[i][m] > matrizCostos[i-1][m] + cost_kill:

            if killIsUsed:
                matrizCostos[i][m] = matrizCostos[i-1][m] + cost_kill
                operaciones[i][m] = operaciones[i-1][m] + [f"kill from position {i-1}"]
                formaciones[i][m] = formaciones[i-1][m]
                killIsUsed = False

            else:
                matrizCostos[i][m] = matrizCostos[i-1][m] 
                operaciones[i][m] = operaciones[i-1][m] 
                formaciones[i][m] = formaciones[i-1][m]
    
    for i in range(0, len(operaciones[n][m])):
        if "advance" in operaciones[n][m][i]:
            conteo_operaciones["advance"] += 1
        elif "delete" in operaciones[n][m][i]:
            conteo_operaciones["delete"] += 1
        elif "insert" in operaciones[n][m][i]:
            conteo_operaciones["insert"] += 1
        elif "replace" in operaciones[n][m][i]:
            conteo_operaciones["replace"] += 1
        elif "kill" in operaciones[n][m][i]:
            conteo_operaciones["kill"] += 1
            


    return matrizCostos[n][m], operaciones[n][m], conteo_operaciones, formaciones[n][m]

if __name__ == "__main__":
    cadena_original = 'francesa'
    cadena_objetivo = 'ancestro'
    costo, ops, conteo_ops, cadena_formada = algoritmoProgramacionDinamica(cadena_original, cadena_objetivo,1,2,2,3,1)
    print("Costo Programación Dinámica:", costo)
    print("Operaciones:", ops)
    print("Conteo de operaciones:", conteo_ops)
    print("Cadena formada:", cadena_formada)
import sys

COST_ADVANCE = 1
COST_DELETE = 2
COST_INSERT = 2
COST_REPLACE = 3
COST_KILL = 1


def algoritmoFuerzaBruta(cadena_original, cadena_objetivo):
    operaciones = []
    cadena_formada = ""
    conteo_operaciones = {"advance": 0, "delete": 0, "insert": 0, "replace": 0, "kill": 0}
    costo_total, cadena_formada = algoritmoFuerzaBrutaRecursiva(cadena_original, cadena_objetivo, 0, 0, 0, operaciones, conteo_operaciones, cadena_formada)
    return costo_total, operaciones, conteo_operaciones, cadena_formada

def algoritmoFuerzaBrutaRecursiva(cadena_original, cadena_objetivo, i, j, costo_total, operaciones, conteo_operaciones, cadena_formada):

    if i == len(cadena_original) and j == len(cadena_objetivo):
        return costo_total, cadena_formada
    
    if i < len(cadena_original) and j < len(cadena_objetivo) and cadena_original[i] == cadena_objetivo[j]:
        operaciones.append(f"advance at position {i}")
        conteo_operaciones["advance"] += 1
        cadena_formada += cadena_original[i]  
        return algoritmoFuerzaBrutaRecursiva(cadena_original, cadena_objetivo, i+1, j+1, costo_total + COST_ADVANCE, operaciones, conteo_operaciones, cadena_formada)

    if i < len(cadena_original) and j < len(cadena_objetivo):
        operaciones_reemplazo = operaciones[:]
        operaciones_reemplazo.append(f"replace {cadena_original[i]} with {cadena_objetivo[j]} at position {i}")
        conteo_operaciones_reemplazo = conteo_operaciones.copy()
        conteo_operaciones_reemplazo["replace"] += 1
        cadena_reemplazo = cadena_formada + cadena_objetivo[j]  
        reemplazo, cadena_reemplazo = algoritmoFuerzaBrutaRecursiva(cadena_original, cadena_objetivo, i+1, j+1, costo_total + COST_REPLACE, operaciones_reemplazo, conteo_operaciones_reemplazo, cadena_reemplazo)
    else:
        reemplazo = sys.maxsize

    if j < len(cadena_objetivo):
        operaciones_insercion = operaciones[:]
        operaciones_insercion.append(f"insert {cadena_objetivo[j]} at position {i}")
        conteo_operaciones_insercion = conteo_operaciones.copy()
        conteo_operaciones_insercion["insert"] += 1
        cadena_insercion = cadena_formada + cadena_objetivo[j] 
        insercion, cadena_insercion = algoritmoFuerzaBrutaRecursiva(cadena_original, cadena_objetivo, i, j+1, costo_total + COST_INSERT, operaciones_insercion, conteo_operaciones_insercion, cadena_insercion)
    else:
        insercion = sys.maxsize

    if i < len(cadena_original):
        operaciones_borrado = operaciones[:]
        operaciones_borrado.append(f"delete {cadena_original[i]} at position {i}")
        conteo_operaciones_borrado = conteo_operaciones.copy()
        conteo_operaciones_borrado["delete"] += 1
        cadena_borrado = cadena_formada  
        borrado, cadena_borrado = algoritmoFuerzaBrutaRecursiva(cadena_original, cadena_objetivo, i+1, j, costo_total + COST_DELETE, operaciones_borrado, conteo_operaciones_borrado, cadena_borrado)
    else:
        borrado = sys.maxsize

    if i < len(cadena_original) and j == len(cadena_objetivo):
        operaciones_kill = operaciones[:]
        operaciones_kill.append(f"kill from position {i}")
        conteo_operaciones_kill = conteo_operaciones.copy()
        conteo_operaciones_kill["kill"] += 1
        cadena_kill = cadena_formada  
        kill = costo_total + COST_KILL
    else:
        kill = sys.maxsize

    min_costo = min(reemplazo, insercion, borrado, kill)

    if min_costo == reemplazo:
        operaciones[:] = operaciones_reemplazo
        conteo_operaciones.update(conteo_operaciones_reemplazo)
        cadena_formada = cadena_reemplazo
    elif min_costo == insercion:
        operaciones[:] = operaciones_insercion
        conteo_operaciones.update(conteo_operaciones_insercion)
        cadena_formada = cadena_insercion
    elif min_costo == borrado:
        operaciones[:] = operaciones_borrado
        conteo_operaciones.update(conteo_operaciones_borrado)
        cadena_formada = cadena_borrado
    elif min_costo == kill:
        operaciones[:] = operaciones_kill
        conteo_operaciones.update(conteo_operaciones_kill)
        cadena_formada = cadena_kill

    return min_costo, cadena_formada

if __name__ == "__main__":
    cadena_original = input("Ingrese la cadena original: ")
    cadena_objetivo = input("Ingrese la cadena objetivo: ")
    costo, ops, conteo_ops, cadena_formada = algoritmoFuerzaBruta(cadena_original, cadena_objetivo)
    print("Costo Fuerza Bruta:", costo)
    print("Operaciones:", ops)
    print("Conteo de operaciones:", conteo_ops)
    print("Cadena formada:", cadena_formada)

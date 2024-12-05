
def algoritmoVoraz(cadena_original, cadena_objetivo,cost_advance, cost_delete , cost_insert, cost_replace, cost_kill):
    i = 0
    j = 0
    costo_total = 0
    operaciones = []
    conteo_operaciones = {"advance": 0, "delete": 0, "insert": 0, "replace": 0, "kill": 0}
    cadena_formada = ""

    while i < len(cadena_original) and j < len(cadena_objetivo):
        costo_advance = cost_advance if cadena_original[i] == cadena_objetivo[j] else float('inf')
        costo_replace = cost_replace
        costo_insert = cost_insert
        costo_delete = cost_delete

        if costo_advance <= costo_replace and costo_advance <= costo_insert and costo_advance <= costo_delete:
            operaciones.append(f"advance at position {i}")
            cadena_formada += cadena_original[i]
            costo_total += cost_advance
            conteo_operaciones["advance"] += 1
            i += 1
            j += 1
        elif costo_replace <= costo_advance and costo_replace <= costo_insert and costo_replace <= costo_delete:
            operaciones.append(f"replace {cadena_original[i]} with {cadena_objetivo[j]} at position {i}")
            cadena_formada += cadena_objetivo[j]
            costo_total += cost_replace
            conteo_operaciones["replace"] += 1
            i += 1
            j += 1
        elif costo_insert <= costo_advance and costo_insert <= costo_replace and costo_insert <= costo_delete:
            operaciones.append(f"insert {cadena_objetivo[j]} at position {i}")
            cadena_formada += cadena_objetivo[j]
            costo_total += cost_insert
            conteo_operaciones["insert"] += 1
            j += 1 
        else:
            
            operaciones.append(f"delete {cadena_original[i]} at position {i}")
            costo_total += cost_delete
            conteo_operaciones["delete"] += 1
            i += 1  

    if i < len(cadena_original) and j == len(cadena_objetivo):
        if cost_kill < cost_delete * (len(cadena_original) - i):
            operaciones.append(f"kill from position {i}")
            costo_total += cost_kill
            conteo_operaciones["kill"] += 1
        else:
            while i < len(cadena_original):
                operaciones.append(f"delete {cadena_original[i]} at position {i}")
                costo_total += cost_delete
                conteo_operaciones["delete"] += 1
                i += 1

    while j < len(cadena_objetivo):
        operaciones.append(f"insert {cadena_objetivo[j]} at position {i}")
        cadena_formada += cadena_objetivo[j]
        costo_total += cost_insert
        conteo_operaciones["insert"] += 1
        j += 1

    return costo_total, operaciones, conteo_operaciones, cadena_formada


if __name__ == "__main__":
    cadena_original = input("Ingrese la cadena original: ")
    cadena_objetivo = input("Ingrese la cadena objetivo: ") 
    costo, ops, conteo_ops, cadena_formada = algoritmoVoraz(cadena_original, cadena_objetivo, 1, 1, 1, 1, 1)
    print("Costo Voraz:", costo)
    print("Operaciones:", ops)
    print("Conteo de operaciones:", conteo_ops)
    print("Cadena formada:", cadena_formada)
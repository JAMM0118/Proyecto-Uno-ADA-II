def resolver_subasta(numeroAcciones, precioAcciones, ofertantes):
    def generar_combinaciones(numeroAcciones, ofertantes):
        resultados = []

        def backtrack(asignacion_actual, indice, acciones_restantes):
            if indice == len(ofertantes):  
                if acciones_restantes >= 0:  
                    resultados.append(asignacion_actual[:])
                return

            _, min_acciones, max_acciones = ofertantes[indice]

            for x in range(min_acciones, max_acciones + 1):
                if acciones_restantes - x >= 0: 
                    asignacion_actual[indice] = x
                    backtrack(asignacion_actual, indice + 1, acciones_restantes - x)

            asignacion_actual[indice] = 0
            backtrack(asignacion_actual, indice + 1, acciones_restantes)

        asignacion_inicial = [0] * len(ofertantes)
        backtrack(asignacion_inicial, 0, numeroAcciones)

        return resultados

    combinaciones = generar_combinaciones(numeroAcciones, ofertantes)
    mejor_valor = 0
    mejor_combinacion = None
    acciones_gobierno = 0

    for combinacion in combinaciones:
        valor = 0
        acciones_asignadas = sum(combinacion)
        for i, (precio, _, _) in enumerate(ofertantes):
            valor += combinacion[i] * precio
        if acciones_asignadas < numeroAcciones:  
            valor += (numeroAcciones - acciones_asignadas) * precioAcciones

        if valor > mejor_valor:
            mejor_valor = valor
            mejor_combinacion = combinacion
            acciones_gobierno = numeroAcciones - acciones_asignadas

    return mejor_combinacion, mejor_valor, acciones_gobierno, combinaciones


if __name__ == "__main__":
    numeroAcciones = 100
    precioAcciones = 10
    ofertantes = [
        (15, 10, 20), 
        (20, 20, 30)
    ]

    mejor_combinacion, mejor_valor, acciones_gobierno, combinaciones = resolver_subasta(
        numeroAcciones, precioAcciones, ofertantes
    )

    print(f"Mejor combinación: {mejor_combinacion}")
    print(f"Valor máximo: {mejor_valor}")
    print(f"Acciones compradas por el gobierno: {acciones_gobierno}")
    #print(f"Total de combinaciones generadas: {combinaciones}")

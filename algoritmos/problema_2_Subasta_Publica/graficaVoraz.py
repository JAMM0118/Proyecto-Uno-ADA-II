import time
import numpy as np
import matplotlib.pyplot as plt
from subastaVoraz import algoritmoVoraz
def algoritmoVoraz(numeroAcciones, ofertantes, precioAcciones):
    def vr(x):
        return sum(o[0] * x[i] for i, o in enumerate(ofertantes))

    def ordenOfertantes(ofertantes):
        intercambios = []
        for i in range(len(ofertantes)):
            for j in range(0, len(ofertantes) - i - 1):
                if ofertantes[j][0] < ofertantes[j + 1][0]:
                    intercambios.append((j, j + 1))
                    ofertantes[j], ofertantes[j + 1] = ofertantes[j + 1], ofertantes[j]
        return ofertantes, intercambios

    ofertantesOrdenados, intercambios = ordenOfertantes(ofertantes)
    x = [0] * len(ofertantesOrdenados)
    mejorX = [0] * len(ofertantesOrdenados)
    valorMaximo = vr(x)

    for j in range(len(ofertantesOrdenados)):
        for i in range(numeroAcciones):
            if (
                ofertantesOrdenados[j][1] <= i
                and ofertantesOrdenados[j][2] >= i
                and sum(x) < numeroAcciones
                and ofertantesOrdenados[j][0] >= precioAcciones
            ):
                x[j] = i
                if sum(x) > numeroAcciones:
                    x[j] = 0
                valorTemp = vr(x)
                if valorTemp > valorMaximo:
                    mejorX = x[:]
                    valorMaximo = valorTemp

    for j1, j2 in reversed(intercambios):
        mejorX[j1], mejorX[j2] = mejorX[j2], mejorX[j1]

    accionesGobierno = max(0, numeroAcciones - sum(mejorX))
    if accionesGobierno != 0:
        valorMaximo += precioAcciones * accionesGobierno

    return mejorX, valorMaximo, accionesGobierno

# Parámetros de prueba
num_casos_voraz = [2, 3, 4, 5, 6]  # Número de ofertantes
numeroAcciones_voraz = 20  # Acciones totales
precioAcciones_voraz = 100

# Medir tiempos experimentales
tiempos_experimentales_voraz = []
complejidad_teorica_voraz = []

for n in num_casos_voraz:
    ofertantes = [(np.random.randint(1, 100), 0, numeroAcciones_voraz) for _ in range(n)]

    # Medir tiempo promedio de ejecución
    tiempos_voraz = []
    for _ in range(50):  # 50 ejecuciones por caso
        inicio = time.time()
        algoritmoVoraz(numeroAcciones_voraz, ofertantes, precioAcciones_voraz)
        fin = time.time()
        tiempos_voraz.append(fin - inicio)
    
    tiempo_promedio_voraz = np.mean(tiempos_voraz)
    tiempos_experimentales_voraz.append(tiempo_promedio_voraz)
    
    # Calcular complejidad teórica
    complejidad_teorica_voraz.append(n**2 * numeroAcciones_voraz)

# Normalizar complejidad teórica para comparación gráfica
complejidad_normalizada_voraz = [c / max(complejidad_teorica_voraz) * max(tiempos_experimentales_voraz) 
                                 for c in complejidad_teorica_voraz]

# Graficar resultados
plt.figure(figsize=(10, 6))
plt.plot(num_casos_voraz, tiempos_experimentales_voraz, label="Tiempo Experimental", marker="o", color="blue")
plt.plot(num_casos_voraz, complejidad_normalizada_voraz, label="Complejidad Teórica (Normalizada)", linestyle="--", color="red")
plt.xlabel("Número de ofertantes (n)")
plt.ylabel("Tiempo (segundos)")
plt.title("Comparación de Tiempo Experimental y Complejidad Teórica (Algoritmo Voraz)")
plt.legend()
plt.grid()
plt.show()

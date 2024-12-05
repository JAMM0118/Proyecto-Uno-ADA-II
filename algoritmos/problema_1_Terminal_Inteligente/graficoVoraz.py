import time
import numpy as np
import matplotlib.pyplot as plt

from algoritmoVoraz import algoritmoVoraz

# Configuración para pruebas
cadenas_originales = ["abc", "abcd", "abcde", "abcdef", "abcdefg"]
cadenas_objetivo = ["xyz", "wxyz", "vwxyz", "uvwxyz", "tuvwxyz"]
costos = (2, 1, 3, 4, 1)

tiempos_experimentales = []
complejidad_teorica = []

for i in range(len(cadenas_originales)):
    tiempo_total = 0
    cadena_original = cadenas_originales[i]
    cadena_objetivo = cadenas_objetivo[i]

    for _ in range(50):  # 50 ejecuciones por caso
        inicio = time.time()
        algoritmoVoraz(cadena_original, cadena_objetivo, *costos)
        fin = time.time()
        tiempo_total += (fin - inicio) * 100000  # Convertir a milisegundos


    # Promedio del tiempo experimental
    tiempos_experimentales.append(tiempo_total / 50)
    
    # Complejidad teórica O(n + m)
    if complejidad_teorica == []:
        complejidad_teorica.append(0)
    else:
        complejidad_teorica.append(len(cadena_original) + len(cadena_objetivo))

# Normalizar complejidad teórica para graficar
complejidad_normalizada = [c / max(complejidad_teorica) * max(tiempos_experimentales) for c in complejidad_teorica]

# Graficar resultados
plt.figure(figsize=(10, 6))
plt.plot(range(len(cadenas_originales)), tiempos_experimentales, label="Tiempo Experimental", marker="o", color="blue")
plt.plot(range(len(cadenas_originales)), complejidad_teorica, label="Complejidad Teórica (Normalizada)", linestyle="--", color="red")
plt.xlabel("Casos (Tamaño creciente de cadenas)")
plt.ylabel("Tiempo (segundos)")
plt.title("Comparación de Tiempo Experimental y Complejidad Teórica (Algoritmo Voraz)")
plt.legend()
plt.grid()
plt.show()

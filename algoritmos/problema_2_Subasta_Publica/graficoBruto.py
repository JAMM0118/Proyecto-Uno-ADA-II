import time
import matplotlib.pyplot as plt
import numpy as np
from subastaBruta import resolver_subasta


# Parámetros de prueba
num_casos = [2, 3, 4]  # Variación del número de ofertantes
max_acciones = 10  # Máximo rango de acciones
numeroAcciones = 20  # Acciones totales
precioAcciones = 100

# Medir tiempos experimentales
tiempos_experimentales = []
complejidad_teorica = []

for n in num_casos:
    ofertantes = [(np.random.randint(1, 100), 0, max_acciones) for _ in range(n)]

    # Medir tiempo promedio de ejecución
    tiempos = []
    for _ in range(50):  # 50 ejecuciones por caso
        inicio = time.time()
        resolver_subasta(numeroAcciones, precioAcciones, ofertantes)
        fin = time.time()
        tiempos.append(fin - inicio)
    
    tiempo_promedio = np.mean(tiempos)
    tiempos_experimentales.append(tiempo_promedio)
    
    # Calcular complejidad teórica aproximada
    complejidad_teorica.append((max_acciones ** n) * n)

# Normalizar complejidad teórica para comparación gráfica
complejidad_normalizada = [c / max(complejidad_teorica) * max(tiempos_experimentales) for c in complejidad_teorica]

# Graficar resultados
plt.figure(figsize=(10, 6))
plt.plot(num_casos, tiempos_experimentales, label="Tiempo Experimental", marker="o")
plt.plot(num_casos, complejidad_normalizada, label="Complejidad Teórica", linestyle="--")
plt.xlabel("Número de ofertantes (n)")
plt.ylabel("Tiempo (segundos)")
plt.title("Comparación de Tiempo Experimental y Complejidad Teórica")
plt.legend()
plt.grid()
plt.show()

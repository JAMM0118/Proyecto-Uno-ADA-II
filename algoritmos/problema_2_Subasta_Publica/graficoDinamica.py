import time
import matplotlib.pyplot as plt
import numpy as np
from subastaDinamica import algoritmoDinamico

# Función del algoritmo dinámico

# Parámetros de prueba
num_casos_dinamico = [2, 3, 4,5]  # Número de ofertantes
max_acciones_dinamico = 10  # Máximo rango de acciones
numeroAcciones_dinamico = 20  # Acciones totales
precioAcciones_dinamico = 100

# Medir tiempos experimentales
tiempos_experimentales_dinamico = []
complejidad_teorica_dinamico = []

for n in num_casos_dinamico:
    
    ofertantes = [(np.random.randint(1, 100), 0, max_acciones_dinamico) for _ in range(n)]

    # Medir tiempo promedio de ejecución
    tiempos_dinamico = []
    for _ in range(50):  # 50 ejecuciones por caso
        inicio = time.time()
        algoritmoDinamico(numeroAcciones_dinamico, ofertantes, precioAcciones_dinamico)
        fin = time.time()
        tiempos_dinamico.append(fin - inicio)
    
    tiempo_promedio_dinamico = np.mean(tiempos_dinamico)
    tiempos_experimentales_dinamico.append(tiempo_promedio_dinamico)
    if complejidad_teorica_dinamico == []:
        complejidad_teorica_dinamico.append(0)
    else: 
        complejidad_teorica_dinamico.append(n * numeroAcciones_dinamico * max_acciones_dinamico)
    
    # Calcular complejidad teórica
    

#Normalizar complejidad teórica para comparación gráfica
complejidad_normalizada_dinamico = [c / max(complejidad_teorica_dinamico) * max(tiempos_experimentales_dinamico) for c in complejidad_teorica_dinamico]

# Graficar resultados
plt.figure(figsize=(10, 6))
plt.plot(num_casos_dinamico, tiempos_experimentales_dinamico, label="Tiempo Experimental", marker="o", color="blue")
plt.plot(num_casos_dinamico, complejidad_normalizada_dinamico, label="Complejidad Teórica", linestyle="--", color="red")
plt.xlabel("Número de ofertantes (n)")
plt.ylabel("Tiempo (segundos)")
plt.title("Comparación de Tiempo Experimental y Complejidad Teórica (Algoritmo Dinámico)")
plt.legend()
plt.grid()
plt.show()

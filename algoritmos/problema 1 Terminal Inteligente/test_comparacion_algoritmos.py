import time
import unittest

from algoritmoFuerzaBruta import algoritmoFuerzaBruta
from algoritmoProgramacionDinamica import algoritmoProgramacionDinamica
from algoritmoVoraz import algoritmoVoraz

class TestComparacionAlgoritmos(unittest.TestCase):
    def test_algoritmos(self):
        test_cases = [
            ("algorithm", "altruistic"),
            ("kitten", "sitting"),
            ("francesa", "ancestro"),
            ("ingenioso", "ingeniero"),
            ("flaw", "lawn"),
            ("intention", "execution"),
            ("abcdef", "azced"),
            ("longest", "stone"),
            ("short", "ports"),
            ("distance", "instance"),
            ("abcdefg", "gfedcba"),
        ]
        
        print("Comparación de algoritmos:")
        for cadena_original, cadena_objetivo in test_cases:
            
            start_time = time.time()
            for _ in range(50):
                algoritmoVoraz(cadena_original, cadena_objetivo)
            end_time = time.time()
            avg_time_voraz = (end_time - start_time) / 50

            start_time = time.time()
            for _ in range(50):
                algoritmoProgramacionDinamica(cadena_original, cadena_objetivo)
            end_time = time.time()
            avg_time_dinamica = (end_time - start_time) / 50

            start_time = time.time()
            for _ in range(50):
                algoritmoFuerzaBruta(cadena_original, cadena_objetivo)
            end_time = time.time()
            avg_time_fuerza_bruta = (end_time - start_time) / 50

            print(f"'{cadena_original}' -> '{cadena_objetivo}':")
            print(f"  Algoritmo Voraz: {avg_time_voraz:.6f} segundos")
            print(f"  Programación Dinámica: {avg_time_dinamica:.6f} segundos")
            print(f"  Algoritmo Fuerza Bruta: {avg_time_fuerza_bruta:.6f} segundos")

if __name__ == "__main__":
    unittest.main()
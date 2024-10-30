const int COST_ADVANCE = 1;
const int COST_DELETE = 2;
const int COST_INSERT = 2;
const int COST_REPLACE = 3;
const int COST_KILL = 1;

List algoritmoProgramacionDinamica(String cadenaOriginal, String cadenaObjetivo) {
  int n = cadenaOriginal.length;
  int m = cadenaObjetivo.length;

  List<List<int>> matrizCostos = List.generate(n + 1, (_) => List.filled(m + 1, 0));
  List<List<List<String>>> operaciones = List.generate(n + 1, (_) => List.generate(m + 1, (_) => []));
  List<List<String>> formaciones = List.generate(n + 1, (_) => List.filled(m + 1, ""));
  Map<String, int> conteoOperaciones = {'advance': 0, 'delete': 0, 'insert': 0, 'replace': 0, 'kill': 0};

  for (int i = 1; i <= n; i++) {
    matrizCostos[i][0] = i * COST_DELETE;
    operaciones[i][0] = List.from(operaciones[i - 1][0])..add("delete ${cadenaOriginal[i - 1]} at position ${i - 1}");
    formaciones[i][0] = formaciones[i - 1][0];
  }

  for (int j = 1; j <= m; j++) {
    matrizCostos[0][j] = j * COST_INSERT;
    operaciones[0][j] = List.from(operaciones[0][j - 1])..add("insert ${cadenaObjetivo[j - 1]} at position ${j - 1}");
    formaciones[0][j] = formaciones[0][j - 1] + cadenaObjetivo[j - 1];
  }

  for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= m; j++) {
      if (cadenaOriginal[i - 1] == cadenaObjetivo[j - 1]) {
        matrizCostos[i][j] = matrizCostos[i - 1][j - 1] + COST_ADVANCE;
        operaciones[i][j] = List.from(operaciones[i - 1][j - 1])..add("advance at position ${i - 1}");
        formaciones[i][j] = formaciones[i - 1][j - 1] + cadenaOriginal[i - 1];
      } else {
        int reemplazar = matrizCostos[i - 1][j - 1] + COST_REPLACE;
        int borrar = matrizCostos[i - 1][j] + COST_DELETE;
        int insertar = matrizCostos[i][j - 1] + COST_INSERT;

        if (reemplazar <= borrar && reemplazar <= insertar) {
          matrizCostos[i][j] = reemplazar;
          operaciones[i][j] = List.from(operaciones[i - 1][j - 1])..add("replace ${cadenaOriginal[i - 1]} with ${cadenaObjetivo[j - 1]} at position ${i - 1}");
          formaciones[i][j] = formaciones[i - 1][j - 1] + cadenaObjetivo[j - 1];
        } else if (borrar <= reemplazar && borrar <= insertar) {
          matrizCostos[i][j] = borrar;
          operaciones[i][j] = List.from(operaciones[i - 1][j])..add("delete ${cadenaOriginal[i - 1]} at position ${i - 1}");
          formaciones[i][j] = formaciones[i - 1][j];
        } else {
          matrizCostos[i][j] = insertar;
          operaciones[i][j] = List.from(operaciones[i][j - 1])..add("insert ${cadenaObjetivo[j - 1]} at position ${j - 1}");
          formaciones[i][j] = formaciones[i][j - 1] + cadenaObjetivo[j - 1];
        }
      }
    }
  }
  for (var op in operaciones[n][m]) {
    if (op.contains('advance')) {
      conteoOperaciones['advance'] = conteoOperaciones['advance']! + 1;
    } else if (op.contains('delete')) {
      conteoOperaciones['delete'] = conteoOperaciones['delete']! + 1;
    } else if (op.contains('insert')) {
      conteoOperaciones['insert'] = conteoOperaciones['insert']! + 1;
    } else if (op.contains('replace')) {
      conteoOperaciones['replace'] = conteoOperaciones['replace']! + 1;
    } else if (op.contains('kill')) {
      conteoOperaciones['kill'] = conteoOperaciones['kill']! + 1;
    }
  }

  return [matrizCostos[n][m], operaciones[n][m], conteoOperaciones, formaciones[n][m]];
}

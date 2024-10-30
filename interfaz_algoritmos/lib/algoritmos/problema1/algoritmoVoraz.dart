

const int COST_ADVANCE = 1;
const int COST_DELETE = 2;
const int COST_INSERT = 2;
const int COST_REPLACE = 3;
const int COST_KILL = 1;

List algoritmoVoraz(String cadenaOriginal, String cadenaObjetivo) {
  int i = 0;
  int j = 0;
  int costoTotal = 0;
  List<String> operaciones = [];
  Map<String, int> conteoOperaciones = {'advance': 0, 'delete': 0, 'insert': 0, 'replace': 0, 'kill': 0};
  String cadenaFormada = "";

  while (i < cadenaOriginal.length && j < cadenaObjetivo.length) {
    int costoAdvance = cadenaOriginal[i] == cadenaObjetivo[j] ? COST_ADVANCE : 9999999;
    int costoReplace = COST_REPLACE;
    int costoInsert = COST_INSERT;
    int costoDelete = COST_DELETE;

    if (costoAdvance <= costoReplace && costoAdvance <= costoInsert && costoAdvance <= costoDelete) {
      operaciones.add("advance");
      cadenaFormada += cadenaOriginal[i];
      costoTotal += COST_ADVANCE;
      conteoOperaciones["advance"] = conteoOperaciones["advance"]! + 1;
      i++;
      j++;
    } else if (costoReplace <= costoAdvance && costoReplace <= costoInsert && costoReplace <= costoDelete) {
      operaciones.add("replace ${cadenaOriginal[i]} with ${cadenaObjetivo[j]}");
      cadenaFormada += cadenaObjetivo[j];
      costoTotal += COST_REPLACE;
      conteoOperaciones["replace"] = conteoOperaciones["replace"]! + 1;
      i++;
      j++;
    } else if (costoInsert <= costoAdvance && costoInsert <= costoReplace && costoInsert <= costoDelete) {
      operaciones.add("insert ${cadenaObjetivo[j]}");
      cadenaFormada += cadenaObjetivo[j];
      costoTotal += COST_INSERT;
      conteoOperaciones["insert"] = conteoOperaciones["insert"]! + 1;
      j++;
    } else {
      operaciones.add("delete ${cadenaOriginal[i]}");
      costoTotal += COST_DELETE;
      conteoOperaciones["delete"] = conteoOperaciones["delete"]! + 1;
      i++;
    }
  }

  if (i < cadenaOriginal.length && j == cadenaObjetivo.length) {
    if (COST_KILL < COST_DELETE * (cadenaOriginal.length - i)) {
      operaciones.add("kill");
      costoTotal += COST_KILL;
      conteoOperaciones["kill"] = conteoOperaciones["kill"]! + 1;
    } else {
      while (i < cadenaOriginal.length) {
        operaciones.add("delete ${cadenaOriginal[i]} at position $i");
        costoTotal += COST_DELETE;
        conteoOperaciones["delete"] = conteoOperaciones["delete"]! + 1;
        i++;
      }
    }
  }

  while (j < cadenaObjetivo.length) {
    operaciones.add("insert ${cadenaObjetivo[j]}");
    cadenaFormada += cadenaObjetivo[j];
    costoTotal += COST_INSERT;
    conteoOperaciones["insert"] = conteoOperaciones["insert"]! + 1;
    j++;
  }

  return [costoTotal, operaciones, conteoOperaciones, cadenaFormada];
}

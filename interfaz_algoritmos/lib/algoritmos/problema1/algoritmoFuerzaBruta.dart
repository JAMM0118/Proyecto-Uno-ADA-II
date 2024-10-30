const int COST_ADVANCE = 1;
const int COST_DELETE = 2;
const int COST_INSERT = 2;
const int COST_REPLACE = 3;
const int COST_KILL = 1;

List algoritmoFuerzaBruta(String cadenaOriginal, String cadenaObjetivo) {
  List<String> operaciones = [];
  String cadenaFormada = "";
  Map<String, int> conteoOperaciones = {
    "advance": 0,
    "delete": 0,
    "insert": 0,
    "replace": 0,
    "kill": 0
  };

  var resultado = algoritmoFuerzaBrutaRecursiva(cadenaOriginal, cadenaObjetivo,
      0, 0, 0, operaciones, conteoOperaciones, cadenaFormada);

  return [
    resultado[0], // costo total
    resultado[1], // operaciones
    resultado[2], // conteo de operaciones
    resultado[3], // cadena formada
  ];
}

List algoritmoFuerzaBrutaRecursiva(
    String cadenaOriginal,
    String cadenaObjetivo,
    int i,
    int j,
    int costoTotal,
    List<String> operaciones,
    Map<String, int> conteoOperaciones,
    String cadenaFormada) {
  if (i == cadenaOriginal.length && j == cadenaObjetivo.length) {
    return [costoTotal, operaciones, conteoOperaciones, cadenaFormada];
  }

  int mejorCosto = double.infinity.toInt();
  List<String> mejorOperaciones = List.from(operaciones);
  Map<String, int> mejorConteo = Map.from(conteoOperaciones);
  String mejorCadena = cadenaFormada;

  // Opción 1: Advance
  if (i < cadenaOriginal.length &&
      j < cadenaObjetivo.length &&
      cadenaOriginal[i] == cadenaObjetivo[j]) {
    List<String> nuevasOperaciones = List.from(operaciones);
    Map<String, int> nuevoConteo = Map.from(conteoOperaciones);

    nuevasOperaciones.add("advance at position $i");
    nuevoConteo["advance"] = nuevoConteo["advance"]! + 1;

    var resultadoAvance = algoritmoFuerzaBrutaRecursiva(
        cadenaOriginal,
        cadenaObjetivo,
        i + 1,
        j + 1,
        costoTotal + COST_ADVANCE,
        nuevasOperaciones,
        nuevoConteo,
        cadenaFormada + cadenaOriginal[i]);

    if (resultadoAvance[0] < mejorCosto) {
      mejorCosto = resultadoAvance[0];
      mejorOperaciones = resultadoAvance[1];
      mejorConteo = resultadoAvance[2];
      mejorCadena = resultadoAvance[3];
    }
  }

  // Opción 2: Replace
  if (i < cadenaOriginal.length && j < cadenaObjetivo.length) {
    List<String> nuevasOperaciones = List.from(operaciones);
    Map<String, int> nuevoConteo = Map.from(conteoOperaciones);

    nuevasOperaciones.add("replace ${cadenaOriginal[i]} with ${cadenaObjetivo[j]} at position $i");
    nuevoConteo["replace"] = nuevoConteo["replace"]! + 1;

    var resultadoReemplazo = algoritmoFuerzaBrutaRecursiva(
        cadenaOriginal,
        cadenaObjetivo,
        i + 1,
        j + 1,
        costoTotal + COST_REPLACE,
        nuevasOperaciones,
        nuevoConteo,
        cadenaFormada + cadenaObjetivo[j]);

    if (resultadoReemplazo[0] < mejorCosto) {
      mejorCosto = resultadoReemplazo[0];
      mejorOperaciones = resultadoReemplazo[1];
      mejorConteo = resultadoReemplazo[2];
      mejorCadena = resultadoReemplazo[3];
    }
  }

  // Opción 3: Insert
  if (j < cadenaObjetivo.length) {
    List<String> nuevasOperaciones = List.from(operaciones);
    Map<String, int> nuevoConteo = Map.from(conteoOperaciones);

    nuevasOperaciones.add("insert ${cadenaObjetivo[j]} at position $i");
    nuevoConteo["insert"] = nuevoConteo["insert"]! + 1;

    var resultadoInsercion = algoritmoFuerzaBrutaRecursiva(
        cadenaOriginal,
        cadenaObjetivo,
        i,
        j + 1,
        costoTotal + COST_INSERT,
        nuevasOperaciones,
        nuevoConteo,
        cadenaFormada + cadenaObjetivo[j]);

    if (resultadoInsercion[0] < mejorCosto) {
      mejorCosto = resultadoInsercion[0];
      mejorOperaciones = resultadoInsercion[1];
      mejorConteo = resultadoInsercion[2];
      mejorCadena = resultadoInsercion[3];
    }
  }

  // Opción 4: Delete
  if (i < cadenaOriginal.length) {
    List<String> nuevasOperaciones = List.from(operaciones);
    Map<String, int> nuevoConteo = Map.from(conteoOperaciones);

    nuevasOperaciones.add("delete ${cadenaOriginal[i]} at position $i");
    nuevoConteo["delete"] = nuevoConteo["delete"]! + 1;

    var resultadoBorrado = algoritmoFuerzaBrutaRecursiva(
        cadenaOriginal,
        cadenaObjetivo,
        i + 1,
        j,
        costoTotal + COST_DELETE,
        nuevasOperaciones,
        nuevoConteo,
        cadenaFormada);

    if (resultadoBorrado[0] < mejorCosto) {
      mejorCosto = resultadoBorrado[0];
      mejorOperaciones = resultadoBorrado[1];
      mejorConteo = resultadoBorrado[2];
      mejorCadena = resultadoBorrado[3];
    }
  }

  // Opción 5: Kill
  if (i < cadenaOriginal.length && j == cadenaObjetivo.length) {
    List<String> nuevasOperaciones = List.from(operaciones);
    Map<String, int> nuevoConteo = Map.from(conteoOperaciones);

    nuevasOperaciones.add("kill from position $i");
    nuevoConteo["kill"] = nuevoConteo["kill"]! + 1;

    int costoKill = costoTotal + COST_KILL;

    if (costoKill < mejorCosto) {
      mejorCosto = costoKill;
      mejorOperaciones = nuevasOperaciones;
      mejorConteo = nuevoConteo;
      mejorCadena = cadenaFormada;
    }
  }

  return [mejorCosto, mejorOperaciones, mejorConteo, mejorCadena];
}

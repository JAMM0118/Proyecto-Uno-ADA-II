import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

String cadenaOriginal = '';
String cadenaObjetivo = '';
int posicion = 0;
bool isUpdating = false;
List resultado = [];
TextEditingController controllerCadenaOriginal = TextEditingController();
TextEditingController controllerCadenaObjetivo = TextEditingController();
TextEditingController controllerCostAdvance = TextEditingController();
TextEditingController controllerCostDelete = TextEditingController();
TextEditingController controllerCostReplace = TextEditingController();
TextEditingController controllerCostInsert = TextEditingController();
TextEditingController controllerCostKill = TextEditingController();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _changeCadena(String typeAlgoritmo) async {
    var url = Uri.http('localhost:4000', '/algoritmo');
    try {
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'algoritmo': typeAlgoritmo,
            'cadena_original': cadenaOriginal,
            'cadena_objetivo': cadenaObjetivo,
            "cost_advance": int.parse(controllerCostAdvance.text),
            "cost_delete": int.parse(controllerCostDelete.text),
            "cost_replace":  int.parse(controllerCostReplace.text),
            "cost_insert": int.parse(controllerCostInsert.text),
            "cost_kill": int.parse(controllerCostKill.text),
          }));
      var respuesta = jsonDecode(response.body);
      setState(() {
        resultado = respuesta['resultado'];
      });
    } catch (e) {
      print(e.toString());
    }

    if (resultado.isEmpty) {
      return;
    }
    List<dynamic> operaciones = resultado[1];

    for (int i = 0; i < operaciones.length; i++) {
      switch (operaciones[i].contains(' ')
          ? operaciones[i].split(' ')[0]
          : operaciones[i]) {
        case 'advance':
          if (!isUpdating) {
            isUpdating = true;
            setState(() {
              posicion++;
            });
            await Future.delayed(const Duration(milliseconds: 500));
            isUpdating = false;
          }
          break;
        case 'delete':
          if (!isUpdating) {
            isUpdating = true;
            setState(() {
              cadenaOriginal = cadenaOriginal.substring(0, posicion) +
                  cadenaOriginal.substring(posicion + 1);
            });
            await Future.delayed(const Duration(milliseconds: 500));
            isUpdating = false;
          }

          break;
        case 'insert':
          if (!isUpdating) {
            isUpdating = true;
            setState(() {
              cadenaOriginal = cadenaOriginal.substring(0, posicion) +
                  operaciones[i].split(' ')[1] +
                  cadenaOriginal.substring(posicion);
              posicion++;
            });
            await Future.delayed(const Duration(milliseconds: 500));
            isUpdating = false;
          }
          break;
        case 'replace':
          if (!isUpdating) {
            isUpdating = true;
            setState(() {
              cadenaOriginal = cadenaOriginal.substring(0, posicion) +
                  operaciones[i].split(' ')[3] +
                  cadenaOriginal.substring(posicion + 1);
              posicion++;
            });

            await Future.delayed(const Duration(milliseconds: 500));
            isUpdating = false;
          }
          break;
        case 'kill':
          if (!isUpdating) {
            isUpdating = true;
            setState(() {
              cadenaOriginal = cadenaOriginal.substring(0, posicion);
            });

            await Future.delayed(const Duration(milliseconds: 500));
            isUpdating = false;
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Wrap(
              children: [
                SizedBox(
                  height: 50,
                  width: 200,
                  child: TextField(
                    controller: controllerCadenaOriginal,

                    decoration: const InputDecoration(
                      labelText: 'Cadena Original',
                      border:  OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    onChanged: (value) {
                      setState(() {
                        
                      cadenaOriginal = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: TextField(
                      controller: controllerCadenaObjetivo,

                      decoration:const InputDecoration(
                      labelText: 'Cadena Objetivo',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    onChanged: (value) {
                      setState(() {
                        
                      cadenaObjetivo = value;
                      });
                    },
                  ),
                ),
                                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      controller: controllerCostAdvance,

                      decoration:const InputDecoration(
                      labelText: 'Advance',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    onChanged: (value) {
                      setState(() {
                        controllerCostAdvance.text = value;
                      });
                    },
                  ),
                ),
                                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      controller: controllerCostInsert,

                      decoration:const InputDecoration(
                      labelText: 'Insert',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    onChanged: (value) {
                      setState(() {
                        controllerCostInsert.text = value;
                      });
                    },
                  ),
                ),
                                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      controller: controllerCostReplace,

                      decoration:const InputDecoration(
                      labelText: 'Replace',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    onChanged: (value) {
                      setState(() {
                        controllerCostReplace.text = value;
                      });
                    },
                  ),
                ),
                                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      controller: controllerCostDelete,

                      decoration:const InputDecoration(
                      labelText: 'Delete',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    onChanged: (value) {
                      setState(() {
                        controllerCostDelete.text = value;
                      });
                    },
                  ),
                ),
                                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 100,
                  child: TextField(
                      controller: controllerCostKill,

                      decoration:const InputDecoration(
                      labelText: 'Kill',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    onChanged: (value) {
                      setState(() {
                        controllerCostKill.text = value;
                      });
                    },
                  ),
                ),

                
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              width: 1200,
              height: 50,
              child: ListView.builder(
                  itemCount: cadenaOriginal.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: index == posicion ? Colors.green : Colors.white,
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(cadenaOriginal[index]),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            if (resultado.isNotEmpty) Text('Costo total: ${resultado[0]}'),
            if (resultado.isNotEmpty) Text('Operaciones: ${resultado[2]}'),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: 20,
            left: 580,
            height: 70,
            width: 100,
            child: FloatingActionButton(
              heroTag: 'fuerzaBruta',
              onPressed: () {
                _changeCadena('fuerza_bruta');
              },
              child: const Text('Fuerza Bruta'),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 400,
            height: 70,
            width: 170,
            child: FloatingActionButton(
              heroTag: 'programacionDinamica',
              onPressed: () {
                _changeCadena('dinamica');
              },
              child: const Text('Programación Dinámica'),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 700,
            height: 70,
            width: 70,
            child: FloatingActionButton(
              heroTag: 'voraz',
              onPressed: () {
                _changeCadena('voraz');
              },
              child: const Text('Voraz'),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 790,
            height: 70,
            width: 70,
            child: FloatingActionButton(
              heroTag: 'reiniciar',
              onPressed: () {
                setState(() {
                  cadenaOriginal = '';
                  cadenaObjetivo = '';
                  posicion = 0;
                  resultado = [];
                  controllerCadenaOriginal.clear();
                  controllerCadenaObjetivo.clear();
                  controllerCostAdvance.clear();
                  controllerCostDelete.clear();
                  controllerCostReplace.clear();
                  controllerCostInsert.clear();
                  controllerCostKill.clear();

                });
              },
              child: const Text('Reiniciar'),
            ),
          ),
        ],
      ),
    );
  }
}

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
TextEditingController controllerNumeroAcciones = TextEditingController();
TextEditingController controllerPrecioAcciones = TextEditingController();
TextEditingController controllerPrecioPagarOferentes = TextEditingController();
TextEditingController controllerMinimoAcciones = TextEditingController();
TextEditingController controllerMaximoAcciones = TextEditingController();
List<List<int>> oferentes = [];
List<int> oferente = [];
List<int> showOferente = [];
List<dynamic> subastaRepuesta = [];

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
  int index = 0;

  void _changeOferentes(String typeSubasta) async {
    var url = Uri.http('localhost:4000', '/algoritmo');
    try {
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'algoritmo': typeSubasta,
            'numeroAcciones': int.parse(controllerNumeroAcciones.text),
            'precioAcciones': int.parse(controllerPrecioAcciones.text),
            'oferentes': oferentes,
          }));
      var respuesta = jsonDecode(response.body);
      setState(() {
        subastaRepuesta = respuesta['resultado'];
      });
      print(subastaRepuesta);

    } catch (e) {
      print(e.toString());
    }

    if (subastaRepuesta.isEmpty) {
      return;
    }
   var combinaciones = subastaRepuesta[3];
    for (int i = 0; i < combinaciones.length; i++) {

      for (int j = 0; j < combinaciones[i].length; j++) {
          if (!isUpdating) {
            isUpdating = true;
            setState(() {
              showOferente[j] = combinaciones[i][j];
            });
            await Future.delayed(const Duration(milliseconds: 10));
            isUpdating = false;
          }
      
      }
      
    }
  }

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
            "cost_replace": int.parse(controllerCostReplace.text),
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
    List<Widget> navegacion = [
      Column(
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
                    border: OutlineInputBorder(),
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
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _changeCadena('fuerza_bruta');
                  },
                  child: const Text('Fuerza Bruta')),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    _changeCadena('dinamica');
                  },
                  child: const Text('Programación Dinámica')),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    _changeCadena('voraz');
                  },
                  child: const Text('Voraz')),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
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
                  child: const Text('Reiniciar')),
            ],
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 200,
                child: TextField(
                  controller: controllerNumeroAcciones,
                  decoration: const InputDecoration(
                    labelText: 'Numero de acciones',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: TextField(
                  controller: controllerPrecioAcciones,
                  decoration: const InputDecoration(
                    labelText: 'Precio de las acciones',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
            children: [
              SizedBox(
                height: 50,
                width: 250,
                child: TextField(
                  controller: controllerPrecioPagarOferentes,
                  decoration: const InputDecoration(
                    labelText: 'Precio a pagar por el oferente ',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                height: 50,
                width: 270,
                child: TextField(
                  controller: controllerMinimoAcciones,
                  decoration: const InputDecoration(
                    labelText: 'Minimo de acciones a comprar',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                height: 50,
                width: 270,
                child: TextField(
                  controller: controllerMaximoAcciones,
                  decoration: const InputDecoration(
                    labelText: 'Maximo de acciones a comprar',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      oferente = [];
                      showOferente.add(0);
                      oferente
                          .add(int.parse(controllerPrecioPagarOferentes.text));
                      oferente.add(int.parse(controllerMinimoAcciones.text));
                      oferente.add(int.parse(controllerMaximoAcciones.text));
                      oferentes.add(oferente);
                      controllerPrecioPagarOferentes.clear();
                      controllerMinimoAcciones.clear();
                      controllerMaximoAcciones.clear();
                      print(oferentes);
                      print(oferente);
                      print(showOferente);
                    });
                  },
                  child: const Text('Añadir Oferente')),
              const SizedBox(
                height: 140,
              ),
              SizedBox(
                width: 1200,
                height: 50,
                child: ListView.builder(
                    itemCount: showOferente.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.only(right: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Text('Oferente: ${index + 1}'),
                              Text(showOferente[index].toString()),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
const SizedBox(
                height: 100,
              ),
                            if (subastaRepuesta.isNotEmpty) Container(
                        width: 300,
                        height: 50,
                        margin: const EdgeInsets.only(right: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              const Text('Acciones compradas por el gobierno'),
                              Text(subastaRepuesta[2].toString()),
                            ],
                          ),
                        ),
                      ),
              if (subastaRepuesta.isNotEmpty) Text('Costo total: ${subastaRepuesta[1]}'),
              const SizedBox(
                width: 30,
              ),
              if (subastaRepuesta.isNotEmpty) Text('Mejor combinacion: ${subastaRepuesta[0]}'),

              const SizedBox(
                width: 1240,
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    _changeOferentes('subastaVoraz');
                  },
                  child: const Text('Subasta Voraz')),
              const SizedBox(
                width: 20,
              ),

              ElevatedButton(
                  onPressed: () {
                    _changeOferentes('subastaDinamica');
                  },
                  child: const Text('Subasta Dinamica')),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    _changeOferentes('subastaBruta');
                  },
                  child: const Text('Subasta Fuerza Bruta')),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      oferentes = [];
                      oferente = [];
                      showOferente = [];
                      subastaRepuesta = [];
                      controllerNumeroAcciones.clear();
                      controllerPrecioAcciones.clear();
                      controllerPrecioPagarOferentes.clear();
                      controllerMinimoAcciones.clear();
                      controllerMaximoAcciones.clear();
                    });
                  },
                  child: const Text('Reiniciar')),
            ],
          ),
        ],
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: navegacion[index],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (int newIndex) {
          setState(() {
            index = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.terminal_sharp),
            label: 'Terminal Inteligente',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Subasta Publica',
          ),
        ],
      ),
    );
  }
}

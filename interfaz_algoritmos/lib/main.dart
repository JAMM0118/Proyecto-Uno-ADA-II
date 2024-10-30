import 'package:flutter/material.dart';
import 'package:interfaz_algoritmos/algoritmos/problema1/algoritmoFuerzaBruta.dart';
import 'package:interfaz_algoritmos/algoritmos/problema1/algoritmoProgramacionDinamica.dart';
import 'package:interfaz_algoritmos/algoritmos/problema1/algoritmoVoraz.dart';

void main() {
  runApp(const MyApp());
}

String cadenaOriginal = 'algorithm';
String cadenaObjetivo = 'altruistic';
int posicion = 0;
bool isUpdating = false;
List resultado = [];

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
  
  void _changeCadena() async {
    if (resultado.isEmpty) {
      return;
    }
  print(cadenaOriginal);
    List<String> operaciones = resultado[1];

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
            print(cadenaOriginal);
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
              cadenaOriginal = cadenaOriginal.substring(0, posicion) + operaciones[i].split(' ')[3] +
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
              cadenaOriginal = cadenaOriginal.substring(0, posicion) ;
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
          
            SizedBox(
             width: 1000,
             height: 50,
             
              child: ListView.builder(                 
                 itemCount: cadenaOriginal.length,
                 scrollDirection: Axis.horizontal,
                 itemBuilder: (context, index) {
                   return Container(
                     
                     width: 40,
                     height: 40,
                     decoration: BoxDecoration(
                       color: index == posicion
                           ? Colors.green
                           : Colors.white,
                       border: Border.all(color: Colors.black),
                     ),
                     child: Center(
                       child: Text(cadenaOriginal[index]),
                     ),
                   );
                 }),
            ),
            if(resultado.isNotEmpty)
            Text('Costo total: ${resultado[3]}'),
            
          ],
        ),
        
      ),
    
       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
              Positioned(

                bottom: 20,
                left: 220,
                height: 70,
                width: 100,
                child: FloatingActionButton(
                  heroTag: 'fuerzaBruta',
                    onPressed: () {
                     resultado= algoritmoFuerzaBruta(cadenaOriginal, cadenaObjetivo);
                    },
                    child: const Text('Fuerza Bruta'),
                  ),
              ),
                Positioned(
                  
                bottom: 20,
                left: 340,
                height: 70,
                width: 170,
                  child: FloatingActionButton(
                    heroTag: 'programacionDinamica',
                    onPressed: () {
                       resultado = algoritmoProgramacionDinamica(cadenaOriginal, cadenaObjetivo);
                       _changeCadena();
                    },
                    child: const Text('Programación Dinámica'),
                  ),
                ),
                Positioned(
                  

                bottom: 20,
                left: 120,
                height: 70,
                width: 70,
                  child: FloatingActionButton(
                    heroTag: 'voraz',
                    onPressed: () {
                     resultado = algoritmoVoraz(cadenaOriginal, cadenaObjetivo);
                      _changeCadena();
                    },
                    child: const Text('Voraz'),
                  ),
                ),
                Positioned(
                bottom: 20,
                left: 20,
                height: 70,
                width: 70,
                  child: FloatingActionButton(
                    heroTag: 'reiniciar',
                    onPressed: () {
                      setState(() {
                        
                      cadenaOriginal = 'algorithm';
                      cadenaObjetivo = 'altruistic';
                      posicion = 0;
                      
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

import 'package:flutter/material.dart';
import 'package:posts_app/home.dart';

class Resultado extends StatefulWidget {
  List<num> casosPrevistos;
  List<num> casosNotificados;
  List<num> nivel;
  List<num> tempMin;
  List<num> tempMax;
  int semanaInicio;
  int semanaFim;
  int duracaoSemanas = 0;

  Resultado(this.casosPrevistos, this.casosNotificados, this.nivel,
      this.tempMin, this.tempMax, this.semanaInicio, this.semanaFim);

  @override
  State<StatefulWidget> createState() {
    return _ResultadoState();
  }
}

class _ResultadoState extends State<Resultado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultados"),
        backgroundColor: Colors.pink[100],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: widget.duracaoSemanas,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    height: 120,
                    child: Column(children: [
                      Text("Semana: ${index + 1}"),
                      Text("Nivel: ${widget.nivel[index]}"),
                      Text("Casos previstos: ${widget.casosPrevistos[index]}"),
                      Text(
                          "Casos notificados: ${widget.casosNotificados[index]}"),
                      Text("Temperatura mínima: ${widget.tempMin[index]}"),
                      Text("Temperatura máxima: ${widget.tempMax[index]}")
                    ]));
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ))
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.pinkAccent[50],
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent[50],
            textStyle: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          child: const Text("Nova busca"),
        ),
      ),
    );
  }

  @override
  void initState() {
    widget.duracaoSemanas = widget.semanaFim - widget.semanaInicio + 1;
  }
}

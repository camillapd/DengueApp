import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:posts_app/resultado.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? radio;
  int? cidade;

  List<int> geocodes = [
    1200401,
    2704302,
    1600303,
    1302603,
    2927408,
    2304400,
    5300108,
    3205309,
    5208707,
    2111300,
    5103403,
    5002704,
    3106200,
    1501402,
    2507507,
    4106902,
    2611606,
    2211001,
    3304557,
    2408102,
    4314902,
    1100205,
    1400100,
    4205407,
    3550308,
    2800308,
    1721000
  ];

  List<String> estados = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ];

  TextEditingController sem1Controller = TextEditingController();
  TextEditingController sem2Controller = TextEditingController();
  TextEditingController ano1Controller = TextEditingController();
  TextEditingController ano2Controller = TextEditingController();

  List<num> casosPrevistos = [], casosNotificados = [];
  List<num> nivel = [], tempMin = [], tempMax = [];

  Future<List> getDengue() async {
    if (sem1Controller.text.isNotEmpty &&
        sem2Controller.text.isNotEmpty &&
        ano1Controller.text.isNotEmpty &&
        ano2Controller.text.isNotEmpty &&
        cidade != null &&
        radio != null) {
      int semanaInicio = int.parse(sem1Controller.text);
      int semanaFim = int.parse(sem2Controller.text);
      int anoInicio = int.parse(ano1Controller.text);
      int anoFim = int.parse(ano2Controller.text);

      String url =
          "https://info.dengue.mat.br/api/alertcity?geocode=$cidade&disease=$radio&format=json&ew_start=$semanaInicio&ew_end=$semanaFim&ey_start=$anoInicio&ey_end=$anoFim";

      http.Response response = await http.get(Uri.parse(url));
      List ret = jsonDecode(response.body);

      for (int i = 0; i < ret.length; i++) {
        casosPrevistos.add(ret[i]["casos_est"]);
        casosNotificados.add(ret[i]["casos"]);
        nivel.add(ret[i]["nivel"]);
        tempMax.add(ret[i]["tempmax"]);
        tempMin.add(ret[i]["tempmin"]);
      }

      return ret;
    } else {
      return [
        {
          "casos_est": "",
          "casos": "",
          "nivel": "",
          "tempmax": "",
          "tempmin": ""
        }
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Alerta Dengue"),
          backgroundColor: Colors.pink[100],
        ),
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 250,
                      child: Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            Text(
                              "Doença",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            RadioListTile(
                              title: const Text("Dengue"),
                              value: "dengue",
                              groupValue: radio,
                              onChanged: (String? value) {
                                radio = value;
                                setState(() {});
                              },
                            ),
                            RadioListTile(
                              title: const Text("Zika"),
                              value: "zika",
                              groupValue: radio,
                              onChanged: (String? value) {
                                radio = value;
                                setState(() {});
                              },
                            ),
                            RadioListTile(
                              title: const Text("Chikungunya"),
                              value: "chikungunya",
                              groupValue: radio,
                              onChanged: (String? value) {
                                radio = value;
                                setState(() {});
                              },
                            )
                          ],
                        ),
                      )),
                  Container(
                      width: 200,
                      child: Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: sem1Controller,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Semana início: ",
                                  labelStyle: TextStyle(fontSize: 14)),
                              style: TextStyle(fontSize: 14),
                              maxLength: 2,
                            ),
                            TextField(
                              controller: sem2Controller,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Semana fim: ",
                                  labelStyle: TextStyle(fontSize: 14)),
                              style: TextStyle(fontSize: 14),
                              maxLength: 2,
                            ),
                            TextField(
                              controller: ano1Controller,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Ano início: ",
                                  labelStyle: TextStyle(fontSize: 15)),
                              style: TextStyle(fontSize: 14),
                              maxLength: 4,
                            ),
                            TextField(
                              controller: ano2Controller,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  labelText: "Ano fim: ",
                                  labelStyle: TextStyle(fontSize: 14)),
                              style: TextStyle(fontSize: 14),
                              maxLength: 4,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              FutureBuilder(
                future: getDengue(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      sem1Controller.text.isNotEmpty && // importante
                      sem2Controller.text.isNotEmpty) {
                    // List result = snapshot.data!;
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Resultado(
                                casosPrevistos,
                                casosNotificados,
                                nivel,
                                tempMin,
                                tempMax,
                                int.parse(sem1Controller.text),
                                int.parse(sem2Controller.text))),
                      );
                    });
                    return Container();
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              Expanded(
                  child: ListView.separated(
                padding: const EdgeInsets.all(4),
                itemCount: estados.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 50,
                      child: Column(children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                cidade = geocodes[index];
                              });
                            },
                            child: Text('${estados[index]}')),
                      ]));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              )),
            ],
          ),
        ));
  }
}

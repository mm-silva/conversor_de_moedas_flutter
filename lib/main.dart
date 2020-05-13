import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json-cors&key=488d0317";

void main() async{

  print(await getData());  
  runApp(MaterialApp(
      home: Home(),
        theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white))
      )
    ), 
  ));
}

Future<Map> getData() async{
  http.Response response = await http.get(request);
  return json.decode(response.body);
}


class Home extends StatefulWidget{
  @override
  _HomeState createState()=> _HomeState();
}
class _HomeState extends State<Home>{

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _realChanged(String text){
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);

  }
  void _dolarChanged(String text){
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }
  void _euroChanged(String text){
    double euro = double.parse(text);
    dolarController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        title: Text("\$ Conversor de Moedas \$"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text("Carregando Dados..",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0
                        ),
                        textAlign: TextAlign.center,
                      )
                  );
                  default: 
                  if(snapshot.hasError){
                      Center(
                      child: Text("Erro ao carregar os dados :(",
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 25.0
                        ),
                        textAlign: TextAlign.center,
                      )
                  );
                  }else{
                    dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                            Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                            buildTextField("Reais", "R\$", realController,_realChanged),
                            Divider(),
                            buildTextField("Dolar", "US\$", dolarController, _dolarChanged),
                            Divider(),
                            buildTextField("Europa", "€", euroController,_euroChanged),
                            Divider(),

                        ],
                      )
                    );
                  }
              }
            }
      )
    );
  }
}
Widget buildTextField(String label, String prefix, TextEditingController c,Function f){
  return TextField(
    controller: c,
       decoration: InputDecoration(
       labelText:  label,
       labelStyle: TextStyle(color: Colors.amber),
       border: OutlineInputBorder(),
       prefixText: prefix
         ),
      style: TextStyle(color: Colors.amber, fontSize: 25.0),
      onChanged: f,
      keyboardType: TextInputType.number,
       );
}
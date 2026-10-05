import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

const request = 'https://api.hgbrasil.com/finance?key=022c8c06';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Map> _fetchData() async {
    http.Response response = await http.get(Uri.parse(request));
    return jsonDecode(response.body)['results']['currencies'];
  }


  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  double dollar = 0;
  double euro = 0;

  void _realChanged(String text){
    double real = double.tryParse(text) ?? 0;
    dollarController.text = (real/dollar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text){
    double dollar = double.tryParse(text) ?? 0;
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar / this.euro).toStringAsFixed(2);

  }

  void _euroChanged(String text){
    double euro = double.tryParse(text) ?? 0;
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro / this.dollar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('\$Conversor\$'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
        future: _fetchData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  'Carregando Dados...',
                  style: TextStyle(color: Colors.amber, fontSize: 25),
                  textAlign: .center,
                ),
              );
              default:
              if(snapshot.hasError){
                return Center(
                  child: Text(
                    'Erro ao Carregar Dados :(',
                    style: TextStyle(color: Colors.amber, fontSize: 25),
                    textAlign: .center,
                  ),
                );
              } else {
                dollar = snapshot.data!['USD']['buy'];
                euro = snapshot.data!['EUR']['buy'];
                return SingleChildScrollView(
                  padding: .all(10.0),
                    child: Column(
                      crossAxisAlignment: .stretch,
                      children: [
                        Icon(Icons.monetization_on, size: 150, color: Colors.amber),
                        buildTextField('Reais', 'R\$ ', realController,_realChanged),
                        SizedBox(height: 10),
                        buildTextField('Doláres', 'US\$ ', dollarController,_dollarChanged),

                        SizedBox(height: 10,),
                        buildTextField('Euros', '€ ', euroController,_euroChanged),
                        
                      ]
                    )
                );
              }
          }
        },
      ),
    );
  }

  Widget buildTextField(String label, String prefix,TextEditingController controller,Function(String) function) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.amber),
        border: OutlineInputBorder(),
        prefixText: prefix,
      ),
      style: TextStyle(
        color: Colors.amber,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: function,
    );
  }
}

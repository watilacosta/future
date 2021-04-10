import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map> _recuperarPrecoBitcoin() async {
    Uri url = Uri.parse('https://www.blockchain.com/ticker');

    http.Response response = await http.get(url);

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map>(
      future: _recuperarPrecoBitcoin(),
      builder: (context, snapshot){
        String resultado;

        switch(snapshot.connectionState){
          case ConnectionState.none :
            resultado = 'Conexão falhou';
            print(resultado);
            break;
          case ConnectionState.waiting :
            resultado = 'Carregando dados...';
            print(resultado);
            break;
          case ConnectionState.done :
            resultado = 'Dados carregados:';
            if(snapshot.hasError) {
              resultado = snapshot.error.toString();
            } else {
              double valor = snapshot.data['BRL']['buy'];
              resultado = valor.toString();
            }
            print(resultado);
            break;
          case ConnectionState.active :
            resultado = 'conexão ativa';
            print(resultado);
            break;
        }

        return Center(
          child: Text(
            snapshot.data['BRL']['symbol'].toString() +
            snapshot.data['BRL']['buy'].toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w300,
              decoration: TextDecoration.none,
            ),
          ),
        );
      },
    );
  }
}

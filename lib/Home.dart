import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<Map> _recuperarPreco() async {
    //url da api
    String url = "https://blockchain.info/ticker";

    Response response;
    response = await get(url);

    return json.decode(response.body);

  }

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<Map>(
      future: _recuperarPreco(),
      builder: (context, snapshot){

        String resutado;
        switch(snapshot.connectionState){
          case ConnectionState.none :
          case ConnectionState.waiting:
            print("Conexão waiting");
            resutado = "Carregando...";
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            print("Conexão done");
            if(snapshot.hasError){
              resutado = "Erro ao carregar os dados.";
            } else {
              double valor = snapshot.data["BRL"]["buy"];
              resutado = "Preço do bitcoin ${valor.toString()}";
            }
            break;
        }

        return Center(
          child: Text(resutado),
        );
      },
    );
  }
}

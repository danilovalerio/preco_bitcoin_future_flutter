import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';

import 'Postagem.dart';

class ListViewDados extends StatefulWidget {
  @override
  _ListViewDadosState createState() => _ListViewDadosState();
}

class _ListViewDadosState extends State<ListViewDados> {
  String _urlBase = "https://jsonplaceholder.typicode.com";

  //Os dados a serem recuperados é uma lista de postagens
  Future<List<Postagem>> _recuperarPostagens() async {
    Response response = await get(_urlBase + "/posts");
    var dadosJson = json.decode(response.body);

    List<Postagem> postagens = List();

    for (var post in dadosJson) {
      print("post: " + post["title"]);
      Postagem p =
          Postagem(post["userId"], post["id"], post["title"], post["body"]);
      postagens.add(p);
    }

    return postagens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consumo de serviços - Future"),
      ),
      body: FutureBuilder<List<Postagem>>(
        future: _recuperarPostagens(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child:  CircularProgressIndicator(
                  backgroundColor: Colors.yellow,
                ),
              );
              break;
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                print("Erro ao recuperar dados.");
              } else {
                print("lista carregou.");
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {

                      List<Postagem> lista = snapshot.data;
                      Postagem post = lista[index];

                      return ListTile(
                        title: Text(post.title,
                        style: TextStyle(
                          fontSize: 12,
                        ),),
                        subtitle: Text(post.id.toString()),
                      );
                    });
              }
              break;
          }

          return Center(
//            child: Text(resutado),
          );
        },
      ),
    );
  }
}

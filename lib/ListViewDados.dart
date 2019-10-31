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

  _post() async {

    var corpo = json.encode(
      {
        "userId": 1,
        "id": null,
        "title":"Titulo teste",
        "body": "Corpo da postagem"
      }
    );

    Response response = await post(
        _urlBase + "/posts",
      headers: {
          "Content-type":"application/json; charset=UTF-8"
      },
      body: corpo
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");

  }

  _put() async { //precisa do objeto inteiro para atualizar

    var corpo = json.encode(
        {
          "userId": 120,
          "id": null,
          "title":"Titulo alterado",
          "body": "Corpo da postagem altearado"
        }
    );

    Response response = await put(
        _urlBase + "/posts/2",
        headers: {
          "Content-type":"application/json; charset=UTF-8"
        },
        body: corpo
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");


  }

  _patch() async {
    var corpo = json.encode(
        {
          "userId": 1,
          "body": "Corpo da postagem"
        }
    );

    Response response = await patch(
        _urlBase + "/posts",
        headers: {
          "Content-type":"application/json; charset=UTF-8"
        },
        body: corpo
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");


  }
  _delete() async {

    Response response = await delete(
        _urlBase + "/posts/2",
    );

    print("resposta: ${response.statusCode}");
    print("resposta: ${response.body}");


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Consumo de serviços - Future"),
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Salvar"),
                    onPressed: _post,
                  ),
                  RaisedButton(
                    child: Text("Atualizar"),
                    onPressed: _put,
                  ),
                  RaisedButton(
                    child: Text("Deletar"),
                    onPressed: _delete,
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<List<Postagem>>(
                  future: _recuperarPostagens(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(
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
                                  title: Text(
                                    post.title,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
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
              )
            ],
          ),
        ));
  }
}

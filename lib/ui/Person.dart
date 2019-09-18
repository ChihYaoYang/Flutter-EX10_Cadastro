import 'package:flutter/material.dart';

class Person extends StatefulWidget {
  final int id;
  final String nome;
  final String telefone;

  //todos os parâmetros são obrigatorios no construtor da class:
  Person(this.id, this.nome, this.telefone);

  //Parâmetros opcionais
//  Person({this.id, this.nome, @required this.telefone});

  @override
  _PersonState createState() => _PersonState();
}

class _PersonState extends State<Person> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nome),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text(widget.id.toString()),
              Text(widget.telefone),
            ],
          ),
        ),
      ),
    );
  }
}

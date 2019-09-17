import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //remove o botão da APPBAR
//          automaticallyImplyLeading: false,
        title: Text("Cadastro"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                prefix: Icon(Icons.account_circle),
                labelText: "Digite o Nome",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                ),
              ),
              controller: _nomeController,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefix: Icon(Icons.email),
                labelText: "Digite o E-mail",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                ),
              ),
              controller: _emailController,
            ),
//            RaisedButton(
//              onPressed: () {
//                Navigator.pop(context);
//              },
//              color: Colors.blueAccent,
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.stretch,
//                children: <Widget>[
//                  Icon(Icons.save,
//                  color: Colors.white,),
//                ],
//              ),
//            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(message),
          actions: <Widget>[
            // define os botões na base do dialogo
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

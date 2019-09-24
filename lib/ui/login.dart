import 'package:flutter/material.dart';
import 'package:cadastro_app/ui/cadastrologin.dart';
import 'package:cadastro_app/ui/home.dart';
import 'package:cadastro_app/helper/login_helper.dart';
import 'package:passwordfield/passwordfield.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  List<Login> logins = List();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('images/user.png'),
                    ),
                  ),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefix: Icon(Icons.email),
                  labelText: "Digite o E-mail ou nome",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
                controller: _emailController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Preencher este campo  !";
                  }
                },
              ),
              PasswordField(
//                decoration: InputDecoration(
//                  prefix: Icon(Icons.vpn_key),
//                  labelText: "Digite a Senha",
//                  enabledBorder: UnderlineInputBorder(
//                    borderSide: BorderSide(color: Colors.cyan),
//                  ),
//                ),
//                controller: _senhaController,
//                validator: (value) {
//                  if (value.isEmpty) {
//                    return "Preencher este campo  !";
//                  }
//                },
//
                  ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  color: Colors.green,
                  child: Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formkey.currentState.validate()) {
//                      _login();
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  color: Colors.greenAccent,
                  child: Text(
                    "Cadastrar",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CadastroLogin()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

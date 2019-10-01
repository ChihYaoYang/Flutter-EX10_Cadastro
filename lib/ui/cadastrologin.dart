import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:cadastro_app/helper/login_helper.dart';
import 'package:cadastro_app/utils/Dialogs.dart';

class CadastroLogin extends StatefulWidget {
  @override
  _CadastroLoginState createState() => _CadastroLoginState();
}

class _CadastroLoginState extends State<CadastroLogin> {
  LoginHelper helper = LoginHelper();
  Dialogs dialog = new Dialogs();

  //Declara variável
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  //Declara booleano
  bool condition = false;
  bool passwordVisible;

  @override
  //初始化狀態時
  void initState() {
    super.initState();
    _nomeController.addListener(() {
      btnReset();
    });
    _emailController.addListener(() {
      btnReset();
    });
    _senhaController.addListener(() {
      btnReset();
    });
    passwordVisible = true;
  }

//Opacidade botão resert
  void btnReset() {
    setState(() {
      if (_nomeController.text.isNotEmpty ||
          _emailController.text.isNotEmpty ||
          _senhaController.text.isNotEmpty) {
        condition = true;
      } else {
        condition = false;
      }
    });
  }

//Resert valor do campo e fecha keyboard
  void _resetFields() {
    _nomeController.text = "";
    _emailController.text = "";
    _senhaController.text = "";
    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro Login'),
        backgroundColor: Colors.cyan,
        centerTitle: true,
        actions: <Widget>[
          Opacity(
              //define a opacidade conforme o preenchimento dos campos.
              opacity: this.condition ? 1.0 : 0.0,
              child: ButtonTheme(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: RaisedButton(
                    color: Colors.cyan,
                    textColor: Colors.white,
                    onPressed: () {
                      //desativa o clique do botão.
                      condition ? _resetFields() : null;
                    },
                    child: Icon(Icons.refresh),
                  )))
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 60, left: 30, right: 30),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Nome",
                  prefixIcon: Container(
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                controller: _nomeController,
                validator: (value) {
                  //Valida o campo se for vazio return text
                  if (value.isEmpty) {
                    return "Campo obrigatório !";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "E-mail",
                  prefixIcon: Container(
                    child: Icon(
                      Icons.email,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                controller: _emailController,
                validator: (value) {
                  //Valida o campo se for vazio return text
                  if (value.isEmpty) {
                    return "Campo obrigatório !";
                  }
                  return null;
                },
              ),
              TextFormField(
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  labelText: "Senha",
                  prefixIcon: Container(
                    child: Icon(
                      Icons.vpn_key,
                      color: Colors.blueAccent,
                    ),
                  ),
                  suffixIcon: Container(
                    child: IconButton(
                      icon: Icon(
                        passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                controller: _senhaController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Campo obrigatório !";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formkey.currentState.validate()) {
            if (isEmail(_emailController.text)) {
              if (await helper.saveLogin(_nomeController.text,
                  _emailController.text, _senhaController.text)) {
                Navigator.pop(context);
              } else {
                dialog.showAlertDialog(
                    context, 'Aviso', 'Usuário não cadastrado');
              }
            } else {
              dialog.showAlertDialog(
                  context, 'Aviso', 'Preencher com E-mail válido');
            }
          }
        },
        child: Icon(
          Icons.save,
          color: Colors.blueAccent,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}

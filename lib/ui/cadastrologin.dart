import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:cadastro_app/helper/login_helper.dart';

class CadastroLogin extends StatefulWidget {
  //constructor
  Login login;

  CadastroLogin({this.login});

  @override
  _CadastroLoginState createState() => _CadastroLoginState();
}

class _CadastroLoginState extends State<CadastroLogin> {
  //Declara variável
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  //Declara booleano
  bool condition = false;
  bool passwordVisible;
  Login _editedLogin;

  @override
  //初始化狀態時
  void initState() {
    if (widget.login == null) {
      _editedLogin = Login();
    }
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
        padding: EdgeInsets.all(10.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  prefix: Icon(Icons.person),
                  labelText: "Digite o Nome",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                ),
                controller: _nomeController,
                validator: (value) {
                  //Valida o campo se for vazio return text
                  if (value.isEmpty) {
                    return "Preencher este campo  !";
                  } else {
                    //else passa valor para editedLogin  => editedLogin.nome nome do campo
                    setState(() {
                      _editedLogin.nome = value;
                    });
                  }
                },
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
                validator: (value) {
                  //Valida o campo se for vazio return text
                  if (value.isEmpty) {
                    return "Preencher este campo  !";
                  } else {
                    //else passa valor para editedLogin  => editedLogin.email nome do campo
                    setState(() {
                      _editedLogin.email = value;
                    });
                  }
                },
              ),
              TextFormField(
                obscureText: passwordVisible,
                decoration: InputDecoration(
                  prefix: Icon(Icons.vpn_key),
                  labelText: "Digite a Senha",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
                controller: _senhaController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Preencher este campo  !";
                  }
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //Botão flutuante
        onPressed: () {
          //Valida campo
          if (_formkey.currentState.validate()) {
            //Valida campo se é email
            if (isEmail(_emailController.text)) {
              //Deu certo fecha keyboard  e _editedPerson passa para página Home (ListView)
              FocusScope.of(context).requestFocus(new FocusNode());
              Navigator.pop(context, _editedLogin);
            } else {
              //else exibir mensagem
              _showDialog(
                  'Aviso', 'O campo e-mail, Preencher com email corretos !');
            }
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.cyan,
      ),
    );
  }

  //Alert Dialog
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

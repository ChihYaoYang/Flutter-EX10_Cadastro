import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cadastro_app/ui/cadastrologin.dart';
import 'package:cadastro_app/ui/home.dart';
import 'package:cadastro_app/helper/login_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  //Declara booleano
  bool passwordVisible;
  bool condition = false;

  LoginHelper helper = LoginHelper();

  //初始化狀態時 passwordVisible = true 隱藏字體
  @override
  void initState() {
    super.initState();
    //Opacidade botão resert
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
      if (_emailController.text.isNotEmpty ||
          _senhaController.text.isNotEmpty) {
        condition = true;
      } else {
        condition = false;
      }
    });
  }

//Resert valor do campo e fecha keyboard
  void _resetFields() {
    _emailController.text = "";
    _senhaController.text = "";
    setState(() {
      FocusScope.of(context).requestFocus(new FocusNode());
    });
  }

//login
  void _login() async {
    if (await helper.getLocado(_emailController.text, _senhaController.text) != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      _showDialog('Aviso', 'Email ou Senha Inválido');
    }
  }

//cadastro
  void _register({Login login}) async {
    final recLogin = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroLogin(
                  login: login,
                )));
    if (login != null) {
      await helper.saveLogin(recLogin);
      await helper.saveSession(recLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: <Widget>[
          Opacity(
              //define a opacidade conforme o preenchimento dos campos.
              opacity: this.condition ? 1.0 : 0.0,
              child: ButtonTheme(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: RaisedButton(
                    color: Colors.blueAccent,
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
              Container(
                padding: EdgeInsets.only(top: 10.0),
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.35),
                    hintText: " Digite o E-mail ou nome",
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Container(
                      child: Icon(
                        Icons.perm_identity,
                        color: Colors.white,
                      ),
                      color: Colors.yellow,
                    ),
                  ),
                  controller: _emailController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Campo obrigatório !";
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.35),
                    hintText: " Digite a Senha",
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Container(
                      child: Icon(
                        Icons.vpn_key,
                        color: Colors.white,
                      ),
                      color: Colors.yellow,
                    ),
                    suffixIcon: Container(
                      child: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
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
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, left: 70.0, right: 70.0),
                child: RaisedButton(
                  color: Colors.yellow,
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.lightBlue),
                  ),
                  onPressed: () {
                    if (_formkey.currentState.validate()) {
                      _login();
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 140.0, right: 140.0),
                child: FlatButton(
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.yellow),
                  ),
                  onPressed: () {
                    _register();
                  },
                ),
              ),
            ],
          ),
        ),
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

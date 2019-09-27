import 'package:flutter/material.dart';
import 'package:cadastro_app/ui/home.dart';
import 'package:cadastro_app/helper/login_helper.dart';
import 'package:validators/validators.dart';

class LoginPage extends StatefulWidget {
  //constructor
  Login login;

  LoginPage({this.login});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool passwordVisible;
  bool condition = false;

  LoginHelper helper = LoginHelper();
  Login _editedLogin;
  Session _editedSession;

  //初始化狀態時 passwordVisible = true 隱藏字體
  @override
  void initState() {
    super.initState();
    if (widget.login == null) {
      _editedLogin = Login();
      _editedSession = Session();
    } else {
      _editedLogin = Login.fromMap(widget.login.toMap());
      _emailController.text = _editedLogin.email;
      _senhaController.text = _editedLogin.senha;
    }
    //Opacidade botão resert
    _emailController.addListener(() {
      btnReset();
    });
    _senhaController.addListener(() {
      btnReset();
    });
    passwordVisible = true;
    _editedSession = Session();
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

//Entrar(Login)
  void _login() async {
    if (await helper.getLogin(_editedLogin.email, _editedLogin.senha) != null) {
      helper.saveSession(_editedSession);
      Navigator.pop(context);
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      _showDialog('Aviso', 'Email ou Senha incorretos !');
    }
  }

//cadastro
  void _register() async {
    helper.saveLogin(_editedLogin);
    setState(() {
      _emailController.text = '';
      _senhaController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false,
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
      backgroundColor: Colors.blue,
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
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
                    hintText: " Digite o E-mail",
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Container(
                      child: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      color: Colors.yellow,
                    ),
                  ),
                  controller: _emailController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Campo obrigatório !";
                    } else {
                      //else passa valor para editedLogin  => editedLogin.email nome do campo
                      setState(() {
                        _editedLogin.email = value;
                      });
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
                    } else {
                      setState(() {
                        _editedLogin.senha = value;
                      });
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
                      if (isEmail(_emailController.text)) {
                        _login();
                      } else {
                        _showDialog('Aviso', 'Preencher com E-mail Válido !');
                      }
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
                    if (_formkey.currentState.validate()) {
                      if (isEmail(_emailController.text)) {
                        _register();
                      } else {
                        _showDialog('Aviso', 'Preencher com E-mail Válido !');
                      }
                    }
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

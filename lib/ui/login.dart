import 'package:cadastro_app/ui/cadastrologin.dart';
import 'package:flutter/material.dart';
import 'package:cadastro_app/ui/home.dart';
import 'package:cadastro_app/helper/login_helper.dart';
import 'package:flutter/services.dart';
import 'package:cadastro_app/utils/Dialogs.dart';

class LoginPage extends StatefulWidget {
  //Constructor
  final Login login;

  LoginPage({this.login});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Declara variaveis
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool passwordVisible;
  bool condition = false;

  LoginHelper helper = LoginHelper();
  List<Login> login = List();
  Dialogs dialog = new Dialogs();

  //初始化狀態時
  @override
  void initState() {
    super.initState();
    //Como queríamos remover as sobreposições apenas na splash screen,
    // é necessário fazer uma chamada ao método setEnabledSystemUIOverlays
    // passando como parâmetro o valor SystemUiOverlay.values no initState da
    // classe HomePage (tela seguinte a splash) para que a tela volte ao posicionamento normal.
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    //Opacidade botão resert
    _emailController.addListener(() {
      btnReset();
    });
    _senhaController.addListener(() {
      btnReset();
    });
    //Declara variavel bool para usa obscuretext
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

//Entrar(Login)
  void _login() async {
    Login user = await helper.getLogin(
        _emailController.text, _emailController.text, _senhaController.text);
    if (user != null) {
      if (user.nome == _emailController.text ||
          user.email == _emailController.text &&
              user.senha == _senhaController.text) {
        helper.saveLogado(user.id);
        Navigator.pop(context);
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage(user.id)));
      } else {
        dialog.showAlertDialog(context, 'Aviso', 'Login inválido');
      }
    } else {
      dialog.showAlertDialog(context, 'Aviso', 'Login inválido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
      backgroundColor: Colors.blue,
      //permite a tela ser rolada automaticamente para cima com objetivo de não esconder
      // campos embaixo do teclado virtual
      body: WillPopScope(
          child: SingleChildScrollView(
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
                        fillColor: Colors.yellow.withOpacity(0.45),
                        hintText: " Digite seu email ou nome",
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Container(
                          child: Icon(
                            Icons.account_circle,
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
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 10.0),
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      //obscureText ocultar caracter, Se for true ocultar false exibir
                      obscureText: passwordVisible,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        filled: true,
                        fillColor: Colors.yellow.withOpacity(0.45),
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
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 70.0, right: 70.0),
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
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CadastroLogin()));
                        _resetFields();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          onWillPop: () {
            SystemNavigator.pop();
          }),
    );
  }
}

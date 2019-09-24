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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  //Declara booleano
  bool passwordVisible;
  bool condition = false;

  LoginHelper helper = LoginHelper();

  //初始化狀態時 passwordVisible = true 隱藏字體
  @override
  void initState() {
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

  void _login({Login login}) async {
    if (login.email == _emailController.text ||
        login.nome == _emailController.text &&
            login.senha == _senhaController.text) {
      final recLogin = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      await helper.getLogin(recLogin);
    } else {
      _showDialog('Aviso', 'Login inválido');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    color: Colors.blue,
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
                      _login();
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

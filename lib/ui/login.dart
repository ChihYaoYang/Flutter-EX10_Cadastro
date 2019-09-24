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

  LoginHelper helper = LoginHelper();

  //初始化狀態時 passwordVisible = true 隱藏字體
  @override
  void initState() {
    passwordVisible = true;
  }

  //Passa valor e valida o campo email e senha
  void _loginvalidation({Login login}) async {
//    final recLogin = await Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => HomePage(
//
//            )));
//    //Valida person
//    if (recLogin != null) {
//      //Se for diferente que NULL => UPDATE
//      if (login != null) {
//        await helper.getLogin(recLogin);
//      }
//    }
  }

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
//                      color: Theme.of(context).primaryColorDark,
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
                      _loginvalidation();
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

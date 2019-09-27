import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cadastro_app/ui/login.dart';
import 'package:cadastro_app/ui/home.dart';
import 'package:cadastro_app/helper/login_helper.dart';

//stateless（無狀態）和 stateful（有狀態）widgets的區別.
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  //Carrega LoginHelper
  LoginHelper helper = LoginHelper();

  @override
  //初始化狀態時
  void initState() {
    super.initState();
    //O setEnabledSystemUIOverlays tem por objetivo definir quais sobreposições
    // por exemplo serão exibidas durante a execução do app.
    // Como na splash screen não queremos que nada a sobreponha, passamos com parâmetro uma lista vazia.
    SystemChrome.setEnabledSystemUIOverlays([]);
    //No initState também precisamos fazer o redirecionamento da splash screen para a tela seguinte
    // que deverá ser aberta. Para isso, usamos ao método delayed da classe Future passando como parâmetro
    // um Duration de 4 segundos.
    // Por fim, o método pushReplacement da classe Navigator é utilizado para executar a troca da tela sem possibilitar o retorno à anterior.
    Future.delayed(Duration(seconds: 4)).then((_) async {
      //Valida Session se o usuário estiver logado(true) redireciona para página HomePage()
      if (await helper.getSesseion() == true) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else { //Caso contrário(else) redireciona para página LoginPage()
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.blue,
        child: Center(
          child: Container(
            width: 150,
            height: 150,
            child: Image.asset("images/splash.png"),
          ),
        ));
  }
}

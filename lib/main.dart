import 'package:cadastro_app/screen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(MaterialApp(
    //Chama tela de Splash Screen(加載頁面)
    home: Splash(),
    debugShowCheckedModeBanner: false,
  ));
}

import 'package:flutter/material.dart';
import 'package:cadastro_app/ui/login.dart';
import 'package:cadastro_app/ui/home.dart';
import 'package:cadastro_app/helper/login_helper.dart';

void main() async {
  LoginHelper helper = LoginHelper();
  runApp(MaterialApp(
    home: (await helper.session == true) ? HomePage() : LoginPage(),
    debugShowCheckedModeBanner: false,
  ));
}

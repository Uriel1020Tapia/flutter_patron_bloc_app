import 'package:flutter/material.dart';
import 'package:flutter_app_patron_bloc/src/bloc/provider.dart';

import 'package:flutter_app_patron_bloc/src/pages/home_page.dart';
import 'package:flutter_app_patron_bloc/src/pages/login_page.dart';
import 'package:flutter_app_patron_bloc/src/pages/product_page.dart';
import 'package:flutter_app_patron_bloc/src/pages/registro_page.dart';
import 'package:flutter_app_patron_bloc/src/preferencias_usuario/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginPage(),
        'home': (context) => HomePage(),
        'product': (context) => ProductPage(),
        'registro': (context) => RegistroPage(),
      },
      theme: ThemeData(primaryColor: Colors.deepPurpleAccent),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app_patron_bloc/src/bloc/provider.dart';

import 'package:flutter_app_patron_bloc/src/pages/home_page.dart';
import 'package:flutter_app_patron_bloc/src/pages/login_page.dart';

void main() => runApp(MyApp());

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
        'home': (context) => HomePage()
      },
      theme: ThemeData(primaryColor: Colors.deepPurpleAccent),
    ));
  }
}

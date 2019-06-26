import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'shoppinglist.dart' ;
import 'signup_page.dart' ;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    ShoppingList.tag: (context) => ShoppingList (),
    SignupPage.tag: (context) => SignupPage(),

  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodeversitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: SignupPage(),
      routes: routes,
    );
  }
}
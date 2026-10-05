import 'package:conversor_app/pages/home_page.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        primarySwatch: Colors.blue,

        inputDecorationTheme: const InputDecorationTheme(
          
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amber),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.amberAccent),
          ),
          hintStyle: TextStyle(color: Colors.amber),
        ),
      ),
      home: const HomePage()
    );
  }
}
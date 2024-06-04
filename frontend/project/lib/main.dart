import 'package:flutter/material.dart';
import 'package:project/Screen/home_screen.dart';
import 'package:project/Screen/starting_screen/login.dart';
import 'package:project/Screen/starting_screen/signup.dart';

void main() {
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/signin': (context) => SignupScreen(),
        '/login': (context) => Login()
      }
    )
  );
}
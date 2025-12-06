import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsi 2 Mobile Paket 2 H1D023109',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.green),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.green),
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(backgroundColor: Colors.green)),
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

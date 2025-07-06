import 'package:flutter/material.dart';
import 'core/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'دعوة QR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Rubik',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          background: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            borderSide: const BorderSide(color: Colors.black12),
          ),
        ),
      ),
      initialRoute: '/', // Start with signup screen
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

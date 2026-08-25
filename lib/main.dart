import 'package:app_contatos/lista_contatos_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListaContatosPage(),
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';

class ListasCompartidasPage extends StatelessWidget {
  const ListasCompartidasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listas Compartidas"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text("Aquí van las listas compartidas"),
      ),
    );
  }

}
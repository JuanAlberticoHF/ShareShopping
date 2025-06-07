
import 'package:flutter/material.dart';

AppBar misListasAppBar () {
  return AppBar(
    title: Text("Mis listas"),
    backgroundColor: Colors.white70,
    scrolledUnderElevation: 0.0,
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
        tooltip: 'Buscar',
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.more_vert),
        tooltip: 'Mas opciones',
        onPressed: () {},
      ),
    ],
  );
}
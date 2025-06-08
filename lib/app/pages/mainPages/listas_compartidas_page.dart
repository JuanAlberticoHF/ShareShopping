import "package:firebase_cloud_firestore/firebase_cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:shareshopping/core/services/auth_service.dart";
import "../../../core/services/listados_fb.dart";
import "../../widgets/elemento_listados.dart";
import 'package:firebase_auth/firebase_auth.dart';

class ListasCompartidasPage extends StatefulWidget {
  const ListasCompartidasPage({super.key});

  @override
  State<ListasCompartidasPage> createState() => ListasCompartidasPageState();
}

class ListasCompartidasPageState extends State<ListasCompartidasPage> {
  final FireStoreService fireStoreService = FireStoreService();
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Buscar listas...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchText = value.toLowerCase();
            });
          },
        )
            : const Text('Listas Compartidas'),
        backgroundColor: Colors.white70,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchText = "";
                }
              });
            },
          ),
        ],
      ),
      backgroundColor: Colors.white70,
      body: StreamBuilder<User?>(
        stream: authServiceNotifier.value.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Inicia sesión para ver tus listas compartidas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }
          final String uidUsuarioActivo = snapshot.data!.uid;
          return StreamBuilder<List<QueryDocumentSnapshot>>(
            key: ValueKey(uidUsuarioActivo),
            stream: fireStoreService
                .getListadosByCompartidos(uidUsuarioActivo)
                .map((snapshot) => snapshot.docs),
            builder: (context, snapshotListas) {
              if (snapshotListas.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshotListas.hasError) {
                return Center(child: Text("Error: ${snapshotListas.error}"));
              }
              final listados = snapshotListas.data ?? [];
              final listasFiltradas = _searchText.isEmpty
                  ? listados.where((listado) => listado['operativa'] == true).toList()
                  : listados.where((listado) {
                final nombreLista = listado['nombre'].toString().toLowerCase();
                return nombreLista.contains(_searchText) && listado['operativa'] == true;
              }).toList();

              if (listasFiltradas.isEmpty) {
                return const Center(child: Text("No se han encontrado listas"));
              }

              return ListView.builder(
                itemCount: listasFiltradas.length,
                itemBuilder: (BuildContext context, int index) {
                  final listado = listasFiltradas[index];
                  final articulo = listado.get("articulos");

                  int cantidadArticulos = articulo.length;
                  int articulosMarcados = 0;
                  for (var art in articulo) {
                    if (art['check'] == true) articulosMarcados++;
                  }
                  final textoProgreso = "$articulosMarcados/$cantidadArticulos";
                  double valorProgreso = cantidadArticulos > 0 ? articulosMarcados / cantidadArticulos : 0;

                  return ElementosListas(
                    id: listado.id,
                    nombre: listado['nombre'],
                    progreso: valorProgreso,
                    itemsText: textoProgreso,
                    onDelete: () {
                      fireStoreService.updateListadoOperativo(listado.id, false);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/services/listados_service_fb.dart';
import '../../widgets/elemento_listados_papelera.dart';

/// Página que muestra las listas en la papelera ('operativo' = false)
class PapeleraPage extends StatefulWidget {
  const PapeleraPage({super.key});

  @override
  State<PapeleraPage> createState() => _PapeleraPageState();
}

class _PapeleraPageState extends State<PapeleraPage> {
  /// Servicio para interactuar con la coleccion 'listados' en Firestore
  FireStoreServiceListados fireStoreServiceListados = FireStoreServiceListados();

  bool _isSearching = false; // Controla el estado de búsqueda
  final TextEditingController _searchController = TextEditingController(); // Controlador de texto para la búsqueda
  String _searchText = ""; // Texto de búsqueda

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
            : const Text('Papelera'),
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
        backgroundColor: Colors.white70,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[200],
      body: Container(
          color: Colors.white70,
          padding: const EdgeInsets.all(5.0),
          child: StreamBuilder (
              stream: fireStoreServiceListados.getListados(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Listados de Firestore
                final listados = snapshot.data!.docs;

                // 🔍 Filtrar por búsqueda
                final listasFiltradas = _searchText.isEmpty
                    ? listados.where((listado) => listado['operativa'] == false).toList()
                    : listados.where((listado) {
                  final nombreLista = listado['nombre'].toString().toLowerCase();
                  return nombreLista.contains(_searchText) && listado['operativa'] == false;
                }).toList();

                return ListView.builder(
                  itemCount: listasFiltradas.length,
                  itemBuilder: (BuildContext context, int index) {
                    final listado = listasFiltradas[index];
                    final articulo = listado.get("articulos");

                    // Calcular progreso
                    int cantidadArticulos = articulo.length;
                    int articulosMarcados = 0;
                    for (var art in articulo) {
                      if (art['check'] == true) articulosMarcados++;
                    }
                    final textoProgreso = "$articulosMarcados/$cantidadArticulos";

                    return ElementosListasPapelera(
                      id: listado.id,
                      nombre: listado['nombre'],
                      itemsText: textoProgreso,
                      onDelete: () {
                        fireStoreServiceListados.deleteListado(listado.id);
                      },
                    );
                  },
                );
              }
          )
      ),
    );
  }
}
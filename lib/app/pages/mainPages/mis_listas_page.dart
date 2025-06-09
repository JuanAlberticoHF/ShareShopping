
import "package:flutter/material.dart";
import "package:ShareShopping/app/pages/operationPages/papelera_page.dart";
import "package:ShareShopping/core/services/auth_service.dart";
import "../../../core/services/listados_service_fb.dart";
import "../../widgets/elemento_listados.dart";
import "../../widgets/elemento_listados_compartidos_creador.dart";
import "../operationPages/add_listas_page.dart";
import 'package:firebase_auth/firebase_auth.dart';

class ListasUsuarioPage extends StatefulWidget {
  const ListasUsuarioPage({super.key});

  @override
  State<ListasUsuarioPage> createState() => ListasUsuarioPageState();
}

class ListasUsuarioPageState extends State<ListasUsuarioPage> {
  final FireStoreServiceListados fireStoreService = FireStoreServiceListados();
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = "";

  Widget sinDatos() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: AssetImage("assets/lista.png"),
            width: 150,
            height: 150,
          ),
          SizedBox(height: 16),
          Text(
            "No se han encontrado listas",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

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
            : const Text('Mis listas'),
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.white,
            onSelected: (value) {
              if (value == 'papelera') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PapeleraPage(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'papelera',
                child: Row(
                  children: const [
                    Icon(Icons.delete, color: Colors.red),
                    Text('Papelera'),
                  ],
                ),
              ),
            ],
          )
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white70,
      floatingActionButton: StreamBuilder<User?>(
        stream: authServiceNotifier.value.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              heroTag: "btnNuevaLista",
              elevation: 4,
              backgroundColor: Colors.blue,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Nueva lista", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddListasPage(),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: StreamBuilder<User?>(
        stream: authServiceNotifier.value.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            // Mensaje genérico para usuario no autenticado
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.no_accounts, size: 100, color: Colors.black),
                  const SizedBox(height: 16),
                  const Text(
                    "Inicia sesion para ver tus listas",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }
          final String uidUsuarioActivo = snapshot.data!.uid;
          return StreamBuilder(
            key: ValueKey(uidUsuarioActivo),
            stream: fireStoreService.getListadosByCreador(uidUsuarioActivo),
            builder: (context, snapshotListas) {
              if (snapshotListas.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshotListas.hasError) {
                return Center(child: Text("Error: ${snapshotListas.error}"));
              }
              if (!snapshotListas.hasData || snapshotListas.data!.docs.isEmpty) {
                return sinDatos();
              }

              final listados = snapshotListas.data!.docs;
              final listasFiltradas = _searchText.isEmpty
                  ? listados.where((listado) => listado['operativa'] == true).toList()
                  : listados.where((listado) {
                final nombreLista = listado['nombre'].toString().toLowerCase();
                return nombreLista.contains(_searchText) && listado['operativa'] == true;
              }).toList();

              if (listasFiltradas.isEmpty) {
                return sinDatos();
              }

              return ListView.builder(
                itemCount: listasFiltradas.length,
                itemBuilder: (BuildContext context, int index) {
                  final listado = listasFiltradas[index];
                  final articulo = listado.get("articulos");
                  final compartidos = listado.get("compartidos");

                  int cantidadArticulos = articulo.length;
                  int articulosMarcados = 0;
                  for (var art in articulo) {
                    if (art['check'] == true) articulosMarcados++;
                  }
                  final textoProgreso = "$articulosMarcados/$cantidadArticulos";
                  double valorProgreso = cantidadArticulos > 0 ? articulosMarcados / cantidadArticulos : 0;

                  if (compartidos.isEmpty) {
                    return ElementosListas(
                      id: listado.id,
                      nombre: listado['nombre'],
                      progreso: valorProgreso,
                      itemsText: textoProgreso,
                      onDelete: () {
                        fireStoreService.updateListadoOperativo(listado.id, false);
                      },
                    );
                  } else {
                    return ElementosListasCompartidasCreador(
                      id: listado.id,
                      nombre: listado['nombre'],
                      progreso: valorProgreso,
                      itemsText: textoProgreso,
                      onDelete: () {
                        fireStoreService.updateListadoOperativo(listado.id, false);
                      },
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
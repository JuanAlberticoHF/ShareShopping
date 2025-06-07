import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/services/listados_fb.dart'; // Servicio de Firestore

class ArticulosListasPage extends StatefulWidget {
  final String listaId; // ID del listado
  final double progress; // Progreso inicial
  final String nombreLista; // Nombre del listado

  const ArticulosListasPage({
    super.key,
    required this.listaId,
    required this.progress,
    required this.nombreLista,
  });

  @override
  State<ArticulosListasPage> createState() => _ArticulosListasPageState();
}

class _ArticulosListasPageState extends State<ArticulosListasPage> {
  // Variables de la pagina
  final FireStoreService fireStoreService = FireStoreService(); // Servicio de Firestore
  final TextEditingController _controller = TextEditingController();
  late double progressValue; // Valor del progreso

  // Al inicio inicializamos el progreso del los articulos marcados
  @override
  void initState() {
    super.initState();
    progressValue = widget.progress;
  }
  /// Agrega un nuevo artículo a la lista.
  void _agregarArticulo() async {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) return;

    final doc = await fireStoreService.getListadoById(widget.listaId);
    final data = doc.data()?.asMap();

    if (data != null && data.containsKey('articulos')) {
      final List<dynamic> articulos = List.from(data['articulos']);
      articulos.add({
        'nombre': nombre,
        'check': false,
        'cantidad': 1,
        'nota': '',
        'unidad': null,
      });

      fireStoreService.updateListado(widget.listaId, articulos);
      recalcularProgreso(articulos); // TODO: No suma bien
    }

    _controller.clear();
  }

  /// Recalcula el progreso de los artículos marcados en la lista.
  void recalcularProgreso(List<dynamic> articulos) {
    final total = articulos.length;
    if (total == 0) {
      setState(() {
        progressValue = 0.0;
      });
      return;
    }
    final marcados = articulos.where((a) => a['check'] == true).length;
    setState(() {
      progressValue = marcados / total;
    });
  }

  /*
  * WIDGET
  */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreLista),
        backgroundColor: Colors.white70,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // TextField para añadir artículos con boton de añadir
          Padding(
            // Padding personalizados
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Añadir artículo',
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) => _agregarArticulo(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.green),
                    onPressed: _agregarArticulo,
                  ),
                ],
              ),
            ),
          ),
          // Indicador de progreso
          LinearProgressIndicator(
            color: Colors.green,
            backgroundColor: Colors.grey[200],
            value: progressValue,
          ),
          // Listado de artículos
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: fireStoreService.getListadoStreamById(widget.listaId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final List<dynamic> articulos = data['articulos'] ?? [];

                return ListView.builder(
                  itemCount: articulos.length,
                  itemBuilder: (context, index) {
                    final articulo = articulos[index];
                    final nombre = articulo['nombre'] ?? 'Artículo';
                    final check = articulo['check'] ?? false;

                    return Dismissible(
                      key: Key(articulo['nombre'] ?? 'Artículo $index'),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        List<dynamic> nuevosArticulos = List.from(articulos)
                          ..removeAt(index);
                        try {
                          await fireStoreService.updateListado(
                            widget.listaId,
                            nuevosArticulos,
                          );
                          recalcularProgreso(nuevosArticulos);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al eliminar el artículo'),
                            ),
                          );
                        }
                      },
                      child: ListTile(
                        leading: Checkbox(
                          value: check,
                          onChanged: (nuevoValor) async {
                            List<dynamic> nuevosArticulos = List.from(
                              articulos,
                            );
                            nuevosArticulos[index] = {
                              ...articulo,
                              'check': nuevoValor,
                            };
                            fireStoreService.updateListado(
                              widget.listaId,
                              nuevosArticulos,
                            );
                            recalcularProgreso(nuevosArticulos);
                          },
                        ),
                        title: Text(
                          nombre,
                          style: TextStyle(
                            decoration: check
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        onTap: () async {
                          List<dynamic> nuevosArticulos = List.from(articulos);
                          nuevosArticulos[index] = {
                            ...articulo,
                            'check': !check,
                          };
                          fireStoreService.updateListado(
                            widget.listaId,
                            nuevosArticulos,
                          );
                          recalcularProgreso(nuevosArticulos);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

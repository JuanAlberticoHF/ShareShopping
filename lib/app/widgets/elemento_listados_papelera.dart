import 'package:flutter/material.dart';

import '../../core/services/listados_service_fb.dart';

class ElementosListasPapelera extends StatelessWidget {
  final String id; // Identificador
  final String nombre; // Título
  final double progreso; // Progreso
  final String itemsText; // Elementos "X/Y"// Callback para eliminar el elemento
  final VoidCallback? onDelete;

  ElementosListasPapelera({
    super.key,
    required this.id,
    required this.nombre,
    required this.progreso,
    required this.itemsText,
    this.onDelete,
  });

  FireStoreServiceListados fireStoreService = FireStoreServiceListados();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Color del fondo de la tarjeta
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      // Tarjeta que contiene el Slidable
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //-- Título de la lista
                Text(
                  nombre,
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  itemsText,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      fireStoreService.updateListadoOperativo(id, true);
                    },
                    child: const Text("Restaurar", style: TextStyle(fontSize: 18, color: Colors.green),)
                ),
                TextButton(
                    onPressed: () {
                      if (onDelete != null) {
                        onDelete!();
                      }
                    },
                    child: const Text("Eliminar", style: TextStyle(fontSize: 18, color: Colors.red),)
                )
              ],
            )
          )
        ],
      ),
    );
  }
}

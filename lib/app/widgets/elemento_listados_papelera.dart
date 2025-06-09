import 'package:flutter/material.dart';

import '../../core/services/listados_service_fb.dart';

/// Widget que representa un elemento de una lista en la papelera
class ElementosListasPapelera extends StatelessWidget {
  final String _id; // Identificador
  final String _nombre; // Título
  final String _itemsText; // Elementos "X/Y"// Callback para eliminar el elemento
  final VoidCallback? _onDelete; // Callback para eliminar el elemento

  ElementosListasPapelera({
    super.key,
    required String id,
    required String nombre,
    required String itemsText,
    void Function()? onDelete,
  }) : _onDelete = onDelete, _itemsText = itemsText,
       _nombre = nombre,
       _id = id;

  /// Servicio para interactuar con la coleccion 'listados' en Firestore
  final FireStoreServiceListados _fireStoreServiceListados = FireStoreServiceListados();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Color del fondo de la tarjeta
      clipBehavior: Clip.antiAlias, // Clip para evitar que el contenido se salga de los bordes
      elevation: 2, // Elevación de la tarjeta
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          // Contenedor para el título y el número de elementos
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //-- Título de la lista (izquierda)
                Text(_nombre, style: const TextStyle(fontSize: 24)),
                // -- Número de elementos (derecha)
                Text(_itemsText, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
          // Padding para el progreso de la lista
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Botón para restaurar la lista
                TextButton(
                  onPressed: () {
                    _fireStoreServiceListados.updateListadoOperativo(_id, true);
                  },
                  child: const Text(
                    "Restaurar",
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ),
                // Botón para eliminar la lista permanentemente
                TextButton(
                  onPressed: () {
                    if (_onDelete != null) {
                      _onDelete!();
                    }
                  },
                  child: const Text(
                    "Eliminar",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

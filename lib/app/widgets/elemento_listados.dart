import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ShareShopping/app/pages/operationPages/articulos_listas_page.dart';
import 'package:ShareShopping/app/widgets/bottonsheet_compartir.dart';

import '../../core/services/listados_service_fb.dart';
import 'bottonsheet_listado.dart';
import 'editar_nombre_dialog.dart';

/// Widget que representa un elemento de una lista del usuario
class ElementosListas extends StatelessWidget {
  final String _id; // Identificador
  final String _nombre; // Título
  final double _progreso; // Progreso
  final String _itemsText; // Elementos "X/Y"// Callback para eliminar el elemento
  final VoidCallback? _onDelete; // Call

  ElementosListas({
    super.key,
    required String id,
    required String nombre,
    required double progreso,
    required String itemsText,
    void Function()? onDelete,
  }) : _onDelete = onDelete, _itemsText = itemsText, _progreso = progreso, _nombre = nombre, _id = id;

  /// Servicio para interactuar con la coleccion 'listados' en Firestore
  final FireStoreServiceListados _fireStoreServiceListados = FireStoreServiceListados();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticulosListasPage(
                listaId: _id,
                progress: _progreso,
                nombreLista: _nombre,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white, // Color del fondo de la tarjeta
        clipBehavior: Clip.antiAlias,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        // Tarjeta que contiene el Slidable
        child: Slidable(
          key: ValueKey(_id), // Clave única para el Slidable
          endActionPane: ActionPane( // Deslizar hacia la izquierda para mostrar acciones
            motion: const ScrollMotion(), // Animación de deslizamiento
            dismissible: DismissiblePane(onDismissed: () {
              if (_onDelete != null) {
                _onDelete!(); // Llama al callback para eliminar el elemento
              }
            }),
            children: [ // Widgets de acciones (Slidable Actions)
              //-- Accion Editar
              SlidableAction(
                onPressed: (context) {
                  EditarNombreDialog.show(
                    context,
                    nombreInicial: _nombre,
                    onSave: (nuevoNombre) {
                      _fireStoreServiceListados.updateListadoName(_id, nuevoNombre);
                    },
                  );
                },
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.edit,
              ),
              //-- Accion Compartir
              SlidableAction(
                onPressed: (context) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // Esto permite que el BottomSheet se ajuste al teclado
                    builder: (context) => CompartirLista(
                      idLista: _id,
                      nombreLista: _nombre,
                    ),
                  );
                },
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: Icons.person_add,
              ),
              SlidableAction(
                //-- Accion Eliminar
                onPressed: (context) {
                  if (_onDelete != null) {
                    _onDelete!(); // Llama al callback para eliminar el elemento
                  }
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
              ),
            ],
          ),
          //-- Contenido de la tarjeta
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //-- Título de la lista
                    Text(
                      _nombre,
                      style: const TextStyle(fontSize: 24),
                    ),
                    //-- Botón de opciones
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return OpcionesListado(idLista: _id, nombreLista: _nombre,);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Center(
                child: Text(
                  _itemsText,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: _progreso,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(colorBaseProgreso(_progreso)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Color colorBaseProgreso(double progressValue) {
    // Interpolación de color: rojo (0.0), naranja (0.5), verde (1.0)
    if (progressValue <= 0.5) {
      // De rojo a naranja
      return Color.lerp(Colors.red, Colors.orange.shade300, progressValue / 0.5)!;
    } else {
      // De naranja a verde
      return Color.lerp(Colors.orange.shade300, Colors.green, (progressValue - 0.5) / 0.5)!;
    }
  }
}

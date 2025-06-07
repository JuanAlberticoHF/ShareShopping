import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shareshopping/app/pages/operationPages/articulos_listas_page.dart';

import '../../core/services/listados_fb.dart';
import 'bottonsheet.dart';
import 'editar_nombre_dialog.dart';

class ElementosListas extends StatelessWidget {
  final String id; // Identificador
  final String nombre; // Título
  final double progreso; // Progreso
  final String itemsText; // Elementos "X/Y"// Callback para eliminar el elemento
  final VoidCallback? onDelete;

  ElementosListas({
    super.key,
    required this.id,
    required this.nombre,
    required this.progreso,
    required this.itemsText,
    this.onDelete,
  });

  FireStoreService fireStoreService = FireStoreService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticulosListasPage(
                listaId: id,
                progress: progreso,
                nombreLista: nombre,
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
          key: ValueKey(id), // Clave única para el Slidable
          endActionPane: ActionPane( // Deslizar hacia la izquierda para mostrar acciones
            motion: const ScrollMotion(), // Animación de deslizamiento
            dismissible: DismissiblePane(onDismissed: () {
              if (onDelete != null) {
                onDelete!(); // Llama al callback para eliminar el elemento
              }
            }),
            children: [ // Widgets de acciones (Slidable Actions)
              //-- Accion Editar
              SlidableAction(
                onPressed: (context) {
                  EditarNombreDialog.show(
                    context,
                    nombreInicial: nombre,
                    onSave: (nuevoNombre) {
                      fireStoreService.updateListadoName(id, nuevoNombre);
                    },
                  );
                },
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                icon: Icons.edit,
              ),
              //-- Accion Compartir
              SlidableAction(
                onPressed: (context) {},
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                icon: Icons.person_add,
              ),
              SlidableAction(
                //-- Accion Eliminar
                onPressed: (context) {},
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
                      nombre,
                      style: const TextStyle(fontSize: 24),
                    ),
                    //-- Botón de opciones
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return OpcionesListado(idLista: id, nombreLista: nombre,);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              Center(
                child: Text(
                  itemsText,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 13, right: 13),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progreso,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(colorBaseProgreso(progreso)),
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

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ShareShopping/app/pages/operationPages/articulos_listas_page.dart';
import 'package:ShareShopping/app/widgets/bottonsheet_listado_salir.dart';

import '../../core/services/listados_service_fb.dart';
import 'bottonsheet_visualizar_compartir.dart';

class ElementosListasCompartidas extends StatelessWidget {
  final String id; // Identificador
  final String nombre; // Título
  final double progreso; // Progreso
  final String itemsText; // Elementos "X/Y"// Callback para eliminar el elemento
  final VoidCallback? onLeave;

  ElementosListasCompartidas({
    super.key,
    required this.id,
    required this.nombre,
    required this.progreso,
    required this.itemsText,
    this.onLeave,
  });

  FireStoreServiceListados fireStoreService = FireStoreServiceListados();

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
              if (onLeave != null) {
                onLeave!(); // Llama al callback para eliminar el elemento
              }
            }),
            children: [ // Widgets de acciones (Slidable Actions)
              //-- Accion Editar
              SlidableAction(
                //-- Accion Eliminar
                onPressed: (context) {
                  if (onLeave != null) {
                    onLeave!(); // Llama al callback para eliminar el elemento
                  }
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.output,
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
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.group),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return OpcionesVisualizarCompartir(idLista: id, nombreLista: nombre,);
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return OpcionesListadoSalir(idLista: id, nombreLista: nombre,);
                              },
                            );
                          },
                        ),
                      ],
                    )
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

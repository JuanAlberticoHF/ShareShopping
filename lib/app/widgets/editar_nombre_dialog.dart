import 'dart:ui';
import 'package:flutter/material.dart';

/// Dialogo para editar el nombre de una lista
class EditarNombreDialog extends StatefulWidget {
  final String _nombreInicial; // Nombre inicial de la lista
  final void Function(String) _onSave; // Callback para guardar el nuevo nombre

  const EditarNombreDialog({
    super.key,
    required String nombreInicial,
    required void Function(String) onSave,
  }) : _onSave = onSave, _nombreInicial = nombreInicial;

  /// Invoca el dialogo de edición de nombre en la pantalla.
  static Future<void> show(BuildContext context, {
    required String nombreInicial,
    required void Function(String) onSave,
  }) {
    return showDialog(
      context: context,
      builder: (context) => EditarNombreDialog(
        nombreInicial: nombreInicial,
        onSave: onSave,
      ),
    );
  }

  @override
  State<EditarNombreDialog> createState() => _EditarNombreDialogState();
}

class _EditarNombreDialogState extends State<EditarNombreDialog> {
  final _formKey = GlobalKey<FormState>(); // Clave para el formulario
  late final TextEditingController _controller; // Controlador de texto para el campo de entrada
  final FocusNode _focusNode = FocusNode(); // Nodo de enfoque para el campo de entrada

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget._nombreInicial);
    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: const EdgeInsets.all(20.0),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Cambiar nombre de lista",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: 'Nombre de la lista',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'El nombre no puede estar vacio' : null,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget._onSave(_controller.text);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
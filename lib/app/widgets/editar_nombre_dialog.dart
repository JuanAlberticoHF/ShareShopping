import 'dart:ui';
import 'package:flutter/material.dart';

class EditarNombreDialog extends StatefulWidget {
  final String nombreInicial;
  final void Function(String) onSave;

  const EditarNombreDialog({
    super.key,
    required this.nombreInicial,
    required this.onSave,
  });

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
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.nombreInicial);
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
                    widget.onSave(_controller.text);
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
import 'package:flutter/material.dart';

class MyInputAlertBox extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final void Function()? onPressed;
  final String onPressedText;

  const MyInputAlertBox({
    super.key,
    required this.textController,
    required this.hintText,
    required this.onPressed,
    required this.onPressedText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: TextField(
        controller: textController,
        maxLength: 140, // Límite tipo Twitter antiguo
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(12),
          ),
          counterText: '', // Ocultar el contador visual pequeño
        ),
      ),
      actions: [
        // Botón Cancelar
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Cierra la alerta
            textController.clear(); // Limpia el texto
          },
          child: const Text("Cancelar"),
        ),

        // Botón Guardar / Publicar
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onPressed?.call();
            textController.clear();
          },
          child: Text(onPressedText),
        ),
      ],
    );
  }
}
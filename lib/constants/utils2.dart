
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void showSnackBar2(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          Icons.check_circle_outline,  // Un ícono amigable
          color: Colors.white,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,  // Color de texto
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.green,  // Color de fondo amigable
    behavior: SnackBarBehavior.floating,  // Para que flote sobre el contenido
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),  // Bordes redondeados
    ),
    duration: Duration(seconds: 3),  // Tiempo de duración en pantalla
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}


void showModalDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Éxito'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Aceptar'),
            onPressed: () {
              print('Modal cerrado');
              Navigator.of(context).pop();  // Cierra el diálogo
            },
          ),
        ],
      );
    },
  );
}


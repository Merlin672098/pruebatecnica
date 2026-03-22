
import 'package:flutter/material.dart';

void showSnackBar2(BuildContext context, String text) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          color: Colors.white,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10), 
    ),
    duration: Duration(seconds: 3), 
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
              Navigator.of(context).pop(); 
            },
          ),
        ],
      );
    },
  );
}


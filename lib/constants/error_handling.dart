import 'dart:convert';

//import 'package:amazon_clone_tutorial/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'utils2.dart';

void httpErrorHandle({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      // Solo llamar a onSuccess sin pasar el JSON completo
      onSuccess();
      break;
    case 400:
      // Extraer el mensaje de error del cuerpo JSON
      final errorMsg = jsonDecode(response.body)['msg'] ?? 'Error en la solicitud';
      showSnackBar2(context, errorMsg);
      break;
    case 500:
      // Extraer el mensaje de error del cuerpo JSON
      final errorMsg = jsonDecode(response.body)['error'] ?? 'Error interno del servidor';
      showSnackBar2(context, errorMsg);
      break;
    default:
      // Mensaje para cualquier otro código de estado
      showSnackBar2(context, ' ¡Reclamo creado exitosamente! ');
  }
}

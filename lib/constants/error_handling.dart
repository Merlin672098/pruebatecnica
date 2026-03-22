import 'dart:convert';

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
      onSuccess();
      break;
    case 400:
      final errorMsg = jsonDecode(response.body)['msg'] ?? 'Error en la solicitud';
      showSnackBar2(context, errorMsg);
      break;
    case 500:
      final errorMsg = jsonDecode(response.body)['error'] ?? 'Error interno del servidor';
      showSnackBar2(context, errorMsg);
      break;
    default:
      showSnackBar2(context, ' ¡Reclamo creado exitosamente! ');
  }
}

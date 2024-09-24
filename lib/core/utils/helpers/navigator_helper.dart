import 'package:flutter/material.dart';
import '../widgets/scale_route.dart'; // Asegúrate de que la ruta es correcta

void navigateTo(BuildContext context, Widget page) {
  Navigator.push(
    context,
    ScaleRoute(page: page),
  );
}

void replaceWith(BuildContext context, Widget page) {
  Navigator.pushReplacement(
    context,
    ScaleRoute(page: page),
  );
}

// Reemplazar y eliminar todas las pantallas anteriores (limpiar pila) con animación personalizada
void replaceAndRemoveUntil(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(
    context,
    ScaleRoute(page: page),
        (Route<dynamic> route) => false,
  );
}

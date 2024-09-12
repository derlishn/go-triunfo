import 'package:flutter/material.dart';
import 'scale_route.dart'; // Asegúrate de que la ruta es correcta

// Navegar a una nueva página con animación personalizada
void navigateTo(BuildContext context, Widget page) {
  Navigator.push(
    context,
    ScaleRoute(page: page),
  );
}

// Reemplazar la página actual por una nueva con animación personalizada
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
        (Route<dynamic> route) => false, // Esto limpia toda la pila de navegación
  );
}

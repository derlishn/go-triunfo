import 'package:flutter/material.dart';
import 'scale_route.dart'; // Asegúrate de que la ruta es correcta

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

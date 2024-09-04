import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_triunfo/core/resources/strings.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                AppStrings.orSignInWithText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(
              context,
              'assets/images/google_icon.svg',
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              context,
              'assets/images/facebook_icon.svg',
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              context,
              'assets/images/apple_icon.svg',
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black, // Cambia el color del icono según el tema
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(
    BuildContext context,
    String assetName, {
    Color? color,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withOpacity(0.3), // Color del borde
          width: 2,
        ),
      ),
      child: IconButton(
        icon: SvgPicture.asset(
          assetName,
          width: 40,
          height: 40,
          color: color, // Aplica el color al icono
        ),
        onPressed: () {
          // Acción para iniciar sesión con Google, Facebook, Apple
        },
      ),
    );
  }
}

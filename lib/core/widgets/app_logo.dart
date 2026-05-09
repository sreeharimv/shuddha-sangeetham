import 'package:flutter/material.dart';

/// Reusable logo widget — use [size] to scale it.
///
/// The logo is a square JPG with a saffron background, so [circular] clips
/// it to a circle for use in app bars and compact contexts.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 40, this.circular = true});

  final double size;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/images/ss_logo.jpg',
      width: size,
      height: size,
      fit: BoxFit.cover,
    );

    if (!circular) return image;

    return ClipOval(
      child: SizedBox(width: size, height: size, child: image),
    );
  }
}

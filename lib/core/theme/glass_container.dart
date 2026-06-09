import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              // Slightly more opaque in light mode so it doesn't wash out
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.65),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(1), // Stronger highlight on the top edge
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  // INCREASED opacity for light mode from 0.05 to 0.12
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.25),
                  blurRadius: 30,
                  // NEW: spreadRadius helps push the shadow out from under the card
                  spreadRadius: isDark ? 0 : 2,
                  offset: const Offset(0, 12),
                )
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

/// FOSHA brand palette (strict).
abstract final class FoshaColors {
  /// Primary (Pink) — actions/CTAs/active.
  static const Color primaryPink = Color(0xFFE8185D);

  /// Background (Purple) — headers/dark surfaces/main background.
  static const Color backgroundPurple = Color(0xFF2D1B5E);

  /// Highlights (Orange) — surge/warnings/SOS.
  static const Color highlightOrange = Color(0xFFF5A623);

  // Neutrals tuned for dark UI.
  static const Color surface = Color(0xFF23124B);
  static const Color surfaceAlt = Color(0xFF1B0E3D);
  static const Color onDark = Color(0xFFF7F3FF);
  static const Color onDarkMuted = Color(0xFFCABEE8);

  static const Color error = Color(0xFFFF4D4F);
  static const Color success = Color(0xFF22C55E);
}


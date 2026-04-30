import 'package:flutter/material.dart';

import '../../theme/fosha_colors.dart';

class FoshaBrandMark extends StatelessWidget {
  const FoshaBrandMark({super.key, this.size = 84});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: FoshaColors.primaryPink,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: FoshaColors.primaryPink.withValues(alpha: 0.35),
            blurRadius: 26,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: FoshaColors.highlightOrange.withValues(alpha: 0.18),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'فسحة',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}


import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fosha_shared/fosha_shared.dart';
import 'package:go_router/go_router.dart';

class DriverMatchingScreen extends StatefulWidget {
  const DriverMatchingScreen({super.key});

  @override
  State<DriverMatchingScreen> createState() => _DriverMatchingScreenState();
}

class _DriverMatchingScreenState extends State<DriverMatchingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat();

    // Demo: auto-advance to payment after a few seconds.
    Future<void>.delayed(const Duration(seconds: 5)).then((_) {
      if (!mounted) return;
      context.go('/payment');
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FoshaScaffold(
      appBar: AppBar(title: const Text('بنبحث عن سواق')),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Expanded(
            child: Center(
              child: AnimatedBuilder(
                animation: _c,
                builder: (context, _) {
                  return CustomPaint(
                    size: const Size(260, 260),
                    painter: _RadarPainter(progress: _c.value),
                    child: Center(
                      child: Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          color: FoshaColors.primaryPink,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: FoshaColors.primaryPink.withValues(alpha: 0.35),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.directions_car_rounded, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'بندور على سواق قريب منك…',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text('لو مفيش سواق هنقولك فوراً', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton(
              onPressed: () => context.go('/home'),
              child: const Text('إلغاء'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.shortestSide / 2;

    for (var i = 0; i < 3; i++) {
      final t = (progress + i / 3) % 1.0;
      final r = maxR * t;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Color.lerp(
              FoshaColors.primaryPink.withValues(alpha: 0.0),
              FoshaColors.primaryPink.withValues(alpha: 0.35),
              1 - t,
            ) ??
            FoshaColors.primaryPink.withValues(alpha: 0.2);
      canvas.drawCircle(center, r, paint);
    }

    final sweepPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = FoshaColors.highlightOrange.withValues(alpha: 0.25);
    final angle = progress * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: maxR),
      angle - 0.5,
      1.0,
      false,
      sweepPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) =>
      oldDelegate.progress != progress;
}


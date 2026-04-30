import 'package:flutter/material.dart';
import 'package:fosha_shared/fosha_shared.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              FoshaColors.backgroundPurple,
              Color(0xFF1A0F3A),
            ],
          ),
        ),
        child: const Center(
          child: ArabicIndicText('فسحة للسواقين'),
        ),
      ),
    );
  }
}


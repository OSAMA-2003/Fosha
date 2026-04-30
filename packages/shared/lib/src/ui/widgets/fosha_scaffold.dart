import 'package:flutter/material.dart';

import '../../theme/fosha_colors.dart';

class FoshaScaffold extends StatelessWidget {
  const FoshaScaffold({
    super.key,
    this.appBar,
    required this.child,
    this.bottom,
    this.padding = const EdgeInsets.all(16),
  });

  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? bottom;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
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
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: padding,
                  child: child,
                ),
              ),
              if (bottom != null) SafeArea(top: false, child: bottom!),
            ],
          ),
        ),
      ),
    );
  }
}


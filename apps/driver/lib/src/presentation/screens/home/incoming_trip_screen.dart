import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fosha_shared/fosha_shared.dart';

class IncomingTripScreen extends StatefulWidget {
  const IncomingTripScreen({super.key});

  @override
  State<IncomingTripScreen> createState() => _IncomingTripScreenState();
}

class _IncomingTripScreenState extends State<IncomingTripScreen> {
  int remaining = 30;
  Timer? t;

  @override
  void initState() {
    super.initState();
    t = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining <= 1) {
        t?.cancel();
        if (mounted) Navigator.of(context).maybePop();
        return;
      }
      setState(() => remaining -= 1);
    });
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FoshaScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          const Text('طلب رحلة جديد', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          FoshaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ArabicIndicText('المسافة لمكان الاستلام: ٢.١ كم'),
                const SizedBox(height: 6),
                ArabicIndicText('أرباحك المتوقعة (٨٠٪): ٣٢.٠٠ ج.م'),
                const SizedBox(height: 10),
                ArabicIndicText('الوقت المتبقي: $remaining ثانية'),
              ],
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('رفض'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 54,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('قبول ✓'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


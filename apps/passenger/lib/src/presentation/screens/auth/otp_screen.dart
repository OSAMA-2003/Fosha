import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fosha_shared/fosha_shared.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_providers.dart';

class OtpArgs {
  const OtpArgs({
    required this.verificationId,
    required this.resendToken,
    required this.phoneE164,
  });

  final String verificationId;
  final int? resendToken;
  final String phoneE164;
}

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.args});

  final OtpArgs args;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  static const _seconds = 60;

  int _remaining = _seconds;
  Timer? _timer;
  bool _verifying = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 1) {
        t.cancel();
        setState(() => _remaining = 0);
      } else {
        setState(() => _remaining -= 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final last4 = widget.args.phoneE164.length >= 4
        ? widget.args.phoneE164.substring(widget.args.phoneE164.length - 4)
        : widget.args.phoneE164;

    return FoshaScaffold(
      appBar: AppBar(title: const Text('أدخل الكود')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 6),
          Text(
            'بعتنالك كود على ****$last4',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          Center(
            child: FoshaCard(
              padding: const EdgeInsets.all(18),
              borderColor: FoshaColors.primaryPink.withValues(alpha: 0.18),
              child: Column(
                children: [
                  OtpInput(
                    enabled: !_verifying,
                    onCompleted: _verify,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 10),
                    Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: _remaining > 0
                ? ArabicIndicText('إعادة الإرسال بعد $_remaining ثانية')
                : TextButton(
                    onPressed: _verifying ? null : _resend,
                    child: const Text('أعد الإرسال'),
                  ),
          ),
          const Spacer(),
          SizedBox(
            height: 54,
            child: FilledButton(
              onPressed: _verifying ? null : () => context.go('/login'),
              child: const Text('تعديل الرقم'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verify(String code) async {
    setState(() {
      _verifying = true;
      _error = null;
    });

    try {
      final service = ref.read(phoneAuthServiceProvider);
      await service.verifyOtp(
        verificationId: widget.args.verificationId,
        smsCode: code,
      );
      if (!mounted) return;
      context.go('/home');
    } on PhoneAuthFailure catch (e) {
      setState(() => _error = e.messageAr);
    } catch (_) {
      setState(() => _error = 'حصل خطأ غير متوقع — حاول تاني');
    } finally {
      if (mounted) {
        setState(() => _verifying = false);
      }
    }
  }

  Future<void> _resend() async {
    setState(() {
      _verifying = true;
      _error = null;
    });
    try {
      final service = ref.read(phoneAuthServiceProvider);
      final session = await service.sendCode(
        phoneE164: widget.args.phoneE164,
        forceResendingToken: widget.args.resendToken,
      );
      if (!mounted) return;
      setState(() {
        _remaining = _seconds;
      });
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_remaining <= 1) {
          t.cancel();
          setState(() => _remaining = 0);
        } else {
          setState(() => _remaining -= 1);
        }
      });
      // Replace args by pushing to same route with new verificationId.
      context.go(
        '/otp',
        extra: OtpArgs(
          verificationId: session.verificationId,
          resendToken: session.resendToken,
          phoneE164: session.phoneE164,
        ),
      );
    } on PhoneAuthFailure catch (e) {
      setState(() => _error = e.messageAr);
    } finally {
      if (mounted) {
        setState(() => _verifying = false);
      }
    }
  }
}


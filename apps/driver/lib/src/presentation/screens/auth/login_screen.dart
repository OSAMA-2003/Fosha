import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_providers.dart';
import 'otp_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('دخول السواق')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            const Text('أهلاً بيك — سجّل رقمك وابدأ الشغل'),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixText: '+20 ',
                hintText: 'رقم الموبايل',
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 10),
              Text(_error!, style: const TextStyle(color: Colors.redAccent)),
            ],
            const Spacer(),
            FilledButton(
              onPressed: _loading ? null : _send,
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('إرسال الكود'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final digits = _controller.text.trim().replaceAll(RegExp(r'\\D'), '');
      if (digits.length < 10) throw Exception();
      final phone = '+20$digits';

      final service = ref.read(phoneAuthServiceProvider);
      final session = await service.sendCode(phoneE164: phone);

      if (!mounted) return;
      context.go(
        '/otp',
        extra: OtpArgs(
          verificationId: session.verificationId,
          resendToken: session.resendToken,
          phoneE164: session.phoneE164,
        ),
      );
    } catch (_) {
      setState(() => _error = 'مفيش إنترنت — تأكد من اتصالك');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}


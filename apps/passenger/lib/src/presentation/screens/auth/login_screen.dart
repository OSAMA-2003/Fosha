import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fosha_shared/fosha_shared.dart';
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
    return FoshaScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Center(child: FoshaBrandMark(size: 86)),
          const SizedBox(height: 18),
          const Text(
            'أهلاً بيك في فسحة 👋',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'اكتب رقمك وهنبعتلك كود تأكيد',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          FoshaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('رقم الموبايل', style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    prefixText: '+20 ',
                    hintText: '١٠xxxxxxxx',
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!, style: const TextStyle(color: Colors.redAccent)),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  height: 54,
                  child: FilledButton(
                    onPressed: _loading ? null : _send,
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('إرسال الكود'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final raw = _controller.text.trim();
      final digits = raw.replaceAll(RegExp(r'\\D'), '');
      if (digits.length < 10) {
        throw Exception('اكتب رقم صحيح');
      }

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
    } catch (e) {
      setState(() => _error = 'مفيش إنترنت — تأكد من اتصالك');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }
}


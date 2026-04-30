import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

sealed class PhoneAuthFailure implements Exception {
  const PhoneAuthFailure(this.messageAr);
  final String messageAr;
}

class PhoneAuthNetworkFailure extends PhoneAuthFailure {
  const PhoneAuthNetworkFailure() : super('مفيش إنترنت — تأكد من اتصالك');
}

class PhoneAuthWrongCodeFailure extends PhoneAuthFailure {
  const PhoneAuthWrongCodeFailure() : super('الكود غلط — حاول تاني');
}

class PhoneAuthExpiredFailure extends PhoneAuthFailure {
  const PhoneAuthExpiredFailure() : super('انتهت صلاحية الكود — اطلب كود جديد');
}

class PhoneAuthTooManyAttemptsFailure extends PhoneAuthFailure {
  const PhoneAuthTooManyAttemptsFailure()
      : super('كتير أوي — استنى شوية وحاول تاني');
}

class PhoneAuthUnknownFailure extends PhoneAuthFailure {
  const PhoneAuthUnknownFailure(super.messageAr);
}

class PhoneAuthSession {
  const PhoneAuthSession({
    required this.verificationId,
    required this.resendToken,
    required this.phoneE164,
  });

  final String verificationId;
  final int? resendToken;
  final String phoneE164;
}

class PhoneAuthService {
  PhoneAuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Future<PhoneAuthSession> sendCode({
    required String phoneE164,
    int? forceResendingToken,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final completer = Completer<PhoneAuthSession>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneE164,
      timeout: timeout,
      forceResendingToken: forceResendingToken,
      verificationCompleted: (credential) async {
        // Auto-verification can happen on Android. We intentionally do not
        // sign in automatically here, because UX typically still shows OTP UI.
      },
      verificationFailed: (e) {
        if (completer.isCompleted) return;
        completer.completeError(_mapFailure(e));
      },
      codeSent: (verificationId, resendToken) {
        if (completer.isCompleted) return;
        completer.complete(
          PhoneAuthSession(
            verificationId: verificationId,
            resendToken: resendToken,
            phoneE164: phoneE164,
          ),
        );
      },
      codeAutoRetrievalTimeout: (_) {},
    );

    return completer.future;
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _mapFailure(e);
    } catch (e) {
      throw PhoneAuthUnknownFailure('حصل خطأ غير متوقع — حاول تاني');
    }
  }

  PhoneAuthFailure _mapFailure(FirebaseAuthException e) {
    final code = e.code;
    return switch (code) {
      'network-request-failed' => const PhoneAuthNetworkFailure(),
      'invalid-verification-code' => const PhoneAuthWrongCodeFailure(),
      'session-expired' => const PhoneAuthExpiredFailure(),
      'too-many-requests' => const PhoneAuthTooManyAttemptsFailure(),
      _ => PhoneAuthUnknownFailure('تعذر إكمال العملية — حاول تاني'),
    };
  }
}


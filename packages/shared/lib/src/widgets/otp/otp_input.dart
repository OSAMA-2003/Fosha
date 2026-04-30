import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/fosha_colors.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    required this.onCompleted,
    this.length = 6,
    this.autoFocus = true,
    this.enabled = true,
  });

  final int length;
  final bool autoFocus;
  final bool enabled;
  final ValueChanged<String> onCompleted;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  final List<String> _digits = [];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _digits.addAll(List.filled(widget.length, ''));

    if (widget.autoFocus) {
      scheduleMicrotask(() {
        if (!mounted) return;
        _focusNodes.first.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(widget.length, (i) {
          return Padding(
            padding: EdgeInsets.only(right: i == widget.length - 1 ? 0 : 10),
            child: _OtpBox(
              controller: _controllers[i],
              focusNode: _focusNodes[i],
              enabled: widget.enabled,
              onChanged: (v) => _onChanged(i, v),
              onKey: (key) => _onKey(i, key),
            ),
          );
        }),
      ),
    );
  }

  void _onChanged(int index, String value) {
    if (!widget.enabled) return;

    final sanitized = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Paste support: if user pastes 6 digits, distribute.
    if (sanitized.length > 1) {
      final chars = sanitized.split('');
      for (var i = 0; i < widget.length; i++) {
        final digit = i < chars.length ? chars[i] : '';
        _digits[i] = digit;
        _controllers[i].text = digit;
      }
      _controllers.last.selection =
          TextSelection.collapsed(offset: _controllers.last.text.length);
      _focusNodes.last.requestFocus();
      _maybeComplete();
      return;
    }

    final digit = sanitized.isEmpty ? '' : sanitized;
    _digits[index] = digit;

    if (digit.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    _maybeComplete();
  }

  void _onKey(int index, LogicalKeyboardKey key) {
    if (!widget.enabled) return;
    if (key != LogicalKeyboardKey.backspace) return;

    if (_controllers[index].text.isNotEmpty) {
      _controllers[index].clear();
      _digits[index] = '';
      return;
    }

    if (index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      _digits[index - 1] = '';
    }
  }

  void _maybeComplete() {
    final code = _digits.join();
    if (code.length == widget.length && !_digits.contains('')) {
      widget.onCompleted(code);
    }
  }
}

class _OtpBox extends StatefulWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.onChanged,
    required this.onKey,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final ValueChanged<LogicalKeyboardKey> onKey;

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: (event) {
          if (event is KeyDownEvent) {
            widget.onKey(event.logicalKey);
          }
        },
        child: TextField(
          enabled: widget.enabled,
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          maxLength: 1,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: const Color(0xFF1B0E3D),
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: FoshaColors.primaryPink,
                width: 2,
              ),
            ),
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}


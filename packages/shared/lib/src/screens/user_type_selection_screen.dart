import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/fosha_colors.dart';

enum FoshaUserType { passenger, driver }

extension on FoshaUserType {
  String get storageValue => switch (this) {
        FoshaUserType.passenger => 'passenger',
        FoshaUserType.driver => 'driver',
      };

  String get arLabel => switch (this) {
        FoshaUserType.passenger => 'راكب',
        FoshaUserType.driver => 'سائق',
      };

  String get arSubtitle => switch (this) {
        FoshaUserType.passenger => 'أريد التنقل',
        FoshaUserType.driver => 'أريد العمل',
      };

  IconData get icon => switch (this) {
        FoshaUserType.passenger => Icons.person_pin_circle_rounded,
        FoshaUserType.driver => Icons.directions_car_filled_rounded,
      };
}

class UserTypeSelectionScreen extends StatefulWidget {
  const UserTypeSelectionScreen({
    super.key,
    this.onContinue,
    this.persistSelection = true,
    this.tryRestoreSelection = true,
  });

  /// Called when user presses continue with a selected type.
  final Future<void> Function(FoshaUserType type)? onContinue;

  /// Store selection in `shared_preferences` under `fosha_user_role`.
  final bool persistSelection;

  /// Restore last selection (if any) from `shared_preferences`.
  final bool tryRestoreSelection;

  static const prefsKey = 'fosha_user_role';

  @override
  State<UserTypeSelectionScreen> createState() => _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  FoshaUserType? selectedType;
  bool restoring = false;

  @override
  void initState() {
    super.initState();
    if (widget.tryRestoreSelection) {
      _restore();
    }
  }

  Future<void> _restore() async {
    setState(() => restoring = true);
    bool shouldStop = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(UserTypeSelectionScreen.prefsKey);
      final restored = switch (value) {
        'passenger' => FoshaUserType.passenger,
        'driver' => FoshaUserType.driver,
        _ => null,
      };
      if (!mounted) {
        shouldStop = true;
      } else {
        setState(() => selectedType = restored);
      }
    } finally {
      if (!shouldStop && mounted) {
        setState(() => restoring = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: FoshaColors.backgroundPurple,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: restoring
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const SizedBox(height: 36),
                    Center(
                      child: _BrandMark(
                        textStyle: theme.textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'أهلاً بك في فسحة',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'اختر نوع الحساب للمتابعة',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth;
                          final cardWidth = (width - 12) / 2;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _UserCard(
                                width: cardWidth,
                                type: FoshaUserType.passenger,
                                isSelected: selectedType == FoshaUserType.passenger,
                                onTap: () => _select(FoshaUserType.passenger),
                              ),
                              const SizedBox(width: 12),
                              _UserCard(
                                width: cardWidth,
                                type: FoshaUserType.driver,
                                isSelected: selectedType == FoshaUserType.driver,
                                onTap: () => _select(FoshaUserType.driver),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 28,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: FilledButton(
                          onPressed: selectedType == null ? null : _continue,
                          child: Text(
                            selectedType == null
                                ? 'اختر نوع الحساب'
                                : 'دخول كـ ${selectedType!.arLabel}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _select(FoshaUserType type) {
    setState(() => selectedType = type);
  }

  Future<void> _continue() async {
    final type = selectedType;
    if (type == null) return;

    if (widget.persistSelection) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(UserTypeSelectionScreen.prefsKey, type.storageValue);
    }

    if (!mounted) return;

    final cb = widget.onContinue;
    if (cb != null) {
      await cb(type);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم اختيار: ${type.arLabel}'),
        backgroundColor: FoshaColors.surface,
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({this.textStyle});

  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
      decoration: BoxDecoration(
        color: FoshaColors.primaryPink,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: FoshaColors.primaryPink.withValues(alpha: 0.35),
            blurRadius: 26,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text('فسحة', style: textStyle),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.width,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final double width;
  final FoshaUserType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = FoshaColors.primaryPink;

    return Semantics(
      button: true,
      selected: isSelected,
      label: type.arLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOutCubic,
          width: width,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: FoshaColors.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: isSelected ? accent : Colors.transparent,
              width: 3,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.22),
                      blurRadius: 22,
                      spreadRadius: 2,
                    ),
                  ]
                : const [],
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutBack,
            scale: isSelected ? 1.02 : 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? accent.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    type.icon,
                    size: 44,
                    color: isSelected ? accent : Colors.white70,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  type.arLabel,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  type.arSubtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white60,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


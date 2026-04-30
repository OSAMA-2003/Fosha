import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fosha_shared/fosha_shared.dart';

import '../../providers/city_provider.dart';

class CitySelectionScreen extends ConsumerWidget {
  const CitySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCityProvider);

    return FoshaScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          const Center(child: FoshaBrandMark(size: 78)),
          const SizedBox(height: 18),
          const Text(
            'اختار مدينتك',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'الخدمة داخل المدينة بس',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 22),
          _CityCard(
            title: 'أسيوط',
            subtitle: 'مراكز وأسواق ومشاوير سريعة',
            icon: Icons.location_city_rounded,
            selected: selected == FoshaCity.asyut,
            onTap: () => ref.read(selectedCityProvider.notifier).setCity(
                  FoshaCity.asyut,
                ),
          ),
          const SizedBox(height: 12),
          _CityCard(
            title: 'سوهاج',
            subtitle: 'تنقل داخل المدينة بسهولة',
            icon: Icons.location_city_rounded,
            selected: selected == FoshaCity.sohag,
            onTap: () => ref.read(selectedCityProvider.notifier).setCity(
                  FoshaCity.sohag,
                ),
          ),
          const SizedBox(height: 12),
          _CityCard(
            title: 'قنا',
            subtitle: 'رحلات داخلية فقط',
            icon: Icons.location_city_rounded,
            selected: selected == FoshaCity.qena,
            onTap: () => ref.read(selectedCityProvider.notifier).setCity(
                  FoshaCity.qena,
                ),
          ),
          const Spacer(),
          SizedBox(
            height: 54,
            child: FilledButton(
              onPressed: selected == null ? null : () {},
              child: const Text('كمّل'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  const _CityCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: FoshaColors.surface.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? FoshaColors.primaryPink : Colors.transparent,
            width: 2.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: FoshaColors.highlightOrange),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: Colors.white60)),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: FoshaColors.primaryPink),
          ],
        ),
      ),
    );
  }
}


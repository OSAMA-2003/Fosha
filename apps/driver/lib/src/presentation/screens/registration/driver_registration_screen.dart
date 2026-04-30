import 'package:flutter/material.dart';
import 'package:fosha_shared/fosha_shared.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() => _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final name = TextEditingController();
  final carModel = TextEditingController();
  final plate = TextEditingController();
  String city = 'asyut';

  @override
  void dispose() {
    name.dispose();
    carModel.dispose();
    plate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FoshaScaffold(
      appBar: AppBar(title: const Text('تسجيل السواق')),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('كمّل بياناتك عشان الإدارة تراجعها', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          FoshaCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(controller: name, decoration: const InputDecoration(hintText: 'الاسم')),
                const SizedBox(height: 10),
                InputDecorator(
                  decoration: const InputDecoration(labelText: 'المدينة'),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: city,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'asyut', child: Text('أسيوط')),
                        DropdownMenuItem(value: 'sohag', child: Text('سوهاج')),
                        DropdownMenuItem(value: 'qena', child: Text('قنا')),
                      ],
                      onChanged: (v) => setState(() => city = v ?? 'asyut'),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: carModel,
                  decoration: const InputDecoration(hintText: 'موديل العربية'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: plate,
                  decoration: const InputDecoration(hintText: 'رقم اللوحة'),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 54,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('رفع المستندات (قريباً)'),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 54,
            child: FilledButton(
              onPressed: () {},
              child: const Text('إرسال للمراجعة'),
            ),
          ),
        ],
      ),
    );
  }
}


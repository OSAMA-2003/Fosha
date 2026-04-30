import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fosha_shared/fosha_shared.dart';

class SosPanelScreen extends StatelessWidget {
  const SosPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sosStream = FirebaseFirestore.instance
        .collection('sos')
        .orderBy('createdAtMillis', descending: true)
        .limit(50)
        .snapshots();

    return FoshaScaffold(
      appBar: AppBar(title: const Text('لوحة SOS')),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: sosStream,
        builder: (context, snap) {
          final docs = snap.data?.docs ?? const [];
          if (docs.isEmpty) {
            return const Center(child: Text('مفيش بلاغات حالياً'));
          }
          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final d = docs[i];
              final data = d.data();
              final status = data['status']?.toString() ?? 'open';
              final tripId = data['tripId']?.toString() ?? d.id;
              return FoshaCard(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: FoshaColors.highlightOrange.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.warning_rounded,
                          color: FoshaColors.highlightOrange),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'بلاغ SOS',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Trip: $tripId',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _StatusChip(status: status),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'resolved' => ('تم الحل', Colors.greenAccent),
      'ack' => ('تم الاستلام', FoshaColors.primaryPink),
      _ => ('مفتوح', FoshaColors.highlightOrange),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w900)),
    );
  }
}


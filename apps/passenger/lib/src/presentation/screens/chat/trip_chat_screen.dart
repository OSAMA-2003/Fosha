import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fosha_shared/fosha_shared.dart';

class TripChatScreen extends StatefulWidget {
  const TripChatScreen({super.key, required this.tripId});

  final String tripId;

  @override
  State<TripChatScreen> createState() => _TripChatScreenState();
}

class _TripChatScreenState extends State<TripChatScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final messagesRef = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.tripId)
        .collection('messages')
        .orderBy('sentAtMillis', descending: true)
        .limit(50);

    return Scaffold(
      appBar: AppBar(title: const Text('محادثة الرحلة')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: messagesRef.snapshots(),
              builder: (context, snap) {
                final docs = snap.data?.docs ?? const [];
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i];
                    final msg = ChatMessage.fromJson(
                      id: d.id,
                      json: d.data().cast<String, Object?>(),
                    );
                    final mine = uid != null && msg.senderId == uid;
                    return Align(
                      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.all(12),
                        constraints: const BoxConstraints(maxWidth: 320),
                        decoration: BoxDecoration(
                          color: mine
                              ? FoshaColors.primaryPink.withValues(alpha: 0.25)
                              : FoshaColors.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(msg.text),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'اكتب رسالة…'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: _send,
                    child: const Text('إرسال'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final ref = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.tripId)
        .collection('messages')
        .doc();

    final msg = ChatMessage(
      id: ref.id,
      tripId: widget.tripId,
      senderId: uid,
      text: text,
      sentAtMillis: DateTime.now().millisecondsSinceEpoch,
    );
    await ref.set(msg.toJson());
    _controller.clear();
  }
}


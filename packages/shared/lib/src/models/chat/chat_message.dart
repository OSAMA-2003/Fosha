class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.tripId,
    required this.senderId,
    required this.text,
    required this.sentAtMillis,
    this.readAtMillis,
  });

  final String id;
  final String tripId;
  final String senderId;
  final String text;
  final int sentAtMillis;
  final int? readAtMillis;

  Map<String, Object?> toJson() => {
        'tripId': tripId,
        'senderId': senderId,
        'text': text,
        'sentAtMillis': sentAtMillis,
        'readAtMillis': readAtMillis,
      };

  static ChatMessage fromJson({
    required String id,
    required Map<String, Object?> json,
  }) {
    return ChatMessage(
      id: id,
      tripId: (json['tripId'] as String?) ?? '',
      senderId: (json['senderId'] as String?) ?? '',
      text: (json['text'] as String?) ?? '',
      sentAtMillis: (json['sentAtMillis'] as num?)?.toInt() ?? 0,
      readAtMillis: (json['readAtMillis'] as num?)?.toInt(),
    );
  }
}


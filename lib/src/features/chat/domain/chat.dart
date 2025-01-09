class Chat {
  final String id;
  final String text;
  final DateTime createdAt;
  final String senderId;

  Chat({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.senderId,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'],
        text: json['text'],
        createdAt: DateTime.parse(json['createdAt']),
        senderId: json['senderId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
        'senderId': senderId,
      };
}

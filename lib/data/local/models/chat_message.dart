class ChatMessage {
  final int? id;
  final String text;
  final String? imagePath;
  final int isSender;
  final String timestamp;

  ChatMessage({
    this.id,
    required this.text,
    this.imagePath,
    required this.isSender,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'imagePath': imagePath,
      'isSender': isSender,
      'timestamp': timestamp,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      text: map['text'],
      imagePath: map['imagePath'],
      isSender: map['isSender'],
      timestamp: map['timestamp'],
    );
  }
}
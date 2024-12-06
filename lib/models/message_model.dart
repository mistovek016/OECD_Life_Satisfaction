class MessageModel {
  String messageId;
  String chatId;
  Role role;
  StringBuffer message;
  List<String> imageLinks;
  DateTime timeStamp;

  MessageModel({
    required this.messageId,
    required this.chatId,
    required this.role,
    required this.message,
    required this.imageLinks,
    required this.timeStamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'role': role.index,
      'message': message.toString(),
      'imageLinks': imageLinks,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'],
      chatId: map['chatId'],
      role: Role.values[map['role']],
      message: StringBuffer(map['message']),
      imageLinks: List<String>.from(map['imageLinks']),
      timeStamp: DateTime.parse(map['timeStamp']),
    );
  }

  MessageModel copyWith({
    String? messageId,
    String? chatId,
    Role? role,
    StringBuffer? message,
    List<String>? imageLinks,
    DateTime? timeStamp,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      role: role ?? role!,
      message: message ?? message!,
      imageLinks: imageLinks ?? this.imageLinks,
      timeStamp: timeStamp ?? timeStamp!,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageModel && other.messageId == messageId;
  }

  @override
  int get hashCode => messageId.hashCode;
}

enum Role {
  user,
  chatbot,
}

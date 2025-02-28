abstract class MessageEntity {
  final String id;
  final Sender sender;
  final String content;
  final Chat chat;
  final DateTime createdAt;
  final DateTime updatedAt;

  MessageEntity({
    required this.id,
    required this.sender,
    required this.content,
    required this.chat,
    required this.createdAt,
    required this.updatedAt,
  });
}

class Sender {
  final String id;
  final String name;
  final String email;
  final String? image;

  Sender({
    required this.id,
    required this.name,
    required this.email,
    this.image,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'], // remains nullable
    );
  }
}

class Chat {
  final String id;
  final String chatName;
  final bool isGroupChat;
  final List<String> users;
  final String latestMessage;

  Chat({
    required this.id,
    required this.chatName,
    required this.isGroupChat,
    required this.users,
    required this.latestMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'] ?? '',
      chatName: json['chatName'] ?? '',
      isGroupChat: json['isGroupChat'] ?? false,
      users: List<String>.from(json['users'] ?? []),
      latestMessage: json['latestMessage'] ?? '',
    );
  }
}

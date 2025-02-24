abstract class AccessChatEntity {
  String id;
  String chatName;
  bool isGroupChat;

  AccessChatEntity(
      {required this.id, required this.chatName, required this.isGroupChat});
}

import 'package:amazetalk_flutter/features/conversation/domain/entities/message_entity.dart';

import '../entities/chats_entity.dart';

abstract class ChatsRepository {
  Future<List<ChatsEntity>> fetchChats();
  Future<List<MessageEntity>> fetchMessage(String chatId);
  // Future<MessagesEntity> fetchMessages(String conversationId);
  // Future<bool> sendMessage(SendMessageEntity message);
}

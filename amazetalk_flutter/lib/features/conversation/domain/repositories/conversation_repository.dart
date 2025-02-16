import 'package:amazetalk_flutter/features/conversation/domain/entities/conversation_entity.dart';
import 'package:amazetalk_flutter/features/conversation/domain/entities/messages_entity.dart';

abstract class ConversationRepository {
  Future<ConversationEntity> fetchConversations();
  Future<MessagesEntity> fetchMessages(String conversationId);
}

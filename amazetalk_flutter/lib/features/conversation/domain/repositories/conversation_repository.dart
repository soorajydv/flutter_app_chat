import 'package:amazetalk_flutter/features/conversation/domain/entities/conversation_entity.dart';

abstract class ConversationRepository {
  Future<ConversationEntity> fetchConversations();
}

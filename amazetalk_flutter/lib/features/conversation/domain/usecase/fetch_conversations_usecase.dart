import 'package:amazetalk_flutter/features/conversation/domain/entities/conversation_entity.dart';
import 'package:amazetalk_flutter/features/conversation/domain/entities/messages_entity.dart';
import 'package:amazetalk_flutter/features/conversation/domain/repositories/conversation_repository.dart';

class FetchConversationsUsecase {
  final ConversationRepository repository;

  FetchConversationsUsecase(this.repository);

  Future<ConversationEntity> call() async {
    return repository.fetchConversations();
  }
}

class FetchMessagesUsecase {
  final ConversationRepository repository;

  FetchMessagesUsecase(this.repository);

  Future<MessagesEntity> call(String conversationId) async {
    return repository.fetchMessages(conversationId);
  }
}

class SendMessageUseCase {
  final ConversationRepository repository;
  SendMessageUseCase(this.repository);

  Future<bool> call(SendMessageEntity message) async {
    return repository.sendMessage(message);
  }
}

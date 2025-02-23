import 'package:amazetalk_flutter/features/conversation/domain/entities/message_entity.dart';

import '../entities/chats_entity.dart';
import '../repositories/chats_remote_repository.dart';

class ChatsUsecase {
  final ChatsRepository repository;

  ChatsUsecase(this.repository);

  Future<List<ChatsEntity>> call() async {
    return repository.fetchChats();
  }
}

class MessagesUsecase {
  final ChatsRepository repository;

  MessagesUsecase(this.repository);

  Future<List<MessageEntity>> call(String chatId) async {
    return repository.fetchMessage(chatId);
  }
}

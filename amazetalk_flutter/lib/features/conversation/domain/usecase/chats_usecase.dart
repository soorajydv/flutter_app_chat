import 'package:amazetalk_flutter/features/conversation/domain/entities/access_chat.dart';
import 'package:amazetalk_flutter/features/conversation/domain/entities/group_info.dart';
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

class AccessChatUsecase {
  final ChatsRepository repository;

  AccessChatUsecase(this.repository);

  Future<AccessChatEntity> call(String userId) async {
    return repository.accessChat(userId);
  }
}

class GroupInfoUsecase {
  final ChatsRepository repository;

  GroupInfoUsecase(this.repository);

  Future<GroupInfoEntity> call(String groupId) async {
    return repository.groupInfo(groupId);
  }
}

class AddMemberToGroupUsecase {
  final ChatsRepository repository;

  AddMemberToGroupUsecase(this.repository);

  Future<bool> call(String groupId, String userId) async {
    return repository.addMemberToGroup(groupId, userId);
  }
}

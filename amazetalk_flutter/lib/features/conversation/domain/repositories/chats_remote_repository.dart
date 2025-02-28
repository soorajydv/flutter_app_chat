import 'package:amazetalk_flutter/features/conversation/domain/entities/access_chat.dart';
import 'package:amazetalk_flutter/features/conversation/domain/entities/group_info.dart';
import 'package:amazetalk_flutter/features/conversation/domain/entities/message_entity.dart';

import '../entities/chats_entity.dart';

abstract class ChatsRepository {
  Future<List<ChatsEntity>> fetchChats();
  Future<List<MessageEntity>> fetchMessage(String chatId);
  Future<AccessChatEntity> accessChat(String userId);
  Future<GroupInfoEntity> groupInfo(String groupId);
  Future<bool> addMemberToGroup(String groupId, String userId);
  // Future<MessagesEntity> fetchMessages(String conversationId);
  // Future<bool> sendMessage(SendMessageEntity message);
}

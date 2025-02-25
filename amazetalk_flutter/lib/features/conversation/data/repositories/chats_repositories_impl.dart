import 'package:amazetalk_flutter/features/conversation/data/models/group_info.dart';
import 'package:amazetalk_flutter/features/conversation/domain/entities/access_chat.dart';
import 'package:amazetalk_flutter/features/conversation/domain/entities/message_entity.dart';

import '../../domain/repositories/chats_remote_repository.dart';
import '../datasource/chats_remote_data_source.dart';
import '../models/chats_model.dart';

class ChatsRepositoriesImpl implements ChatsRepository {
  final ChatsRemoteDataSource remoteDataSource;
  ChatsRepositoriesImpl({required this.remoteDataSource});
  @override
  Future<List<ChatsModel>> fetchChats() => remoteDataSource.fetchChats();

  @override
  Future<List<MessageEntity>> fetchMessage(String chatId) =>
      remoteDataSource.fetchMessages(chatId);

  @override
  Future<AccessChatEntity> accessChat(String userId) =>
      remoteDataSource.accessChat(userId);

  @override
  Future<GroupInfo> groupInfo(String groupId) =>
      remoteDataSource.groupInfo(groupId);

  @override
  Future<bool> addMemberToGroup(String groupId, String userId) =>
      remoteDataSource.addMemberToGroup(groupId, userId);
}

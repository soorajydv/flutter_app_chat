import 'package:amazetalk_flutter/features/conversation/data/datasource/conversation_remote_data_source.dart';
import 'package:amazetalk_flutter/features/conversation/domain/entities/conversation_entity.dart';
import 'package:amazetalk_flutter/features/conversation/domain/repositories/conversation_repository.dart';

class ConversationsRepositoriesImpl implements ConversationRepository {
  final ConversationRemoteDataSource remoteDataSource;
  ConversationsRepositoriesImpl({required this.remoteDataSource});
  @override
  Future<List<ConversationEntity>> fetchConversations() async {
    return await remoteDataSource.fetchConversations();
  }
}

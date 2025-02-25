part of 'chats_bloc.dart';

sealed class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object> get props => [];
}

final class ChatsInitial extends ChatsState {}

final class ChatsLoading extends ChatsState {}

final class ChatsFetched extends ChatsState {
  final List<ChatsEntity> chats;
  final String uid;
  const ChatsFetched(this.chats, this.uid);
}

final class ChatsFailure extends ChatsState {
  final String message;
  const ChatsFailure([this.message = 'Failed to fetch chats']);
}

final class AccessChatFetched extends ChatsState {
  final AccessChatEntity chat;
  const AccessChatFetched(this.chat);
}

final class GroupInfoLoading extends ChatsState {
  const GroupInfoLoading();
}

final class GroupInfoFetched extends ChatsState {
  final GroupInfoEntity info;
  final String uid;
  const GroupInfoFetched(this.info, this.uid);
}

final class MemberAddedToGroup extends ChatsState {}

final class MemberAddedToGroupFailed extends ChatsState {}

part of 'chats_bloc.dart';

sealed class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object> get props => [];
}

final class FetchChats extends ChatsEvent {}

final class AccessChat extends ChatsEvent {
  final String userId;

  const AccessChat(this.userId);
}

final class GroupInfo extends ChatsEvent {
  final String groupId;

  const GroupInfo(this.groupId);
}

final class AddMemberToGroup extends ChatsEvent {
  final String userId;
  final String groupId;

  const AddMemberToGroup(this.userId, this.groupId);
}

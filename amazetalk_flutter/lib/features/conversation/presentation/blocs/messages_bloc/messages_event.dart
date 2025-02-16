part of 'messages_bloc.dart';

sealed class MessagesEvent extends Equatable {
  const MessagesEvent();

  @override
  List<Object> get props => [];
}

class FetchMessages extends MessagesEvent {
  final String conversationId;

  FetchMessages(this.conversationId);
}

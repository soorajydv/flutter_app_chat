part of 'messages_bloc.dart';

sealed class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object> get props => [];
}

final class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  final List<MessageEntity> messages;
  final String uid;
  const MessagesLoaded(this.messages, this.uid);
  @override
  List<Object> get props => [messages];
}

class MessagesError extends MessagesState {
  final String message;
  const MessagesError(this.message);
}

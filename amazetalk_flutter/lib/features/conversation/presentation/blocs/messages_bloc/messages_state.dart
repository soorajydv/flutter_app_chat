part of 'messages_bloc.dart';

sealed class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object> get props => [];
}

final class MessagesInitial extends MessagesState {}

class MessagesLoading extends MessagesState {}

class MessagesLoaded extends MessagesState {
  final MessagesEntity conversation;
  const MessagesLoaded(this.conversation);
  @override
  List<Object> get props => [conversation];
}

class MessagesError extends MessagesState {
  final String message;
  const MessagesError(this.message);
}

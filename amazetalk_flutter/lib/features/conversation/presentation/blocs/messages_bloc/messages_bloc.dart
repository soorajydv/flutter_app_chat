import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/messages_entity.dart';
import '../../../domain/usecase/fetch_conversations_usecase.dart';

part 'messages_event.dart';
part 'messages_state.dart';

class MessagesBloc extends Bloc<MessagesEvent, MessagesState> {
  final FetchMessagesUsecase fetchMessagesUsecase;
  MessagesBloc(this.fetchMessagesUsecase) : super(MessagesInitial()) {
    on<FetchMessages>((event, emit) async {
      emit(MessagesLoading());
      try {
        final messages = await fetchMessagesUsecase(event.conversationId);
        emit(MessagesLoaded(messages));
      } catch (error) {
        emit(MessagesError("Fail to load messages"));
      }
    });
  }
}

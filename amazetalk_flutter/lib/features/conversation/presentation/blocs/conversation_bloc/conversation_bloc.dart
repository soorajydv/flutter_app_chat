import 'package:amazetalk_flutter/features/conversation/domain/usecase/fetch_conversations_usecase.dart';
import 'package:amazetalk_flutter/features/conversation/presentation/blocs/conversation_bloc/conversation_event.dart';
import 'package:amazetalk_flutter/features/conversation/presentation/blocs/conversation_bloc/conversation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final FetchConversationsUsecase fetchConversationsUsecase;

  ConversationBloc({required this.fetchConversationsUsecase})
      : super(ConversationInitial()) {
    on<FetchConversations>(_onFetchConversations);
  }
  Future<void> _onFetchConversations(
      FetchConversations events, Emitter<ConversationState> emit) async {
    emit(ConversationsLoading());
    try {
      final conversation = await fetchConversationsUsecase();
      emit(ConversationsLoaded(conversation));
    } catch (error) {
      emit(ConversationsError("Fail to locad Conversation"));
    }
  }
}

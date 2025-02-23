import 'package:amazetalk_flutter/features/auth/domain/entities/user_entity.dart';
import 'package:amazetalk_flutter/features/conversation/data/models/chats_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/chats_entity.dart';
import '../../../domain/usecase/chats_usecase.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatsUsecase fetchChats;
  ChatsBloc(this.fetchChats) : super(ChatsInitial()) {
    on<FetchChats>((event, emit) async {
      // try {
      emit(ChatsLoading());

      final chats = await fetchChats();
      emit(ChatsFetched(chats));
      // } catch (e) {
      // emit(ChatsFailure(e.toString()));
      // }
    });
  }
}

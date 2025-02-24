import 'package:amazetalk_flutter/features/conversation/domain/entities/access_chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../auth/data/datasource/auth_local_data_source.dart';
import '../../../domain/entities/chats_entity.dart';
import '../../../domain/usecase/chats_usecase.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final ChatsUsecase fetchChats;
  final AccessChatUsecase accessChat;
  ChatsBloc(this.fetchChats, this.accessChat) : super(ChatsInitial()) {
    on<FetchChats>((event, emit) async {
      // try {
      emit(ChatsLoading());

      final chats = await fetchChats();
      final uid = await AuthLocalDataSource().getUserId();

      if (uid != null) {
        emit(ChatsFetched(chats, uid));
      }
      // } catch (e) {
      // emit(ChatsFailure(e.toString()));
      // }
    });

    on<AccessChat>((event, emit) async {
      final chats = await accessChat(event.userId);

      emit(AccessChatFetched(chats));
    });
  }
}

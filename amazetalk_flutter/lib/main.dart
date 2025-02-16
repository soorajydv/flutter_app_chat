import 'package:amazetalk_flutter/chat_page.dart';
import 'package:amazetalk_flutter/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:amazetalk_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:amazetalk_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:amazetalk_flutter/features/auth/domain/usecases/register_usecase.dart';
import 'package:amazetalk_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:amazetalk_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:amazetalk_flutter/features/auth/presentation/pages/register_page.dart';
import 'package:amazetalk_flutter/features/conversation/data/datasource/conversation_remote_data_source.dart';
import 'package:amazetalk_flutter/features/conversation/data/repositories/conversations_repositories_impl.dart';
import 'package:amazetalk_flutter/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:amazetalk_flutter/features/conversation/domain/usecase/fetch_conversations_usecase.dart';
import 'package:amazetalk_flutter/features/conversation/presentation/blocs/conversation_bloc/conversation_bloc.dart';
import 'package:amazetalk_flutter/features/conversation/presentation/blocs/messages_bloc/messages_bloc.dart';
import 'package:amazetalk_flutter/features/conversation/presentation/pages/conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure Flutter is initialized

  // ✅ Correctly initialize Auth Dependencies

  final authRepository =
      AuthRepositoryImpl(authRemoteDataSource: AuthRemoteDataSource());
  final conversationRepository = ConversationsRepositoriesImpl(
      remoteDataSource: ConversationRemoteDataSource());

  runApp(MyApp(
    authRepository: authRepository,
    conversationRepository: conversationRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final ConversationRepository conversationRepository;

  const MyApp(
      {super.key,
      required this.authRepository,
      required this.conversationRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthBloc(
                registerUsecase: RegisterUsecase(repository: authRepository),
                loginUsecase: LoginUsecase(repository: authRepository))),
        BlocProvider(
          create: (_) => ConversationBloc(
            fetchConversationsUsecase:
                FetchConversationsUsecase(conversationRepository),
          ),
        ),
        BlocProvider(
          create: (_) => MessagesBloc(
            FetchMessagesUsecase(conversationRepository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: RegisterPage(),
        routes: {
          "/login": (_) => LoginPage(),
          "/register": (_) => RegisterPage(),
          // "/chatPage": (_) => ChatPage(),
          "/conversationPage": (_) => ConversationPage()
        },
      ),
    );
  }
}

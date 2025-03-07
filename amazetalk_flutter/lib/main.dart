import 'package:amazetalk_flutter/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:amazetalk_flutter/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:amazetalk_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:amazetalk_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:amazetalk_flutter/features/auth/domain/usecases/register_usecase.dart';
import 'package:amazetalk_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:amazetalk_flutter/features/conversation/presentation/blocs/chats_bloc/chats_bloc.dart';
import 'package:amazetalk_flutter/features/conversation/presentation/blocs/messages_bloc/messages_bloc.dart';
import 'package:amazetalk_flutter/services/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_routes.dart';
import 'features/conversation/data/datasource/chats_remote_data_source.dart';
import 'features/conversation/data/repositories/chats_repositories_impl.dart';
import 'features/conversation/domain/usecase/chats_usecase.dart';

final navigatorKey = GlobalKey<NavigatorState>();
ValueNotifier<Brightness> appThemeMode = ValueNotifier(Brightness.light);

void main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure Flutter is initialized

  // ✅ Correctly initialize Auth Dependencies

  // WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboardingComplete = prefs.getBool('onboardingComplete') ?? false;

  runApp(MyApp(isOnboardingCompleted: onboardingComplete));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.isOnboardingCompleted});
  final bool isOnboardingCompleted;
  // void checkToken() async {
  @override
  Widget build(BuildContext context) {
    final httpClient = DioClient();
    final authCache = AuthLocalDataSource();

    final chatsRepository = ChatsRepositoriesImpl(
        remoteDataSource: ChatsRemoteDataSource(httpClient));

    final authRepository = AuthRepositoryImpl(
        authRemoteDataSource:
            AuthRemoteDataSource(AuthLocalDataSource(), httpClient));

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthBloc(authCache,
                registerUsecase: RegisterUsecase(repository: authRepository),
                loginUsecase: LoginUsecase(repository: authRepository))),
        // BlocProvider(
        //   create: (_) => ConversationBloc(
        //     fetchConversationsUsecase:
        //         FetchConversationsUsecase(conversationRepository),
        //   ),
        // ),
        BlocProvider(
          create: (_) => ChatsBloc(
              ChatsUsecase(chatsRepository),
              AccessChatUsecase(chatsRepository),
              GroupInfoUsecase(chatsRepository),
              AddMemberToGroupUsecase(chatsRepository)),
        ),
        BlocProvider(
          create: (_) =>
              MessagesBloc(MessagesUsecase(chatsRepository), authCache),
        ),
      ],
      child: SafeArea(
        child: MaterialApp(
          title: 'Amaze Chat',
          // Set initial route
          initialRoute: isOnboardingCompleted
              ? AppRoutes.loaderPage
              : AppRoutes.onboardingPage,
          debugShowCheckedModeBanner: false,

          // _haveToken == null
          //     ? AppRoutes.loaderPage
          //     :
          // _haveToken
          //     // == true
          //     ? AppRoutes.conversations
          //     : AppRoutes.login,
          // Use generateRoute for named routes
          onGenerateRoute: AppRoutes.generateRoute,
          // Set the navigator key here
          navigatorKey: navigatorKey,
          // theme: ThemeData().copyWith(brightness: appThemeMode.value),
        ),
      ),
    );
  }
}

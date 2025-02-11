import 'package:amazetalk_flutter/chat_page.dart';
import 'package:amazetalk_flutter/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:amazetalk_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:amazetalk_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:amazetalk_flutter/features/auth/domain/usecases/register_usecase.dart';
import 'package:amazetalk_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:amazetalk_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:amazetalk_flutter/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure Flutter is initialized

  // ✅ Correctly initialize Auth Dependencies
  final authRemoteDataSource = AuthRemoteDataSource();
  final authRepository =
      AuthRepositoryImpl(authRemoteDataSource: authRemoteDataSource);

  runApp(MyApp(authRepository: authRepository));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  const MyApp({super.key, required this.authRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => AuthBloc(
                registerUsecase: RegisterUsecase(repository: authRepository),
                loginUsecase: LoginUsecase(repository: authRepository)))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: RegisterPage(),
        routes: {
          "/login": (_) => LoginPage(),
          "/register": (_) => RegisterPage(),
          "/chatPage": (_) => ChatPage(),
        },
      ),
    );
  }
}

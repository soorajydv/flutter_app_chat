import 'package:amazetalk_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:amazetalk_flutter/features/auth/domain/usecases/register_usecase.dart';
import 'package:amazetalk_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:amazetalk_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUsecase registerUsecase;
  final LoginUsecase loginUsecase;
  final FlutterSecureStorage _storage =
      const FlutterSecureStorage(); // ✅ Correct initialization
  AuthBloc({required this.registerUsecase, required this.loginUsecase})
      : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await registerUsecase.call(
          event.username, event.email, event.password);
      emit(AuthSuccess(message: "Registration Successful"));
    } catch (e) {
      emit(AuthFailure(error: "Registration Failed")); // ✅ Fixed Typo
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUsecase.call(event.email, event.password);
      await _storage.write(key: 'token', value: user.token); // ✅ Correct
      emit(AuthSuccess(message: "Login Successful"));
    } catch (e) {
      emit(AuthFailure(error: "Login Failed")); // ✅ Fixed Typo
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:todo_app/database/firebase_auth.dart';
import 'dart:developer' as dev;

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService _authService = AuthService();

  LoginCubit() : super(LoginInitial());

  void login(String email, String password) async {
    dev.log("Cubit: Bắt đầu đăng nhập, emit Loading");
    emit(LoginLoading());
    try {
      dev.log("Cubit: Đang gọi Firebase...");
      await _authService.signInWithEmailAndPassword(
        email.trim(),
        password.trim(),
      );
      dev.log("Cubit: Firebase gọi thành công! emit Success");
      emit(LoginSuccess());
    } catch (e) {
      dev.log("Cubit: Đăng nhập lỗi: ${e.toString()}");
      emit(LoginFailure(e.toString()));
    }
  }
}

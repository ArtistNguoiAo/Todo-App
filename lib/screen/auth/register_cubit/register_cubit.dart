import 'package:bloc/bloc.dart';
import 'package:todo_app/utils/string_utils.dart';

import '../../../database/firebase_auth.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService _authService = AuthService();
  
  RegisterCubit() : super(RegisterInitial());
  
  void register(String email, String password, String confirmPassword) async{
    if(password != confirmPassword){
      emit(RegisterFailure(StringUtils.wrongConfirmPassword));
      return;
    }
    if(email.trim().isEmpty || password.trim().isEmpty){
      emit(RegisterFailure(StringUtils.emptyInfo));
      return;
    }
    emit(RegisterLoading());
    try{
      await _authService.registerWithEmailAndPassword(
        email.trim(),
        password.trim()
      );
      await _authService.signOut();
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
